# eea.docker.iris2

run the container: 

    docker run --restart=always --name iris2 --volumes-from=iris2_data --volumes-from=iris2_home -p <port_host>:80 -e MYSQL_ROOT_PASSWORD=<secret_password> -d eeacms/iris2

current <port_host> = 50003

moving data volume containers from one host to another:



<donor host>

    docker run --rm --volumes-from=iris2_home -v $(pwd):/backup busybox tar cvf /backup/iris2_home.tar /var/www

    docker run --rm --volumes-from=iris2_data -v $(pwd):/backup busybox tar cvf /backup/iris2_data.tar /var/lib/mysql

<target host>

    docker run -d --name iris2_home eeacms/php_data
    docker run -d --name iris2_data eeacms/mysql_data

    docker run --rm --volumes-from=iris2_home -v $(pwd):/backups busybox tar xvf /backups/iris2_home.tar
    docker run --rm --volumes-from=iris2_data -v $(pwd):/backups busybox tar xvf /backups/iris2_data.tar
