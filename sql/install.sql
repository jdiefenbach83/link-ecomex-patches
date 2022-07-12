WHENEVER OSERROR EXIT FAILURE

REM +========================================================================+
REM | Objetivo.....: Atualizar o eComex para o novo Release.                 |
REM | Onde executar: No banco de dados do eComex.                            |
REM +========================================================================+

SET ECHO OFF
SET FEEDBACK OFF
SET HEAD OFF
SET LINE 1000
SET PAGESIZE 50000
SET TERMOUT OFF
SET TRIMSPOOL ON
SET VERIFY OFF

REM +=============================================================+
REM | ATENÇÃO! Atualize o nome dos patches que são pré-requisitos |
REM | entre virgula e sem espaços aqui:                           |
REM | exemplo: DEFINE PATCHES_PRE_REQ=p108a,p108b,p108x            |
REM +=============================================================+
DEFINE PATCHES_PRE_REQ=p108bb,p108bi,p108bl,p108by,p108cc,p108cg,p108ch,p108cm,p108cp,p108cr,p108cs,p108ct,p108cw,p108cy,p108cz
REM +=============================================================+

REM +=============================================================+
REM | ATENÇÃO! Informe o número da release base deste patch       |
REM | exemplo: DEFINE RELEASE_NUMBER=108                          |
REM +=============================================================+
DEFINE RELEASE_NUMBER=108
REM +=============================================================+


PROMPT
PROMPT Generating the log file. The script will abort if this step fails.
PROMPT ==================================================================

SPOOL cmx_patch.sql.tmp


SELECT 'PROMPT This patch cannot be installed on this system, because the pre-requirement to ' || chr (10) ||
       'PROMPT install it is the patch p'||'&RELEASE_NUMBER' ||'.'|| chr (10) ||
       'PAUSE Press ENTER to abort.' || chr (10) ||
       'EXIT'
  FROM dual
 WHERE cmx_fnc_profile('RELEASE_NUMBER') <> '&RELEASE_NUMBER';

SELECT 'PROMPT This patch cannot be installed on this system, because the pre-requirement to ' || chr (10) ||
       'PROMPT install it is the p_controle_patch_001 patch.' || chr (10) ||
       'PAUSE Press ENTER to abort.' || chr (10) ||
       'EXIT'
  FROM dual
 WHERE NOT EXISTS (SELECT NULL
                     FROM user_objects
                    WHERE Upper(object_name) = 'CMX_FNC_PATCHES_FALTANTES');

SELECT 'PROMPT This patch cannot be installed on this system, because the pre-requirement to ' || chr (10) ||
       'PROMPT install it is the patch(es) ' || cmx_fnc_patches_faltantes('&PATCHES_PRE_REQ')||'.' || chr (10) ||
       'PAUSE Press ENTER to abort.' || chr (10) ||
       'EXIT'
  FROM dual
  WHERE cmx_fnc_patches_faltantes('&PATCHES_PRE_REQ') IS NOT NULL;

SELECT 'PROMPT Creating synonym for imp_fnc_cond_prev_cust_sap ' || chr (10) ||
       'CREATE SYNONYM imp_fnc_cond_prev_cust FOR imp_fnc_cond_prev_cust_sap;'
  FROM dual
 WHERE EXISTS (SELECT NULL
                     FROM user_objects
                    WHERE Upper(object_name) = 'IMP_FNC_COND_PREV_CUST_SAP');



SPOOL OFF

SET FEEDBACK ON
SET TERMOUT ON
SET APPINFO ON

@cmx_patch.sql.tmp

SET ECHO ON

REM +=========================================+
REM | ATENÇÃO! Atualize o nome do patch aqui: |
REM +=========================================+
DEFINE PATCH=p108dd
REM +=========================================+

REM +==========================================================+
REM | Define patch ID e executa procedure cmx_prc_log_patch:   |
VARIABLE PATCH_ID          NUMBER
VARIABLE OBJETOS_INVALIDOS NUMBER
REM +==========================================================+
BEGIN
  :PATCH_ID := cmx_fnc_proxima_sequencia('cmx_log_patch_sq1');
  cmx_prc_log_patch(:PATCH_ID, '&PATCH');
END;
/

PROMPT
PROMPT Generating the log file. The script will abort if this step fails.
PROMPT ==================================================================

SPOOL install_&patch..lst

WHENEVER OSERROR CONTINUE

SET ECHO OFF
SET FEEDBACK OFF

SELECT 'eComex Release: 3.0.' || conteudo
  FROM cmx_profiles
 WHERE campo = 'RELEASE_NUMBER';

SELECT 'Client''s info'  || chr (10) ||
       '=============='  || chr (10) ||
       '  User.......: ' || s.username || chr (10) ||
       '  Schema.....: ' || s.schemaname || chr (10) ||
       '  OS user....: ' || s.osuser || chr (10) ||
       '  Process....: ' || s.process || chr (10) ||
       '  Machine....: ' || s.machine || chr (10) ||
       '  Terminal...: ' || s.terminal || chr (10) ||
       '  Program....: ' || s.program || chr (10) ||
       '  Module.....: ' || s.module || chr (10) ||
       '  Logon time.: ' || to_char (s.logon_time, 'dd/mm/yyyy hh24:mi:ss') || chr (10) || chr (10) ||
       'Server''s info'  || chr (10) ||
       '=============='  || chr (10) ||
       '  Username...: ' || p.username  || chr (10) ||
       '  Process....: ' || p.spid || chr (10) ||
       '  Terminal...: ' || p.terminal || chr (10) ||
       '  Program....: ' || p.program || chr (10) || chr (10) ||
       'Database''s info'|| chr (10) ||
       '===============' || chr (10) ||
       '  Name.......: ' || sys_context ('userenv', 'db_name')  || chr (10) ||
       '  Domain.....: ' || sys_context ('userenv', 'db_domain') || chr (10) ||
       '  Date/time..: ' || to_char (sysdate, 'dd/mm/yyyy hh24:mi:ss')
       info
  FROM gv$session s
  JOIN gv$process p
    ON p.addr = s.paddr
 WHERE s.audsid = sys_context ('userenv', 'sessionid');

SET FEEDBACK ON

PROMPT
PROMPT Invalid objects before patch appliance
PROMPT ======================================

SELECT object_type, object_name, to_char(last_ddl_time,'yyyy/mm/dd hh24:mi:ss') last_ddl_time, timestamp
  FROM user_objects
 WHERE status = 'INVALID'
 ORDER BY object_name;

SET ECHO ON

@@script_ecomex.sql



SET ECHO OFF
SET FEEDBACK OFF

SELECT 'Starting compilation of ' || count (*) || ' invalid objects...'
  FROM user_objects
 WHERE status = 'INVALID';

EXEC cmx_prc_compilar_objetos ('Patch &patch.');
EXEC cmx_prc_compilar_objetos ('Patch &patch.');

SELECT 'Total of ' || count (*) || ' objects remain invalid...'
  FROM user_objects
 WHERE status = 'INVALID';

BEGIN
  SELECT count(*)
    INTO :OBJETOS_INVALIDOS
    FROM user_objects
   WHERE status = 'INVALID';

  UPDATE cmx_log_patch
     SET hora_fim                 = SYSDATE
       , objetos_invalidos_depois = :OBJETOS_INVALIDOS
   WHERE patch_id = :PATCH_ID;
  COMMIT;
END;
/

SET HEAD ON
SET FEEDBACK ON

SELECT descricao ERRORS
  FROM cmx_log_erros
 WHERE evento_id = (SELECT max(evento_id) FROM cmx_eventos WHERE nome LIKE 'Patch &patch.: Compila%o dos objetos %')
 ORDER BY log_erros_id;

PROMPT
PROMPT Objects modified in the last 24 hours
PROMPT =====================================

SELECT object_type, object_name, to_char(last_ddl_time,'yyyy/mm/dd hh24:mi:ss') last_ddl_time, timestamp, status
  FROM user_objects
 WHERE last_ddl_time > sysdate - 1
 ORDER BY last_ddl_time DESC;

PROMPT NLS_LANG value
PROMPT ==============
SPOOL OFF
HOST cmd /c "echo %NLS_LANG%"
HOST echo $NLS_LANG
HOST cmd /c "echo %NLS_LANG%" >>install_&patch..lst
HOST echo $NLS_LANG >>install_&patch..lst