# Scripts disponibles

| Script | Description/Usage/Exemple |
|--------|--------------------------|
| 404-count-in-logs | Analyzes log files for 404 errors, counting occurrences per URL. Usage: /home/michael/bin/404-count-in-logs /path/to/logs |
| backup | Backup script using duplicity: [full|local] (parameters: BACKUP_URL from .env) |
| caddy-error-bind | Sets CAP_NET_BIND_SERVICE capability on Caddy binary to allow binding to privileged ports ([<1024]). Usage: [-h] [-v] |
| catlog | Display colored log file (params: none) |
| dbash | Usage: dbash" [-h] [container_name] [shell_type] - Attach to a Docker container's shell (default: current directory name, bash). |
| dbash | Usage: dbash [-h] [container_name] [shell_type] - Attach to a Docker container's shell (default: current directory name, bash). |
| dc | Run docker-compose with given arguments (e.g., up, down, build, logs, etc.). |
| deepseek-help-adder | Automatically adds/updates shebang and help (-h/--help) blocks in bash scripts, parameters: script files... |
| desactiver-paste-molette-souris | Install gnome-tweak-tool: [-h] (no parameters) |
| dkill | Stop and remove a Docker container. Parameters: <container_name> |
| dkillall | Stop all Docker containers and optionally clean up resources; parameters: [--force] [--clean] |
| dlogs | Display Docker container logs continuously or a specified number of lines. Parameters: [container_name] [--tail N] |
| dns-refresh | Restart systemd-resolved service; usage: [-h] |
| docker-clean-inused-unmonted | Clean up unused Docker objects (containers, images, volumes, networks) - accepts no parameters. |
| dsh | Execute commands in a Docker container (params: [-c] [container_name] [command...]) |
| duu | Display disk usage for current directory contents (sorted by size) and overall disk space; supports -h for human-readable output." Parameters: -h (human-readable sizes). |
| duu | Display disk usage for current directory contents (sorted by size) and overall disk space; supports -h for human-readable output. Parameters: -h (human-readable sizes). |
| export-db | Backup PostgreSQL database and uploads folder: [-h] [container_name db_name pg_user pg_password timestamp dest_dir site_dir] |
| fast | Set CPU governor to performance mode for cores 0-7." Parameters: none. |
| fast | Set CPU governor to performance mode for cores 0-7. Parameters: none. |
| files-clean | Clean filenames by replacing special chars in a directory [directory] (-h for help) |
| gcp | Commit helper with auto-message generation via Deepseek API. Options: -f/--force, -p/--passtest, -h/--help. |
| git-add-private | Génère une clé SSH privée pour le repository fourni (URL obligatoire), affiche la clé publique à ajouter sur GitHub, propose l'URL directe pour l'ajout, puis clone le repository en utilisant la clé générée. Usage : ./git-add-private https://github.com/owner/repo |
| git-configs-ssh-key | Configure Git to use a specific SSH key for the current repository (-h for help). Parameters: none. |
| git-news.json | Display commit history with subjects and dates; parameters: -h (help), --force, --help, or commit subjects. |
| git-permissions-repair | Usage: git-permissions-repair" [-h] - Reset .git ownership and permissions to current user (755). |
| git-reset-clean | Usage: /home/michael/bin/git-reset-clean [-h] - Resets and cleans a git repo (hard reset, force clean), requires sudo. |
| git-submodule-instal-from.gitmodules | Remove and re-add all git submodules: [-h] |
| hosts-pub-install | Install or update the Ultimate Hosts Blacklist (parameters: none) |
| hosts-pub-update | Updates the system's hosts file using Ultimate Hosts Blacklist; parameters: none |
| http-from-current-dir | Usage: [-h] [-p port] - Starts a simple HTTP server on specified port (default: 8000) and displays access URL. |
| image-compress | Optimize image files (PNG, GIF, TIFF, BMP, JPG, JPEG) in current directory and subdirectories using optipng and jpegoptim." Parameters: none. |
| image-compress | Optimize image files (PNG, GIF, TIFF, BMP, JPG, JPEG) in current directory and subdirectories using optipng and jpegoptim. Parameters: none. |
| image-resize | Resize all JPG/JPEG/PNG images in a directory to specified dimensions, e.g., 800x600. Parameters: <dimensions> [directory]. |
| image-resize | Resize all JPG/JPEG/PNG images in a directory to specified dimensions, e.g., 800x600. Parameters: [dimensions] [directory]. |
| import-db | Reset and import PostgreSQL database: [container] [db] [user] [password] [file] |
| list-big-dirs | Show top 30 largest files/directories in /, sorted by size (-h human-readable, -S no subdirs, -r reverse, -n numeric sort) |
| list-big-files | List top 30 largest files in /, parameters: none |
| machines | Perform a ping scan (-sn) on the local network (192.168.1.0/24) using nmap with sudo." Parameters: [-h] |
| nbr-fichiers | Count files in each subdirectory, sorted by count; parameters: none. |
| pd-pub | Convert an ebook file to EPUB format with heuristics, justified text, no first image, and no default cover. Parameters: <input_file> |
| pd-pub | Convert an ebook file to EPUB format with heuristics, justified text, no first image, and no default cover. Parameters: [input_file] |
| playlist-create | Generate an M3U playlist for audio files in a directory; parameters: [directory] (default: current directory) |
| port-application-used | Usage: port-application-used" [-h] <port> - List processes listening on specified port; -h shows help. |
| port-application-used | Usage: port-application-used [-h] [port] - List processes listening on specified port; -h shows help. |
| readme-generate | Generate README.md from script help texts (-h); parameters: none. |
| restore | Restore backups using duplicity: full, file [path], or list; requires BACKUP_URL in .env. |
| rotate-screen | Rotate screen and input devices (parameters: none). |
| runcaddy | Run Docker container with Caddy reverse proxy, parameters: none. |
| runsite | Run Docker Compose with current directory as service name, auto-generate configs if missing; params: none |
| slow | Set all CPU cores to powersave mode: [-h] |
| svgs-to-pngs | Convert SVG files to PNG with optional width (default: 1024). Usage: script.sh [width] |
| ttl | Set default IPv4 TTL (64 for PC, 65 for Phone). No parameters. |
| udp-buffer-set | Usage: udp-buffer-set" [-h] - Adjusts kernel network buffer sizes (rmem_max/wmem_max=7500000). |
| udp-buffer-set | Usage: udp-buffer-set [-h] - Adjusts kernel network buffer sizes (rmem_max/wmem_max=7500000). |
| uneheure | Usage: uneheure" [-h] - Plays a series of beeps for 1 hour; no parameters required. |
| uneheure | Usage: uneheure [-h] - Plays a series of beeps for 1 hour; no parameters required. |
| usb-copy-real | Adjust VM dirty memory thresholds: sets dirty_background_bytes to 16MB and dirty_bytes to 48MB." No parameters. |
| usb-copy-real | Adjust VM dirty memory thresholds: sets dirty_background_bytes to 16MB and dirty_bytes to 48MB. No parameters. |
| wget | Download a file from URL (parameter 1) with resuming support, optional rate limit (parameter 2, default: 300k), ignoring SSL, saving with original name." Parameters: <URL> [rate_limit] |
| wget | Download a file from URL (parameter 1) with resuming support, optional rate limit (parameter 2, default: 300k), ignoring SSL, saving with original name. Parameters: [URL] [rate_limit] |
| git-add-private | Génère une clé SSH privée pour le repository fourni (URL obligatoire), affiche la clé publique à ajouter sur GitHub, propose l'URL directe pour l'ajout, puis clone le repository en utilisant la clé générée. Usage : ./git-add-private [https://github.com/owner/repo] |
| wgetn | Download a file using wget with resume support (-c) and content-disposition, takes a single URL parameter. |
| xubuntu-conf-power | Description: Disables screen locking, suspend, and power management in XFCE, applies personal settings, and logs out. No parameters. |

README généré automatiquement à partir des scripts du dossier scripts/.
