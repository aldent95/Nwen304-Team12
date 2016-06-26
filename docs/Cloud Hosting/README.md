# Cloud Hosting
We decided we were going to do Ruby on Rails app so we decided that AWS(Amazon Web Services) would be the best place to host it.

All files referenced in this file can be found https://github.com/aldent95/Nwen304-Team12/tree/master/docs/Cloud%20Hosting.

### Components of Hosting
1. Webserver Host: Amazon EC2
2. Code Setup
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
|SSH  |22  |

All other settings were kept as default until the section for using or creating your own key pair which is essential for remote management via ssh. Once the key pair is created and selected as part of the config it is downloaded onto the computer you are using to access the AWS console.

Once the instance was stood up I connected via ssh using the key pair I created and the username ubuntu. See the following example.
```shell
$ ssh -i "keypair.pem" ubuntu@ec2.ap-southeast-2.compute.amazonaws.com
```
I then created a shell script in the home directory called setup.sh.

```shell
$ sudo nano setup.sh
```
This script can be seen is this directory. This installed Passenger which is the ruby webserver, NGINX the reverse proxy, Git for cloning the code from the repo and the Postgres development library and the Postgres client for testing and connecting to the database.

Once you have this script in your home directory you are going to want to make the script executable see following.
```shell
$ sudo chmod +x setup.sh
```
Then run the script with the following command.
```shell
$ ./setup.sh
```
This will take around 10 minutes, once this is completed you should have everything installed.

### 2. Code Setup
Now its time to setup the code to run. Firstly you are gonna want to git clone the repo down from GitHub into the webserving directory. see following.
```shell
$ cd /opt
$ git clone https://github.com/aldent95/Nwen304-Team12.git
```
Now its time to install the dependancies for the project this can be achieved with the following.
```shell
$ cd Nwen304-Team12
$ sudo bundle install
```
Now all the dependancies are installed its now time to make the project content web servable. see following.
```shell
$ sudo  chmod 775 *
```
Lastly I you need to generate a secret key for the application to run. To do this run the following command.
```shell
$ rake secret
```
Save the output guid somewhere so it can be inputted later. Next, you need to create a secrets.yml with the following command. The contents of this file can be seen with the provided file in this directory.
```shell
$ sudo nano config/secrets.yml
```
### 3. Webserver: Passenger
There is not much configuration required for Passenger as this is taked care of by NGINX. Passenger is just used to serve the content to NGINX. NGINX is the Component which does all the heavy lifting in this scenario.

### 4. Reverse Proxy: NGINX
NGINX acts as the connection broker between passenger and the elastic loadbalencer.

I create a piece of config which enables the connection between passenger and the elb. The following is how and where to create it. You can find the nginx.conf file in this directory.

```shell
sudo nano /opt/nginx/conf/nginx.conf
```
The config has a few key parts which enable the heavy lifting. The **passenger_root** and **passenger_ruby** under the **http** heading define the location of the passenger server files so when NGINX starts so does Passenger. The first **server** heading defines the listning connection of 80 and the serverd **root** location from the project. The second **server** heading is defined as the redirect. Specifically, when the elb gets requests on port 80 they are then forwarded onto port 808 and redirected to the load balancer as an https request. There is a location block which defines where the precompiled assets are stored as well as how they are cached and compressed with the NGINX gzip module. I implemented this when Max identified we were not caching and compressing our assets which were decreasing speed.
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

    gzip off;
    sendfile        on;

    server {
        listen            80;
        passenger_enabled on;
        root              /opt/Nwen304-Team12/public;
        location ~ ^/assets/ {
            gzip_static on;

            add_header Cache-Control public;
            expires 4w;
            gzip on;
            gzip_vary on;
            gzip_proxied any;
            gzip_disable "MSIE [1-6]\.";
            gzip_comp_level 6;
            gzip_types text/plain text/css application/json application/javascript application/x-javascript text/javascript text/xml application/xml application/rss+xml application/atom+xml application/rdf+xml image/x-icon image/png image/jpeg image/gif;
        }
    }
    server {
        listen            8080;
        return            301 https://$host$request_uri;
    }
}
```
The next piece of config is loading the environment variables into Passenger using NGINX. This can be achieved with the following command. You can find the relevant file in this directory.

```shell
sudo nano /etc/default/nginx
```
In this case, the environment variables are for specifying the connection variables to the RDS database server and the rails application environment as well as the secret key you generated and saved earlier.
```
export RDS_HOSTNAME=
export RDS_USERNAME=
export RDS_PASSWORD=
export RAILS_ENV=production
export SECRET_KEY_BASE=
```
### 5. Loadbalencer: Amazon ELB
The main purpose of the ELB, in this case, is to do the SSL termination so that the webserver doesn't need to do the decryption of every request which is computationally intensive if a webserver is receiving 100 to 1000's of concurrent requests. It was also given used to show the ability of scaling up instances based on demand meaning using auto scaling the loadbalancer could distribute requests over multiple instances.

The elb was configured with the following security group.

|Type |Port|
|-----|----|
|TCP  |443 |  
|HTTP |80  |
|SSH  |22  |

The elb was configured with the following listeners. The listeners are way of configuring port redirection to the web server as well as hosting an SSL certificate to do SSL termination. The certificate which was generated in the AWS Certificate Manager is tied to the HTTPS listener.

| Load Balancer   Protocol | Load Balancer Port | Instance Protocol | Instance Port |
|--------------------------|--------------------|-------------------|---------------|
| HTTP                     | 80                 | HTTP              | 8080          |
| HTTPS                    | 443                | HTTP              | 80                         |
The elb health check was set to the following. The health check does a periodic get request in this case on the root URL to check the availability of the ec2 instance.

| Ping Target         | HTTP:80/   |
|---------------------|------------|
| Timeout             | 5 seconds  |
| Interval            | 30 seconds |
| Unhealthy threshold | 2          |
| Healthy threshold   | 10         |

The elb was configured with the instance we setup earlier.

### 6. Automating Code Deployment and Integration: Cron Job
I wanted to create an automated method for doing Continuous integration and Continuous deployment. Whats this means is not having to log into the instance and pull down the code and reconfigure the settings every time there is a change. What I did was create a Cron job with a bash script. The script can be seen bellow as well as in the directory. The script is called **cicd.sh**. The job was configured to run every 5 minutes.

```shell
#!/bin/sh
cd /opt/Nwen304-Team12/   # changing to the webserving directory/repo
sudo git stash -u   # stashing nonesential changes
sudo git pull   # pulling latest changes from the repo
export RDS_HOSTNAME=    # environment variable for Database Hostname
export RDS_USERNAME=    # environment variable for Database Username
export RDS_PASSWORD=    # environment variable for Database Password
export RAILS_ENV=production   # environment variable for ruby on rails runtime
sudo bundle install   # updates gems
sudo rake assets:clobber assets:precompile RAILS_ENV=production # deletes old precompiled assets and creates new ones
rake db:migrate   # does latest database migrations
sudo service nginx restart  # restarts NGINX
```
When setting up the Cron job make sure to set the script to executable see following.
```shell
$ sudo chmod +x cicd.sh
```
