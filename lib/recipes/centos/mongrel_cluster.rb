namespace :mongrel do

  namespace :cluster do 
  
    namespace :centos do
    
      desc <<-DESC
      Create mongrel cluster.
      
      <dl>
      <dt>mongrel_size</dt><dd>Number of mongrels</dd>
      <dd>@set :mongrel_size, 3@</dd>
      
      <dt>mongrel_port</dt><dd>Starting port for mongrels. If there are 3 mongrels with port 9000, 
      then instances will be at 9000, 9001, and 9002</dd>      
      <dd>@set :mongrel_port, 9000@</dd>
      
      <dt>mongrel_config_dir</dt>
      <dd>Directory for mongrel config.</dd>
      <dd class="default">Defaults to @\#{shared_path}/config/mongrel@</dd>
      
      <dt>mongrel_pid_dir</dt><dd>Directory for mongrel pids</dd> 
      <dd class="default">Defaults to @\#{shared_path}/pids@</dd>
      
      <dt>mongrel_config_script</dt><dd>Config script to load with mongrel</dd> 
      <dd class="default">Defaults to @nil@</dd>
      <dd>@set :mongrel_config_script, "config/mongrel_handler.rb"@</dd>
      
      <dt>mongrel_cluster_command</dt>
      <dd>Mongrel cluster command.</dd>
      <dd class="default">Defaults to @mongrel_cluster_ctl@</dd>
      
      <dt>mongrel_initscript_name</dt><dd>Mongrel initscript name.</dd> 
      <dd class="default">Defaults to @mongrel_cluster_\#{application}@</dd>
      
      <dt>mongrel_config_options</dt>
      <dd>Config options appended to cluster yml.</dd>
      <dd class="default">Defaults to @{}@</dd>
      
      </dl>
      "Source":#{link_to_source(__FILE__)}
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
        
        set :mongrel_pid_path, "#{mongrel_pid_dir}/#{mongrel_application}.pid"
        set :mongrel_log_path, "log/#{mongrel_application}.log"

        put template.load("mongrel/mongrel_cluster.initd.erb"), "/tmp/#{mongrel_initscript_name}.initd"    
        put template.load("mongrel/mongrel_cluster.yml.erb"), "#{mongrel_config_dir}/mongrel_cluster.yml"

        # Setup the mongrel_cluster init script
        sudo "install -o root /tmp/#{mongrel_initscript_name}.initd /etc/init.d/#{mongrel_initscript_name}"

        sudo "/sbin/chkconfig --level 345 #{mongrel_initscript_name} on"
      end
    
    end
    
  end
  
end