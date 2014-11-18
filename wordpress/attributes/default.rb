# Default configuration for the AWS OpsWorks cookbook for Wordpress
#

Chef::Log.info("Set wordpress attributes")

layer               = node[:opsworks][:instance][:layers].first
Chef::Log.info("Layer : #{layer}")
instance            = node[:opsworks][:layers].fetch(layer)[:instances].first[1]
Chef::Log.info("Instance : #{instance}")
instance_elastic_ip = instance[:elastic_ip]
Chef::Log.info("Instance_elastic_ip : #{instance_elastic_ip}")
application_name    = node[:opsworks][:applications][0][:name]
Chef::Log.info("application_name : #{application_name}")
Chef::Log.info("deploy attributes : #{deploy}")
Chef::Log.info("deploy attributes app : #{deploy[application_name.to_sym]}")
Chef::Log.info("deploy attributes app 2 : #{deploy[application_name]}")
password            = deploy[application_name.to_sym][:environment][:ftp_user_password]
Chef::Log.info("password : #{password}")

default['wordpress']['wp_config']['ftp_host'] = instance_elastic_ip
default['wordpress']['wp_config']['ftp_user'] = "ftpuser"
default['wordpress']['wp_config']['ftp_pass'] = password

# Enable the Wordpress W3 Total Cache plugin (http://wordpress.org/plugins/w3-total-cache/)?
default['wordpress']['wp_config']['enable_W3TC'] = false

# Force logins via https (http://codex.wordpress.org/Administration_Over_SSL#To_Force_SSL_Logins_and_SSL_Admin_Access)
default['wordpress']['wp_config']['force_secure_logins'] = false
