echo "Creating stack..."

aws cloudformation create-stack \
--stack-name $1 \
--template-body file://infra/$2 \
--parameters file://infra/$3 \
--region=us-west-2 \
--capabilities CAPABILITY_NAMED_IAM \
--disable-rollback