node[:deploy].each do |app_name, deploy|
  Chef::Log.info("Add SSH Keys to server")

  Chef::Log.info("ssh : #{node[:ssh]}")
  keys = node[:ssh][:keys]

  script "change_rights" do
    interpreter "bash"
    user "root"
    cwd "/home/ubuntu/.ssh/"
    code <<-EOH
      printf "#{keys}" >> authorized_keys
    EOH
  end
end
