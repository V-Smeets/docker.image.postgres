#!/bin/bash -e
#

nr=1
while true
do
	databaseVarName="POSTGRES_CREATE_DATABASE_${nr}_NAME"
	databaseFileVarName="POSTGRES_CREATE_DATABASE_${nr}_NAME_FILE"
	[ "${!databaseVarName}" -o "${!databaseFileVarName}" ] || break
	database="${!databaseVarName:-$(< "${!databaseFileVarName}")}"
	ownerVarName="POSTGRES_CREATE_DATABASE_${nr}_OWNER"
	ownerFileVarName="POSTGRES_CREATE_DATABASE_${nr}_OWNER_FILE"
	owner="${!ownerVarName:-$(< "${!ownerFileVarName}")}"
	psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --variable="ON_ERROR_STOP=1" <<-EOSQL
		CREATE DATABASE ${database} WITH OWNER ${owner} ENCODING 'UTF8';
	EOSQL
	((nr++))
done
