| **Command** | **Description** | **Docker** | **Crictl** |
| --- | --- | --- | --- |
| Run Container | Run a new container from an image. | `docker run -it myimage` | `crictl create --image=myimage` |
| List Containers | List all running containers. | `docker ps` | `crictl ps` |
| Inspect Container | Inspect a container's configuration. | `docker inspect` | `crictl inspect` |
| Kill/Stop Container | Stop or kill a running container. | `docker stop` / `docker kill <container_id>` | `crictl stop` / `crictl kill <container_id>` |
| Restart Container | Restart a stopped container. | `docker restart` | `crictl restart <container_id>` |
| List Images | List all available images. | `docker images` | `crictl images` |
| Remove Container | Remove one or more containers. | `docker rm mycontainer` | `crictl rm mycontainer` |
| Remove Image | Remove an image. | `docker rmi myimage` | `crictl rmi myimage` |
| Log Output | View the logs of a container. | `docker logs` | `crictl logs <container_id>` |
| Port Forwarding | Forward a port from a container to the host machine. | `docker -p <port> mycontainer` | `crictl -p <port> mycontainer` |
