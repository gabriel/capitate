require 'md5'

module Capitate::Plugins::Prompt

  # Prompt.
  #
  # ==== Options
  # :label<String>:: Label
  # :options<Hash>:: An options hash (see below)
  #
  def ask(label, options = {}, &block)
    Capistrano::CLI.ui.ask(label, &block)
  end
  
  # Prompt for password.
  #
  # ==== Options (options)
  # :label<String>:: Label
  # :options<Hash>:: An options hash (see below)
  #
  # ==== Password options
  # :verify<bool>:: If true, prompt twice and verify
  # :lazy<bool>:: If true, returns a Proc. _Defaults to true_
  # :check_hash<String>:: If present, checks that md5 is same as password md5
  # :max_attempts<Integer>:: Number of attempts to retry. _Defaults to 3_
  #
  def password(label, options = {})
    
    verify = options[:verify]
    lazy = options[:lazy].nil? ? true : options[:lazy]
    check_hash = options[:check_hash]
    max_attempts = options[:max_attempts] || 3
    
    # Lazy
    password_prompt = Proc.new { 
      
      attempts = 0
      password = nil
      success = true

      loop do
        password = Capistrano::CLI.password_prompt(label)
        attempts += 1
    
        if verify
          password_verify = Capistrano::CLI.password_prompt("[VERIFY] #{label}")
          if password != password_verify
            logger.important "Passwords do not match" 
            success = false
          end
        end
      
        if check_hash
          if MD5.md5(password).hexdigest != check_hash
            logger.important "Invalid password, try again." 
            success = false            
          end         
        end
        
        break if success
        break if attempts >= max_attempts
        
        # Reset success
        success = true
      end
      
      raise "Invalid password, too many tries" unless success
    
      password
    }
    
    return password_prompt if lazy
    password_prompt.call
  end  
  
  # Preview variables, and re-set them if asked to.
  # Uses highline menus. Is not very intelligent.
  #
  # ==== Options
  # :variables<Array>:: List of variables to show and verify
  # :header<String>:: Menu header
  # :prompt<String>:: Menu prompt
  #
  def preview_variables(variables, header = "Verify your settings", prompt = "Choose: ")
    hl = Capistrano::CLI.ui
    
    confirmed = false
    while not confirmed do 
      hl.choose do |menu|
        menu.header = header
        menu.prompt = prompt
        
        menu.choice("<Continue>") do
          confirmed = true
        end
        
        variables.each do |variable|
          menu.choice("#{variable}: #{fetch(variable)}") do
            new_setting = ask("Set #{variable}: ") { |q| q.default = fetch(variable) }
            set variable, new_setting
          end
        end        
      end
    end
  end
  
end

Capistrano.plugin :prompt, Capitate::Plugins::Prompt
