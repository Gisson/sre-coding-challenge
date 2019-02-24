FROM  python:3
ADD . /multivac
WORKDIR /multivac
RUN pip install -r requirements.txt
CMD [ "python", "manage.py","runserver" ]

FROM  python:3
ADD . /multivac
WORKDIR /multivac
RUN pip install -r requirements.txt
CMD [ "python", "manage.py","worker" ]
