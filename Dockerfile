# define the base image that will be used to create the image.
FROM python:3.8.5-alpine3.12

# some extra information
LABEL Author="Nkosinathi Sola"
LABEL E-mail="nkosinathisola@gmail.com"
LABEL version="0.1"

# defines the work directory
WORKDIR /app

# copy requirements.txt from the host to the container
COPY ./app/requirements.txt /src/requirements.txt

# install dependencies from the requirements file
RUN pip install -r /src/requirements.txt

# copy our application app.py from the host to the container
COPY ./app/app.py /src/app.py

# execute the commands after and build up the container.
CMD ["python3", "/src/app.py"]