echo "y" | sudo apt-get update
echo "y" | sudo apt-get install apt-transport-https ca-certificates
echo "y" | sudo apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
echo "y" | sudo apt-get update
echo "y" | sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
echo "y" | sudo apt-get update
echo "y" | sudo apt-get install docker-engine
echo "y" | sudo service docker startUSER
sudo usermod -aG docker $(whoami)

#Verifiyes if docker is installed! Optional
#echo "y" | sudo docker run hello-world

