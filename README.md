# passenger_nginx

This cookbook installs Nginx and Passenger using the integrated package provided by Phusion, and installs Ruby 2.1 from the Brightbox PPA, configuring Nginx/Passenger to use this Ruby.

## Usage

Simply include the recipe `passenger_nginx` in a wrapper cookbook or in a run list.  At present only Ubuntu 14.04 is tested and supported.

## Testing

This cookbook is written test-first using ChefSpec and KitchenCI.  To run the ChefSpec tests:

    rspec -fd --color

To run the ServerSpec tests (via KitchenCI):

    kitchen verify

## Todo

- Expose a vhost LWRP 

