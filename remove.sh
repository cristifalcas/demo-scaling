#!/bin/bash

helm delete --purge observability
kubectl delete namespace demo
./autoscaler/vertical-pod-autoscaler/hack/vpa-down.sh
