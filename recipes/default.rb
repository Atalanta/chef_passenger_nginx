#
# Cookbook Name:: passenger_nginx
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe 'apt-repo'
include_recipe 'fail2ban'

apt_repo "passenger" do
  url "https://oss-binaries.phusionpassenger.com/apt/passenger"
  key_id "561F9B9CAC40B2F7"
  keyserver "keyserver.ubuntu.com" # defaults to keys.gnupg.net
end

ppa 'ppa:brightbox/ruby-ng'

package 'nginx-full'
package 'passenger'
package 'ruby2.1'
package 'ruby2.1-dev'
package 'ruby-switch'

execute 'Set default Ruby to 2.1' do
  command 'ruby-switch --set ruby2.1'
  not_if 'ruby-switch --check | grep -q ruby2\.1' 
end

directory '/etc/nginx/ssl'

service 'nginx' do
  action [:enable, :start]
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  notifies :restart, 'service[nginx]', :immediately
end


