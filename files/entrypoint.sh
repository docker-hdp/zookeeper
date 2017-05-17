#!/bin/bash

sed -i s/CTX_DATA_DIR/$ZOO_DATA_DIR/ $ZOO_CONF_DIR/zoo.cfg
sed -i s/CTX_CLIENT_PORT/$ZOO_PORT/ $ZOO_CONF_DIR/zoo.cfg

COUNT=1
for ZOO_SERVER in ${!ZOO_SERVER*}
do
	echo "server.$COUNT=${!ZOO_SERVER}" >> $ZOO_CONF_DIR/zoo.cfg
	(( count++ ))
done

echo "Starting zookeeper server:"
source $ZOO_CONF_DIR/zookeeper-env.sh
/usr/hdp/current/zookeeper-server/bin/zkServer.sh start