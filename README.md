# Scripts disponibles

| Script | Description | Usage | Exemple |
|--------|-------------|-------|---------|
|--------|-------------|-------|---------|
| 404_count_in_logs | - | Counts and lists 404 error URLs from log files in a directory. Usage: /home/michael/bin/404_count_in_logs /path/to/logs | - |
| alexa_maj_local | - | - | - |
| alexa_push | - | Usage: [-h] [commit_message] - stages, commits, and pushes changes, then deploys with ask | - |
| backup | - | - | - |
| caddy_docker_get_config | Description: Display the autosaved Caddyfile from the caddy container. Parameters: none. | - | - |
| caddyErrorBind | - | - | - |
| cards | Description: Insert a test card into Nextcloud's Deck database. Parameters: none. | - | - |
| catlog | Display colored log file (var/log/{env}-{date}.log) based on log levels (error/warning/info). Parameters: none. | - | - |
| copyToUsbReal | Adjust VM dirty memory thresholds: sets dirty_background_bytes to 16MB and dirty_bytes to 48MB. Parameters: none. | - | - |
| createsite.save | Clone and setup a new project: requires destination directory and private git URL as parameters. Parameters: <destination_directory> <private_git_url> | - | - |
| crudmickAdd | Initialize a Symfony project with Docker, install dependencies, and configure security | - | - |
| dbash | - | - | - |
| dbashs | - | - | - |
| dc | - | Usage: /home/michael/bin/dc [-h] [docker-compose-args] - Wrapper for docker compose with same parameters. | - |
| dcup | - | - | - |
| deepseek-help-adder | Automatically adds or updates -h help text in bash scripts, with --reset to remove existing help. [--reset] [script files...] | - | - |
| desactiver_paste_molette_souris | - | - | - |
| dkill | Stop and remove a Docker container; parameters: <container_name> | - | - |
| dkillall | - | - | - |
| dlogs | Display Docker container logs continuously or a specified number of lines. Parameters: [container_name] [--tail N] | - | - |
| dns-refresh | Restart systemd-resolved service | - | - |
| docker_clean_inused_unmonted | - | - | - |
| dsh | - | Usage: [-h] [-c command] [container_name] [command] - Execute command in or enter a Docker container, defaulting to current directory name | - |
| duu | - | - | - |
| exportBd | Backup PostgreSQL database and uploads folder with parameters: [CONTAINER_NAME DB_NAME PG_USER PG_PASSWORD TIMESTAMP DEST_DIR SITE_DIR] or interactive prompts. | - | - |
| fast | Set CPU governor to performance mode for cores 0-7. Parameters: none. | - | - |
| files_clean | - | - | - |
| gac | - | - | - |
| gacp | - | - | - |
| gall | - | - | - |
| gc | - | - | - |
| gcp | - | - | - |
| gitConfigSSHKey | Configure Git to use a specific SSH key for the current repository | - | - |
| gitMergeAll | - | - | - |
| git_news.json | Display git commit history with subjects and dates; parameters: -h (help), --force, --help | - | - |
| git_permissions_repair | - | - | - |
| gitPullBranchs | - | Usage: /home/michael/bin/gitPullBranchs [-h] - Fetches all remote branches and tracks them locally, then pulls all updates. | - |
| gitpullRmModifs | Reset local changes, clean untracked files, and pull latest changes. Parameters: None. | - | - |
| gitResetAndClean | - | - | - |
| gitRmBranch | - | - | - |
| gitSubmoduleRM | Remove a Git submodule: provide submodule path as parameter. | - | - |
| gitSubmodulesConfigMerge | Configures all git submodules to use rebase on pull | - | - |
| gitSubmodulesInit | - | - | - |
| gitSubmodulesInstallFrom.gitmodules | Remove and re-add all git submodules, with optional forced removal using gitSubmoduleRM. Parameters: none. | - | - |
| gitSubmodulesMergeBranchs | Fetch, track all remote branches, pull updates, and merge all branches in each submodule. Parameters: none. | - | - |
| gitSubmodulesOnMain | - | Usage: /home/michael/bin/gitSubmodulesOnMain [-h] - Checkout main branch in all Git submodules | - |
| gitSubmodulesPullMergeBranchs | - | - | - |
| gitSubmodulesUpdate | Update git submodules to their latest main branch versions. Parameters: none. | - | - |
| gop | - | - | - |
| gs | Check Git and submodule statuses. Parameters: none. | - | - |
| hosts_pub_install | - | - | - |
| hosts_pub_update | Update system hosts file with Ultimate Hosts Blacklist | - | - |
| image_compress | - | - | - |
| image_resize | - | - | - |
| importBd | Reset and import PostgreSQL database: [container] [db] [user] [password] [file] | - | - |
| lib | - | - | - |
| list_Big_Dirs | - | - | - |
| list_Big_Files | List top 30 largest files in /, parameters: none | - | - |
| machines | - | - | - |
| mouse_remove_paste_by_middle_button | - | Usage: mouse_remove_paste_by_middle_button [-h] - Configures mouse pointer acceleration via /home/michael/.Xmodmap. | - |
| nbr_fichiers | Count files in each directory and sort by count | - | - |
| nextcloud_list_conflits | - | - | - |
| nextcloud_rm_conflits | - | - | - |
| pdfToEpub | Convert an ebook file to EPUB format with heuristics, justified text, and no cover. Parameters: <input_file> | - | - |
| playlist-create | Generate an M3U playlist from audio files in a directory. Parameters: [directory] (default: current directory) | - | - |
| port_application_used | - | - | - |
| removeCrud | - | - | - |
| restore | Restore backups using duplicity: full, file [path], or list | - | - |
| rotate-screen | Rotate screen and input devices between normal/left/inverted/right orientations. | - | - |
| runC | Adds current directory as a service to compose.yaml and creates Caddyfile | - | - |
| runcaddy | Run Docker container with Caddy reverse proxy, auto-generating configs. Params: none. | - | - |
| runphp | - | - | - |
| runsite | Run Docker Compose for Symfony, auto-generating configs | - | - |
| server-http-from-curent-dir | - | - | - |
| server-run-command | - | - | - |
| server-update-yarn-composer | Deploy and update project on remote server via SSH, using SERVER_CONNECT and SERVER_DIR from .env. Parameters: none (uses .env file). | - | - |
| slow | Set CPU governors to powersave for cores 0-7. Parameters: None. | - | - |
| suspend | - | - | - |
| svgs_to_pngs | Convert SVG files to PNG with optional width parameter (default: 1024). Parameters: [width] | - | - |
| symfony_create_project | Install a Symfony project with Docker: ./script.sh PROJECT_NAME | - | - |
| ttl | Set TTL value (64 for PC, 65 for Phone) - no parameters. | - | - |
| UDP_buffer_set | - | - | - |
| Ultimaker-Cura | Launch Ultimaker Cura 5.2.1 with NVIDIA PRIME render offload support. Parameters: [AppImage options]. | - | - |
| uneheure | - | - | - |
| vpn_off | - | Usage: /home/michael/bin/vpn_off [-h] - Bring down the WireGuard interface defined in /home/michael/pcmick.conf | - |
| vpn_on | Description: Restarts a WireGuard VPN connection, updates routing, and tests connectivity. Parameters: none. | - | - |
| wget | - | - | - |
| wgetn | - | - | - |
| xubuntu_conf_power | Disables XFCE power saving, screen locking, and suspend features, applies custom desktop settings, and logs out. [No parameters] | - | - |

README généré automatiquement à partir des scripts du dossier scripts/.
