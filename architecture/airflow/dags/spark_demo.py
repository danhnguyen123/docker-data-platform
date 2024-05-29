from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.contrib.operators.spark_submit_operator import SparkSubmitOperator
from datetime import datetime, timedelta

now = datetime.now()
spark_master = "spark://spark-master:7077"
default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": datetime(now.year, now.month, now.day),
    "email": ["airflow@airflow.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=1)
}

dag = DAG(
        dag_id="spark-hello-world-module", 
        description="This DAG runs a Pyspark app that uses modules.",
        default_args=default_args, 
        schedule_interval=timedelta(1)
    )

start = DummyOperator(task_id="start", dag=dag)

spark_job = SparkSubmitOperator(
    task_id="spark_job",
    application="/opt/workspace/data-processing-spark/2-apache-spark-basics/architecture/resource_config.py", # Spark application path created in airflow and spark cluster
    name="spark-demo",
    conn_id="spark_default",
    verbose=1,
    conf={"spark.master": spark_master},
    dag=dag)

end = DummyOperator(task_id="end", dag=dag)

start >> spark_job >> end