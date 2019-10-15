#!/bin/bash

### Checking and installing dependencies ###
echo ""
echo "####################################################"
echo "#### Installing CB Event Forwarder dependencies ####"
echo "####################################################"
sleep 2
echo ""
yum -y install git wget rpm-build gcc gcc-c++
sleep 2
echo ""

### Create and cd into working directory ###
WORKDIR="/root/cb-event/"
echo "Checking working directory.."
echo ""
if [ -d "$WORKDIR" ]; then
	### Take action if $GODIR exists ###
	sleep 2
	echo "Directory exist!"
	echo "Change into working directory /root/cb-event/"
	echo ""
	cd $WORKDIR
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "Creating working directory /root/cb-event/"
	echo ""
	sleep 1
	mkdir $WORKDIR
	echo "Change into working directory /root/cb-event/"
	echo ""
	sleep 1
	cd $WORKDIR
fi
sleep 2

### GOLANG Installation ###
echo "Checking GOLang installation.."
echo ""
sleep 2
GODIR="/usr/local/go/"
if [ -d "$GODIR" ]; then
	### Take action if $GODIR exists ###
	echo "GOLang Installed..Continuing.."
	echo ""
	sleep 2
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "GOLang not installed..Installing GOLang.."
	echo ""
	echo "Getting GOLang Installation file.."
	echo ""
	sleep 2
	wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
	echo "Extracting GOLang installation file to /usr/local/"
	echo ""
	sleep 2
	tar -C /usr/local -xzf go1.13.1.linux-amd64.tar.gz
	echo "Done.."
	echo ""
	echo "Setting up GOLang environment.."
	echo ""
	sleep 2
	export PATH=$PATH:/usr/local/go/bin
	export GOPATH=/usr/local/go/
	export GOBIN=/usr/local/go/bin/
fi

### PROTOC Installation ###
echo "Checking Protobuf installation.."
echo ""
sleep 2
PROTOCFILE="/usr/local/bin/protoc"
if [ -f "$PROTOCFILE" ]; then
	### Take action if $PROTOCFILE exists ###
	echo "Protobuf Installed..Continuing.."
	echo ""
	sleep 2
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "Getting Protobuf Installation file.."
	echo ""
	sleep 2
	wget https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0/protoc-3.10.0-linux-x86_64.zip
	echo "Extracting Protobuf installation file to /usr/local/"
	echo ""
	sleep 2
	unzip -o protoc-3.10.0-linux-x86_64.zip -d /usr/local bin/protoc
	unzip -o protoc-3.10.0-linux-x86_64.zip -d /usr/local 'include/*'
	echo "Done.."
	echo ""
fi

### LIBRDKAFKA Installation ###
echo "Checking librdkafka installation.."
echo ""
sleep 2
LIBKAFKADIR="/usr/include/librdkafka/"
if [ -d "$LIBKAFKADIR" ]; then
	### Take action if $LIBKAFKADIR exists ###
	echo "Libkafka Installed..Continuing.."
	echo ""
	sleep 2
else
	###  Control will jump here if $DIR does NOT exists ###
	echo "Cloning Librdkafka git folder.."
	echo ""
	sleep 2
	git clone https://github.com/edenhill/librdkafka.git
	cd librdkafka/
	echo "Configuring Librdkafka.."
	echo ""
	sleep 2
	./configure --prefix /usr/
	echo "Building Librdkafka installation file..this might take few minutes"
	echo ""
	sleep 2
	make
	echo "Installing Librdkafka"
	echo ""
	sleep 2
	make install
	echo "Done.."
	echo ""
fi
echo "Back to $WORKDIR"
cd $WORKDIR
sleep 2

### CB Event Forwarder Installation ###
echo "#######################################"
echo "#### Installing CB Event Forwarder ####"
echo "#######################################"
echo ""
sleep 1
echo "Checking cb-event-forwarder installation.."
echo ""
sleep 2
CBDIR="/usr/share/cb/integrations/event-forwarder/"
if [ -d "$CBDIR" ]; then
	### Take action if $CBDIR exists ###
	echo "cb-event-forwarder already installed. Do you want to start the service now? [Y,n]"
	read input
	if [[ $input == "Y" || $input == "y" ]]; then
		echo "Starting CB Event Forwarder service"
		echo ""
		systemctl start cb-event-forwarder
		sleep 2
		echo "Configure CB Event Forwarder to run at startup"
		echo ""
		systemctl enable cb-event-forwarder
		sleep 2
		echo "Checking CB Event Forwarder status"
		echo ""
		systemctl status cb-event-forwarder
		sleep 2
	else
        echo "Exiting.."
		sleep 2
		exit 1
	fi
else
	echo "cb-event-forwarder not installed..continuing.."
	echo ""
	sleep 2
	CBEFDIR="/root/cb-event/cb-event-forwarder/"
	if [ -d "$CBEFDIR" ]; then
		### Take action if $CBEFDIR exists ###
		echo ""
		echo "Removing previous cb-event-forwarder directory (if any)"
		rm -rf $CBEFDIR
		echo ""
		sleep 2
		echo "Directory removed!"
	else
		###  Control will jump here if $DIR does NOT exists ###
		echo "No previous download..continuing.."
		echo ""
		sleep 2
	fi
	###  Control will jump here if $DIR does NOT exists ###
	echo "Cloning cb event forwarder git folder.."
	echo ""
	sleep 2
	git clone https://github.com/carbonblack/cb-event-forwarder.git
	cd cb-event-forwarder
	echo "Building CB Event Forwarder RPM file..this might take few minutes"
	echo ""
	sleep 2
	make rpm
	RPMFILE="/root/rpmbuild/RPMS/x86_64/cb-event-forwarder-3.6-0.x86_64.rpm"
	if [ -f "$RPMFILE" ]; then
		### Take action if $RPMFILE exists ###
		echo "RPM file successfully created.."
		echo ""
		echo "RPM file located at /root/rpmbuild/RPMS/x86_64/"
		ls /root/rpmbuild/RPMS/x86_64/
		sleep 2
	else
		###  Control will jump here if $DIR does NOT exists ###
		echo "RPM build failed.."
		echo ""
		sleep 2
		echo "Check PATH, GOPATH, GOBIN for GOLANG and re-run script.."
		################################################
		### Run below command for EXPORT PATH ##########
		### ~]#export PATH=$PATH:/usr/local/go/bin  ####
		### ~]#export GOPATH=/usr/local/go/		    ####
		### ~]#export GOBIN=/usr/local/go/bin/	    ####
		################################################
		echo "Exiting.."
		exit 1
	fi
fi
echo ""
echo "Do you want to install cb event forwarder now? [Y,n]"
read input
if [[ $input == "Y" || $input == "y" ]]; then
        cd /root/rpmbuild/RPMS/x86_64/
		echo "Installing CB Event Forwarder RPM file"
		echo ""
		sleep 2
		rpm -ivh cb-event-forwarder-3.6-0.x86_64.rpm
		echo "Starting CB Event Forwarder service"
		echo ""
		systemctl start cb-event-forwarder
		sleep 2
		echo "Configure CB Event Forwarder to run at startup"
		echo ""
		systemctl enable cb-event-forwarder
		sleep 2
		echo "Checking CB Event Forwarder status"
		echo ""
		systemctl status cb-event-forwarder
		sleep 2
		echo "Done.."
		sleep 2
else
        echo "Exiting.."
		sleep 2
fi
exit
