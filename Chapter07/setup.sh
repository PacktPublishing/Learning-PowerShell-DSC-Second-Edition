# YUM to install the required pre-requisites
sudo yum -y groupinstall 'Development Tools'
sudo yum -y install pam-devel openssl-devel python python-devel libcurl-devel wget

wget https://github.com/Microsoft/omi/releases/download/v1.1.0-0/omi-1.1.0.ssl_100.x64.rpm
wget https://github.com/Microsoft/PowerShell-DSC-for-Linux/releases/download/v1.1.1-294/dsc-1.1.1-294.ssl_100.x64.rpm

sudo rpm -Uvh omi-1.1.0.ssl_100.x64.rpm
sudo rpm -Uvh dsc-1.1.1-294.ssl_100.x64.rpm

#Open Firewall
sudo systemctl start firewalld.service
sudo firewall-cmd --zone=public --permanent --add-port=5986/tcp
sudo firewall-cmd --reload

#Ignore Certs (DSC does not support Self-Signed Certificates on Linux)
sed -i 's/^DoNotCheckCertificate.*/DoNotCheckCertificate=true/' /etc/opt/omi/conf/dsc/dsc.conf
cat /etc/opt/omi/conf/dsc/dsc.conf
 
#Change DSC Defaults with reboots
sed -i 's/.*RebootNodeIfNeeded = False.*/     RebootNodeIfNeeded = True;/' /opt/microsoft/dsc/Scripts/Register.py

#Configure the client
# /opt/microsoft/dsc/Scripts/Register.py --ServerURL "https://buildserver.laurierhodes.info:8080/PSDSCPullServer.svc" --ConfigurationMode "ApplyOnly" --RefreshMode Pull --ConfigurationName 42666de9-1330-4370-bc1f-99f12285af84 --RegistrationKey e2a2b9c3-5e16-43c4-9fb6-c395ba5c0b5f
