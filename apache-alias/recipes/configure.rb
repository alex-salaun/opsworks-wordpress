template "/etc/apache2/sites-available/#{default['apache_alias']['application_name']}" do
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
