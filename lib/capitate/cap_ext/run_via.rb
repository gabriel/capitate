module Capitate::CapExt::RunVia
  
  # Invoke command with current run_method setting.
  #
  # ==== Options
  # +cmd+:: Command to run
  # +options+:: Options (see invoke_command options)
  #
  def run_via(cmd, options = {}, &block)    
    options[:via] = fetch(:run_method, :sudo) unless options.has_key?(:via)
    invoke_command(cmd, options, &block)
  end
  
end