# gcloudのconfigurationを切り替える
function gconf() {
  config=$(gcloud config configurations list | peco)
  if [ -n "$config" ]; then  
    config_name=$(echo ${config} | awk '{print $1}')    
    gcloud config configurations activate ${config_name}
  fi
}
