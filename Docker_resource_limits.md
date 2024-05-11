## Docker Container resource limits

Docker containers doesnt have any limit set by default! 

# Hard limits 
  -  When a container exceeds a hard memory limit, Docker takes aggressive actions such as terminating the container.
# Soft limits 
  - When a soft limit is reached, Docker warns the user but does not take immediate action.

# What can be employed to control the docker resources? 
  - dont forget cgroups :)

# Limit Docker Memory Usage  
  - Set soft and hard limits on containers

```
# Hard limit 
$ docker run -dit --memory="5g" nginx
$ docker stats


CONTAINER ID   NAME             CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O     PIDS
89ad2c010831   goofy_lovelace   0.00%     4.426MiB /**5GiB**       0.09%     2.43kB / 0B     0B / 20.5kB   5

# Soft Limit

$ docker run -dit --memory="5g" --memory-reservation="2g" nginx

# Check if its applied 
root@rpc:~/session_03# docker inspect dcfe4e7a7aff|grep -i mem
            "Memory": 5368709120,
            "CpusetMems": "",
            "MemoryReservation": 2147483648,
            "MemorySwap": 10737418240,
            "MemorySwappiness": null,
# One billion nano CPUs corresponds to one CPU
```

# Limit Number of CPU Cores

```
$ docker run -dit --cpus="1.0" --memory="10g" --memory-reservation="9g" nginx

# Verify if the limits are set
root@rpc:~/session_03# docker inspect 4cab8b72cb96 |egrep -i "mem|NanoCpus"
            **"Memory": 10737418240,**
            **"NanoCpus": 1000000000,**
            "CpusetMems": "",
           ** "MemoryReservation": 9663676416,**
            "MemorySwap": 21474836480,
            "MemorySwappiness": null,

```

