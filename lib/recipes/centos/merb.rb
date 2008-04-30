namespace :merb do
  namespace :centos do
    
    desc <<-DESC
    Setup merb.
      
    <dl>
    <dt>merb_command_path</dt>
    <dd>The path for merb startup command</dd>
    <dd class="default">Defaults to @merb@</dd>
    
    <dt>merb_nodes</dt>
    <dd>Number of merb daemons to run</dd>
    <dd>@set :merb_nodes, 3@</dd>
    
    <dt>merb_port</dt>
    <dd>Starting port for merb nodes. If there are 3 merb nodes with port 9000, 
    then instances will be at 9000, 9001, and 9002</dd>
    <dd>@set :merb_port, 9000@</dd>
    
    <dt>merb_root</dt>
    <dd>Directory for merb root</dd>
    <dd class="default">Defaults to @\#{current_path}@</dd>
    
    <dt>merb_pid_path</dt>
    <dd>Path for merb pids</dd> 
    <dd class="default">Defaults to @\#{shared_path}/pids/merb.pid@</dd>      
    </dl>
    "Source":#{link_to_source(__FILE__)}
    DESC
    task :setup do 

      # Settings
      fetch(:merb_nodes)
      fetch(:merb_port)
      fetch_or_default(:merb_command_path, "merb")
      fetch_or_default(:merb_pid_path, "#{shared_path}/pids/merb.pid")
      fetch_or_default(:merb_root, current_path)
      fetch_or_default(:merb_application, "merb_#{application}")
      
      fetch_or_default(:merb_initscript_name, "merb_#{application}")

      utils.install_template("merb/merb.initd.centos.erb", "/etc/init.d/#{merb_initscript_name}")
      run_via "/sbin/chkconfig --level 345 #{merb_initscript_name} on"
    end
    
  end
  
end