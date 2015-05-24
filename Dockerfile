FROM jmoger/gitblit

MAINTAINER Elder Research, Inc.

ENV LOGICAL_HOSTNAME cap.elderrearch.com

RUN sed -e "s;^server.httpsPort.*;server.httpsPort=0;" \
        -e "s;^server.httpPort.*;server.httpPort=80;" \
        -e "s;^web.enableRpcManagement.*;web.enableRpcManagement=true;" \
        -e "s;^web.enableRpcAdministration.*;web.enableRpcAdministration=true;" \
        -e "s;^server.contextPath.*;server.contextPath=/gitblit/;" \
        -e "s;^web.canonicalUrl.*;web.canonicalUrl = http://${LOGICAL_HOSTNAME};" \
        -e "s;^realm.authenticationProviders.*;realm.authenticationProvider=ldap;" \
        -e "s;^realm.ldap.server.*;realm.ldap.server=ldap://ldap:389;" \
        -e "s;^realm.ldap.accountBase.*;realm.ldap.accountBase = DC=cap,DC=elderresearch,DC=com;" \
        -e "s;^realm.ldap.groupBase.*;realm.ldap.groupBase = OU=Groups,DC=cho,DC=elderresearch,DC=com;" \
        -e "s;^realm.ldap.accountPattern.*$;realm.ldap.accountPattern = (\&(objectClass=person)(uid=\$\{username\}));" \
        -e "s;^realm.ldap.admins.*;realm.ldap.admins=@\"Gitblit Admins\";" \
        -e "s;^realm.ldap.groupMemberPattern.*;realm.ldap.groupMemberPattern=(\&(objectClass=groupofnames)(member=\$\{dn\}));"\
        -e "s;^realm.ldap.groupEmptyMemberPattern.*;realm.ldap.groupEmptyMemberPattern=(\&(objectClass=groupofnames)(!(member=*)));" \
        /opt/gitblit-data/default.properties > /opt/gitblit-data/gitblit.properties

ADD log4j.properties /opt/gitblit-data/

VOLUME /opt/gitblit-data

# cmd ["java", "-server", "-Xmx1024M", "-Djava.awt.headless=true", "-Dlog4j.configuration=${GITBLIT_DATA}/log4j.properties", "-jar", "/opt/gitblit/gitblit.jar", "--baseFolder", "/opt/gitblit-data"]
CMD ["java", "-server", "-Xmx1024M", "-Djava.awt.headless=true", "-jar", "/opt/gitblit/gitblit.jar", "--baseFolder", "/opt/gitblit-data"]
