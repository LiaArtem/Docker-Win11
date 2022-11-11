#!/bin/bash
sqlplus -s /nolog << EOF
CONNECT sys/!Aa112233 as sysdba;

whenever sqlerror exit sql.sqlcode;
set echo off
set heading off

@/opt/sql_add_sys.sql
@/opt/sql_add_test_user.sql

exit;
EOF
