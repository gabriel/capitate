require 'md5'

module Capitate::Plugins::Prompt

  # Prompt.
  #
  # ==== Options
  # +label+:: Label
  # +options+:: Options (none yet)
  #
  def ask(label, options = {}, &block)
    Capistrano::CLI.ui.ask(label, &block)
  end
  
  # Prompt for password.
  #
  # ==== Options
  # +label+:: Label
  # +options+:: Options (see Password options)
  #
  # ==== Password options
  # +verify+:: If true, prompt twice and verify
  # +lazy+:: If true, returns a Proc. _Defaults to true_
  # +check_hash+:: If present, checks that md5 is same as password md5
  # +max_attempts+:: Number of attempts to retry. _Defaults to 3_
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
  
end

Capistrano.plugin :prompt, Capitate::Plugins::Prompt
