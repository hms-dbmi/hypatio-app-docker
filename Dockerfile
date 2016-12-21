FROM dbmi/pynxgu

COPY Hypatio /hypatio/
RUN pip install -r /hypatio/requirements.txt

RUN mkdir /entry_scripts/
COPY gunicorn-nginx-entry.sh /entry_scripts/
RUN chmod u+x /entry_scripts/gunicorn-nginx-entry.sh

COPY hypatio.conf /etc/nginx/sites-available/pynxgu.conf

WORKDIR /

ENTRYPOINT ["/entry_scripts/gunicorn-nginx-entry.sh"]