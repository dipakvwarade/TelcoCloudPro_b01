# Docker volume practice

A Docker Volume is a mechanism for persisting data generated and used by Docker containers. Volumes can be more efficient and flexible than storing data inside a container's writable layer because they allow data to persist across container restarts, updates, and even when containers are deleted. 



## Create a dir /root/tcp_vol
## Change the working dir to /root/tcp_vol/
```
mkdir /root/tcp_vol
cd /root/tcp_vol
```
## Create a file with following contents using "vi index.html"
```
html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to TelcoCloudPro Session!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to TelcoCloudPro Session!</h1>
<p>If you see this page, the TelcoCloudPro web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://telcocloud.pro/">telcocloud.pro</a>.<br/>
Commercial support is available at
<a href="http://telcocloud.pro">telcocloud.pro</a>.</p>

<p><em>Thank you for using TelcoCloudPro.</em></p>
</body>
</html>
```
## Run nginx pod
```
docker run -d -it --name ng_cont -p 80:80 nginx

curl localhost:80 # to check if nginx is running. you should see default page of nginx

docker stop ng_cont
docker rm ng_cont      
```
## Run nginx pod wit volume attached from host 
```
docker run -d -it -p 80:80 --name ng_cont -v /root/tcp_vol:/usr/share/nginx/html/ nginx

curl localhost:80 # to check if nginx is running. you should see modified page of nginx
```

## Logs from trainers lab
```
root in ~/tcp_vol 
➜ docker run -d -it --name ng_cont -p 80:80 nginx

810f30ffe9ba8a32d0e6f2a71c6047ef335a5d96c927ecd223edf47f4bea13ff

root in ~/tcp_vol 
➜ curl localhost:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

root in ~/tcp_vol 
➜ docker stop ng_cont
ng_cont

root in ~/tcp_vol 
➜ docker run -d -it -p 80:80 --name ng_cont -v /root/tcp_vol:/usr/share/nginx/html/ nginx

➜ docker rm ng_cont                                                                      
ng_cont

root in ~/tcp_vol 
➜ docker run -d -it -p 80:80 --name ng_cont -v /root/tcp_vol:/usr/share/nginx/html/ nginx
388de6f997581171d3be774932a18b67ed9e677507c871c6dddb6748e9abac1a

root in ~/tcp_vol 
➜ curl localhost:80                                                                      
html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to TelcoCloudPro Session!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to TelcoCloudPro Session!</h1>
<p>If you see this page, the TelcoCloudPro web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://telcocloud.pro/">telcocloud.pro</a>.<br/>
Commercial support is available at
<a href="http://telcocloud.pro">telcocloud.pro</a>.</p>

<p><em>Thank you for using TelcoCloudPro.</em></p>
</body>
</html>

root in ~/tcp_vol 
➜ docker inspect 388de6f997 | grep -i tcp_vol -C4                                        
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": [
                "/root/tcp_vol:/usr/share/nginx/html/"
            ],
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
--
        },
        "Mounts": [
            {
                "Type": "bind",
                "Source": "/root/tcp_vol",
                "Destination": "/usr/share/nginx/html",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"

root in ~/tcp_vol 
```

