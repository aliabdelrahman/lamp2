app = search("aws_opsworks_app").first
application "#{app['shortname']}" do
  owner 'root'
  group 'root'
  repository app['app_source']['url']
  revision   'master'
  path "/srv/#{app['shortname']}"
end
