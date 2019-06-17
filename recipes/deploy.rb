app = search(:aws_opsworks_app).first
app_path = "/var/www/html/example.com/public_html/#{app['shortname']}"

package "git" do
  # workaround for:
  # WARNING: The following packages cannot be authenticated!
  # liberror-perl
  # STDERR: E: There are problems and -y was used without --force-yes
  options "--force-yes" if node["platform"] == "ubuntu" && node["platform_version"] == "18.04"
end


  git app_path do
    repository app["app_source"]["url"]
    revision app["app_source"]["revision"]
  end

  npm_install do
    retries 3
    retry_delay 10
  end

  npm_start do
    action [:stop, :enable, :start]
  end
end
