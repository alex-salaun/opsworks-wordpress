Chef::Log.info("Configure Nginx Proxy Pass")

node[:deploy].each do |app_name, deploy|
  Chef::Log.info("app_name : #{app_name.gsub('-', '_')}")

  template "/etc/nginx/sites-available/#{app_name.gsub('-', '_')}" do
      source "site.erb"
      mode 0660
      group deploy[:group]

      if platform?("ubuntu")
        owner "www-data"
      elsif platform?("amazon")
        owner "apache"
      end

      variables(
          :proxy_url  => deploy[app_name.gsub('-', '_').to_sym][:environment][:proxy_url],
          :app_name   => app_name.gsub('-', '_'),
          :domain     => (deploy[:domains].first)
      )
  end

  service "nginx" do
    action :reload
  end

  service "nginx" do
    action :restart
  end
end
