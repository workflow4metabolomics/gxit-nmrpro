# call parent container
FROM python:2.7

# set author
MAINTAINER Lain Pavot <lain.pavot@inra.fr>

# set encoding
ENV LANG en_US.UTF-8

# Install NMRPro
RUN pip install django==1.9.7
RUN pip install numpy scipy patterns url
RUN pip install nmrpro
RUN pip install django-nmrpro
RUN django-admin startproject nmrpro_server

# Setup NMRPro -> file changed
COPY resources/nmrpro_server/settings.py nmrpro_server/nmrpro_server/settings.py
COPY resources/nmrpro_server/urls.py     nmrpro_server/nmrpro_server/urls.py 
RUN python /nmrpro_server/manage.py migrate

COPY resources/django_nmrpro/encoder.py /usr/local/lib/python2.7/site-packages/django_nmrpro/encoder.py
COPY resources/django_nmrpro/views.py   /usr/local/lib/python2.7/site-packages/django_nmrpro/views.py

CMD python /nmrpro_server/manage.py runserver 0.0.0.0:8000