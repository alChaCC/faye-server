References:

[faye-websockets-part-1](https://www.driftingruby.com/episodes/faye-websockets-part-1)

[faye-websockets-part-2](https://www.driftingruby.com/episodes/faye-websockets-part-2)

[How to Use Faye as a Real-Time Push Server in Rails](http://code.tutsplus.com/tutorials/how-to-use-faye-as-a-real-time-push-server-in-rails--net-22600)

## Step1. Install Ruby environment in Ubuntu

Reference: [https://gorails.com/deploy/ubuntu/14.04](https://gorails.com/deploy/ubuntu/14.04)

### Add user
```
sudo adduser deploy
sudo adduser deploy sudo
su deploy
```
### Make sure you can login using new user

```
cd ~
mkdir .ssh
cd .ssh
vim authorized_keys
```
then put the content in `~/.ssh/id_rsa.pub` in your *local machine* into it.

### Install Ruby and RVM

```
sudo apt-get update

sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev

sudo apt-get install libgdbm-dev libncurses5-dev automake libtool bison libffi-dev

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

curl -L https://get.rvm.io | bash -s stable

source ~/.rvm/scripts/rvm

rvm install 2.2.3

gem install bundler
```

### Create fake SSL for thin server

```
mkdir -p /home/deploy/faye-server/shared/thin/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /home/deploy/faye-server/shared/thin/ssl/thin.key -out /home/deploy/faye-server/shared/thin/ssl/thin.crt
```

### Create .env file
`vim /home/deploy/faye-server/shared/.env`

put like this

```
AUTH_TOKEN: 'your_secret'
```

### Create thin.yml file
ps. copied from `config/thin.yml.example`
`vim /home/deploy/faye-server/shared/config/thin.yml`
```
port: 8080
user: deploy
group: deploy
pid: /home/deploy/faye-server/current/faye/pids/thin.pid
timeout: 30
wait: 30
log: /home/deploy/faye-server/current/log/thin.log
max_conns: 4096
require: []
environment: production
max_persistent_conns: 1024
servers: 1
threaded: true
no-epoll: true
daemonize: true
chdir: /home/deploy/faye-server/current
tag: faye
ssl: true
ssl-key-file: /home/deploy/faye-server/current/thin/ssl/thin.key
ssl-cert-file: /home/deploy/faye-server/current/thin/ssl/thin.crt
ssl-disable-verify: true

```

## Step2. Clone the project

```
git clone https://github.com/alChaCC/faye-server.git
```

### Update Some Configurations

*config/deploy/staging.rb*

```
server 'your server ip'
```

## Step3. Deployment

```
cap staging deploy
```

## How to test?

Before start you have to update the *IP* in `faye-server/test/index.html` and `faye-server/test/test.rb`

Then

```
cd faye-server/test
python -m SimpleHTTPServer 8000
```

Now you can open browser and type `http://localhost:8000/`

Then, you can type

```
irb
require './test'
t = SimpleTest.new
t.tester(1, 10)
```
