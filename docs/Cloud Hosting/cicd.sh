cd /opt/Nwen304-Team12/   # changing to the webserving directory/repo
sudo git stash -u   # stashing non esential changes
sudo git pull   # pulling lattedt changes from repo
export RDS_HOSTNAME=    # enviroment varible for Database Hostname
export RDS_USERNAME=    # enviroment varible for Database Username
export RDS_PASSWORD=    # enviroment varible for Database Password
export RAILS_ENV=production   # enviroment varible for ruby on rails runtime
sudo bundle install   # updates gems
sudo rake assets:clobber assets:precompile RAILS_ENV=production # deletes old precompiled assets and creates new ones
rake db:migrate   # does latest database migrations
sudo service nginx restart  # restarts NGINX
