namespace :gems do
  
  desc "Install gems"
  task :install do
    gem_install(gem_list) if gem_list
  end
  
end