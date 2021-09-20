# VMWare ESXi unofficial SOAP api client
Allows to start/stop esxi virtual machines via internal soap api, because REST api is only available for paid vcenter installations.
Originally created to use in jenkins with "Slave SetupPlugin" to poweroff unused build VMs.
Tested with ESXi 6.7.0 U3.

# Installation

**Create separate ESXi user (use root is not is the best practice)**
* Go to ESXi web panel
* In "Manage > Security & Users > Roles" add new role (for example, "Manage VM Power") with Permissions "Root > System" and "Root > VirtualMachine > Interact > PowerOn/PowerOff"
* In "Manage > Security & Users > Users" add new user.
* Open required virtual machine(s), in menu "Actions" open "Permissions".
* Add previously added user.
* Next, select user, press "Assign role" and add previously added role.

**Setup script**
* Clone repository
* Edit script settings: **ESXI_HOST**, **ESXI_LOGIN** and **ESXI_PASSWORD**.
* Get required VM id: open VM page in the web panel, vm id will be in the url (example url ``https://esxi.local/ui/#/host/vms/281``, vm id is **281**).
* Run script with params ``<vm id> <start|stop>`` (example ``./esxi_api.sh 281 start``).