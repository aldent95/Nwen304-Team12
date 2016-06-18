#!/bin/bash
RUBY_VERSION=2.3.1
PASSENGER_VERSION=5.0.28

apt-get update
apt-get install -y build-essential libcurl4-openssl-dev zlib1g-dev libpq-dev postgresql-client

wget -q http://cache.ruby-lang.org/pub/ruby/${RUBY_VERSION:0:3}/ruby-$RUBY_VERSION.tar.gz -O /tmp/ruby-$RUBY_VERSION.tar.gz
tar -xzf /tmp/ruby-$RUBY_VERSION.tar.gz -C /tmp
cd /tmp/ruby-$RUBY_VERSION
./configure
make
make install

/usr/local/bin/gem install bundler
/usr/local/bin/gem install rack

wget -q http://s3.amazonaws.com/phusion-passenger/releases/passenger-$PASSENGER_VERSION.tar.gz -O /tmp/passenger-$PASSENGER_VERSION.tar.gz
mkdir -p /var/lib/passenger
tar -xzf /tmp/passenger-$PASSENGER_VERSION.tar.gz -C /var/lib/passenger

echo export PATH=/var/lib/passenger/passenger-$PASSENGER_VERSION/bin:\$PATH > /etc/profile.d/passenger.sh
source /etc/profile

passenger-install-nginx-module --auto
