# Cloud Hosting
We decided we were going to do Ruby on Rails app so we decided that AWS(Amazon Web Services) would be the best place to host it.

### Components of Hosting
1. Webserver Host: Amazon EC2
2. Webserver: Passenger
3. Reverse Proxy: NGINX
4. Loadbalencer: Amazon ELB
5. Database: Amazon RDS
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
This script can be seen is this directory. This installed Passenger which is the ruby webserver, NGINX the reverse proxy and the postgres development library and the postgres client for testing and conecting to the database.

Once you have this script in your home directory you are going to want to make the script executable see following.
```shell
$ sudo chmod +x setup.s
```
Then run the script with the following comand.
```shell
$ ./setup.sh
```
This will take around 10 minutes, once this is completed you should have everything installed.
