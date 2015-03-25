# Default configuration for the AWS OpsWorks cookbook for proftpd
#

layer               = node[:opsworks][:instance][:layers].first
instance            = node[:opsworks][:layers].fetch(layer)[:instances].first[1]
instance_dns_name   = instance[:public_dns_name]
instance_elastic_ip = instance[:elastic_ip]
application_name    = node[:opsworks][:applications][0][:name].gsub('-', '_')
user_name           = deploy[application_name.to_sym][:environment][:ftp_user_name]
password            = deploy[application_name.to_sym][:environment][:ftp_user_password]


default[:proftpd] = {
  :user => {
    :name => user_name,
    :password => password
  },
  :group => {
    :name => "ftpgroup"
  },
  :folder_path => "/srv/www/blog_production",
  :passive_ports => "1024 1048",
  :elastic_ip => instance_elastic_ip,
  :server_name => instance_dns_name
}
