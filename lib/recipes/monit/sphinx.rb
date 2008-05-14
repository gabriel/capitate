namespace :sphinx do
  
  namespace :monit do
  
    desc <<-DESC
    Create monit configuration for sphinx.\n  

    "Source":#{link_to_source(__FILE__)}
    DESC
    task_arg(:monit_conf_dir, :default => "/etc/monit")
    task_arg(:sphinx_pid_path, :default => Proc.new{"#{shared_path}/pids/searchd.pid"}, :default_desc => "\#{shared_path}/pids/searchd.pid")
    task :setup do    
      put template.load("sphinx/sphinx.monitrc.erb"), "/tmp/sphinx_#{application}.monitrc"            
      sudo "install -o root /tmp/sphinx_#{application}.monitrc #{monit_conf_dir}/sphinx_#{application}.monitrc"
    end
  
    desc "Restart sphinx application (through monit)"
    task :restart do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} restart sphinx_#{application}"
    end
    
    desc "Start sphinx application (through monit)"
    task :start do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} start sphinx_#{application}"
    end
    
    desc "Stop sphinx application (through monit)"
    task :stop do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} stop sphinx_#{application}"
    end
    
    
  end
    
end