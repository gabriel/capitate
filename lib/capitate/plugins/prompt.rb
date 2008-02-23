
module Capitate::Plugins::Prompt
  
  def ask(label, &block)
    Capistrano::CLI.ui.ask(label, &block)
  end
  
  def password(label, verify = false)
    
    password = Capistrano::CLI.password_prompt(label)
    
    if verify
      password_verify = Capistrano::CLI.password_prompt(label)
      raise "Passwords do not match" if password != password_verify
    end
    
    password
  end
  
end

Capistrano.plugin :prompt, Capitate::Plugins::Prompt
