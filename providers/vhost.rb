def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info "#{ @new_resource } already exists: no action needed."
  else
    converge_by("Create #{ @new_resource }") do
      create_vhost
    end
  end
end

action :delete do
  if @current_resource.exists
    converge_by("Delete #{ @new_resource }") do
      delete_vhost
    end
  else
    Chef::Log.info "#{ @current_resource } does not exist: no action needed."
  end
end


def load_current_resource
  @current_resource = Chef::Resource::PassengerNginxVhost.new(@new_resource.name)
  @current_resource.name(@new_resource.name)
  @current_resource.port(@new_resource.port)
  @current_resource.server_name(@new_resource.server_name)
  @current_resource.environment(@new_resource.environment)
  @current_resource.root(@new_resource.root)
  if vhost_exists?(@current_resource.name)
    @current_resource.exists = true
  end
end

def create_vhost
  
  name = new_resource.name

  template "/etc/nginx/sites-available/#{name}" do
    cookbook 'passenger_nginx'
    source 'passenger_vhost.erb'
    variables new_resource.to_hash
    notifies :reload, 'service[nginx]'
  end

  link "/etc/nginx/sites-enabled/#{name}" do
    to "/etc/nginx/sites-available/#{name}"
  end

end

def delete_vhost

  name = new_resource.name

  link "/etc/nginx/sites-enabled/#{name}" do
    action :delete
    notifies :reload, 'service[nginx]'
  end
end

def vhost_exists?(name)
  ::File.exists? "/etc/nginx/sites-enabled/#{name}"
end
