#!/bin/bash
set -e

points=0
query_out=$(mktemp)

function finish {
  echo "Your total points: $points out of 9! Congratz! You could ask your PM for a raise."
}
trap finish EXIT

echo "Howdy! thank you for participating in our voluntary homework, let's see how much we like the solution."
echo 'Bear in mind that I am a very simple checker, so if you named your resources *less correctly*, I might not find them...'
echo

kubectl get svc,deployment,statefulset,secret,pvc -l zadanie=kubernetes -o json > $query_out

total_items=$(jq '.items|length' $query_out)
echo -n "Found $total_items items labeled with zadanie=kubernetes... "
if [[ "$total_items" -eq 7 ]] || [[ "$total_items" -eq 6 ]]; then
  echo "promising!"
  points=$((points+1))
else
  echo "not so good... (expected 6 or 7)"
fi

echo -n "Searching for an outside-facing service... "
loadBalancerResource=$(jq '.items[]|select(.kind == "Service" and .spec.type == "LoadBalancer")' $query_out)
loadBalancerFound=$(jq '[.items[]|select(.kind == "Service" and .spec.type == "LoadBalancer")]|length' $query_out)

if [[ "$loadBalancerFound" -eq 0 ]]; then
  echo "No load balancer found! Sad panda, but we will give you a chance..."
  echo
  points=$((points-9))
else
  echo "got it!"
  points=$((points+1))

  loadBalancerIp=$(echo $loadBalancerResource | jq -r '.status.loadBalancer.ingress[].ip')
  echo "Load balancer's IP is... $loadBalancerIp"
  visitCounter=$(curl -s $loadBalancerIp | grep -o ' [[:digit:]]\+ times so far')
  echo "You have a lot of traffic there! visited$visitCounter! Watch out for them bots..."
  echo
fi

echo "Let's see how you built your application..."

# REDIS
redisResource=$(jq '.items[]|select(.metadata.name == "redis-deployment")' $query_out)
redisKind=$(echo $redisResource | jq '.kind')

if [[ "$redisKind" == "StatefulSet" ]]; then
  points=$((points+2))
else
  points=$((points+1))
fi

echo "So your redis is a $redisKind... nice!"


echo "Let's count out everything else that you have..."
echo
services=$(jq '.items[]|select(.kind == "Service")|.metadata.name' $query_out)
servicesCount=$(echo "$services"| wc -l)
echo "$servicesCount service(s):"
echo "$services"
echo
points=$((points + servicesCount))

deployments=$(jq '.items[]|select(.kind == "Deployment")|.metadata.name' $query_out)
deploymentsCount=$(echo "$deployments" | wc -l)
echo "$deploymentsCount deployment(s):"
echo "$deployments"
echo
points=$((points + deploymentsCount))

pvc=$(jq '.items[]|select(.kind == "PersistentVolumeClaim")|.metadata.name' $query_out)
pvcCount=$(echo "$pvc" | wc -l)
echo "$pvcCount PVCs:"
echo "$pvc"
echo
points=$((points + pvcCount))

secrets=$(jq '.items[]|select(.kind == "Secret")|.metadata.name' $query_out)
secretsCount=$(echo "$secrets" | wc -l)
echo "$secretsCount secret(s):"
echo "$secrets"
echo
points=$((points + secretsCount))

