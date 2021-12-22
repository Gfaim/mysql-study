# mysql-study

## Install

### Prerequisites
You will need docker installed on your computer to run the sql image.

### Running sql container
Run ```docker run --net=host -d --name mysql-container -e TZ=UTC -e MYSQL_ROOT_PASSWORD=totoabc mysql:latest && docker exec -i `docker ps -aq | head -n 1` mysql -uroot -ptotoabc```

## Project

### Create Database: