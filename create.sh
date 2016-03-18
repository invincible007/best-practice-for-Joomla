#!/bin/bash
#Script to set the permissions as needed for the website folder
#Read the reference document for details

#Check whether there is exactly one parameter 
if [ $# != 2 ]; then
    echo "Warning: Incorrect Parameters"
    echo "Correct Usage is: createfolders <path> <newsitename>"
    exit 1
fi

#Error handler to break in case something goes wrong
abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred. Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e

#Define the constants used in the script
#---- User IDs ----
userID="me_init"
apacheID="apache"

#---- Group Names ----
primaryGroup="me_init"
wwwmodGroup="wwwmod"
batchmodGroup="batchmod"
logGroup="logGroup"

#---- Folder Names ----
accessFldr="access"
actualFldr="actual"
actualCFldr="c_2xxx_"
batchFldr="batch"
logsFldr="logs"
accessLogsFldr="access"
batchLogsFldr="batch"
errorLogsFldr="error"
joomlaLogsFldr="joomla"
resourcesFldr="resources"
resourcesDataFldr="data"
resourcesPreviousFldr="previous"
resourcesFilesFldr="files"
scriptsFldr="scripts"

htdocsLink="htdocs"
filesLink="files"

#----Actual work starts here
echo "----  folder setup utility started ----"

mainSitePath=$1 #stores the directory path
newSiteName=$2 #stores the new website name

cd $mainSitePath

#Start creating the required directories
echo "Creating directories..."
mkdir $newSiteName
cd $newSiteName
	mkdir $accessFldr
	mkdir $actualFldr
		cd $actualFldr
		mkdir $actualCFldr
			cd $actualCFldr
			ln -sfn ../../$resourcesFldr/$resourcesFilesFldr $filesLink
			cd ..
		cd ..
	mkdir $batchFldr
	ln -sfn $actualFldr/$actualCFldr $htdocsLink
	mkdir $logsFldr
		cd $logsFldr
		mkdir $accessLogsFldr
		mkdir $batchLogsFldr
		mkdir $errorLogsFldr
		mkdir $joomlaLogsFldr
		cd ..
	mkdir $resourcesFldr
		cd $resourcesFldr
		mkdir $resourcesDataFldr
			cd $resourcesDataFldr
			mkdir $resourcesPreviousFldr
			cd ..
		mkdir $resourcesFilesFldr
		cd ..
	mkdir $scriptsFldr
	cd ..

#End of creating the required directories	
#Start setting the permissions now
echo "Settings permissions..."
chown -R $userID:$wwwmodGroup $newSiteName
chmod -R 2775 $newSiteName
cd $newSiteName
	chown -R $userID:$batchmodGroup $batchFldr
	chmod -R 2770 $batchFldr
	
	chown -R $apacheID:$logGroup $logsFldr
	chmod -R 750 $logsFldr
	chmod -R g-s $logsFldr
	cd $logsFldr
		
		chown -R $userID:$batchmodGroup $batchLogsFldr
		chmod -R 2770 $batchLogsFldr
		cd ..
	cd $resourcesFldr
		chown -R $userID:$batchmodGroup $resourcesDataFldr
		chmod -R 2770 $resourcesDataFldr
		cd ..
	chown -R $userID:$batchmodGroup $scriptsFldr
	chmod -R 2770 $scriptsFldr
	cd ..	

trap : 0
echo "----  folder setup utility terminating ----"
set +e
