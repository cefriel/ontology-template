#!/bin/bash

VOCABULARY="$1"
RELEASE="$2"

if [ "$RELEASE" = "" ] || [ "$VOCABULARY" = "" ]; then
    echo "Provide the vocabulary name and the version number x.y.z"
    exit 1
fi

if [ -d './'$VOCABULARY'/'$RELEASE ]; then
    echo "The provided version already exists."
    exit 1
else
	mkdir './'$VOCABULARY''

	# Clean /latest and create folders
	rm -r './'$VOCABULARY'/latest'
	mkdir './'$VOCABULARY'/latest'
	mkdir './'$VOCABULARY'/'$RELEASE

	# Create serialisations and documentation
	java -jar tools/widoco.jar -excludeIntroduction -ontFile './'$VOCABULARY'/'$VOCABULARY'.owl' -outFolder './'$VOCABULARY'/latest' -lang en

	# Move files
	mv './'$VOCABULARY'/latest/index-en.html' './'$VOCABULARY'/latest/index.html'

	for EXT in "jsonld" "nt" "owl" "ttl" ; do
		mv './'$VOCABULARY'/latest/ontology.'$EXT './'$VOCABULARY'/latest/'$VOCABULARY'.'$EXT
		sed -i 's/ontology.'$EXT'/'$VOCABULARY'.'$EXT'/g' './'$VOCABULARY'/latest/index.html'
	done

	# Keep both extensions for rdf/xml
	cp './'$VOCABULARY'/latest/'$VOCABULARY'.owl' './'$VOCABULARY'/latest/'$VOCABULARY'.rdf'

	# Keep sections
	cp -r './'$VOCABULARY'/sections/'* './'$VOCABULARY'/latest/sections'
	
	# Copy from latest
	rm './'$VOCABULARY'/latest/'*'.md'
	cp -r './'$VOCABULARY'/latest/'* './'$VOCABULARY'/'$RELEASE
fi