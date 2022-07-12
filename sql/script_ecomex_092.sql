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

BEGIN

  INSERT INTO exp_identificadores_due 
  (
    identificador_id                                         
  , codigo
  , descricao
  , tag
  , tipo
  , valor
  , origem                          
  , creation_date
  , created_by
  , last_update_date
  , last_updated_by
  , tamanho
  , corta_tamanho
  ) VALUES (
      exp_identificadores_due_sq1.NEXTVAL  
    , 'EX0020_NF'
    , 'ItemDU-E/descriçãoComercial'
    , 'commercialDescription '
    , 'P'
    , 'vc_retorno := NULL;'
    , 'NA'
    , SYSDATE
    , 0
    , SYSDATE
    , 0
    , 600
    , 'N'
  );
COMMIT;
END;
/

DECLARE
  vn_evento_id NUMBER := cmx_fnc_gera_Evento('Automatizacao de datas DUE', SYSDATE, 0);

  PROCEDURE p( pc_tipo      VARCHAR2
             , pc_codigo    VARCHAR2
             , pc_Descricao VARCHAR2
             , pc_auxiliar1 VARCHAR2
             , pc_auxiliar2 VARCHAR2
             , pc_auxiliar3 VARCHAR2
             )
  IS

    CURSOR cur_tab
        IS
    SELECT tabela_id
      FROM cmx_tabelas ct
     WHERE ct.tipo= pc_tipo
       AND ct.codigo = pc_codigo;

    vn_tabela_id NUMBER;

  BEGIN
    OPEN cur_tab;
    FETCH cur_tab INTO vn_tabela_id;
    CLOSE cur_tab;

    IF vn_tabela_id IS NOT NULL THEN
      UPDATE cmx_tabelas
         SET descricao = pc_descricao
           , auxiliar1 = pc_auxiliar1
           , auxiliar2 = pc_auxiliar2
           , auxiliar3 = pc_auxiliar3
           , last_updated_by = 0
           , last_update_date = SYSDATE
      WHERE tabela_id = vn_tabela_id;

      cmx_prc_gera_log_erros(vn_evento_id, 'Tabela ' || pc_tipo || ' - ' || pc_codigo || ' atualizada.','*');

    ELSE
      vn_tabela_id := cmx_fnc_proxima_sequencia('cmx_tabelas_sq1');

      INSERT INTO cmx_tabelas
     (
       tabela_id
     , tipo
     , codigo
     , descricao
     , auxiliar1
     , auxiliar2
     , auxiliar3
     , creation_date
     , created_by
     , last_update_date
     , last_updated_by
     ) VALUES (
                vn_tabela_id
              , pc_tipo
              , pc_codigo
              , pc_descricao
              , pc_auxiliar1
              , pc_auxiliar2
              , pc_auxiliar3
              , SYSDATE
              , 0
              , SYSDATE
              , 0
              );
      cmx_prc_gera_log_erros(vn_evento_id, 'Tabela ' || pc_tipo || ' - ' || pc_codigo || ' inserida.','*');
    END IF;


  END;

BEGIN


  p('203','DUE_AN_FIS_CONC','DATA DA CONCLUSÃO DA ANÁLISE FISCAL DA DUE','N','N','F');
  p('203','DUE_AP_DESP','DATA DA DUE APRESENTADA PARA DESPACHO','N','N','F');
  p('203','DUE_AVERBADA','DATA DE AVERBAÇÃO DA DUE','N','N','F');
  p('203','DUE_CANC_ADUANA','DATA DO CANCELAMENTO DA DUE PELA ADUANA','N','N','F');
  p('203','DUE_CANC_A_PED_EXP','DATA DO CANCELAMENTO DA DUE PELA ADUANA A PEDIDO DO EXPORTADOR','N','N','F');
  p('203','DUE_CANCELADA','DATA DE CANCELAMENTO DA DUE','N','N','F');
  p('203','DUE_CANC_PRAZO_EXP','DATA DO CANCELAMENTO DA DUE POR EXPIRAÇÃO DE PRAZO','N','N','F');
  p('203','DUE_DES','DATA DE DESEMBARAÇO DA DUE','N','N','F');
  p('203','DUE_EM_AN_FISC','DATA DE SITUAÇÃO DE ANÁLISE FISCAL DA DUE','N','N','F');
  p('203','DUE_EMB_ANT_AUT','DATA DE EMBARQUE ANTECIPADO AUTORIZADO DA DUE','N','N','F');
  p('203','DUE_EMB_ANT_PEND','DATA DE EMBARQUE ANTECIPADO PENDENTE DE AUTORIZAÇÃO DA DUE','N','N','F');
  p('203','DUE_INTERROMPIDA','DATA DA INTERRUPÇÃO DA DUE','N','N','F');
  p('203','DUE_LIB_CANAL_VERDE','DATA DE LIBERAÇÃO DA DUE SEM CONFERÊNCIA ADUANEIRA CANAL VERDE','N','N','F');
  p('203','DUE_REG','DATA DE REGISTRO DA DUE','N','N','F');
  p('203','DUE_SEL_CONF','DATA DA SITUAÇÃO DA DUE DE SELECIONADA PARA CONFERÊNCIA CANAL LARANJA OU VERMELHO','N','N','F');

  p('288','10','REGISTRADA','REGISTRADA%','DUE_REG','');
  p('288','11','DECLARAÇÃO APRESENTADA PARA DESPACHO','DECLARAÇÃO APRESENTADA PARA DESPACHO%','DUE_AP_DESP','');
  p('288','20','LIBERADA SEM CONFERÊNCIA ADUANEIRA CANAL VERDE','LIBERADA SEM CONFERÊNCIA ADUANEIRA CANAL VERDE%','DUE_LIB_CANAL_VERDE','');
  p('288','21','SELECIONADA PARA CONFERÊNCIA CANAL LARANJA OU VERMELHO','SELECIONADA PARA CONFERÊNCIA CANAL LARANJA OU VERMELHO%','DUE_SEL_CONF','');
  p('288','25','EMBARQUE ANTECIPADO AUTORIZADO','EMBARQUE ANTECIPADO AUTORIZADO%','DUE_EMB_ANT_AUT','');
  p('288','26','EMBARQUE ANTECIPADO PENDENTE DE AUTORIZAÇÃO','EMBARQUE ANTECIPADO PENDENTE DE AUTORIZAÇÃO%','DUE_EMB_ANT_PEND','');
  p('288','30','EM ANÁLISE FISCAL','EM ANÁLISE FISCAL%','DUE_EM_AN_FISC','');
  p('288','35','CONCLUÍDA ANÁLISE FISCAL','CONCLUÍDA ANÁLISE FISCAL%','DUE_AN_FIS_CONC','');
  p('288','40','DESEMBARAÇADA','DESEMBARAÇADA%','DUE_DES','');
  p('288','70','AVERBADA','AVERBADA%','DUE_AVERBADA','');
  p('288','80','CANCELADA PELO EXPORTADOR','CANCELADA PELO EXPORTADOR%','DUE_CANCELADA','');
  p('288','81','CANCELADA POR EXPIRAÇÃO DE PRAZO','CANCELADA POR EXPIRAÇÃO DE PRAZO%','DUE_CANC_PRAZO_EXP','');
  p('288','82','CANCELADA PELA ADUANA','CANCELADA PELA ADUANA%','DUE_CANC_ADUANA','');
  p('288','83','CANCELADA PELA ADUANA A PEDIDO DO EXPORTADOR','CANCELADA PELA ADUANA A PEDIDO DO EXPORTADOR%','DUE_CANC_A_PED_EXP','');
  p('288','86','INTERROMPIDA','INTERROMPIDA%','DUE_INTERROMPIDA','');

  Dbms_Output.put_line('Verifique evento ' || vn_evento_id);
  COMMIT;

END;
/


DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_REG')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_REG')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE REGISTRO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE REGISTRO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DA INTERRUPÇÃO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA INTERRUPÇÃO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DO CANCELAMENTO DA DUE  PELA ADUANA A PEDIDO DO EXPORTADOR', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DO CANCELAMENTO DA DUE  PELA ADUANA A PEDIDO DO EXPORTADOR'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DO CANCELAMENTO DA DUE  PELA ADUANA', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DO CANCELAMENTO DA DUE  PELA ADUANA'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DO CANCELAMENTO DA DUE POR EXPIRAÇÃO DE PRAZO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DO CANCELAMENTO DA DUE POR EXPIRAÇÃO DE PRAZO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE CANCELAMENTO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE CANCELAMENTO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE AVERBAÇÃO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE AVERBAÇÃO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_DES')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_DES')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE DESEMBARAÇO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE DESEMBARAÇO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DA CONCLUSÃO DA ANÁLISE FISCAL DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA CONCLUSÃO DA ANÁLISE FISCAL DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE SITUAÇÃO DE ANÁLISE FISCAL DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE SITUAÇÃO DE ANÁLISE FISCAL DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE EMBARQUE ANTECIPADO PENDENTE DE AUTORIZAÇÃO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE EMBARQUE ANTECIPADO PENDENTE DE AUTORIZAÇÃO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE EMBARQUE ANTECIPADO AUTORIZADO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE EMBARQUE ANTECIPADO AUTORIZADO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DA SITUAÇÃO DA DUE DE SELECIONADA PARA CONFERÊNCIA CANAL LARANJA OU VERMELHO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA SITUAÇÃO DA DUE DE SELECIONADA PARA CONFERÊNCIA CANAL LARANJA OU VERMELHO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DE LIBERAÇÃO DA DUE SEM CONFERÊNCIA ADUANEIRA CANAL VERDE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE LIBERAÇÃO DA DUE SEM CONFERÊNCIA ADUANEIRA CANAL VERDE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','PT-BR');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
                            , cmx_pkg_tabelas.tabela_id('905','PT-BR')
                                 , 'DATA DA DUE APRESENTADA PARA DESPACHO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA DUE APRESENTADA PARA DESPACHO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE AVERBAÇÃO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE AVERBAÇÃO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE CANCELAMENTO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE CANCELAMENTO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DO CANCELAMENTO DA DUE  PELA ADUANA A PEDIDO DO EXPORTADOR', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DO CANCELAMENTO DA DUE  PELA ADUANA A PEDIDO DO EXPORTADOR'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_DES')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_DES')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE DESEMBARAÇO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE DESEMBARAÇO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_REG')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_REG')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE REGISTRO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE REGISTRO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE LIBERAÇÃO DA DUE SEM CONFERÊNCIA ADUANEIRA CANAL VERDE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE LIBERAÇÃO DA DUE SEM CONFERÊNCIA ADUANEIRA CANAL VERDE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DA INTERRUPÇÃO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA INTERRUPÇÃO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE EMBARQUE ANTECIPADO AUTORIZADO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE EMBARQUE ANTECIPADO AUTORIZADO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DA SITUAÇÃO DA DUE DE SELECIONADA PARA CONFERÊNCIA CANAL LARANJA OU VERMELHO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA SITUAÇÃO DA DUE DE SELECIONADA PARA CONFERÊNCIA CANAL LARANJA OU VERMELHO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE SITUAÇÃO DE ANÁLISE FISCAL DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE SITUAÇÃO DE ANÁLISE FISCAL DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DO CANCELAMENTO DA DUE  PELA ADUANA', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DO CANCELAMENTO DA DUE  PELA ADUANA'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DA DUE APRESENTADA PARA DESPACHO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA DUE APRESENTADA PARA DESPACHO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DO CANCELAMENTO DA DUE POR EXPIRAÇÃO DE PRAZO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DO CANCELAMENTO DA DUE POR EXPIRAÇÃO DE PRAZO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DA CONCLUSÃO DA ANÁLISE FISCAL DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DA CONCLUSÃO DA ANÁLISE FISCAL DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','EN-US');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
                            , cmx_pkg_tabelas.tabela_id('905','EN-US')
                                 , 'DATA DE EMBARQUE ANTECIPADO PENDENTE DE AUTORIZAÇÃO DA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='DATA DE EMBARQUE ANTECIPADO PENDENTE DE AUTORIZAÇÃO DA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_DES')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_DES')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE LIBERACIÓN ADUANAL DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE LIBERACIÓN ADUANAL DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE CONCLUSIÓN DEL ANÁLISIS FISCAL DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CONCLUSIÓN DEL ANÁLISIS FISCAL DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE SITUACIÓN DE ANÁLISIS FISCAL DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE SITUACIÓN DE ANÁLISIS FISCAL DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE EMBARQUE ANTICIPADO PENDIENTE DE AUTORIZACIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE EMBARQUE ANTICIPADO PENDIENTE DE AUTORIZACIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE EMBARQUE ANTICIPADO AUTORIZADO DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE EMBARQUE ANTICIPADO AUTORIZADO DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE INTERRUPCIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE INTERRUPCIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_REG')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_REG')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE OFICIALIZACIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE OFICIALIZACIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE LA DUE PRESENTADA PARA DESPACHO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE LA DUE PRESENTADA PARA DESPACHO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE POR EXPIRACIÓN DE PLAZO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE POR EXPIRACIÓN DE PLAZO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE LIBERACIÓN DE LA DUE SIN CHEQUEO ADUANERO CANAL VERDE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE LIBERACIÓN DE LA DUE SIN CHEQUEO ADUANERO CANAL VERDE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE SITUACIÓN DE LA DUE DE SELECCIONADA PARA CHEQUEO CANAL NARANJO O ROJO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE SITUACIÓN DE LA DUE DE SELECCIONADA PARA CHEQUEO CANAL NARANJO O ROJO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA BAJO SOLICITUD DEL EXPORTADOR', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA BAJO SOLICITUD DEL EXPORTADOR'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ESA');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
                            , cmx_pkg_tabelas.tabela_id('905','ESA')
                                 , 'FECHA DE ENDOSO DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE ENDOSO DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_A_PED_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA BAJO SOLICITUD DEL EXPORTADOR', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA BAJO SOLICITUD DEL EXPORTADOR'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_DES')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_DES')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE LIBERACIÓN ADUANAL DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE LIBERACIÓN ADUANAL DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_PEND')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE EMBARQUE ANTICIPADO PENDIENTE DE AUTORIZACIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE EMBARQUE ANTICIPADO PENDIENTE DE AUTORIZACIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_LIB_CANAL_VERDE')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE LIBERACIÓN DE LA DUE SIN CHEQUEO ADUANERO CANAL VERDE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE LIBERACIÓN DE LA DUE SIN CHEQUEO ADUANERO CANAL VERDE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_SEL_CONF')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE SITUACIÓN DE LA DUE DE SELECCIONADA PARA CHEQUEO CANAL NARANJO O ROJO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE SITUACIÓN DE LA DUE DE SELECCIONADA PARA CHEQUEO CANAL NARANJO O ROJO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_REG')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_REG')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE OFICIALIZACIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE OFICIALIZACIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EM_AN_FISC')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE SITUACIÓN DE ANÁLISIS FISCAL DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE SITUACIÓN DE ANÁLISIS FISCAL DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANCELADA')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_INTERROMPIDA')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE INTERRUPCIÓN DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE INTERRUPCIÓN DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AP_DESP')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE LA DUE PRESENTADA PARA DESPACHO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE LA DUE PRESENTADA PARA DESPACHO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_ADUANA')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE POR LA ADUANA'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AVERBADA')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE ENDOSO DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE ENDOSO DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_EMB_ANT_AUT')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE EMBARQUE ANTICIPADO AUTORIZADO DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE EMBARQUE ANTICIPADO AUTORIZADO DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_AN_FIS_CONC')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE CONCLUSIÓN DEL ANÁLISIS FISCAL DE LA DUE', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CONCLUSIÓN DEL ANÁLISIS FISCAL DE LA DUE'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/
DECLARE
  CURSOR cur_verifica IS
    SELECT tabelas_descr_id
      FROM cmx_tabelas_descr
      WHERE tabela_id  = cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
        AND idioma_id  = cmx_pkg_tabelas.tabela_id('905','ES');

  vb_achou BOOLEAN := FALSE;
  vn_tab_id NUMBER;
BEGIN
  OPEN cur_verifica;
  FETCH cur_verifica INTO vn_tab_id;
  vb_achou := cur_verifica%FOUND;
  CLOSE cur_verifica;

  IF (NOT vb_achou) THEN
    INSERT INTO cmx_tabelas_descr (tabelas_descr_id
                            , tabela_id
                            , idioma_id
                                 , descricao, creation_date, created_by, last_update_date, last_updated_by)
                           VALUES (cmx_fnc_proxima_sequencia('cmx_tabelas_descr_sq1')
                            , cmx_pkg_tabelas.tabela_id('203','DUE_CANC_PRAZO_EXP')
                            , cmx_pkg_tabelas.tabela_id('905','ES')
                                 , 'FECHA DE CANCELACIÓN DE LA DUE POR EXPIRACIÓN DE PLAZO', SYSDATE, 0, SYSDATE, 0 );
  ELSE
    UPDATE cmx_tabelas_descr
      SET descricao ='FECHA DE CANCELACIÓN DE LA DUE POR EXPIRACIÓN DE PLAZO'
    WHERE tabelas_descr_id = vn_tab_id;

  END IF;
  COMMIT;

END;
/

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

-- Views

-- Procedures

-- Triggers

-- Packages bodies
SET SCAN OFF
@@exp_pkb_due.sql
SET SCAN ON
-- Indexes

-- Fim



