FROM python:3.7.9

WORKDIR \LoginAPI

COPY . .

RUN pip install -r requirements.txt

EXPOSE 8000

CMD python3 main.py