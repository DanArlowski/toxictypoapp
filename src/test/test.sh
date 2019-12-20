echo "starting e2e test"
echo "****testing file: $1****" >> log/log.txt
python2 e2e_test.py server:8080 $1 10
exit $?