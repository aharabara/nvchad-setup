### Keys remapping
```shell
sudo add-apt-repository ppa:keyd-team/ppa
sudo apt update
sudo apt install keyd
sudo systemctl enable keyd --now
sudo keyd.rvaiya reload
```

```
# /etc/keyd/default.conf
[ids]
*

[main]
kp1=1
kp2=2
kp3=3
kp4=4
kp5=5
kp6=6
kp7=7
kp8=8
kp9=9
kp0=0

numlock=toggle(control_layer)

[control_layer]
kp7=macro(space 1)
kp0=macro(leftalt+h)
kp5=macro(space space)

```
