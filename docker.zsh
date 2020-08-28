alias dcup='docker-compose -f $(ls -l | grep \.yml | awk '\''{print $8}'\'' | peco) up -d'
alias dcdown='docker-compose -f $(ls -l | grep \.yml | awk '\''{print $8}'\'' | peco) down'
alias dps='docker ps --format "{{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Command}}\t{{.RunningFor}}"'
alias dexec='docker exec -it `dps | peco | cut -f 1` /bin/bash'
