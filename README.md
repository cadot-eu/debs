# Scripts disponibles

| Script | Description/Usage/Exemple |
|--------|--------------------|---------|
| 404-count-in-logs | Counts and lists 404 error URLs from log files in a directory. Usage: /home/michael/bin/404-count-in-logs /path/to/logs |
| backup | Backup script using duplicity (params: full, local, or none for incremental) |
| cadd-rro-ind | Sets CAP_NET_BIND_SERVICE capability on Caddy binary to allow binding to privileged ports (<1024). No parameters. |
| catlog | Display colored log file (var/log/{env}-{date}.log) based on log levels (error/warning/info). Parameters: none. |
| cop-s-eal | Adjust VM dirty memory thresholds: sets dirty_background_bytes to 16MB and dirty_bytes to 48MB." Parameters: none. |
| dbash | Usage: dbash" [-h] [container_name] [shell_path] - Attach to a Docker container's shell (default: current directory name as container, /bin/bash as shell). |
| dc | Usage: /home/michael/bin/dc [-h] [docker-compose-args] - Wrapper for 'docker compose' with same parameters. |
| deepseek-help-adder | Automatically adds/updates -h help text in bash scripts, with --reset to remove existing help. [--reset] [script files...] |
| desactiver-paste-molette-souris | Install gnome-tweak-tool: [-h|--help] (show help) |
| dkill | Stop and remove a Docker container; parameters: <container_name> [-h|--help] |
| dkillall | Stop and remove all Docker containers, with options: [--force] [--clean] |
| dlogs | Display Docker container logs continuously or a specified number of lines. Parameters: [container_name] [--tail N] |
| dns-refresh | Restart systemd-resolved service; params: [-h for help] |
| docker-clean-inused-unmonted | Clean up unused Docker objects (containers, images, volumes, networks) -f: force |
| dsh | Usage: [-h] [-c command] [container_name] [command] - Execute command in or enter a Docker container, defaulting to current directory name |
| duu | Display disk usage for current directory contents (sorted by size) and overall disk space; no parameters. |
| expor-d | Backup PostgreSQL database and uploads folder with parameters: [CONTAINER_NAME DB_NAME PG_USER PG_PASSWORD TIMESTAMP DEST_DIR SITE_DIR] or interactive prompts. |
| fast | Set CPU governor to performance mode for cores 0-7." Parameters: none. |
| files-clean | Clean filenames by replacing special characters in a directory [directory] (-h for help) |
| gcp | Automated git workflow with tests, auto-commit messages via Deepseek, and pushes - options: [-f|--force] [-p|--passtest] [-h|--help] |
| gi-erg-ll | Merge all local and remote branches into main, then delete them (-h for help)" [parameters: none] |
| gi-ese-n-lean | Reset and clean Git repository: [-h] |
| gi-onfi-shkey | Configure Git to use a specific SSH key for the current repository; no parameters. |
| gi-ranch | Delete a Git branch locally and remotely. Parameters: <branch_name> |
| git-news.json | Display git commit history with subjects and dates; parameters: -h (help), --force, --help |
| git-permissions-repair | Usage: git-permissions-repair" [-h] - Reset .git ownership and permissions to current user (755). |
| gitpul-odifs | Reset local changes, clean untracked files, and pull latest changes. Parameters: [-h|--help] |
| gi-ubmodule-ain | Usage: /home/michael/bin/gi-ubmodule-ain [-h|--help] - Checkout main branch in all Git submodules |
| gi-ubmodule-erg-ranchs | Fetch, track all remote branches, pull updates, and merge all branches in each submodule. Parameters: none. |
| gi-ubmodule-nit | Initialize and update git submodules recursively (-h for help). Parameters: none. |
| gi-ubmodule-nstal-rom.gitmodules | Remove and re-add all git submodules, with optional forced removal using 'gitSubmoduleRM'." Parameters: none. |
| gi-ubmodule-onfi-erge | Configures all git submodules to use rebase on pull; no parameters. |
| gi-ubmodule-pdate | Update git submodules to their latest main branch versions. Parameters: none. |
| gi-ubmodule-ul-erg-ranchs | Usage: /home/michael/bin/gi-ubmodule-ul-erg-ranchs - Pull and merge all branches in git submodules (params: none) |
| gi-ubmodul-m | Remove a Git submodule: provide submodule path as parameter." Parameters: <submodule_path> [-h|--help] |
| gi-ul-ranchs | Usage: /home/michael/bin/gi-ul-ranchs [-h] - Fetches all remote branches and tracks them locally, then pulls all updates. |
| gs | Check Git and submodule statuses. Parameters: none. |
| hosts-pub-install | Install or update Ultimate Hosts Blacklist (requires root, no parameters) |
| hosts-pub-update | Update system hosts file with Ultimate Hosts Blacklist; parameters: -h, --help |
| http-from-current-dir | Usage: [-h] [-p port] - Starts a simple HTTP server on specified port (default: 8000) and displays access URL. |
| image-compress | Optimize image files (PNG, GIF, TIFF, BMP, JPG, JPEG) in current directory and subdirectories using optipng and jpegoptim." [parameters: -h, --help] |
| image-resize | Resize all JPG/PNG images in a directory to specified dimensions; params: <width>x<height> (e.g., 800x600), directory (optional, defaults to current). |
| impor-d | Reset and import PostgreSQL database: [container] [db] [user] [password] [file] |
| list-big-dirs | Show top 30 largest files/dirs in /, sorted by size (-h human-readable, -S no subdirs) |
| list-big-files | List top 30 largest files in /, parameters: none |
| machines | Perform a ping scan (-sn) on the local network (192.168.1.0/24) using sudo nmap." Parameters: [-h] [custom_network_range] |
| nbr-fichiers | Count files in each directory and sort by count; parameters: -h, --help. |
| pd-pub | Convert an ebook to EPUB format with heuristics, justified text, and no cover. Parameters: <input_file> |
| playlist-create | Generate an M3U playlist from audio files in a directory. Parameters: [directory] (default: current directory) |
| port-application-used | Usage: port-application-used" [-h] <port> - List processes listening on specified port. |
| readme-generate | Generate README.md table from script help texts (-h options) in the scripts directory. Parameters: none. |
| restore | Restore backups using duplicity: full, file [path], or list; requires BACKUP_URL in .env." [full|file [path]|list] |
| rotate-screen | Rotate screen and input devices between normal/left/inverted/right orientations. Options: -h, --help |
| runcaddy | Run Docker container with Caddy reverse proxy, auto-generating configs. Params: none. |
| runsite | Run Docker Compose for Symfony, auto-generating configs; params: none |
| slow | Set CPU governors to powersave for cores 0-7. Parameters: None. |
| svgs-to-pngs | Convert SVG files to PNG with optional width parameter (default: 1024). Parameters: [width] |
| ttl | Set TTL value (64 for PC, 65 for Phone) - no parameters. |
| udp-buffer-set | Usage: udp-buffer-set" [-h|--help] - Adjusts kernel network buffer sizes (rmem_max/wmem_max=7500000). |
| uneheure | Usage: uneheure" [-h|--help] - Plays beeps for 1 hour; requires 'beep' and pcspkr module. |
| wget | Download a file with resuming support, optional speed limit (default: 300k), and insecure SSL; params: URL [speed] |
| wgetn | Download a file using wget with resume support (-c) and content-disposition, takes a single URL parameter." Parameters: <URL> |
| xubuntu-conf-power | Disables XFCE power saving, screen locking, and suspend features, applies custom desktop settings, and logs out. [No parameters] |

README généré automatiquement à partir des scripts du dossier scripts/.
