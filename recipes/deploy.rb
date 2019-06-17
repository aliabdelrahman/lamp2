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


git app_path do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
  end

service "apach" do
  action :reload
end
