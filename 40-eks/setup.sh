#!/bin/bash

#~/log/config-workstation/<file-name>-<timestamp>.log
LOG_FOLDER="/home/ec2-user/log/config-workstation/"
SCRIPT_NAME=$(echo $0 | awk -F "/" '{print $NF}' | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d::%H:%M:%S)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
USERID=$(id -u)

mkdir -p $LOG_FOLDER

R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"

DEFAULT_ACCESS_KEY=$1
DEFAULT_SECRET_KEY=$2
DEFAULT_REGION="us-east-1"


VALIDATE(){
  if [ $1 -ne 0 ]
  then
    echo -e "$2 ... $R FAILED $N" | tee -a $LOG_FILE
    
    if [ $# -eq 3 ]
    then
      echo -e "$3" | tee -a $LOG_FILE
      exit 1
    fi
  else
    echo -e "$2 ... $G SUCCESS $N" | tee -a $LOG_FILE
  fi
}

# test
  # kubectl
    kubectl version --client &>> $LOG_FILE
    VALIDATE $? "Test kubectl" "kubectl not install correctly. Exiting..."
  # eksctl
    eksctl version &>> $LOG_FILE
    VALIDATE $? "Test eksctl" "eksctl not install correctly. Exiting..."
  # aws
    aws --version &>> $LOG_FILE
    VALIDATE $? "Test AWS CLI" "AWS CLI not install correctly. Exiting..."

# clone required repos
cd /home/ec2-user/
git clone https://github.com/MMahiketh/k8s-prctc.git &>> $LOG_FILE
git clone https://github.com/MMahiketh/k8s-expense.git &>> $LOG_FILE
git clone https://github.com/MMahiketh/helm-expense.git &>> $LOG_FILE

# aws configure
aws configure set aws_access_key_id $DEFAULT_ACCESS_KEY
aws configure set aws_secret_access_key $DEFAULT_SECRET_KEY
aws configure set default.region $DEFAULT_REGION

aws sts get-caller-identity &>> $LOG_FILE
VALIDATE $? "Connecting to aws" "Connection to aws failed. Exiting..."

# get eks credentials
aws eks update-kubeconfig --region us-east-1 --name expense-dev

# install ebs and efs drivers
kubectl apply -k 'github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.39' &>> $LOG_FILE
kubectl apply -k 'github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-2.1' &>> $LOG_FILE

# install metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml &>> $LOG_FILE

# install k9s
curl -sS https://webinstall.dev/k9s | bash

# setup AWS Load Balancer Controller
# Ingress Controller
#### Create an IAM OIDC provider
eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster expense --approve
#### Download IAM policy
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
#### Create an IAM policy using above file
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json
#### Create IAM service account
eksctl create iamserviceaccount --cluster=expense-dev --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::339712874850:policy/AWSLoadBalancerControllerIAMPolicy --override-existing-serviceaccounts --region us-east-1 --approve
#### Add the EKS chart repo to Helm
helm repo add eks https://aws.github.io/eks-charts
#### Install drivers
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=expense-dev --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
