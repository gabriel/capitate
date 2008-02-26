# Rails recipes
namespace :rails do
  
  desc <<-DESC
  Create database yaml in shared path.
  
  *db_name*: Database name (rails).\n    
  @set :db_name, "app_db_name"@\n  
  *db_user*: Database user (rails).\n  
  @set :db_user, "app_db_user"@\n    
  *db_pass*: Database password (rails).\n  
  @set :db_pass, "the_password"@\n    
  *db_host*: Database host (can be nil, if you are using socket). _Defaults to nil_\n
  *db_socket*: Database socket (can be nil, if you are using host). _Defaults to nil_\n
  @set :db_socket, "/var/lib/mysql/mysql.sock"@\n
  DESC
  task :setup do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    fetch_or_default(:db_host, nil)
    fetch_or_default(:db_socket, nil)
    
    run "mkdir -p #{shared_path}/config"
    put template.load("rails/database.yml.erb"), "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
  
  desc <<-DESC
  Tail production log files. (http://errtheblog.com/posts/19-streaming-capistrano)
  DESC
  task :tail_logs, :roles => :web do
    run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}" 
      break if stream == :err    
    end
  end


  desc <<-DESC
  Check production log files in TextMate.  (http://errtheblog.com/posts/19-streaming-capistrano)
  DESC
  task :mate_logs, :roles => :app do

    require 'tempfile'
    tmp = Tempfile.open('w')
    logs = Hash.new { |h,k| h[k] = '' }

    run "tail -n500 #{shared_path}/log/production.log" do |channel, stream, data|
      logs[channel[:host]] << data
      break if stream == :err
    end

    logs.each do |host, log|
      tmp.write("--- #{host} ---\n\n")
      tmp.write(log + "\n")
    end

    exec "mate -w #{tmp.path}" 
    tmp.close
  end

  desc <<-DESC
  Remotely console. (http://errtheblog.com/posts/19-streaming-capistrano)
  DESC
  task :console, :roles => :app do
    input = ''
    run "cd #{current_path} && ./script/console #{ENV['RAILS_ENV']}" do |channel, stream, data|
      next if data.chomp == input.chomp || data.chomp == ''
      print data
      channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
    end
  end
end
