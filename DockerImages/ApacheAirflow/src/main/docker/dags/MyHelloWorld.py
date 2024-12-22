from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from datetime import datetime


def hello_world():
    print('Hello World')


with DAG(dag_id="MyHelloWorld",
         start_date=datetime(2021, 1, 1),
         schedule_interval="@hourly",
         catchup=False) as dag:

    task1 = BashOperator(
        task_id="Initialise",
        bash_command='echo "This is the initialisation task"'
    )

    task2 = PythonOperator(
        task_id="hello_world",
        python_callable=hello_world
    )

    task3 = BashOperator(
        task_id="closing",
        bash_command='echo "This is the ending of the application"'
    )


task1 >> task2 >> task3
