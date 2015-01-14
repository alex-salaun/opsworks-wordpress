node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    Chef::Log.info("Setup Ghost for #{app_name}")

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

    script "setup_ghost" do
      interpreter "bash"
      user "deploy"
      cwd "#{deploy[:deploy_to]}/current/"
      code <<-EOH
        npm install --production
      EOH
    end
  end
end
