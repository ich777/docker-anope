# Anope in Docker optimized for Unraid
Anope is a set of IRC Services designed for flexibility and ease of use.

This container is configured by default to work with InspIRCd - fill out the required variables and start the container (also click on 'Show more settings' on the template page of InspIRCd to configure it for the Anope Services).

**WARNING:** If you change a variable here it has no effect to the configuration - the configuration file is only changed on the first start of the container.

If you made a mistake at the first start go to your the '/anope/conf' directory in your appdata folder and delete the file 'services.conf' after a restart of the container the values will be written again).

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for configfiles and the application | /anope |
| HOST | Specify the full hostname from your IRCd (must be the same as configured in your IRCd Server). | irc.example.com |
| IP_ADDR | Specify the IP Address from your IRCd (if you run it on Unraid it is usually the IP address of Unraid). | UnraidIP |
| SSL | Use SSL to establish the connection (if your IRCd is on the same network this is no problem since Anope talks internally to your IRCd - use this carefully since you have to configure some extra settings in the services.conf itself - valid options are: 'yes' or 'no'). | yes |
| PORT | The Server port of your IRCd (usually 7000 is without SSL - this is be no proble if you connect it to your internal network since it only talks internally to your IRCd - if you want to enable SSL you have to configure some extra settings in the services.conf itself). | 7000 |
| PASSWORD | This have to be the same as your IRCd Service Password (if you are using InspIRCd click on 'Show more Settings'). | ServicesPWDfromInspIRCd |
| IRCD | Set your IRCd type (valid options are: bahamut, charybdis, hybrid, inspircd12, inspircd20, inspircd3, ngircd, plexus, ratbox, unreal (for 3.2.x), unreal4) | inspircd3 |
| CASEMAP | Specify the casemap of your IRCd (if you use InspIRCd the default value is: 'rfc1459' other clients often use for example 'ascii') | rfc1459 |
| LOCAL_HOSTNAME | Specify the hostname where Anope is available (this has to be something different than your IRCd hostname, you don't have to make it reachable from outside or create any port forwarding - leave this value as it is) | services |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value for new created files | 0000 |
| DATA_PERMS | Data permissions for config folder | 770 |

## Run example
```
docker run --name Anope -d \
	-p 6667:6667 -p 6697:6697 -p 7000:7000 -p 7001:7001 \
	--env 'HOST=irc.example.com' \
	--env 'IP_ADDR=UnraidIP' \
	--env 'SSL=yes' \
	--env 'PORT=7000' \
	--env 'PASSWORD=ServicesPWDfromInspIRCd' \
	--env 'IRCD=inspircd3' \
	--env 'CASEMAP=rfc1459' \
	--env 'LOCAL_HOSTNAME=*@*' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERMS=770' \
	--volume /path/to/anope:/anope \
	ich777/anope
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!
 
#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/