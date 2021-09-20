#!/bin/sh
COOKIE_FILE=~/.esxi_cookies.txt
ESXI_HOST="https://esxi.local"
ESXI_LOGIN="api-user"
ESXI_PASSWORD="1234567890"
VM=$1
ACTION=$2

if [ "$VM" = "" ]
then
  echo "Usage: $0 <vm id> <start|stop>"
  exit 1
fi


#Login
ret=$(curl --write-out "%{http_code}" --silent --output /dev/nul -c $COOKIE_FILE -k ''"$ESXI_HOST"'/sdk/' -H 'Cookie: vmware_client=VMware' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: text/xml' -H 'SOAPAction: urn:vim25/6.7.3'  -H 'Origin: https://esxi.lan' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://esxi.lan/ui/' -H 'Cookie: vmware_client=VMware' --data-raw '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Header><operationID>esxui-723e</operationID></Header><Body><Login xmlns="urn:vim25"><_this type="SessionManager">ha-sessionmgr</_this><userName>'"$ESXI_LOGIN"'</userName><password>'"$ESXI_PASSWORD"'</password><locale>en-US</locale></Login></Body></Envelope>')

if [ "$ret" != "200" ]
then
  echo "Can't login to the ESXi"
  exit 1
fi

#exit 0

case "${ACTION}" in
	start)
		ret=$(curl --write-out "%{http_code}" --silent --output /dev/null  -b $COOKIE_FILE -k ''"$ESXI_HOST"'/sdk/'  -H 'Cookie: vmware_client=VMware'  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: text/xml' -H 'SOAPAction: urn:vim25/6.7.3' -H 'Origin: https://esxi.lan' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://esxi.lan/ui/' --data-raw '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Header><operationID>esxui-b8c5</operationID></Header><Body><PowerOnVM_Task xmlns="urn:vim25"><_this type="VirtualMachine">'"$VM"'</_this></PowerOnVM_Task></Body></Envelope>')

		if [ "$ret" != "200" ]
		then
		  echo "Can't start vm $VM"
		  exit 1
		fi
		;;

	stop)
		ret=$(curl --write-out "%{http_code}" --silent --output /dev/null -b $COOKIE_FILE -k  ''"$ESXI_HOST"'/sdk/' -H 'Cookie: vmware_client=VMware' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0) Gecko/20100101 Firefox/78.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: text/xml' -H 'SOAPAction: urn:vim25/6.7.3' -H 'Origin: https://esxi.lan' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://esxi.lan/ui/' --data-raw '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><Header><operationID>esxui-fd7b</operationID></Header><Body><ShutdownGuest xmlns="urn:vim25"><_this type="VirtualMachine">'"$VM"'</_this></ShutdownGuest></Body></Envelope>')
		if [ "$ret" != "200" ]
		then
		  echo "Can't stop vm $VM"
		  exit 1
		fi
		;;

	*)
		echo "Usage: $0 <vm id> <start|stop>"
		exit 1
		;;
esac

rm $COOKIE_FILE
