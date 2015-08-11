# eea.docker.iris2

run the container: 

    docker run --restart=always --name iris2 --link postfixcontainer:postfixcontainer --link iris2db:iris2db --volumes-from=iris2_home -p <port_host>:80 -d iris2
    
dependency containers:
    
    docker run --restart=always --name iris2db --volumes-from=iris2_data --link iris2db:iris2db -e MYSQL_ROOT_PASSWORD=<secret_password> -d mariadb:5.5
    
    docker run --restart=always --env-file=/configuration_files/.secret -v /etc/localtime:/etc/localtime:ro --name=postfixcontainer -d eeacms/postfix:eionet

current <port_host> = 50003

moving data volume containers from one host to another:



<donor host>

    docker run --rm --volumes-from=iris2_home -v $(pwd):/backup busybox tar cvf /backup/iris2_home.tar /var/www
    
    docker run --rm --volumes-from=iris2_data -v $(pwd):/backup busybox tar cvf /backup/iris2_data.tar /var/lib/mysql

<target host>

    docker run -d --name iris2_home eeacms/php_data
    docker run -d --name iris2_data eeacms/mysql_data

    docker run --rm --volumes-from=iris2_home -v $(pwd):/backups busybox tar xvf /backups/iris2_home.tar
    docker run --rm --volumes-from=iris2_home -v $(pwd):/backups busybox chmod a+w /var/www/iris2/irisii_app/cache
    
    docker run --rm --volumes-from=iris2_data -v $(pwd):/backups busybox tar xvf /backups/iris2_data.tar
