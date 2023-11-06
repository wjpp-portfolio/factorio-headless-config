import boto3
import sys
import subprocess
import ansible

KEY_PATH = '$HOME/factorio_pem.pem'
ANSIBLE_PLAYBOOK = 'playbook.yaml'
INSTANCE_USER = 'ec2-user'

class Game_Server:
    def __init__(self, aws_session, template_name):
        self.dns_name = None
        self.state = None
        self.session = aws_session

        self.deploy_game_sever(self.session, template_name)

    def deploy_game_sever(self, aws_session, template_name):
        print('Launching instance')
        start_instance = self.launch_instance(template_name)
        self.server_id = start_instance['Instances'][0]['InstanceId']

        print('Waiting for server ready status ({})'.format(self.server_id))
        
        while True:
            info = self.get_instance_info()
            self.state = info['State']['Name']
     
            if 'PublicDnsName' in info.keys() and len(info['PublicDnsName']) > 0:
                self.dns_name = info['PublicDnsName']

            if self.dns_name is not None and self.state == 'running':
                break
        print('Configuring instance')
        print(self.server_id)
        print(self.dns_name)
        print(self.state)


        #ansible-playbook --private-key KEY_PATH -u INSTANCE_USER -i self.dns_name, ANSIBLE_PLAYBOOK



    def launch_instance(self, template):
        response = self.session.run_instances(
            LaunchTemplate={
                'LaunchTemplateName': template
            },
            MaxCount=1,
            MinCount=1,
        )
        return response

    def get_instance_info(self):
        response = self.session.describe_instances(InstanceIds=[self.server_id])
        return response['Reservations'][0]['Instances'][0] 
    
    def upload_save():
        pass

    def download_save():
        pass

    def upload_config():
        pass

    def update_status():
        pass

def get_running_instances(tag_value):
    response = ec2.describe_instances(
        Filters=[
            {
                #'Values': [
                #    'running',
                #],
                'Name': 'tag:project',
                'Values': [
                    tag_value,
                ],
            },
        ],
    )
    l = []
    for i in response['Reservations']:
        l.append(i['Instances'][0]['InstanceId'])
    return l

def terminate_all():
    response = ec2.terminate_instances(
        InstanceIds=get_running_instances('factorio'),
    )
    return response

list_of_servers = []
ec2 = boto3.client('ec2')

try:
    response = get_running_instances('factorio')
except:
    print("AWS not connected.  Please run `aws configure`.")
    sys.exit()

#if len(response['Reservations']) > 0:
#    for instance in response['Reservations'][0]['Instances']:
#        if instance['State']['Name'] == 'running':
#            list_of_servers.append(Game_Server(instance))
else:
    print("No running instances, starting one...")
    a = Game_Server(ec2, 'factorio_ec2_template')


    
"""
Serve ID     Game Version       Players       DNS name       Status

menu
1. Deploy new server
2. Upload save to server
3. Upload new config to server
4. Download save from server
5. Terminate instance

statuss
    ready
    deploying
    

"""


