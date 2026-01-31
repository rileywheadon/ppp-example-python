export DOCKERHUB_USERNAME="rileywheadon"
export TAG=$(yq e '.version' version.yaml)
docker compose down 
docker compose up -d