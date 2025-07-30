# Scripts disponibles

| Script | Description & Usage | Exemple |
|--------|--------------------|---------|
|--------|--------------------|---------|
| 404_count_in_logs | - | "Counts and lists 404 error URLs from log files in a directory. Usage: ./404_count_in_logs /path/to/logs" | - |
| alexa_maj_local | "Fetch Alexa skill files (interaction model and manifest) using the skill ID from .ask/ask-states.json." Parameters: none. | - |
| alexa_push | - | "Usage: [-h] [commit_message] - stages, commits, and pushes changes, then deploys with ask" | - |
| backup | "Backup script using duplicity (params: full, local, or none for incremental)" | - |
| caddy_docker_get_config | Description: Display the autosaved Caddyfile from the caddy container. Parameters: none. | - |
| caddyErrorBind | "Sets CAP_NET_BIND_SERVICE capability on Caddy binary to allow binding to privileged ports (<1024). No parameters." | - |
| cards | "Description: Insert a test card into Nextcloud's Deck database. Parameters: none." | - |
| catlog | "Display colored log file (var/log/{env}-{date}.log) based on log levels (error/warning/info). Parameters: none." | - |
| copyToUsbReal | "Adjust VM dirty memory thresholds: sets dirty_background_bytes to 16MB and dirty_bytes to 48MB." Parameters: none. | - |
| createsite.save | "Clone and setup a new project." Parameters: <destination_directory> <private_git_url> | - |
| crudmickAdd | "Initialize a Symfony project with Docker, install dependencies, and configure security; params: none" | - |
| dbash | - | "Usage: dbash" [-h] [container_name] [shell_path] - Attach to a Docker container's shell (default: current directory name as container, /bin/bash as shell)." | - |
| dbashs | - | "Usage: dbashs" [container-name] [shell-type] - Exec into a PHP container's shell (default: current dir name and bash)." | - |
| dc | - | "Usage: ./dc [-h] [docker-compose-args] - Wrapper for 'docker compose' with same parameters." | - |
| dcup | "Start Docker Compose services in detached mode, automatically detecting compose files (supports docker-compose.yml, .yaml, override.*, local.*)." Parameters: none. | - |
| deepseek-help-adder | "Automatically adds/updates -h help text in bash scripts, with --reset to remove existing help. [--reset] [script files...]" | - |
| desactiver_paste_molette_souris | "Install gnome-tweak-tool: [-h|--help] (show help)" | - |
| dkill | Stop and remove a Docker container; parameters: <container_name> [-h|--help] | - |
| dkillall | "Stop and remove all Docker containers (-h for help)" [parameters: -h, --help] | - |
| dlogs | "Display Docker container logs continuously or a specified number of lines. Parameters: [container_name] [--tail N]" | - |
| dns-refresh | Restart systemd-resolved service; params: [-h for help] | - |
| docker_clean_inused_unmonted | Clean up unused Docker objects (containers, images, volumes, networks) -f: force | - |
| dsh | - | "Usage: [-h] [-c command] [container_name] [command] - Execute command in or enter a Docker container, defaulting to current directory name" | - |
| duu | "Display disk usage for current directory contents (sorted by size) and overall disk space; no parameters." | - |
| exportBd | "Backup PostgreSQL database and uploads folder with parameters: [CONTAINER_NAME DB_NAME PG_USER PG_PASSWORD TIMESTAMP DEST_DIR SITE_DIR] or interactive prompts." | - |
| fast | "Set CPU governor to performance mode for cores 0-7." Parameters: none. | - |
| files_clean | "Clean filenames by replacing special characters in a directory [directory] (-h for help)" | - |
| gac | - | "Usage: ./gac <file> <message> - Stage and commit a file with the given message." [options: -h, --help] | - |
| gacp | - | "Usage: ./gacp [-h] <file> <message> - Stages, commits, and pushes changes to Git." | - |
| gall | - | "Usage: ./gall [-h] <commit_message> - Stage and commit all changes with the given message." | - |
| gc | "Commit changes with optional test bypass (-p|--passtest) or help (-h|--help)." | - |
| gcp | "Automated git workflow with tests, auto-commit messages via Deepseek, and pushes - options: [-f|--force] [-p|--passtest] [-h|--help]" | - |
| gitConfigSSHKey | "Configure Git to use a specific SSH key for the current repository; no parameters." | - |
| gitMergeAll | "Merge all local and remote branches into main, then delete them (-h for help)" [parameters: none] | - |
| git_news.json | "Display git commit history with subjects and dates; parameters: -h (help), --force, --help" | - |
| git_permissions_repair | - | "Usage: git_permissions_repair" [-h] - Reset .git ownership and permissions to current user (755)." | - |
| gitPullBranchs | - | "Usage: ./gitPullBranchs [-h] - Fetches all remote branches and tracks them locally, then pulls all updates." | - |
| gitpullRmModifs | Reset local changes, clean untracked files, and pull latest changes. Parameters: [-h|--help] | - |
| gitResetAndClean | "Reset and clean Git repository: [-h]" | - |
| gitRmBranch | "Delete a Git branch locally and remotely. Parameters: <branch_name>" | - |
| gitSubmoduleRM | "Remove a Git submodule: provide submodule path as parameter." Parameters: <submodule_path> [-h|--help] | - |
| gitSubmodulesConfigMerge | "Configures all git submodules to use rebase on pull; no parameters." | - |
| gitSubmodulesInit | "Initialize and update git submodules recursively (-h for help). Parameters: none." | - |
| gitSubmodulesInstallFrom.gitmodules | "Remove and re-add all git submodules, with optional forced removal using 'gitSubmoduleRM'." Parameters: none. | - |
| gitSubmodulesMergeBranchs | "Fetch, track all remote branches, pull updates, and merge all branches in each submodule. Parameters: none." | - |
| gitSubmodulesOnMain | - | "Usage: ./gitSubmodulesOnMain [-h|--help] - Checkout main branch in all Git submodules" | - |
| gitSubmodulesPullMergeBranchs | - | "Usage: ./gitSubmodulesPullMergeBranchs - Pull and merge all branches in git submodules (params: none)" | - |
| gitSubmodulesUpdate | "Update git submodules to their latest main branch versions. Parameters: none." | - |
| gop | "Force push Git changes, optionally skipping tests (-f|--force, -p|--passtest, -h|--help)" | - |
| gs | "Check Git and submodule statuses. Parameters: none." | - |
| hosts_pub_install | "Install or update Ultimate Hosts Blacklist (requires root, no parameters)" | - |
| hosts_pub_update | "Update system hosts file with Ultimate Hosts Blacklist; parameters: -h, --help" | - |
| image_compress | "Optimize image files (PNG, GIF, TIFF, BMP, JPG, JPEG) in current directory and subdirectories using optipng and jpegoptim." [parameters: -h, --help] | - |
| image_resize | "Resize all JPG/PNG images in a directory to specified dimensions; params: <width>x<height> (e.g., 800x600), directory (optional, defaults to current)." | - |
| importBd | "Reset and import PostgreSQL database: [container] [db] [user] [password] [file]" | - |
| lib | "Utility for interactive prompts (yes/no, input, choice) with parameters: [question] [default] [options...]" | - |
| list_Big_Dirs | "Show top 30 largest files/dirs in /, sorted by size (-h human-readable, -S no subdirs)" | - |
| list_Big_Files | "List top 30 largest files in /, parameters: none" | - |
| machines | "Perform a ping scan (-sn) on the local network (192.168.1.0/24) using sudo nmap." Parameters: [-h] [custom_network_range] | - |
| mouse_remove_paste_by_middle_button | - | "Usage: mouse_remove_paste_by_middle_button" [-h|--help] - Configures mouse pointer acceleration via ~/.Xmodmap" | - |
| nbr_fichiers | "Count files in each directory and sort by count; parameters: -h, --help." | - |
| pdfToEpub | "Convert an ebook to EPUB format with heuristics, justified text, and no cover. Parameters: <input_file>" | - |
| playlist-create | "Generate an M3U playlist from audio files in a directory. Parameters: [directory] (default: current directory)" | - |
| port_application_used | - | "Usage: port_application_used" [-h] <port> - List processes listening on specified port." | - |
| removeCrud | - | "Remove Symfony CRUD files for specified entity - Usage: ./removeCrud <EntityName> [-h|--help]" | - |
| restore | "Restore backups using duplicity: full, file [path], or list; requires BACKUP_URL in .env." [full|file [path]|list] | - |
| rotate-screen | "Rotate screen and input devices between normal/left/inverted/right orientations. Options: -h, --help" | - |
| runC | "Adds current directory as a service to compose.yaml and creates Caddyfile; params: -h, --help" | - |
| runcaddy | "Run Docker container with Caddy reverse proxy, auto-generating configs. Params: none." | - |
| runphp | "Initialize PHP/nginx Docker environment with Caddy proxy (-h for help)" [params: none] | - |
| runsite | "Run Docker Compose for Symfony, auto-generating configs; params: none" | - |
| server-http-from-curent-dir | - | "Usage: [-h] [-p port] - Starts a simple HTTP server on specified port (default: 8000) and displays access URL." | - |
| server-run-command | "Connect to a server and execute a command in a specified directory. Parameters: command (in quotes)." | - |
| server-update-yarn-composer | "Deploy and update project on remote server via SSH, using SERVER_CONNECT and SERVER_DIR from .env." Parameters: none (uses .env file). | - |
| slow | "Set CPU governors to powersave for cores 0-7. Parameters: None." | - |
| suspend | "Configure laptop lid close behavior (--install/--uninstall)" | - |
| svgs_to_pngs | "Convert SVG files to PNG with optional width parameter (default: 1024). Parameters: [width]" | - |
| symfony_create_project | "Install a Symfony project with Docker: ./script.sh PROJECT_NAME [-h|--help]" | - |
| ttl | "Set TTL value (64 for PC, 65 for Phone) - no parameters." | - |
| UDP_buffer_set | - | "Usage: UDP_buffer_set" [-h|--help] - Adjusts kernel network buffer sizes (rmem_max/wmem_max=7500000)." | - |
| Ultimaker-Cura | "Launch Ultimaker Cura 5.2.1 with NVIDIA PRIME render offload support. Parameters: [AppImage options]." | - |
| uneheure | - | "Usage: uneheure" [-h|--help] - Plays beeps for 1 hour; requires 'beep' and pcspkr module." | - |
| vpn_off | - | "Usage: ./vpn_off [-h|--help] - Bring down the WireGuard interface defined in ~/pcmick.conf" | - |
| vpn_on | "Restarts WireGuard VPN, updates routing, and tests connectivity. Parameters: none." | - |
| wget | "Download a file with resuming support, optional speed limit (default: 300k), and insecure SSL; params: URL [speed]" | - |
| wgetn | "Download a file using wget with resume support (-c) and content-disposition, takes a single URL parameter." Parameters: <URL> | - |
| xubuntu_conf_power | "Disables XFCE power saving, screen locking, and suspend features, applies custom desktop settings, and logs out. [No parameters]" | - |

README généré automatiquement à partir des scripts du dossier scripts/.
