node[:deploy].each do |app_name, deploy|
  if defined?(deploy[:application_type]) && deploy[:application_type] == 'static'
    Chef::Log.info("Setup ghost")

    script "start_npm" do
      interpreter "bash"
      user "root"
      cwd "/srv/www/"
      code <<-EOH
          mkdir content
          mkdir content/apps
          mkdir content/data
          mkdir content/images
          chown -R deploy:www-data content
      EOH
    end
  end
end
