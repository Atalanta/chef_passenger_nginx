require 'spec_helper'

describe 'Passenger Nginx Default Recipe' do
  
  it 'should enable the Phusion repo' do
    expect((command 'apt-cache policy | grep phusion').stdout).to match /oss-binaries.phusionpassenger.com/
  end

  it 'should enable the Brightbox RubyNG repo' do
    expect((command 'apt-cache policy | grep ruby-ng').stdout).to match /ppa.launchpad.net\/brightbox\/ruby-ng/
  end

  it 'should install Nginx with embedded Passenger' do
    expect(package 'nginx-full').to be_installed
    expect(package 'passenger').to be_installed
    expect((command 'nginx -v').stdout).to match /^nginx version: nginx\/\d+.\d+.\d+$/
    expect((command 'passenger --version').stdout).to match /^Phusion Passenger version \d+.\d+.\d+$/
  end

  it 'should install ruby-switch' do
    expect(package 'ruby-switch').to be_installed
    expect((command 'ruby-switch --list').stdout).to match /^ruby/
  end

  it 'should not use Ruby 2.2-preview' do
    expect((command 'ruby-switch --check').stdout).to match /Currently using: ruby2.1/
  end

  it 'should install Ruby 2.1' do
    expect(package 'ruby2.1').to be_installed
    expect(package 'ruby2.1-dev').to be_installed
    expect((command 'ruby --version').stdout).to match /^ruby 2\.1\.\d+p\d+/
  end

  it 'should set the passenger root' do
    expect(file('/etc/nginx/nginx.conf').content).to match /^\s+passenger_root.*locations\.ini;$/
  end

  it 'should set the passenger ruby' do
    expect(file('/etc/nginx/nginx.conf').content).to match /^\s+passenger_ruby.*\/usr\/bin\/ruby;$/
  end

  it 'should start and enable nginx' do
    expect(service('nginx')).to be_running
    expect(service('nginx')).to be_enabled
  end

end


