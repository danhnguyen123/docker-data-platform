SPARK_WORKER=2
HADOOP_DATANODE=2

# Create docker network, object storage and hive metastore
init:
	@docker network create -d bridge data-network

minio:
	@cd ./architecture/minio && docker compose up --build -d && cd ../..
	
hive:
	@cd ./architecture/hive && docker compose up --build -d && cd ../..

up: spark notebook airflow trino hue metabase

spark:
	@ cd ./architecture/spark && docker compose up --build -d --scale spark-worker=$(SPARK_WORKER) && cd ../..

# For JDBC/ODBC connector
thrift:
	@cd ./architecture/spark && docker compose --profile thrift up -d && cd ../..

# For JDBC/ODBC connector
notebook:
	@cd ./architecture/spark && docker compose --profile notebook up -d --build && cd ../..

airflow:
	@cd ./architecture/airflow && docker compose up --build -d && cd ../..

trino:
	@cd ./architecture/trino && docker compose up --build -d && cd ../..

hue:
	@cd ./architecture/hue && docker compose up --build -d && cd ../..

metabase:
	@cd ./architecture/metabase && docker compose up --build -d && cd ../..

hadoop:
	@cd ./architecture/hadoop && docker compose up --build -d --scale datanode=$(HADOOP_DATANODE) && cd ../..

stop:
	@docker stop $(docker ps -a -q)

down:
	@docker rm $(docker ps -a -q)

setup: datagen create-tables

# Generate tpch data
datagen:
	@docker exec -it spark-master bash -c 'cd tpch-dbgen && make && ./dbgen -s 1'

# Generate sample upstream postgres database
fake-datagen:
	@docker exec spark-master bash -c "python3 /opt/spark/work-dir/capstone/upstream_datagen/datagen.py"

# Create hive external table with tpch data stored at MinIO (AWS S3 compatible), 
# These tables are used to practice in workspace/data-processing-spark
create-tables:
	@docker exec spark-master spark-sql --master spark://spark-master:7077 --deploy-mode client -f /opt/bitnami/spark/setup.sql

count-tables:
	@docker exec spark-master spark-sql --master spark://spark-master:7077 --deploy-mode client -f /opt/bitnami/spark/count.sql

## Web UIs

ui-spark-master:
	open http://localhost:8008

ui-spark-master-app:
	open http://localhost:4040

ui-spark-history:
	open http://localhost:18080

ui-spark-thrift:
	open http://localhost:4041

ui-spark-notebook:
	open http://localhost:8888

ui-spark-notebook-app:
	open http://localhost:4042

ui-trino:
	open http://localhost:8001

ui-minio:
	open http://localhost:9001

ui-metabase:
	open http://localhost:3000

ui-hue:
	open http://localhost:8000

ui-airflow:
	open http://localhost:8080

## Start Pyspark and Spark SQL REPL sessions

python:
	docker exec -it spark-master bash python --master spark://spark-master:7077 

spark-sql:
	docker exec -it spark-master spark-sql --master spark://spark-master:7077 

## Pyspark runner
spark-submit: 
	@read -p "Enter pyspark relative path:" pyspark_path; docker exec -it spark-master spark-submit --master spark://spark-master:7077 $$pyspark_path

## Project

rainforest:
	docker exec spark-master spark-submit --master spark://spark-master:7077 --deploy-mode client ./capstone/run_code.py
