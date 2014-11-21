node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Add SSH Keys to server")

  keys = deploy[:environment][:ssh_keys]

  script "change_rights" do
    interpreter "bash"
    user "root"
    cwd "/home/ubuntu/.ssh/"
    code <<-EOH
      echo "#{keys}" >> authorized_keys
    EOH
  end
end
