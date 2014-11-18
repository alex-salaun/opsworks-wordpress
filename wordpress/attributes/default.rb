# Default configuration for the AWS OpsWorks cookbook for Wordpress
#

Chef::Log.info("Set wordpress attributes")

layer               = node[:opsworks][:instance][:layers].first
instance            = node[:opsworks][:layers].fetch(layer)[:instances].first[1]
instance_elastic_ip = instance[:elastic_ip]
application_name    = node[:opsworks][:applications][0][:name].gsub('-', '_')
password            = deploy[application_name.to_sym][:environment][:ftp_user_password]

default['wordpress']['wp_config']['ftp_host'] = instance_elastic_ip
default['wordpress']['wp_config']['ftp_user'] = "ftpuser"
default['wordpress']['wp_config']['ftp_pass'] = password

# Enable the Wordpress W3 Total Cache plugin (http://wordpress.org/plugins/w3-total-cache/)?
default['wordpress']['wp_config']['enable_W3TC'] = false

# Force logins via https (http://codex.wordpress.org/Administration_Over_SSL#To_Force_SSL_Logins_and_SSL_Admin_Access)
default['wordpress']['wp_config']['force_secure_logins'] = false
