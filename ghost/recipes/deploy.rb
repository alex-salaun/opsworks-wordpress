node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Start ghost server")

  if defined?(deploy[:application_type]) && deploy[:application_type] != 'static'
    Chef::Log.debug("Skipping ghost configure application #{app_name} as it is not defined as ghost blog")
    next
  end

  script "start_npm" do
    interpreter "bash"
    user "deploy"
    cwd "#{deploy[:deploy_to]}/current/"
    code <<-EOH
        npm start --production
    EOH
  end
end
