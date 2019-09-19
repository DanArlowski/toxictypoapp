FROM python:2.7
RUN pip install requests
COPY . /test
WORKDIR /test
ENTRYPOINT sh test.sh
