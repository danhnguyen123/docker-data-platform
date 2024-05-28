FROM spark-image 

# -- Layer: JupyterLab
USER root

ARG shared_workspace=/opt/workspace
ARG spark_version=3.3.4
ARG jupyterlab_version=4.2.0
# ARG jupyter_token=danhnguyen123

RUN mkdir -p ${shared_workspace} && \
    apt-get update -y && \
    pip3 install wget jupyterlab

# install dependencies
# RUN pip install --upgrade pip
# COPY ./requirements.txt .
# RUN pip install -r requirements.txt

# -- Runtime

EXPOSE 8888
WORKDIR ${shared_workspace}