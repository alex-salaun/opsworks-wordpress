Chef::Log.info("Configure Nginx Proxy Pass")

node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'rails'
    Chef::Log.info("Update conf file : /etc/nginx/sites-available/#{app_name.gsub('-', '_')}")

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
  end
end
