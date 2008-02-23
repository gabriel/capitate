module Capitate::CapExt::RunVia
  
  # Invoke command with current run_method
  def run_via(command)
     via = fetch(:run_method, :sudo)
     invoke_command command, :via => via
   end
  
end