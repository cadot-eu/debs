#!/bin/bash
my_dir="$(dirname "$0")"
source "$my_dir/lib.sh"
# ---------------------------------------------------------------------------- #

docker exec -i mariadb mysql -uroot -D nextcloud -parowana <<EOF
INSERT INTO oc_deck_cards (\`id\`, \`title\`, \`description\`, \`description_prev\`, \`stack_id\`, \`type\`, \`last_modified\`, \`last_editor\`, \`created_at\`, \`owner\`, \`order\`, \`archived\`, \`duedate\`, \`notified\`, \`deleted_at\`) VALUES (NULL, "tests", "", "", "125", "plain", "1675253824", "mickadmin", "1675253792", "mickadmin", "2000", "0", NULL, "0", "0");
EOF
