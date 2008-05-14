namespace :merb do
  
  desc <<-DESC
    Run the migrate rake task. By default, it runs this in most recently \
    deployed version of the app. However, you can specify a different release \
    via the migrate_target variable, which must be one of :latest (for the \
    default behavior), or :current (for the release indicated by the \
    `current' symlink). Strings will work for those values instead of symbols, \
    too. You can also specify additional environment variables to pass to rake \
    via the migrate_env variable. Finally, you can specify the full path to the \
    rake executable by setting the rake variable. The defaults are:

      set :rake,           "rake"
      set :merb_env,      "production"
      set :migrate_env,    ""
      set :migrate_target, :latest
  DESC
  task_arg(:rake, "Path to rake", :default => "rake")
  task_arg(:merb_env, "Merb environment", :default => "")
  task_arg(:migrate_target, "Migration target", :default => :latest)
  task :migrate, :roles => :db, :only => { :primary => true } do

    current_directory = case migrate_target.to_sym
      when :current then current_path
      when :latest  then current_release
      else raise ArgumentError, "unknown migration target #{migrate_target.inspect}"
      end

    run "cd #{current_directory}; #{rake} MERB_ENV=#{merb_env} #{migrate_env} db:migrate"
  end
  
end