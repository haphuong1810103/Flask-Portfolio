# DESCRIPTION:	  Create Flask-Portfolio in Container
# AUTHOR:		  Dhrumil Mistry <contact@dmdhrumilmistry.me>
# COMMENTS:
#	This file describes how to build Portfolio Website
#	in a container with all dependencies installed.
# USAGE:
#	# Download flask-portfolio Dockerfile
#	wget [link]
#
#	# Build image
#	docker build -t flask-portfolio .
#
#   # run docker container
#	docker run -d flask-portfolio
#
FROM python:3.10-slim-buster

LABEL maintainer "Ha Phuong <haphuong@u.nus.edu>"

# install requirements
RUN apt update -y && apt install python python-pip -y

# configure working directory
WORKDIR /python-docker

# copy files
COPY static /python-docker/static
COPY templates /python-docker/templates
COPY app.py /python-docker/app.py
COPY requirements.txt /python-docker/requirements.txt
COPY wsgi.py /python-docker/wsgi.py
COPY README.md /python-docker/README.md
COPY LICENSE /python-docker/LICENSE

# install project requirements
RUN pip install -r requirements.txt

# expose docker port to host machine
EXPOSE 8080

# migrate db
RUN rm -rf migrations
RUN flask db init
RUN flask db migrate -m "initial migration"
RUN flask db upgrade

# start project
CMD [ "waitress-serve", "wsgi:app" ]