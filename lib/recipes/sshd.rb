namespace :sshd do
  
  desc <<-DESC
  Create public and private keys for ssh.
      
  *ssh_keygen_type*: SSH keygen type. _Defaults to rsa_\n
  *ssh_keygen_bits*: SSH keygen bits. _Defaults to 2048_\n  
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :keygen do
    # Settings 
    fetch_or_default(:ssh_keygen_type, "rsa")   
    fetch_or_default(:ssh_keygen_bits, 2048)      
    
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
  Add to authorized keys. Uses <tt>.ssh/authorized_keys</tt>.
  
  *ssh_public_key*: The public key from ssh:keygen.
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :authorize_key do
    
    fetch(:ssh_public_key)
    
    ssh_dir = "~/.ssh"
    authorized_keys_path = "#{ssh_dir}/authorized_keys"
    
    run_all <<-CMDS    
      if [ ! -d #{ssh_dir} ]; then mkdir #{ssh_dir} ; chmod 700 #{ssh_dir} ; fi 
      if [ ! -f #{authorized_keys_path} ]; then touch #{authorized_keys_path} ; chmod 600 #{authorized_keys_path} ; fi 
      echo "#{ssh_public_key}" >> #{authorized_keys_path}
    CMDS
  end
  
end