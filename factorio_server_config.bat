set ec2_instance=ec2-13-40-85-34.eu-west-2.compute.amazonaws.com
set ec2_user=ec2-user


set pem_key="C:\Users\will\Downloads\factorio_pem.pem"
set factorio_save_directory=C:\Users\will\AppData\Roaming\Factorio\saves\

@echo off
setlocal enabledelayedexpansion
cls

echo 1. configure new instance
echo 2. upload save to server
echo 3. upload server config files
echo 4. download save to local machine


set /P menu_action=enter an action:

IF %menu_action%==1 (
:: configures server but does NOT start service
	cls
	::upload files 
	scp -i %pem_key% configure_new_ec2_instance.sh %ec2_user%@%ec2_instance%:configure_new_ec2_instance.sh
	scp -i %pem_key% factorio.service %ec2_user%@%ec2_instance%:factorio.service
	scp -i %pem_key% server-settings.json %ec2_user%@%ec2_instance%:server-settings.json
	scp -i %pem_key% map-settings.json %ec2_user%@%ec2_instance%:map-settings.json
	scp -i %pem_key% map-gen-settings.json %ec2_user%@%ec2_instance%:map-gen-settings.json
	::install dos2unix as the script has windows line endings
	ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo yum -y install dos2unix
	::process script using dos2unix
	ssh -i %pem_key% %ec2_user%@%ec2_instance% dos2unix configure_new_ec2_instance.sh
	ssh -i %pem_key% %ec2_user%@%ec2_instance% dos2unix factorio.service
	::run the script then remove it
	ssh -i %pem_key% %ec2_user%@%ec2_instance% sh configure_new_ec2_instance.sh
	ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo rm configure_new_ec2_instance.sh
	)
IF %menu_action%==2 (
::uploads save then starts service
	cls
	dir /b /o %factorio_save_directory%
	set /P save_name=Enter save file name - inc zip:
	if exist %factorio_save_directory%!save_name! (
		ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo systemctl stop factorio
		ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo rm -r /opt/factorio/saves/*
		scp -i %pem_key% %factorio_save_directory%!save_name! %ec2_user%@%ec2_instance%:/opt/factorio/saves/!save_name!
		ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo systemctl start factorio
		)
	if not exist %factorio_save_directory%!save_name! echo file not found
	)
IF %menu_action%==3 (
	scp -i %pem_key% server-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/server-settings.json
	scp -i %pem_key% map-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/map-settings.json
	scp -i %pem_key% map-gen-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/map-gen-settings.json
	ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo systemctl restart factorio.service
	)
IF %menu_action%==4 (
	cls
	echo files on remote server
	ssh -i %pem_key% %ec2_user%@%ec2_instance% ls /opt/factorio/saves/
	set /P save_to_download=Enter save file name inc zip: 
	scp -i %pem_key% %ec2_user%@%ec2_instance%:/opt/factorio/saves/!save_to_download! %factorio_save_directory%!save_to_download!
	)