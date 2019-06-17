app = search(:aws_opsworks_app).first
app_path = "/var/www/#{app['shortname']}"
case node[:platform]
when 'ubuntu', 'debian'
  app_user = node['deb_app_user']
  app_group = node['deb_app_group']
else
  app_user = node['rpm_app_user']
  app_group = node['rpm_app_group']
end


file "/home/#{app_user}/git_id_rsa" do
  owner app_user
  group app_group
  mode "0700"
  content app["app_source"]["ssh_key"]
end

file "/home/#{app_user}/.ssh/config" do
  owner app_user
  group app_group
  mode "0644"
  content "Host #{node['repository_host']}
HostName #{node['repository_host']}
IdentityFile /home/#{app_user}/git_id_rsa
User git

StrictHostKeyChecking no
"
end

package "git" do
  # workaround for:
  # WARNING: The following packages cannot be authenticated!
  # liberror-perl
  # STDERR: E: There are problems and -y was used without --force-yes
  options "--force-yes" if node["platform"] == "ubuntu" && node["platform_version"] == "14.04"
end


git app_path do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
  end

service "apache" do
  action :reload
end
