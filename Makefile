init:
	docker network create -d bridge data-network

	cd ./architecture/minio
	docker compose  up --build -d
	cd ../..

	cd ./architecture/hive
	docker compose up --build -d
	cd ../..

up-build-spark:
    cd ./architecture/spark
	docker compose up --build -d --scale spark-worker=2
	cd ../..

up-build-airflow:
    cd ./architecture/airflow
	docker compose up --build -d
	cd ../..

up-build-trino:
    cd ./architecture/trino
	docker compose up --build -d
	cd ../..

up-build-hue:
    cd ./architecture/hue
	docker compose up --build -d
	cd ../..

up-build-metabase:
    cd ./architecture/metabase
	docker compose up --build -d
	cd ../..


setup: datagen create-tables

datagen:
	docker exec -ti spark-master bash -c 'cd tpch-dbgen && make && ./dbgen -s 1'

create-tables:
	docker exec spark-master spark-sql --master spark://spark-master:7077 --deploy-mode client -f /opt/bitnami/spark/setup.sql
