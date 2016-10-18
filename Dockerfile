FROM dbmi/pynxgu

#Code for hypatio-app
RUN mkdir /hypatio-app/
RUN mkdir /hypatio-app/static/
WORKDIR /hypatio-app/
RUN  echo "abcde" && git clone -b development https://github.com/hms-dbmi/hypatio-app.git 
RUN pip install -r /hypatio-app/hypatio-app/requirements.txt

COPY gunicorn-nginx-entry.sh /
RUN chmod u+x /gunicorn-nginx-entry.sh

COPY hypatio.conf /etc/nginx/sites-available/pynxgu.conf

WORKDIR /

ENTRYPOINT ["./gunicorn-nginx-entry.sh"]