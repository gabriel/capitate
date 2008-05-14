namespace :mongrel do

  namespace :cluster do 
  
    namespace :centos do
    
      desc <<-DESC
      Create mongrel cluster.
      
      "Source":#{link_to_source(__FILE__)}
      DESC
      
      task_arg(:mongrel_application, "Name of mongrel application")
      task_arg(:mongrel_size, "Number of mongrels")
      task_arg(:mongrel_port, "Starting port for mongrels. If there are 3 mongrels with port 9000, then instances will be at 9000, 9001, and 9002")
      task_arg(:mongrel_config_dir, "Directory for mongrel config", :default => Proc.new{"#{shared_path}/config/mongrel"}, :default_desc => "\#{shared_path}/config/mongrel")
      task_arg(:mongrel_pid_dir, "Directory for mongrel pids", :default => Proc.new{"#{shared_path}/pids"}, :default_desc => "\#{shared_path}/pids")
      task_arg(:mongrel_config_script, "Config script to load with mongrel", :default => nil)
      
      task_arg(:mongrel_cluster_command, "Mongrel cluster command", :default => "mongrel_cluster_ctl")
      task_arg(:mongrel_initscript_name, "Mongrel initscript name", :default => Proc.new{"mongrel_cluster_#{application}"}, :default_desc => "mongrel_cluster_\#{application}")
      task_arg(:mongrel_config_options, "Config options appended to cluster yml", :default => {})
      
      task :setup do 
        
        unless mongrel_config_script.blank?
          mongrel_config_options["config_script"] = mongrel_config_script
        end
      
        run "mkdir -p #{mongrel_config_dir}"
        
        set :mongrel_pid_path, "#{mongrel_pid_dir}/#{mongrel_application}.pid"
        set :mongrel_log_path, "log/#{mongrel_application}.log"
            
        put template.load("mongrel/mongrel_cluster.yml.erb"), "#{mongrel_config_dir}/mongrel_cluster.yml"

        initscript
      end    
    
      desc "Mongrel cluster setup initscript for application"
      task_arg(:mongrel_config_dir, "Directory for mongrel config", :default => Proc.new{"#{shared_path}/config/mongrel"}, :default_desc => "\#{shared_path}/config/mongrel")
      task_arg(:mongrel_pid_dir, "Directory for mongrel pids", :default => Proc.new{"#{shared_path}/pids"}, :default_desc => "\#{shared_path}/pids")
      task_arg(:mongrel_cluster_command, "Mongrel cluster command", :default => "mongrel_cluster_ctl")
      task_arg(:mongrel_initscript_name, "Mongrel initscript name", :default => Proc.new{"mongrel_cluster_#{application}"}, :default_desc => "mongrel_cluster_\#{application}")
      task :initscript do
        utils.install_template("mongrel/mongrel_cluster.initd.centos.erb", "/etc/init.d/#{mongrel_initscript_name}")
        run_via "/sbin/chkconfig --level 345 #{mongrel_initscript_name} on"
      end
      
    end
    
  end
  
end