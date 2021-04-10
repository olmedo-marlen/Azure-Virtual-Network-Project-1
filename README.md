# Automated ELK Stack & Beats Deployment

### The files in this repository were used to configure the network depicted below.

![alt text](https://github.com/IrishLuck1/CyberSec/blob/main/Diagrams/Elk-Stack-Project-Diagram.png)
```diff
The files/playbooks listed below have been tested and used to generate a live ELK deployment on Azure. They can be used
to either recreate the entire deployment pictured above. Alternatively, these files can be modified to install only
certain pieces of it; such as Filebeat/Metricbeat or any other Beats desired.
```
- [CLICK to view - Elk-Server-Deployment Playbook](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/elk-server-deployment.yml)
- [CLICK to view - FileBeat Deployment Playbook](Ansible/filebeat-playbook.yml)
- [CLICK to view - MetricBeat Deployment Playbook](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/metricbeat-playbook.yml)

**This document contains the following details:**
- **Description of the Topology**
- **Access Policies**
- **ELK Configuration**
    - **Beats in Use**
    - **Machines Being Monitored**
- **ELK Deployment, Play by Play**
- **Beats Deployment, Play by Play**

# Description of the Topology
```diff
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the Damn Vulnerable Web
Application.  Load balancing ensures that the application will be highly available, in addition to restricting access
to the network.

Load Balancing plays an important security role as computing moves evermore to the cloud. The off-loading function
of a load balancer defends an organization against distributed denial-of-service (DDoS) attacks. It does this by
shifting attack traffic from the corporate server to a public cloud provider.  This is important for accomplishing
availability in the CIA triad.
```
```diff
A Jumpbox is a secure computer that all admins first connect to before launching any administrative task or use
as an origination point to connect to other servers or untrusted environments.
```
```diff
Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the data and system logs.  
It's recommended to use beats in tandem with Logstash.
```
```diff
Filebeat is a light weight log shipper installed as an agent on your servers for forwarding and centralizing log
data.  Filebeat monitors the log files that you specify ships them to either Logstash or Elasticsearch to be
processed, indexed and made viewable by Kibana.
```
- https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-overview.html
```diff
Metricbeat is another lightweight log shipper that collects metrics / metadata ships them to Logstash to be
processed and sent to Elasticsearch to be indexed and made viewable by Kibana.  For more information on what
metrics / metadata can be recorded please see the below link.
```
- https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-overview.html


### **The configuration details of each machine may be found below.**
| Name             | Function          | IP Address        | Operating System                |
| -----------------|:-----------------:|:-----------------:|:-------------------------------:|
| Jumpbox          | Management        | 10.0.0.4/16       | Ubuntu Server (18.04-LTS) Linux |
| Web1 - DVWA      | WebServer         | 10.0.0.5/16       | Ubuntu Server (18.04-LTS) Linux |
| Web2 - DVWA      | WebServer         | 10.0.0.6/16       | Ubuntu Server (18.04-LTS) Linux |
| Web3 - DVWA      | WebServer         | 10.0.0.7/16       | Ubuntu Server (18.04-LTS) Linux |
| Elk Server       | SysLog            | 10.1.0.4/16       | Ubuntu Server (18.04-LTS) Linux |

# Access Policies
```diff
The machines on the internal network are not exposed to the public Internet.
Only the Jumpbox machine can accept connections from the Internet. Access to this machine is only allowed
from the following IP addresses:
On-premises public IP X.X.X.X
```
```diff
Machines within the network can only be accessed by Jumpbox Docker Container.
I allowed the JumpBox / Bastion Host to access the ELK-VM in order to manage and push ansible playbooks.
JumpBox 10.0.0.4/16
```

### Summary of Access Policies / Firewall Rules in the table below.
| RedTeamSG DMZ ______________________________________________________________ |
|----------------------------------------------------------------------------- |

| Name                         | Publicly Accessible | Allowed IP Addresses    |
| -----------------------------|:-------------------:|:-----------------------:|
| Bastion / Ansible Controller | Yes                 | Public_IP:22            |
| Web1,2 & 3 - DVWA            | Yes                 | Public_IP:80            |
| Ansible - Web1,2 & 3         | No                  | 10.0.0.4:22             |

#

| Elk-Server-NSG DMZ __________________________________________________________|
|:----------------------------------------------------------------------------:|

| Name                         | Publicly Accessible | Allowed IP Addresses    |
| -----------------------------|:-------------------:|:-----------------------:|
| Elk-Server/Kibana            | Yes                 | X.X.X.X:5601            |
| Ansible (Bastion)/Elk-Server | No                  | 10.0.0.4:22             |


# **Elk Configuration**
```diff
Ansible was used to automate configuration of the ELK machine. No configuration was performed manually,
which is advantageous because...  Being able to automate tasks saves time which saves money and provides
greater productivity and accuracy due to the lack of human error. It's also widely used and has a large
support community.  Further benefits are its simplicity to setup and use, no special coding skills are
necessary to use Ansible's Playbooks.
```

- **The Elk-Server-Deployment Playbook implements the following tasks:**
    - **Installs docker.io**
    - **Installs pip3**
    - **Updates the vm.max_map_count in the /etc/sysctl.conf file to increase memory size to value: "262144"**
    - **Downloads and launches a Docker ELK Container**
    - **Enable's Docker service on boot**

**The following screenshot displays the result of running docker ps -a (List all containers) after successfully configuring the ELK instance.**
![alt text](https://github.com/IrishLuck1/CyberSec/blob/main/ScreenShots/ElkServerAutomation.png?raw=true)

**Target Machines & Beats**
- **This ELK server is configured to monitor the following machines:**
    - **Web1**
    - **Web2**
    - **Web3**
- **We have installed the following Beats on these machines:**
    - **Filebeat**
    - **Metricbeat**
- **These Beats allow us to collect the following information from each machine:**
    - **Linux /Var Logs**
    - **Cloud Metadata**
    - **Host Metadata**

```diff
After Filebeat has been deployed you should expect log event data to start being forwarded to Logstash
and Elasticsearch.  With Filebeat you as the administrator set which files are to be monitored.  For
example: In a Linux environment if you have auditd installed you can setup a cronjob with crontab
to create logs anytime account changes are made and have them stored in the /var/log/ directory.  

Anytime a user account change is made you can have that change write a new file or append an existing
log file.  When filebeat detects a file size change in the log file, the filebeat input will then start
a harvester, the harvester will read the log file line by line until it reaches the end and then it will initiate a
close_inactive and the session will end and the harvester will close.  

At this point if another account
change is made and we are appending, the logfile size will change and then the filebeat input will repeat
this process forwarding the new event data to the logstash or elasticsearch to be viewed by Kibana.
This is how you would monitor account changes with a Linux system.  Please see the below links for more
information on filebeat.
```

- https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-overview.html
- https://www.elastic.co/guide/en/beats/filebeat/current/how-filebeat-works.html
```diff
After Metricbeat has been deployed you should expect to see Metric Metadata being forwarded to Elasticsearch.
The Metricbeat Azure Module will consist of one or more Metricsets This module specifies details about the
service including how to connect, how often to collect metrics, and which metrics to collect.  Each Metricset
is the part of the module that fetches and structures the data.  Rather than collecting each metric as a separate
event, Metricsets retrieve a list of multiple related metrics in a single request to a remote system.  

For example: The Azure Module provides an info Metricset that collects information and statistics from the Azure
Module by running the INFO command and parsing the returned result.  Please refer to the below link for more
information on the Azure module for Module-specific configuration notes and Metricsets. This is how we would
create dashboards to monitor Azure Metrics such as the following:
```
- https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-module-azure.html
- https://www.elastic.co/guide/en/beats/metricbeat/current/defining-processors.html

| add_cloud_metadata  | add_host_metadata     |
|---------------------|-----------------------|
| Compute_vm          | netinfo.enabled       |
| Compute_vm_scalset  | cache.ttl             |
| storage             | geo.name              |
| Container_Instance  | geo.location          |
| Container_registry  | geo.continent_name    |
| Container_service   | geo.country_name      |
| datbase_account     | geo.region_name       |
| billing             | geo.city_name         |
| app_insights        | geo.country.iso_code  |
| app_state           | geo.region_iso_code   |
|                     | replace_fields        |




# Using the Playbook! You could say the below is a... Play by Play?... 😂

![](https://github.com/IrishLuck1/CyberSec/blob/main/ScreenShots/ezgif-6-f88aa07dc25f.gif)
```diff
In order to use the playbook, you will need to have an Ansible control node already configured, in this deployment the
ansible control node was located on the **Bastion Host / Jumpbox**. Assuming you have such a control node provisioned,
SSH into the control node and follow the steps below:
```
```diff
1. Copy the Elk-Server-Deployment.yml file to /etc/ansible/ directory. (This file is your playbook)
```
   - [CLICK to view - Elk-Server-Deployment.yml](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/elk-server-deployment.yml)
```diff
2. On line 107 of the Ansible.cfg file you will see the entry remoteuser="username" make sure to change this to the
username of your admin account on the elk server.
*note - The stock configuration should be sufficient for most users, but there may be reasons you would want to
change them.
```
   - [CLICK to view - Ansible.cfg](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/Ansible.cfg)
```diff
3. Make sure to update the Ansible "hosts" file to include the [elk] group, the elk server IP Address(s) and the
Ansible Interpreter.  This is not your system hosts file but the ansible specific hosts file located in the
/etc/ansible/ directory.  

When you run your playbook, it's going to look in the ansible hosts file for the "Group" with the IP Address(s) of the
servers you wish to deploy elk to.  It will locate the [elk] group and it'll see the 10.1.0.4 IP Address(s) and it'll
run the playbook to that IP Address(s).  In this environment we only had 1 elk server to deploy.  If you wanted to
deploy multiple you'd only need to add the additional IP Address(s) to the hosts file in the [elk] group with the
interpreter and the ansible control node would run the playbook on all IP's in the [elk] group.

#A collection of hosts belonging to the "elk" group
[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3


While you are viewing the hosts file make sure to notice the [webservers] group.  Your playbooks will reference the
hosts file, and then it'll point toward the group.  This is how your playbook will find the remote nodes to push
configurations to.

# Ex 2: A collection of hosts belonging to the 'webservers' group
[webservers]
10.0.0.6 ansible_python_interpreter=/usr/bin/python3
10.0.0.5 ansible_python_interpreter=/usr/bin/python3
10.0.0.7 ansible_python_interpreter=/usr/bin/python3
```
   - [CLICK to view - Ansible Hosts File](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/hosts)
```diff
4. Navigate to the /etc/ansible directory where the playbook is located.  
Use the following command on your terminal to run the playbook
"ansible-playbook elk-server-deployment.yml"
```

**You should see similar output to what is in the below screenshot.**
![alt text](https://github.com/IrishLuck1/CyberSec/blob/main/ScreenShots/PlaybookOutput.png)

```diff
5. Verification of deployment.
From the Bastion Host / Jumbox run the following command to SSH into the newly deployed elk-server.
    - ssh sysadmin@10.1.0.4
Once you are in the elk-server command line run the following command.
    - sudo docker ps -a
```
**If successful you should see the following output displaying the sebp/elk:761 docker container...**
![alt text](https://github.com/IrishLuck1/CyberSec/blob/main/ScreenShots/ElkServerAutomation.png)

```diff
6. To verify that your ELK Docker has been deployed up and running properly you will connect to Kibana.
To do this you will navigate to the Public or Private IP Address configured for the elk-server
on port 5601.  Use the following URL in your browser to verify both Public and Private access are working.
    - http://10.1.0.4:5601  (Private IP)
    - http://X.X.X.X:5601   (X.X.X.X  is your Public IP if configured to have Public Access)
```

**If successful you should see the following output displaying the Kibana landing page**
![alt text](https://github.com/IrishLuck1/CyberSec/blob/main/ScreenShots/Kibana.png)


# **Let's get the heart of our deployment BEATING!** ❤️

![](https://media.giphy.com/media/3o6Mb96ZOdz0U2TDag/giphy.gif)

**HOW DO WE DO IT???!!!**
```diff
The below will be the instructions on how to automate the deployment process of our BEATS.  We will be deploying
Filebeat & Metricbeat.  The process at this point will be much shorter now that we have the elk-server deployed.
The deployment is very similar to the above instructions on deploying the elk-server.
```
```diff
1. Copy the filebeat-configuration.yml & the filebeat-playbook.yml to the /etc/ansible/files directory.
   Copy the metricbeat-configuration.yml & the metricbeat-playbook.yml to the /etc/ansible/files directory.
```
   - [CLICK to view - Filebeat-Configuration.yml](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/filebeat-configuration.yml)
   - [CLICK to view - Filebeat-Playbook.yml](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/filebeat-playbook.yml)
   - [CLICK to view - Metricbeat-Confgiuration.yml](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/metricbeat-configuration.yml)
   - [CLICK to view - Metricbeat-Playbook.yml](https://github.com/IrishLuck1/CyberSec/blob/main/Ansible/metricbeat-playbook.yml)
```diff
2. From the /etc/ansible/files/ directory then run the following command to launch the filebeat-playbook.
    - ansible-playbook filebeat-playbook.yml
```
```diff
3. From the /etc/ansible/files/ directory then run the following command to launch the metricbeat-playbook.
    - ansible-playbook metricbeat-playbook.yml
```
**The below screen shot displays only the installation of filebeat but the output will be the same for metricbeat but
instead of saying filebeat it'll say metricbeat during the process.**
![alt text](https://github.com/IrishLuck1/CyberSec/blob/main/ScreenShots/filebeatinstall.png)
```diff
4. After both playbooks have successfully run SSH into each webserver and verify Filebeat/Metricbeat installation
by running a ls command and you should see both .deb files installed listed below.
    - filebeat-7.4.0-amd64.deb
    - metricbeat-7.4.0-amd64.deb
```
```diff
5. The final step is to verify you are receiving logs from your webservers, you will navigate to your Kibana site
Use the following URL in your browser to verify both Public and Private access are working and you are receiving logs.
    - http://10.1.0.4:5601  (Private IP)
    - http://X.X.X.X:5601   (X.X.X.X  is your Public IP if configured to have Public Access)
```
**If successful you should see the following log events in Kibana**
![alt text](https://github.com/IrishLuck1/CyberSec/blob/main/ScreenShots/Filebeat.png)

# CONGRADULATIONS ON YOUR DEPLOYMENT!!!
![](https://media.giphy.com/media/11sBLVxNs7v6WA/giphy.gif)
