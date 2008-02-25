
module Capitate::Plugins::Prompt
  
  def ask(label, &block)
    Capistrano::CLI.ui.ask(label, &block)
  end
  
  def password(label, verify = false, lazy = true)
    # Lazy
    password_prompt = Proc.new { 
      password = Capistrano::CLI.password_prompt(label)
    
      if verify
        password_verify = Capistrano::CLI.password_prompt("[VERIFY] #{label}")
        raise "Passwords do not match" if password != password_verify
      end
    
      password
    }
    
    return password_prompt if lazy
    password_prompt.call
  end
  
end

Capistrano.plugin :prompt, Capitate::Plugins::Prompt
