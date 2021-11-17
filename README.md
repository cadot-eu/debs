# debs form cadot.info Factory

Install deb by `sudo dpkg -i ...deb`
Install or update all by `sudo dpkg -i *.deb`

## shtodeb
For create deb from bash script
`shtodeb bashFile` and Follow instructions

## gcp 
git and commit with auto tags for package.json
`git -i` for init 

## runsite
Create Docker-compose.yml if don't exist with the actual directory and return port for http://localhost:...
I use symfony5 docker image and port 80

## local-update-db-public
Update local db and public from distant server.
He activate maintenace mode.
He use .env parameters
```bash
SERVER_CONNECT=user@ip or name
SERVER_DIR=/home/.../...
```
## server-update-yarn-composer
Update distant by github, composer and yarn from .env and use maintenance mode
```bash
SERVER_CONNECT=user@ip or name
SERVER_DIR=/home/.../...
```
## server-run-command
run a command in the distant server from .env

`server-run-command "ls"`

```bash
SERVER_CONNECT=user@ip or name
SERVER_DIR=/home/.../...
```
## docker-kill-all
kill all docker and remove
`docker-kill-all`

## docker-kill
kill docker and remove
`docker-kill nameOfDocker`

## deocker-bash
enter in bash from docker, name is currrent directory /web/test ... test is the docker name
`docker-bash`

## server-http-from-current-dir
run a http server on port 8000 on current dir
`server-http-from-current-dir`

## rotate screen
rotate screen and touch
`rotate-screeen`
