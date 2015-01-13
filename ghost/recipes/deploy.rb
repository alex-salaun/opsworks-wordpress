node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Start ghost server")

  script "start_npm" do
    interpreter "bash"
    user "deploy"
    cwd "#{deploy[:deploy_to]}/current/"
    code <<-EOH
        npm start --production
    EOH
  end
end
