# Database Server
For this we use AWS RDS. Specifically I configured a RDS instance with PostgreSQL 9.4.7 with the port 5432 and with a database called **Nwen304_Team12_production**. I set the instance size to db.t2.micro with 5 GB of General Purpose (SSD). I se the availability zone to be the same as the EC2 instance **ap-southeast-2c**. The security group was set to the following.

|Type |Port|
|-----|----|
|TCP  |5432|

The database was configured to only talk over SSL for security.
