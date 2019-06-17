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

  link "#{app_path}/server.js" do
    to "#{app_path}/index.js"
  end

  npm_install do
    retries 3
    retry_delay 10
  end

  npm_start do
    action [:stop, :enable, :start]
  end

