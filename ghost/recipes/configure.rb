node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    Chef::Log.info("Setup Ghost for #{app_name}")

    htaccess_username = node[:custom_nginx][:htaccess_username]
    htaccess_password = node[:custom_nginx][:htaccess_password]

    template "/etc/nginx/sites-available/#{app_name.gsub('-', '_')}" do
      source "site.erb"

      variables(
        :proxy_url  => deploy[:environment][:proxy_url],
        :app_name   => app_name.gsub('-', '_'),
        :domain     => (deploy[:domains].first)
      )
    end

    script "add_htpasswd" do
      interpreter "bash"
      user "root"
      cwd "/"
      code <<-EOH
      touch /etc/nginx/conf.d/htpasswd
      printf "#{htaccess_username}:$(openssl passwd -crypt #{htaccess_password})\n\" | tee /etc/nginx/conf.d/htpasswd
      EOH
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
        :database   => (deploy[:database][:database] rescue nil),
        :user       => (deploy[:database][:username] rescue nil),
        :password   => (deploy[:database][:password] rescue nil),
        :host       => (deploy[:database][:host] rescue nil),
        :domain     => (deploy[:domains].first)
      )
    end

    script "setup_ghost" do
      interpreter "bash"
      user "root"
      cwd "#{deploy[:deploy_to]}/current/"
      code <<-EOH
        npm cache clean
        npm install --production
        npm install pm2 -g
        pm2 start index.js
      EOH
    end
  end
end
