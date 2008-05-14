namespace :sshd do
  
  desc <<-DESC
  Create public and private keys for ssh.
      
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:ssh_keygen_type, "SSH keygen type", :default => "rsa")   
  task_arg(:ssh_keygen_bits, "SSH keygen bits", :default => 2048)
  task :keygen do
    
    run "ssh-keygen -t #{ssh_keygen_type} -b #{ssh_keygen_bits}" do |channel, stream, data|
      logger.trace data
      
      if data =~ /^Overwrite (y\/n)?/        
        channel.send_data "n\n"
        logger.important "This key already exists! Aborting."
      
      # Use default for file and empty password
      elsif data =~ /^Enter file/ or
        data =~ /^Enter passphrase/ or
        data =~ /^Enter same passphrase again/
        
        channel.send_data "\n"
        
      end
    end
    
  end
  
  desc <<-DESC
  Add to authorized keys. Uses @.ssh/authorized_keys@.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task_arg(:ssh_public_key, "The public key from sshd:keygen")
  task_arg(:ssh_dir, "SSH home directory", :default => "~/.ssh")
  task_arg(:authorized_keys_path, "Path to authorized keys", :default => "~/.ssh/authorized_keys")
  task :authorize_key do
    run_all <<-CMDS    
      if [ ! -d #{ssh_dir} ]; then mkdir #{ssh_dir} ; chmod 700 #{ssh_dir} ; fi 
      if [ ! -f #{authorized_keys_path} ]; then touch #{authorized_keys_path} ; chmod 600 #{authorized_keys_path} ; fi 
      echo "#{ssh_public_key}" >> #{authorized_keys_path}
    CMDS
  end
  
end