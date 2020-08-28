# gcloudのconfigurationを切り替える
function gconf() {
  CONFIG=$(gcloud config configurations list | peco)
  if [ -n "$CONFIG" ]; then  
    CONFIG_NAME=$(echo ${CONFIG} | awk '{print $1}')    
    gcloud config configurations activate ${CONFIG_NAME}
  fi
}

function ggetname() {
  INSTANCE=$(gcloud compute instances list --format="value(name,zone,status)" | peco)
  NAME=$(echo ${INSTANCE} | awk '{print $1}')
  echo ${NAME}
}

function gssh() {
  gcloud compute ssh $(ggetname)
}

function gstart() {
  gcloud compute instances start $(ggetname)
}

function gstop() {
  gcloud compute instances stop $(ggetname)
}

function ggetip() {
  IP=$(gcloud compute instances list --filter="name=$(ggetname)" --format="value(EXTERNAL_IP)")
  echo ${IP}
}

# gcpのインスタンスを選択してssh
function gcp-ssh {
  PROJECT_ID=$(gcloud projects list --format="value(projectId)" | peco)
  INSTANCE=${(z)$(gcloud --project=${PROJECT_ID} compute instances list --format="value(name,zone)" | peco)}
  NAME=${INSTANCE[1]}
  ZONE=${INSTANCE[2]}
  gcloud --project=${PROJECT_ID} compute ssh ${NAME} --zone=${ZONE}
}

