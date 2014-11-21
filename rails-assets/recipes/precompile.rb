node[:deploy].each do |application, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'rails'
    rails_env    = deploy[:rails_env]
    current_path = deploy[:current_path]

    Chef::Log.info("Precompiling Rails assets with environment #{rails_env} and restart")

    execute 'rake assets:precompile' do
      cwd current_path
      user 'deploy'
      command "bundle exec rake assets:precompile && #{node[:opsworks][:rails_stack][:restart_command]}"
      environment 'RAILS_ENV' => rails_env
    end
  end
end
