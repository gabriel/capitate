namespace :mongrel do

  namespace :cluster do 
  
    namespace :centos do
    
      desc <<-DESC
      Create mongrel cluster.
    
      *mongrel_size*: Number of mongrels.\n    
      @set :mongrel_size, 3@\n
      *mongrel_port*: Starting port for mongrels. If there are 3 mongrels with port 9000, 
      then instances will be at 9000, 9001, and 9002\n      
      @set :mongrel_port, 9000@\n      
      *mongrel_config_dir*: Directory for mongrel config. _Defaults to "[shared_path]/config/mongrel"_
      *mongrel_pid_dir*: Directory for mongrel pids. _Defaults to "[shared_path]/pids"
      *mongrel_config_script*: Config script to load with mongrel. _Defaults to nil_\n  
      @set :mongrel_config_script, "config/mongrel_handler.rb"@\n
      *mongrel_cluster_command*: Mongrel cluster command. _Defaults to mongrel_cluster_ctl_
      *mongrel_initscript_name*: Mongrel initscript name. _Defaults to mongrel_cluster_\#{application}_
      *mongrel_config_options*: Config options appended to cluster yml. _Defaults to <tt>{}</tt>_
      DESC
      task :setup do 

        # Settings
        fetch(:mongrel_size)
        fetch(:mongrel_port)
        fetch_or_default(:mongrel_config_dir, "#{shared_path}/config/mongrel")
        fetch_or_default(:mongrel_pid_dir, "#{shared_path}/pids")
        fetch_or_default(:mongrel_config_script, nil)
        
        fetch_or_default(:mongrel_cluster_command, "mongrel_cluster_ctl")
        fetch_or_default(:mongrel_initscript_name, "mongrel_cluster_#{application}")
        fetch_or_default(:mongrel_config_options, {})
        
        unless mongrel_config_script.blank?
          mongrel_config_options["config_script"] = mongrel_config_script
        end
      
        run "mkdir -p #{mongrel_config_dir}"

        put template.load("mongrel/mongrel_cluster.initd.erb"), "/tmp/#{mongrel_initscript_name}.initd"    
        put template.load("mongrel/mongrel_cluster.yml.erb"), "#{mongrel_config_dir}/mongrel_cluster.yml"

        # Setup the mongrel_cluster init script
        sudo "install -o root /tmp/#{mongrel_initscript_name}.initd /etc/init.d/#{mongrel_initscript_name}"

        sudo "/sbin/chkconfig --level 345 #{mongrel_initscript_name} on"
      end
    
    end
    
  end
  
end