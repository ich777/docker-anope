#!/bin/bash
LAT_V="$(curl -s https://api.github.com/repos/ich777/anope/releases/latest | grep tag_name | cut -d '"' -f4)"
CUR_V="$(${DATA_DIR}/bin/services --version 2>/dev/null | cut -d '-' -f2- | cut -d ' ' -f1)"
if [ -z $LAT_V ]; then
	if [ -z $CUR_V ]; then
		echo "---Can't get latest version of Anope, falling back to v2.0.7---"
		LAT_V="2.0.7"
	else
		echo "---Can't get latest version of Anope, falling back to v$CUR_V---"
	fi
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
	echo "---Anope not found, downloading and installing v$LAT_V...---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Anope-v$LAT_V.tar.gz "https://github.com/ich777/anope/releases/download/$LAT_V/Anope-v$LAT_V.tar.gz" ; then
		echo "---Successfully downloaded Anope v$LAT_V---"
	else
		echo "---Something went wrong, can't download Anope v$LAT_V, putting container into sleep mode!---"
		sleep infinity
	fi
	tar -C ${DATA_DIR} --strip-components=1 -xf ${DATA_DIR}/Anope-v$LAT_V.tar.gz
	rm ${DATA_DIR}/Anope-v$LAT_V.tar.gz
elif [ "$CUR_V" != "$LAT_V" ]; then
	echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Anope-v$LAT_V.tar.gz "https://github.com/ich777/anope/releases/download/$LAT_V/Anope-v$LAT_V.tar.gz" ; then
		echo "---Successfully downloaded Anope v$LAT_V---"
	else
		echo "---Something went wrong, can't download Anope v$LAT_V, putting container into sleep mode!---"
		sleep infinity
	fi
	echo "---Moving configruation---"
	mv ${DATA_DIR}/conf/ /tmp/
	mv ${DATA_DIR}/data/ /tmp/
	mv ${DATA_DIR}/logs/ /tmp/
	tar -C ${DATA_DIR} --strip-components=1 --overwrite -xf ${DATA_DIR}/Anope-v$LAT_V.tar.gz
	rm ${DATA_DIR}/Anope-v$LAT_V.tar.gz
	echo "---Restoring configuration---"
	rm -R ${DATA_DIR}/conf/ ${DATA_DIR}/data/ ${DATA_DIR}/logs/
	mv /tmp/conf/ ${DATA_DIR}/
	mv /tmp/data/ ${DATA_DIR}/
	mv /tmp/logs/ ${DATA_DIR}/
elif [ "$CUR_V" == "$LAT_V" ]; then
	echo "---Anope v$CUR_V up-to-date---"
fi

echo "---Preparing Server---"
echo "---Checking if configuration is in place---"
if [ ! -f ${DATA_DIR}/conf/services.conf ]; then
	echo "---No configuration file found, copying!---"
	mv ${DATA_DIR}/conf/example.conf ${DATA_DIR}/conf/services.conf
	sleep 2
	echo "---Setting initial values in config file!---"
	sed -i "/name = \"services.host\"/c\\\tname = \"${HOST#*.}\"" ${DATA_DIR}/conf/services.conf
	sed -i "/value = \"services.localhost.net\"/c\\\tvalue = \"${HOST}\"" ${DATA_DIR}/conf/services.conf
	sed -i "/host = \"127.0.0.1\"/c\\\thost = \"${IP_ADDR}\"" ${DATA_DIR}/conf/services.conf
	sed -i "/ssl = no/c\\\tssl = ${SSL}" ${DATA_DIR}/conf/services.conf
	sed -i "/port = 7000/c\\\tport = ${PORT}" ${DATA_DIR}/conf/services.conf
	sed -i "/password = \"mypassword\"/c\\\tpassword = \"${PASSWORD}\"" ${DATA_DIR}/conf/services.conf
	sed -i "/name = \"services.localhost.net\"/c\\\tname = \"${LOCAL_HOSTNAME}.${HOST#*.}\"" ${DATA_DIR}/conf/services.conf
	sed -i "/name = \"inspircd20\"/c\\\tname = \"${IRCD}\"" ${DATA_DIR}/conf/services.conf
	sed -i "/networkname = \"LocalNet\"/c\\\tnetworkname = \"${LOCAL_HOSTNAME}.${HOST#*.}\"" ${DATA_DIR}/conf/services.conf
	sed -i "/casemap = \"ascii\"/c\\\tcasemap = \"${CASEMAP}\"" ${DATA_DIR}/conf/services.conf
else
	echo "---Configuration found!---"
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
screen -wipe 2&>/dev/null

echo "---Starting Anope---"
cd ${DATA_DIR}
${DATA_DIR}/bin/services
sleep 3
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
tail -F "$(find ${DATA_DIR}/logs/ -name 'services*' | tail -1)"