#
# Cookbook Name:: proftpd
# Recipe:: default
#
#

# Install proftpd package

ftp_user  = node[:proftpd][:user][:name]
ftp_group = node[:proftpd][:group][:name]

Chef::Log.debug("Install proftpd and create group and user")

packages "proftpd" do
  action :install
  options '--force-yes'
end

user node[:proftpd][:user][:name] do
  password node[:proftpd][:user][:password]
end

script "set_locale" do
  interpreter "bash"
  user "root"
  cwd "/"
  code <<-EOH
  groupadd #{ftp_group}
  adduser #{ftp_user} #{ftp_group}
  EOH
end

template "/etc/proftpd/proftpd.conf" do
  source "proftpd.erb"
end

# Restart proftpd
service "proftpd" do
  action :restart
end
