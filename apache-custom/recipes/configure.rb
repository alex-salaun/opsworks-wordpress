Chef::Log.info("Configure apache alias")

node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'php'
    Chef::Log.info("Update conf file : /etc/apache2/sites-available/#{app_name.gsub('-', '_')}.conf")

    template "/etc/apache2/sites-available/#{app_name.gsub('-', '_')}.conf" do
      source "site.erb"

      variables(
        :app_name   => app_name.gsub('-', '_'),
        :domain     => (deploy[:domains].first),
        :ftp_user   => deploy[:environment][:ftp_user_name],
        :ftp_pass   => deploy[:environment][:ftp_user_password]
      )
    end

    service "apache2" do
      action :reload
    end

    service "apache2" do
      action :restart
    end
  end
end
