REM +========================================================================+
REM  Objetivo.....: Criar os objetos padrões do eComex.                     |
REM | Onde executar: No banco de dados do eComex.                            |
REM +========================================================================+
-- Create table

-- Alter table add column
ALTER TABLE imp_excecoes_fiscais ADD   base_zerada_antid              VARCHAR2(1)   NULL;
ALTER TABLE imp_excecoes_Fiscais ADD   ex_ipi_recof_id                NUMBER        NULL;
ALTER TABLE imp_excecoes_Fiscais ADD   ato_legal_recof_id             NUMBER        NULL;
ALTER TABLE imp_excecoes_Fiscais ADD   nr_ato_legal_recof             NUMBER(6,0)   NULL;
ALTER TABLE imp_excecoes_Fiscais ADD   orgao_emissor_recof_id         NUMBER        NULL;
ALTER TABLE imp_excecoes_Fiscais ADD   ano_ato_legal_recof            NUMBER(6,0)   NULL;
ALTER TABLE imp_excecoes_Fiscais ADD   tp_acordo                      NUMBER        NULL;
ALTER TABLE imp_excecoes_fiscais ADD   repex                          VARCHAR2(1)   NULL;
ALTER TABLE imp_excecoes_fiscais ADD   regtrib_ipi_repex_id           NUMBER        NULL;
ALTER TABLE imp_excecoes_fiscais ADD   regtrib_pis_cofins_repex_id    NUMBER        NULL;
ALTER TABLE imp_excecoes_fiscais ADD   fund_legal_pis_cofins_repex_id NUMBER        NULL;
ALTER TABLE imp_excecoes_fiscais ADD   enquad_legal_ipi_repex_id      NUMBER        NULL;

ALTER TABLE imp_excecoes_fiscais ADD   flag_nao_enviar_ex_estr_di     VARCHAR2(1)   DEFAULT 'N' NULL;
ALTER TABLE imp_excecoes_fiscais ADD   aliq_adval_igual_red           VARCHAR2(1)   DEFAULT 'N' NULL;

-- Comments on table

-- Comments on column

-- Alter table drop check constraint

-- Alter table drop constraint foreign key

-- Alter table drop constraint unique key

-- Alter table drop constraint primary key

-- Inserts

-- Pre updates

-- Alter table modify column

-- Alter table add constraint primary key

-- Alter table add constraint unique key

-- Alter table add constraint foreign key

-- Alter table add check constraint

-- Post updates

-- Alter table drop column

-- Package specifications

-- Functions
@@imp_fnc_gera_adicao_dcl.sql
-- Views

-- Procedures

@@imp_prc_atualiza_di_li_ivc.sql
@@imp_prc_gerar_declaracao.sql

-- Triggers
@@imp_trg_inclui_adi_dcl.sql
@@imp_trg_altera_adi_dcl.sql
@@imp_trg_atualiza_dcl_li.sql

-- Packages bodies
@@imp_pkb_gera_xml_ep.sql
@@imp_pkb_totaliza_ebq.sql

-- Indexes

-- Fim


