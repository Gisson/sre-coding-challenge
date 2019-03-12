#!/bin/bash

BASEPATH=$(pwd)/..
HTTPSKEYPATH=${BASEPATH}/k8/nginx/docker/cacert.key
HTTPSCERTPATH=${BASEPATH}/k8/nginx/docker/cacert.cert
PROJECTNAME="gcr.io/multivac-232319"
USERNAME=admin


usage (){ echo "Usage helper [prepare | deploy]"; }

analyzereq (){ 
	if [[ $(which $1)  ]];then 
		echo "Found $1"
	else
		echo "$1 not found. Please install"
		exit -1
	fi

}

prepare (){
		set -e
		echo "Checking dependencies..."
		analyzereq gcloud
		analyzereq kubectl
		analyzereq openssl
		analyzereq htpasswd
		analyzereq docker
		echo -n "Checking docker..."
		systemctl is-active --quiet docker && echo -n "Docker is running!" || echo -n "Starting docker..." && systemctl start docker
		echo "Done"
		echo -n "Checking kubectl..."
		kubectl get pods  1>/dev/null || $(echo "Please initialize kubectl config" && exit -1)
		echo "Done"
		echo "Done checking dependencies!"
		echo "Preparing environment"
		htpasswd -c ${BASEPATH}/k8/nginx/docker/.htpasswd ${USERNAME}
		[[ -f ${HTTPSKEYPATH} ]] || cp  ${HTTPSKEYPATH} ${BASEPATH}/k8/nginx/docker/cacert.key
		[[ -f ${HTTPSCERTPATH} ]] || cp ${HTTPSCERTPATH} ${BASEPATH}/k8/nginx/docker/cacert.cert
		echo "Insert password for mongodb:"
		read -s
		cat .env |  sed -e 's/{{ mongo_password }}/'$REPLY'/g' > ${BASEPATH}/MultiVAC/.env
		cat mongo_create_user.js |  sed -e 's/{{ mongo_password }}/'\"$REPLY\"'/g' > ${BASEPATH}/docker/mongo/mongo_create_user.js
		echo "Insert root password for mongodb: "
		read -s
		cat mongo-secret.yaml |  sed -e 's/{{ mongo_root_password }}/'$(echo $REPLY | base64)'/g' > ${BASEPATH}/k8/mongo/mongo-secret.yaml
		pushd .
#		cd ${BASEPATH}/k8/nginx/docker
		docker build ${BASEPATH}/k8/nginx/docker -t ${PROJECTNAME}/nginx:latest
		docker build ${BASEPATH}/MultiVAC/ -t ${PROJECTNAME}/multivac:latest 
		docker build ${BASEPATH}/MultiVAC/ -f ${BASEPATH}/MultiVAC/Dockerfile-worker -t ${PROJECTNAME}/multivac-worker:latest
		docker build ${BASEPATH}/docker/mongo -t ${PROJECTNAME}/mymongo:latest 
		cd ${BASEPATH}/MultiVAC
		popd 
		echo "Deploy now?(y/n) "
		read $y
		if $y;then
			docker push ${PROJECTNAME}/nginx:latest
			docker push ${PROJECTNAME}/multivac:latest
			docker push ${PROJECTNAME}/multivac-worker:latest
			docker push ${PROJECTNAME}/mymongo:latest
		fi
		echo "Finished preparing environment!"



}


deploy (){
	echo "Deploying..."
	find ${BASEPATH}/k8 -name *.yaml -exec kubectl apply -f {} \;	
	echo "Test POST?(y/n) "
	read $y
	if $y;then
		curl  -k -X POST -u ${USERNAME}	--data  "data=test"  https://muultivac.duckdns.org/multivac/data
	fi
	echo "Finished deploying!"
}


case "$1" in
	"prepare")
			prepare
			;;
	"deploy")
			deploy
			;;
	*)
			usage
			exit -1
			;;
esac
