export DOCKERHUB_USERNAME="rileywheadon"
export TAG=$(yq e '.version' version.yaml)
docker build -t ${DOCKERHUB_USERNAME}/ppp-example-python:${TAG} .
docker push ${DOCKERHUB_USERNAME}/ppp-example-python:${TAG}


