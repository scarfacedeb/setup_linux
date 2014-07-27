sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
wget -q https://dl-ssl.google.com/linux/linux_signing_key.pub -O- | sudo apt-key add -
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
sudo wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
wget -O- http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4C9D234C