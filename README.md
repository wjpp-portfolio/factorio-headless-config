# Factorio headless config
 config files and scripts for configuring and running a factorio headless server on aws from Windows desktop
 
 ## Prereqs
 .pem keypair created and downloaded into Downloads folder locally

 ## Steps
 1. start instance in aws
 2. paste instance address into ec2_instance variable in `factorio_server_config.bat`
 3. rename pem_key to correct file name
 4. run `factorio_server_config.bat`

## factorio_server_config.bat
### 1. configure new instance
sets up ec2 instance for factorio by creating user, directories, and downloading factorio headless server config and extracting it, and creating a service to run the server.  Also uploads headless server config files.  Note the config on the machine is via shell script `configure_new_ec2_instance.sh`
### 2. upload save to server
uploads chosen save file from default windows save location to server and starts server service
### 3. upload server config files
uploads config files for headless server and restarts factorio service
### 4. downloads save file back into local factorio save directory
