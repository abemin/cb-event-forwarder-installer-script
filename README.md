# cb-event-forwarder-installer-script

This script will attempt to build rpm package for cb-event-forwarder used by Carbon Black Response.

At the time of writing, the version of cb-event-forwarder is 3.6.

Script will 
- assume you have a working network connection to CentOS repo and internet.
- check if you want to install on CB Server or Standalone for large deployment.
- install dependencies packages 
- install golang
- install librdkafka required for cb-event-forwarder
- install protobuffer

RPM package provided was build on CentOS 7 1908.

More info please refer https://github.com/carbonblack/cb-event-forwarder
