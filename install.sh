#!/bin/bash

helm upgrade --install --values ./values-me.yaml observability ~/work/github/charts/stable/prometheus-operator --namespace observability
./autoscaler/vertical-pod-autoscaler/hack/vpa-up.sh

kubectl create namespace demo
kubectl apply -n demo -f ./example.yaml
kubectl apply -n demo -f ./hpa.yaml

# follow
kubectl get deploy -n demo resource-consumer -o yaml
kubectl get hpa -n demo resource-consumer -w
kubectl get nodes -w


curl --data "millicores=$((RANDOM%300+100))&durationSec=600" http://34.68.119.97:8080/ConsumeCPU

kubectl delete -n demo -f ./hpa.yaml
kubectl patch deployment -n demo resource-consumer --patch '{"spec": {"replicas": 3}}'
kubectl apply  -n demo -f ./vpa.yaml


curl --data "millicores=$((RANDOM%800+300))&durationSec=600" http://34.68.119.97:8080/ConsumeCPU

kubectl get vpa -n demo resource-consumer -o yaml
kubectl get pods -n demo -w -o yaml
kubectl get pods -n demo resource-consumer-67bb9bb76c-rj8ww -o yaml



rate(container_cpu_usage_seconds_total{namespace="demo",container_name="resource-consumer"}[5m])
count(node_uname_info)
