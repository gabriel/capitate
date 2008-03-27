namespace :database do
  
  namespace :monit do
    
    desc "Restart database (monit group)"
    task :restart do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} -g database restart all"
    end
    
    desc "Start database (monit group)"
    task :start do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} -g database start all" 
    end
    
    desc "Stop database (monit group)"
    task :stop do
      fetch_or_default(:monit_bin_path, "monit")
      sudo "#{monit_bin_path} -g database stop all"
    end
    
  end
  
end