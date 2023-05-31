docker run --restart=always \
  -itd \
  -e MYSQL_ROOT_PASSWORD=mysql \
  -e MYSQL_DATABASE=obo \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=123456 \
  -v $PWD/obo.sql:/docker-entrypoint-initdb.d/init.sql \
  -p 3336:3306 \
  --name obo_database \
  mysql