# Load recipes
# This is only loadable from within Capistrano
recipes = Dir[File.dirname(__FILE__) + "/../recipes/**/*.rb"].collect { |recipe| File.expand_path(recipe) }
recipes.each do |recipe|
  Capistrano::Configuration.instance.load recipe
end

# Reset the password var
Capistrano::Configuration.instance.load(:string => "reset_password")