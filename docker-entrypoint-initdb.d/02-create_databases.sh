#!/bin/bash -ex
#
for (( nr=1 \
	; \
	POSTGRES_CREATE_DATABASE_${nr}_NAME || POSTGRES_CREATE_DATABASE_${nr}_NAME_FILE \
	; \
	nr++ ))
do
	databaseVarName="POSTGRES_CREATE_DATABASE_${nr}_NAME"
	databaseFileVarName="POSTGRES_CREATE_DATABASE_${nr}_NAME_FILE"
	database="${!databaseVarName:-$(< "${!databaseFileVarName}")}"
	ownerVarName="POSTGRES_CREATE_DATABASE_${nr}_OWNER"
	ownerFileVarName="POSTGRES_CREATE_DATABASE_${nr}_OWNER_FILE"
	owner="${!ownerVarName:-$(< "${!ownerFileVarName}")}"
	psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --variable="ON_ERROR_STOP=1" <<-EOSQL
		CREATE DATABASE ${database} WITH OWNER ${owner} ENCODING 'UTF8';
	EOSQL
done
