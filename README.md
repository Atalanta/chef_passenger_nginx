# passenger_nginx

This cookbook installs Nginx and Passenger using the integrated package provided by Phusion, and installs Ruby 2.1 from the Brightbox PPA, configuring Nginx/Passenger to use this Ruby.

## Usage

Simply include the recipe `passenger_nginx` in a wrapper cookbook or in a run list.  At present only Ubuntu 14.04 is tested and supported.

The cookbook provides an LWRP for generating a virtual host for the rack application you wish to serve via Passenger:

    passenger_ngnix_vhost 'myapp' do
        port 80
        server_name 'myapp.com'
        environment 'development'
        root '/home/deploy/myapp/current/public'
    end

This will generate a config snippet like this:

    server {
            listen 80 default_server;
            listen [::]:80 default_server ipv6only=on;
    
            server_name myapp.com;
            passenger_enabled on;
            rails_env    production;
            root         /home/deploy/myapp/current/public;
    
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
    }
    
## Testing

This cookbook is written test-first using ChefSpec and KitchenCI.  To run the ChefSpec tests:

    rspec -fd --color

To run the ServerSpec tests (via KitchenCI):

    kitchen verify

The LWRP is tested via a separate cookbook `passenger_nginx_vhost_test`.

## Todo

- Expose a vhost LWRP 

