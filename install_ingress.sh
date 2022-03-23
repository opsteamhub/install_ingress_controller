#!/bin/bash

aws eks update-kubeconfig --name $ENVIRONMENT-$REPO_NAME --region $AWS_REGION

kubectl apply -f templates/rbac-role-alb-ingress-controller.yaml

kubectl annotate serviceaccount -n kube-system alb-ingress-controller \
eks.amazonaws.com/role-arn=arn:aws:iam::$ACCOUNT_ID:role/role-ingress-controller-$ENVIRONMENT-$REPO_NAME


sed -i 's/\# - --cluster-name=devCluster/- --cluster-name=$ENVIRONMENT-$REPO_NAME/g' templates/alb-ingress-controller.yaml 

kubectl apply -f templates/alb-ingress-controller.yaml