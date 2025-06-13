from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import time

# Define default arguments
default_args = {
    'owner': 'airflow',
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}

# Define the DAG
with DAG(
    dag_id='example_basic_dag2',
    default_args=default_args,
    description='A simple example DAG',
    schedule_interval='@daily',
    start_date=datetime(2025, 6, 1),
    catchup=False,
    tags=['example'],
) as dag:

    def print_date():
        print(f"Current date is: {datetime.now()}")

    def sleep_task():
        print("Sleeping for 5 seconds...")
        time.sleep(5)

    def print_message():
        print("Task pipeline finished successfully!")

    # Define tasks
    task_print_date = PythonOperator(
        task_id='print_date',
        python_callable=print_date,
    )

    task_sleep = PythonOperator(
        task_id='sleep',
        python_callable=sleep_task,
    )

    task_print_message = PythonOperator(
        task_id='print_message',
        python_callable=print_message,
    )

    # Set task dependencies
    task_print_date >> task_sleep >> task_print_message