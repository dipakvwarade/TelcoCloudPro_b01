
### 1. **Introduction to Docker Networking**


Docker networking allows containers to communicate with each other, the host machine, and the external world. Docker offers multiple networking options for different use cases:


- **Bridge Network**: Default network driver. Suitable for multi-container applications running on a single host.

- **Host Network**: Containers share the host’s networking namespace.

- **Overlay Network**: Enables swarm services to communicate with each other, even across different Docker daemons.

- **None Network**: Disables all networking.

- **Macvlan Network**: Assigns a MAC address to containers, making them appear as physical devices on the network.

- **Custom Network**: User-defined networks for specific needs.



### 2. **Bridge Network**



#### 2.1. **Default Bridge Network**

- When Docker is installed, it automatically creates a `bridge` network. You can see it by running:

  

  ```bash

  docker network ls

  ```



- To start a container with the default bridge network:



  ```bash

  docker run -d --name container



#### Default Bridge Network (`bridge`):

- To inspect the default bridge network:

  

  ```bash

  docker network inspect bridge

  ```



Containers on the bridge network can be accessed by each other's IP addresses or hostnames.



#### 2.2. **User-Defined Bridge Networks**



User-defined bridge networks are more versatile and provide better isolation and control over your containers' communication.



**Creating a User-Defined Bridge Network:**



```bash

docker network create my-bridge-network

```



**Running Containers on a User-Defined Bridge Network:**



```bash

docker run -d --name my-container --network my-bridge-network nginx

```



**Communicate Between Containers:**



When two containers are on the same user-defined bridge network, they can communicate with each other using their container names as the hostname.



Example:



```bash

docker run -d --name container1 --network my-bridge-network nginx

docker run -d --name container2 --network my-bridge-network busybox sleep 1000



# Inside container2, you can ping container1:

docker exec -it container2 ping container1

```



### 3. **Host Network**



Using the host network means the container does not get its own IP address but shares the host’s IP and ports.



**Running a Container with the Host Network:**



```bash

docker run -d --name my-container --network host nginx

```



Note: This is useful for performance reasons but sacrifices the isolation Docker typically provides.



### 4. **Overlay Network**



Overlay networks allow containers that are running on different Docker daemons to communicate. They’re essential for Docker Swarm services.



**Creating an Overlay Network:**



```bash

docker network create -d overlay my-overlay-network

```



**Running Services with Overlay Networks:**



Overlay networks are primarily for use with Docker Swarm. Here’s a simple example:



```bash

docker swarm init

docker network create -d overlay my-overlay-network

docker service create --name my-service --network my-overlay-network nginx

```



### 5. **Macvlan Network**



Macvlan networks assign a unique MAC address to each container, making them appear as individual devices on the local network.



**Creating a Macvlan Network:**



```bash

docker network create -d macvlan \

    --subnet=192.168.1.0/24 \

    --gateway=192.168.1.1 \

    -o parent=eth0 my-macvlan-network

```



**Running Containers with Macvlan Network:**



```bash

docker run -d --name my-container --network my-macvlan-network nginx

```



### 6. **Container-to-Container Networking**



#### 6.1. **Linking Containers**

- Deprecated but still functional. Links allow you to communicate between containers without creating a custom network.



```bash

docker run -d --name container1 nginx

docker run -d --name container2 --link container1:alias-for-container1 busybox sleep 1000

```



Inside `container2`, `alias-for-container1` resolves to `container1`.



### 7. **Network Management Commands**



- **List Networks:**



  ```bash

  docker network ls

  ```



- **Inspect a Network:**



  ```bash

  docker network inspect my-bridge-network

  ```



- **Remove a Network:**



  ```bash

  docker network rm my-bridge-network

  ```



- **Disconnect a Container from a Network:**



  ```bash

  docker network disconnect my-bridge-network my-container

  ```



- **Connect a Container to a Network:**



  ```bash

  docker network connect my-bridge-network my-container

  ```



### 8. **Practical Example**



Let's conduct a small, practical scenario where we'll use a user-defined bridge network.



1. **Create a network:**



   ```bash

   docker network create my-app-network

   ```



2. **Run a web server container:**



   ```bash

   docker run -d --name webserver --network my-app-network nginx

   ```



3. **Run a client container:**



   ```bash

   docker run -d --name client --network my-app-network busybox sleep 1000

   ```



4. **Ping the webserver from the client container:**



   ```bash

   docker exec -it client ping webserver

   ```



You should see successful pings, indicating that the containers are communicating over the user-defined network.
