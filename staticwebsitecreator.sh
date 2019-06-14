#!/bin/bash 
#export BUCKETNAME="vedalabs-staging-insights"
#export BUCKETREGION="us-west-2"

BUCKETNAME=$1
BUCKETREGION=$2
CONTENT_FOLDER=$3
RESULT=2 

function validateInputs(){
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
		aws s3 mb s3://$1 --region $2
		RESULT=$?
		echo "sleeping again"
		sleep 60
	done 
	echo "Bucket created!"
}

function copyWesbiteToBucket(){
	echo  "copy $3's contents to bucket"
	aws s3 sync $CONTENT_FOLDER s3://$BUCKETNAME
}

funciton showWebsiteEndpoint(){
	WEBSITEENDPOINT="http://$BUCKETNAME.s3-website-$BUCKETREGION.amazonaws.com"
	echo $WEBSITEENDPOINT
}

validateInputs
createBucket
copyWesbiteToBucket

echo "your website is ready at: "$WEBSITEENDPOINT
