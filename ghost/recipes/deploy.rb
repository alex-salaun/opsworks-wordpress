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
        :database         => (deploy[:database][:database] rescue nil),
        :user             => (deploy[:database][:username] rescue nil),
        :password         => (deploy[:database][:password] rescue nil),
        :host             => (deploy[:database][:host] rescue nil),
        :domain           => (deploy[:domains].first),
        :s3_access_id     => (node[:s3][:access_id] rescue nil),
        :s3_access_secret => (node[:s3][:access_secret] rescue nil),
        :s3_bucket        => (node[:s3][:bucket] rescue nil),
        :s3_region        => (node[:s3][:region] rescue nil)
      )
    end

    script "start_npm" do
      interpreter "bash"
      user "root"
      cwd "#{deploy[:deploy_to]}/current/"
      code <<-EOH
          killall node
          npm install --production
          ln -s #{deploy[:deploy_to]}/current/content/themes /srv/www/content/themes
          nohup npm start --production > /dev/null 2>&1 &
      EOH
    end
  end
end
