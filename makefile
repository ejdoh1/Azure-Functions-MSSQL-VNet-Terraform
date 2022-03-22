include .env

login:
	@az login --service-principal -u "${ARM_CLIENT_ID}" -p "${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}"
	@az account set --subscription "${ARM_SUBSCRIPTION_ID}"

deploy: check-env login
	set -a; source .env; set +a; \
	terraform init; \
	terraform apply -auto-approve

build:
	dotnet build LocalFunctionProj/LocalFunctionProj.csproj /p:DeployOnBuild=true /p:DeployTarget=Package;CreatePackageOnPublish=true
	cd LocalFunctionProj/bin/Debug/netcoreapp3.1/Publish/ && zip -r ../../../sample.zip .

check-env:
	@for var in terraform az dotnet; do \
		if ! command -v $$var &> /dev/null; then \
			echo "$$var could not be found"; \
			exit 1; \
		fi; \
	done
	
test:
	@curl --silent `terraform output -raw api_url`?name=person | grep "Hello, person. This HTTP triggered function executed successfully. Database Server Name: `terraform output -raw mssql_servername`" > /dev/null && echo "TEST PASS" || echo "TEST FAIL"

destroy:
	set -a; source .env; set +a; \
	terraform init; \
	terraform destroy -auto-approve
