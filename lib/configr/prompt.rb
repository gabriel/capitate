# For getting user input
module Configr::Prompt
  
  def prompt_with_default(message, default = nil, auto = false)
    return default if auto && !default.blank?
    prompt(message, nil, nil, default, true)
  end
  
  def prompt_with_example(message, example, default = nil, auto = false)
    return default if auto && !default.blank?
    prompt(message, nil, example, default, true)
  end
  
  def prompt(message, choices = nil, example = nil, default = nil, check_input = false)    
    printf("#{message}")
    printf(" (ex. #{example})") if example
    if !choices.blank?
      printf(" [#{choices}]") 
    elsif !default.blank?
      printf(" [#{default}]") 
    end
    printf(": ")
    STDOUT.flush
    
    input = STDIN.gets.chomp!    
    input = default if input.blank?
      
    if check_input && input.blank?
      puts "Invalid input\n"
      return prompt(message, default, example)
    end
    input
  end
  
  # Returns true for yes, false for no
  def prompt_yes_no(message, default = true)
    choices = default ? "Y/n" : "y/N"
    default_val = default ? "Y" : "N"
    input = prompt(message, choices, nil, default_val, true)
    return true if input =~ /y|yes|ok/i
    false
  end
  
end