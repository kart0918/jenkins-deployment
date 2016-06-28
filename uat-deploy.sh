!/usr/bin/bash

# Public cloud authorization deploy scripts
# for UAT env.

# Prepare session variables
function add_vars_file {
    for file in $@
      do
        echo $file
        if [ -e "$file" ]; then
          export VARS_FILES+="-e @$file "
        fi
      done
}

# Check for parameters
if [ $# -ne 2 ]
  then
    echo "No argument supplied."
    echo "uat-deploy.sh <region> <component_name>"
    echo "eg. uat-deploy.sh wdc01 keystone"
    exit 1
fi

export DEPLOY_VARS=~/keystone-ansible-vars
export DEPLOY_ANSIBLE=~/keystone-ansible

region=$1
component=$2
# Set variables based on region
if [ $region = "wdc01" ]
 then
    add_vars_file $DEPLOY_ANSIBLE/playbook/roles/openstack-defaults/defaults/main.yml \
    $DEPLOY_VARS/pca-uat/pca-uat $DEPLOY_VARS/pca-uat/pca-uat-wdc $DEPLOY_VARS/pca-uat/pca-uat-wdc01
fi

##TODO Set the inventory file based on the components to be installed.
# Run the Ansible deployment
if [ $component = "keystone" ]
  then
    set -x
    ansible-playbook -i $DEPLOY_ANSIBLE/inventories/uat/uat_wdc01_keystone --private-key ~/.ssh/overcloud $DEPLOY_ANSIBLE/playbook/site.yml \
        $VARS_FILES || exit 1
    set +x
fi
