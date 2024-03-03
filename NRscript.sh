#!/bin/bash
#Welcome to my project
#student's name: peleg odi
#student code:S24 
#Class code:7736
#lecturer's name:natali erez	
  figlet "Welcome"
  													
function start ()
{
	
	sleep 3
	echo "what is your name?"
	read name
	echo "Good day $name,hope you doing well"
	sleep 2
}
start
	sleep 2
function geo()
{ 
	sudo apt-get install geoip-bin
}	

function nipeins ()
{
	# Download
	cd ~ > /dev/null 2>&1
	git clone https://github.com/GouveaHeitor/nipe > /dev/null 2>&1 && cd nipe
	sudo apt-get install -y cpanminus > /dev/null 2>&1
	sudo cpanm install Switch JSON LWP::UserAgent Config::Simple > /dev/null 2>&1
	sudo perl nipe.pl install > /dev/null 2>&1
	sudo perl nipe.pl start > /dev/null 2>&1
    
  
}



function nipeinfo()
{
	if [ -d ~/nipe ]
	then	
		 echo "(*)  nipe is installed"
	else
	    echo "(*)  nipe is not installed"
	    nipeins
	 fi
	 
	}
	
#nipeinfo
function geoinfo () # function to check if geoiplookup is installed if not install it
{
	if [ -f /usr/bin/geoiplookup ]
    then 
	  echo	 "(*)  iplookup is installed"
    else
	  echo "(*)  not installed" 
	  geo
	fi  	   
}
geoinfo

	# Check if whois is installed if not install it
if command -v whois &> /dev/null; then
    echo "(*)  whois is installed."
else
    echo "(*)  whois is not installed. Installing..."
    sudo apt-get install whois &> /dev/null
fi  

function view() #function to install nipe and activate it.
{
	cd ~ && cd nipe > /dev/null 2>&1

	sudo perl nipe.pl stop > /dev/null 2>&1

	sudo perl nipe.pl restart > /dev/null 2>&1

	sudo perl nipe.pl start > /dev/null 2>&1
	PUBIP=$(cd ~ && cd nipe ;sudo perl nipe.pl status |grep -i "ip" |awk '{print $3}')
	chkanon=$(geoiplookup $PUBIP |awk '{print $5}'|tr '[:upper:]' '[:lower:]')
	read -p "What is your associated country?: " CNTRY
}	

function restart()
{
	sudo perl nipe.pl restart > /dev/null 2>&1 
	sudo perl nipe.pl start > /dev/null 2>&1 
	sudo perl nipe.pl status > /dev/null 2>&1 
}

function truefalse ()
{

	cd ~ && cd nipe > /dev/null 2>&1 
	sudo perl nipe.pl stop > /dev/null 2>&1  
	sudo perl nipe.pl restart > /dev/null 2>&1  
	sudo perl nipe.pl start > /dev/null 2>&1 
		
	yes=$(sudo perl nipe.pl status | grep -io true|tr '[:upper:]' '[:lower:]')  
	no=$(sudo perl nipe.pl status | grep -io false|tr '[:upper:]' '[:lower:]') 
	
	if [ $yes = "true" ] 
	then
		view   
	elif [ $no = "false" ] 
	then
		restart   
		view  
	fi
}
truefalse




function CNTRY() 
{
	
	#This function creted to check if you are anonymous
	if [ "$chkanon" == "$CNTRY" ]
	then
	   echo "(*) Warning: The network connection is not anonymous. Exiting."
	   truefalse
	   CNTRY
	else
	sleep 2
	   echo "(*) your are anonymous"
		
	fi
}
CNTRY 	

function spoofinfo ()
{
	cd ~ && cd nipe
	ip_address=$(sudo perl nipe.pl status |grep -i "Ip" |awk '{print $(NF)}')
	country=$(geoiplookup $(sudo perl nipe.pl status |grep -i "Ip" |awk '{print $(NF)}') |awk '{print $(NF)}')
	echo "your ip: $ip_address "
	echo "country: $country "
}														
spoofinfo

 #function to show the uptime and country
 
function ssh ()
{
	#ip=192.168.188.129
	#pass=kali
	#user=kali
	read -p "What is the server ip adress? " ip
	read -p "What is the server password? " pass
	read -p "What is the server username? " user
	sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@$ip exit
	
	ipssh=$(sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@$ip 'hostname -I')
	uptime=$(sshpass -p $pass ssh -o StrictHostKeyChecking=no $user@$ip uptime)
	ip_address=$(curl -s ifconfig.co)
	cntry=$(sshpass -p "$pass" ssh -o StrictHostKeyChecking=no "$user@$ip" "geoiplookup \$(curl -s ifconfig.co) | awk '{print \$5}'")
	
	
	echo "Remote Server Details:"
	echo "ssh IP Address: $ipssh"
	echo "country IP Address: $cntry"
	echo "Uptime: $uptime"
}
ssh

cd /home/kali/Desktop/project 
function whois() #function to Explore the domain
{
	while true;
	do
		  read -p "put your domain name Please:" domain
			if nslookup "$domain" 2>/dev/null | grep -qi 'Non-'; 
				then 
					echo
					sleep 1
					echo "[*] Data Processor.."
					echo
					echo "domain exist"
					sleep 2 
					break  # breaid
				else
					echo
					sleep 1
					echo "[*] Does not exist"
					sleep 1
					echo
			fi 
	done

	
sshpass -p "$pass" ssh -o StrictHostKeyChecking=no "$user@$ip" "whois $domain " > whois.data

}
whois

function nmap() #saving to a nmap file to domain info above.
{
	
	
sshpass -p "$pass" ssh -o StrictHostKeyChecking=no "$user@$ip" "nmap $domain -F --open "  > nmap.data	

echo "(*)The domain information saved into a project file"
	sleep 3
echo "THANK YOU FOR USING MY SCRIPT"
	sleep 3
echo "This script was creted by Peleg odi"
	sleep 3
}
nmap




echo " $(date) :[*] data of nmap that scan '$domain' was saved into computer " >>log.data
echo " $(date) :[*] data of whois that scan '$domain' was saved into computer " >>log.data



#download sshpass											

