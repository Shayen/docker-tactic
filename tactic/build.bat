#! /bin/bash
TIMESTAMP=`date +%Y-%m-%d`
alias docker='sudo docker'
sed -i "s/ENV REFRESHED_AT .*$/ENV REFRESHED_AT $TIMESTAMP/" Dockerfile
docker build -t sirasit1234/tactic .
docker build -t sirasit1234/tactic:4.6 .
docker push sirasit1234/tactic
