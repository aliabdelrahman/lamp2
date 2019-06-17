app = search("aws_opsworks_app").first
application "#{app['aplamp']}" do
  owner 'root'
  group 'root'
  repository app['app_source']['git@github.com:aliabdelrahman/test1.git']
  revision   'master'
  path "/var/www/html/public_html/#{app['aplamp']}"
end
