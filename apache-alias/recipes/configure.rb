app_name = default['apache_alias']['application_name']

Chef::Log.info("app_name : #{app_name}")
Chef::Log.info("Configure apache alias")

template "/etc/apache2/sites-available/#{app_name}" do
    source "site.conf.erb"
    mode 0660
    group deploy[:group]
end

service "apache2" do
  action :reload
end

service "apache2" do
  action :restart
end
