REM
REM  Enable foreing keys referring to PK/UK on a given table
REM

PROMPT
PROMPT ENABLE FOREIGN KEYS REFERRING TO A TABLE
PROMPT
ACCEPT own PROMPT "Parent table owner: "
ACCEPT tab PROMPT "Parent table name: "
PROMPT

@_BEGIN
SET HEADING OFF
SET ECHO OFF
SET FEEDBACK OFF

SPOOL &SCRIPT
SELECT 
    'ALTER TABLE ' || t.owner || '.' || t.table_name ||
    ' ENABLE CONSTRAINT ' || t.constraint_name || ';'
FROM   
    dba_constraints t,
    dba_constraints f
WHERE  
    f.owner LIKE UPPER('&own') 
    AND f.table_name LIKE UPPER('&tab')
    AND f.constraint_type IN ('P', 'U')
    AND t.r_constraint_name = f.constraint_name
/
SPOOL OFF

@_CONFIRM "enable"
@_BEGIN
SET ECHO ON
SET FEEDBACK ON

@&SCRIPT

SET ECHO OFF
SET FEEDBACK OFF

UNDEFINE own tab
@_END		
