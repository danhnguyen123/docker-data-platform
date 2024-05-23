up-build:
	docker compose up --build -d --scale spark-worker=2

setup: datagen create-tables

datagen:
	docker exec -ti spark-master bash -c 'cd tpch-dbgen && make && ./dbgen -s 1'

create-tables:
	docker exec spark-master spark-sql --master spark://spark-master:7077 --deploy-mode client -f /opt/bitnami/spark/setup.sql
