# Docker volume practice

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
```
## Run nginx pod wit volume attached from host 
```
docker run -d -it -p 80:80 --name ng_cont -v /root/tcp_vol:/usr/share/nginx/html/ nginx

curl localhost:80 # to check if nginx is running. you should see modified page of nginx
```
