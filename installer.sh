#!/bin/bash
### Checking and installing dependencies ###

echo "########## Installing Dependencies ##########"
sleep 2
echo ""
echo ""
yum install git wget rpm-build gcc gcc-c++
echo ""
echo ""
### Create and cd into working directory ###
WORKDIR="/root/cb-event/"
mkdir $WORKDIR
cd $WORKDIR

### GOLANG Installation ###
echo "Checking GoLang installation.."
GODIR="/usr/local/go/"
if [ -d "$GODIR" ]; then
	### Take action if $GODIR exists ###
	echo "GOLang Installed..Continuing.."
	exit 1
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "Installing GOLang.."
	echo "Getting GOLang Installation file.."
	sleep 2
	wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
	echo "Extracting GOLang installation file to /usr/local/"
	sleep 2
	tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz
	echo "Setting up GOLang environment.."
	sleep 2
	export PATH=$PATH:/usr/local/go/bin
	export GOPATH=/usr/local/go/
	export GOBIN=/usr/local/go/bin/
fi
echo ""
echo ""
echo ""
### PROTOC Installation ###
echo "Checking Protoc installation.."
PROTOCFILE="/usr/local/bin/protoc"
if [ -f "$PROTOCFILE" ]; then
	### Take action if $PROTOCFILE exists ###
	echo "Protoc Installed..Continuing.."
	exit 1
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "Getting Protobuf Installation file.."
	sleep 2
	wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0/protoc-3.10.0-linux-x86_64.zip
	echo "Extracting Protobuf installation file to /usr/local/"
	sleep 2
	unzip -o protoc-3.10.0-linux-x86_64.zip -d /usr/local bin/protoc
	unzip -o protoc-3.10.0-linux-x86_64.zip -d /usr/local 'include/*'
fi
echo ""
echo ""
echo ""
### LIBRDKAFKA Installation ###
echo "Checking librdkafka installation.."
LIBKAFKADIR="/usr/include/librdkafka/"
if [ -d "$LIBKAFKADIR" ]; then
	### Take action if $LIBKAFKADIR exists ###
	echo "libkafka Installed..Continuing.."
	exit 1
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "Cloning Librdkafka git folder.."
	sleep 2
	git clone https://github.com/edenhill/librdkafka.git
	cd librdkafka/
	echo "Configuring Librdkafka.."
	sleep 2
	./configure --prefix /usr/
	echo "Building Librdkafka installation file..this might take few minutes"
	sleep 2
	make
	echo "Installing Librdkafka"
	sleep 2
	make install
fi
echo ""
echo ""
echo ""
cd $WORKDIR
sleep 2
### CB Event Forwarder Installation ###
echo "#### Installing CB Event Forwarder ####"
echo ""
echo ""
sleep 1
echo "Checking cb-event-forwarder installation.."
echo ""
echo ""
echo ""
sleep 2
CBDIR="/usr/share/cb/integrations/event-forwarder/"
if [ -d "$CBDIR" ]; then
	### Take action if $CBDIR exists ###
	echo "..Continuing.."
	echo "cb-event-forwarder installed. Do you want to start the service now? [Y,n]"
	read input
	if [[ $input == "Y" || $input == "y" ]]; then
		echo "Starting CB Event Forwarder service"
		systemctl start cb-event-forwarder
		sleep 2
		echo "Configure CB Event Forwarder to run at startup"
		systemctl enable cb-event-forwarder
		sleep 2
		echo "Done!"
		sleep 2
		exit 
	else
        echo "Exiting.."
		sleep 2
	fi
	exit 1
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "Cloning cb event forwarder git folder.."
	sleep 2
	git clone https://github.com/carbonblack/cb-event-forwarder.git
	cd cb-event-forwarder
	echo "Building CB Event Forwarder RPM file..this might take few minutes"
	sleep 2
	make rpm
	echo "RPM file successfully created"
	echo "RPM file located at /root/rpmbuild/RPMS/x86_64/"
fi
echo ""
echo ""
echo ""
echo "Do you want to install now? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        cd /root/rpmbuild/RPMS/x86_64/
		echo "Installing CB Event Forwarder RPM file"
		sleep 2
		rpm -ivh cb-event-forwarder-3.6-0.x86_64.rpm
		echo "Starting CB Event Forwarder service"
		systemctl start cb-event-forwarder
		sleep 2
		echo "Configure CB Event Forwarder to run at startup"
		systemctl enable cb-event-forwarder
		sleep 2
		echo "Done!"
		sleep 2
		exit 
else
        echo "Exiting.."
		sleep 2
fi
exit
