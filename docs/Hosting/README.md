# Cloud Hosting
We decided we were going to do Ruby on Rails app so we decided that AWS(Amazon Web Services) would be the best place to host it.

### Components of Hosting
1. Webserver Host: Amazon EC2
2. Code Setup: Git Clone
3. Webserver: Passenger
4. Reverse Proxy: NGINX
5. Loadbalencer: Amazon ELB
6. Automating Code Deployment: Cron Job

### 1. Webserver Host: Amazon EC2
I created an EC2 instance with Ubuntu Server 14.04. I gave the instance a 15gb general purpose SSD volume. I configured the security group to accept the following incoming traffic types.

|Type |Port|
|-----|----|
|TCP  |8080|  
|HTTP |80  |
|HTTPS|443 |
|SSH  |22  |

All other setings were kept as default until the section for using or creating your own key pair which is essential for remote managment via ssh. Once the key pair is created and selected as part of the config it is downloaded onto the computer you are using to access the AWS console.

Once the instance was stood up I connected via ssh using the key pair I created and the username ubuntu. See following example.
```shell
$ ssh -i "keypair.pem" ubuntu@ec2.ap-southeast-2.compute.amazonaws.com
```
I then created a shell script in the home directory called setup.sh.

```shell
$ sudo nano setup.sh
```
This script can be seen is this directory. This installed Passenger which is the ruby webserver, NGINX the reverse proxy, Git for cloning the code from the repo and the postgres development library and the postgres client for testing and conecting to the database.

Once you have this script in your home directory you are going to want to make the script executable see following.
```shell
$ sudo chmod +x setup.sh
```
Then run the script with the following comand.
```shell
$ ./setup.sh
```
This will take around 10 minutes, once this is completed you should have everything installed.

### 2. Code Setup: Git Clone
Now its time to setup the code to run. Firstly you are gonna want to git clone the repo down from GitHub into the webserving directory. see following.
```shell
$ cd /opt
$ git clone https://github.com/aldent95/Nwen304-Team12.git
```
Now its time to install the dependancies for the project this can be achived with the following.
```shell
$ cd Nwen304-Team12
$ sudo bundle install
```
Now all the dependancies are installed its now time to make the project content web servable. see following.
```shell
$ sudo  chmod 775 *
```
### 3. Webserver: Passenger
There is not mauch configuration required for Passenger as this is taked care of by NGINX. Passenger is just used to serve the content to NGINX. NGINX is the Component which does all the heavy lifting in this scenario.

### 4. Reverse Proxy: NGINX

```shell
sudo nano /opt/nginx/conf/nginx.conf
```

```
worker_processes  1;
events {
    worker_connections  1024;
}
http {
    passenger_root        /var/lib/passenger/passenger-5.0.28;
    passenger_ruby        /usr/local/bin/ruby;

    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;

    server {
        listen            80;
        rails_env         production;
        passenger_enabled on;
        root              /opt/Nwen304-Team12/public;
    }
    server {
        listen            8080;
        return            301 https://$host$request_uri;
    }
}
```

```shell
sudo nano /etc/default/nginx
```

```shell
sudo nano /etc/default/nginx
```
