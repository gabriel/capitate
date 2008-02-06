namespace :gems do
  
  desc "Install gems"
  task :install do
    gem_install(gems) if gems
  end
  
end