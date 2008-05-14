# Rails recipes
namespace :rails do
  
  desc "Make symlink for database yaml" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
  
  # Log tasks
  namespace :logs do 
    
    desc <<-DESC
    Tail production log files.
    
    "From errtheblog":http://errtheblog.com/posts/19-streaming-capistrano

    "Source":#{link_to_source(__FILE__)}
    DESC
    task :tail, :roles => :web do
      run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
        puts  # for an extra line break before the host name
        puts "#{channel[:host]}: #{data}" 
        break if stream == :err    
      end
    end


    desc <<-DESC
    Check production log files in TextMate.
    
    "From errtheblog":http://errtheblog.com/posts/19-streaming-capistrano

    "Source":#{link_to_source(__FILE__)}
    DESC
    task :mate, :roles => :app do

      require 'tempfile'
      tmp = Tempfile.open('w')
      logs = Hash.new { |h,k| h[k] = '' }

      run "tail -n500 #{shared_path}/log/production.log" do |channel, stream, data|
        logs[channel[:host]] << data
        break if stream == :err
      end

      logs.each do |host, log|
        tmp.write("--- #{host} ---\n\n")
        tmp.write(log + "\n")
      end

      exec "mate -w #{tmp.path}" 
      tmp.close
    end
  end

  desc <<-DESC
  Remotely console.
  
  "From errtheblog":http://errtheblog.com/posts/19-streaming-capistrano
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :console, :roles => :app do
    input = ''
    run "cd #{current_path} && ./script/console #{ENV['RAILS_ENV']}" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end
end
