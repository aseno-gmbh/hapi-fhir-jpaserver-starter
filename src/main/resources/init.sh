
#!/bin/bash
echo $APP_PORT
echo $DB_URL
echo $DB_USER
echo $JAVA_OPTS


exec java -Dserver.port=$APP_PORT -Dspring.datasource.url=$DB_URL -Dspring.datasource.username=$DB_USER -Dspring.datasource.password=$DB_PWD $JAVA_OPTS -jar /data/hapi/app/ROOT.war