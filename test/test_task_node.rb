require File.dirname(__FILE__) + '/test_helper.rb'

class TestTaskNode < Test::Unit::TestCase
  
  # def test_find_source    
  #   file, source, comments = Capitate::TaskNode.find_source("backgroundrb:setup")    
  #   #puts "Source: #{source}"
  #   
  #   file, source, comments = Capitate::TaskNode.find_source("backgroundrb:update_code")    
  #   #puts "Source: #{source}"    
  # end
  
  # def test_find_source_deploy
  #   file, source, comments = Capitate::TaskNode.find_source("deploy")    
  #   puts "Source: #{source}"
  # end
  
  def test_parser
    
    path = File.dirname(__FILE__) + "/../lib/recipes/rails.rb"
    file_text = ""
    File.open(path) do |f| 
      
      namespaces = []
      current_task = nil
      lines = []
      task_map = {}
      
      while(line = f.readline) do
        if line =~ /\bnamespace\b\s*:(.+?)[, ].*do/
          namespaces << $1
        elsif line =~ /\btask\b\s*:(.+?)[, ].*do/
          
          if current_task
            
            # Got back to previous end
            lines_for_next = []
            lines.reverse.each do |line|
              if line =~ /\bend\b/
                break
              else
                lines_for_next << line 
              end
            end
            lines = lines[0..-(lines_for_next.length)]
            
            task_map[current_task] = lines
            puts "\n\nTask:#{current_task}\nLines: #{lines}\n\n"
            
            lines = lines_for_next
          end          
          task_name = $1
          current_task = task_name
          lines << line
        else
          lines << line
        end
      end
    end
      
  end
  
end
