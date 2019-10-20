#!/bin/bash -e
#

nr=1
while true
do
	userVarName="POSTGRES_CREATE_USER_${nr}_NAME"
	userFileVarName="POSTGRES_CREATE_USER_${nr}_NAME_FILE"
	[ "${!userVarName}" -o "${!userFileVarName}" ] || break
	user="${!userVarName:-$(< "${!userFileVarName}")}"
	passwordVarName="POSTGRES_CREATE_USER_${nr}_PASSWORD"
	passwordFileVarName="POSTGRES_CREATE_USER_${nr}_PASSWORD_FILE"
	password="${!passwordVarName:-$(< "${!passwordFileVarName}")}"
	psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --variable="ON_ERROR_STOP=1" <<-EOSQL
		CREATE USER ${user} WITH PASSWORD '${password}';
	EOSQL
	((nr++))
done
