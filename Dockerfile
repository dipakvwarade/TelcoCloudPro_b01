FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y install git
RUN echo "Welcome to TelcoCloudPro B01"
WORKDIR /TelcoCloudPro/B01
RUN git clone https://github.com/dipakvwarade/TelcoCloudPro_b01 .
CMD ping -c 1000 google.com 




# docker build -t dipakvwarade/pinggoogle:v01 .
# docker push dipakvwarade/pinggoogle:v01

root@rpc:~/session_03# docker push dipakvwarade/pinggoogle:v01
# The push refers to repository [docker.io/dipakvwarade/pinggoogle]
# 765bfac2ddd1: Pushed 
# 5d0bd67ec299: Pushed 
# 5f70bf18a086: Mounted from library/redis 
# 64909d1b5c75: Pushed 
# 85971e180e39: Pushed 
# 80098e3d304c: Mounted from library/ubuntu 
# v01: digest: sha256:0df10a3b34c1d659882b203c58e6cf9294cdc94d2a7eeb6ceaea0c47874ca1fc size: 1575
# root@rpc:~/session_03# 
