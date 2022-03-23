#!/bin/bash

export REPO_NAME=$REPO_NAME
export ACCOUNT_ID=$ACCOUNT_ID
export ENVIRONMENT=$ENVIRONMENT

aws eks update-kubeconfig --name $ENVIRONMENT-$REPO_NAME --region $AWS_REGION

kubectl apply -f templates/rbac-role-alb-ingress-controller.yaml

kubectl annotate serviceaccount -n kube-system alb-ingress-controller \
eks.amazonaws.com/role-arn=arn:aws:iam::$ACCOUNT_ID:role/role-ingress-controller-$ENVIRONMENT-$REPO_NAME

cd templates

sed -i 's/\# - --cluster-name=devCluster/- --cluster-name=${ENVIRONMENT}-${REPO_NAME}/g' alb-ingress-controller.yaml 

kubectl apply -f alb-ingress-controller.yaml