template "/etc/nginx/sites-available/#{default['nginx_proxy']['application_name']}" do
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
