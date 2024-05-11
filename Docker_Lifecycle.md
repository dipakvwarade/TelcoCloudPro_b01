# Docker [run,pause,unpose,stop,start,rm,rmi]

```
docker run redis:latest

docker run -d redis:tag

docker pause/unpause ContainerName

docker stop ContainerName

```


# Expose a port / port mapping


```
docker run -d -p 8080:80 nginx:latest

systemctl status docker # look for proxy forwarding

```


# Volume mapping


```
docker run -d -it -v /tmp/dockerDir:/var/lib/mysql ubuntu bash
docker exec -it 195b69dac215 bash

```


# Docker inspect - all details in json format 
```
docker inspect 195b69dac215
```


```
docker logs -f 195b69dac215
```



# Environment variable

```
docker run -e CLASS=TelcoCloud_B01 -d -it ubuntu bash
root@rpc:/tmp/dockerDir# docker exec -it 065ae9cfd8f1 bash
root@065ae9cfd8f1:/# echo $CLASS
TelcoCloud_B01

```
