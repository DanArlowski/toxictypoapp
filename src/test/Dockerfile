FROM python:2.7
RUN pip install requests
COPY . /test
WORKDIR /test
ENV TESTFILE="sanity"
ENTRYPOINT sh test.sh ${TESTFILE}
