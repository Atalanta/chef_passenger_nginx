def whyrun_supported?
  true
end

action :create do
  converge_by("Creating Vhost #{ @new_resource }") do
    create_vhost
  end
end

action :delete do
  converge_by("Deleting Vhost #{ @new_resource }") do
    delete_vhost
  end
end

action :disable do
    converge_by("Disabling Vhost #{ @new_resource }") do
      disable_vhost
    end
end

action :enable do
  converge_by("Enabling Vhost #{ @new_resource }") do
    enable_vhost
  end
end

def load_current_resource
  @current_resource = Chef::Resource::PassengerNginxVhost.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.port(@new_resource.port)
  @current_resource.server_name(@new_resource.server_name)
  @current_resource.environment(@new_resource.environment)
  @current_resource.root(@new_resource.root)
end

def create_vhost
  name = new_resource.name
  server_name = new_resource.server_name

  template "/etc/nginx/sites-available/#{name}" do
    cookbook 'passenger_nginx'
    source 'passenger_vhost.erb'
    variables new_resource.to_hash
    notifies :reload, 'service[nginx]'
  end

  cookbook_file "/etc/nginx/ssl/#{server_name}.crt" do
    cookbook new_resource.cookbook_name.to_s
    source "#{server_name}.crt"
  end
  
  cookbook_file "/etc/nginx/ssl/#{server_name}.key" do
    cookbook new_resource.cookbook_name.to_s
    source "#{server_name}.key"
  end
  
end

def enable_vhost
  name = new_resource.name

  link "/etc/nginx/sites-enabled/#{name}" do
    to "/etc/nginx/sites-available/#{name}"
    notifies :reload, 'service[nginx]'
  end
end

def disable_vhost
  name = new_resource.name
  link "/etc/nginx/sites-enabled/#{name}" do
    action :delete
    notifies :reload, 'service[nginx]'
  end
end

def delete_vhost
  name = new_resource.name

  file "/etc/nginx/sites-available/#{name}" do
    action :delete
    notifies :reload, 'service[nginx]'
  end
end
