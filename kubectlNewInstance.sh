#!/bin/bash

# delete the portainer namespace
sudo kubectl delete ns portainer
# start portainer 
sudo kubectl apply -f ~/Desktop/portainer/manual-testing/kubernetes/portainer-ee.yml
# start the agent
sudo kubectl apply -f ~/Desktop/portainer/manual-testing/kubernetes/portainer-agent-k8s.yaml
# get the ip and port of the agent to add to the instance as an agent endpoint
clusterIp=$(sudo kubectl -n portainer get all | grep service/portainer-agent | head -n 1 | awk '{print $3}')
port=$(sudo kubectl -n portainer get all | grep service/portainer-agent | head -n 1 | awk '{print $5}' | awk -F  ":" '/1/ {print $1}')

# wait for the portainer pod to start running
podName=$(sudo kubectl -n portainer get all | grep pod/portainer | tail -n 1 | awk '{print $1}')
while [[ $(sudo kubectl -n portainer get ${podName} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; 
    do echo "waiting for pod" && sleep 4;   
done
echo "pod started"

echo "${clusterIp}:${port}"