@echo off
:: variables
set drive=C:\Users\Keith\Documents\Programming\Rails\MusicApp2.0\db\Backups
set folder=%date:~10,4%_%date:~4,2%_%date:~7,2%
mkdir "%drive%\%folder%\"
copy "C:\Users\Keith\Documents\Programming\Rails\MusicApp2.0\db\development.sqlite3" "%drive%\%folder%"