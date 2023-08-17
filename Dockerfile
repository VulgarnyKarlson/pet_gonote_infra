FROM python:3.7.11-slim-buster
RUN apt-get update -qq \
    && apt-get install -qq curl git unzip openssh-client \
    && apt-get -q clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/ansible

COPY ansible/requirements.txt ./
RUN pip3 -qq install -r requirements.txt
RUN ansible-galaxy collection install community.general

COPY ansible/roles.yml ./
RUN ansible-galaxy install -p roles -r roles.yml

ENV PYTHONWARNINGS="ignore"

COPY ansible /root/ansible

ENV ANSIBLE_PIPELINING=True
ENV ANSIBLE_SSH_PIPELINING=True
