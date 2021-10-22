echo on
mysqldump -u root -p --databases his >his.sql --triggers --routines
::mysqldump -u root -p --databases vtigercrm6 >vtigerpostgresql.sql --compatible=postgresql --default-character-set=utf8 --triggers --routines
pause
