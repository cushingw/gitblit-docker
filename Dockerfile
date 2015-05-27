FROM jmoger/gitblit

MAINTAINER Elder Research, Inc.

ENV LOGICAL_HOSTNAME cap.elderresearch.com

RUN sed -e "s;^server.httpsPort.*;server.httpsPort=0;" \
        -e "s;^server.httpPort.*;server.httpPort=80;" \
        -e "s;^web.enableRpcManagement.*;web.enableRpcManagement=true;" \
        -e "s;^web.enableRpcAdministration.*;web.enableRpcAdministration=true;" \
        -e "s;^server.contextPath.*;server.contextPath=/gitblit/;" \
        -e "s;^web.canonicalUrl.*;web.canonicalUrl = http://${LOGICAL_HOSTNAME};" \
        -e "s;^realm.authenticationProviders.*;realm.authenticationProviders = ldap;" \
        -e "s;^realm.ldap.server.*;realm.ldap.server=ldap://ldap:389;" \
        -e "s;^realm.ldap.accountBase.*;realm.ldap.accountBase = DC=cap,DC=elderresearch,DC=com;" \
        -e "s;^realm.ldap.groupBase.*;realm.ldap.groupBase = OU=Groups,DC=cho,DC=elderresearch,DC=com;" \
        -e "s;^realm.ldap.accountPattern.*$;realm.ldap.accountPattern = (\&(objectClass=person)(uid=\$\{username\}));" \
        -e "s;^realm.ldap.admins.*;realm.ldap.admins=\"@Gitblit Admin\" sfitch;" \
        -e "s;^realm.ldap.groupMemberPattern.*;realm.ldap.groupMemberPattern=(\&(objectClass=groupofnames)(member=\$\{dn\}));"\
        -e "s;^realm.ldap.groupEmptyMemberPattern.*;realm.ldap.groupEmptyMemberPattern=(\&(objectClass=groupofnames)(!(member=*)));" \
        -e "s;^realm.ldap.displayName.*;realm.ldap.displayName = cn;" \
        -e "s;^realm.ldap.email.*;realm.ldap.email = \$\{givenName\}.\$\{sn\}@datamininglab.com;" \
        -e "s;^realm.ldap.synchronize.*;realm.ldap.synchronize = true;" \
        -e "s;^realm.ldap.maintainTeams.*;realm.ldap.maintainTeams = true;" \
        /opt/gitblit-data/default.properties > /opt/gitblit-data/gitblit.properties

VOLUME /opt/gitblit-data

CMD ["java", "-server", "-Xmx1024M", "-Djava.awt.headless=true", "-jar", "/opt/gitblit/gitblit.jar", "--baseFolder", "/opt/gitblit-data"]
