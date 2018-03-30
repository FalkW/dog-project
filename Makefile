EC2_REGION=eu-west-1
EC2_INSTANCEID=i-02c821079ecefd2b6
EC2_URL=$(shell aws --region $(EC2_REGION) ec2 describe-instances --instance-ids $(EC2_INSTANCEID) --query "Reservations[*].Instances[*].PublicIpAddress" --output=text)

# sync code
syncup:
	rsync -e "ssh -i ~/.ssh/deeplearning" -avz --exclude=".git/" --exclude="bottleneck_features/" --exclude="dogImages/" --exclude="lfw/" . ubuntu@$(EC2_URL):~/dog-project
syncdown:
	rsync -e "ssh -i ~/.ssh/deeplearning" -avz --exclude=".git/" --exclude="bottleneck_features/" --exclude="dogImages/" --exclude="lfw/" ubuntu@$(EC2_URL):~/dog-project/ .
# start/stop instance
ec2stop:
	aws --region $(EC2_REGION) ec2 stop-instances --instance-ids $(EC2_INSTANCEID)
ec2start:
	aws --region $(EC2_REGION) ec2 start-instances --instance-ids $(EC2_INSTANCEID)
ec2status:
	aws --region $(EC2_REGION) ec2 describe-instance-status --instance-ids $(EC2_INSTANCEID)

# ssh into machine and forward jupyter port
ssh:
	ssh -i ~/.ssh/deeplearning -L 8888:localhost:8888 ubuntu@$(EC2_URL)

