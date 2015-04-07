node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    Chef::Log.info("Setup Ghost for #{app_name}")

    htaccess_username = node[:custom_nginx][:htaccess_username]
    htaccess_password = node[:custom_nginx][:htaccess_password]

    template "/etc/nginx/sites-available/#{app_name.gsub('-', '_')}" do
      source "site.erb"

      variables(
        :app_name   => app_name.gsub('-', '_')
      )
    end

    service "nginx" do
      action :reload
    end

    service "nginx" do
      action :restart
    end

    template "#{deploy[:deploy_to]}/current/config.js" do
      source "config.js.erb"
      group deploy[:group]

      if platform?("ubuntu")
        owner "www-data"
      elsif platform?("amazon")
        owner "apache"
      end

      variables(
        :database         => (deploy[:database][:database] rescue nil),
        :user             => (deploy[:database][:username] rescue nil),
        :password         => (deploy[:database][:password] rescue nil),
        :host             => (deploy[:database][:host] rescue nil),
        :domain           => (deploy[:domains].first),
        :s3_access_id     => (deploy[:s3][:access_id] rescue nil),
        :s3_access_secret => (deploy[:s3][:access_secret] rescue nil),
        :s3_bucket        => (deploy[:s3][:bucket] rescue nil),
        :s3_region        => (deploy[:s3][:region] rescue nil)
      )
    end

    script "setup_ghost" do
      interpreter "bash"
      user "root"
      cwd "#{deploy[:deploy_to]}/current/"
      code <<-EOH
        npm cache clean
        npm install --production
        echo "export NODE_ENV=production" >> ~/.profile
        source ~/.profile
        nohup npm start --production > /dev/null 2>&1 &
      EOH
    end
  end
end
