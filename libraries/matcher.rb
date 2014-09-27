if defined?(ChefSpec)
  def create_passenger_nginx_vhost(vhost)
    ChefSpec::Matchers::ResourceMatcher.new(:passenger_nginx_vhost, :create, vhost)
  end

  def delete_passenger_nginx_vhost(vhost)
    ChefSpec::Matchers::ResourceMatcher.new(:passenger_nginx_vhost, :delete, vhost)
  end

end
