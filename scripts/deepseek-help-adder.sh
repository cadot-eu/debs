#!/bin/bash
if [[ "$1" == "-h" ]]; then echo ""Automatically adds or updates -h help text in bash scripts, with --reset to remove existing help." [--reset] [script files...]"; exit 0; fi

# Check if any arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [--reset] [script files...]"
    exit 1
fi

# Load .env.local only from ~/debs or ~/git/debs (never local)
if [ -f "$HOME/debs/.env.local" ]; then
    export $(grep -v '^#' "$HOME/debs/.env.local" | xargs)
    elif [ -f "$HOME/git/debs/.env.local" ]; then
    export $(grep -v '^#' "$HOME/git/debs/.env.local" | xargs)
fi

# Iterate over all provided files
for script in "$@"; do
    echo "[DEBUG] Processing $script..."
    
    # Check if it's a file and executable
    if [[ -f "$script" && -x "$script" ]]; then
        echo "[DEBUG] $script is an executable file"
        
        # Check and add shebang if necessary
        shebang=$(head -n 1 "$script")
        if [[ ! "$shebang" =~ ^#!/bin/(ba|z|)sh ]]; then
            echo "[INFO] $script does not have a bash/sh shebang on the first line. Automatically adding '#!/bin/bash'." >&2
            tmpfile=$(mktemp)
            echo '#!/bin/bash' > "$tmpfile"
            cat "$script" >> "$tmpfile"
            mv "$tmpfile" "$script"
            chmod +x "$script"
            echo "[INFO] Shebang added to $script."
        fi
        
        echo "[DEBUG] Shebang of $script: $shebang"
        
        if [[ "$shebang" =~ ^#!/bin/(ba|z|)sh ]]; then
            echo "[DEBUG] Valid shebang for $script"
            
            # If --reset, remove any existing -h block
            if [[ "$1" == "--reset" ]]; then
                echo "[DEBUG] Reset mode for $script"
                tmpfile=$(mktemp)
                # Remove multi-line -h blocks and single-line -h blocks
                awk 'BEGIN{skip=0}
                    /^if \[\[ "\$1" == "-h"/ && /fi$/ {next}
                    /^if \[\[ "\$1" == "-h"/ {skip=1; next}
                    skip && /^fi/ {skip=0; next}
                !skip {print}' "$script" > "$tmpfile"
                mv "$tmpfile" "$script"
                echo "[INFO] -h block removed from $script"
            fi
            
            # Check if a -h block already exists
            if grep -q 'if \[\[ "\$1" == "-h"' "$script"; then
                echo "[INFO] -h block already present in $script, skipping."
                continue
            fi
            
            # Add the -h block only if it doesn't exist
            if [[ -n "$DEEPSEEK" ]]; then
                TMP_JSON=$(mktemp)
                prompt="Provide only a very short one-line description for this bash script (for the -h option), also listing possible parameters. Provide nothing else."
                # Escape the code to avoid formatting issues
                script_content=$(sed ':a;N;$!ba;s/\n/\\n/g;s/\"/\\\"/g' "$script")
                jq -n --arg prompt "$prompt" --arg content "$script_content" '{
                    model: "deepseek-chat",
                    messages: [
                        {role: "system", content: "You are an assistant that generates help for bash scripts."},
                        {role: "user", content: ($prompt + "\n" + $content)}
                    ]
                }' > "$TMP_JSON"
                raw_response=$(curl -s -X POST https://api.deepseek.com/v1/chat/completions \
                    -H "Content-Type: application/json" \
                    -H "Authorization: Bearer $DEEPSEEK" \
                --data-binary "@${TMP_JSON}" | jq -r '.choices[0].message.content')
                rm -f "$TMP_JSON"
                helptext="$raw_response"
                if [[ -z "$helptext" || "$helptext" == "null" ]]; then
                    helptext="Script $script: utility script (add a description here)"
                fi
                elif command -v deepseek &>/dev/null; then
                helptext=$(deepseek --prompt "In one line, provide a very short description of this bash script for the -h option, also listing possible parameters." "$script" 2>/dev/null)
                if [[ -z "$helptext" ]]; then
                    helptext="Script $script: utility script (add a description here)"
                fi
            else
                helptext="Script $script: utility script (add a description here)"
            fi
            
            tmpfile=$(mktemp)
            # Place the -h block right after the shebang
            {
                echo "$shebang"
                echo -e "if [[ \"\$1\" == \"-h\" ]]; then echo \"$helptext\"; exit 0; fi"
                tail -n +2 "$script"
            } > "$tmpfile"
            mv "$tmpfile" "$script"
            chmod +x "$script"
            echo "[INFO] -h block generated/added to $script"
        else
            echo "[DEBUG] Invalid shebang for $script, ignored"
        fi
    else
        echo "[DEBUG] $script is not an executable file, ignored"
    fi
    echo "[DEBUG] Finished processing $script"
done

echo "[DEBUG] Finished processing all files"
