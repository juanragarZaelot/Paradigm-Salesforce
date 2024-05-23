#A powershell script that takes the files specified in a branch package.xml, packages them and deploys to a target org
#Parameters 1. Branch name (-branch ), 2. Org name (-org), 3. Unit Test parameter (-tests) 4. Salesforce API version (-av)
#Example run command: .\scripts\deploypkg.ps1 -branch branch-name-here -org ProdAuto -tests nameofsometestclass
#Author: Ásgeir Einarsson - asgeirei@icelandair.is
#Reference: https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_force_mdapi.htm
Param($branch,$org,$tests,$av)
Write-Host 'Packaging' $branch 'and deploying to' $org
$ErrorActionPreference = "Stop"; #Make all errors terminating
Try
  {
    $orgLower = $org.ToLower()
    mkdir ./deployment
	if($av){
		sfdx force:mdapi:retrieve --retrievetargetdir deployment  -k manifest/branches/$branch.xml -s --apiversion=$av
	}
	else {
		sfdx force:mdapi:retrieve --retrievetargetdir deployment  -k manifest/branches/$branch.xml -s
	}
    Expand-Archive -Force -Path ./deployment/unpackaged.zip -DestinationPath ./deployment/
    Remove-Item ./deployment/unpackaged.zip
    if($orgLower -like '*prod*') {
        Write-Host 'PRODUCTION DEPLOYMENT'
        if($tests -like 'false'){
            Write-Host 'Running no tests'
            sfdx force:mdapi:deploy -d deployment/ -u $org -w 30 
        }
        elseif($tests){
            Write-Host 'Running specified tests'
            sfdx force:mdapi:deploy -d deployment/ -u $org -w 60 -l RunSpecifiedTests -r $tests 
        }
        else {
            #Default on production is to run all tests
            Write-Host 'Running ALL tests'
            sfdx force:mdapi:deploy -d deployment/ -u $org -w 60 -l RunLocalTests 
        }
    }
    elseif($orgLower -like 'stag*') {
        Write-Host 'STAGING DEPLOYMENT'
        if($tests -like 'all'){
            #We want to run all tests on staging but we cannot at the moment because some tests depend on Email Delivery
            Write-Host 'Running ALL tests'
            sfdx force:mdapi:deploy -d deployment/ -u $org -w 60 -l RunLocalTests 
        }
        elseif($tests){
            Write-Host 'Running specified tests'
            sfdx force:mdapi:deploy -d deployment/ -u $org -w 60 -l RunSpecifiedTests -r $tests 
        }
        else {
            Write-Host 'Running no tests'
            sfdx force:mdapi:deploy -d deployment/ -u $org -w 30 
        }
    }
    else {
        sfdx force:mdapi:deploy -d deployment/ -u $org -w 30 
    }
}
Catch
{
    Write-Host 'ERROR, stopping script: ' $_.Exception.Message
}
Remove-Item ./deployment -r -fo
