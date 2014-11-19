application_name = node[:opsworks][:applications][0][:name].gsub('-', '_')
proxy_url        = deploy[application_name.to_sym][:environment][:proxy_url]

default[:nginx_proxy][:application_name] = application_name
default[:nginx_proxy][:proxy_url]        = proxy_url
