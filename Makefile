AWS_REGION := eu-central-1
ECR_REPOSITORY_URI := 654654262492.dkr.ecr.eu-central-1.amazonaws.com/default-applications-repo
DATA_FEED_LAMBDA_TAG := data-feed-latest
DATA_FEED_LAMBDA_IMAGE_NAME := data_feed


infracost:
	infracost breakdown --show-skipped --path .

login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_REPOSITORY_URI)


build-lambda:
	docker build -t ${DATA_FEED_LAMBDA_IMAGE_NAME}:${DATA_FEED_LAMBDA_TAG} -f ./applications/python/data_feed/Dockerfile.lambda ./applications/python/data_feed/.
tag-lambda:
	docker tag $(DATA_FEED_LAMBDA_IMAGE_NAME):$(DATA_FEED_LAMBDA_TAG) $(ECR_REPOSITORY_URI):$(DATA_FEED_LAMBDA_TAG)
push-lambda:
	docker push $(ECR_REPOSITORY_URI):$(DATA_FEED_LAMBDA_TAG)

deploy-lambda: build-lambda tag-lambda push-lambda


build-vps:
	docker build -t data_feed:vps-latest -f ./applications/python/data_feed/Dockerfile.vps ./applications/python/data_feed/.

nuke:
	aws-nuke-v2.25.0-linux-amd64 -c nuke-config.yaml --no-dry-run