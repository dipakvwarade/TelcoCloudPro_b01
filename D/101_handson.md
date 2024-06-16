The goal of this exercise is to practice the two common ways of entering a container. The first
method is entering the container at runtime. The second is entering or connecting to a container that
is already running. In practice, the second method will be the one you'll use most often.

# Instructions:

## 1 Enter a Container at Runtime
Launch a container based on the "nginx" image and start an interactive shell. Name the container
"enter_nginx" and run the container in the foreground.

``
docker run -it --name enter_nginx nginx /bin/bash
`` 

Following that command, you are presented with a prompt that contains a username, a hostname,
and a path. This most likely means that the Bash shell is available to you as opposed to an older,
simpler shell.

Check that this is a correct assumption with the "bash --version" command.


``bash --version
`` 
The first line of output reports the version of Bash you are running.
Because the container is running in the foreground, when the process that started the container
stops, the container itself stops. To stop the Bash shell, type "exit".

``exit
`` 
Confirm that the container stopped.

``docker ps -a
`` 
You should see that the status of the "enter_nginx" container is "Exited."


## 2 Enter a Running Container

Most often, you'll want to connect to a container that is already running.
First, start a container named "exec_command_nginx" based on the "nginx" image. Run it in the
background.

``docker run -dit --name exec_command_nginx nginx
`` 

Check that it’s running properly after starting it detached.
``docker ps
`` 

Enter the container by running the bash shell. Remember, that you'll need to use the "-it" option.

``docker exec -it exec_command_nginx /bin/bash
`` 
You are presented with a prompt again. End your shell by typing "Ctrl-D" or by executing the "exit"
command.

``exit
`` 
Check that the container is still running

``docker ps
`` 

You should still see your container running after disconnecting from it.

