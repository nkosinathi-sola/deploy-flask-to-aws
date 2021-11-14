# define the base image that will be used to create the image.
FROM python:3.9-slim

# some extra information
LABEL Author="Nkosinathi Sola"
LABEL E-mail="nkosinathisola@gmail.com"
LABEL version="0.1"

# defines the work directory
WORKDIR /${APP_HOME}

# copy requirements.txt from the host to the container
COPY ./app/requirements.txt /${APP_HOME}/requirements.txt

# install dependencies from the requirements file
RUN pip install -r /${APP_HOME}/requirements.txt

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# copy our application app.py from the host to the container
COPY ./app/app.py /${APP_HOME}/app.py

# execute the commands after and build up the container.
ENTRYPOINT ["/bin/bash", "-c", "entrypoint.sh"]