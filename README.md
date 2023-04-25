# protNLM


sudo aws ecr get-login-password --region us-west-2 | sudo  docker login --username AWS --password-stdin 915613358575.dkr.ecr.us-west-2.amazonaws.com
aws ecr create-repository --repository-name protnlm

sudo docker build . -t protnlm
sudo docker tag protnlm 915613358575.dkr.ecr.us-west-2.amazonaws.com/protnlm
sudo docker push 915613358575.dkr.ecr.us-west-2.amazonaws.com/protnlm
sudo cortex deploy
sudo cortex refresh protnlm
sudo cortex describe protnlm