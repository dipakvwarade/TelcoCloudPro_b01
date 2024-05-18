# Bridge [internal network]
  - a bridge network is a Link Layer device which forwards traffic between network segments
  - a bridge network uses a software bridge which lets containers connected to the same bridge network communicate, while providing isolation from containers that aren't connected to that bridge network
  - Bridge networks apply to containers running on the same Docker daemon host

- docker0 is by default created as a part of default bridge network
- Internal network
- 172.17.0.x
- only ip connectivity between containers
```
➜ ip link show                 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 42:01:0a:b6:00:05 brd ff:ff:ff:ff:ff:ff
4: **docker0**: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 02:42:44:c1:06:8e brd ff:ff:ff:ff:ff:ff
47: **veth394d0f1@if46**: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP mode DEFAULT group default 
    link/ether 2a:cc:47:d5:3a:dd brd ff:ff:ff:ff:ff:ff link-netnsid 0



➜ docker run -dit nginx                  
b3d71df78718a35dffde4209fbac80e272c94206ca039fde3c12abd744e08e07

root in TelcoCloudPro_b01/prometheus-grafana on  main on 🐳 v26.1.3 
➜ ip link show            
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 42:01:0a:b6:00:05 brd ff:ff:ff:ff:ff:ff
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 02:42:44:c1:06:8e brd ff:ff:ff:ff:ff:ff
47: veth394d0f1@if46: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP mode DEFAULT group default 
    link/ether 2a:cc:47:d5:3a:dd brd ff:ff:ff:ff:ff:ff link-netnsid 0
49: veth0e3eec8@if48: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP mode DEFAULT group default 
    link/ether 3e:db:34:f6:5e:f2 brd ff:ff:ff:ff:ff:ff link-netnsid 1

two container hence two veth connecting to docker0 bridge
```

## lets create our own private brige
```
➜ docker network create mynet 
8e62b0463202fda62daea918f84fe9640c6e3dd2425ce0cf519bf497c8eb4895

root in ~ 
➜ docker network ls          
NETWORK ID     NAME      DRIVER    SCOPE
866a98c34c78   bridge    bridge    local
7de883b3a935   host      host      local
8e62b0463202   mynet     bridge    local
8cfb2c1ab0aa   none      null      local

➜ ip a s |grep 8e62b0463202         
50: br-8e62b0463202: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    inet 172.22.0.1/16 brd 172.22.255.255 scope global br-8e62b0463202

root in ~ 
➜ ip a s  
50: br-8e62b0463202: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:ae:48:4f:d9 brd ff:ff:ff:ff:ff:ff
    inet 172.22.0.1/16 brd 172.22.255.255 scope global br-8e62b0463202
       valid_lft forever preferred_lft forever
    inet6 fe80::42:aeff:fe48:4fd9/64 scope link 
       valid_lft forever preferred_lft forever
52: veth2997314@if51: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e62b0463202 state UP group default 
    link/ether 62:4d:25:5a:93:35 brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet6 fe80::604d:25ff:fe5a:9335/64 scope link 
       valid_lft forever preferred_lft forever


oot in ~ 
➜ docker run -dit --network mynet --name netshoot nicolaka/netshoot                       
40a914e7ce157c88843f52e480a129e419c2e9a8df60e74c54aa7556c33c3bc5

root in ~ 
➜ docker run -dit --network mynet --name netshoot1 nicolaka/netshoot
05de77024cd95f46efc7a87ab8188a2be16bd4bf5ce7182bce210d99211d566a

root in ~ 
➜ docker run -dit --network mynet --name nginx1 nginx                
2ab86ec482ce309d7eaa2cbcc7df17b037eb87b0aa83b7c4e9dba254ed8df2b4

root in ~ 
➜ docker ps                                          
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS          PORTS     NAMES
2ab86ec482ce   nginx               "/docker-entrypoint.…"   4 seconds ago    Up 4 seconds    80/tcp    nginx1
05de77024cd9   nicolaka/netshoot   "zsh"                    24 seconds ago   Up 24 seconds             netshoot1
40a914e7ce15   nicolaka/netshoot   "zsh"                    30 seconds ago   Up 29 seconds             netshoot

root in ~ 
➜ docker exec netshoot ping nginx1     
PING nginx1 (172.22.0.4) 56(84) bytes of data.
64 bytes from nginx1.mynet (172.22.0.4): icmp_seq=1 ttl=64 time=0.084 ms
64 bytes from nginx1.mynet (172.22.0.4): icmp_seq=2 ttl=64 time=0.064 ms
^C

root in ~ 
➜ docker exec netshoot1 ping nginx1
PING nginx1 (172.22.0.4) 56(84) bytes of data.
64 bytes from nginx1.mynet (172.22.0.4): icmp_seq=1 ttl=64 time=0.083 ms
64 bytes from nginx1.mynet (172.22.0.4): icmp_seq=2 ttl=64 time=0.060 ms
^C

root in ~ 
➜ docker exec netshoot1 ping nginx1

➜ ip link show 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 42:01:0a:b6:00:05 brd ff:ff:ff:ff:ff:ff
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:44:c1:06:8e brd ff:ff:ff:ff:ff:ff
50: br-8e62b0463202: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 02:42:ae:48:4f:d9 brd ff:ff:ff:ff:ff:ff
60: vethab1b89c@if59: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e62b0463202 state UP mode DEFAULT group default 
    link/ether d6:c1:62:10:c4:83 brd ff:ff:ff:ff:ff:ff link-netnsid 0
62: veth5e24843@if61: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e62b0463202 state UP mode DEFAULT group default 
    link/ether 3a:89:d2:f9:b0:f8 brd ff:ff:ff:ff:ff:ff link-netnsid 1
64: vethf73e0d7@if63: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-8e62b0463202 state UP mode DEFAULT group default 
    link/ether 8a:5f:0e:80:e5:35 brd ff:ff:ff:ff:ff:ff link-netnsid 2
```

# None
- no networking :)


# Host [host network]
- connnect to host machine network
docker run redis --network=host

```
