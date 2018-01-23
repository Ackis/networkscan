#!/bin/bash

DATE=$(date +%Y%m%d)

# Get System Info
#lsb_release -a
#uname -a

################################
#
# Scans
#
################################


# List all netstat ports

# -t == --tcp
# -a == --all
# -u == --udp
# -p == --program
# -e == --extend
# -n == --numeric

#sudo netstat -taupen
#sudo netstat --tcp --udp --all --udp --program --extend --numeric

#nmap --iflist
#nmap -sL 192.168.0.0/24

#sudo nmap -sS -sU -PN -p 1-65535 192.168.0.0/24

#nmap --reason --osscan-guess -oA ~/nmap 192.168.0.0/24


# Port Scan Internal Network
sudo nmap -v -iL iprange -A -oG /opt/syscheck/nmapscan -oX /opt/syscheck/nmapscan.xml

# Update Nikto Library Definitions
sudo perl /opt/nikto/nikto.pl -update

# Run Nikto on all hosts identified on the local network
sudo perl /opt/nikto/nikto.pl -Format html -maxtime 600s -output /opt/syscheck/nikto.html -C all -host /opt/syscheck/nmapscan

# Run Tiger
sudo /usr/sbin/tiger -l /opt/syscheck -H -e


################################
#
# Assign Permissions
#
################################

sudo chmod go+r -R /opt/syscheck/
sudo chown root:adm -R /opt/syscheck/

################################
#
# Copy Reports
#
################################

# NMAP Reports
# Convert xml output into html
sudo xsltproc /opt/syscheck/nmapscan.xml -o /opt/syscheck/nmapscan.html
# Copy html report to our reports directory.
sudo cp /opt/syscheck/nmapscan.html /var/log/reports/nmap.html

# Nikto Reports
sudo cp /opt/syscheck/nikto.html /var/log/reports/nikto.html

# Tiger Reports
sudo cp /opt/syscheck/security.report* /var/log/reports/tiger.html

################################
#
# Clean up reports
#
################################

# Remove old xml file
sudo rm -f /opt/syscheck/nmapscan.xml

# Backup NMAP Reports
sudo mv /opt/syscheck/nmapscan.html /opt/syscheck/nmap/scan_$DATE.html
sudo mv /opt/syscheck/nmapscan /opt/syscheck/nmap/scan_$DATE

# Backup Nikto Reports
sudo mv /opt/syscheck/nikto.html /opt/syscheck/nikto/nikto_$DATE.html

# Backup Tiger Reports
sudo mv /opt/syscheck/security.report* /opt/syscheck/tiger/

#execute
#sudo /usr/bin/nikto -Format html -h 192.168.0.199 -p 80,443,8080,8081,9091,5050,10000,32400 -o /var/log/reports/Nikto.html -C all

#sudo /usr/sbin/tiger -l /opt/syscheck -H -E -e
