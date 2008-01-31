# Gem recipes, you should freeze your gems, but these are for gems with native dependencies that need to be installed
namespace :gems do
  
  task :raspell do
    gem_install([ "raspell" ])
  end
  
end
    