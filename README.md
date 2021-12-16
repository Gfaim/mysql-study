# mysql-study

## Install

### Prerequisites
You will need docker installed on your computer to run the sql image.

### Running sql container
Run ```docker build . -t mysql-test && docker run -d --name mysql-container -e TZ=UTC -p 30306:3306 -e MYSQL_RANDOM_ROOT_PASSWORD=yes mysql-test && echo "ROOT_PASSWORD=" && docker logs `docker ps -aq | head -n 1` 2>/dev/null | xargs |  grep -oP '(?<=GENERATED ROOT PASSWORD).*(?=\s)' | cut -d " " -f2
&& docker exec -it `docker ps -aq` /bin/bash```

## Project

### Create Database:
