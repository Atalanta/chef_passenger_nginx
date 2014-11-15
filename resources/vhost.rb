actions :create, :delete, :enable, :disable

attribute :name, :name_attribute => true
attribute :port, :kind_of => Fixnum, :default => 80
attribute :server_name, :kind_of => String, :required => true
attribute :environment, :kind_of => String, :default => 'production'
attribute :root, :kind_of => String, :required => true

def initialize(*args)
  super
  @action = :create
end
