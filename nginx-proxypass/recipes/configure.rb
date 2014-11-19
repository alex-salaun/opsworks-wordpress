app_name = default['nginx_proxy']['application_name']

Chef::Log.info("app_name : #{app_name}")
Chef::Log.info("Configure Nginx Proxy Pass")

template "/etc/nginx/sites-available/#{app_name}" do
    source "site.erb"
    mode 0660
    group deploy[:group]
end

service "nginx" do
  action :reload
end

service "nginx" do
  action :restart
end
