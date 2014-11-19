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

        variables(
            :app_name   => app_name.gsub('-', '_'),
            :domain     => (deploy[:domains].first),
            :ftp_user   => deploy[app_name.gsub('-', '_').to_sym][:environment][:ftp_user_name],
            :ftp_pass   => deploy[app_name.gsub('-', '_').to_sym][:environment][:ftp_user_password],
            :site_url   => deploy[app_name.gsub('-', '_').to_sym][:environment][:blog_siteurl]
        )
    end

    service "apache2" do
      action :reload
    end

    service "apache2" do
      action :restart
    end
end
