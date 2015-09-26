#!/bin/bash
# Date 2015/09/25 create
# This script is used for let 7-digging-java-Swing/, copying from bookd's CD, to clean code
# This script will remove all *.class/*.jar/*.bat and convert all *.java to utf-8 format, and then transform all *.bat into one Makefile 
#
# usage: cd ~/sourceCode/BookSourceCode/7-digging-java-Swing/7-digging-java-Swing-utf8-study/
#        `creaeMakefile.sh`

outputDir="build"
rootDir="Sources"

convertFile(){
	fileName="$1"
	while read -r line
	do
		if [[ "${line}" = "" ]] || [[ "${line}" = "pause" ]];then continue; fi

		case ${fileName} in
			compile.bat) 
				javaFiles="${line#javac }" 
				echo -e "\t@javac -d ${outputDir} ${javaFiles}" >> Makefile
				;;
			run.bat) 
				javaCmd=`echo "${line}"|grep java`
				if [[ "${javaCmd}" = ""  ]];then
					echo -e "\t@${line} " >> Makefile
				else
					classFiles="${line#java }" # there is a leading space, `echo $line` will not show it, but `echo "${line}" can show it!
					echo -e "\t@java -cp ${outputDir} ${classFiles} " >> Makefile
				fi
				;;
			makeJ*.bat)  # makeJar/makeJAR
				jarCmd="${line% *.class*}" # '*' is the wild-card
				jarFiles=${line#*manifest.txt }
				echo -e "\t@cd build;${jarCmd} ${jarFiles}" >> Makefile # jar -C dir *.class ---> will fail since "jar -C dir" don't eat *.class
				;;
			runJ*.bat)  # runJar/runJAR 
				jarRunCmd="${line% *.jar}" 
				jarFile="${line#java *-jar }" 
				echo -e "\t@${jarRunCmd} ${outputDir}/${jarFile}" >> Makefile
				;;
		esac
	done  < ${fileName}
}

createMakefile(){
	for f in *.bat; do # not all folders have makeJ*.bat or runJ*.bat
		case ${f} in
			compile.bat) 
				echo "all:" > Makefile
				echo -e "\t@if [ ! -d ${outputDir} ]; then mkdir ${outputDir}; fi" >> Makefile
				echo -e "\t@if [ -d images ]; then cp -r images ${outputDir}; fi" >> Makefile
				echo -e "\t@if [ -d doc ]; then cp -r doc ${outputDir}; fi" >> Makefile
				echo -e "\t@if [ -f synth.xml ]; then cp synth.xml ${outputDir}; fi" >> Makefile
				echo -e "\t@if [ -f tree.properties ]; then cp tree.properties ${outputDir}; fi" >> Makefile
				echo -e "\t@if [ -f manifest.txt ]; then cp manifest.txt ${outputDir}; fi" >> Makefile
				convertFile compile.bat
				;;
			run.bat) 
				echo "run:" >> Makefile
				convertFile run.bat
				;;
			makeJ*.bat)  # makeJar/makeJAR
				echo "jar:" >> Makefile
				convertFile makeJ*.bat
				;;
			runJ*.bat)  # runJar/runJAR
				echo "runjar:" >> Makefile
				convertFile runJ*.bat
				;;
		esac

		# remove xxx.bat
		if [[ -n ${f} ]]; then rm ${f}; fi
	done

	echo "clean:" >> Makefile
	echo -e "\trm -r build" >> Makefile
}

# make sure we're in the right directory
if [[ ! -d ${rootDir} ]];then 
	echo "There is no ${rootDir}/ in the current path !!!"
	exit 
fi

# remove *.class and *.jar
echo "Removing *.class and *.jar"
find ${rootDir} -type f -name *.class -exec rm {} \;
find ${rootDir} -type f -name *.jar -exec rm {} \;

# convert *.java into utf-8 format
echo "convert *.java to utf-8 format"
twtoutf8all "*.java" overwrite

#set -x
for dotBatFile in `find ${rootDir} -type f -name *.bat`; do # not all folders have makeJ*.bat or runJ*.bat
	batFileDir=`dirname ${dotBatFile}`
	makeFile="${batFileDir}/Makefile"

	# if *.bat are removed, just pass this dir
	if [[ -f ${makeFile} ]]; then continue; fi

	# cd to *.bat folder
	oldDir=`pwd`
	cd ${batFileDir}

	echo -e "\n<<<< create Makefile in `pwd`<<<<<<<<"
	# convert  0x0d0a to 0x0a
	dos2unix *.bat
	createMakefile

	cd ${oldDir}
done
#set +x
