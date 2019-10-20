#!/bin/bash -ex
#
for (( nr=1 \
	; \
	( POSTGRES_CREATE_USER_${nr}_NAME || POSTGRES_CREATE_USER_${nr}_NAME_FILE ) \
	&& \
	( POSTGRES_CREATE_USER_${nr}_PASSWORD || POSTGRES_CREATE_USER_${nr}_PASSWORD_FILE ) \
	; \
	nr++ ))
do
	userVarName="POSTGRES_CREATE_USER_${nr}_NAME"
	userFileVarName="POSTGRES_CREATE_USER_${nr}_NAME_FILE"
	user="${!userVarName:-$(< "${!userFileVarName}")}"
	passwordVarName="POSTGRES_CREATE_USER_${nr}_PASSWORD"
	passwordFileVarName="POSTGRES_CREATE_USER_${nr}_PASSWORD_FILE"
	password="${!passwordVarName:-$(< "${!passwordFileVarName}")}"
	psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --variable="ON_ERROR_STOP=1" <<-EOSQL
		CREATE USER ${user} WITH PASSWORD '${password}';
	EOSQL
done
