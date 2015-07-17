#!/bin/bash

# check to see if GitBlit's properties file already exists and, if not, copy in all the config data
# This allows us to rebind the baseFolder to an attached data-only volume

if [ ! -f /opt/gitblit-data/gitblit.properties ]; then
    cp -a /opt/gitblit/data/* /opt/gitblit-data

    # Adjust the default Gitblit settings to bind to 80, 9418, 29418, and allow RPC administration.

    sed -e "s/server\.httpsPort\s=\s8443/server\.httpsPort=0/" \
        -e "s/server\.httpPort\s=\s0/server\.httpPort=80/" \
        -e "s/web\.enableRpcManagement\s=\sfalse/web\.enableRpcManagement=true/" \
        -e "s/web\.enableRpcAdministration\s=\sfalse/web.enableRpcAdministration=true/" \
        -e "s/server\.contextPath\s=\s\//server.contextPath=\/gitblit\//" \
        /opt/gitblit/data/gitblit.properties > /opt/gitblit-data/gitblit.properties

fi

java -server -Xmx1024M -Djava.awt.headless=true -jar /opt/gitblit/gitblit.jar --baseFolder /opt/gitblit-data
