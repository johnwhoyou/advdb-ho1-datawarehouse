#!/bin/bash
#
# This script is the property of STADVD Group 5
# (c) 2023 Renz Cruz, John Joyo, Justin Ayuyao
#

container_prefix="stadvdb-ho1"
mysql="${container_prefix}-mysql-1"
mongo="${container_prefix}-mongo-1"
nifi="${container_prefix}-apache-nifi-1"

install_scripts () {
	echo "installing dependencies"

	mkdir scripts
	curl -O https://cdn.discordapp.com/attachments/781008261041618968/1069607211602563142/docker-compose.yml
	wget -P ./scripts https://raw.githubusercontent.com/neelabalan/mongodb-sample-dataset/main/sample_supplies/sales.json
	wget -P ./scripts https://cdn.discordapp.com/attachments/1033015694855512134/1071342336233193542/Datawarehouse_Script.sql
	wget -P ./scripts https://cdn.discordapp.com/attachments/781008261041618968/1069602563017670766/ADVDB_HO1.xml
} 

install_drivers() {
	echo "installing mariadb and mysql drivers"

	workdir="/opt/nifi/nifi-current/drivers"
	docker exec $nifi bash -c "mkdir $workdir"
	# MariaDB 3.0.7 J Connector
	docker exec -w $workdir $nifi bash -c "curl -O https://cdn.discordapp.com/attachments/781008261041618968/1071748839037468692/3.0.7.tar.gz && tar -xzvf 3.0.7.tar.gz"
	# MySQL J Connector
	docker exec -w $workdir $nifi bash -c "curl -O https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-j-8.0.32.tar.gz && tar -xzvf mysql-connector-j-8.0.32.tar.gz"
}

install_data() {
	echo "installing 26k-consumer-complaints.csv"

	workdir="/opt/nifi/nifi-current/data"
	docker exec $nifi bash -c "mkdir $workdir"
	docker exec -w $workdir $nifi bash -c "curl -O https://raw.githubusercontent.com/plotly/datasets/master/26k-consumer-complaints.csv"
}

check_deps() {
	if ! command -v  wget > /dev/null; then
		echo "Command wget does not exist. Exiting script..."
		false
		return
	fi

	if ! command -v  curl > /dev/null; then
		echo "Command curl does not exist. Exiting script..."
		false
		return
	fi

	if ! command -v docker > /dev/null; then
		echo "Command docker does not exist. Exiting script..."
		false
		return
	fi

	echo "Required dependencies found. Continuing setup script"

	true
}

start_containers() {
	docker compose up -d

	echo ""
	echo ""
	echo ""
	while [ "`docker inspect -f {{.State.Running}} $mysql`" != "true" ]; do     sleep 2; done
	echo "$mysql is up"
	while [ "`docker inspect -f {{.State.Running}} $mongo`" != "true" ]; do     sleep 2; done
	echo "$mongo is up"
	while [ "`docker inspect -f {{.State.Running}} $nifi`" != "true" ]; do     sleep 2; done
	echo "$nifi is up"
}

if check_deps; then
	install_scripts
	start_containers
	install_drivers
	install_data

	echo ""
	echo ""
	echo ""
	echo "==============================================================================="
	echo "				  Setup complete!"
	echo "==============================================================================="
	echo ""
	echo "All the files for the following steps are located in ./scripts"
	echo ""
	echo "Next Steps:"
	echo "	- Import Schema to MySQL (localhost:8888, user: root, pass: 1234)"
	echo "	- Import Sales Data to MongoDB (localhost:27017, user: root, pass: 1234)"
	echo "	- Open NiFi web console, import template and configure controllers (https://localhost:8443/nifi, user: root, pass: root12345678)"
	echo ""
	echo "Services can be started with 'docker compose up -d' and stopped with 'docker compose down"
	echo "(IMPORTANT: Be sure to run these commands in the directory where docker-compose.yml is located)"
	echo ""
fi
