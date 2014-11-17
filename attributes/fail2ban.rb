default['fail2ban']['filters'] = {
  'nginx-req-limit' => {
        "failregex" => ['limiting requests, excess:.* by zone.*client: <HOST>'],
        "ignoreregex" => []
     },
}

default['fail2ban']['services'] = {
  'nginx-req-limit' => {
        "enabled" => "false",
        "port" => "http,https",
        "filter" => "nginx-req-limit",
        "logpath" => "/var/log/nginx/*error.log",
#        "action" => 'iptables-multiport[name=ReqLimit, port="http,https", protocol=tcp]',
        "maxretry" => "6"
     }
}
