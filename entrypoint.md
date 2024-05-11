```
FROM ubuntu
RUN  apt-get update -y
RUN  apt-get install -y iputils-ping
ENTRYPOINT ["ping"]
CMD ["8.8.8.8"]

```
