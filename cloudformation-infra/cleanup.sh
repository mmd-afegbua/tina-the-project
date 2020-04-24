echo "Cleaning up all stacks..."
aws cloudformation delete-stack \
--stack-name $1 $2