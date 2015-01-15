Chef::Log.info("Set nginx attributes")

my_ip = '10.0.0.0/8'

application_name = node[:opsworks][:applications].each do |application|
  Chef::Log.info("Application : #{application.inspect}")
  Chef::Log.info("Deploy : #{deploy.inspect}")

  application_name = application[:name].gsub('-', '_')
  unless deploy[application_name.to_sym][:environment][:my_ip].blank?
    my_ip = deploy[application_name.to_sym][:environment][:my_ip]
  end
end

default['nginx_custom_ip']['my_ip'] = my_ip
