#!/bin/sh

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]
	then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]
	then
		val="${!var}"
	elif [ "${!fileVar:-}" ]
	then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

# Fetch value from server config
# We use mysqld --verbose --help instead of my_print_defaults because the
# latter only show values present in config files, and not server defaults
_get_config() {
	local conf="$1"; shift
	"$@" --verbose --help --log-bin-index="$(mktemp -u)" 2>/dev/null | awk '$1 == "'"$conf"'" { print $2; exit }'
}

file_env 'MYSQL_ROOT_PASSWORD'

SOCKET="$(_get_config 'socket' mysqld)"
mysql=( mysql --protocol=socket -uroot -hlocalhost --socket="${SOCKET}" )

if [ ! -z "$MYSQL_ROOT_PASSWORD" ]
then
    mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )
fi

if [ "$MYSQL_DATABASE_LIST" ]
then
    for db in "$MYSQL_DATABASE_LIST"
    do
        echo "CREATE DATABASE IF NOT EXISTS \`$db\` ;" | "${mysql[@]}" && echo "Database \"$db\" created."
    done
fi