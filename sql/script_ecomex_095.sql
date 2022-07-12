REM +========================================================================+
REM  Objetivo.....: Criar os objetos padrões do eComex.                     |
REM | Onde executar: No banco de dados do eComex.                            |
REM +========================================================================+
-- Create table

-- Alter table add column

-- Comments on table

-- Comments on column

-- Alter table drop check constraint

-- Alter table drop constraint foreign key

-- Alter table drop constraint unique key

-- Alter table drop constraint primary key

-- Inserts

-- Pre updates
DECLARE
  vn_tabela_id NUMBER := cmx_pkg_tabelas.tabela_id('119','08');
  vn_idioma_id NUMBER:= cmx_pkg_tabelas.tabela_id('905','EN-US');
BEGIN

UPDATE cmx_tabelas_descr SET descricao = '''ROYALTIES'' E DIREITOS DE LICENCA', last_update_date = sysdate, last_updated_by = 0 WHERE tabela_id = vn_tabela_id and idioma_id = vn_idioma_id;

END;
/
 DECLARE
  vn_tabela_id NUMBER := cmx_pkg_tabelas.tabela_id('119','08');
  vn_idioma_id NUMBER:= cmx_pkg_tabelas.tabela_id('905','PT-BR');
BEGIN

UPDATE cmx_tabelas_descr SET descricao = '''ROYALTIES'' E DIREITOS DE LICENCA', last_update_date = sysdate, last_updated_by = 0 WHERE tabela_id = vn_tabela_id and idioma_id = vn_idioma_id;

END;
/
 DECLARE
  vn_tabela_id NUMBER := cmx_pkg_tabelas.tabela_id('119','08');
  vn_idioma_id NUMBER:= cmx_pkg_tabelas.tabela_id('905','ESA');
BEGIN

UPDATE cmx_tabelas_descr SET descricao = '''ROYALTIES'' E DIREITOS DE LICENCA', last_update_date = sysdate, last_updated_by = 0 WHERE tabela_id = vn_tabela_id and idioma_id = vn_idioma_id;

END;
/
 DECLARE
  vn_tabela_id NUMBER := cmx_pkg_tabelas.tabela_id('119','08');
  vn_idioma_id NUMBER:= cmx_pkg_tabelas.tabela_id('905','ES');
BEGIN

UPDATE cmx_tabelas_descr SET descricao = '''ROYALTIES'' E DIREITOS DE LICENCA', last_update_date = sysdate, last_updated_by = 0 WHERE tabela_id = vn_tabela_id and idioma_id = vn_idioma_id;

END;
/


-- Alter table modify column

-- Alter table add constraint primary key

-- Alter table add constraint unique key

-- Alter table add constraint foreign key

-- Alter table add check constraint

-- Post updates
BEGIN

  DELETE
    FROM cmx_programas
   WHERE upper(programa) = 'DRW_MEMORANDOS_EMITIDOS';

  COMMIT;

END;
/
-- Alter table drop column

-- Package specifications

-- Functions

-- Views
-- Procedures
@@cmx_prc_envia_email_jobmonitor.sql

-- Triggers

-- Packages bodies
@@cam_pkb_interface_importacao.sql

-- Indexes

-- Fim