default['fail2ban']['filters'] = {
  'nginx-req-limit' => {
        "failregex" => ['limiting requests, excess:.* by zone.*client: <HOST>'],
        "ignoreregex" => []
     },
}

normal['fail2ban']['services'] = {
  'nginx-req-limit' => {
        "enabled" => "true",
        "port" => "http,https",
        "filter" => "nginx-req-limit",
        "logpath" => "/var/log/nginx/*error.log",
        "maxretry" => "6"
     }
}
