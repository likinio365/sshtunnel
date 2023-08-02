## Docker SSH Tunnel
The bellow image has been created to use the ssh tunnel in reverse mode, allowing multiple ports on a remote servers to redirect to a port or multiple ports on a local host. The below example is the same as SSH'ing to TUNNEL_HOST and the forwarding REMOTE_HOST:REMOTE_PORT on local machine on LOCAL_PORT. You can have one and more tunnels.

 1. REMOTE should be always true
 2. H should be always number_of_tunnels -1
 3. IPs or ports should be comma separated 
 4. You should mount the volume that has the key file and define keyfile in KEY variable 
 5. data directory should have permissions 744 and key file should have permissions 600

## Usage


In docker-compose.yml

 

       version: '3.8'
        services:
         sshtunnel:
          image: likinio365/sshtunnel
          network_mode: "host"
          volumes:
            - ~/data/:/data/:ro
          environment:
            - H=1    (if you want two tunnels H should be -1, on my example i want 2 tunnels.)
            - REMOTE=true
            - TUNNEL_HOST=SomeIP,SomeOrOtherIP
            - REMOTE_PORT=SomePort,SomeOrOtherPort
            - REMOTE_HOST=SomeIP,SomeOrOtherIP
            - LOCAL_PORT=SomePort,SomeOrOtherPort
            - KEY=/data/Keyfile
          restart: always


## EXAMPLE
On the bellow example we forwarded port 10.1.1.10-12 443 on our local machine on ports 499 500 and 501.
Is like you running the bellow commands in linux :

    ssh -vv -o StrictHostKeyChecking=no -fN 10.10.10.1 -L 499:10.1.1.10:443
    ssh -vv -o StrictHostKeyChecking=no -fN 10.10.10.2 -L 500:10.1.1.11:443
    ssh -vv -o StrictHostKeyChecking=no -fN 10.10.10.3 -L 501:10.1.1.12:443

Here is the **docker-compose.yml** .
Don't forget to define the number of tunnels you want on H variable , value should be number -1 . On my example is 3-1=2

    version: '3.8'
    services:
     sshtunnel:
      image: likinio365/sshtunnel:1.0
      network_mode: "host"
      volumes:
        - ~/data/:/data/:ro
      environment:
        - H=2
        - REMOTE=true
        - TUNNEL_HOST=10.10.10.1,10.10.10.2,10.10.10.3
        - REMOTE_PORT=443,443,443
        - REMOTE_HOST=10.1.1.10,10.1.1.11,10.1.1.12
        - LOCAL_PORT=499,500,501
        - KEY=/data/id_rsa
      restart: always
