#!/bin/bash
#A shell script that takes the files specified in a branch package.xml, packages them and deploys to a target org
#Parameters 1. Branch name, 2. Org name, 3. If Tests should be run 4. Salesforce API version (-av)
#Author: Ásgeir Einarsson - asgeirei@icelandair.is
#Reference: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_mdapi.htm
while getopts o:b:t:a: option 

do 
 case "${option}" 
 in 
 o) org=${OPTARG};; 
 b) branch=${OPTARG};; 
 t) tests=${OPTARG};;
 a) av=${OPTARG};;
 esac 
done 

set -e #Make all errors terminating
orgLower=$(tr '[:upper:]' '[:lower:]'<<<${org})
echo 'Packaging' $branch 'and deploying to' $orgLower
mkdir -p ./deployment
if [ $av ]
then
	sfdx force:mdapi:retrieve --retrievetargetdir deployment  -k ./manifest/branches/$branch.xml -s --apiversion=$av
else
	sfdx force:mdapi:retrieve --retrievetargetdir deployment  -k ./manifest/branches/$branch.xml -s
fi
unzip -o -qq ./deployment/unpackaged.zip -d ./deployment/
rm ./deployment/unpackaged.zip
if [ $orgLower = 'prod' ]
then
    echo 'PRODUCTION DEPLOYMENT'

    if [ $tests = 'false' ]
    then
        echo 'Running no tests'
        sfdx force:mdapi:deploy -d deployment/ -u $org -w 30
    elif [ $tests ]
    then
        echo 'Running specified tests'
        sfdx force:mdapi:deploy -d deployment/ -u $org -w 60 -l RunSpecifiedTests -r $tests
    else
        echo 'Running ALL tests'
        sfdx force:mdapi:deploy -d deployment/ -u $org -w 60 -l RunLocalTests
    fi
elif [ $orgLower = 'stage' ]
then
    #We want to run all tests on staging but we cannot at the moment because some tests depend on Email Delivery
    sfdx force:mdapi:deploy -d deployment/ -u $org -w 30
else
    sfdx force:mdapi:deploy -d deployment/ -u $org -w 30
fi
rm -rf ./deployment