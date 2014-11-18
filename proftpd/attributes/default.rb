# Default configuration for the AWS OpsWorks cookbook for proftpd
#

layer               = node[:opsworks][:instance][:layers].first
Chef::Log.info("layer : #{layer}")
instance            = node[:opsworks][:layers].fetch(layer)[:instances].first[1]
Chef::Log.info("instance : #{instance}")
instance_dns_name   = instance[:public_dns_name]
Chef::Log.info("instance_dns_name : #{instance_dns_name}")
instance_elastic_ip = instance[:elastic_ip]
Chef::Log.info("instance_elastic_ip : #{instance_elastic_ip}")
application_name    = node[:opsworks][:applications][0][:name]
Chef::Log.info("application_name : #{application_name}")
password            = deploy[application_name.to_sym][:environment][:ftp_user_password]
Chef::Log.info("password : #{password}")

default[:proftpd] = {
  :user => {
    :name => "ftpuser",
    :password => password
  },
  :group => {
    :name => "ftpgroup"
  },
  :folder_path => "/srv/www/blog_staging",
  :passive_ports => "1024 1048",
  :elastic_ip => instance_elastic_ip,
  :server_name => instance_dns_name
}
