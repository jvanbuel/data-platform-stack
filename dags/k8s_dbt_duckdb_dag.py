
from airflow import DAG
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from airflow.utils.dates import days_ago
from datetime import timedelta
from airflow.models import Variable

# from kubernetes.client import models as k8s

# init_environments = [k8s.V1EnvVar(name="TARGET", value="exoscale")]

# Default args for DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}

# Define DAG
with DAG(
    dag_id='example_dbt_duckdb',
    default_args=default_args,
    description='Run a task in a Kubernetes pod using the KubernetesPodOperator',
    schedule_interval=None,
    start_date=days_ago(1),
    catchup=False,
    tags=['example', 'kubernetes'],
) as dag:

    # Define task using KubernetesPodOperator
    run_in_k8s = KubernetesPodOperator(
        namespace='services',  # or your airflow namespace
        image='nilli9990/dbt-exoscale',
        # cmds=["sh", "-c"],
        arguments=["-target", "exoscale"],
        labels={"app": "airflow"},
        name="example-pod-task",
        task_id="run_echo_task",
        env_vars={
            'TARGET': 'exoscale',
            'AWS_ACCESS_KEY_ID': Variable.get("AWS_ACCESS_KEY_ID"),
            'AWS_SECRET_ACCESS_KEY': Variable.get("AWS_SECRET_ACCESS_KEY"),
        },
        get_logs=True,
        is_delete_operator_pod=True,  # Clean up after running
    )

    run_in_k8s