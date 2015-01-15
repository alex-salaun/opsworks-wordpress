node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    Chef::Log.info("Start ghost server #{app_name}")

    template "#{deploy[:deploy_to]}/current/config.js" do
      source "config.js.erb"
      group deploy[:group]

      if platform?("ubuntu")
        owner "www-data"
      elsif platform?("amazon")
        owner "apache"
      end

      variables(
        :database   => (deploy[:database][:database] rescue nil),
        :user       => (deploy[:database][:username] rescue nil),
        :password   => (deploy[:database][:password] rescue nil),
        :host       => (deploy[:database][:host] rescue nil),
        :domain     => (deploy[:domains].first)
      )
    end

    script "start_npm" do
      interpreter "bash"
      user "root"
      cwd "#{deploy[:deploy_to]}/current/"
      code <<-EOH
          pm2 restart ghost
      EOH
    end
  end
end
