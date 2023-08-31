set ec2_instance=ec2-13-42-26-28.eu-west-2.compute.amazonaws.com
set ec2_user=ec2-user


set pem_key="C:\Users\will\Downloads\factorio_pem.pem"
set factorio_save_directory=C:\Users\will\AppData\Roaming\Factorio\saves\

@echo off
setlocal enabledelayedexpansion
cls

echo 1. configure new instance
echo 2. upload save to server
echo 3. start server (select save)
echo 4. upload server config files
echo 5. download save to local machine


set /P menu_action=enter an action:

IF %menu_action%==3 (
    ::get file names, request entry, start server
	cls
	echo files on remove server
	ssh -i %pem_key% %ec2_user%@%ec2_instance% ls
	set /P save_name=Enter save file name - inc zip: 
	ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo /opt/factorio/bin/x64/factorio --start-server !save_name!
    )
	
IF %menu_action%==2 (
	cls
	dir /b /o %factorio_save_directory%
	set /P save_name=Enter save file name - inc zip:
	if exist %factorio_save_directory%!save_name! scp -i %pem_key% %factorio_save_directory%!save_name! %ec2_user%@%ec2_instance%:!save_name!
	if not exist %factorio_save_directory%!save_name! echo file not found
	)
	
IF %menu_action%==4 (
	scp -i %pem_key% server-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/server-settings.json
	scp -i %pem_key% map-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/map-settings.json
	scp -i %pem_key% map-gen-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/map-gen-settings.json
	)
	
IF %menu_action%==5 (
	cls
	echo files on remove server
	ssh -i %pem_key% %ec2_user%@%ec2_instance% ls
	set /P save_to_download=Enter save file name inc zip: 
	scp -i %pem_key% %ec2_user%@%ec2_instance%:!save_to_download! %factorio_save_directory%!save_to_download!
	)
IF %menu_action%==1 (
	cls
	::upload config script
	scp -i %pem_key% configure_new_ec2_instance.sh %ec2_user%@%ec2_instance%:configure_new_ec2_instance.sh
	::install dos2unix as the script has windows line endings
	ssh -i %pem_key% %ec2_user%@%ec2_instance% sudo yum -y install dos2unix
	::process script using dos2unix
	ssh -i %pem_key% %ec2_user%@%ec2_instance% dos2unix configure_new_ec2_instance.sh
	::run the script
	ssh -i %pem_key% %ec2_user%@%ec2_instance% sh configure_new_ec2_instance.sh
	::upload server config
	scp -i %pem_key% server-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/server-settings.json
	scp -i %pem_key% map-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/map-settings.json
	scp -i %pem_key% map-gen-settings.json %ec2_user%@%ec2_instance%:/opt/factorio/data/map-gen-settings.json
	)
