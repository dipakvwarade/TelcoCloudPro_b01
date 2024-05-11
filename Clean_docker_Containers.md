```
for i in $(docker ps -a|awk '{print $1}'); do docker stop $i; done
for i in $(docker ps -a|awk '{print $1}'); do docker rm $i; done
```
