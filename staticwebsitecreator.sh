#!/bin/bash 

# export these varibales before running the script.
# export BUCKETNAME="my-test-bucket"
# export AWS_ACCESS_KEY_ID="xxxxxxxxxxxxxx"
# export AWS_SECRET_ACCESS_KEY="xxxxxxxxxxxxxxxxxxxxx"
# export AWS_DEFAULT_REGION=""

BUCKETNAME=$1
BUCKETREGION=$2
CONTENT_FOLDER=$3
RESULT=2 
RETRY_TIME=10

function showUsage() {
	echo "Usage: bash <bucket-name> <bucket-region> <content-folder>"
}

function validateInputs() {
	if [ ! -z "$BUCKETNAME" ]
	then
		echo "bucket name valid-"$BUCKETNAME
	else
		echo "No bucket name found"
		showUsage
		exit 1
	fi

	if [ ! -z "$BUCKETREGION" ]
	then
		echo "Deployment region valid-"$BUCKETREGION
	else
		echo "No valid bucket region found"
		showUsage
		exit 1
	fi

	if [ ! -z "$CONTENT_FOLDER" ]
	then
		if [ -d "$CONTENT_FOLDER" ]; then
			echo "Content Folder Exists & is valid- "$CONTENT_FOLDER" "
		fi
	else
		echo "No valid Content Folder found"
		showUsage
		exit 1
	fi
}

function createBucket(){
	until [  $RESULT -eq 0 ]; do
		echo "Trying to create s3 bucket"
		aws s3 mb s3://$BUCKETNAME --region "$BUCKETREGION"
		RESULT=$?
		if [ $RESULT -ne 0 ]
		then
			echo "sleeping again"
			sleep $RETRY_TIME
		fi
	done 
	echo "Bucket created!"
}

function copyWesbiteToBucket(){
	echo  "copy $3's contents to bucket"
	aws s3 sync $CONTENT_FOLDER s3://$BUCKETNAME
}

function deTemplatize(){
	sed "s/<bucket-name>/${BUCKETNAME}/g" bucketpoliciesTemplate.json > bucketpolicies.json	
}

function updateAccessPolicies(){
	deTemplatize
	echo "updating Bucket policies for Public website access!"
	aws s3api put-bucket-policy --bucket $BUCKETNAME --policy file://bucketpolicies.json
}

function showWebsiteEndpoint() {
	WEBSITEENDPOINT="http://$BUCKETNAME.s3-website.$BUCKETREGION.amazonaws.com"
	echo "your website is ready at: "$WEBSITEENDPOINT
}

function hostWebsite(){
	aws s3 website s3://$BUCKETNAME --index-document index.html --error-document error.html	
	echo  "Status: $? hosting your wesbite with index.html file & error.html as defaults. "

}

validateInputs
createBucket
copyWesbiteToBucket
updateAccessPolicies
hostWebsite
showWebsiteEndpoint
