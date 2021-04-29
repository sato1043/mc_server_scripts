#! /bin/bash

source ./settings.sh

MYSQL="mysql --defaults-extra-file=backupDB.cnf"

MYSQLDUMP="mysqldump --defaults-extra-file=backupDB.cnf \
--routines --triggers --events \
--flush-logs --lock-all-tables \
--set-charset --quote-names \
--add-drop-database --add-drop-table --add-locks --create-options \
--disable-keys --extended-insert"

DBLIST_SQL="SELECT schema_name \
FROM information_schema.schemata \
WHERE schema_name NOT IN ('mysql','information_schema','performance_schema')"

DBLIST=""
for DB in `${MYSQL} -ANe"${DBLIST_SQL}"`; do
  DBLIST="${DBLIST} ${DB}"
done

${MYSQLDUMP} --databases ${DBLIST} | gzip -c > ${DB_BK_NAME}

chmod g-rwx ${DB_BK_NAME}

#__END__
