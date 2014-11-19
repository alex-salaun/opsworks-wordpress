# Default configuration for the AWS OpsWorks cookbook for Wordpress
#

Chef::Log.info("Set apache attributes")

application_name = node[:opsworks][:applications][0][:name].gsub('-', '_')
site_url         = deploy[application_name.to_sym][:environment][:blog_siteurl]
user_name        = deploy[application_name.to_sym][:environment][:ftp_user_name]
password         = deploy[application_name.to_sym][:environment][:ftp_user_password]

default['apache_alias']['application_name'] = application_name
default['apache_alias']['siteurl']          = site_url
default['apache_alias']['ftp_user_name']    = user_name
default['apache_alias']['ftp_password']     = password

Chef::Log.info("apache alias : #{default['apache_alias']}")
