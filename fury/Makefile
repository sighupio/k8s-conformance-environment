PROJECTNAME=$(shell basename "$(PWD)")

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command run in "$(PROJECTNAME)":"
	@echo " Don't forget to set fury-dir variable "
	@echo " Example usage: make init fury-dir=1.25 "
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## init: Run terraform init command
init: check-aws-env check-fury-dir
	@cd $(fury-dir) && rm -rf .terraform
	@cd $(fury-dir) && terraform init \
        --backend=true \
        --backend-config="bucket=${TERRAFORM_TF_STATE_BUCKET_NAME}" \
        --backend-config="key=${TERRAFORM_TF_STATE_KEY}" \
        --backend-config="region=${TERRAFORM_TF_STATE_BUCKET_REGION}"

## plan: Run terraform plan command
plan: check-aws-env check-fury-dir
	@cd $(fury-dir) && terraform plan

## apply: Run terraform apply command
apply: check-aws-env check-fury-dir
	@cd $(fury-dir) && terraform apply \
		--auto-approve

## destroy: Run terraform destroy command
destroy: check-aws-env check-fury-dir
	@cd $(fury-dir) && terraform destroy \
		--auto-approve && rm -rf cluster.key .terraform

## ssh_command_help: Get Help to ssh
ssh_command_help: check-aws-env check-fury-dir
	@cd $(fury-dir) && terraform output ssh_command_help


check-aws-env:
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
endif
ifndef AWS_DEFAULT_REGION
	$(error AWS_DEFAULT_REGION is undefined)
endif
ifndef TERRAFORM_TF_STATE_BUCKET_NAME
	$(error TERRAFORM_TF_STATE_BUCKET_NAME is undefined)
endif
ifndef TERRAFORM_TF_STATE_KEY
	$(error TERRAFORM_TF_STATE_KEY is undefined)
endif
ifndef TERRAFORM_TF_STATE_BUCKET_REGION
	$(error TERRAFORM_TF_STATE_KEY is undefined)
endif
check-fury-dir:
ifndef fury-dir
	$(error fury-dir is undefined)
endif
