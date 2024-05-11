FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y install git
RUN echo "Welcome to TelcoCloudPro B01"
WORKDIR /TelcoCloudPro/B01
RUN git clone https://github.com/dipakvwarade/TelcoCloudPro_b01 .
CMD ping -c 1000 google.com 
