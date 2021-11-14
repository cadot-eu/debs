#connect at server by parameter in .env
#SERVER_CONNECT=user@ip or name
#SERVER_DIR=/home/.../...

#get parameters
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi
#name of ssh user
arrIN=(${SERVER_CONNECT//@/ })
NAME=${arrIN[0]}

if [ -n "$SERVER_DIR" ] || [-n "$SERVER_CONNECT"]; then
    echo "----change propriotary of local var ---"
    sudo chown $USER: var/ -R
    echo "----change propriotary of local server----"
    sudo chown $USER: public -R
    echo "----get the data.db of server----"
    scp $SERVER_CONNECT:$SERVER_DIR/var/data.db var/data.db
    echo "----server on maintenance----"
    ssh $SERVER_CONNECT "cd $SERVER_DIR && sh crudmick/maintenance.sh on"
    echo "----change propriotary of public server----"
    ssh $SERVER_CONNECT "cd $SERVER_DIR && sudo chown $NAME: public -R"
    echo "----change propriotary of local var ---"
    sudo chown www-data: var -R
    echo "----download the uploads of server----"
    sudo chown $USER: public -R
    if [ -d "public/uploads" ]; then
        rsync -aP $SERVER_CONNECT:$SERVER_DIR/public/uploads/* public/uploads/.
    fi
    if [ -d "public/upload" ]; then
        rsync -aP $SERVER_CONNECT:$SERVER_DIR/public/upload/* public/upload/.
    fi
    if [ -d "public/embed" ]; then
        rsync -aP $SERVER_CONNECT:$SERVER_DIR/public/embed/* public/embed/.
    fi
    echo "----change propriotary of public server----"
    ssh $SERVER_CONNECT "cd $SERVER_DIR && sudo chown www-data: public -R"
    echo "----server off maintenance----"
    ssh $SERVER_CONNECT "cd $SERVER_DIR && sh crudmick/maintenance.sh off"
    echo "----change propriotary of local server----"
    sudo chown www-data: public -R
else
    echo "parameters empty in .env, get SERVER_CONNECT and SERVER_DIR"
fi
