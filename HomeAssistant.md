Install https://github.com/tobias-kuendig/hacompanion

add the following to the haconpanion.toml
```
[script.vpn_connected]
path = "/usr/local/bin/vpnadmin.sh"
## Attributes according to
## https://developers.home-assistant.io/docs/api/native-app-integration/sensors
 name = "openVPN connected"
 icon = "mdi:server-network"
 type = "binary_sensor" 
 ```
 
 Home Assistant configuration.yaml
 ```
 input_select:
  vpn_servers:
    name: vpn servers
    options:
     -  "stop"
 
 
     sensors:
      vpn_ip:
        friendly_name: "vpn ip address"
        value_template: "{{ state_attr('binary_sensor.vpn_connected', 'ip_address') }}"
      vpn_location:
        friendly_name: "vpn location"
        value_template: "{{ state_attr('binary_sensor.vpn_connected', 'location') }}"

shell_command:  
   vpn_switch: ssh -i /config/ssh/id_rsa -o StrictHostKeyChecking=accept-new user@vpn-gateway sudo /usr/local/bin/vpnadmin.sh start {{states('input_select.vpn_servers' ) }}

```

automation to fill the input select
```

alias: startup_fill_vpn_servers
description: ""
trigger:
  - platform: homeassistant
    event: start
  - platform: state
    entity_id:
      - sensor.openvpn_connected_to_location
condition: []
action:
  - service: input_select.set_options
    data:
      options: " {{state_attr('binary_sensor.vpn_connected','connections')}}"
    target:
      entity_id: input_select.vpn_servers
  - service: input_select.select_option
    data:
      option: "{{state_attr('binary_sensor.vpn_connected','location')}}"
    target:
      entity_id: input_select.vpn_servers
mode: single
```
A script to fire off the shell command

```
alias: update vpn
sequence:
  - service: shell_command.vpn_switch
    data: {}
mode: single
```

and Install Select list Card hacks integration
and you have all the means to build your card





