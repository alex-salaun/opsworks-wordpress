node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    Chef::Log.info("Start ghost server #{app_name}")

    script "start_npm" do
      interpreter "bash"
      user "deploy"
      cwd "#{deploy[:deploy_to]}/current/"
      code <<-EOH
          pm2 restart index
      EOH
    end
  end
end
