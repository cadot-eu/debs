# debs form cadot.info Factory

Install deb by `sudo dpkg -i ...deb`

## shtodeb
for create deb from bash script
Follow instructions

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

