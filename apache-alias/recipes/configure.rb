Chef::Log.info("Configure apache alias")

node[:deploy].each do |app_name, deploy|
    Chef::Log.info("app_name : #{app_name.gsub('-', '_')}")

    template "/etc/apache2/sites-available/#{app_name.gsub('-', '_')}" do
        source "site.conf.erb"
        mode 0660
        group deploy[:group]

        if platform?("ubuntu")
          owner "www-data"
        elsif platform?("amazon")
          owner "apache"
        end

        Chef::Log.info("app name : #{app_name}")
        Chef::Log.info("app name : #{app_name.gsub('-', '_')}")
        Chef::Log.info("deploy : #{deploy}")

        variables(
            :app_name   => app_name.gsub('-', '_'),
            :domain     => (deploy[:domains].first),
            :ftp_user   => deploy[:environment][:ftp_user_name],
            :ftp_pass   => deploy[:environment][:ftp_user_password],
            :site_url   => deploy[:environment][:blog_siteurl]
        )
    end

    service "apache2" do
      action :reload
    end

    service "apache2" do
      action :restart
    end
end
