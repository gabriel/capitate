# Rails recipes
namespace :rails do
  
  desc <<-DESC
  Create database yaml in shared path. Note: If both @:db_host@ and @:db_socket@ are used, @db_socket@ wins.
  
  *DEPRECATED*: Use @active_record:setup@
  
  <dl>
  <dt>db_name</dt>
  <dd>Database name.</dd>  
  <dd>@set :db_name, "app_db_name"@</dd>
  
  <dt>db_user</dt>
  <dd>Database user.</dd>
  <dd>@set :db_user, "app_db_user"@</dd>    
  
  <dt>db_pass</dt>
  <dd>Database password.</dd>
  <dd>@set :db_pass, "the_password"@</dd>   
  
  <dt>db_host</dt>
  <dd>Database host (can be nil, if you are using socket).</dd>
  <dd class="default">Defaults to @nil@</dd>
  
  <dt>db_socket</dt>
  <dd>Database socket (can be nil, if you are using host).</dd>
  <dd class="default">Defaults to @nil@</dd>      
  <dd>@set :db_socket, "/var/lib/mysql/mysql.sock"@</dd>
  
  <dt>database_yml_template</dt>
  <dd>Path to database yml erb template.
  <dd class="default">Defaults to @rails/database.yml.erb@ (in this GEM)</dd>
  </dl>
  
  "Source":#{link_to_source(__FILE__)}
  DESC
  task :setup, :roles => :app do    
    
    # Settings
    fetch(:db_name)
    fetch(:db_user)
    fetch(:db_pass)
    fetch_or_default(:db_host, nil)
    fetch_or_default(:db_socket, nil)
    fetch_or_default(:database_yml_template, "rails/database.yml.erb")
    
    unless db_host.blank?
      set :db_connect_type, "host"
      set :db_connect, db_host
    end
    
    unless db_socket.blank?
      set :db_connect_type, "socket"
      set :db_connect, db_socket
    end
    
    run "mkdir -p #{shared_path}/config"
    put template.load(database_yml_template), "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml" 
  task :update_code do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
  
  # Log tasks
  namespace :logs do 
    
    desc <<-DESC
    Tail production log files.
    
    "From errtheblog":http://errtheblog.com/posts/19-streaming-capistrano

    "Source":#{link_to_source(__FILE__)}
    DESC
    task :tail, :roles => :web do
      run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
        puts  # for an extra line break before the host name
        puts "#{channel[:host]}: #{data}" 
        break if stream == :err    
      end
    end


    desc <<-DESC
    Check production log files in TextMate.
    
    "From errtheblog":http://errtheblog.com/posts/19-streaming-capistrano

    "Source":#{link_to_source(__FILE__)}
    DESC
    task :mate, :roles => :app do

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
  end

  desc <<-DESC
  Remotely console.
  
  "From errtheblog":http://errtheblog.com/posts/19-streaming-capistrano
  
  "Source":#{link_to_source(__FILE__)}
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
