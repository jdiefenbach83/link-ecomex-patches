CREATE OR REPLACE PACKAGE exp_pkg_due
AS


  FUNCTION fnc_xml_due( pn_due_id                     NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_adi( pn_due_id                     NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_exporter( pn_due_id                NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_goodsshipment( pn_due_id           NUMBER, pc_nf VARCHAR2) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_adi( pn_due_ship_id             NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_ref( pn_due_ship_id             NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item( pn_due_ship_id            NUMBER, pc_nf VARCHAR2) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_adi( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_dest( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_ref( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_prod( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_char( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_crit( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_enq( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_pdoc( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_adoc( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gi_adoc_ainfo( pn_due_si_adoc_id   NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gi_adoc_inv( pn_due_si_adoc_id     NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gi_adoc_pdoc( pn_due_si_adoc_id    NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_due_gs_item_adj( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE;
  FUNCTION fnc_valida_due(pn_due_id                   NUMBER, pn_evento_id NUMBER ) RETURN NUMBER;
  FUNCTION fnc_ret_val( pn_fatura_id                  NUMBER
                      , pn_fatura_item_id             NUMBER
                      , pn_fatura_item_detalhe_id     NUMBER
                      , pn_embarque_id                NUMBER
                      , pn_fatura_nf_id               NUMBER
                      , pc_nivel                      VARCHAR2
                      , pc_tipo                       VARCHAR2
                      , pc_origem                     VARCHAR2
                      , pc_valor                      VARCHAR2
                      , pc_mascara                    VARCHAR2
                      , pn_due_id                     NUMBER
                      , pn_fatura_det_nf_id           NUMBER
                      , pn_tamanho                    NUMBER
                      , pc_corta_tamanho              VARCHAR2
                      , pc_identificador              VARCHAR2
                      ) RETURN VARCHAR2;

  FUNCTION fnc_ind_due( pc_codigo                 VARCHAR2
                      , pc_nivel                  VARCHAR2
                      , pn_fatura_id              NUMBER
                      , pn_fatura_nf_id           NUMBER DEFAULT NULL
                      , pn_fatura_item_id         NUMBER DEFAULT NULL
                      , pn_fatura_item_detalhe_id NUMBER DEFAULT NULL
                      , pn_due_id                 NUMBER DEFAULT NULL
                      , pn_fatura_det_nf_id       NUMBER DEFAULT NULL
                      ) RETURN VARCHAR2;

  FUNCTION fnc_criar_due( pn_due_id     NUMBER
                        , pn_evento_id  NUMBER
                        , pn_usuario_id NUMBER
                        ) RETURN NUMBER;

  FUNCTION fnc_good_ship(  pn_due_id     NUMBER
                         , pn_fatura_id  NUMBER
                         , pn_evento_id  NUMBER
                         , pn_usuario_id NUMBER
                         , pn_itens_due  IN OUT NUMBER
                         ) RETURN NUMBER;

  PROCEDURE prc_gs_i_nf( pn_due_id       NUMBER
                       , pn_due_ship_id  NUMBER
                       , pn_fatura_nf_id NUMBER
                       , pn_usuario_id   NUMBER
                       , pn_evento_id    NUMBER
                       , pn_itens_due    IN OUT NUMBER
                       , pn_fatura_id    NUMBER
                       );

  PROCEDURE prc_gs_i_snf( pn_due_id      NUMBER
                        , pn_due_ship_id NUMBER
                        , pn_fatura_id   NUMBER
                        , pn_usuario_id  NUMBER
                        , pn_itens_due   IN OUT NUMBER
                        );

  FUNCTION fnc_xml_table(pn_due_id       NUMBER)
  RETURN NUMBER;

  FUNCTION fnc_xml_line(pn_linha         NUMBER)
  RETURN VARCHAR2;

  FUNCTION fnc_xml_table_clob_base64(pc_clob clob)
  RETURN NUMBER;

  FUNCTION fnc_xml_table_base64(pn_due_id NUMBER)
  RETURN NUMBER;

  FUNCTION fnc_xml_line_base64(pn_linha  NUMBER)
  RETURN VARCHAR2;

  FUNCTION fnc_gerar_due( pn_due_tmp_id NUMBER
                        , pn_evento_id NUMBER
                        , pn_usuario_id NUMBER
                        ) RETURN NUMBER;

  FUNCTION fnc_clob_base64 (
     pclob_texto_xml   IN  CLOB
   , pc_charset        IN VARCHAR2 DEFAULT 'UTF8'
  ) RETURN CLOB;

  FUNCTION fnc_base64_clob (
     pclob_texto_xml   IN  CLOB
   , pc_charset        IN VARCHAR2 DEFAULT 'UTF8'
  ) RETURN CLOB;

  PROCEDURE prc_limpa_b64;
  PROCEDURE prc_add_token(pc_token VARCHAR2);

  FUNCTION fnc_proc_retorno( pn_due_id      NUMBER
                           , pn_usuario_id  NUMBER
                           , pn_evento_id   NUMBER DEFAULT NULL
                           , pn_nr_linha    NUMBER DEFAULT NULL
                           , pc_retificacao VARCHAR2 DEFAULT 'N'
                           )
  RETURN VARCHAR2;

  FUNCTION fnc_proc_retorno_json( pn_due_id      NUMBER
                                , pn_usuario_id  NUMBER
                                , pn_evento_id   NUMBER DEFAULT NULL
                                , pn_nr_linha    NUMBER DEFAULT NULL
                                )
  RETURN VARCHAR2;

  FUNCTION fnc_valida_trans_due( pn_due_id      NUMBER
                               , pn_usuario_id  NUMBER
                               , pn_evento_id   NUMBER DEFAULT NULL
                               , pn_nr_linha    NUMBER DEFAULT NULL
                               )
  RETURN NUMBER;

  FUNCTION fnc_atualiza_due(pn_due_id NUMBER, pn_evento_id NUMBER, pn_usuario_id NUMBER)
  RETURN NUMBER;

  PROCEDURE prc_atual_compl( pn_due_id       NUMBER
                           , pc_complemento  VARCHAR2
                           , pc_valor        VARCHAR2
                           , pn_usuario_id   NUMBER
                           , pd_dt_registro  DATE     DEFAULT NULL
                           , pd_dt_averbacao DATE     DEFAULT NULL
                           , pc_chave_acesso VARCHAR2 DEFAULT NULL
                           );

  FUNCTION fnc_ret_fatura_due (pn_due_id NUMBER) RETURN VARCHAR2;

  PROCEDURE prc_busca_atributo_ncm( pn_due_id             NUMBER
                                  , pn_due_ship_item_id   NUMBER
                                  , pc_ncm                VARCHAR2
                                  , pn_atributo_id        NUMBER
                                  , pc_formula            VARCHAR2
                                  , pc_destaque           OUT VARCHAR2
                                  );

  FUNCTION fnc_ret_descricao_item(pn_fatura_item_id NUMBER, pn_fat_item_det_id NUMBER) RETURN VARCHAR2;

  FUNCTION fnc_proc_retorno_cancel( pn_due_id      NUMBER
                                  , pn_usuario_id  NUMBER
                                  , pn_evento_id   NUMBER
                                  , pc_motivo      VARCHAR2
                                  )
  RETURN VARCHAR2;

  FUNCTION fnc_vlr_comissao ( pn_fatura_item_id NUMBER DEFAULT NULL
                            , pn_ncm_id         NUMBER DEFAULT NULL
                            ) RETURN NUMBER;

  FUNCTION fnc_proc_retorno_situacao( pn_due_id      NUMBER
                                    , pn_usuario_id  NUMBER
                                    , pn_evento_id   NUMBER DEFAULT NULL
                                    , pn_nr_linha    NUMBER DEFAULT NULL
                                    )
  RETURN VARCHAR2;

  FUNCTION fnc_normalizar_texto_xml(pc_texto_in VARCHAR2) RETURN VARCHAR2;

  PROCEDURE prc_atualiza_datas( pn_due_id    NUMBER
                              , pc_situacao  VARCHAR2
                              , pd_data      DATE
                              );

  PROCEDURE p_prc_inserir_ato( pn_fat_item_det_ato_id     NUMBER
                             , pn_fat_item_ato_id         NUMBER
                             , pn_due_ship_item_id        NUMBER
                             , pn_usuario_id              NUMBER
                             , pn_fatura_id               NUMBER
                             , pn_fatura_item_id          NUMBER
                             , pn_fatura_item_detalhe_id  NUMBER
                             , pn_due_si_adoc_id          NUMBER
                             , pn_quantidade_est          NUMBER
                             , pc_tipo                    VARCHAR2
                             );

  PROCEDURE p_prc_inserir_ato_isencao( pn_due_ship_item_id        NUMBER
                                     , pn_fatura_det_nf_id        NUMBER
                                     , pn_usuario_id              NUMBER
                                     );

  FUNCTION exp_fnc_ret_estado(pn_fatura_id NUMBER) RETURN VARCHAR2;

  FUNCTION exp_fnc_ret_nome_cliente(pn_fatura_id NUMBER) RETURN VARCHAR2;

  FUNCTION exp_fnc_ret_pais_cliente(pn_fatura_id NUMBER) RETURN VARCHAR2;

  FUNCTION exp_fnc_ret_endereco_cliente(pn_fatura_id NUMBER) RETURN VARCHAR2;

  FUNCTION exp_fnc_ret_pais_destino(pn_fatura_id NUMBER) RETURN VARCHAR2;

  FUNCTION fnc_incluir_faturas( pn_due_tmp_id NUMBER
                              , pn_due_id     NUMBER
                              , pn_evento_id  NUMBER
                              , pn_usuario_id NUMBER
                              ) RETURN NUMBER;
END exp_pkg_due;

/

PROMPT CREATE OR REPLACE PACKAGE BODY exp_pkg_due
CREATE OR REPLACE PACKAGE BODY exp_pkg_due
AS

  TYPE xml_table IS TABLE OF VARCHAR2(32000) INDEX BY PLS_INTEGER;
  vt_xml xml_table;
  vt_xml_b64 xml_table;
  gc_ret_b64 CLOB;

  PROCEDURE prc_atual_compl( pn_due_id       NUMBER
                           , pc_complemento  VARCHAR2
                           , pc_valor        VARCHAR2
                           , pn_usuario_id   NUMBER
                           , pd_dt_registro  DATE     DEFAULT NULL
                           , pd_dt_averbacao DATE     DEFAULT NULL
                           , pc_chave_acesso VARCHAR2 DEFAULT NULL
                           )
  AS

    CURSOR cur_tipo_sd
        IS
    SELECT tp_solicitacao_despacho_id
         , cmx_pkg_tabelas.auxiliar(tp_solicitacao_despacho_id, 4)
      FROM exp_identificadores;

    CURSOR cur_fat
        IS
    SELECT edf.fatura_id, ef.embarque_id
      FROM exp_due_faturas edf
         , exp_faturas     ef
     WHERE edf.fatura_id = ef.fatura_id
       AND edf.due_id = pn_due_id;

    CURSOR cur_tabelas(pc_tipo VARCHAR2, pc_codigo VARCHAR2) IS
      SELECT tabela_id, auxiliar3, auxiliar4
        FROM cmx_tabelas
       WHERE tipo   = pc_tipo
         AND codigo = pc_codigo;

    CURSOR cur_due_nf_lin
        IS
    SELECT DISTINCT det.fatura_item_detalhe_id
         , det.fatura_item_id
      FROM exp_fatura_item_detalhes det
         , exp_fatura_item_det_nf   nf
         , exp_due_ship_item        due
     WHERE det.fatura_item_detalhe_id = nf.fatura_item_detalhe_id
       AND nf.due_ship_item_id = due.due_ship_item_id
       AND due.due_id          = pn_due_id;

    CURSOR cur_due_snf_lin
        IS
    SELECT DISTINCT det.fatura_item_detalhe_id
         , det.fatura_item_id
      FROM exp_fatura_item_detalhes det
         , exp_fatura_itens         item
         , exp_due_faturas          due
     WHERE det.fatura_item_id = item.fatura_item_id
       AND item.fatura_id     = due.fatura_id
       AND due.due_id         = pn_due_id;

    vn_complemento_id   NUMBER;
    vn_tp_solic_id      NUMBER;
    vc_aplicacao        VARCHAR2(150);

    vn_dt_sd_id         NUMBER := NULL;
    vn_dt_averbacao_id  NUMBER := NULL;
    vn_chave_id         NUMBER := NULL;
    vn_dt_averbacao_id2 NUMBER := NULL;

    vc_apl_tp_solic     VARCHAR2(150);
    vc_apl_dt_sd        VARCHAR2(150);
    vc_apl_dt_averb     VARCHAR2(150);
    vc_apl_chave        VARCHAR2(150);
    vc_apl_dt_averb2    VARCHAR2(150);
    vn_qtde_reg         NUMBER := 0;

    vc_dummy            VARCHAR2(150);

    PROCEDURE p_prc_atualizar( pc_tipo          VARCHAR2
                             , pn_reg_id        NUMBER
                             , pn_tipo_id       NUMBER
                             , pn_tabela_id     NUMBER
                             , pc_tbl_codigo    VARCHAR2
                             , pc_tbl_descricao VARCHAR2
                             , pb_complemento   BOOLEAN DEFAULT TRUE
                             , pd_data          DATE DEFAULT NULL
                             ) IS

      vc_tabela       VARCHAR2(150);
      vc_sql          VARCHAR2(32000);
      vc_campo_tbl_id VARCHAR2(150);
      vc_compo_id     VARCHAR2(150);

      vn_id           NUMBER;
    BEGIN

      IF(pc_tipo = 'E') THEN

        IF(pb_complemento) THEN
          vc_tabela       := 'exp_embarque_complementos';
          vc_campo_tbl_id := 'embarque_complemento_id';
          vc_compo_id     := 'embarque_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_embarque_complementos_sq1');
        ELSE
          vc_tabela       := 'exp_embarque_datas';
          vc_campo_tbl_id := 'embarque_data_id';
          vc_compo_id     := 'embarque_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_embarque_datas_sq1');
        END IF;

      ELSIF(pc_tipo = 'F') THEN

        IF(pb_complemento) THEN
          vc_tabela       := 'exp_fatura_complementos';
          vc_campo_tbl_id := 'fatura_complemento_id';
          vc_compo_id     := 'fatura_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_fatura_complementos_sq1');
        ELSE
          vc_tabela       := 'exp_fatura_datas';
          vc_campo_tbl_id := 'fatura_data_id';
          vc_compo_id     := 'fatura_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_fatura_datas_sq1');
        END IF;

      ELSIF(pc_tipo = 'L') THEN

        IF(pb_complemento) THEN
          vc_tabela       := 'exp_fatura_item_complementos';
          vc_campo_tbl_id := 'fatura_item_complemento_id';
          vc_compo_id     := 'fatura_item_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_fatura_item_compl_sq1');
        ELSE
          vc_tabela       := 'exp_fatura_item_datas';
          vc_campo_tbl_id := 'fatura_item_data_id';
          vc_compo_id     := 'fatura_item_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_fatura_item_datas_sq1');
        END IF;

      ELSIF(pc_tipo = 'D') THEN

        IF(pb_complemento) THEN
          vc_tabela       := 'exp_fatura_item_detalhe_compl';
          vc_campo_tbl_id := 'fatura_item_detalhe_compl_id';
          vc_compo_id     := 'fatura_item_detalhe_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_fatura_item_det_compl_sq1');
        ELSE
          vc_tabela       := 'exp_fatura_item_detalhe_datas';
          vc_campo_tbl_id := 'fatura_item_detalhe_data_id';
          vc_compo_id     := 'fatura_item_detalhe_id';
          vn_id           := cmx_fnc_proxima_sequencia('exp_fatura_item_det_datas_sq1');
        END IF;

      END IF;

      IF(pb_complemento) THEN
        vc_sql       := ' DECLARE '                                              ||
                        ' vn_id         NUMBER := :1; '                          ||
                        ' vn_reg_id     NUMBER := :2; '                          ||
                        ' vn_tipo_id    NUMBER := :3; '                          ||
                        ' vn_tabela_id  NUMBER := :4; '                          ||
                        ' vc_tbl_codigo VARCHAR2(150) := :5; '                   ||
                        ' vc_tbl_descricao VARCHAR2(4000) := :6; '               ||
                        ' BEGIN '                                                ||
                        '   INSERT INTO '||vc_tabela||' '                        ||
                        '   ( '||vc_campo_tbl_id||' '                            ||
                        '   , '||vc_compo_id||' '                                ||
                        '   , tipo_id '                                          ||
                        '   , tabela_id '                                        ||
                        '   , tabela_codigo '                                    ||
                        '   , tabela_descricao '                                 ||
                        '   , creation_date '                                    ||
                        '   , created_by '                                       ||
                        '   , last_update_date '                                 ||
                        '   , last_updated_by '                                  ||
                        '   ) VALUES ( vn_id '                                   ||
                        '           , vn_reg_id '                                ||
                        '           , vn_tipo_id '                               ||
                        '           , vn_tabela_id '                             ||
                        '           , vc_tbl_codigo '                            ||
                        '           , vc_tbl_descricao '                         ||
                        '           , SYSDATE '                                  ||
                        '           , '||Nvl(pn_usuario_id,0)||' '               ||
                        '           , SYSDATE '                                  ||
                        '           , '||Nvl(pn_usuario_id,0)||' '               ||
                        '           ); '                                         ||
                        ' EXCEPTION '                                            ||
                        ' WHEN Dup_Val_On_Index THEN '                           ||
                        '   UPDATE '||vc_tabela||' '                             ||
                        '       SET tabela_descricao = vc_tbl_descricao '        ||
                        '         , tabela_codigo    = vc_tbl_codigo '           ||
                        '         , tabela_id    = vn_tabela_id '                ||
                        '         , last_update_date = SYSDATE '                 ||
                        '         , last_updated_by  = '||Nvl(pn_usuario_id,0)||' ' ||
                        '     WHERE '||vc_compo_id||'   = vn_reg_id '            ||
                        '       AND tipo_id       = vn_tipo_id; '                ||
                        ' END;';

         BEGIN
          EXECUTE IMMEDIATE vc_sql USING vn_id
                                       , pn_reg_id
                                       , pn_tipo_id
                                       , pn_tabela_id
                                       , pc_tbl_codigo
                                       , pc_tbl_descricao;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      ELSE
        vc_sql       := ' DECLARE '                                              ||
                        ' vn_id         NUMBER := :1; '                          ||
                        ' vn_reg_id     NUMBER := :2; '                          ||
                        ' vn_tipo_id    NUMBER := :3; '                          ||
                        ' vd_data       DATE := :4; '                            ||
                        ' vc_tbl_descricao VARCHAR2(4000) := :5; '               ||

                        ' BEGIN '                                                ||
                        '    INSERT INTO '||vc_tabela||' '                       ||
                        '    ( '||vc_campo_tbl_id||' '                           ||
                        '    , '||vc_compo_id||' '                               ||
                        '    , tipo_id '                                         ||
                        '    , data '                                            ||
                        '    , descricao '                                       ||
                        '    , creation_date '                                   ||
                        '    , created_by '                                      ||
                        '    , last_update_date '                                ||
                        '    , last_updated_by '                                 ||
                        '    ) VALUES ( vn_id '                                  ||
                        '            , vn_reg_id '                               ||
                        '            , vn_tipo_id '                              ||
                        '            , vd_data '                                 ||
                        '            , vc_tbl_descricao '                        ||
                        '            , SYSDATE '                                 ||
                        '            , '||Nvl(pn_usuario_id,0)||' '              ||
                        '            , SYSDATE '                                 ||
                        '            , '||Nvl(pn_usuario_id,0)||' '              ||
                        '            ); '                                        ||
                        '  EXCEPTION '                                           ||
                        '    WHEN Dup_Val_On_Index THEN '                        ||
                        '      UPDATE '||vc_tabela||' '                          ||
                        '          SET data             = vd_data '              ||
                        '            , last_update_date = SYSDATE '              ||
                        '            , last_updated_by  = '||Nvl(pn_usuario_id,0)||' '||
                        '            , descricao        = vc_tbl_descricao '     ||
                        '        WHERE '||vc_compo_id||' = vn_reg_id '           ||
                        '          AND tipo_id     = vn_tipo_id; '               ||
                        '  END;';

        BEGIN
          EXECUTE IMMEDIATE vc_sql USING vn_id
                                       , pn_reg_id
                                       , pn_tipo_id
                                       , pd_data
                                       , pc_tbl_descricao;
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;

      END IF;
    END p_prc_atualizar;

  BEGIN
    vn_complemento_id := cmx_pkg_tabelas.tabela_id('201',pc_complemento);
    vc_aplicacao      := cmx_pkg_tabelas.auxiliar(vn_complemento_id, 4);

    --SD
    OPEN  cur_tipo_sd;
    FETCH cur_tipo_sd INTO vn_tp_solic_id, vc_apl_tp_solic;
    CLOSE cur_tipo_sd;

    --SD DT
    OPEN  cur_tabelas('203', 'SD');
    FETCH cur_tabelas INTO vn_dt_sd_id, vc_apl_dt_sd, vc_dummy;
    CLOSE cur_tabelas;

    --AVERBAÇÃO
    OPEN  cur_tabelas('203', 'AVERBACAO');
    FETCH cur_tabelas INTO vn_dt_averbacao_id, vc_apl_dt_averb, vc_dummy;
    CLOSE cur_tabelas;

    --DATA_AVERBAÇÃO
    OPEN  cur_tabelas('203', 'DATA_AVERBACAO');
    FETCH cur_tabelas INTO vn_dt_averbacao_id2, vc_apl_dt_averb2, vc_dummy;
    CLOSE cur_tabelas;

    --CHAVE ACESSO
    OPEN  cur_tabelas('201', 'DUE_CHAVE_ACESSO');
    FETCH cur_tabelas INTO vn_chave_id, vc_dummy, vc_apl_chave;
    CLOSE cur_tabelas;

    IF vn_complemento_id IS NOT NULL THEN

      IF(  vc_aplicacao    IN ('E', 'F') OR vc_apl_tp_solic IN ('E', 'F')
        OR vc_apl_dt_averb IN ('E', 'F') OR vc_apl_chave    IN ('E', 'F')
        OR vc_apl_dt_averb2 IN ('E', 'F')
        ) THEN

        FOR x IN cur_fat LOOP

          IF(vc_aplicacao = 'E' AND x.embarque_id IS NOT NULL) THEN
            p_prc_atualizar ('E', x.embarque_id, vn_complemento_id, NULL, NULL, pc_valor, TRUE, NULL);
          ELSIF(vc_aplicacao = 'F') THEN
            p_prc_atualizar ('F', x.fatura_id, vn_complemento_id, NULL, NULL, pc_valor, TRUE, NULL);
          END IF;

          IF(pc_complemento = 'SD') THEN
            --TIPO SOLICITAÇÃO DE DESPACHO
            IF(vn_tp_solic_id IS NOT NULL) THEN
              IF(vc_apl_tp_solic = 'E' AND x.embarque_id IS NOT NULL) THEN
                p_prc_atualizar ('E', x.embarque_id, vn_tp_solic_id, cmx_pkg_tabelas.tabela_id('231', 'DUE'), 'DUE', 'DUE', TRUE, NULL);
              ELSIF(vc_apl_tp_solic = 'F') THEN
                p_prc_atualizar ('F', x.fatura_id, vn_tp_solic_id, cmx_pkg_tabelas.tabela_id('231', 'DUE'), 'DUE', 'DUE', TRUE, NULL);
              END IF;
            END IF;

            --CHAVE_ACESSO
            IF(vn_chave_id IS NOT NULL) THEN
              IF(vc_apl_chave = 'E' AND x.embarque_id IS NOT NULL) THEN
                p_prc_atualizar ('E', x.embarque_id, vn_chave_id, NULL, NULL, pc_chave_acesso, TRUE, NULL);
              ELSIF(vc_apl_chave = 'F') THEN
                p_prc_atualizar ('F', x.fatura_id, vn_chave_id, NULL, NULL, pc_chave_acesso, TRUE, NULL);
              END IF;
            END IF;

            --ATUALIZAR DATA DE REGISTRO
            IF(vn_dt_sd_id IS NOT NULL) THEN
              IF(vc_apl_dt_sd = 'E' AND x.embarque_id IS NOT NULL) THEN
                p_prc_atualizar ('E', x.embarque_id, vn_dt_sd_id, NULL, NULL, 'DUE', FALSE, pd_dt_registro);
              ELSIF(vc_apl_dt_sd = 'F') THEN
                p_prc_atualizar ('F', x.fatura_id, vn_dt_sd_id, NULL, NULL, 'DUE', FALSE, pd_dt_registro);
              END IF;
            END IF;

            --ATUALIZAR DATA DE AVERBACÃO
            IF(vn_dt_averbacao_id IS NOT NULL) THEN
              IF(vc_apl_dt_averb = 'E' AND x.embarque_id IS NOT NULL) THEN
                p_prc_atualizar ('E', x.embarque_id, vn_dt_averbacao_id, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
              ELSIF(vc_apl_dt_averb = 'F') THEN
                p_prc_atualizar ('F', x.fatura_id, vn_dt_averbacao_id, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
              END IF;
            END IF;
          END IF;

          --ATUALIZAR DATA DE AVERBACÃO2
            IF(vn_dt_averbacao_id2 IS NOT NULL) THEN
              IF(vc_apl_dt_averb2 = 'E' AND x.embarque_id IS NOT NULL) THEN
                p_prc_atualizar ('E', x.embarque_id, vn_dt_averbacao_id2, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
              ELSIF(vc_apl_dt_averb2 = 'F') THEN
                p_prc_atualizar ('F', x.fatura_id, vn_dt_averbacao_id2, NULL, NULL, 'DUE2', FALSE, pd_dt_averbacao);
              END IF;
            END IF;

        END LOOP;
      END IF;

      IF(  vc_aplicacao    IN ('L', 'D') OR vc_apl_tp_solic IN ('L', 'D')
        OR vc_apl_dt_averb IN ('L', 'D') OR vc_apl_chave    IN ('L', 'D')
        OR vc_apl_dt_averb2 IN ('L', 'D')
        ) THEN

        --DUE COM NOTA FISCAL
        FOR x IN cur_due_nf_lin LOOP
          IF(vc_aplicacao = 'L' AND x.fatura_item_id IS NOT NULL) THEN
            p_prc_atualizar ('L', x.fatura_item_id, vn_complemento_id, NULL, NULL, pc_valor, TRUE, NULL);
          ELSIF(vc_aplicacao = 'D') THEN
            p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_complemento_id, NULL, NULL, pc_valor, TRUE, NULL);
          END IF;

          IF(pc_complemento = 'SD') THEN
            --TIPO SOLICITAÇÃO DE DESPACHO
            IF(vn_tp_solic_id IS NOT NULL) THEN
              IF(vc_apl_tp_solic = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                p_prc_atualizar ('L', x.fatura_item_id, vn_tp_solic_id, cmx_pkg_tabelas.tabela_id('231', 'DUE'), 'DUE', 'DUE', TRUE, NULL);
              ELSIF(vc_apl_tp_solic = 'D') THEN
                p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_tp_solic_id, cmx_pkg_tabelas.tabela_id('231', 'DUE'), 'DUE', 'DUE', TRUE, NULL);
              END IF;
            END IF;

            --CHAVE_ACESSO
            IF(vn_chave_id IS NOT NULL) THEN
              IF(vc_apl_chave = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                p_prc_atualizar ('L', x.fatura_item_id, vn_chave_id, NULL, NULL, pc_chave_acesso, TRUE, NULL);
              ELSIF(vc_apl_chave = 'D') THEN
                p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_chave_id, NULL, NULL, pc_chave_acesso, TRUE, NULL);
              END IF;
            END IF;

            --ATUALIZAR DATA DE REGISTRO
            IF(vn_dt_sd_id IS NOT NULL) THEN
              IF(vc_apl_dt_sd = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                p_prc_atualizar ('L', x.fatura_item_id, vn_dt_sd_id, NULL, NULL, 'DUE', FALSE, pd_dt_registro);
              ELSIF(vc_apl_dt_sd = 'D') THEN
                p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_dt_sd_id, NULL, NULL, 'DUE', FALSE, pd_dt_registro);
              END IF;
            END IF;

            --ATUALIZAR DATA DE AVERBACÃO
            IF(vn_dt_averbacao_id IS NOT NULL) THEN
              IF(vc_apl_dt_averb = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                p_prc_atualizar ('L', x.fatura_item_id, vn_dt_averbacao_id, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
              ELSIF(vc_apl_dt_averb = 'D') THEN
                p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_dt_averbacao_id, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
              END IF;
            END IF;

            --ATUALIZAR DATA DE AVERBACÃO2
            IF(vn_dt_averbacao_id2 IS NOT NULL) THEN
              IF(vc_apl_dt_averb2 = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                p_prc_atualizar ('L', x.fatura_item_id, vn_dt_averbacao_id2, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
              ELSIF(vc_apl_dt_averb2 = 'D') THEN
                p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_dt_averbacao_id2, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
              END IF;
            END IF;

          END IF;

          vn_qtde_reg := vn_qtde_reg + 1;
        END LOOP;

        IF(vn_qtde_reg = 0) THEN

          --DUE SEM NOTA FISCAL
          FOR x IN cur_due_nf_lin LOOP
            IF(vc_aplicacao = 'L' AND x.fatura_item_id IS NOT NULL) THEN
              p_prc_atualizar ('L', x.fatura_item_id, vn_complemento_id, NULL, NULL, pc_valor, TRUE, NULL);
            ELSIF(vc_aplicacao = 'D') THEN
              p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_complemento_id, NULL, NULL, pc_valor, TRUE, NULL);
            END IF;

            IF(pc_complemento = 'SD') THEN
              --TIPO SOLICITAÇÃO DE DESPACHO
              IF(vn_tp_solic_id IS NOT NULL) THEN
                IF(vc_apl_tp_solic = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                  p_prc_atualizar ('L', x.fatura_item_id, vn_tp_solic_id, cmx_pkg_tabelas.tabela_id('231', 'DUE'), 'DUE', 'DUE', TRUE, NULL);
                ELSIF(vc_apl_tp_solic = 'D') THEN
                  p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_tp_solic_id, cmx_pkg_tabelas.tabela_id('231', 'DUE'), 'DUE', 'DUE', TRUE, NULL);
                END IF;
              END IF;

              --CHAVE_ACESSO
              IF(vn_chave_id IS NOT NULL) THEN
                IF(vc_apl_chave = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                  p_prc_atualizar ('L', x.fatura_item_id, vn_chave_id, NULL, NULL, pc_chave_acesso, TRUE, NULL);
                ELSIF(vc_apl_chave = 'D') THEN
                  p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_chave_id, NULL, NULL, pc_chave_acesso, TRUE, NULL);
                END IF;
              END IF;

              --ATUALIZAR DATA DE REGISTRO
              IF(vn_dt_sd_id IS NOT NULL) THEN
                IF(vc_apl_dt_sd = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                  p_prc_atualizar ('L', x.fatura_item_id, vn_dt_sd_id, NULL, NULL, 'DUE', FALSE, pd_dt_registro);
                ELSIF(vc_apl_dt_sd = 'D') THEN
                  p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_dt_sd_id, NULL, NULL, 'DUE', FALSE, pd_dt_registro);
                END IF;
              END IF;

              --ATUALIZAR DATA DE AVERBACÃO
              IF(vn_dt_averbacao_id IS NOT NULL) THEN
                IF(vc_apl_dt_averb = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                  p_prc_atualizar ('L', x.fatura_item_id, vn_dt_averbacao_id, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
                ELSIF(vc_apl_dt_averb = 'D') THEN
                  p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_dt_averbacao_id, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
                END IF;
              END IF;

              --ATUALIZAR DATA DE AVERBACÃO2
              IF(vn_dt_averbacao_id2 IS NOT NULL) THEN
                IF(vc_apl_dt_averb2 = 'L' AND x.fatura_item_id IS NOT NULL) THEN
                  p_prc_atualizar ('L', x.fatura_item_id, vn_dt_averbacao_id2, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
                ELSIF(vc_apl_dt_averb2 = 'D') THEN
                  p_prc_atualizar ('D', x.fatura_item_detalhe_id, vn_dt_averbacao_id2, NULL, NULL, 'DUE', FALSE, pd_dt_averbacao);
                END IF;
              END IF;
            END IF;

            vn_qtde_reg := vn_qtde_reg + 1;
          END LOOP;
        END IF;
      END IF;

    ELSE
      Raise_Application_Error(-20000, 'Complemento não cadastrado.');
    END IF;
  END prc_atual_compl;

  FUNCTION fnc_xml_due( pn_due_id                  NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_xml_nonf(vc_justificativa VARCHAR2)
      IS
  SELECT XMLElement("Declaration"
                                 , XMLAttributes('urn:wco:datamodel:WCO:GoodsDeclaration:1 GoodsDeclaration_1p0_DUE.xsd'  AS "xsi:schemaLocation"
                                                , 'urn:wco:datamodel:WCO:GoodsDeclaration_DS:1'                           AS "xmlns:ds"
                                                , 'urn:wco:datamodel:WCO:GoodsDeclaration:1'                              AS "xmlns"
                                                , 'http://www.w3.org/2001/XMLSchema-instance'                             AS "xmlns:xsi"
                                                )
                   , XMLElement("DeclarationNoNF"
                               , XMLElement("ID", NULL)
                               , XMLELement("DeclarationOffice"
                                           , XMLElement("ID", ed.doffice_identification)
                                           , XMLElement("Warehouse"
                                                       , XMLElement("ID", Decode(ed.whs_type, '19', ed.declarant_identification, ed.whs_identification))
                                                       , XMLElement("TypeCode", ed.whs_type)
                                                       , XMLForest( To_Char(whs_latitude , 'FM9999990D000000', 'NLS_NUMERIC_CHARACTERS=.,')  AS "LatitudeMeasure"
                                                                  , To_Char(whs_longitude, 'FM9999990D000000', 'NLS_NUMERIC_CHARACTERS=.,')  AS "LongitudeMeasure"
                                                                  , XMLForest(          whs_addr_line  AS "Line"

                                                                              ) AS "Address"
                                                                  ) AS "Warehouse"
                                                       )
                                           )
                               , fnc_due_adi(ed.due_id)
                               , XMLElement("CurrencyExchange"
                                           , XMLForest(
                                                        ed.currencytype AS "CurrencyTypeCode"
                                                      )
                                           )
                               , XMLElement("Declarant"
                                           , XMLElement("ID", ed.declarant_identification)
                                           , Decode( vc_justificativa
                                                   , 'S'
                                                   , Decode ( ed.declarant_name
                                                            , NULL
                                                            , NULL
                                                            , XMLElement("Contact"
                                                                        , XMLElement("Name", ed.declarant_name)
                                                                        , XMLForest(
                                                                                      XMLForest( ed.declarant_email AS "ID"
                                                                                              , Decode(ed.declarant_email, NULL, NULL, 'EM')  AS "TypeCode"
                                                                                              ) AS "Communication"
                                                                                    )
                                                                        , XMLForest(
                                                                                      XMLForest( ed.declarant_tel   AS "ID"
                                                                                              , Decode(ed.declarant_tel, NULL, NULL, 'TE')  AS "TypeCode"
                                                                                              ) AS "Communication"
                                                                                    )
                                                                        )
                                                            )
                                                  , NULL
                                                  )
                                           )
                               , XMLElement("ExitOffice"
                                           , XMLElement("ID", ed.exitoffice_identification)
                                           , XMLElement( "Warehouse"
                                                       , XMLElement("ID", exitoffice_whs_identification)
                                                       , XMLElement("TypeCode", exitoffice_whs_type)
                                                       )
                                           )
                               --, fnc_due_exporter(ed.due_id)
                               , fnc_due_goodsshipment(ed.due_id, 'N')
                               --, XMLElement("Importer"
                               --            , XMLElement("Name", ed.importer_name)
                               --            , XMLElement("Address"
                               --                        , XMLElement("CountryCode", ed.importer_addr_country)
                               --                        , XMLElement("Line", ed.importer_addr_line)
                               --                        )
                               --            )
                               , XMLForest(
                                           XMLForest(ed.ucr AS "TraderAssignedReferenceID") AS "UCR"
                                          )
                   )
                   ) xmlnonf
    FROM exp_due ed
   WHERE ed.due_id = pn_due_id;

  CURSOR cur_xml(vc_justificativa VARCHAR2)
      IS
  SELECT XMLElement("Declaration"
                                 , XMLAttributes('urn:wco:datamodel:WCO:GoodsDeclaration:1 GoodsDeclaration_1p0_DUE.xsd' AS "xsi:schemaLocation"
                                                , 'urn:wco:datamodel:WCO:GoodsDeclaration_DS:1'                           AS "xmlns:ds"
                                                , 'urn:wco:datamodel:WCO:GoodsDeclaration:1'                              AS "xmlns"
                                                , 'http://www.w3.org/2001/XMLSchema-instance'                             AS "xmlns:xsi"
                                                )
                   , XMLElement("DeclarationNFe"
                               , XMLElement("ID", NULL)
                               , XMLELement("DeclarationOffice"
                                           , XMLElement("ID", ed.doffice_identification)
                                           , XMLElement("Warehouse"
                                                       , XMLElement("ID", Decode(ed.whs_type, '19', ed.declarant_identification, ed.whs_identification))
                                                       , XMLElement("TypeCode", ed.whs_type)
                                                       , XMLForest( To_Char(whs_latitude , 'FM9999990D000000', 'NLS_NUMERIC_CHARACTERS=.,') AS "LatitudeMeasure"
                                                                  , To_Char(whs_longitude, 'FM9999990D000000', 'NLS_NUMERIC_CHARACTERS=.,') AS "LongitudeMeasure"
                                                                  , XMLForest(          whs_addr_line  AS "Line"

                                                                              ) AS "Address"
                                                                  ) AS "Warehouse"
                                                       )
                                           )
                               , fnc_due_adi(ed.due_id)
                               , XMLElement("CurrencyExchange"
                                           , XMLForest(
                                                        ed.currencytype AS "CurrencyTypeCode"
                                                      )
                                           )
                               , XMLElement("Declarant"
                                           , XMLElement("ID", ed.declarant_identification)
                                           , Decode( vc_justificativa
                                                   , 'S'
                                                   , Decode ( ed.declarant_name
                                                            , NULL
                                                            , NULL
                                                            , XMLElement("Contact"
                                                                        , XMLElement("Name", ed.declarant_name)
                                                                        , XMLForest( XMLForest( ed.declarant_email AS "ID"
                                                                                              , Decode(ed.declarant_email, NULL, NULL, 'EM')  AS "TypeCode"
                                                                                              ) AS "Communication"
                                                                                  )
                                                                        , XMLForest( XMLForest( ed.declarant_tel   AS "ID"
                                                                                              , Decode(REPLACE(ed.declarant_tel, ' ', ''), NULL, NULL, 'TE')  AS "TypeCode"
                                                                                              ) AS "Communication"
                                                                                  )
                                                                        )
                                                            )
                                                  , NULL
                                                  )
                                           )
                               , XMLElement("ExitOffice"
                                           , XMLElement("ID", ed.exitoffice_identification)
                                           , XMLElement( "Warehouse"
                                                       , XMLElement("ID", exitoffice_whs_identification)
                                                       , XMLElement("TypeCode", exitoffice_whs_type)
                                                       )
                                           )
                               --, fnc_due_exporter(ed.due_id)
                               , fnc_due_goodsshipment(ed.due_id, 'S')
                               --, XMLElement("Importer"
                               --            , XMLElement("Name", ed.importer_name)
                               --            , XMLElement("Address"
                               --                        , XMLElement("CountryCode", ed.importer_addr_country)
                               --                        , XMLElement("Line", ed.importer_addr_line)
                               --                        )
                               --            )
                               , XMLForest(
                                           XMLForest(ed.ucr AS "TraderAssignedReferenceID") AS "UCR"
                                          )
                   )
                   ) xmlnf
    FROM exp_due ed
   WHERE ed.due_id = pn_due_id;

  CURSOR cur_nf
      IS
  SELECT ed.com_nf
    FROM exp_due ed
   WHERE ed.due_id    = pn_due_id;

  CURSOR cur_avd
      IS
  SELECT due_gsi_add_info_id
    FROM exp_due_gs_item_add_info info
       , exp_due_ship_item        item
   WHERE info.due_ship_item_id = item.due_ship_item_id
     AND info.statementtypecode = 'AVD'
     AND info.statementdescription IS NOT NULL
     AND item.due_id = pn_due_id;

  vx_xml               XMLTYPE;
  vn_fatura_nf_id      NUMBER;
  vb_found             BOOLEAN;
  vc_com_nf            VARCHAR2(100);
  vn_add_info_id       NUMBER;
  vb_achou             BOOLEAN;
  vc_justificativa     VARCHAR2(1) := 'N';

  BEGIN
    OPEN  cur_nf;
    FETCH cur_nf INTO vc_com_nf;
    vb_found := cur_nf%FOUND;
    CLOSE cur_nf;

    vb_achou := FALSE;
    OPEN  cur_avd;
    FETCH cur_avd INTO vn_add_info_id;
    vb_achou := cur_avd%FOUND;
    CLOSE cur_avd;

    IF(vb_achou) THEN
      vc_justificativa := 'S';
    END IF;

    IF vc_com_nf = 'S' THEN

      OPEN cur_xml(vc_justificativa);
      FETCH cur_xml INTO vx_xml;
      CLOSE cur_xml;
    ELSE
      OPEN  cur_xml_nonf(vc_justificativa);
      FETCH cur_xml_nonf INTO vx_xml;
      CLOSE cur_xml_nonf;
    END IF;

    UPDATE exp_due SET xml       = vx_xml
                     , xml_envio = (vx_xml).getclobval()
                 where due_id = pn_due_id;

    RETURN      vx_xml;
  END fnc_xml_due;

  FUNCTION fnc_due_adi( pn_due_id NUMBER) RETURN XMLTYPE
  AS
    CURSOR cur_due_adi
        IS
    SELECT XMLAGG(
                  XMLForest(
                            XMLForest(
                                        edai.statementcode            AS "StatementCode"
                                      , edai.statementdescription     AS "StatementDescription"
                                      , edai.limitdatetime            AS "LimitDateTime"
                                      , edai.statementtypecode        AS "StatementTypeCode"
                                      ) AS "AdditionalInformation"
                          )
                )
      FROM exp_due_add_info edai
    WHERE edai.due_id = pn_due_id;

    vx_due_adi           XMLTYPE;

  BEGIN
    OPEN cur_due_adi;
    FETCH cur_due_adi INTO vx_due_adi;
    CLOSE cur_due_adi;

    RETURN vx_due_adi;
  END fnc_due_adi;

  FUNCTION fnc_due_exporter( pn_due_id                NUMBER) RETURN XMLTYPE
  AS
    CURSOR cur_exporter
        IS
    SELECT XMLAGG(
                  XMLForest(
                        XMLForest(
                                   ede.name           AS "Name"
                                 , ede.identification AS "ID"
                                 , XMLForest(
                                              ede.countrycode AS "CountryCode"
                                            , Decode(ede.countrycode, NULL, NULL, ede.countrycode || '-' ) || ede.countrysubdivisioncode AS "CountrySubDivisionCode"
                                            , ede.addr_line AS "Line"
                                            ) AS "Address"
                                 ) AS "Exporter"
                        )
                 )
      FROM exp_due_exporter ede
     WHERE ede.due_id = pn_due_id;

    vx_due_exporter      XMLTYPE;

  BEGIN
    OPEN cur_exporter;
    FETCH cur_exporter INTO vx_due_exporter;
    CLOSE cur_exporter;

    RETURN vx_due_exporter;

  END fnc_due_exporter;

  FUNCTION fnc_due_gs_adi( pn_due_ship_id NUMBER) RETURN XMLTYPE
  AS

    CURSOR cur_due_gs_adi
        IS
    SELECT XMLAGG(
                  XMLForest(
                            XMLForest(
                                        edai.statementcode            AS "StatementCode"
                                      , edai.statementtypecode        AS "StatementTypeCode"
                                      , edai.statementdescription     AS "StatementDescription"
                                      , edai.limitdatetime            AS "LimitDateTime"
                                      ) AS "AdditionalInformation"
                          )
                )
      FROM exp_due_gs_add_info edai
    WHERE edai.due_ship_id = pn_due_ship_id;

    vx_due_gs_adi           XMLTYPE;

  BEGIN
    OPEN cur_due_gs_adi;
    FETCH cur_due_gs_adi INTO vx_due_gs_adi;
    CLOSE cur_due_gs_adi;

    RETURN vx_due_gs_adi;
  END fnc_due_gs_adi;

  FUNCTION fnc_due_gs_ref( pn_due_ship_id             NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_ref
      IS
  SELECT XMLAGG( XMLElement( "ReferencedInvoice"
                           , XMLForest( edri.identification AS  "ID"
                                      , edri.typecode       AS  "TypeCode"
                                      --, XMLForest(edri.issuedatetime AS "DateTime") AS  "IssueDateTime"
                                      --, edri.sequencenumeric AS "SequenceNumeric"
                                      , XMLForest( edri.ivc_sbmttr_identif AS "ID"
                                                 --, XMLForest( edri.ivc_sbmttr_addr_ctrysuddiv AS "CountrySubDivisionCode"
                                                 --           )AS "Address"
                                                 ) AS "Submitter"
                                      )
                           )
               )
  FROM  exp_due_si_ref_ivc  edri
  WHERE edri.due_ship_id = pn_due_ship_id
  ORDER BY To_Number(edri.sequencenumeric);

  vx_ref XMLTYPE;

  BEGIN
    OPEN cur_ref;
    FETCH cur_ref INTO vx_ref;
    CLOSE cur_ref;

    RETURN vx_ref;
  END fnc_due_gs_ref;

  FUNCTION fnc_due_goodsshipment( pn_due_id           NUMBER, pc_nf VARCHAR2) RETURN XMLTYPE
  AS

  CURSOR cur_gs_s
      IS
  SELECT XMLAGG(
                XMLElement( "GoodsShipment"
                          , fnc_due_gs_item(eds.due_ship_id,'S')
                          , XMLElement( "Invoice"
                                      , XMLForest( eds.ivc_identification AS "ID"
                                                 , eds.ivc_type           AS "TypeCode"
--                                                 , eds.ivc_issue          AS "IssueDateTime"
                                                 , XMLForest(
                                                              eds.ivc_sbmttr_identif AS "ID"
--                                                            , XMLForest( eds.ivc_sbmttr_addr_ctrysuddiv AS "CountrySubDivisionCode"
--                                                                       )AS "Address"
                                                            ) AS "Submitter"
                                                 )
                                                 --, fnc_due_gs_adi(eds.due_ship_id)
                                                 , fnc_due_gs_ref(eds.due_ship_id)
                                      )
                          , XMLElement("TradeTerms"
                                      , XMLElement("ConditionCode", eds.ivc_tradeterms_condition)
                                      )
                          )
               ORDER BY To_Number(eds.due_ship_id) )
    FROM exp_due_ship eds
   WHERE eds.due_id            = pn_due_id
   ORDER BY eds.due_ship_id;

  CURSOR cur_gs_n
      IS
  SELECT XMLAGG(
                XMLElement( "GoodsShipment"
                          , fnc_due_exporter(pn_due_id)
                          , fnc_due_gs_item(eds.due_ship_id,'N')
                          , XMLElement("Importer"
                                      , XMLElement("Name", edf.importer_name)
                                      , XMLElement("Address"
                                                  , XMLElement("CountryCode", edf.importer_addr_country)
                                                  , XMLElement("Line", edf.importer_addr_line)
                                                  )
                                      )
                          , XMLElement( "Invoice"
                                      , XMLElement( "TypeCode", eds.ivc_type          )
                                      --           --, eds.ivc_identification AS "ID"
                                      --           --, eds.ivc_issue          AS "IssueDateTime"
                                      --           --, XMLForest(
                                      --           --             eds.ivc_sbmttr_identif AS "ID"
                                      --           --           , XMLForest( eds.ivc_sbmttr_addr_ctrysuddiv AS "CountrySubDivisionCode"
                                      --           --                      )AS "Address"
                                      --           --           ) AS "Submitter"
                                      --           --
                                      --           )
                                                 , fnc_due_gs_adi(eds.due_ship_id)
                                                 --, fnc_due_gs_ref(eds.due_ship_id)

                                     )
                          , XMLElement("TradeTerms"
                                      , XMLElement("ConditionCode", eds.ivc_tradeterms_condition)
                                      )
                          )
               ORDER BY To_Number(eds.due_ship_id) )
    FROM exp_due_ship eds
       , exp_due      ed
       , exp_due_faturas edf
   WHERE eds.due_id            = ed.due_id
     AND eds.fatura_id         = edf.fatura_id
     AND edf.due_id            = ed.due_id
     AND ed.due_id             = pn_due_id
   ORDER BY eds.due_ship_id;

  vx_gs XMLTYPE;

  BEGIN
    IF pc_nf = 'S' THEN
      OPEN cur_gs_s;
      FETCH cur_gs_s INTO vx_gs;
      CLOSE cur_gs_s;
    ELSE
      OPEN cur_gs_n;
      FETCH cur_gs_n INTO vx_gs;
      CLOSE cur_gs_n;
    END IF;
    RETURN vx_gs;
  END fnc_due_goodsshipment;

  FUNCTION fnc_due_gs_item( pn_due_ship_id NUMBER, pc_nf VARCHAR2) RETURN XMLTYPE
  AS

  CURSOR cur_gsi_s
      IS
  SELECT XMLAGG(
                 XMLElement( "GovernmentAgencyGoodsItem"
                           , XMLForest( To_Char(edsi.customsvalue, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,') AS "CustomsValueAmount"
                                      , Decode(Nvl(edsi.financedvalue,0), 0, NULL, To_Char(edsi.financedvalue, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,')) AS "FinancedValueAmount"
                                      , edsi.sequence AS "SequenceNumeric"
                                      )
                           , fnc_due_gs_item_dest(edsi.due_ship_item_id)
                           , fnc_due_gs_item_adoc( edsi.due_ship_item_id )
                           , fnc_due_gs_item_adi(edsi.due_ship_item_id)
                           , XMLElement("Commodity"
                                       , XMLForest(
                                         fnc_normalizar_texto_xml(edsi.cmmdty_description)    AS "Description"
                                       , To_Char(edsi.cmmdty_value, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,') AS "ValueAmount"
                                       --, edsi.cmmdty_commercial_descr  AS "CommercialDescription"
                                       ,
                                                    XMLForest(
                                                              null       AS "ID"
                                                             , Decode(null, NULL, NULL,'HS') AS "IdentificationTypeCode"
                                                             )              AS "Classification"
                                                  )
                                       , XMLElement( "InvoiceLine"
                                                   , XMLForest(edsi.cmmdty_line_sequence AS "SequenceNumeric")
                                                   , fnc_due_gs_item_ref( edsi.due_ship_item_id )
                                                   )
                                       --, fnc_due_gs_item_prod( edsi.due_ship_item_id )
                                       , fnc_due_gs_item_char( edsi.due_ship_item_id )
                                       , fnc_due_gs_item_crit( edsi.due_ship_item_id )
                                      )
                           , XMLElement( "GoodsMeasure"
                                       , XMLElement( "NetNetWeightMeasure", To_Char(edsi.cmmdty_gs_netweight,'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,'))
                                       --, XMLElement( "TariffQuantity"     , edsi.cmmdty_gs_tariff)
                                       )
                           , fnc_due_gs_item_enq( edsi.due_ship_item_id )
                           , fnc_due_gs_item_pdoc( edsi.due_ship_item_id )
                           , fnc_due_gs_item_adj( edsi.due_ship_item_id )
                           )
               ORDER BY To_Number(edsi.sequence) )
  FROM exp_due_ship_item edsi
  WHERE edsi.due_ship_id  = pn_due_ship_id
  ORDER BY To_Number(edsi.sequence);

  CURSOR cur_gsi_n
      IS
  SELECT XMLAGG(
                 XMLElement( "GovernmentAgencyGoodsItem"
                           , XMLForest( To_Char(edsi.customsvalue, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,') AS "CustomsValueAmount"
                                      , Decode(Nvl(edsi.financedvalue,0), 0, NULL, To_Char(edsi.financedvalue, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,')) AS "FinancedValueAmount"
                                      , edsi.sequence AS "SequenceNumeric"
                                      )
                           , fnc_due_gs_item_dest(edsi.due_ship_item_id)
                           , fnc_due_gs_item_adoc( edsi.due_ship_item_id )
                           , fnc_due_gs_item_adi(edsi.due_ship_item_id)
                           , XMLElement("Commodity"
                                       , XMLForest(
                                         fnc_normalizar_texto_xml(edsi.cmmdty_description)       AS "Description"
                                       , To_Char(edsi.cmmdty_value, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,') AS "ValueAmount"
                                       , edsi.cmmdty_commercial_descr  AS "CommercialDescription"
                                       ,            XMLForest(
                                                              edsi.ncm       AS "ID"
                                                             , Decode(edsi.ncm, NULL, NULL,'HS') AS "IdentificationTypeCode"
                                                             )              AS "Classification"
                                                  )
                                       --, XMLElement( "InvoiceLine"
                                       --            , XMLForest(edsi.cmmdty_line_sequence AS "SequenceNumeric")
                                       --            , fnc_due_gs_item_ref( edsi.due_ship_item_id )
                                       --            )
                                       , XMLElement( "GoodsMeasure"
                                                   , XMLElement("TypeCode", edsi.cmmdty_gs_cod_est)
                                                   , XMLElement("TariffQuantity", To_Char(edsi.cmmdty_gs_tariff_est, 'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,'))
                                                   )
                                       , XMLElement( "GoodsMeasure"
                                                   , XMLElement("UnitDescription", edsi.cmmdty_gs_umed_com)
                                                   , XMLElement("TypeCode", edsi.cmmdty_gs_cod_com)
                                                   , XMLElement("TariffQuantity", To_Char(edsi.cmmdty_gs_tariff, 'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,'))
                                                   )
                                       , fnc_due_gs_item_prod( edsi.due_ship_item_id )
                                       , fnc_due_gs_item_char( edsi.due_ship_item_id )
                                       , fnc_due_gs_item_crit( edsi.due_ship_item_id )
                                      )
                           , XMLElement( "GoodsMeasure"
                                       , XMLElement( "NetNetWeightMeasure", To_Char(edsi.cmmdty_gs_netweight,'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,'))
                                       --, XMLElement( "TariffQuantity"     , edsi.cmmdty_gs_tariff)
                                       )
                           , fnc_due_gs_item_enq( edsi.due_ship_item_id )
                           , fnc_due_gs_item_pdoc( edsi.due_ship_item_id )
                           , fnc_due_gs_item_adj( edsi.due_ship_item_id )
                           )
               ORDER BY To_Number(edsi.sequence) )
  FROM exp_due_ship_item edsi
  WHERE edsi.due_ship_id  = pn_due_ship_id
  ORDER BY To_Number(edsi.sequence);

  vx_due_gsi XMLTYPE;

  BEGIN
    IF pc_nf = 'S' THEN
      OPEN cur_gsi_s;
      FETCH cur_gsi_s INTO vx_due_gsi;
      CLOSE cur_gsi_S;
    ELSE
      OPEN cur_gsi_n;
      FETCH cur_gsi_n INTO vx_due_gsi;
      CLOSE cur_gsi_n;
    END IF;

    RETURN vx_due_gsi;
  END fnc_due_gs_item;

  FUNCTION fnc_due_gs_item_adi( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE
  AS

    CURSOR cur_due_gsi_adi
        IS
    SELECT XMLAGG(
                  XMLForest(
                            XMLForest(
                                        edai.statementcode            AS "StatementCode"
                                      , edai.statementdescription     AS "StatementDescription"
                                      , edai.limitdatetime            AS "LimitDateTime"
                                      , edai.statementtypecode        AS "StatementTypeCode"
                                      ) AS "AdditionalInformation"
                          )
                ORDER BY Decode(edai.statementtypecode, 'AVD', 0, 1)
                )
      FROM exp_due_gs_item_add_info edai
    WHERE edai.due_ship_item_id = pn_due_ship_item_id;

    vx_due_gsi_adi           XMLTYPE;

  BEGIN
    OPEN cur_due_gsi_adi;
    FETCH cur_due_gsi_adi INTO vx_due_gsi_adi;
    CLOSE cur_due_gsi_adi;

    RETURN vx_due_gsi_adi;
  END fnc_due_gs_item_adi;

  FUNCTION fnc_due_gi_adoc_ainfo( pn_due_si_adoc_id  NUMBER) RETURN XMLTYPE
  AS

    CURSOR cur_due_gsi_adi
        IS
    SELECT XMLAGG(
                  XMLForest(
                            edai.statementtypecode        AS "StatementTypeCode"
                          , edai.statementdescription     AS "StatementDescription"
                          --, edai.limitdatetime            AS "LimitDateTime"
                          , edai.statementcode            AS "StatementCode"
                          )
                ORDER BY Decode(edai.statementtypecode, 'AVD', 0, 1)
                )
      FROM exp_due_si_adoc_add_info edai
    WHERE edai.due_si_adoc_id = pn_due_si_adoc_id;

    vx_due_gsi_adi           XMLTYPE;

  BEGIN
    OPEN cur_due_gsi_adi;
    FETCH cur_due_gsi_adi INTO vx_due_gsi_adi;
    CLOSE cur_due_gsi_adi;

    RETURN vx_due_gsi_adi;
  END fnc_due_gi_adoc_ainfo;

  FUNCTION fnc_due_gi_adoc_inv(pn_due_si_adoc_id  NUMBER) RETURN XMLTYPE
  AS

    CURSOR cur_due_gsi_adi
        IS
    SELECT XMLAGG(
                  XMLForest( edai.identification                          AS "ID"
                           , To_Char(edai.issuedatetime, 'YYYY-MM-DD')    AS "IssueDateTime"
                           , edai.typecode                                AS "TypeCode"
                           , To_Char(edai.customsvalueamount, 'FM999999999999990D00', 'NLS_NUMERIC_CHARACTERS=.,')       AS "CustomsValueAmount"
                           , To_Char(edai.quantityquantity, 'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,')      AS "QuantityQuantity"
                           )
                )
      FROM exp_due_si_adoc_inv edai
    WHERE edai.due_si_adoc_id = pn_due_si_adoc_id;

    vx_due_gsi_adi           XMLTYPE;

  BEGIN
    OPEN cur_due_gsi_adi;
    FETCH cur_due_gsi_adi INTO vx_due_gsi_adi;
    CLOSE cur_due_gsi_adi;

    RETURN vx_due_gsi_adi;
  END fnc_due_gi_adoc_inv;

  --
  FUNCTION fnc_due_gi_adoc_pdoc(pn_due_si_adoc_id  NUMBER) RETURN XMLTYPE
  AS

    CURSOR cur_due_gsi_adi
        IS
    SELECT XMLAGG(
                  XMLForest(
                             To_Char(edap.amountamount, 'FM999999999999990D00', 'NLS_NUMERIC_CHARACTERS=.,') AS "AmountAmount"
                           , edap.categorycode AS "CategoryCode"
                           , edap.identification AS "ID"
                           , To_Char(edap.quantityquantity, 'FM999999999999990D00', 'NLS_NUMERIC_CHARACTERS=.,') AS "QuantityQuantity"
                           , edap.itemid AS "ItemID"
                           )
                )
      FROM exp_due_si_adoc_pdoc edap
    WHERE edap.due_si_adoc_id = pn_due_si_adoc_id;

    vx_due_gsi_adi           XMLTYPE;

  BEGIN
    OPEN cur_due_gsi_adi;
    FETCH cur_due_gsi_adi INTO vx_due_gsi_adi;
    CLOSE cur_due_gsi_adi;

    RETURN vx_due_gsi_adi;
  END fnc_due_gi_adoc_pdoc;
  --

  FUNCTION fnc_due_gs_item_dest( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE
  AS
    CURSOR cur_dest
        IS
    SELECT xmlagg( XMLElement( "Destination"
                             , XMLElement("CountryCode", edsid.countrycode)
                             , XMLElement("GoodsMeasure"
                                         , XMLElement("TariffQuantity", To_Char(edsid.gm_tariffquantity, 'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,'))
                                         )
                             )
                 )
      FROM exp_due_si_dest edsid
     WHERE edsid.due_ship_item_id = pn_due_ship_item_id;

     vx_dest XMLTYPE;
  BEGIN
    OPEN cur_dest;
    FETCH cur_dest INTO vx_dest;
    CLOSE cur_dest;

    RETURN vx_dest;
  END fnc_due_gs_item_dest;

  FUNCTION fnc_due_gs_item_ref( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_refi
      IS
  SELECT XMLAGG(
                XMLELement("ReferencedInvoiceLine"
                          , XMLForest( edri.sequencenumeric             AS "SequenceNumeric"
                                     --, edri.invoiceidentificationid AS "InvoiceIdentificationID"
                                     , nf.identification                AS "InvoiceIdentificationID"
                                     , XMLForest( Decode(edri.gm_tariffquantity
                                                        , NULL
                                                        , NULL
                                                        , To_Char(edri.gm_tariffquantity,'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,')
                                                        ) AS "TariffQuantity") AS "GoodsMeasure"
                                     )
                          )
               )
    FROM exp_due_si_ref_ivcl edri
       , exp_due_si_ref_ivc  nf
   WHERE edri.due_si_ref_ivc_id = nf.due_si_ref_ivc_id
     AND edri.due_ship_item_id = pn_due_ship_item_id;

  vx_refi XMLTYPE;

  BEGIN
    OPEN cur_refi;
    FETCH cur_refi INTO vx_refi;
    CLOSE cur_refi;

    RETURN vx_refi;
  END fnc_due_gs_item_ref;

  FUNCTION fnc_due_gs_item_prod( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_prod
      IS
  SELECT XMLAGG(
                XMLElement( "Product"
                          , XMLForest( edp.identification     AS "ID"
                                     , edp.identifiertypecode AS "IdentifierTypeCode"
                                     )
                          )
               )
    FROM exp_due_si_prod edp
   WHERE edp.due_ship_item_id = pn_due_ship_item_id;

  vx_prod XMLTYPE;

  BEGIN
    OPEN  cur_prod;
    FETCH cur_prod INTO vx_prod;
    CLOSE cur_prod;

    RETURN vx_prod;
  END fnc_due_gs_item_prod;

  FUNCTION fnc_due_gs_item_char( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_char
      IS
  SELECT XMLAGG(
                XMLElement( "ProductCharacteristics"
                          ,  XMLForest( edc.typecode     AS "TypeCode"
                                      , edc.description  AS "Description"
                                      )
                          )
               )
    FROM exp_due_si_char edc
   WHERE edc.due_ship_item_id = pn_due_ship_item_id;


  vx_char XMLTYPE;

  BEGIN

    OPEN cur_char;
    FETCH cur_char INTO vx_char;
    CLOSE cur_char;

    RETURN vx_char;
  END fnc_due_gs_item_char;

  FUNCTION fnc_due_gs_item_crit( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_crit
      IS
  SELECT XMLAGG(
                XMLElement( "ProductCriteriaConformance"
                          ,  Decode( nullif(edc.quantityquantity,0)
                                   , NULL
                                   , NULL
                                   , XMLElement("QuantityQuantity"  , To_Char(edc.quantityquantity, 'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,'))
                                   )
                          ,  XMLElement("TypeCode"   , edc.typecode    )
                          ,  XMLElement("Description", edc.description )
                          )
               )
    FROM exp_due_si_crit edc
   WHERE edc.due_ship_item_id = pn_due_ship_item_id;


  vx_crit XMLTYPE;

  BEGIN

    OPEN  cur_crit;
    FETCH cur_crit INTO vx_crit;
    CLOSE cur_crit;

    RETURN vx_crit;

  END fnc_due_gs_item_crit;

  FUNCTION fnc_due_gs_item_enq( pn_due_ship_item_id   NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_enq
      IS
  SELECT XMLAGG(
                XMLElement( "GovernmentProcedure"
                          , XMLForest( ede.enquadramento     AS "CurrentCode")
                          )
               )
    FROM exp_due_si_enq ede
   WHERE ede.due_ship_item_id = pn_due_ship_item_id;

  vx_enq XMLTYPE;

  BEGIN
    OPEN  cur_enq;
    FETCH cur_enq INTO vx_enq;
    CLOSE cur_enq;

    RETURN vx_enq;
  END fnc_due_gs_item_enq;

  FUNCTION fnc_due_gs_item_adoc( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_adoc
      IS
  SELECT XMLAGG(
                 XMLForest(
                              XMLForest(
                                         eda.category                                   AS "CategoryCode"
                                       , eda.identification                             AS "ID"
                                       , eda.drawbackhsclassification                   AS "DrawbackHsClassification"
                                       , eda.drawbackrecipientid                        AS "DrawbackRecipientId"
                                       , Decode( eda.vlrwithoutexcoveramount
                                               , 0
                                               , NULL
                                               , To_Char(eda.vlrwithoutexcoveramount, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,')
                                               )                                        AS "ValueWithoutExchangeCoverAmount"
                                       , Decode( eda.vlrwithexcoveramount
                                               , 0
                                               , NULL
                                               , To_Char(eda.vlrwithexcoveramount, 'FM99999999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,')
                                               )                                        AS "ValueWithExchangeCoverAmount"
                                       , eda.itemid                                     AS "ItemID"
                                       , To_Char(eda.quantity,'FM999999999999990D00000', 'NLS_NUMERIC_CHARACTERS=.,') AS "QuantityQuantity"
                                       , fnc_due_gi_adoc_ainfo(due_si_adoc_id)  AS "AdditionalInformation"
                                       , fnc_due_gi_adoc_pdoc(due_si_adoc_id)   AS "PreviousDocument"
                                       , fnc_due_gi_adoc_inv(due_si_adoc_id)    AS "Invoice"
                                       ) AS "AdditionalDocument"
                             )

               )
    FROM exp_due_si_adoc eda
   WHERE eda.due_ship_item_id = pn_due_ship_item_id;

  vx_adoc XMLTYPE;

  BEGIN
    OPEN  cur_adoc;
    FETCH cur_adoc INTO vx_adoc;
    CLOSE cur_adoc;

    RETURN vx_adoc;
  END fnc_due_gs_item_adoc;

  FUNCTION fnc_due_gs_item_pdoc( pn_due_ship_item_id  NUMBER) RETURN XMLTYPE
  AS

  CURSOR cur_pdoc
      IS
  SELECT XMLAGG(
                XMLElement( "PreviousDocument"
                          ,  XMLForest( edp.identification     AS "ID"
                                      , edp.typecode AS "TypeCode"
                                      )
                          )
               )
    FROM exp_due_si_pdoc edp
   WHERE edp.due_ship_item_id = pn_due_ship_item_id;

  vx_pdoc XMLTYPE;

  BEGIN
    OPEN  cur_pdoc;
    FETCH cur_pdoc INTO vx_pdoc;
    CLOSE cur_pdoc;

    RETURN vx_pdoc;
  END fnc_due_gs_item_pdoc;

  FUNCTION fnc_due_gs_item_adj(pn_due_ship_item_id  NUMBER) RETURN XMLTYPE
  IS

  CURSOR cur_adj
      IS
  SELECT XMLAGG ( XMLElement( "ValuationAdjustment"
                            , XMLForest ( eds.additioncode AS "AdditionCode"
                                        , To_Char(eds.percentage,'FM999999999999990D00', 'NLS_NUMERIC_CHARACTERS=.,') AS "PercentageNumeric"
                                        )
                            )
                )
    FROM exp_due_ship_item_adj eds
   WHERE due_ship_item_id = pn_due_ship_item_id;

    vx_adj XMLTYPE;
  BEGIN
    --EX0073 e EX0074
    OPEN  cur_adj;
    FETCH cur_adj INTO vx_adj;
    CLOSE cur_adj;

    RETURN vx_adj;
  END fnc_due_gs_item_adj;

  FUNCTION fnc_ret_val( pn_fatura_id                 NUMBER
                      , pn_fatura_item_id            NUMBER
                      , pn_fatura_item_detalhe_id    NUMBER
                      , pn_embarque_id               NUMBER
                      , pn_fatura_nf_id              NUMBER
                      , pc_nivel                     VARCHAR2
                      , pc_tipo                      VARCHAR2
                      , pc_origem                    VARCHAR2
                      , pc_valor                     VARCHAR2
                      , pc_mascara                   VARCHAR2
                      , pn_due_id                    NUMBER
                      , pn_fatura_det_nf_id          NUMBER
                      , pn_tamanho                   NUMBER
                      , pc_corta_tamanho             VARCHAR2
                      , pc_identificador             VARCHAR2
                      ) RETURN VARCHAR2
  AS

  CURSOR cur_fat
      IS
  SELECT DISTINCT ef.fatura_numero || '/' || ef.fatura_ano
    FROM exp_faturas ef
  WHERE ef.fatura_id = pn_fatura_id;

  CURSOR cur_item
     IS
  SELECT DISTINCT SubStr(efi.codigo  || ' - ' || efi.descricao,1,4000) item_descricao
    FROM exp_vw_fatura_itens efi
   WHERE efi.fatura_item_id = pn_fatura_item_id;


    vc_retorno VARCHAR2(4000);
    vc_sql     VARCHAR2(32000);
    vc_fatura  VARCHAR2(4000);
    vc_item    VARCHAR2(4000);
  BEGIN

  IF ( pc_tipo = 'F' ) THEN
    RETURN pc_valor;    -- VALOR FIXO
  END IF;

  vc_sql :=
'
DECLARE
  vn_fatura_id                 NUMBER := :1;
  vn_fatura_item_id            NUMBER := :2;
  vn_fatura_item_detalhe_id    NUMBER := :3;
  vn_embarque_id               NUMBER := :4;
  vn_fatura_nf_id              NUMBER := :5;
  vn_due_id                    NUMBER := :6;
  vn_fatura_det_nf_id          NUMBER := :7;
  vc_retorno                   VARCHAR2(4000);
BEGIN
';

    IF (pc_tipo = 'T') THEN

      vc_sql := vc_sql || '  SELECT ';

      IF (pc_mascara IS NOT NULL) THEN
        vc_sql := vc_sql || ' TO_CHAR( ' || pc_valor || ',''' || pc_mascara || ''')';
      ELSE
        vc_sql := vc_sql || pc_valor ;
      END IF;

      vc_sql := vc_sql ||  ' INTO vc_retorno FROM ';

      IF ( pc_nivel = 'F') THEN
        vc_sql := vc_sql || ' exp_faturas ef WHERE fatura_id = vn_fatura_id;';
      ELSIF ( pc_nivel = 'L' ) THEN
        vc_sql := vc_sql || ' exp_fatura_itens efi WHERE fatura_item_id = vn_fatura_item_id;';
      ELSIF ( pc_nivel = 'D' ) THEN
        vc_sql := vc_sql || ' exp_fatura_item_detalhes efid WHERE fatura_item_detalhe_id = vn_fatura_item_detalhe_id;';
      ELSIF ( pc_nivel = 'E' ) THEN
        vc_sql := vc_sql || ' exp_embarques ee WHERE embarque_id = vn_embarque_id;';
      ELSIF ( pc_nivel = 'N' ) THEN
        vc_sql := vc_sql || ' exp_fatura_nf efn WHERE fatura_nf_id = vn_fatura_nf_id;';
      ELSIF ( pc_nivel = 'DNF' ) THEN
        vc_sql := vc_sql || ' exp_fatura_item_det_nf efn WHERE fatura_det_nf_id = vn_fatura_det_nf_id;';
      END IF;

    ELSIF ( pc_tipo = 'P' ) THEN
      vc_sql := vc_sql || pc_valor;
    ELSIF ( pc_tipo = 'I') THEN
      IF ( pc_origem = 'DP' )  THEN
        IF (pc_mascara IS NOT NULL) THEN
          vc_sql := vc_sql || ' vc_retorno := to_char(exp_pkg_informacoes.fnc_data_prevista(cmx_pkg_tabelas.tabela_id(''203'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id)' || ',''' || pc_mascara || '''); ';
        ELSE
          vc_sql := vc_sql || ' vc_retorno := exp_pkg_informacoes.fnc_data_prevista(cmx_pkg_tabelas.tabela_id(''203'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id);';
        END IF;
      ELSIF ( pc_origem = 'DR') THEN
        IF (pc_mascara IS NOT NULL) THEN
          vc_sql := vc_sql || ' vc_retorno := to_char(exp_pkg_informacoes.fnc_data_realizada(cmx_pkg_tabelas.tabela_id(''203'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id)' || ',''' || pc_mascara || '''); ';
        ELSE
          vc_sql := vc_sql || ' vc_retorno := exp_pkg_informacoes.fnc_data_realizada(cmx_pkg_tabelas.tabela_id(''203'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id);';
        END IF;
      ELSIF ( pc_origem = 'VA') THEN
        IF (pc_mascara IS NOT NULL) THEN
          vc_sql := vc_sql || ' vc_retorno := to_char(exp_pkg_informacoes.fnc_valor(cmx_pkg_tabelas.tabela_id(''202'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id)' || ',''' || pc_mascara || '''); ';
        ELSE
          vc_sql := vc_sql || ' vc_retorno := exp_pkg_informacoes.fnc_valor(cmx_pkg_tabelas.tabela_id(''202'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id);';
        END IF;
      ELSIF ( pc_origem = 'CC' ) THEN
        vc_sql := vc_sql || ' vc_retorno := exp_pkg_informacoes.fnc_complemento_codigo(cmx_pkg_tabelas.tabela_id(''201'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id);';
      ELSIF ( pc_origem = 'CD' ) THEN
        vc_sql := vc_sql || ' vc_retorno := exp_pkg_informacoes.fnc_complemento_descricao(cmx_pkg_tabelas.tabela_id(''201'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id);';
      ELSIF ( pc_origem = 'EC' ) THEN
        vc_sql := vc_sql || ' vc_retorno := exp_pkg_informacoes.fnc_entidade_codigo(cmx_pkg_tabelas.tabela_id(''918'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id);';
      ELSIF ( pc_origem = 'ED' ) THEN
        vc_sql := vc_sql || ' vc_retorno := exp_pkg_informacoes.fnc_entidade_descricao(cmx_pkg_tabelas.tabela_id(''918'',''' || pc_valor || '''), vn_embarque_id, vn_fatura_id, vn_fatura_item_id, vn_fatura_item_detalhe_id);';
      END IF;

    ELSE
      RETURN pc_valor; -- se não for de nenhum tipo definido retorna o proprio valor;
    END IF;

    vc_sql := vc_sql ||
'

  :8 := vc_retorno;
  END;
';

    EXECUTE IMMEDIATE vc_sql USING pn_fatura_id
                                 , pn_fatura_item_id
                                 , pn_fatura_item_detalhe_id
                                 , pn_embarque_id
                                 , pn_fatura_nf_id
                                 , pn_due_id
                                 , pn_fatura_det_nf_id
                                 , OUT vc_retorno;



    IF pn_tamanho IS NOT NULL THEN
      IF Length(vc_retorno) > pn_tamanho THEN
        IF (Nvl(pc_corta_tamanho,'N') = 'S') THEN
          vc_retorno := SubStr(vc_retorno, 1, pn_tamanho);
        ELSE
          OPEN cur_fat;
          FETCH cur_fat INTO vc_fatura;
          CLOSE cur_fat;

          IF pn_fatura_item_id IS NOT NULL THEN
            OPEN cur_item;
            FETCH cur_item INTO vc_item;
            CLOSE cur_item;
          END IF;

          Raise_Application_Error(-20000, cmx_fnc_texto_traduzido('Identificador @@01@@ excede o tamanho configurado @@02@@. Valor atual: @@03@@. Fatura [@@04@@], item [@@05@@].', 'EXP_PKG_DUE','FNC_RET_VAL_01',null,pc_identificador, pn_tamanho, vc_retorno, vc_fatura, vc_item));
        END IF;
      END IF;
    END IF;

    RETURN vc_retorno;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END fnc_ret_val;

  FUNCTION fnc_ind_due( pc_codigo                 VARCHAR2
                      , pc_nivel                  VARCHAR2
                      , pn_fatura_id              NUMBER
                      , pn_fatura_nf_id           NUMBER DEFAULT NULL
                      , pn_fatura_item_id         NUMBER DEFAULT NULL
                      , pn_fatura_item_detalhe_id NUMBER DEFAULT NULL
                      , pn_due_id                 NUMBER DEFAULT NULL
                      , pn_fatura_det_nf_id       NUMBER DEFAULT NULL
                      ) RETURN VARCHAR2
  AS

    CURSOR cur_ind_due
        IS
    SELECT identificador_id
         , codigo
         , descricao
         , tag
         , tipo
         , cmx_pkg_tabelas.codigo(tabela_id) valor_tab
         , auxiliar
         , valor
         , mascara
         , origem
         , tamanho
         , corta_tamanho
      FROM exp_identificadores_due
     WHERE codigo = pc_codigo;

    vr_ind_due cur_ind_due%ROWTYPE;
    vb_found BOOLEAN;

  BEGIN

    OPEN cur_ind_due;
    FETCH cur_ind_due INTO vr_ind_due;
    vb_found := cur_ind_due%FOUND;
    CLOSE cur_ind_due;

    --cmx_prc_teste_Execucao('pc_codigo ' || pc_codigo,19800908);

    IF (vb_found) THEN
      IF (vr_ind_due.tipo = 'I') THEN
        RETURN fnc_ret_val( pn_fatura_id
                          , pn_fatura_item_id
                          , pn_fatura_item_detalhe_id
                          , NULL --pn_embarque_id
                          , pn_fatura_nf_id
                          , pc_nivel
                          , vr_ind_due.tipo
                          , vr_ind_due.origem
                          , vr_ind_due.valor
                          , vr_ind_due.mascara
                          , pn_due_id
                          , pn_fatura_det_nf_id
                          , vr_ind_due.tamanho
                          , vr_ind_due.corta_tamanho
                          , vr_ind_due.codigo
                          );
      ELSE
        RETURN fnc_ret_val( pn_fatura_id
                          , pn_fatura_item_id
                          , pn_fatura_item_detalhe_id
                          , NULL --pn_embarque_id
                          , pn_fatura_nf_id
                          , pc_nivel
                          , vr_ind_due.tipo
                          , vr_ind_due.origem
                          , vr_ind_due.valor
                          , vr_ind_due.mascara
                          , pn_due_id
                          , pn_fatura_det_nf_id
                          , vr_ind_due.tamanho
                          , vr_ind_due.corta_tamanho
                          , vr_ind_due.codigo
                          );
      END IF;

    ELSE

      BEGIN
      INSERT INTO exp_identificadores_due
      (
        identificador_id
      , codigo
      , descricao
      , tag
      , tipo
      , tabela_id
      , valor
      , creation_date
      , created_by
      , last_update_date
      , last_updated_by
      ) VALUES (
                 cmx_fnc_proxima_sequencia('exp_identificadores_due_sq1')
               , pc_codigo
               , pc_codigo || ' - Verificar XSD DUE'
               , NULL
               , 'F'
               , NULL
               , pc_codigo
               , SYSDATE
               , 0
               , SYSDATE
               , 0
               );
      EXCEPTION
        WHEN OTHERS THEN
          Raise_Application_Error(-20000,'Identificador ' || pc_codigo || ' não cadastrado.');
      END;
    END IF;

    RETURN NULL;
  END fnc_ind_due;

  FUNCTION fnc_criar_due( pn_due_id     NUMBER
                        , pn_evento_id  NUMBER
                        , pn_usuario_id NUMBER
                        ) RETURN NUMBER
  AS

    CURSOR cur_dados
        IS
    SELECT ef.fatura_id
         , ef.embarque_id
         , exp_pkg_due.fnc_ind_due('EX0010' ,'F', ef.fatura_id ) doffice_identification
         , NVL(exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
             , exp_pkg_due.fnc_ind_due('EX0037_CNPJ' ,'F', ef.fatura_id )) whs_identification
         , Decode( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                 , NULL
                 , '22'
                 , '281'
                 )                                               whs_type
         , exp_pkg_due.fnc_ind_due('EX0063' ,'F', ef.fatura_id ) whs_latitude
         , exp_pkg_due.fnc_ind_due('EX0064' ,'F', ef.fatura_id ) whs_longitude
         , exp_pkg_due.fnc_ind_due('EX0062' ,'F', ef.fatura_id ) whs_addr_line
         , exp_pkg_due.fnc_ind_due('EX0039' ,'F', ef.fatura_id ) currencytype
         , exp_pkg_due.fnc_ind_due('EX0011' ,'F', ef.fatura_id ) exitoffice_identification
         , exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id ) exitoffice_whs_identification
         , Decode( exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )
                 , NULL
                 , '22'
                 , '281'
                 )                                               exitoffice_whs_type
         --, exp_pkg_due.fnc_ind_due('EX0008' ,'F', ef.fatura_id ) importer_name
         , exp_pkg_due.fnc_ind_due('EX0009' ,'F', ef.fatura_id ) importer_addr_country
         --, exp_pkg_due.fnc_ind_due('EX0036' ,'F', ef.fatura_id ) importer_addr_line
         --, exp_pkg_due.fnc_ind_due('EX0002' ,'F', ef.fatura_id ) ucr
         , exp_pkg_due.fnc_ind_due('EX0040_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao
         , exp_pkg_due.fnc_ind_due('EX0041_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao_type
         , exp_pkg_due.fnc_ind_due('EX0040_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial
         , exp_pkg_due.fnc_ind_due('EX0041_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial_type
         , exp_pkg_due.fnc_ind_due('EX0040_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte
         , exp_pkg_due.fnc_ind_due('EX0041_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte_type
         , exp_pkg_due.fnc_ind_due('EX0042_OBS_GER' ,'F', ef.fatura_id, NULL, NULL, NULL, edf.due_id) observacoes_gerais
         , exp_pkg_due.fnc_ind_due('EX0041_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais_type
         , exp_pkg_due.fnc_ind_due('EX0005','F', ef.fatura_id ) exporter_name
         , exp_pkg_due.fnc_ind_due('EX0004','F', ef.fatura_id ) exporter_identification
         , exp_pkg_due.fnc_ind_due('EX0006','F', ef.fatura_id ) exporter_countrysubdivision
         , exp_pkg_due.fnc_ind_due('EX0006_LINE','F', ef.fatura_id ) exporter_country_addr_line
         , exp_pkg_due.fnc_ind_due('EX0007','F', ef.fatura_id ) exporter_countrycode
         , ef.empresa_id
         , ef.fatura_numero
         , ef.fatura_ano
      FROM exp_faturas      ef
         , exp_due_faturas  edf
     WHERE ef.fatura_id = edf.fatura_id
       AND edf.due_id   = pn_due_id
  ORDER BY ef.fatura_numero, ef.fatura_ano;

    CURSOR cur_app_info(pn_due_id NUMBER, pc_type_code VARCHAR2)
        IS
    SELECT due_add_info_id
      FROM exp_due_add_info
     WHERE due_id = pn_due_id
       AND statementtypecode = pc_type_code;

    CURSOR cur_exporter(pc_exporter_ident VARCHAR2)
        IS
    SELECT due_exporter_id
      FROM exp_due_exporter
     WHERE due_id = pn_due_id
       AND identification = pc_exporter_ident;

    CURSOR cur_fat_com_nf
        IS
    SELECT Count(*)
      FROM exp_due_faturas edf
         , exp_fatura_nf   efn
     WHERE edf.fatura_id = efn.fatura_id
       AND edf.due_id = pn_due_id;

    CURSOR cur_fat_sem_nf
        IS
    SELECT Count(*)
      FROM exp_due_faturas edf
     WHERE edf.due_id    = pn_due_id
       AND NOT EXISTS ( SELECT NULL
                          FROM exp_fatura_nf efn
                         WHERE edf.fatura_id = efn.fatura_id
                      );

    CURSOR cur_det_sem_nf
        IS
    SELECT /*+rule*/ Count(*)
      FROM exp_fatura_itens         efi
         , exp_fatura_item_detalhes det
         , exp_fatura_item_det_nf   efidn
         , exp_due_faturas          edf
     WHERE efi.fatura_item_id         = det.fatura_item_id
       AND det.fatura_item_detalhe_id = efidn.fatura_item_detalhe_id(+)
       AND efi.fatura_id              = edf.fatura_id
       AND edf.due_id                 = pn_due_id
       AND Nvl(det.nf_numero, efidn.numero_nf) IS NULL;

    CURSOR cur_det_sem_nf_ato
        IS
     SELECT Count(*)
       FROM exp_fatura_itens             efi
          , exp_fatura_item_atos         efia
          , exp_fatura_item_detalhe_atos ato
          , exp_fatura_item_det_nf       efidn
          , exp_due_faturas              edf
      WHERE efi.fatura_item_id         = efia.fatura_item_id
        AND efia.fatura_item_ato_id    = ato.fatura_item_ato_id
        AND ato.fatura_item_detalhe_id = efidn.fatura_item_detalhe_id(+)
        AND ato.fatura_item_detalhe_ato_id  = efidn.fatura_item_detalhe_ato_id(+)
        AND efi.fatura_id              = edf.fatura_id(+)
        AND edf.due_id                 = pn_due_id
        AND efidn.numero_nf IS NULL;

    --vr_dados cur_dados%ROWTYPE;
    vb_found        BOOLEAN;
    vn_due_id       NUMBER;
    vb_erro         BOOLEAN := FALSE;
    vc_ucr          VARCHAR2(35);
    vn_itens_due    NUMBER := 0 ;

    vb_achou        BOOLEAN := FALSE;
    vn_add_info_id  NUMBER;
    vn_exporter_id  NUMBER;

    vn_count_com_nf NUMBER := 0;
    vn_count_sem_nf NUMBER := 0;
  BEGIN
    vn_due_id := pn_due_id;
    vc_ucr    := NULL;

    /* Verifica se possui Nota fiscal vinculado aos processos de Notas fiscal do detalhe do item */
    OPEN  cur_fat_com_nf;
    FETCH cur_fat_com_nf INTO vn_count_com_nf;
    CLOSE cur_fat_com_nf;

    OPEN  cur_fat_sem_nf;
    FETCH cur_fat_sem_nf INTO vn_count_sem_nf;
    CLOSE cur_fat_sem_nf;

    IF(vn_count_com_nf > 0 AND vn_count_sem_nf > 0) THEN
      Raise_Application_Error(-20000, 'Não foi possível gerar a DUE, pois existem faturas com notas fiscais e faturas sem notas fiscais vinculadas.');
    ELSIF(vn_count_com_nf > 0 AND vn_count_sem_nf = 0) THEN

      vn_count_sem_nf := 0;
      --vn_count_com_nf := 0;

      OPEN  cur_det_sem_nf;
      FETCH cur_det_sem_nf INTO vn_count_sem_nf;
      CLOSE cur_det_sem_nf;

      IF(Nvl(vn_count_sem_nf,0) = 0) THEN
        OPEN  cur_det_sem_nf_ato;
        FETCH cur_det_sem_nf_ato INTO vn_count_sem_nf;
        CLOSE cur_det_sem_nf_ato;
      END IF;

      IF(vn_count_com_nf > 0 AND vn_count_sem_nf > 0) THEN
        Raise_Application_Error(-20000, 'Existe nota fiscal para as faturas, porém há detalhes sem nota fiscal. Não é possível gerar a DU-E).');
      END IF;
    END IF;

    DELETE FROM exp_due_ship      WHERE due_id = pn_due_id;
    DELETE FROM exp_due_exporter  WHERE due_id = vn_due_id;
    DELETE FROM exp_due_add_info  WHERE due_id = vn_due_id;

    FOR vr_dados IN cur_dados
    LOOP
      exp_prc_criar_due_hook1(pn_evento_id, vr_dados.fatura_id);

--      IF vc_ucr IS NULL THEN
--        IF vr_dados.ucr IS NULL THEN
--          vc_ucr := To_Char(SYSDATE, 'Y') || 'BR' || SubStr(LPad(cmx_pkg_empresas.cnpj(vr_dados.empresa_id),14,'0'),1,8) || SubStr(To_Char(SYSDATE, 'YY'),1,1) || SubStr(LPad(cmx_pkg_empresas.cnpj(vr_dados.empresa_id),14,'0'),9,6) ||  'D' || LPad(vn_due_id,16,'0');
--        ELSE
--          vc_ucr := To_Char(SYSDATE, 'Y') || 'BR' || SubStr(LPad(cmx_pkg_empresas.cnpj(vr_dados.empresa_id),14,'0'),1,8) || SubStr(To_Char(SYSDATE, 'YY'),1,1) || vr_dados.ucr;
--        END IF;
--      END IF;

        UPDATE exp_due
          SET
              embarque_id                    = vr_dados.embarque_id
            , doffice_identification         = vr_dados.doffice_identification
            , whs_identification             = vr_dados.whs_identification
            , whs_type                       = vr_dados.whs_type
            , whs_latitude                   = vr_dados.whs_latitude
            , whs_longitude                  = vr_dados.whs_longitude
            , whs_addr_line                  = vr_dados.whs_addr_line
            , currencytype                   = vr_dados.currencytype
            --, declarant_identification       = vr_dados.declarant_identification
            , exitoffice_identification      = vr_dados.exitoffice_identification
            , exitoffice_whs_identification  = vr_dados.exitoffice_whs_identification
            , exitoffice_whs_type            = vr_dados.exitoffice_whs_type
            --, importer_name                  = SubStr(vr_dados.importer_name, 1, 70)
            , importer_addr_country          = vr_dados.importer_addr_country
            --, importer_addr_line             = vr_dados.importer_addr_line
            --, ucr                            = vc_ucr
            , last_update_date               = SYSDATE
            , last_updated_by                = pn_usuario_id
        WHERE due_id = vn_due_id;

        -- prc_atual_compl( vn_due_id
        --                , 'DUE_RUC'
        --                , vc_ucr
        --                , pn_usuario_id
        --                );

        --DELETE exp_due_add_info
        --WHERE due_id = vn_due_id;

        IF vr_dados.forma_exportacao IS NOT NULL THEN

          vb_achou := FALSE;
          OPEN cur_app_info(pn_due_id, vr_dados.forma_exportacao_type);
          FETCH cur_app_info INTO vn_add_info_id;
          vb_achou := cur_app_info%FOUND;
          CLOSE cur_app_info;

          IF NOT(vb_achou) THEN
            INSERT INTO exp_due_add_info
            (
              due_id
            , due_add_info_id
            , statementcode
            , statementdescription
            , limitdatetime
            , statementtypecode
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      vn_due_id
                    , cmx_fnc_proxima_sequencia('exp_due_add_info_sq1')
                    , vr_dados.forma_exportacao
                    , NULL --statementdescription
                    , NULL --limitdatetime
                    , vr_dados.forma_exportacao_type --statementtypecode
                    , SYSDATE --creation_date
                    , pn_usuario_id --created_by
                    , SYSDATE -- last_update_date,
                    , pn_usuario_id --last_updated_by
                    );
          END IF;
        ELSE
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ sem forma de exportação preenchida.', 'EXP_PKG_DUE','FNC_GERAR_DUE_048',null,vr_dados.fatura_numero || '/' || vr_dados.fatura_ano),'E');
        END IF;

        IF vr_dados.situacao_especial IS NOT NULL THEN

          vb_achou := FALSE;
          OPEN cur_app_info(pn_due_id, vr_dados.situacao_especial_type);
          FETCH cur_app_info INTO vn_add_info_id;
          vb_achou := cur_app_info%FOUND;
          CLOSE cur_app_info;

          IF NOT(vb_achou) THEN
            INSERT INTO exp_due_add_info
            (
              due_id
            , due_add_info_id
            , statementcode
            , statementdescription
            , limitdatetime
            , statementtypecode
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      vn_due_id
                    , cmx_fnc_proxima_sequencia('exp_due_add_info_sq1')
                    , vr_dados.situacao_especial
                    , NULL --statementdescription
                    , NULL --limitdatetime
                    , vr_dados.situacao_especial_type --statementtypecode
                    , SYSDATE --creation_date
                    , pn_usuario_id --created_by
                    , SYSDATE -- last_update_date,
                    , pn_usuario_id --last_updated_by
                    );
          END IF;
        END IF;

        IF vr_dados.caso_esp_transporte IS NOT NULL THEN

          vb_achou := FALSE;
          OPEN cur_app_info(pn_due_id, vr_dados.caso_esp_transporte_type);
          FETCH cur_app_info INTO vn_add_info_id;
          vb_achou := cur_app_info%FOUND;
          CLOSE cur_app_info;

          IF NOT(vb_achou) THEN
            INSERT INTO exp_due_add_info
            (
              due_id
            , due_add_info_id
            , statementcode
            , statementdescription
            , limitdatetime
            , statementtypecode
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      vn_due_id
                    , cmx_fnc_proxima_sequencia('exp_due_add_info_sq1')
                    , vr_dados.caso_esp_transporte
                    , NULL --statementdescription
                    , NULL --limitdatetime
                    , vr_dados.caso_esp_transporte_type --statementtypecode
                    , SYSDATE --creation_date
                    , pn_usuario_id --created_by
                    , SYSDATE -- last_update_date,
                    , pn_usuario_id --last_updated_by
                    );
          END IF;
        END IF;

        IF vr_dados.observacoes_gerais IS NOT NULL THEN
          vb_achou := FALSE;
          OPEN cur_app_info(pn_due_id, vr_dados.observacoes_gerais_type);
          FETCH cur_app_info INTO vn_add_info_id;
          vb_achou := cur_app_info%FOUND;
          CLOSE cur_app_info;

          IF NOT(vb_achou) THEN
            INSERT INTO exp_due_add_info
            (
              due_id
            , due_add_info_id
            , statementcode
            , statementdescription
            , limitdatetime
            , statementtypecode
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      vn_due_id
                    , cmx_fnc_proxima_sequencia('exp_due_add_info_sq1')
                    , NULL
                    , SubStr(vr_dados.observacoes_gerais,1, 4000) --statementdescription
                    , NULL --limitdatetime
                    , vr_dados.observacoes_gerais_type --statementtypecode
                    , SYSDATE --creation_date
                    , pn_usuario_id --created_by
                    , SYSDATE -- last_update_date,
                    , pn_usuario_id --last_updated_by
                    );
          END IF;
        END IF;

        IF ( vr_dados.exporter_identification IS NOT NULL ) THEN
          vb_achou := FALSE;
          OPEN  cur_exporter(vr_dados.exporter_identification);
          FETCH cur_exporter INTO vn_exporter_id;
          vb_achou := cur_exporter%FOUND;
          CLOSE cur_exporter;

          IF NOT(vb_achou) THEN
            INSERT INTO exp_due_exporter
            (
              due_id
            , due_exporter_id
            , name
            , identification
            , countrycode
            , countrysubdivisioncode
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            , addr_line
            ) VALUES (
                      vn_due_id
                    , cmx_fnc_proxima_sequencia('exp_due_exporter_sq1')
                    , vr_dados.exporter_name
                    , vr_dados.exporter_identification
                    , vr_dados.exporter_countrycode
                    , vr_dados.exporter_countrysubdivision
                    , SYSDATE --creation_date
                    , pn_usuario_id --created_by
                    , SYSDATE -- last_update_date,
                    , pn_usuario_id --last_updated_by
                    , vr_dados.exporter_country_addr_line
                    );
          END IF;
        END IF;

        IF fnc_good_ship(  vn_due_id, vr_dados.fatura_id, pn_evento_id, pn_usuario_id, vn_itens_due ) > 0 THEN
          RETURN NULL;
        END IF;
    END LOOP;

    RETURN vn_due_id;
  END fnc_criar_due;

  FUNCTION fnc_good_ship(  pn_due_id     NUMBER
                         , pn_fatura_id  NUMBER
                         , pn_evento_id  NUMBER
                         , pn_usuario_id NUMBER
                         , pn_itens_due  IN OUT NUMBER
                         ) RETURN NUMBER
  AS
    CURSOR cur_nf
        IS
    SELECT enf.chave_nf
         , enf.numero  numero_nf
         , enf.serie
         , enf.data nf_issue
         , enf.fatura_nf_id
         , exp_pkg_due.fnc_ind_due('EX0043_NF_ELETR' ,'N', enf.fatura_id, enf.fatura_nf_id ) nfe_id
         , exp_pkg_due.fnc_ind_due('EX0069_NF_ELETR' ,'N', enf.fatura_id, enf.fatura_nf_id ) nfe_type
         , exp_pkg_due.fnc_ind_due('EX0043_NF_FORM' ,'N', enf.fatura_id, enf.fatura_nf_id )  nff_id
         , exp_pkg_due.fnc_ind_due('EX0069_NF_FORM' ,'N', enf.fatura_id, enf.fatura_nf_id )  nff_type
         , exp_pkg_due.fnc_ind_due('EX0046_NF_FORM' ,'F', enf.fatura_id, enf.fatura_nf_id )  nff_cnpj
       --  , exp_pkg_due.fnc_ind_due('EX0047_NF_FORM' ,'F', enf.fatura_id, enf.fatura_nf_id )  nff_uf
           , NULL nff_uf
       --  , exp_pkg_due.fnc_ind_due('EX0045' ,'N', enf.fatura_id, enf.fatura_nf_id )  nf_issue
         , exp_pkg_due.fnc_ind_due('EX0016' ,'F', enf.fatura_id ) condition
      FROM exp_fatura_nf          enf
         , exp_due_fatura_nf_tmp  edfn
     WHERE enf.fatura_nf_id =  edfn.fatura_nf_id
       AND enf.fatura_id    = pn_fatura_id;

    CURSOR cur_sem_nf(pc_motiv VARCHAR2)
        IS
    SELECT efi.fatura_id
         , exp_pkg_due.fnc_ind_due('EX0069_SEM_NF' ,'F', efi.fatura_id  )  semnf_type
         , exp_pkg_due.fnc_ind_due('EX0067' ,'F', efi.fatura_id ) motivoDispensaNF
         , exp_pkg_due.fnc_ind_due('EX0068' ,'F', efi.fatura_id ) motivoDispensaNFType
         , exp_pkg_due.fnc_ind_due('EX0016' ,'F', efi.fatura_id ) condition
      FROM exp_fatura_itens efi
         , exp_fatura_item_detalhes efid
     WHERE efi.fatura_item_id = efid.fatura_item_id
       AND (efid.nf_numero IS NULL OR pc_motiv IS NOT NULL)
       AND efi.fatura_id = pn_fatura_id
--       AND exp_pkg_due.fnc_ind_due('EX0067' ,'F', efi.fatura_id ) IS NOT NULL
    GROUP BY efi.fatura_id;

    CURSOR cur_motiv
        IS
    SELECT exp_pkg_due.fnc_ind_due('EX0067' ,'F', efi.fatura_id ) motivoDispensaNF
      FROM exp_faturas efi
     WHERE exp_pkg_due.fnc_ind_due('EX0067' ,'F', efi.fatura_id ) IS NOT NULL
       AND efi.fatura_id = pn_fatura_id;

  CURSOR cur_nf_r( pn_fatura_nf_id NUMBER)
        IS
    SELECT DISTINCT --exp_pkg_due.fnc_ind_due('EX0061' ,'D', pn_fatura_id, efn.fatura_nf_id, efid.fatura_item_id, efid.fatura_item_detalhe_id) sequencenumeric
         --, exp_pkg_due.fnc_ind_due('EX0048' ,'D', pn_fatura_id, efn.fatura_nf_id, efid.fatura_item_id, efid.fatura_item_detalhe_id) Identification
         --, exp_pkg_due.fnc_ind_due('EX0058' ,'D', pn_fatura_id, efn.fatura_nf_id, efid.fatura_item_id, efid.fatura_item_detalhe_id) issuedatetime
          efnr.chave_nf Identification
         , efnr.data issuedatetime
         , SubStr(efnr.chave_nf, 7, 14) ivc_sbmttr_identif
         --, exp_pkg_due.fnc_ind_due('EX0059' ,'F', pn_fatura_id, efn.fatura_nf_id, efid.fatura_item_id, efid.fatura_item_detalhe_id) ivc_sbmttr_identif
         --, exp_pkg_due.fnc_ind_due('EX0060' ,'F', pn_fatura_id, efn.fatura_nf_id, efid.fatura_item_id, efid.fatura_item_detalhe_id) ivc_sbmttr_addr_ctrysuddiv
     --    , efidn.item sequencenumeric
         , efnr.fatura_nf_rem_id
         , efnr.tipo_nfe                typecode
      FROM exp_fatura_nf            efn
         , exp_fatura_nf_rem        efnr
         , exp_fatura_item_detalhes_nfr  efidn
     WHERE efn.fatura_nf_id      = efnr.fatura_nf_id
       AND efnr.fatura_nf_rem_id = efidn.fatura_nf_rem_id
       AND efn.fatura_id       = pn_fatura_id
       AND efn.fatura_nf_id    = pn_fatura_nf_id
    ORDER BY efnr.chave_nf, efnr.data, efnr.fatura_nf_rem_id;

    CURSOR cur_ship_nf(pc_nff_id VARCHAR2, pc_nfe_id VARCHAR2)
        IS
    SELECT eds.due_ship_id
      FROM exp_due_ship eds
     WHERE eds.due_id  = pn_due_id
       AND eds.ivc_identification = Decode(pc_nfe_id, NULL, pc_nff_id, pc_nfe_id );

    CURSOR cur_ship_nnf(pc_motiv VARCHAR2)
        IS
    SELECT eds.due_ship_id
      FROM exp_vw_due_ship eds
     WHERE due_id     = pn_due_id
       AND eds.ivc_addit_statement = pc_motiv;

/*
    CURSOR cur_tem_nf(pn_fatura_id NUMBER) IS
      SELECT enf.fatura_id
        FROM exp_fatura_nf enf
       WHERE enf.fatura_id = pn_fatura_id;

    CURSOR cur_ver_sem_nf(pn_fatura_id NUMBER) IS
      SELECT NULL
        FROM exp_vw_fatura_item_det_nf_ato
       WHERE fatura_id = pn_fatura_id
         AND numero_nf IS NULL;
*/

    vn_due_ship_id NUMBER;
    vc_com_nf      VARCHAR2(1) := 'N';
    vn_seq         NUMBER;
    vc_motiv       VARCHAR2(150);
    vb_found       BOOLEAN;
    vb_nf          BOOLEAN := FALSE;
    vn_temp        NUMBER;
    vn_qtd_nf_ato  NUMBER;
  BEGIN

    OPEN cur_motiv;
    FETCH cur_motiv INTO vc_motiv;
    vb_found     := cur_motiv%FOUND;
    CLOSE cur_motiv;

    -- se encotrar motivo para enviar sem nota, então não passa no cursor de nota fiscal.
    IF NOT vb_found THEN

      --pn_itens_due := 0;
      FOR x IN cur_nf
      LOOP

        vc_com_nf := 'S';
        vb_found  := FALSE;
        --OPEN cur_ship_nf(x.nff_id, x.nfe_id);
        --FETCH cur_ship_nf INTO vn_due_ship_id;
        --vb_found  := cur_ship_nf%FOUND;
        --CLOSE cur_ship_nf;

        IF NOT vb_found THEN

          vn_due_ship_id := cmx_fnc_proxima_sequencia('exp_due_ship_sq1');

          INSERT INTO exp_due_ship
          (
            due_id
          , due_ship_id
          , ivc_identification
          , ivc_issue
          , ivc_type
          , ivc_sbmttr_identif
          , ivc_sbmttr_addr_ctrysuddiv
          , ivc_addit_statement
          , ivc_addit_statementtype
          , ivc_tradeterms_condition
          , fatura_nf_id
          , numero_nf
          , serie
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          , fatura_id
          ) VALUES (
                      pn_due_id
                    , vn_due_ship_id
                    , Decode(x.nfe_id, NULL, x.nff_id, x.nfe_id )
                    , x.nf_issue
                    --, Decode(x.nfe_id, NULL, x.nff_type, x.nff_type )
                    --, Decode(x.nfe_id, NULL, x.nff_cnpj, NULL )
                    --, Decode(x.nfe_id, NULL, x.nff_uf, NULL )
                    , x.nff_type
                    , x.nff_cnpj
                    , x.nff_uf
                    , NULL
                    , NULL
                    , x.condition
                    , x.fatura_nf_id
                    , x.numero_nf
                    , x.serie
                    , SYSDATE
                    , pn_usuario_id
                    , SYSDATE
                    , pn_usuario_id
                    , pn_fatura_id
                    );
        END IF;

        vn_seq := 1;
        FOR nf_r IN cur_nf_r(x.fatura_nf_id)
        LOOP
        --cmx_prc_teste_Execucao('nf_r.identification ' || nf_r.identification,19800908);
          IF (nf_r.identification IS NOT NULL) THEN
            INSERT INTO exp_due_si_ref_ivc
            (
              due_si_ref_ivc_id
            , due_ship_id
            , identification
            , issuedatetime
            , sequencenumeric
            , ivc_sbmttr_identif
            , ivc_sbmttr_addr_ctrysuddiv
            , typecode
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            , fatura_nf_id
            , fatura_nf_rem_id
            ) VALUES (
                        cmx_fnc_proxima_sequencia('exp_due_si_ref_ivc_sq1')
                      , vn_due_ship_id
                      , nf_r.identification
                      , nf_r.issuedatetime
                      --, nf_r.sequencenumeric
                      , vn_seq
                      , nf_r.ivc_sbmttr_identif
                      , NULL --nf_r.ivc_sbmttr_addr_ctrysuddiv
                      , nf_r.typecode
                      , SYSDATE
                      , pn_usuario_id
                      , SYSDATE
                      , pn_usuario_id
                      , x.fatura_nf_id
                      , nf_r.fatura_nf_rem_id
                      );
              vn_seq := vn_seq + 1;

          END IF;

        END LOOP;

        prc_gs_i_nf(pn_due_id, vn_due_ship_id,  x.fatura_nf_id, pn_usuario_id, pn_evento_id, pn_itens_due, pn_fatura_id);

      END LOOP;

    END IF;

    IF (Nvl(vc_com_nf,'N') = 'N') THEN
      FOR x IN cur_sem_nf(vc_motiv)
      LOOP

        --IF (vc_com_nf = 'S') THEN
        --  Raise_Application_Error(-20000, 'Existe nota fiscal para a fatura, porém há detalhes sem nota fiscal. Não é possível gerar a DU-E).');
        --END IF;

        vb_found := FALSE;
        --OPEN cur_ship_nnf(vc_motiv);
        --FETCH cur_ship_nnf INTO vn_due_ship_id;
        --vb_found  := cur_ship_nnf%FOUND;
        --CLOSE cur_ship_nnf;

        IF NOT vb_found THEN

          vn_due_ship_id := cmx_fnc_proxima_sequencia('exp_due_ship_sq1');

          INSERT INTO exp_due_ship
          (
            due_id
          , due_ship_id
          , ivc_identification
          , ivc_issue
          , ivc_type
          , ivc_sbmttr_identif
          , ivc_sbmttr_addr_ctrysuddiv
          , ivc_addit_statement
          , ivc_addit_statementtype
          , ivc_tradeterms_condition
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          , fatura_id
          ) VALUES (
                    pn_due_id
                  , vn_due_ship_id
                  , null
                  , null
                  , x.semnf_type
                  , NULL
                  , NULL
                  , NULL
                  , NULL
                  , x.condition
                  , SYSDATE
                  , pn_usuario_id
                  , SYSDATE
                  , pn_usuario_id
                  , pn_fatura_id
                  );

          IF (x.motivoDispensaNF IS NOT NULL) THEN
            INSERT INTO exp_due_gs_add_info
            (
              due_gs_add_info_id
            , due_ship_id
            , statementcode
            , statementdescription
            , limitdatetime
            , statementtypecode
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      cmx_fnc_proxima_sequencia('exp_due_gs_add_info_sq1')
                    , vn_due_ship_id
                    , x.motivodispensanf
                    , NULL
                    , NULL
                    , x.motivodispensanftype
                    , SYSDATE
                    , pn_usuario_id
                    , SYSDATE
                    , pn_usuario_id
                    );
          END IF;

        END IF;
        prc_gs_i_snf(pn_due_id, vn_due_ship_id, pn_fatura_id, pn_usuario_id, pn_itens_due);

      END LOOP;
    END IF;

    UPDATE exp_due
       SET com_nf = vc_com_nf
     WHERE due_id = pn_due_id;

    RETURN NULL;
  END fnc_good_ship;

  PROCEDURE prc_gs_i_nf( pn_due_id       NUMBER
                       , pn_due_ship_id  NUMBER
                       , pn_fatura_nf_id NUMBER
                       , pn_usuario_id   NUMBER
                       , pn_evento_id    NUMBER
                       , pn_itens_due    IN OUT NUMBER
                       , pn_fatura_id    NUMBER
                       )
  AS
    CURSOR cur_i_nf
        IS
    SELECT fatura_id
         , fatura_item_id
         , numero_nf        nf_numero
         , serie_nf         nf_serie
         , nf_nr_linha      nf_nr_linha
         , exp_pkg_due.fnc_ind_due('EX0019'       ,'L', fatura_id, fatura_nf_id, fatura_item_id, fatura_item_detalhe_id)    descricao
         , exp_pkg_due.fnc_ind_due('EX0049'       ,'L', fatura_id, fatura_nf_id, fatura_item_id)                            pais_destino
         , exp_pkg_due.fnc_ind_due('EX0032_ENQ_1' ,'L', fatura_id, fatura_nf_id, fatura_item_id, fatura_item_detalhe_id)    enquadramento_1
         , exp_pkg_due.fnc_ind_due('EX0032_ENQ_2' ,'L', fatura_id, fatura_nf_id, fatura_item_id, fatura_item_detalhe_id)    enquadramento_2
         , exp_pkg_due.fnc_ind_due('EX0032_ENQ_3' ,'L', fatura_id, fatura_nf_id, fatura_item_id, fatura_item_detalhe_id)    enquadramento_3
         , exp_pkg_due.fnc_ind_due('EX0032_ENQ_4' ,'L', fatura_id, fatura_nf_id, fatura_item_id, fatura_item_detalhe_id)    enquadramento_4
         , exp_pkg_due.fnc_ind_due('EX0027_PRIO_CARGA' ,'L', fatura_id, fatura_nf_id, fatura_item_id)                       prio_carga_type
         , exp_pkg_due.fnc_ind_due('EX0027_PRAZO_TEMP' ,'L', fatura_id, fatura_nf_id, fatura_item_id)                       prazo_exp_tmp_type
         , exp_pkg_due.fnc_ind_due('EX0035' ,'L', fatura_id, fatura_nf_id, fatura_item_id)                                  prio_carga
         , exp_pkg_due.fnc_ind_due('EX0028_TEMP' ,'L', fatura_id, fatura_nf_id, fatura_item_id)                             doc_exp_temp
         , exp_pkg_due.fnc_ind_due('EX0026' ,'L', fatura_id, fatura_nf_id, fatura_item_id)                                  prazo_exp_tmp
         , exp_pkg_due.fnc_ind_due('EX0034' ,'L', fatura_id, NULL, fatura_item_id)                                          destaque_ncm
         , ncm_codigo
         , ncm
         , Sum(valor_fob)           valor_fob
         , Sum(valor_vcv_mn)        valor_vcv_mn
         , Sum(valor_financiamento) valor_financiamento
         , Sum(peso_liquido)        peso_liquido
         , Sum(qtde_un_est)         qtde_un_est
         , Sum(quantidade_nf)       quantidade_nf
         , Sum(qtde_comercial)      qtde_comercial
         , fatura_item_ato_id
         , fatura_det_nf_id
         , fatura_item_detalhe_id
         , fatura_item_detalhe_ato_id
         , nf_nr_linha_due
      FROM (
            SELECT efi.fatura_id
                 , efi.fatura_item_id
                 , efi.numero_nf
                 , efi.serie_nf
                 , efi.nf_nr_linha
                 , efi.ncm                                                                                                                      ncm_codigo
                 , exp_pkg_due.fnc_ind_due('EX0021' ,'L', efi.fatura_id, NULL, efi.fatura_item_id)                                              ncm
                 , exp_pkg_due.fnc_ind_due('EX0030' ,'D', efi.fatura_id, efi.fatura_nf_id, efi.fatura_item_id, efi.fatura_item_detalhe_id)      valor_fob
                 , exp_pkg_due.fnc_ind_due('EX0031' ,'D', efi.fatura_id, efi.fatura_nf_id, efi.fatura_item_id, efi.fatura_item_detalhe_id)      valor_vcv_mn
                 , exp_pkg_due.fnc_ind_due('EX0090' ,'D', efi.fatura_id, efi.fatura_nf_id, efi.fatura_item_id, efi.fatura_item_detalhe_id)      valor_financiamento
                 , exp_pkg_due.fnc_ind_due('EX0025' ,'D', efi.fatura_id, efi.fatura_nf_id, efi.fatura_item_id, efi.fatura_item_detalhe_id)      peso_liquido
                 --, efi.peso_liquido                                                                                                             peso_liquido
                 , exp_pkg_due.fnc_ind_due('EX0050' ,'D', efi.fatura_id, efi.fatura_nf_id, efi.fatura_item_id, efi.fatura_item_detalhe_id)      qtde_un_est
                 , efi.quantidade                                                                                                               quantidade_nf
                 , exp_pkg_due.fnc_ind_due('EX0029_COM' ,'D', efi.fatura_id, efi.fatura_nf_id, efi.fatura_item_id, efi.fatura_item_detalhe_id)  qtde_comercial
                 , efi.fatura_item_ato_id
                 , efi.fatura_det_nf_id
                 , efi.fatura_item_detalhe_id
                 , efi.fatura_item_detalhe_ato_id
                 , Nvl(exp_pkg_due.fnc_ind_due( 'EX0051'
                                              , 'DNF'
                                              , efi.fatura_id
                                              , efi.fatura_nf_id
                                              , efi.fatura_item_id
                                              , efi.fatura_item_detalhe_id
                                              , pn_due_id
                                              , efi.fatura_det_nf_id
                                              )
                      , efi.nf_nr_linha)                                                                                                        nf_nr_linha_due
                 , efi.fatura_nf_id
              FROM exp_vw_fatura_item_det_nf_ato  efi
             WHERE efi.fatura_id       = pn_fatura_id
               AND efi.fatura_nf_id    = pn_fatura_nf_id
           ) tbl
  GROUP BY fatura_id
         , fatura_item_id
         , numero_nf
         , serie_nf
         , nf_nr_linha
         , ncm_codigo
         , ncm
         , fatura_item_ato_id
         , fatura_det_nf_id
         , fatura_item_detalhe_id
         , fatura_item_detalhe_ato_id
         , nf_nr_linha_due
         , fatura_nf_id
  ORDER BY numero_nf, serie_nf, nf_nr_linha;

/*
    CURSOR cur_nf_r( pc_nf_numero   VARCHAR2
                   , pc_nf_serie    VARCHAR2
                   , pn_nf_nr_linha NUMBER
                   , pn_fatura_id   NUMBER
                   )
        IS
    SELECT DISTINCT efidn.item sequencenumeric
         , ediri.sequencenumeric invoiceIdentificationid
         , efidn.qtde gm_tariffquantity
         , ediri.due_si_ref_ivc_id
      FROM exp_fatura_itens              efi
         , exp_vw_fatura_item_detalhes   efid
         , exp_fatura_item_detalhes_nfr  efidn
         , exp_fatura_nf_rem             efnr
         , exp_due_si_ref_ivc            ediri
     WHERE efid.fatura_item_id = efi.fatura_item_id
       AND efid.fatura_item_detalhe_id  = efidn.fatura_item_detalhe_id
       AND efidn.fatura_nf_rem_id       = efnr.fatura_nf_rem_id
       AND ediri.fatura_nf_rem_id       = efnr.fatura_nf_rem_id
       AND efi.fatura_id                = pn_fatura_id
       AND Nvl(efid.nf_numero,' ')      = Nvl(pc_nf_numero, ' ')
       AND Nvl(efid.nf_serie,' ')       = Nvl(pc_nf_serie, ' ')
       AND Nvl(efid.nf_nr_linha,-1)     = Nvl(pn_nf_nr_linha, -1); */

    CURSOR cur_nf_det_rem(pn_fat_det_nf_id NUMBER)
        IS
    SELECT DISTINCT efidn.item sequencenumeric
         , ediri.sequencenumeric invoiceIdentificationid
         , efidn.qtde gm_tariffquantity
         , ediri.due_si_ref_ivc_id
      FROM exp_fatura_item_detalhes_nfr efidn
         , exp_fatura_nf_rem            efnr
         , exp_due_si_ref_ivc           ediri
     WHERE efidn.fatura_nf_rem_id = efnr.fatura_nf_rem_id
       AND efnr.fatura_nf_rem_id  = ediri.fatura_nf_rem_id
       AND efidn.fatura_det_nf_id = pn_fat_det_nf_id;

    CURSOR cur_atrib(pc_ncm VARCHAR2, pc_destaque VARCHAR2)
        IS
    SELECT etna.codigo
      FROM cmx_tab_ncm_atributos  etna
         , cmx_tab_ncm_atr_compl  etnac
     WHERE etna.ncm_atributo_id = etnac.ncm_atributo_id
       AND etnac.tipo   = 'DO'
       AND etna.ncm     = pc_ncm
       AND etnac.codigo = pc_destaque;

    CURSOR cur_atos(pn_fat_item_det_ato_id NUMBER)
        IS
    SELECT efia.numero
         , efia.nr_item_drawback
         , Sum(Nvl(nullif(efidna.qtde_estatistica,0), efida.quantidade_drw))  quantidade
         , Sum(efida.valor18b)        valor
         , efia.ncm
         , efia.cnpj
      FROM exp_vw_fatura_item_atos        efia
         , exp_fatura_item_detalhe_atos   efida
         , exp_vw_fatura_item_det_nf_ato  efidna
     WHERE efia.fatura_item_ato_id          = efida.fatura_item_ato_id
       AND efida.fatura_item_detalhe_ato_id = efidna.fatura_item_detalhe_ato_id
       AND efida.fatura_item_detalhe_ato_id = pn_fat_item_det_ato_id
       AND efia.numero IS NOT NULL
  GROUP BY efia.numero
         , efia.nr_item_drawback
         , efia.ncm
         , efia.cnpj
         , efida.fatura_item_ato_id;

    CURSOR cur_adoc_di(pn_fatura_item_id NUMBER)
        IS
    SELECT efid.nr_declaracao
         , ida.adicao_num
         , efid.dsi
         , ida.declaracao_adi_id
      FROM exp_vw_fatura_item_decs efid
         , imp_declaracoes_lin     idl
         , imp_declaracoes_adi     ida
     WHERE efid.fatura_item_id = pn_fatura_item_id
       AND idl.declaracao_lin_id  = efid.declaracao_lin_id
       AND idl.declaracao_adi_id  = ida.declaracao_adi_id
       AND efid.nr_declaracao IS NOT NULL
     UNION
    SELECT efiea.nr_declaracao
         , ida.adicao_num
         , idc.dsi
         , ida.declaracao_adi_id
      FROM exp_vw_fatura_item_entr_adua efiea
         , imp_declaracoes_lin     idl
         , imp_declaracoes_adi     ida
         , imp_declaracoes         idc
     WHERE efiea.fatura_item_id = pn_fatura_item_id
       AND idl.declaracao_lin_id  = efiea.declaracao_lin_id
       AND idl.declaracao_adi_id  = ida.declaracao_adi_id
       AND idl.declaracao_id      = idc.declaracao_id
       AND efiea.nr_declaracao IS NOT NULL
     UNION
    SELECT DISTINCT id.nr_declaracao
         , ida.adicao_num
         , id.dsi
         , ida.declaracao_adi_id
      FROM exp_vw_fatura_item_tr_garantia efitg
         , imp_declaracoes_lin            idl
         , imp_declaracoes                id
         , imp_declaracoes_adi     ida
     WHERE efitg.declaracao_lin_id = idl.declaracao_lin_id
       AND idl.declaracao_id       = id.declaracao_id
       AND idl.declaracao_adi_id  = ida.declaracao_adi_id
       AND id.nr_declaracao IS NOT NULL
       AND efitg.fatura_item_id    = pn_fatura_item_id
   /*UNION
  SELECT DISTINCT id.nr_declaracao
    FROM exp_vw_fat_item_embalagem_ret efitg
       , imp_declaracoes_lin            idl
       , imp_declaracoes                id
   WHERE efitg.invoice_lin_id = idl.invoice_lin_id
     AND idl.declaracao_id       = id.declaracao_id
     AND id.nr_declaracao IS NOT NULL
     AND efitg.fatura_item_id    = pn_fatura_item_id*/;


  CURSOR cur_proc_adm(pn_declaracao_adi_id NUMBER)
  IS
  SELECT rcr.processo_numero
    FROM imp_adm_temp_rcr_lin rcr_lin
       , imp_adm_temp_rcr     rcr
       , imp_declaracoes_lin  idl
   WHERE rcr_lin.invoice_lin_id  = idl.invoice_lin_id
     AND rcr_lin.rcr_id          = rcr.rcr_id
     AND rcr.processo_numero    IS NOT NULL
     AND idl.declaracao_adi_id  = pn_declaracao_adi_id
  UNION
 SELECT rat.processo_numero
   FROM imp_adm_temp_rat_lin rat_lin
      , imp_adm_temp_rat     rat
      , imp_declaracoes_lin  idl
  WHERE rat_lin.invoice_lin_id  = idl.invoice_lin_id
    AND rat_lin.rat_id          = rat.rat_id
    AND rat.processo_numero IS NOT NULL
    AND idl.declaracao_adi_id  = pn_declaracao_adi_id;


    CURSOR cur_nfr(pc_identification VARCHAR2)
        IS
    SELECT due_si_ref_ivc_id
      FROM exp_due_si_ref_ivc ivc
     WHERE ivc.identification = pc_identification
       AND ivc.due_ship_id = pn_due_ship_id;

/*
    CURSOR cur_i_nf_itens( pn_fatura_item_id NUMBER
                         , pc_nf_numero      VARCHAR2
                         , pc_nf_serie       VARCHAR2
                         , pn_nf_nr_linha    NUMBER
                         )
        IS
    SELECT detalhe.fatura_item_detalhe_id                                       fatura_item_detalhe_id
         , exp_pkg_due.fnc_ind_due( 'EX0050'
                                  , 'D'
                                  , itens.fatura_id
                                  , detalhe.nf_id
                                  , detalhe.fatura_item_id
                                  , detalhe.fatura_item_detalhe_id
                                  )                                             qtde_un_est
         , exp_pkg_due.fnc_ind_due( 'EX0031'
                                  , 'D'
                                  , itens.fatura_id
                                  , detalhe.nf_id
                                  , detalhe.fatura_item_id
                                  , detalhe.fatura_item_detalhe_id
                                  )                                             valor_18a
         , exp_pkg_due.fnc_ind_due( 'EX0030'
                                  , 'D'
                                  , itens.fatura_id
                                  , detalhe.nf_id
                                  , detalhe.fatura_item_id
                                  , detalhe.fatura_item_detalhe_id
                                  )                                             valor_18b
         , itens.fatura_id
      FROM exp_vw_fatura_item_detalhes  detalhe
         , exp_fatura_itens             itens
     WHERE detalhe.fatura_item_id = itens.fatura_item_id
       AND detalhe.fatura_item_id = pn_fatura_item_id
       AND detalhe.nf_numero      = pc_nf_numero
       AND detalhe.nf_serie       = pc_nf_serie
       AND detalhe.nf_nr_linha    = pn_nf_nr_linha;*/

    CURSOR cur_detalhe_ato(pn_item_det_id NUMBER)
        IS
    SELECT Nvl(efida.valor, 0)         valor
         , Nvl(efida.quantidade,0)     quantidade
         , Nvl(efida.quantidade_drw,0) quantidade_drw
         , Nvl(efida.peso_liquido,0)   peso_liquido
         , efia.fatura_item_ato_id
         , efia.rd_id
      FROM exp_fatura_item_atos          efia
         , exp_fatura_item_detalhe_atos  efida
    WHERE efia.fatura_item_ato_id = efida.fatura_item_ato_id
      AND fatura_item_detalhe_id  = pn_item_det_id;

    CURSOR cur_paridade_us_emb (pn_fatura_id exp_faturas.fatura_id%TYPE)
        IS
    SELECT embarque.data      data_embarque
         , cmx_pkg_taxas.fnc_paridade_usd_dia_util (
                                     fatura.moeda_id
                                   , embarque.data
                                   , 'DIARIA COMPRA'
                                   )
      FROM exp_fatura_datas embarque
         , exp_faturas      fatura
     WHERE fatura.fatura_id       = pn_fatura_id
       AND embarque.fatura_id     = fatura.fatura_id
       AND embarque.tipo_id       = cmx_pkg_tabelas.tabela_id ('203', 'EMBARQUE');

    CURSOR cur_data_conhecimento (pn_fatura_id exp_faturas.fatura_id%TYPE)
        IS
    SELECT conhec.data      data_conhec
      FROM exp_fatura_datas conhec
     WHERE conhec.fatura_id     = pn_fatura_id
       AND conhec.tipo_id       = cmx_pkg_tabelas.tabela_id ('203', 'CONHEC_TRANSPORTE');

    CURSOR cur_fat_item_info(pn_fatura_item_id NUMBER)
        IS
    SELECT efi.item_id
         , efi.ncm_id
         , decode ( efi.codigo
                  , NULL
                  , efi.un_medida_id
                  , exp_pkg_pesquisa.un_medida_id ( efi.item_id
                                                  , efi.organizacao_id
                                                  )
                  )           unidade_de_id
         , ctn.un_medida_id   unidade_para_id
      FROM exp_fatura_itens efi
         , cmx_tab_ncm      ctn
     WHERE efi.ncm_id          =  ctn.ncm_id (+)
       AND efi.fatura_item_id  =  pn_fatura_item_id;

    CURSOR cur_ato_enq(pn_fat_item_ato_id NUMBER) IS
      SELECT cmx_pkg_tabelas.codigo(drd.enquadramento_id) enquadramento
        FROM exp_fatura_item_atos   efia
           , drw_registro_drawback  drd
       WHERE efia.rd_id = drd.rd_id
         AND drd.enquadramento_id IS NOT NULL
         AND efia.fatura_item_ato_id = pn_fat_item_ato_id;

    CURSOR cur_comissao_repre(pn_fat_item_id NUMBER) IS
      SELECT Sum(percentual) percentual
        FROM exp_fatura_item_representantes
       WHERE fatura_item_id = pn_fat_item_id;

    CURSOR cur_ver_ship_item( pn_item_id     NUMBER
                            , pc_nf_nr_linha VARCHAR2
                            ) IS
      SELECT efidn.due_ship_item_id
        FROM exp_fatura_itens         efi
           , exp_fatura_item_detalhes efid
           , exp_fatura_item_det_nf   efidn
           , exp_due_ship_item        edsi
       WHERE efi.fatura_item_id  = efid.fatura_item_id
         AND efid.fatura_item_detalhe_id = efidn.fatura_item_detalhe_id
         AND efidn.due_ship_item_id      = edsi.due_ship_item_id
         AND efi.item_id         = pn_item_id
         AND efidn.fatura_nf_id  = pn_fatura_nf_id
         AND efidn.nf_nr_linha   = pc_nf_nr_linha
         AND edsi.due_id         = pn_due_id;

    CURSOR cur_atrib_ativo(pc_ncm VARCHAR2)
        IS
    SELECT DISTINCT etna.codigo
         , etna.ncm_atributo_id
         , Nvl(etna.formula, tipo.formula) formula
         , Upper(tipo.nomeapresentacao)    nomeapresentacao
      FROM cmx_tab_ncm_atributos        etna
         , cmx_tab_ncm_atributos_tipo   tipo
     WHERE etna.ncm_atr_tipo_id = tipo.ncm_atr_tipo_id
       AND etna.ncm             = pc_ncm
       AND Nvl(etna.ativo, 'S') = 'S'
       AND etna.modalidade = 'EXPORTAÇÃO';

    CURSOR cur_nr_linha_nf( pc_numero_nf    VARCHAR2
                          , pc_serie_nf     VARCHAR2
                          , pc_nr_linha_nf  VARCHAR2
                          )
        IS
    SELECT nf_nr_linha_due
      FROM exp_vw_due_numero_lin_nf
     WHERE due_id      = pn_due_id
       AND fatura_id   = pn_fatura_id
       AND numero_nf   = pc_numero_nf
       AND serie_nf    = pc_serie_nf
       AND nf_nr_linha = pc_nr_linha_nf;

    CURSOR cur_serie(pn_fat_item_det_id NUMBER)
        IS
    SELECT serie
      FROM exp_fatura_item_detalhes
     WHERE fatura_item_detalhe_id = pn_fat_item_det_id;

    CURSOR cur_ship_item(pn_id NUMBER)
        IS
    SELECT cmmdty_description
      FROM exp_due_ship_item
     WHERE due_ship_item_id = pn_id;

    CURSOR cur_adoc_recof(pn_fat_detalhe_id NUMBER)
        IS
    SELECT DISTINCT nr_di nr_declaracao
         , adicao_num
         , dsi
         , qtde_consumo
      FROM exp_vw_due_res_reexportaca
     WHERE fatura_item_detalhe_id = pn_fat_detalhe_id;

  CURSOR cur_rcf_proc_adm(pc_nr_declaracao VARCHAR2, pn_adicao_num NUMBER)
  IS
  SELECT rcr.processo_numero
    FROM imp_adm_temp_rcr_lin rcr_lin
       , imp_adm_temp_rcr     rcr
       , imp_declaracoes_lin  idl
       , imp_declaracoes      id
       , imp_declaracoes_adi  ida
   WHERE rcr_lin.invoice_lin_id  = idl.invoice_lin_id
     AND rcr_lin.rcr_id          = rcr.rcr_id
     AND rcr.processo_numero    IS NOT NULL
     AND idl.declaracao_adi_id  = ida.declaracao_adi_id
     AND idl.declaracao_id      = id.declaracao_id
     AND ida.adicao_num         = pn_adicao_num
     AND id.nr_declaracao       = pc_nr_declaracao
  UNION
 SELECT rat.processo_numero
   FROM imp_adm_temp_rat_lin rat_lin
      , imp_adm_temp_rat     rat
      , imp_declaracoes_lin  idl
      , imp_declaracoes      id
      , imp_declaracoes_adi  ida
  WHERE rat_lin.invoice_lin_id  = idl.invoice_lin_id
    AND rat_lin.rat_id          = rat.rat_id
    AND rat.processo_numero IS NOT NULL
    AND idl.declaracao_adi_id  = ida.declaracao_adi_id
    AND idl.declaracao_id      = id.declaracao_id
    AND ida.adicao_num         = pn_adicao_num
    AND id.nr_declaracao       = pc_nr_declaracao;

    CURSOR cur_ato_due( pn_due_ship_item_id  NUMBER
                      , pc_nr_ato            VARCHAR2
                      , pn_itemid            NUMBER
                       ) IS
      SELECT due_si_adoc_id
        FROM exp_due_si_adoc
        WHERE due_ship_item_id = pn_due_ship_item_id
          AND identification   = pc_nr_ato
          AND itemid           = pn_itemid;

    CURSOR cur_nr_ato(pn_fatura_item_ato_id NUMBER) IS
      SELECT numero, nr_item_drawback
        FROM exp_vw_fatura_item_atos
       WHERE fatura_item_ato_id = pn_fatura_item_ato_id;

    CURSOR cur_enq_sem_di(pn_due_ship_item_id NUMBER)
        IS
    SELECT Max(Upper(Nvl(ct.auxiliar6,'S'))) enq_sem_di
      FROM cmx_tabelas ct
         , exp_due_si_enq edie
     WHERE ct.codigo = edie.enquadramento
       AND edie.due_ship_item_id = pn_due_ship_item_id;

    CURSOR cur_ver_enq(pn_due_ship_item_id NUMBER, pc_enquadramento VARCHAR2)
        IS
    SELECT due_si_enq_id
      FROM exp_due_si_enq
     WHERE due_ship_item_id = pn_due_ship_item_id
       AND enquadramento = pc_enquadramento;

    CURSOR cur_nf_due_remessa ( pn_due_ship_item_id         NUMBER
                              , pn_due_si_ref_ivc_id        NUMBER
                              , pc_invoiceidentificationid  VARCHAR2
                              , pn_sequencenumeric          NUMBER
                              ) IS
      SELECT due_si_ref_ivcl_id
        FROM exp_due_si_ref_ivcl
       WHERE invoiceidentificationid = pc_invoiceidentificationid
         AND due_ship_item_id        = pn_due_ship_item_id
         AND due_si_ref_ivc_id       = pn_due_si_ref_ivc_id
         AND sequencenumeric         = pn_sequencenumeric;

    vr_fat_item_info      cur_fat_item_info%ROWTYPE;
    vr_nr_ato             cur_nr_ato%ROWTYPE;
    vn_due_ship_item_id   NUMBER;
    vn_due_si_ref_ivc_id  NUMBER;
    vc_atrib_code         VARCHAR2(150);
    vn_item_det_re_id     NUMBER;
    vd_data_embarque      DATE;
    vn_paridade_us_dt_emb NUMBER;
    vd_data_conhec        DATE;
    vn_qtde_estatistica   NUMBER;
    vn_peso_liquido       NUMBER;
    vn_valor_fob          NUMBER;
    vn_valor_vcv_mn       NUMBER;
    vc_enquadramento      VARCHAR2(20);
    vn_per_comissao       NUMBER;

    vn_fat_item_id_ant    NUMBER  := NULL;
    vb_continuar          BOOLEAN := FALSE;
    vb_enq_ato            BOOLEAN := FALSE;
    vn_ship_item_id       NUMBER  := NULL;
    vb_achou              BOOLEAN := FALSE;
    vc_destaque           VARCHAR2(150);

    vn_nf_nr_linha_due    NUMBER  := NULL;
    vn_item_id            NUMBER  := NULL;
    vn_item_id_ant        NUMBER  := NULL;

    vc_serie              VARCHAR2(40);
    vc_descricao_item     VARCHAR2(4000);
    vc_typecode           VARCHAR2(10);

    vn_due_si_adoc_id     NUMBER;
    vc_enq_sem_di         VARCHAR2(1);
    vn_qtd_total_det      NUMBER;
    vn_due_si_enq_id      NUMBER;
    vn_vlr_financiamento  NUMBER;
    vn_due_si_ref_ivcl_id NUMBER;
  BEGIN

    FOR x IN cur_i_nf
    LOOP
      vb_continuar := TRUE;

      --Quantidade estatística
      OPEN cur_fat_item_info(x.fatura_item_id);
      FETCH cur_fat_item_info INTO vr_fat_item_info;
      CLOSE cur_fat_item_info;

      --Quantidade vinculado ao detalhe do item
      vn_qtd_total_det := exp_pkg_informacoes.fnc_valor ( cmx_pkg_tabelas.tabela_id ('202', 'QUANTIDADE')
                                                        , NULL
                                                        , x.fatura_id
                                                        , x.fatura_item_id
                                                        , x.fatura_item_detalhe_id
                                                        );

      IF(Nvl(x.peso_liquido,0) = 0) THEN

        vn_peso_liquido := Nvl(exp_pkg_informacoes.fnc_valor( cmx_pkg_tabelas.tabela_id ('202', 'PESO_LIQUIDO')
                                                            , NULL
                                                            , x.fatura_id
                                                            , x.fatura_item_id
                                                            , x.fatura_item_detalhe_id
                                                            ),0);

        IF(Nvl(vn_peso_liquido,0) > 0) THEN
          vn_peso_liquido := Nvl(vn_peso_liquido,0) * Nvl(x.quantidade_nf,0);
        END IF;
      ELSE
        vn_peso_liquido      := (Nvl(x.peso_liquido,0) / Nvl(x.qtde_comercial,0)) * Nvl(x.quantidade_nf,0);
      END IF;

      IF ( Nvl(x.qtde_un_est, 0) = 0 OR vn_qtd_total_det <> x.quantidade_nf) THEN

        BEGIN
          vn_qtde_estatistica := cmx_pkg_itens.fnc_conv_qtde_um(
                                                        nvl( exp_pkg_informacoes.fnc_complemento_id( cmx_pkg_tabelas.tabela_id('201','UNIDADE_VENDA')
                                                                                                  , NULL
                                                                                                  , x.fatura_id
                                                                                                  , x.fatura_item_id
                                                                                                  , x.fatura_item_detalhe_id
                                                                                                  )
                                                          ,   vr_fat_item_info.unidade_de_id
                                                          )
                                                      , vr_fat_item_info.unidade_para_id
                                                      , vr_fat_item_info.item_id
                                                      , x.quantidade_nf
                                                      , vn_peso_liquido
                                                      , vr_fat_item_info.ncm_id
                                                      );
        EXCEPTION
          WHEN OTHERS THEN
            vn_qtde_estatistica := 0;
        END;
      ELSE
          vn_qtde_estatistica :=  x.qtde_un_est ;
      END IF ;

      vc_atrib_code        := NULL;
      vn_valor_fob         := (Nvl(x.valor_fob,0) / Nvl(x.qtde_comercial,0)) * Nvl(x.quantidade_nf,0);
      vn_valor_vcv_mn      := (Nvl(x.valor_vcv_mn,0) / Nvl(x.qtde_comercial,0)) * Nvl(x.quantidade_nf,0);

      IF( Nvl(x.valor_financiamento,0) > 0 AND
          ( (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_1,'-99999')),7),'N') = 'S') OR
            (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_2,'-99999')),7),'N') = 'S') OR
            (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_3,'-99999')),7),'N') = 'S') OR
            (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_4,'-99999')),7),'N') = 'S')
          )
        ) THEN
        vn_vlr_financiamento := (Nvl(x.valor_financiamento,0) / Nvl(x.qtde_comercial,0)) * Nvl(x.quantidade_nf,0);
      ELSE
        vn_vlr_financiamento := NULL;
      END IF;

      /*
        Verifica se para o mesmo item da fatura com o mesmo número de nota fiscal
        e o mesmo número de linha de nota fiscal
        já foi inserido na DUE.
      */
      IF(vr_fat_item_info.item_id = vn_item_id_ant AND vn_item_id_ant IS NOT NULL AND vr_fat_item_info.item_id IS NOT NULL) THEN

        vb_achou := FALSE;
        vn_due_ship_item_id := NULL;
        OPEN  cur_ver_ship_item(vr_fat_item_info.item_id, x.nf_nr_linha_due);
        FETCH cur_ver_ship_item INTO vn_due_ship_item_id;
        vb_achou := cur_ver_ship_item%FOUND;
        CLOSE cur_ver_ship_item;

        IF(vb_achou) THEN

          vb_continuar := FALSE;
          vc_descricao_item := NULL;

          OPEN  cur_ship_item(vn_due_ship_item_id);
          FETCH cur_ship_item INTO vc_descricao_item;
          CLOSE cur_ship_item;

          vc_serie := NULL;
          OPEN  cur_serie(x.fatura_item_detalhe_id);
          FETCH cur_serie INTO vc_serie;
          CLOSE cur_serie;

          IF(vc_serie IS NOT NULL) THEN
            IF(InStr(vc_descricao_item, 'Serie:') > 0) THEN
              vc_descricao_item := vc_descricao_item ||', '||vc_serie;
            ELSE
              vc_descricao_item := vc_descricao_item ||' Serie: '||vc_serie;
            END IF;
          END IF;

          UPDATE exp_due_ship_item SET customsvalue = Nvl(customsvalue,0) + Nvl(vn_valor_fob,0)
                                     , cmmdty_value = Nvl(cmmdty_value,0) + Nvl(vn_valor_vcv_mn,0)
                                     , cmmdty_gs_netweight = Nvl(cmmdty_gs_netweight,0) + Nvl(vn_peso_liquido,0)
                                     , cmmdty_description  = vc_descricao_item
                                 WHERE due_ship_item_id = vn_due_ship_item_id;

          UPDATE exp_due_si_dest SET gm_tariffquantity = Nvl(gm_tariffquantity,0) + Nvl(vn_qtde_estatistica,0)
                               WHERE due_ship_item_id = vn_due_ship_item_id;

          --Financedvalue
          IF(Nvl(vn_vlr_financiamento,0) > 0) THEN
            UPDATE exp_due_ship_item SET financedvalue = Nvl(financedvalue,0) + Nvl(vn_vlr_financiamento,0)
                                   WHERE due_ship_item_id = vn_due_ship_item_id;
          END IF;

          --Drawback Suspensão
          IF(x.fatura_item_detalhe_ato_id IS NOT NULL) THEN

            OPEN  cur_nr_ato(x.fatura_item_ato_id);
            FETCH cur_nr_ato INTO vr_nr_ato;
            CLOSE cur_nr_ato;

            vn_due_si_adoc_id := NULL;
            vb_achou          := FALSE;
            OPEN  cur_ato_due(vn_due_ship_item_id, vr_nr_ato.numero, vr_nr_ato.nr_item_drawback);
            FETCH cur_ato_due INTO vn_due_si_adoc_id;
            vb_achou := cur_ato_due%FOUND;
            CLOSE cur_ato_due;

            IF(vb_achou) THEN

--              FOR ato IN cur_atos(x.fatura_item_detalhe_ato_id)
--              LOOP
--                UPDATE exp_due_si_adoc SET quantity = Nvl(quantity,0) + Nvl(ato.quantidade,0)
--                                         , vlrwithexcoveramount = Nvl(vlrwithexcoveramount,0) + Nvl(ato.valor,0)
--                                     WHERE due_si_adoc_id = vn_due_si_adoc_id;
--              END LOOP;

              p_prc_inserir_ato( x.fatura_item_detalhe_ato_id
                               , x.fatura_item_ato_id
                               , vn_due_ship_item_id
                               , pn_usuario_id
                               , x.fatura_id
                               , x.fatura_item_id
                               , x.fatura_item_detalhe_id
                               , vn_due_si_adoc_id
                               , vn_qtde_estatistica
                               , 'U'
                               );

            ELSE
              /*
              EX0075 ItemID
              EX0076 QuantityQuantity
              EX0077 ValueWithExchangeCoverAmount
              EX0078 ValueWithoutExchangeCoverAmount
              EX0083 DrawbackHsClassification
              EX0084 DrawbackRecipientId
              */
              p_prc_inserir_ato( x.fatura_item_detalhe_ato_id
                               , x.fatura_item_ato_id
                               , vn_due_ship_item_id
                               , pn_usuario_id
                               , x.fatura_id
                               , x.fatura_item_id
                               , x.fatura_item_detalhe_id
                               , NULL
                               , vn_qtde_estatistica
                               , 'I'
                               );

            END IF;
          END IF;

        END IF;
      END IF;

      IF(vb_continuar) THEN

        vn_nf_nr_linha_due := NULL;
        IF(Nvl(cmx_fnc_profile('EXP_DUE_REDEFINE_SEQ_LINHA_NF'), 'N') = 'S') THEN
          OPEN  cur_nr_linha_nf ( x.nf_numero
                                , x.nf_serie
                                , x.nf_nr_linha
                                );
          FETCH cur_nr_linha_nf INTO vn_nf_nr_linha_due;
          CLOSE cur_nr_linha_nf;
        ELSE
          vn_nf_nr_linha_due := x.nf_nr_linha_due;
        END IF;

        pn_itens_due := pn_itens_due + 1;
        vn_due_ship_item_id := NULL;
        vn_due_ship_item_id := cmx_fnc_proxima_sequencia('exp_due_ship_item_sq1');
        INSERT INTO exp_due_ship_item
        (
          due_id                                       --01
        , due_ship_id                                  --02
        , due_ship_item_id                             --03
        , customsvalue                                 --04
        , sequence                                     --05
        , cmmdty_description                           --06
        , cmmdty_value                                 --07
        , cmmdty_line_sequence                         --08
        , cmmdty_gs_netweight                          --09
        , ncm                                          --10
        , creation_date                                --11
        , created_by                                   --12
        , last_update_date                             --13
        , last_updated_by                              --14
        , financedvalue                                --15
        ) VALUES (
                   pn_due_id                           --01
                 , pn_due_ship_id                      --02
                 , vn_due_ship_item_id                 --03
                 , vn_valor_fob                        --04
                 , pn_itens_due                        --05
                 , SubStr(x.descricao, 1, 4000)        --06
                 , vn_valor_vcv_mn                     --07
                 , vn_nf_nr_linha_due                  --08
                 , vn_peso_liquido                     --09
                 , x.ncm                               --10
                 , SYSDATE                             --11
                 , pn_usuario_id                       --12
                 , SYSDATE                             --13
                 , pn_usuario_id                       --14
                 , vn_vlr_financiamento                --15
                 );

        INSERT INTO exp_due_si_dest
        (
          due_si_dest_id
        , due_ship_item_id
        , countrycode
        , gm_tariffquantity
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        ) VALUES (
                   cmx_fnc_proxima_sequencia('exp_due_si_dest_sq1')
                 , vn_due_ship_item_id
                 , x.pais_destino
                 , vn_qtde_estatistica
                 , SYSDATE
                 , pn_usuario_id
                 , SYSDATE
                 , pn_usuario_id
                 );

        vc_enq_sem_di := NULL;
        vb_enq_ato    := FALSE;

        IF(x.fatura_item_ato_id IS NOT  NULL) THEN

           vc_enquadramento := NULL;
           OPEN  cur_ato_enq(x.fatura_item_ato_id);
           FETCH cur_ato_enq INTO vc_enquadramento;
           CLOSE cur_ato_enq;

           IF(vc_enquadramento IS NOT NULL) THEN

             vb_achou := FALSE;
             OPEN  cur_ver_enq(vn_due_ship_item_id, vc_enquadramento);
             FETCH cur_ver_enq INTO vn_due_si_enq_id;
             vb_achou := cur_ver_enq%FOUND;
             CLOSE cur_ver_enq;

             IF NOT(vb_achou) THEN

              vb_enq_ato := TRUE;

              INSERT INTO exp_due_si_enq
              (
                due_si_enq_id
              , due_ship_item_id
              , enquadramento
              , creation_date
              , created_by
              , last_update_date
              , last_updated_by
              ) VALUES (
                          cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                        , vn_due_ship_item_id
                        , vc_enquadramento
                        , SYSDATE
                        , pn_usuario_id
                        , SYSDATE
                        , pn_usuario_id
                        );
            END IF;
           END IF;
        END IF ;

        IF NOT(vb_enq_ato) THEN
          IF ( x.enquadramento_1 IS NOT NULL) THEN

            vb_achou := FALSE;
            OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_1);
            FETCH cur_ver_enq INTO vn_due_si_enq_id;
            vb_achou := cur_ver_enq%FOUND;
            CLOSE cur_ver_enq;

            IF NOT(vb_achou) THEN

                INSERT INTO exp_due_si_enq
                (
                  due_si_enq_id
                , due_ship_item_id
                , enquadramento
                , creation_date
                , created_by
                , last_update_date
                , last_updated_by
                ) VALUES (
                            cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                          , vn_due_ship_item_id
                          , x.enquadramento_1
                          , SYSDATE
                          , pn_usuario_id
                          , SYSDATE
                          , pn_usuario_id
                          );
            END IF;
          END IF;

          IF ( x.enquadramento_2 IS NOT NULL) THEN

            vb_achou := FALSE;
            OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_2);
            FETCH cur_ver_enq INTO vn_due_si_enq_id;
            vb_achou := cur_ver_enq%FOUND;
            CLOSE cur_ver_enq;

            IF NOT(vb_achou) THEN
              INSERT INTO exp_due_si_enq
              (
                due_si_enq_id
              , due_ship_item_id
              , enquadramento
              , creation_date
              , created_by
              , last_update_date
              , last_updated_by
              ) VALUES (
                        cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                      , vn_due_ship_item_id
                      , x.enquadramento_2
                      , SYSDATE
                      , pn_usuario_id
                      , SYSDATE
                      , pn_usuario_id
                      );
            END IF;
          END IF;

          IF ( x.enquadramento_3 IS NOT NULL) THEN

            vb_achou := FALSE;
            OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_3);
            FETCH cur_ver_enq INTO vn_due_si_enq_id;
            vb_achou := cur_ver_enq%FOUND;
            CLOSE cur_ver_enq;

            IF NOT(vb_achou) THEN
              INSERT INTO exp_due_si_enq
              (
                due_si_enq_id
              , due_ship_item_id
              , enquadramento
              , creation_date
              , created_by
              , last_update_date
              , last_updated_by
              ) VALUES (
                        cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                      , vn_due_ship_item_id
                      , x.enquadramento_3
                      , SYSDATE
                      , pn_usuario_id
                      , SYSDATE
                      , pn_usuario_id
                      );
            END IF;
          END IF;

          IF ( x.enquadramento_4 IS NOT NULL) THEN

            vb_achou := FALSE;
            OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_4);
            FETCH cur_ver_enq INTO vn_due_si_enq_id;
            vb_achou := cur_ver_enq%FOUND;
            CLOSE cur_ver_enq;

            IF NOT(vb_achou) THEN

              INSERT INTO exp_due_si_enq
              (
                due_si_enq_id
              , due_ship_item_id
              , enquadramento
              , creation_date
              , created_by
              , last_update_date
              , last_updated_by
              ) VALUES (
                        cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                      , vn_due_ship_item_id
                      , x.enquadramento_4
                      , SYSDATE
                      , pn_usuario_id
                      , SYSDATE
                      , pn_usuario_id
                      );
            END IF;
          END IF;
        END IF; --vb_enq_ato

        FOR attr IN cur_atrib_ativo(x.ncm_codigo) LOOP
          vc_destaque   := NULL;

          IF(attr.formula IS NOT NULL) THEN
            prc_busca_atributo_ncm( pn_due_id
                                  , vn_due_ship_item_id
                                  , x.ncm_codigo
                                  , attr.ncm_atributo_id
                                  , attr.formula
                                  , vc_destaque
                                  );
          END IF;

          IF(attr.nomeapresentacao  = 'DESTAQUE' AND vc_destaque IS NULL) THEN
            vc_destaque := x.destaque_ncm;
          END IF;

          -- EX0033
          INSERT INTO exp_due_si_char
          (
            due_si_char_id
          , due_ship_item_id
          , typecode
          , description
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          ) VALUES (
                      cmx_fnc_proxima_sequencia('exp_due_si_char_sq1')
                   , vn_due_ship_item_id
                   , attr.codigo  --x.destaque_ncm_type
                   , vc_destaque
                   , SYSDATE
                   , pn_usuario_id
                   , SYSDATE
                   , pn_usuario_id
                   );
        END LOOP;

/*      IF(x.destaque_ncm IS NOT NULL) THEN
          vc_atrib_code := NULL;
          -- EX0033
          OPEN cur_atrib(x.ncm_codigo, x.destaque_ncm);
          FETCH cur_atrib INTO vc_atrib_code;
          CLOSE cur_atrib;

          INSERT INTO exp_due_si_char
          (
            due_si_char_id
          , due_ship_item_id
          , typecode
          , description
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          ) VALUES (
                     cmx_fnc_proxima_sequencia('exp_due_si_char_sq1')
                   , vn_due_ship_item_id
                   , vc_atrib_code  --x.destaque_ncm_type
                   , x.destaque_ncm
                   , SYSDATE
                   , pn_usuario_id
                   , SYSDATE
                   , pn_usuario_id
                   );
        ELSE
          IF vc_atrib_code IS NOT NULL THEN
            cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Destaque da NCM não preenchido, verifique os destaques. NCM @@1@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_049',null,x.ncm_codigo),'E');
          END IF;
        END IF;*/

        IF (x.prazo_exp_tmp IS NOT NULL) THEN
          INSERT INTO exp_due_gs_item_add_info
          (
            due_gsi_add_info_id
          , due_ship_item_id
          , statementcode
          , statementdescription
          , limitdatetime
          , statementtypecode
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          ) VALUES (
                     cmx_fnc_proxima_sequencia('exp_due_gsi_add_info_sq1')
                   , vn_due_ship_item_id
                   , NULL --x.prio_carga
                   , SubStr(x.doc_exp_temp,1 , 4000)  --statementdescription
                   , x.prazo_exp_tmp --limitdatetime
                   , x.prazo_exp_tmp_type
                   , SYSDATE
                   , pn_usuario_id
                   , SYSDATE
                   , pn_usuario_id
                   );
        END IF;

        IF (x.prio_carga IS NOT NULL) THEN
          INSERT INTO exp_due_gs_item_add_info
          (
            due_gsi_add_info_id
          , due_ship_item_id
          , statementcode
          , statementdescription
          , limitdatetime
          , statementtypecode
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          ) VALUES (
                     cmx_fnc_proxima_sequencia('exp_due_gsi_add_info_sq1')
                   , vn_due_ship_item_id
                   , x.prio_carga
                   , NULL --statementdescription
                   , NULL --limitdatetime
                   , x.prio_carga_type
                   , SYSDATE
                   , pn_usuario_id
                   , SYSDATE
                   , pn_usuario_id
                   );
        END IF;

        /*
        Drawback Suspensão

        EX0075 ItemID
        EX0076 QuantityQuantity
        EX0077 ValueWithExchangeCoverAmount
        EX0078 ValueWithoutExchangeCoverAmount
        EX0083 DrawbackHsClassification
        EX0084 DrawbackRecipientId
        */
        p_prc_inserir_ato( x.fatura_item_detalhe_ato_id
                         , x.fatura_item_ato_id
                         , vn_due_ship_item_id
                         , pn_usuario_id
                         , x.fatura_id
                         , x.fatura_item_id
                         , x.fatura_item_detalhe_id
                         , NULL
                         , vn_qtde_estatistica
                         , 'I'
                         );

        OPEN cur_enq_sem_di(vn_due_ship_item_id);
        FETCH cur_enq_sem_di INTO vc_enq_sem_di;
        CLOSE cur_enq_sem_di;

        IF Upper(Nvl(vc_enq_sem_di,'S')) = 'S' THEN
          FOR adoc IN cur_adoc_di(x.fatura_item_id)
          LOOP
            vn_due_si_adoc_id := cmx_fnc_proxima_sequencia('exp_due_si_adoc_sq1');
            INSERT INTO exp_due_si_adoc
            (
              due_si_adoc_id
            , due_ship_item_id
            , identification
            , category
            , itemid
            , quantity
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                       vn_due_si_adoc_id
                     , vn_due_ship_item_id
                     , adoc.nr_declaracao
                     , exp_pkg_due.fnc_ind_due(Decode(Nvl(adoc.dsi,'N')
                                                     , 'N', 'EX0024_DI'
                                                     , 'S', 'EX0024_DSI') ,'L', x.fatura_id, NULL , x.fatura_item_id)
                     , adoc.adicao_num
                     , vn_qtde_estatistica
                     , SYSDATE
                     , pn_usuario_id
                     , SYSDATE
                     , pn_usuario_id
                     );

            FOR proc_adm IN cur_proc_adm(adoc.declaracao_adi_id)
            LOOP
              INSERT INTO exp_due_si_adoc_add_info
              (
                due_gs_add_info_id
              , due_si_adoc_id
              , statementtypecode
              , statementdescription
              , creation_date
              , created_by
              , last_update_date
              , last_updated_by
              ) VALUES (
                       cmx_fnc_proxima_Sequencia('exp_due_si_adoc_add_info_sq1')
                       , vn_due_si_adoc_id
                       , 'ABC'
                       , proc_adm.processo_numero
                       , SYSDATE
                       , pn_usuario_id
                       , SYSDATE
                       , pn_usuario_id
                       );
            END LOOP;


          END LOOP;
        END IF;

        FOR nf_r IN cur_nf_det_rem(x.fatura_det_nf_id)
        LOOP

          IF (nf_r.invoiceIdentificationid IS NOT NULL) THEN

            INSERT INTO exp_due_si_ref_ivcl
            (
              due_si_ref_ivcl_id
            , due_si_ref_ivc_id
            , due_ship_item_id
            , sequencenumeric
            , invoiceidentificationid
            , gm_tariffquantity
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                       cmx_fnc_proxima_sequencia('exp_due_si_ref_ivcl_sq1')
                     , nf_r.due_si_ref_ivc_id
                     , vn_due_ship_item_id
                     , nf_r.sequencenumeric
                     , nf_r.invoiceidentificationid
                     , nf_r.gm_tariffquantity
                     , SYSDATE
                     , pn_usuario_id
                     , SYSDATE
                     , pn_usuario_id
                     );
          END IF;

        END LOOP;

        /*EX0073 e EX0074 -> TIPO = 149*/
        vn_per_comissao := 0;
        --OPEN  cur_comissao_repre(x.fatura_item_id);
        --FETCH cur_comissao_repre INTO vn_per_comissao;
        --CLOSE cur_comissao_repre;
        vn_per_comissao := fnc_vlr_comissao(x.fatura_item_id, vr_fat_item_info.ncm_id);

        IF(Nvl(vn_per_comissao,0) > 0) THEN
          INSERT INTO exp_due_ship_item_adj( due_si_adj_id
                                           , due_ship_item_id
                                           , additioncode
                                           , percentage
                                           , creation_date
                                           , created_by
                                           , last_update_date
                                           , last_updated_by
                                           )
                                    VALUES ( cmx_fnc_proxima_sequencia('exp_due_ship_item_adj_sq1')
                                           , vn_due_ship_item_id
                                           , '149'
                                           , vn_per_comissao
                                           , SYSDATE
                                           , pn_usuario_id
                                           , SYSDATE
                                           , pn_usuario_id
                                           );
        END IF;

      ELSE

         FOR nf_r IN cur_nf_det_rem(x.fatura_det_nf_id) LOOP

             IF (nf_r.invoiceIdentificationid IS NOT NULL) THEN

                  vb_achou := FALSE;
                  --Verifica se já existe
                  OPEN  cur_nf_due_remessa( vn_due_ship_item_id
                                          , nf_r.due_si_ref_ivc_id
                                          , nf_r.invoiceidentificationid
                                          , nf_r.sequencenumeric
                                          );
                  FETCH cur_nf_due_remessa INTO vn_due_si_ref_ivcl_id;
                  vb_achou := cur_nf_due_remessa%FOUND;
                  CLOSE cur_nf_due_remessa;

                  IF NOT(vb_achou) THEN

                    INSERT INTO exp_due_si_ref_ivcl
                    (
                      due_si_ref_ivcl_id
                    , due_si_ref_ivc_id
                    , due_ship_item_id
                    , sequencenumeric
                    , invoiceidentificationid
                    , gm_tariffquantity
                    , creation_date
                    , created_by
                    , last_update_date
                    , last_updated_by
                    ) VALUES (
                              cmx_fnc_proxima_sequencia('exp_due_si_ref_ivcl_sq1')
                            , nf_r.due_si_ref_ivc_id
                            , vn_due_ship_item_id
                            , nf_r.sequencenumeric
                            , nf_r.invoiceidentificationid
                            , nf_r.gm_tariffquantity
                            , SYSDATE
                            , pn_usuario_id
                            , SYSDATE
                            , pn_usuario_id
                            );
                ELSE

                  IF(Nvl(nf_r.gm_tariffquantity,0) > 0) THEN
                    UPDATE exp_due_si_ref_ivcl SET gm_tariffquantity = Nvl(gm_tariffquantity,0) + Nvl(nf_r.gm_tariffquantity,0)
                                            WHERE due_si_ref_ivcl_id = vn_due_si_ref_ivcl_id;
                  END IF;

                END IF;

            END IF;

          END LOOP ;

      END IF;

      /*Vincula a due com a nota do detalhe do item*/
      IF(x.fatura_det_nf_id IS NOT NULL) THEN
        UPDATE exp_fatura_item_det_nf SET numero_nf        = x.nf_numero
                                        , serie_nf         = x.nf_serie
                                        , qtde_estatistica = vn_qtde_estatistica
                                        , due_ship_item_id = vn_due_ship_item_id
                                        , valor_18b        = vn_valor_fob
                                        , valor_18a        = vn_valor_vcv_mn
                                        , last_update_date = SYSDATE
                                        , last_updated_by  = pn_usuario_id
                                        , fatura_nf_id     = pn_fatura_nf_id
                                        , nf_nr_linha      = x.nf_nr_linha_due
                                    WHERE fatura_det_nf_id = x.fatura_det_nf_id;
      ELSE

        INSERT INTO exp_fatura_item_det_nf  ( fatura_det_nf_id
																				    , fatura_nf_id
																				    , fatura_item_detalhe_id
																				    , fatura_item_detalhe_ato_id
																				    , quantidade_nf
																				    , valor_18b
                                            , valor_18a
																				    , peso_liquido
																				    , nf_nr_linha
																				    , numero_nf
																				    , serie_nf
                                            , qtde_estatistica
                                            , creation_date
                                            , created_by
                                            , last_update_date
                                            , last_updated_by
			                                      , due_ship_item_id
                                            )
			                              VALUES ( cmx_fnc_proxima_sequencia('exp_fatura_item_det_nf_sq1')
			                                      , pn_fatura_nf_id
			                                      , x.fatura_item_detalhe_id
			                                      , x.fatura_item_detalhe_ato_id
			                                      , x.quantidade_nf
			                                      , vn_valor_fob
                                            , vn_valor_vcv_mn
			                                      , vn_peso_liquido
			                                      , x.nf_nr_linha_due
			                                      , x.nf_numero
			                                      , x.nf_serie
                                            , vn_qtde_estatistica
                                            , SYSDATE
                                            , pn_usuario_id
                                            , SYSDATE
                                            , pn_usuario_id
                                            , vn_due_ship_item_id
			                                      );
      END IF;

      --REEXPORTAÇÃO RECOF
      --vc_typecode := exp_pkg_due.fnc_ind_due('EX0018_DI' ,'L', x.fatura_id, NULL , x.fatura_item_id);
      IF Upper(Nvl(vc_enq_sem_di,'S')) = 'S' THEN

        FOR adoc IN cur_adoc_recof(x.fatura_item_detalhe_id)
          LOOP
          vn_due_si_adoc_id :=  cmx_fnc_proxima_sequencia('exp_due_si_adoc_sq1');

          INSERT INTO exp_due_si_adoc
          (
            due_si_adoc_id
          , due_ship_item_id
          , identification
          , category
          , itemid
          , quantity
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          ) VALUES (
                     vn_due_si_adoc_id
                   , vn_due_ship_item_id
                   , adoc.nr_declaracao
                   , exp_pkg_due.fnc_ind_due(Decode(Nvl(adoc.dsi,'N')
                                                     , 'N', 'EX0024_DI'
                                                     , 'S', 'EX0024_DSI') ,'L', x.fatura_id, NULL , x.fatura_item_id)
                   , adoc.adicao_num
                   , Nvl(  adoc.qtde_consumo , vn_qtde_estatistica )
                   , SYSDATE
                   , pn_usuario_id
                   , SYSDATE
                   , pn_usuario_id
                   );

          FOR proc_adm IN cur_rcf_proc_adm(adoc.nr_declaracao, adoc.adicao_num)
          LOOP
            INSERT INTO exp_due_si_adoc_add_info
            (
              due_gs_add_info_id
            , due_si_adoc_id
            , statementtypecode
            , statementdescription
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      cmx_fnc_proxima_Sequencia('exp_due_si_adoc_add_info_sq1')
                      , vn_due_si_adoc_id
                      , 'ABC'
                      , proc_adm.processo_numero
                      , SYSDATE
                      , pn_usuario_id
                      , SYSDATE
                      , pn_usuario_id
                      );
          END LOOP;

        END LOOP;
      END IF;

      --Drawback Isenção
      IF(x.fatura_det_nf_id IS NOT NULL) THEN
        p_prc_inserir_ato_isencao ( vn_due_ship_item_id
                                  , x.fatura_det_nf_id
                                  , pn_usuario_id
                                  );
      END IF;

      vn_item_id_ant := vr_fat_item_info.item_id;
    END LOOP;
  END prc_gs_i_nf;

  PROCEDURE prc_gs_i_snf( pn_due_id      NUMBER
                        , pn_due_ship_id NUMBER
                        , pn_fatura_id   NUMBER
                        , pn_usuario_id  NUMBER
                        , pn_itens_due   IN OUT NUMBER
                        )
  AS

    CURSOR cur_i_snf
        IS
    SELECT fatura_id
         , fatura_item_id
         , Sum(valor_fob) valor_fob
         , descricao
         , exp_pkg_due.fnc_ind_due('EX0020' ,'L'      , fatura_id, NULL, fatura_item_id)                               descricao_comercial
         , exp_pkg_due.fnc_ind_due('EX0021' ,'L'      , fatura_id, NULL, fatura_item_id)                               ncm
         , exp_pkg_due.fnc_ind_due('EX0022' ,'L'      , fatura_id, NULL, fatura_item_id)                               ncm_type
         , Sum(valor_vcv_mn) valor_vcv_mn
         , Sum(peso_liquido) peso_liquido
         , Sum(qtde_un_est) qtde_un_est
         , Sum(qtde_un_com) qtde_un_com
         , Sum(valor_financiamento) valor_financiamento
         , exp_pkg_due.fnc_ind_due('EX0049' ,'L', fatura_id, NULL, fatura_item_id)                                     pais_destino
         , enquadramento_1
         , enquadramento_2
         , enquadramento_3
         , enquadramento_4
         , exp_pkg_due.fnc_ind_due('EX0014' ,'L', fatura_id, NULL, fatura_item_id)                                     codigo_produto
         , exp_pkg_due.fnc_ind_due('EX0015' ,'L', fatura_id, NULL, fatura_item_id)                                     codigo_produto_type
         , exp_pkg_due.fnc_ind_due('EX0027_PRIO_CARGA' ,'L', fatura_id, NULL, fatura_item_id)                          prio_carga_type
         , exp_pkg_due.fnc_ind_due('EX0027_PRAZO_TEMP' ,'L', fatura_id, NULL, fatura_item_id)                          prazo_exp_tmp_type
         , exp_pkg_due.fnc_ind_due('EX0035' ,'L', fatura_id, NULL, fatura_item_id)                                     prio_carga
         , exp_pkg_due.fnc_ind_due('EX0028_TEMP' ,'L', fatura_id, NULL, fatura_item_id)                                doc_exp_temp
         , exp_pkg_due.fnc_ind_due('EX0026' ,'L', fatura_id, NULL, fatura_item_id)                                     prazo_exp_tmp
         , exp_pkg_due.fnc_ind_due('EX0034' ,'L', fatura_id, NULL, fatura_item_id)                                     destaque_ncm
         , exp_pkg_due.fnc_ind_due('EX0056' ,'L', fatura_id, NULL, fatura_item_id)                                     crit_typecode
         , exp_pkg_due.fnc_ind_due('EX0057' ,'L', fatura_id, NULL, fatura_item_id)                                     crit_description
         , exp_pkg_due.fnc_ind_due('EX0094' ,'L', fatura_id, NULL, fatura_item_id)                                     crit_quantidade
         , exp_pkg_due.fnc_ind_due('EX0070_EST' ,'L', fatura_id, NULL, fatura_item_id)                                 cod_un_est
         , exp_pkg_due.fnc_ind_due('EX0070_COM' ,'L', fatura_id, NULL, fatura_item_id)                                 cod_un_com
         , exp_pkg_due.fnc_ind_due('EX0071' ,'L', fatura_id, NULL, fatura_item_id)                                     descr_un_com
         , un_venda_id
      FROM (SELECT efi.fatura_id
                 , efi.fatura_item_id
                 , exp_pkg_due.fnc_ind_due('EX0032_ENQ_1' ,'L', fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      enquadramento_1
                 , exp_pkg_due.fnc_ind_due('EX0032_ENQ_2' ,'L', fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      enquadramento_2
                 , exp_pkg_due.fnc_ind_due('EX0032_ENQ_3' ,'L', fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      enquadramento_3
                 , exp_pkg_due.fnc_ind_due('EX0032_ENQ_4' ,'L', fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      enquadramento_4
                 , exp_pkg_due.fnc_ind_due('EX0019' ,'L'  , efi.fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      descricao
                 , exp_pkg_due.fnc_ind_due('EX0030' ,'D'  , efi.fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      valor_fob
                 , exp_pkg_due.fnc_ind_due('EX0031' ,'D'  , efi.fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      valor_vcv_mn
                 , exp_pkg_due.fnc_ind_due('EX0090' ,'D'  , efi.fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      valor_financiamento
                 , exp_pkg_due.fnc_ind_due('EX0025' ,'D'  , efi.fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)      peso_liquido
                 , exp_pkg_due.fnc_ind_due('EX0029_EST' ,'D'  , efi.fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)  qtde_un_est
                 , exp_pkg_due.fnc_ind_due('EX0029_COM' ,'D'  , efi.fatura_id, NULL, efi.fatura_item_id, efid.fatura_item_detalhe_id)  qtde_un_com
                 -- , exp_pkg_due.fnc_ind_due('EX0027_ADM_DOSS_TMP' ,'L', efi.fatura_id, NULL, efi.fatura_item_id)                        adm_dossie_tmp_type
                 -- , exp_pkg_due.fnc_ind_due('EX0028' ,'L', efi.fatura_id, NULL, efi.fatura_item_id)                                     adm_dossie_tmp
                 -- , exp_pkg_due.fnc_ind_due('EX0024' ,'L', efi.fatura_id, NULL, efi.fatura_item_id)                                     categoria_nrACDrw
                 -- , exp_pkg_due.fnc_ind_due('EX0023' ,'L', efi.fatura_id, NULL, efi.fatura_item_id)                                     nrACDrw
                 -- , exp_pkg_due.fnc_ind_due('EX0033' ,'L', efi.fatura_id, NULL, efi.fatura_item_id)                                     destaque_ncm_type
                 , exp_pkg_informacoes.fnc_complemento_id( cmx_pkg_tabelas.tabela_id('201','UNIDADE_VENDA')
                                                                                                  , NULL
                                                                                                  , efi.fatura_id
                                                                                                  , efi.fatura_item_id
                                                                                                  , efid.fatura_item_detalhe_id
                                                                                                  ) un_venda_id
              FROM exp_fatura_itens         efi
                 , exp_fatura_item_detalhes efid
             WHERE efid.fatura_item_id = efi.fatura_item_id
              --AND efid.nf_numero      IS NULL
              --AND efid.nf_serie       IS NULL
               AND efi.fatura_id    = pn_fatura_id
           ) tbl
  GROUP BY fatura_id
         , fatura_item_id
         , descricao
         , un_venda_id
         , enquadramento_1
         , enquadramento_2
         , enquadramento_3
         , enquadramento_4;

--  CURSOR cur_atos(pn_fatura_item_id NUMBER)
--      IS
--  SELECT DISTINCT efia.numero
--    FROM exp_vw_fatura_item_atos efia
--   WHERE efia.fatura_item_id = pn_fatura_item_id
--     AND efia.numero IS NOT NULL;

    CURSOR cur_atos(pn_fatura_item_id NUMBER)
        IS
    SELECT efia.numero
         , efia.nr_item_drawback
         , Sum(Nvl(nullif(efida.quantidade_re,0), efida.quantidade_drw))       quantidade
         --, Sum(Nvl(nullif(efidna.qtde_estatistica,0), efida.quantidade_drw))  quantidade
         , Sum(efida.valor18b)        valor
         , efia.ncm
         , efia.cnpj
      FROM exp_vw_fatura_item_atos        efia
         , exp_fatura_item_detalhe_atos   efida
         --, exp_vw_fatura_item_det_nf_ato  efidna
     WHERE efia.fatura_item_ato_id          = efida.fatura_item_ato_id
       --AND efida.fatura_item_detalhe_ato_id = efidna.fatura_item_detalhe_ato_id
       AND efia.fatura_item_id              = pn_fatura_item_id
       AND efia.numero IS NOT NULL
  GROUP BY efia.numero
         , efia.nr_item_drawback
         , efia.ncm
         , efia.cnpj
         , efida.fatura_item_ato_id;

    CURSOR cur_adoc_di(pn_fatura_item_id NUMBER)
        IS
    SELECT efid.nr_declaracao
         , ida.adicao_num
         , efid.dsi
         , ida.declaracao_adi_id
      FROM exp_vw_fatura_item_decs efid
         , imp_declaracoes_lin     idl
         , imp_declaracoes_adi     ida
     WHERE efid.fatura_item_id = pn_fatura_item_id
       AND idl.declaracao_lin_id  = efid.declaracao_lin_id
       AND idl.declaracao_adi_id  = ida.declaracao_adi_id
       AND efid.nr_declaracao IS NOT NULL
     UNION
    SELECT efiea.nr_declaracao
         , ida.adicao_num
         , idc.dsi
         , ida.declaracao_adi_id
      FROM exp_vw_fatura_item_entr_adua efiea
         , imp_declaracoes_lin     idl
         , imp_declaracoes_adi     ida
         , imp_declaracoes         idc
     WHERE efiea.fatura_item_id = pn_fatura_item_id
       AND idl.declaracao_lin_id  = efiea.declaracao_lin_id
       AND idl.declaracao_adi_id  = ida.declaracao_adi_id
       AND idl.declaracao_id      = idc.declaracao_id
       AND efiea.nr_declaracao IS NOT NULL
     UNION
    SELECT DISTINCT id.nr_declaracao
         , ida.adicao_num
         , id.dsi
         , ida.declaracao_adi_id
      FROM exp_vw_fatura_item_tr_garantia efitg
         , imp_declaracoes_lin            idl
         , imp_declaracoes                id
         , imp_declaracoes_adi     ida
     WHERE efitg.declaracao_lin_id = idl.declaracao_lin_id
       AND idl.declaracao_id       = id.declaracao_id
       AND idl.declaracao_adi_id  = ida.declaracao_adi_id
       AND id.nr_declaracao IS NOT NULL
       AND efitg.fatura_item_id    = pn_fatura_item_id
   /*UNION
  SELECT DISTINCT id.nr_declaracao
    FROM exp_vw_fat_item_embalagem_ret efitg
       , imp_declaracoes_lin            idl
       , imp_declaracoes                id
   WHERE efitg.invoice_lin_id = idl.invoice_lin_id
     AND idl.declaracao_id       = id.declaracao_id
     AND id.nr_declaracao IS NOT NULL
     AND efitg.fatura_item_id    = pn_fatura_item_id*/;

  CURSOR cur_proc_adm(pn_declaracao_adi_id NUMBER)
  IS
  SELECT rcr.processo_numero
    FROM imp_adm_temp_rcr_lin rcr_lin
       , imp_adm_temp_rcr     rcr
       , imp_declaracoes_lin  idl
   WHERE rcr_lin.invoice_lin_id  = idl.invoice_lin_id
     AND rcr_lin.rcr_id          = rcr.rcr_id
     AND rcr.processo_numero    IS NOT NULL
     AND idl.declaracao_adi_id  = pn_declaracao_adi_id
  UNION
 SELECT rat.processo_numero
   FROM imp_adm_temp_rat_lin rat_lin
      , imp_adm_temp_rat     rat
      , imp_declaracoes_lin  idl
  WHERE rat_lin.invoice_lin_id  = idl.invoice_lin_id
    AND rat_lin.rat_id          = rat.rat_id
    AND rat.processo_numero IS NOT NULL
    AND idl.declaracao_adi_id  = pn_declaracao_adi_id;


  CURSOR cur_atrib(pc_ncm VARCHAR2, pc_destaque VARCHAR2)
      IS
  SELECT etna.codigo
    FROM cmx_tab_ncm_atributos  etna
       , cmx_tab_ncm_atr_compl  etnac
   WHERE etna.ncm_atributo_id = etnac.ncm_atributo_id
     AND etnac.tipo   = 'DO'
     AND etna.ncm     = pc_ncm
     AND etnac.codigo = pc_destaque;

  CURSOR cur_comissao_repre(pn_fat_item_id NUMBER) IS
    SELECT Sum(percentual) percentual
      FROM exp_fatura_item_representantes
      WHERE fatura_item_id = pn_fat_item_id;

  CURSOR cur_ato_enq(pn_fat_item_id NUMBER) IS
    SELECT cmx_pkg_tabelas.codigo(drd.enquadramento_id) enquadramento
      FROM exp_fatura_item_atos   efia
         , drw_registro_drawback  drd
     WHERE efia.rd_id = drd.rd_id
       AND drd.enquadramento_id IS NOT NULL
       AND efia.fatura_item_id = pn_fat_item_id;

  CURSOR cur_atrib_ativo(pc_ncm VARCHAR2)
      IS
  SELECT DISTINCT etna.codigo
        , etna.ncm_atributo_id
        , Nvl(etna.formula, tipo.formula) formula
        , Upper(tipo.nomeapresentacao)    nomeapresentacao
    FROM cmx_tab_ncm_atributos        etna
       , cmx_tab_ncm_atributos_tipo   tipo
    WHERE etna.ncm_atr_tipo_id = tipo.ncm_atr_tipo_id
      AND etna.ncm             = pc_ncm
      AND Nvl(etna.ativo, 'S') = 'S'
      AND etna.modalidade = 'EXPORTAÇÃO';

    CURSOR cur_fat_item_info(pn_fatura_item_id NUMBER)
        IS
    SELECT efi.item_id
         , efi.ncm_id
         , decode ( efi.codigo
                  , NULL
                  , efi.un_medida_id
                  , exp_pkg_pesquisa.un_medida_id ( efi.item_id
                                                  , efi.organizacao_id
                                                  )
                  )           unidade_de_id
         , ctn.un_medida_id   unidade_para_id
      FROM exp_fatura_itens efi
         , cmx_tab_ncm      ctn
     WHERE efi.ncm_id          =  ctn.ncm_id (+)
       AND efi.fatura_item_id  =  pn_fatura_item_id;

    CURSOR cur_enq_sem_di(pn_due_ship_item_id NUMBER)
        IS
    SELECT Max(Upper(Nvl(ct.auxiliar6,'S'))) enq_sem_di
      FROM cmx_tabelas ct
         , exp_due_si_enq edie
     WHERE ct.codigo = edie.enquadramento
       AND edie.due_ship_item_id = pn_due_ship_item_id;

    CURSOR cur_ver_enq(pn_due_ship_item_id NUMBER, pc_enquadramento VARCHAR2)
        IS
    SELECT due_si_enq_id
      FROM exp_due_si_enq
     WHERE due_ship_item_id = pn_due_ship_item_id
       AND enquadramento = pc_enquadramento;

    vr_fat_item_info      cur_fat_item_info%ROWTYPE;
    vn_due_ship_item_id   NUMBER;
    vn_fatura_snf_item    NUMBER;
    vc_atrib_code         VARCHAR2(150);
    vn_per_comissao       NUMBER;
    vc_enquadramento      VARCHAR2(20);
    vb_achou              BOOLEAN;
    vc_destaque           VARCHAR2(150);
    vn_qtde_estatistica   NUMBER;
    vn_due_si_adoc_id     NUMBER;
    vc_enq_sem_di         VARCHAR2(1);
    vn_due_si_enq_id      NUMBER;
    vn_vlr_financiamento  NUMBER;
  BEGIN
    FOR x IN cur_i_snf
    LOOP
      vn_fatura_snf_item := vn_fatura_snf_item +1;
      pn_itens_due := pn_itens_due + 1;

      --Quantidade estatistica
      OPEN cur_fat_item_info(x.fatura_item_id);
      FETCH cur_fat_item_info INTO vr_fat_item_info;
      CLOSE cur_fat_item_info;

      IF Nvl( x.qtde_un_est , 0 ) = 0 THEN

        BEGIN
          vn_qtde_estatistica := cmx_pkg_itens.fnc_conv_qtde_um(
                                                        nvl( x.un_venda_id
                                                          ,  vr_fat_item_info.unidade_de_id
                                                          )
                                                      , vr_fat_item_info.unidade_para_id
                                                      , vr_fat_item_info.item_id
                                                      , x.qtde_un_com
                                                      , x.peso_liquido
                                                      , vr_fat_item_info.ncm_id
                                                      );
        EXCEPTION
          WHEN OTHERS THEN
            vn_qtde_estatistica := 0;
        END;
      ELSE
          vn_qtde_estatistica :=  x.qtde_un_est ;
      END IF ;

      IF( Nvl(x.valor_financiamento,0) > 0 AND
          ( (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_1,'-99999')),7),'N') = 'S') OR
            (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_2,'-99999')),7),'N') = 'S') OR
            (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_3,'-99999')),7),'N') = 'S') OR
            (Nvl(cmx_pkg_tabelas.auxiliar(cmx_pkg_tabelas.tabela_id('211', Nvl(x.enquadramento_4,'-99999')),7),'N') = 'S')
          )
        ) THEN
        vn_vlr_financiamento := x.valor_financiamento;
      ELSE
        vn_vlr_financiamento := NULL;
      END IF;

      vn_due_ship_item_id := cmx_fnc_proxima_sequencia('exp_due_ship_item_sq1');
      INSERT INTO exp_due_ship_item
      (
        due_id
      , due_ship_id
      , due_ship_item_id
      , customsvalue
      , sequence
      , cmmdty_description
      , cmmdty_value
      , cmmdty_commercial_descr
      , cmmdty_line_sequence
      , cmmdty_gs_netweight
      , cmmdty_gs_tariff
      , cmmdty_gs_cod_com
      , cmmdty_gs_umed_com
      , cmmdty_gs_cod_est
      , cmmdty_gs_tariff_est
      , ncm
      , creation_date
      , created_by
      , last_update_date
      , last_updated_by
      , financedvalue
      , fatura_item_temp_id
      ) VALUES (
                 pn_due_id
               , pn_due_ship_id
               , vn_due_ship_item_id
               , x.valor_fob
               , pn_itens_due
               , SubStr(x.descricao, 1, 4000)
               , x.valor_vcv_mn
               , SubStr(x.descricao_comercial, 1, 256)
               , vn_fatura_snf_item
               , x.peso_liquido
               , x.qtde_un_com
               , x.cod_un_com
               , x.descr_un_com
               , x.cod_un_est
               , vn_qtde_estatistica -- x.qtde_un_est
               , x.ncm
               , SYSDATE
               , pn_usuario_id
               , SYSDATE
               , pn_usuario_id
               , vn_vlr_financiamento
               , x.fatura_item_id
               );

      INSERT INTO exp_due_si_dest
      (
        due_si_dest_id
      , due_ship_item_id
      , countrycode
      , gm_tariffquantity
      , creation_date
      , created_by
      , last_update_date
      , last_updated_by
      ) VALUES (
                  cmx_fnc_proxima_sequencia('exp_due_si_dest_sq1')
                , vn_due_ship_item_id
                , x.pais_destino
                , vn_qtde_estatistica --x.qtde_un_est
                , SYSDATE
                , pn_usuario_id
                , SYSDATE
                , pn_usuario_id
               );


      IF x.codigo_produto IS NOT NULL THEN
        INSERT INTO  exp_due_si_prod
        (
          due_si_prod_id
        , due_ship_item_id
        , identification
        , identifiertypecode
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        ) VALUES (
                   cmx_fnc_proxima_sequencia('exp_due_si_prod_sq1')
                 , vn_due_ship_item_id
                 , x.codigo_produto
                 , x.codigo_produto_type
                 , SYSDATE
                 , pn_usuario_id
                 , SYSDATE
                 , pn_usuario_id
                 );
      END IF;

      IF x.crit_typecode IS NOT NULL THEN
        INSERT INTO  exp_due_si_crit
        (
          due_si_crit_id
        , due_ship_item_id
        , description
        , typecode
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        , quantityquantity
        ) VALUES (
                   cmx_fnc_proxima_sequencia('exp_due_si_crit_sq1')
                 , vn_due_ship_item_id
                 , x.crit_description
                 , x.crit_typecode
                 , SYSDATE
                 , pn_usuario_id
                 , SYSDATE
                 , pn_usuario_id
                 , x.crit_quantidade
                 );
      END IF;


--      vc_enq_sem_di := NULL;
--      vc_enquadramento := NULL;
--      OPEN cur_ato_enq (x.fatura_item_id);
--      FETCH cur_ato_enq INTO vc_enquadramento;
--      CLOSE cur_ato_enq;

--      IF vc_enquadramento IS NOT NULL THEN
--        INSERT INTO exp_due_si_enq
--        (
--          due_si_enq_id
--        , due_ship_item_id
--        , enquadramento
--        , creation_date
--        , created_by
--        , last_update_date
--        , last_updated_by
--        ) VALUES (
--                   cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
--                 , vn_due_ship_item_id
--                 , vc_enquadramento
--                 , SYSDATE
--                 , pn_usuario_id
--                 , SYSDATE
--                 , pn_usuario_id
--                 );
--      ELSE

        IF ( x.enquadramento_1 IS NOT NULL) THEN

          vb_achou := FALSE;
          OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_1);
          FETCH cur_ver_enq INTO vn_due_si_enq_id;
          vb_achou := cur_ver_enq%FOUND;
          CLOSE cur_ver_enq;

          IF NOT(vb_achou) THEN
            INSERT INTO exp_due_si_enq
            (
              due_si_enq_id
            , due_ship_item_id
            , enquadramento
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                    , vn_due_ship_item_id
                    , x.enquadramento_1
                    , SYSDATE
                    , pn_usuario_id
                    , SYSDATE
                    , pn_usuario_id
                    );
          END IF;
        END IF;

        IF ( x.enquadramento_2 IS NOT NULL) THEN

          vb_achou := FALSE;
          OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_2);
          FETCH cur_ver_enq INTO vn_due_si_enq_id;
          vb_achou := cur_ver_enq%FOUND;
          CLOSE cur_ver_enq;

          IF NOT(vb_achou) THEN

            INSERT INTO exp_due_si_enq
            (
              due_si_enq_id
            , due_ship_item_id
            , enquadramento
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                    , vn_due_ship_item_id
                    , x.enquadramento_2
                    , SYSDATE
                    , pn_usuario_id
                    , SYSDATE
                    , pn_usuario_id
                    );

          END IF;
        END IF;

        IF ( x.enquadramento_3 IS NOT NULL) THEN

          vb_achou := FALSE;
          OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_3);
          FETCH cur_ver_enq INTO vn_due_si_enq_id;
          vb_achou := cur_ver_enq%FOUND;
          CLOSE cur_ver_enq;

          IF NOT(vb_achou) THEN
            INSERT INTO exp_due_si_enq
            (
              due_si_enq_id
            , due_ship_item_id
            , enquadramento
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                    , vn_due_ship_item_id
                    , x.enquadramento_3
                    , SYSDATE
                    , pn_usuario_id
                    , SYSDATE
                    , pn_usuario_id
                    );
          END IF;
        END IF;

        IF ( x.enquadramento_4 IS NOT NULL) THEN

          vb_achou := FALSE;
          OPEN  cur_ver_enq(vn_due_ship_item_id, x.enquadramento_4);
          FETCH cur_ver_enq INTO vn_due_si_enq_id;
          vb_achou := cur_ver_enq%FOUND;
          CLOSE cur_ver_enq;

          IF NOT(vb_achou) THEN

            INSERT INTO exp_due_si_enq
            (
              due_si_enq_id
            , due_ship_item_id
            , enquadramento
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                      cmx_fnc_proxima_sequencia('exp_due_si_enq_sq1')
                    , vn_due_ship_item_id
                    , x.enquadramento_4
                    , SYSDATE
                    , pn_usuario_id
                    , SYSDATE
                    , pn_usuario_id
                    );
          END IF;

        END IF;
--      END IF;

      FOR attr IN cur_atrib_ativo(x.ncm) LOOP
        vc_destaque   := NULL;

        IF(attr.formula IS NOT NULL) THEN
          prc_busca_atributo_ncm( pn_due_id
                                , vn_due_ship_item_id
                                , x.ncm
                                , attr.ncm_atributo_id
                                , attr.formula
                                , vc_destaque
                                );
        END IF;

        IF(attr.nomeapresentacao  = 'DESTAQUE' AND vc_destaque IS NULL) THEN
          vc_destaque := x.destaque_ncm;
        END IF;

        -- EX0033
        INSERT INTO exp_due_si_char
        (
          due_si_char_id
        , due_ship_item_id
        , typecode
        , description
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        ) VALUES (
                    cmx_fnc_proxima_sequencia('exp_due_si_char_sq1')
                  , vn_due_ship_item_id
                  , attr.codigo  --x.destaque_ncm_type
                  , vc_destaque
                  , SYSDATE
                  , pn_usuario_id
                  , SYSDATE
                  , pn_usuario_id
                  );
      END LOOP;

/*
      IF (x.destaque_ncm IS NOT NULL) THEN
        -- EX0033
        vc_atrib_code := NULL;
        OPEN cur_atrib(x.ncm, x.destaque_ncm);
        FETCH cur_atrib INTO vc_atrib_code;
        CLOSE cur_atrib;

        INSERT INTO exp_due_si_char
        (
          due_si_char_id
        , due_ship_item_id
        , typecode
        , description
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        ) VALUES (
                   cmx_fnc_proxima_sequencia('exp_due_si_char_sq1')
                 , vn_due_ship_item_id
                 , vc_atrib_code -- x.destaque_ncm_type
                 , x.destaque_ncm
                 , SYSDATE
                 , pn_usuario_id
                 , SYSDATE
                 , pn_usuario_id
                 );
      END IF;
*/
      --prio_carga
      --adm_dossie_tmp
      --prazo_exp_tmp
      IF (x.prazo_exp_tmp IS NOT NULL) THEN
        INSERT INTO exp_due_gs_item_add_info
        (
          due_gsi_add_info_id
        , due_ship_item_id
        , statementcode
        , statementdescription
        , limitdatetime
        , statementtypecode
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        ) VALUES (
                   cmx_fnc_proxima_sequencia('exp_due_gsi_add_info_sq1')
                 , vn_due_ship_item_id
                 , NULL            --x.prio_carga
                 , SubStr(x.doc_exp_temp, 1, 4000)  --statementdescription
                 , x.prazo_exp_tmp --limitdatetime
                 , x.prazo_exp_tmp_type
                 , SYSDATE
                 , pn_usuario_id
                 , SYSDATE
                 , pn_usuario_id
                 );
      END IF;

      IF (x.prio_carga IS NOT NULL) THEN
        INSERT INTO exp_due_gs_item_add_info
        (
          due_gsi_add_info_id
        , due_ship_item_id
        , statementcode
        , statementdescription
        , limitdatetime
        , statementtypecode
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        ) VALUES (
                   cmx_fnc_proxima_sequencia('exp_due_gsi_add_info_sq1')
                 , vn_due_ship_item_id
                 , x.prio_carga
                 , NULL --statementdescription
                 , NULL --limitdatetime
                 , x.prio_carga_type
                 , SYSDATE
                 , pn_usuario_id
                 , SYSDATE
                 , pn_usuario_id
                 );
      END IF;

--      IF (x.adm_dossie_tmp IS NOT NULL) THEN
--        INSERT INTO exp_due_gs_item_add_info
--        (
--          due_gsi_add_info_id
--        , due_ship_item_id
--        , statementcode
--        , statementdescription
--        , limitdatetime
--        , statementtypecode
--        , creation_date
--        , created_by
--        , last_update_date
--        , last_updated_by
--        ) VALUES (
--                   cmx_fnc_proxima_sequencia('exp_due_gsi_add_info_sq1')
--                 , vn_due_ship_item_id
--                 , x.adm_dossie_tmp
--                 , NULL --statementdescription
--                 , NULL --limitdatetime
--                 , x.adm_dossie_tmp_type
--                 , SYSDATE
--                 , pn_usuario_id
--                 , SYSDATE
--                 , pn_usuario_id
--                 );
--      END IF;

--      FOR ato IN cur_atos(x.fatura_item_id)
--      LOOP
--        INSERT INTO exp_due_si_adoc
--        (
--          due_si_adoc_id
--        , due_ship_item_id
--        , identification
--        , category
--        , creation_date
--        , created_by
--        , last_update_date
--        , last_updated_by
--        ) VALUES (
--                   cmx_fnc_proxima_sequencia('exp_due_si_adoc_sq1')
--                 , vn_due_ship_item_id
--                 , ato.numero
--                 , exp_pkg_due.fnc_ind_due('EX0024' ,'L', x.fatura_id, NULL , x.fatura_item_id)
--                 , SYSDATE
--                 , pn_usuario_id
--                 , SYSDATE
--                 , pn_usuario_id
--                 );
--      END LOOP;

--      Retirado rotina de drawback, pois quando o embarque for do tipo antecipado não pode enviar esses dados
--      /*
--      EX0075 ItemID
--      EX0076 QuantityQuantity
--      EX0077 ValueWithExchangeCoverAmount
--      EX0078 ValueWithoutExchangeCoverAmount
--      EX0083 DrawbackHsClassification
--      EX0084 DrawbackRecipientId
--      */
--      FOR ato IN cur_atos(x.fatura_item_id)
--      LOOP
--        INSERT INTO exp_due_si_adoc
--        (
--          due_si_adoc_id
--        , due_ship_item_id
--        , identification
--        , category
--        , creation_date
--        , created_by
--        , last_update_date
--        , last_updated_by
--        , itemid
--        , quantity
--        , vlrwithexcoveramount
--        , vlrwithoutexcoveramount
--        , drawbackhsclassification
--        , drawbackrecipientid
--        ) VALUES (
--                   cmx_fnc_proxima_sequencia('exp_due_si_adoc_sq1')
--                 , vn_due_ship_item_id
--                 , ato.numero
--                 , exp_pkg_due.fnc_ind_due('EX0024' ,'L', x.fatura_id, NULL , x.fatura_item_id)
--                 , SYSDATE
--                 , pn_usuario_id
--                 , SYSDATE
--                 , pn_usuario_id
--                 , ato.nr_item_drawback
--                 , ato.quantidade
--                 , ato.valor
--                 , 0
--                 , ato.ncm
--                 , ato.cnpj
--                 );
--      END LOOP;

      OPEN cur_enq_sem_di(vn_due_ship_item_id);
      FETCH cur_enq_sem_di INTO vc_enq_sem_di;
      CLOSE cur_enq_sem_di;

      IF Upper(Nvl(vc_enq_sem_di,'S')) = 'S' THEN


        FOR adoc IN cur_adoc_di(x.fatura_item_id)
        LOOP
          vn_due_si_adoc_id :=   cmx_fnc_proxima_sequencia('exp_due_si_adoc_sq1');
          INSERT INTO exp_due_si_adoc
          (
            due_si_adoc_id
          , due_ship_item_id
          , identification
          , category
          , itemid
          , quantity
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          ) VALUES (
                     vn_due_si_adoc_id
                   , vn_due_ship_item_id
                   , adoc.nr_declaracao
                   , exp_pkg_due.fnc_ind_due(Decode(Nvl(adoc.dsi,'N')
                                                     , 'N', 'EX0024_DI'
                                                     , 'S', 'EX0024_DSI') ,'L', x.fatura_id, NULL , x.fatura_item_id)
                   , adoc.adicao_num
                   , vn_qtde_estatistica --x.qtde_un_est
                   , SYSDATE
                   , pn_usuario_id
                   , SYSDATE
                   , pn_usuario_id
                   );

          FOR proc_adm IN cur_proc_adm(adoc.declaracao_adi_id)
          LOOP
            INSERT INTO exp_due_si_adoc_add_info
            (
              due_gs_add_info_id
            , due_si_adoc_id
            , statementtypecode
            , statementdescription
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            ) VALUES (
                     cmx_fnc_proxima_Sequencia('exp_due_si_adoc_add_info_sq1')
                     , vn_due_si_adoc_id
                     , 'ABC'
                     , proc_adm.processo_numero
                     , SYSDATE
                     , pn_usuario_id
                     , SYSDATE
                     , pn_usuario_id
                     );
          END LOOP;

        END LOOP;
      END IF;

      /*EX0073 e EX0074 -> TIPO = 149*/
      vn_per_comissao := 0;
      OPEN  cur_comissao_repre(x.fatura_item_id);
      FETCH cur_comissao_repre INTO vn_per_comissao;
      CLOSE cur_comissao_repre;

      IF(Nvl(vn_per_comissao,0) > 0) THEN
        INSERT INTO exp_due_ship_item_adj ( due_si_adj_id
                                          , due_ship_item_id
                                          , additioncode
                                          , percentage
                                          , creation_date
                                          , created_by
                                          , last_update_date
                                          , last_updated_by
                                          )
                                   VALUES ( cmx_fnc_proxima_sequencia('exp_due_ship_item_adj_sq1')
                                          , vn_due_ship_item_id
                                          , '149'
                                          , vn_per_comissao
                                          , SYSDATE
                                          , pn_usuario_id
                                          , SYSDATE
                                          , pn_usuario_id
                                          );
      END IF;

    END LOOP;
  END prc_gs_i_snf;

  FUNCTION fnc_xml_table(pn_due_id       NUMBER)
  RETURN NUMBER
  AS
    CURSOR cur_nls
    IS
    SELECT nsp.value  valor
    FROM nls_session_parameters nsp
    WHERE nsp.parameter='NLS_NUMERIC_CHARACTERS';

    vc_xml CLOB;
    vn_indice PLS_INTEGER := 1;
    vn_pos    NUMBER      := 1;
    vn_amt    NUMBER;
    vc_valor VARCHAR2(100);

  BEGIN
    OPEN cur_nls;
    FETCH cur_nls INTO vc_valor;
    CLOSE cur_nls;

    vt_xml.DELETE;
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=''.,''';
    vc_xml := fnc_xml_due(pn_due_id).extract('*').getclobval();
    EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS=''' || vc_valor || '''';
    vn_amt := Dbms_Lob.InStr(vc_xml, Chr(10));
    IF vn_amt > 0 THEN

      LOOP
        vt_xml(vn_indice) := Dbms_Lob.SubStr(vc_xml, vn_amt - vn_pos, vn_pos);
        vn_pos := vn_amt + 1;
        vn_amt := Dbms_Lob.InStr(vc_xml, Chr(10), vn_pos);
        vn_indice := vn_indice + 1;
      EXIT WHEN vn_amt < 1;
      END LOOP;

    ELSE
      vt_xml(vn_indice) := vc_xml;

    END IF;
    RETURN vn_indice - 1;
  END fnc_xml_table;

  FUNCTION fnc_clob_base64 (
     pclob_texto_xml   IN  CLOB
   , pc_charset        IN VARCHAR2 DEFAULT 'UTF8'
  )
  RETURN CLOB
  IS

    vblob_arq_utf8      BLOB;
    vblob_arq_destino   BLOB;
    vblob_arq_aux       BLOB;
    vc_aux              CLOB;
    vclob_arq_origem    CLOB;

    vn_tmp_blob_id      NUMBER;

    vn_tamanho_arq_utf8 PLS_INTEGER    := 0;
    vbi_amt             BINARY_INTEGER := 10800 /*16384*/;
    vn_pos              INTEGER;
    vn_tam_max          NUMBER := null;
    vc_buf              VARCHAR2(32767);
    vr_buf              RAW(32767);

    vc_nome_arq         VARCHAR2(256) := null;
    vc_ultimo_passo     VARCHAR2(4000);

    vb_log              BOOLEAN := FALSE;

    vn_lang_context     number := dbms_lob.default_lang_ctx;
    vn_warning          NUMBER;
    vn_dest_offset      NUMBER :=1;
    vn_src_offset       NUMBER :=1;
    vn_mod              NUMBER :=0;

    vc_charset          VARCHAR2(150);

    CURSOR cur_charset
        IS
    SELECT value
      FROM v$nls_parameters
     WHERE parameter='NLS_CHARACTERSET';

  BEGIN
    vn_pos := 1;
    vc_charset := NULL;
    OPEN cur_charset;
    FETCH cur_charset INTO vc_charset;
    CLOSE cur_charset;

    vclob_arq_origem := pclob_texto_xml;

    dbms_lob.createtemporary (vblob_arq_destino, true);

    Dbms_Lob.createtemporary(vblob_arq_aux,TRUE);

    Dbms_Lob.convertToBlob(vblob_arq_aux,
                           vclob_arq_origem,
                           Length(vclob_arq_origem),
                           vn_dest_offset,
                           vn_src_offset,
                           nls_charset_id(pc_charset),
                           vn_lang_context,
                           vn_warning);
                           Dbms_Output.put_line(Dbms_Lob.getLength(vblob_arq_aux));

    dbms_lob.createtemporary (vblob_arq_utf8, true);

    dbms_lob.open (vblob_arq_utf8, dbms_lob.lob_readwrite);

    dbms_lob.createtemporary (vblob_arq_destino, true);

    dbms_lob.open (vblob_arq_destino, dbms_lob.lob_readwrite);

    vn_tam_max := dbms_lob.getlength (vblob_arq_aux);

    LOOP

      IF (vn_pos >= vn_tam_max) THEN

        EXIT;
      END IF;

      vn_pos := least (vn_pos, vn_tam_max);
      vr_buf := '';

      dbms_lob.read (vblob_arq_aux, vbi_amt, vn_pos, vr_buf);

      dbms_lob.writeappend (
         vblob_arq_utf8
       , utl_raw.length (vr_buf)
       , vr_buf
      );

      vr_buf := utl_encode.base64_encode (vr_buf);

      dbms_lob.writeappend (
         vblob_arq_destino
       , utl_raw.length (vr_buf)
       , vr_buf
      );

      vn_mod := Mod(Utl_Raw.Length(vr_buf),4) ;

      vn_pos := vn_pos + vbi_amt;

    END LOOP;

    IF vn_mod <> 0 THEN
      vn_mod := 4 - vn_mod;
      Dbms_Lob.writeappend( vblob_arq_destino
                          , vn_mod
                          , Utl_Raw.cast_to_raw(LPad('=', vn_mod, '='))
                          );
    END IF;

    vn_tamanho_arq_utf8 := dbms_lob.getlength (vblob_arq_utf8);

    vn_dest_offset := 1;
    vn_src_offset := 1;
    Dbms_Lob.convertToClob(vclob_arq_origem,
                           vblob_arq_destino,
                           Dbms_Lob.getLength(vblob_arq_destino),
                           vn_dest_offset,
                           vn_src_offset,
                           nls_charset_id(pc_charset),
                           vn_lang_context,
                           vn_warning);


    dbms_lob.close (vblob_arq_utf8);
    dbms_lob.close (vblob_arq_destino);

    dbms_lob.freetemporary (vblob_arq_utf8);
    dbms_lob.freetemporary (vblob_arq_destino);
    dbms_lob.freetemporary (vblob_arq_aux);

    RETURN vclob_arq_origem;

  EXCEPTION
    WHEN OTHERS THEN

      RETURN null;

  END fnc_clob_base64;

  FUNCTION fnc_base64_clob (
     pclob_texto_xml   IN  CLOB
   , pc_charset        IN VARCHAR2 DEFAULT 'UTF8'
  )
  RETURN CLOB
  IS

    vblob_arq_utf8      BLOB;
    vblob_arq_destino   BLOB;
    vblob_arq_aux       BLOB;
    vc_aux              CLOB;
    vclob_arq_origem    CLOB;

    vn_tmp_blob_id      NUMBER;

    vn_tamanho_arq_utf8 PLS_INTEGER    := 0;
    vbi_amt             BINARY_INTEGER := 10800 /*16384*/;
    vn_pos              INTEGER;
    vn_tam_max          NUMBER := null;
    vc_buf              VARCHAR2(32767);
    vr_buf              RAW(32767);

    vc_nome_arq         VARCHAR2(256) := null;
    vc_ultimo_passo     VARCHAR2(4000);

    vb_log              BOOLEAN := FALSE;

    vn_lang_context     number := dbms_lob.default_lang_ctx;
    vn_warning          NUMBER;
    vn_dest_offset      NUMBER :=1;
    vn_src_offset       NUMBER :=1;
    vn_offset           NUMBER :=1;

    vc_charset          VARCHAR2(150);
    vc_decodeline       VARCHAR2(32000);
    vr_buffer_raw       RAW(32000);
    vn_linesize         NUMBER;

    CURSOR cur_charset
        IS
    SELECT value
      FROM v$nls_parameters
     WHERE parameter='NLS_CHARACTERSET';

  BEGIN
    vn_pos := 1;
    vc_charset := NULL;
    OPEN cur_charset;
    FETCH cur_charset INTO vc_charset;
    CLOSE cur_charset;

    vclob_arq_origem := pclob_texto_xml;

--    vn_linesize := Dbms_Lob.InStr(pclob_texto_xml,Chr(10));
--    Dbms_Output.put_line(vn_linesize);
--    IF vn_linesize > 0 THEN
--      vn_linesize := vn_linesize;
--    ELSE
--      vn_linesize := 128;
--    END IF;

    vn_linesize := 2048;

    dbms_lob.createtemporary(vblob_arq_destino, true);

    vn_offset := 1;

    FOR i in 1 .. ceil(dbms_lob.getlength(pclob_texto_xml) / vn_linesize)
    LOOP
      dbms_lob.read(pclob_texto_xml, vn_linesize, vn_offset, vc_decodeline);
      Dbms_Output.put_line(i || '-' || vc_decodeline);
      vr_buffer_raw := utl_raw.cast_to_raw(vc_decodeline);
      vr_buffer_raw := utl_encode.base64_decode(vr_buffer_raw);
      dbms_lob.writeappend(vblob_arq_destino, utl_raw.length(vr_buffer_raw), vr_buffer_raw);
      vn_offset := vn_offset + vn_linesize;
    END LOOP;

    dbms_lob.createtemporary(vclob_arq_origem, true);
    vn_dest_offset := 1;
    vn_src_offset := 1;
    Dbms_Lob.convertToClob(vclob_arq_origem,
                           vblob_arq_destino,
                           Dbms_Lob.getLength(vblob_arq_destino),
                           vn_dest_offset,
                           vn_src_offset,
                           nls_charset_id(pc_charset),
                           vn_lang_context,
                           vn_warning);

    dbms_lob.freetemporary (vblob_arq_destino);

    RETURN vclob_arq_origem;
  END fnc_base64_clob;

  FUNCTION fnc_xml_table_clob_base64(pc_clob clob)
  RETURN NUMBER
  AS
    vc_xml    CLOB;
    vc_xml2   CLOB;
    vn_indice PLS_INTEGER := 1;
    vn_pos    NUMBER      := 1;
    vn_amt    NUMBER;
  BEGIN
    vt_xml_b64.DELETE;

    vc_xml2 := pc_clob;
    vc_xml := fnc_clob_base64(vc_xml2);
    vn_amt := Dbms_Lob.InStr(vc_xml, Chr(10));
    IF vn_amt > 0 THEN

      LOOP
        vt_xml_b64(vn_indice) := Dbms_Lob.SubStr(vc_xml, vn_amt - vn_pos, vn_pos);
        vn_pos := vn_amt + 1;
        vn_amt := Dbms_Lob.InStr(vc_xml, Chr(10), vn_pos);
        vn_indice := vn_indice + 1;

      EXIT WHEN vn_amt < 1;
      END LOOP;
      IF vn_pos < Length(vc_xml) THEN
        vt_xml_b64(vn_indice) := Dbms_Lob.SubStr(vc_xml, Length(vc_xml) - vn_pos, vn_pos);
        vn_indice := vn_indice + 1;
      END IF;

    ELSE
      vt_xml_b64(vn_indice) := vc_xml;

    END IF;
    RETURN vn_indice - 1;
  END;

  FUNCTION fnc_xml_table_base64(pn_due_id       NUMBER)
  RETURN NUMBER
  AS
    vc_xml    CLOB;
    vc_xml2   CLOB;
    vn_indice PLS_INTEGER := 1;
    vn_pos    NUMBER      := 1;
    vn_amt    NUMBER;
  BEGIN

    --Limpando flag_justificativa
    UPDATE exp_due_ship_item SET flag_justificativa = 'N'
                           WHERE due_id = pn_due_id;
    COMMIT;

    vc_xml2 := fnc_xml_due(pn_due_id).extract('*').getclobval();

    RETURN fnc_xml_table_clob_base64(vc_xml2);

  END fnc_xml_table_base64;

  FUNCTION fnc_xml_line(pn_linha         NUMBER)
  RETURN VARCHAR2
  AS
  BEGIN
    RETURN vt_xml(pn_linha);
  END fnc_xml_line;

  FUNCTION fnc_xml_line_base64(pn_linha         NUMBER)
  RETURN VARCHAR2
  AS
  BEGIN
    RETURN vt_xml_b64(pn_linha);
  END fnc_xml_line_base64;

  FUNCTION fnc_valida_due(pn_due_id NUMBER, pn_evento_id NUMBER ) RETURN NUMBER
  AS

    CURSOR cur_dados
        IS
    SELECT fatura_id
         , embarque_id
         , fatura_numero
         , fatura_ano
         , empresa_id
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         --, importer_name
         , importer_addr_country
         --, importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type
         , motivo_dispensa_nf
      FROM (SELECT ef.fatura_id
                , ef.embarque_id
                , ef.fatura_numero
                , ef.fatura_ano
                , ef.empresa_id
                , exp_pkg_due.fnc_ind_due('EX0010' ,'F', ef.fatura_id )         doffice_identification
                , NVL( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                     , exp_pkg_due.fnc_ind_due('EX0037_CNPJ' ,'F', ef.fatura_id ))         whs_identification
                , Decode( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                        , NULL
                        , '22'
                        , '281'
                        )                                                       whs_type
                , exp_pkg_due.fnc_ind_due('EX0063' ,'F', ef.fatura_id )         whs_latitude
                , exp_pkg_due.fnc_ind_due('EX0064' ,'F', ef.fatura_id )         whs_longitude
                , exp_pkg_due.fnc_ind_due('EX0062' ,'F', ef.fatura_id )         whs_addr_line
                , exp_pkg_due.fnc_ind_due('EX0039' ,'F', ef.fatura_id )         currencytype
                , exp_pkg_due.fnc_ind_due('EX0011' ,'F', ef.fatura_id )         exitoffice_identification
                , exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )         exitoffice_whs_identification
                , Decode( exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )
                        , NULL
                        , '22'
                        , '281'
                        )                                                       exitoffice_whs_type
                --, exp_pkg_due.fnc_ind_due('EX0008' ,'F', ef.fatura_id )         importer_name
                , exp_pkg_due.fnc_ind_due('EX0009' ,'F', ef.fatura_id )         importer_addr_country
                --, exp_pkg_due.fnc_ind_due('EX0036' ,'F', ef.fatura_id )         importer_addr_line
                , exp_pkg_due.fnc_ind_due('EX0040_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao
                , exp_pkg_due.fnc_ind_due('EX0041_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao_type
                , exp_pkg_due.fnc_ind_due('EX0040_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial
                , exp_pkg_due.fnc_ind_due('EX0041_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial_type
                , exp_pkg_due.fnc_ind_due('EX0040_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte
                , exp_pkg_due.fnc_ind_due('EX0041_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte_type
                , exp_pkg_due.fnc_ind_due('EX0042_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais
                , exp_pkg_due.fnc_ind_due('EX0041_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais_type
                , exp_pkg_due.fnc_ind_due('EX0067' ,'F', ef.fatura_id )         motivo_dispensa_nf
              FROM exp_faturas ef
                , exp_due_faturas edft
            WHERE ef.fatura_id = edft.fatura_id
              AND edft.due_id = pn_due_id
           ) tbl
  ORDER BY fatura_ano
         , fatura_numero
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         --, importer_name
         , importer_addr_country
         --, importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type
         , motivo_dispensa_nf;

    vr_fat_ant cur_dados%ROWTYPE;
    vb_erro              BOOLEAN;
    vn_due_id            NUMBER;
    vn_criacao           NUMBER;

  BEGIN
    -- verifica se alguma fatura tem informação divergente das demais.
    vr_fat_ant := NULL;
    vb_erro    := FALSE;

    FOR x IN cur_dados
    LOOP
      exp_prc_criar_due_hook1(pn_evento_id, x.fatura_id);
      --IF x.doffice_identification IS NULL THEN
      --  cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ sem local de despacho preenchido.', 'EXP_PKG_DUE','FNC_GERAR_DUE_001',null,x.fatura_numero || '/' || x.fatura_ano),'E');
      --  vb_erro := TRUE;
      --END IF;

      IF vr_fat_ant.fatura_id IS NOT NULL THEN
        IF Nvl(x.doffice_identification       ,'-!-!-!')  <> Nvl(vr_fat_ant.doffice_identification       ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_002',null,x.fatura_numero || '/' || x.fatura_ano, 'doffice_identification'       , x.doffice_identification       ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_identification           ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_identification           ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_003',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_identification'           , x.whs_identification           ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_type                     ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_type                     ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_004',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_type'                     , x.whs_type                     ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_latitude                 ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_latitude                 ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_005',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_latitude'                 , x.whs_latitude                 ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_longitude                ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_longitude                ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_006',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_longitude'                , x.whs_longitude                ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_addr_line                ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_addr_line                ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_007',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_addr_line'                , x.whs_addr_line                ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.currencytype                 ,'-!-!-!')  <> Nvl(vr_fat_ant.currencytype                 ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_008',null,x.fatura_numero || '/' || x.fatura_ano, 'currencytype'                 , x.currencytype                 ),'E');
          vb_erro := TRUE;
        END IF;

        --IF Nvl(x.declarant_identification     ,'-!-!-!')  <> Nvl(vr_fat_ant.declarant_identification     ,'-!-!-!') THEN
        --  cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_009',null,x.fatura_numero || '/' || x.fatura_ano, 'declarant_identification'     , x.declarant_identification     ),'E');
        --  vb_erro := TRUE;
        --END IF;

        IF Nvl(x.exitoffice_identification    ,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_identification    ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_010',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_identification'    , x.exitoffice_identification    ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.exitoffice_whs_identification,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_whs_identification,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_011',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_whs_identification', x.exitoffice_whs_identification),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.exitoffice_whs_type          ,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_whs_type          ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_012',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_whs_type'          , x.exitoffice_whs_type          ),'E');
          vb_erro := TRUE;
        END IF;

--        IF Nvl(x.importer_name                ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_name                ,'-!-!-!') THEN
--          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_014',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_name'                , x.importer_name                ),'E');
--          vb_erro := TRUE;
--        END IF;

        IF Nvl(x.importer_addr_country        ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_addr_country        ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_015',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_addr_country'        , x.importer_addr_country        ),'E');
          vb_erro := TRUE;
        END IF;

--        IF Nvl(x.importer_addr_line           ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_addr_line           ,'-!-!-!') THEN
--          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_016',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_addr_line'           , x.importer_addr_line           ),'E');
--          vb_erro := TRUE;
--        END IF;

        IF Nvl(x.forma_exportacao             ,'-!-!-!')  <> Nvl(vr_fat_ant.forma_exportacao             ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_017',null,x.fatura_numero || '/' || x.fatura_ano, 'forma_exportacao'             , x.forma_exportacao             ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.forma_exportacao_type        ,'-!-!-!')  <> Nvl(vr_fat_ant.forma_exportacao_type        ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_018',null,x.fatura_numero || '/' || x.fatura_ano, 'forma_exportacao_type'        , x.forma_exportacao_type        ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.situacao_especial            ,'-!-!-!')  <> Nvl(vr_fat_ant.situacao_especial            ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_019',null,x.fatura_numero || '/' || x.fatura_ano, 'situacao_especial'            , x.situacao_especial            ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.situacao_especial_type       ,'-!-!-!')  <> Nvl(vr_fat_ant.situacao_especial_type       ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_020',null,x.fatura_numero || '/' || x.fatura_ano, 'situacao_especial_type'       , x.situacao_especial_type       ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.caso_esp_transporte          ,'-!-!-!')  <> Nvl(vr_fat_ant.caso_esp_transporte          ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_021',null,x.fatura_numero || '/' || x.fatura_ano, 'caso_esp_transporte'          , x.caso_esp_transporte          ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.caso_esp_transporte_type     ,'-!-!-!')  <> Nvl(vr_fat_ant.caso_esp_transporte_type     ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_022',null,x.fatura_numero || '/' || x.fatura_ano, 'caso_esp_transporte_type'     , x.caso_esp_transporte_type     ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.observacoes_gerais           ,'-!-!-!')  <> Nvl(vr_fat_ant.observacoes_gerais           ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_023',null,x.fatura_numero || '/' || x.fatura_ano, 'observacoes_gerais'           , x.observacoes_gerais           ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.observacoes_gerais_type      ,'-!-!-!')  <> Nvl(vr_fat_ant.observacoes_gerais_type      ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_024',null,x.fatura_numero || '/' || x.fatura_ano, 'observacoes_gerais_type'      , x.observacoes_gerais_type      ),'E');
          vb_erro := TRUE;
        END IF;
        IF Nvl(x.motivo_dispensa_nf      ,'-!-!-!')  <> Nvl(vr_fat_ant.motivo_dispensa_nf      ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_024',null,x.fatura_numero || '/' || x.fatura_ano, 'motivo_dispensa_nf'      , Nvl(x.motivo_dispensa_nf, ' ')      ),'E');
          vb_erro := TRUE;
        END IF;

      END IF;

      vr_fat_ant := x;

    END LOOP;


    IF vb_erro THEN
      RETURN pn_evento_id;
    END IF;

    RETURN NULL;
  END fnc_valida_due;

  FUNCTION fnc_gerar_due( pn_due_tmp_id NUMBER
                        , pn_evento_id NUMBER
                        , pn_usuario_id NUMBER
                        ) RETURN NUMBER
  AS

    CURSOR cur_dados
        IS
    SELECT fatura_id
         , embarque_id
         , fatura_numero
         , fatura_ano
         , empresa_id
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         --, declarant_identification
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         --, importer_name
         , importer_addr_country
         --, importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type
         --, ucr
         , motivo_dispensa_nf
      FROM (SELECT ef.fatura_id
                 , ef.embarque_id
                 , ef.fatura_numero
                 , ef.fatura_ano
                 , edft.empresa_id
                 , exp_pkg_due.fnc_ind_due('EX0010' ,'F', ef.fatura_id )         doffice_identification
                 , NVL( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                      , exp_pkg_due.fnc_ind_due('EX0037_CNPJ' ,'F', ef.fatura_id ))         whs_identification
                 , Decode( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                         , NULL
                         , '22'
                         , '281'
                         )                                                       whs_type
                 , exp_pkg_due.fnc_ind_due('EX0063' ,'F', ef.fatura_id )         whs_latitude
                 , exp_pkg_due.fnc_ind_due('EX0064' ,'F', ef.fatura_id )         whs_longitude
                 , exp_pkg_due.fnc_ind_due('EX0062' ,'F', ef.fatura_id )         whs_addr_line
                 , exp_pkg_due.fnc_ind_due('EX0039' ,'F', ef.fatura_id )         currencytype
                 --, exp_pkg_due.fnc_ind_due('EX0003' ,'F', ef.fatura_id )         declarant_identification
                 , exp_pkg_due.fnc_ind_due('EX0011' ,'F', ef.fatura_id )         exitoffice_identification
                 , exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )         exitoffice_whs_identification
                 , Decode( exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )
                         , NULL
                         , '22'
                         , '281'
                         )                                                       exitoffice_whs_type
                 --, exp_pkg_due.fnc_ind_due('EX0008' ,'F', ef.fatura_id )         importer_name
                 , exp_pkg_due.fnc_ind_due('EX0009' ,'F', ef.fatura_id )         importer_addr_country
                 --, exp_pkg_due.fnc_ind_due('EX0036' ,'F', ef.fatura_id )         importer_addr_line
                 , exp_pkg_due.fnc_ind_due('EX0040_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao
                 , exp_pkg_due.fnc_ind_due('EX0041_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao_type
                 , exp_pkg_due.fnc_ind_due('EX0040_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial
                 , exp_pkg_due.fnc_ind_due('EX0041_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial_type
                 , exp_pkg_due.fnc_ind_due('EX0040_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte
                 , exp_pkg_due.fnc_ind_due('EX0041_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte_type
                 , exp_pkg_due.fnc_ind_due('EX0042_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais
                 , exp_pkg_due.fnc_ind_due('EX0041_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais_type
                 --, exp_pkg_due.fnc_ind_due('EX0002' ,'F', ef.fatura_id )         ucr
                 , exp_pkg_due.fnc_ind_due('EX0067' ,'F', ef.fatura_id )         motivo_dispensa_nf
              FROM exp_faturas ef
                 , exp_due_fatura_tmp edft
             WHERE ef.fatura_id = edft.fatura_id
               AND edft.due_tmp_id = pn_due_tmp_id
           )
  ORDER BY fatura_ano
         , fatura_numero
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         --, declarant_identification
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         --, importer_name
         , importer_addr_country
         --, importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type
         , motivo_dispensa_nf
         ;

    CURSOR cur_empresas(pn_empresa_id NUMBER) IS
      SELECT SubStr(Nvl(numero_documento, cnpj),1,17) cnpj
        FROM cmx_empresas
       WHERE empresa_id = pn_empresa_id;

    CURSOR cur_vinc_fat
       IS
   SELECT cmx_fnc_string_agg(fat.fatura_numero||'/'||fat.fatura_ano)
     FROM exp_due_faturas      dfat
        , exp_due              due
        , exp_due_fatura_tmp   tmp
        , exp_due_ship         ship
        , exp_faturas          fat
    WHERE dfat.due_id = due.due_id
      AND dfat.fatura_id = tmp.fatura_id
      AND dfat.fatura_id = ship.fatura_id
      AND ship.due_id   = due.due_id
      AND dfat.fatura_id = fat.fatura_id
      AND due.dt_cancel IS NULL
      AND ship.fatura_nf_id IS NULL
      AND tmp.due_tmp_id = pn_due_tmp_id
      GROUP BY fat.fatura_numero, fat.fatura_ano;

    vr_fat_ant cur_dados%ROWTYPE;
    vb_erro              BOOLEAN;
    vn_due_id            NUMBER;
    vn_criacao           NUMBER;
    vc_ucr               VARCHAR2(35) := NULL;
    vc_decl_identif      VARCHAR2(17);
    vc_faturas           VARCHAR2(4000) := NULL;

  BEGIN
    -- verifica se alguma fatura tem informação divergente das demais.
    vr_fat_ant := NULL;
    vb_erro    := FALSE;

    -- verifica se alguma fatura já possui DUE gerada do tipo embarque antecipado.
    OPEN  cur_vinc_fat;
    FETCH cur_vinc_fat INTO vc_faturas;
    CLOSE cur_vinc_fat;

    IF(vc_faturas IS NOT NULL) THEN
      cmx_prc_gera_log_erros(pn_evento_id, 'Não é possível gerar a DUE, pois a(s) fatura(s) ['||vc_faturas||'] já está(ão) vinculada(s) a uma DUE.','E');
      vb_erro := TRUE;
    END IF;

    FOR x IN cur_dados
    LOOP
      --IF x.doffice_identification IS NULL THEN
      --  cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ sem local de despacho preenchido.', 'EXP_PKG_DUE','FNC_GERAR_DUE_025',null,x.fatura_numero || '/' || x.fatura_ano),'E');
      --  vb_erro := TRUE;
      --END IF;

      IF vr_fat_ant.fatura_id IS NOT NULL THEN
        IF Nvl(x.doffice_identification       ,'-!-!-!')  <> Nvl(vr_fat_ant.doffice_identification       ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_026',null,x.fatura_numero || '/' || x.fatura_ano, 'doffice_identification'       , x.doffice_identification       ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_identification           ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_identification           ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_027',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_identification'           , x.whs_identification           ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_type                     ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_type                     ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_028',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_type'                     , x.whs_type                     ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_latitude                 ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_latitude                 ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_029',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_latitude'                 , x.whs_latitude                 ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_longitude                ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_longitude                ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_030',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_longitude'                , x.whs_longitude                ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_addr_line                ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_addr_line                ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_031',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_addr_line'                , x.whs_addr_line                ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.currencytype                 ,'-!-!-!')  <> Nvl(vr_fat_ant.currencytype                 ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_032',null,x.fatura_numero || '/' || x.fatura_ano, 'currencytype'                 , x.currencytype                 ),'E');
          vb_erro := TRUE;
        END IF;

        --IF Nvl(x.declarant_identification     ,'-!-!-!')  <> Nvl(vr_fat_ant.declarant_identification     ,'-!-!-!') THEN
        -- cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_033',null,x.fatura_numero || '/' || x.fatura_ano, 'declarant_identification'     , x.declarant_identification     ),'E');
        --  vb_erro := TRUE;
        --END IF;

        IF Nvl(x.exitoffice_identification    ,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_identification    ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_034',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_identification'    , x.exitoffice_identification    ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.exitoffice_whs_identification,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_whs_identification,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_035',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_whs_identification', x.exitoffice_whs_identification),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.exitoffice_whs_type          ,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_whs_type          ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_036',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_whs_type'          , x.exitoffice_whs_type          ),'E');
          vb_erro := TRUE;
        END IF;

--        IF Nvl(x.importer_name                ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_name                ,'-!-!-!') THEN
--          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_037',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_name'                , x.importer_name                ),'E');
--          vb_erro := TRUE;
--        END IF;

        IF Nvl(x.importer_addr_country        ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_addr_country        ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_038',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_addr_country'        , x.importer_addr_country        ),'E');
          vb_erro := TRUE;
        END IF;

--        IF Nvl(x.importer_addr_line           ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_addr_line           ,'-!-!-!') THEN
--          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_039',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_addr_line'           , x.importer_addr_line           ),'E');
--          vb_erro := TRUE;
--        END IF;

        IF Nvl(x.forma_exportacao             ,'-!-!-!')  <> Nvl(vr_fat_ant.forma_exportacao             ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_040',null,x.fatura_numero || '/' || x.fatura_ano, 'forma_exportacao'             , x.forma_exportacao             ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.forma_exportacao_type        ,'-!-!-!')  <> Nvl(vr_fat_ant.forma_exportacao_type        ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_041',null,x.fatura_numero || '/' || x.fatura_ano, 'forma_exportacao_type'        , x.forma_exportacao_type        ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.situacao_especial            ,'-!-!-!')  <> Nvl(vr_fat_ant.situacao_especial            ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_042',null,x.fatura_numero || '/' || x.fatura_ano, 'situacao_especial'            , x.situacao_especial            ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.situacao_especial_type       ,'-!-!-!')  <> Nvl(vr_fat_ant.situacao_especial_type       ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_043',null,x.fatura_numero || '/' || x.fatura_ano, 'situacao_especial_type'       , x.situacao_especial_type       ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.caso_esp_transporte          ,'-!-!-!')  <> Nvl(vr_fat_ant.caso_esp_transporte          ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_044',null,x.fatura_numero || '/' || x.fatura_ano, 'caso_esp_transporte'          , x.caso_esp_transporte          ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.caso_esp_transporte_type     ,'-!-!-!')  <> Nvl(vr_fat_ant.caso_esp_transporte_type     ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_045',null,x.fatura_numero || '/' || x.fatura_ano, 'caso_esp_transporte_type'     , x.caso_esp_transporte_type     ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.observacoes_gerais           ,'-!-!-!')  <> Nvl(vr_fat_ant.observacoes_gerais           ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_046',null,x.fatura_numero || '/' || x.fatura_ano, 'observacoes_gerais'           , x.observacoes_gerais           ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.observacoes_gerais_type      ,'-!-!-!')  <> Nvl(vr_fat_ant.observacoes_gerais_type      ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_047',null,x.fatura_numero || '/' || x.fatura_ano, 'observacoes_gerais_type'      , x.observacoes_gerais_type      ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.motivo_dispensa_nf      ,'-!-!-!')  <> Nvl(vr_fat_ant.motivo_dispensa_nf      ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_047',null,x.fatura_numero || '/' || x.fatura_ano, 'motivo_dispensa_nf'      , Nvl(x.motivo_dispensa_nf, ' ')      ),'E');
          vb_erro := TRUE;
        END IF;

      END IF;

      vr_fat_ant := x;

    END LOOP;

    IF vb_erro THEN
      RETURN NULL;
    ELSE
      vn_due_id  := cmx_fnc_proxima_sequencia('exp_due_sq1');
      vc_ucr     := exp_pkg_due.fnc_ind_due('EX0002' ,'F', vr_fat_ant.fatura_id, NULL, NULL, NULL, vn_due_id);

      --IF vr_fat_ant.ucr IS NULL THEN
      IF vc_ucr IS NULL THEN
        vc_ucr := To_Char(SYSDATE, 'Y') || 'BR' || SubStr(LPad(cmx_pkg_empresas.cnpj(vr_fat_ant.empresa_id),14,'0'),1,8) || SubStr(To_Char(SYSDATE, 'YY'),1,1) || SubStr(LPad(cmx_pkg_empresas.cnpj(vr_fat_ant.empresa_id),14,'0'),9,6) ||  'D' || LPad(vn_due_id,16,'0');
      ELSE
        vc_ucr := To_Char(SYSDATE, 'Y') || 'BR' || SubStr(LPad(cmx_pkg_empresas.cnpj(vr_fat_ant.empresa_id),14,'0'),1,8) || SubStr(To_Char(SYSDATE, 'YY'),1,1) || vc_ucr;
      END IF;

      --EX0003
      OPEN  cur_empresas(vr_fat_ant.empresa_id);
      FETCH cur_empresas INTO vc_decl_identif;
      CLOSE cur_empresas;

      INSERT INTO exp_due
      (
        due_id
      , transmissao
      , doffice_identification
      , whs_identification
      , whs_type
      , whs_latitude
      , whs_longitude
      , whs_addr_line
      , currencytype
      , declarant_identification
      , exitoffice_identification
      , exitoffice_whs_identification
      , exitoffice_whs_type
      --, importer_name
      , importer_addr_country
      --, importer_addr_line
      , ucr
--      , forma_exportacao
--      , forma_exportacao_type
--      , situacao_especial
--      , situacao_especial_type
--      , caso_esp_transporte
--      , caso_esp_transporte_type
--      , observacoes_gerais
--      , observacoes_gerais_type
      , creation_date
      , created_by
      , last_update_date
      , last_updated_by
      , empresa_id
      , emissao
      ) VALUES ( vn_due_id
               , 0 -- transmissao
               , vr_fat_ant.doffice_identification
               , vr_fat_ant.whs_identification
               , vr_fat_ant.whs_type
               , vr_fat_ant.whs_latitude
               , vr_fat_ant.whs_longitude
               , vr_fat_ant.whs_addr_line
               , vr_fat_ant.currencytype
               , vc_decl_identif
               , vr_fat_ant.exitoffice_identification
               , vr_fat_ant.exitoffice_whs_identification
               , vr_fat_ant.exitoffice_whs_type
               --, SubStr(vr_fat_ant.importer_name, 1, 70)
               , vr_fat_ant.importer_addr_country
               --, vr_fat_ant.importer_addr_line
               , vc_ucr
--               , vr_fat_ant.forma_exportacao
--               , vr_fat_ant.forma_exportacao_type
--               , vr_fat_ant.situacao_especial
--               , vr_fat_ant.situacao_especial_type
--               , vr_fat_ant.caso_esp_transporte
--               , vr_fat_ant.caso_esp_transporte_type
--               , vr_fat_ant.observacoes_gerais
--               , vr_fat_ant.observacoes_gerais_type
               , SYSDATE
               , pn_usuario_id
               , SYSDATE
               , pn_usuario_id
               , vr_fat_ant.empresa_id
               , sysdate
               );

    END IF;

    INSERT INTO exp_due_faturas
    (
      due_fatura_id
    , due_id
    , fatura_id
    , creation_date
    , created_by
    , last_update_date
    , last_updated_by
    , importer_name
    , importer_addr_country
    , importer_addr_line
    ) SELECT cmx_fnc_proxima_sequencia('exp_due_faturas_sq1')
           , vn_due_id
           , edft.fatura_id
           , SYSDATE
           , pn_usuario_id
           , SYSDATE
           , pn_usuario_id
           , exp_pkg_due.fnc_ind_due('EX0008' ,'F', edft.fatura_id )
           , exp_pkg_due.fnc_ind_due('EX0009' ,'F', edft.fatura_id )
           , exp_pkg_due.fnc_ind_due('EX0036' ,'F', edft.fatura_id )
        FROM exp_due_fatura_tmp edft
       WHERE edft.due_tmp_id    = pn_due_tmp_id;

    prc_atual_compl( vn_due_id
                   , 'DUE_RUC'
                   , vc_ucr
                   , pn_usuario_id
                   );


    vn_criacao := fnc_criar_due(vn_due_id, pn_evento_id, pn_usuario_id);

    IF vn_criacao IS NULL THEN
      DELETE FROM exp_due_faturas WHERE due_id = vn_due_id;
      DELETE FROM exp_due         WHERE due_id = vn_due_id;
      RETURN NULL;
    END IF;

    exp_prc_gera_due_hook1( vn_due_id
                          , pn_due_tmp_id
                          , pn_evento_id
                          , pn_usuario_id
                          );
    COMMIT;

    RETURN vn_due_id;
  END fnc_gerar_due;

  PROCEDURE prc_limpa_b64
  AS
  BEGIN
    Dbms_Lob.createtemporary(gc_ret_b64,false);
  END prc_limpa_b64;

  PROCEDURE prc_add_token(pc_token VARCHAR2)
  AS
  BEGIN
    IF (pc_token IS NOT NULL) THEN
     Dbms_lob.writeappend(gc_ret_b64,length(pc_token),pc_token);
   END IF;
  END prc_add_token;

  PROCEDURE prc_proc_ret(pn_due_id     NUMBER
                        , pc_mensagem  VARCHAR2
                        , pn_evento_id NUMBER
                        , pc_tipo      VARCHAR2
                        )
  IS

    CURSOR cur_det(pc_item VARCHAR2)
        IS
    SELECT eds.ivc_identification
         , eds.ivc_issue
         , eds.numero_nf
         , eds.serie
         , edsi.cmmdty_line_sequence      linha
         , edsi.SEQUENCE
         , ef.fatura_numero
         , ef.fatura_ano
         , edsi.due_ship_item_id
      FROM exp_due_ship_item edsi
         , exp_due_ship      eds
         , exp_faturas       ef
     WHERE edsi.due_ship_id = eds.due_ship_id
       AND eds.fatura_id     = ef.fatura_id (+)
       AND edsi.sequence = pc_item
       AND eds.due_id   = pn_due_id ;

    vc_mensagem VARCHAR2(4000);
    vc_item     VARCHAR2(4000);
    vn_pos_ini  NUMBER;
    vn_pos_fim  NUMBER;

  BEGIN
    vc_mensagem := SubStr(dbms_xmlgen.Convert (pc_mensagem,1),1,4000);

    vn_pos_ini  := InStr(Upper(vc_mensagem),'ITEM DU-E') ;

    IF ( vn_pos_ini > 0 ) THEN
      vn_pos_fim := InStr(Upper(vc_mensagem),':', vn_pos_ini + 9);

      IF ( vn_pos_fim > 0 )  THEN

        vc_item := Trim(SubStr(vc_mensagem, vn_pos_ini + 9, vn_pos_fim - ( vn_pos_ini + 9)));
        Dbms_Output.put_line(vn_pos_ini || ' - ' || vn_pos_fim || ' - ' || vc_item);
        FOR x IN cur_det(vc_item) LOOP
          vc_mensagem := 'Fatura [' || x.fatura_numero || '/' || x.fatura_ano || '] - Nota Fiscal [' || x.numero_nf || '-' || x.serie || '] chave [' || x.ivc_identification || '] linha [' || x.linha || ']. ' || vc_mensagem;
          cmx_prc_gera_log_erros( pn_evento_id
                                , vc_mensagem
                                , pc_tipo
                                );
          --
          IF(InStr(Upper(vc_mensagem), 'SUJEITOS A VERIFICAÇÃO ESTATÍSTICA DA SECEX') > 0) THEN
            UPDATE exp_due_ship_item SET flag_justificativa = 'S'
                                   WHERE due_ship_item_id   = x.due_ship_item_id;
          END IF;
          --
        END LOOP;

      END IF;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  FUNCTION fnc_proc_retorno( pn_due_id      NUMBER
                           , pn_usuario_id  NUMBER
                           , pn_evento_id   NUMBER DEFAULT NULL
                           , pn_nr_linha    NUMBER DEFAULT NULL
                           , pc_retificacao VARCHAR2 DEFAULT 'N'
                           )
  RETURN VARCHAR2
  AS

    CURSOR cur_errors(pc_xml CLOB) IS
    SELECT extract(VALUE(erros), '//message/text()').getclobval()         erros
      FROM TABLE(XMLSequence(Extract( xmltype(pc_xml)
                                       , '//error/message'))) erros;

    CURSOR cur_sucesso(pc_xml CLOB) IS
    SELECT extract(VALUE(due), '//message/text()').getclobval()           mensagem
         , extract(VALUE(due), '//due/text()').getclobval()               due
         , extract(VALUE(due), '//ruc/text()').getclobval()               ruc
         , extract(VALUE(due), '//date/text()').getclobval()              data
         , extract(VALUE(due), '//chaveDeAcesso/text()').getclobval()     chave_acesso
      FROM TABLE(XMLSequence(Extract( xmltype(pc_xml)
                                       , '//pucomexReturn'))) due;

    CURSOR cur_warnings(pc_xml CLOB) IS
    SELECT extract(VALUE(due), '//warning/text()').getclobval()           warning
      FROM TABLE(XMLSequence(Extract( xmltype(pc_xml)
                                       , '//pucomexReturn/warnings/warning'))) due;

    CURSOR cur_due
        IS
    SELECT ed.ucr
         , Nvl(ed.retificacao,0) retificacao
      FROM exp_due ed
     WHERE ed.due_id = pn_due_id;

    vc_clob         CLOB;
    vn_evento_id    NUMBER;
    vc_ucr          VARCHAR2(100);
    vb_erro         BOOLEAN := FALSE;
    vc_complemento  VARCHAR2(150);
    vn_retificacao  NUMBER;
    vc_etapa        VARCHAR2(4000);
  BEGIN
    vc_etapa := 'Convertendo retorno';
    vc_clob :=  fnc_base64_clob(gc_ret_b64);

    OPEN cur_due;
    FETCH cur_due INTO vc_ucr, vn_retificacao;
    CLOSE cur_due;

    IF(Nvl(pc_retificacao,'N') = 'S') THEN
      vn_retificacao := Nvl(vn_retificacao,0) + 1;
    END IF;

    vc_etapa := 'Salvando retorno';
    IF(Dbms_Lob.getlength(vc_clob) > 0) THEN
      UPDATE exp_due
         SET xml_retorno = vc_clob
       WHERE due_id = pn_due_id;
    END IF;

    IF(pn_evento_id IS NULL) THEN
      vn_evento_id := cmx_fnc_gera_evento('Verificando retorno DUE com número de RUC: ' || vc_ucr, SYSDATE,pn_usuario_id);
    ELSE
      vn_evento_id := pn_evento_id;
    END IF;

    vc_etapa := 'Lendo XML';
    IF(pn_nr_linha IS NOT NULL) THEN
      vc_complemento := 'RUC['||vc_ucr||'], Nr. Linha['||pn_nr_linha||']'||' - ';
    END IF;

    BEGIN

      FOR x IN cur_errors(vc_clob) LOOP
        vb_erro := TRUE;
        cmx_prc_gera_log_erros( vn_evento_id
                              , vc_complemento||'Etapa['||vc_etapa||'] -'||dbms_xmlgen.Convert (x.erros,1)
                              , 'E'
                              );
        prc_proc_ret(pn_due_id, x.erros, vn_evento_id,'E');
      END LOOP;

      FOR x IN cur_warnings(vc_clob)
      LOOP
        vb_erro := TRUE;
        cmx_prc_gera_log_erros( vn_evento_id
                              , vc_complemento||'Etapa['||vc_etapa||'] -'||'Warning: ' ||  dbms_xmlgen.Convert (x.warning,1)
                              , 'A'
                              );
        prc_proc_ret(pn_due_id, x.warning, vn_evento_id,'A');
      END LOOP;

      IF(Nvl(pc_retificacao,'N') = 'S') THEN
        FOR x IN cur_sucesso(vc_clob) LOOP
          UPDATE exp_due
             SET ultimo_envio     = SYSDATE
               , last_update_date = SYSDATE
               , last_updated_by  = pn_usuario_id
               , retificacao      = vn_retificacao
           WHERE due_id = pn_due_id;

          cmx_prc_gera_log_erros( vn_evento_id
                                , vc_complemento||'Etapa['||vc_etapa||'] -'||dbms_xmlgen.Convert (x.mensagem,1) || ' - Due: [ ' || x.due || '].'
                                , '*'
                                );

        END LOOP;
      ELSE
        FOR x IN cur_sucesso(vc_clob) LOOP
          UPDATE exp_due
            SET registro         = To_Date(SubStr(x.data,1,19), 'YYYY-MM-DD HH24:MI:SS)')
              , numero           = x.due
              , chave_acesso     = x.chave_acesso
              , ultimo_envio     = SYSDATE
              , last_update_date = SYSDATE
              , last_updated_by  = pn_usuario_id
              , retificacao      = vn_retificacao
          WHERE due_id = pn_due_id;

          cmx_prc_gera_log_erros( vn_evento_id
                                , vc_complemento||'Etapa['||vc_etapa||'] -'||dbms_xmlgen.Convert (x.mensagem,1) || ' - Due: [ ' || x.due || '].'
                                , '*'
                                );
        END LOOP;
      END IF;

      COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
         vb_erro := TRUE;
         cmx_prc_gera_log_erros( vn_evento_id
                               , vc_complemento||'Etapa['||vc_etapa||'] -'||SubStr(vc_clob,1,3000)||' ['||SubStr(sqlerrm,1,1000)||']'
                               , 'E'
                               );
    END;

    IF(pn_evento_id IS NULL) THEN
      RETURN 'Verifique o evento: [' || vn_evento_id  || '].';
    ELSE

      IF(vb_erro) THEN
        RETURN 'ERRO';
      ELSE
        RETURN NULL;
      END IF;

    END IF;
  END fnc_proc_retorno;

  FUNCTION fnc_proc_retorno_json( pn_due_id      NUMBER
                                , pn_usuario_id  NUMBER
                                , pn_evento_id   NUMBER
                                , pn_nr_linha    NUMBER DEFAULT NULL
                                )
  RETURN VARCHAR2
  AS

    CURSOR cur_due
        IS
    SELECT ed.numero
      FROM exp_due ed
     WHERE ed.due_id = pn_due_id;

    CURSOR cur_verifica_situacao
        IS
    SELECT situacaodue
         , indicadorbloqueio
         , situacaocarga
         , controleadministrativo
      FROM exp_due_hist_situacao
     WHERE due_id  = pn_due_id
     ORDER BY due_situacao_id DESC;

    vt_obj_json                 cmx_pkg_json.JSONStructObj;
    vc_clob                     CLOB;
    vn_count                    NUMBER := 1;
    vb_erro                     BOOLEAN := FALSE;
    vb_inserir                  BOOLEAN := FALSE;
    vb_achou                    BOOLEAN := FALSE;
    vc_numero                   VARCHAR2(100);
    vc_complemento              VARCHAR2(150);
    vc_etapa                    VARCHAR2(4000);
    vc_conteudo                 VARCHAR2(2000);
    vc_tipo                     VARCHAR2(100);
    vr_situacao                 cur_verifica_situacao%ROWTYPE;

    vc_numerodue                VARCHAR2(100);
    vc_numeroruc                VARCHAR2(100);
    vc_situacaodue              VARCHAR2(100);
    vn_situacao_id              NUMBER;
    vd_datasituacaodue          DATE;
    vn_indicadorbloqueio        NUMBER;
    vc_controleadministrativo   VARCHAR2(100);
    vc_uaembarque               VARCHAR2(100);
    vc_uadespacho               VARCHAR2(100);
    vc_responsaveluadespacho    VARCHAR2(100);
    vc_cdrecintoaddespacho      VARCHAR2(100);
    vc_cdrecintoadembarque      VARCHAR2(100);
    vc_coordenadasdespacho      VARCHAR2(100);
    vc_recintodespacho          VARCHAR2(100);
    vc_declarante_num           VARCHAR2(100);
    vc_declarante_tipo          VARCHAR2(100);
    vc_exportadores_num         VARCHAR2(100);
    vc_exportadores_tipo        VARCHAR2(100);
    vc_situacaocarga            VARCHAR2(100);
    vn_situacaocarga_id         NUMBER;
    vn_due_status_id            NUMBER;
    vn_timestamp                NUMBER;
    vd_cancel                   DATE;

    FUNCTION fnc_trata_campo(pn_index NUMBER) RETURN VARCHAR2 IS
      vc_dados VARCHAR2(2000);
    BEGIN

      vc_dados    := vt_obj_json(pn_index).item;
      vc_dados    := REPLACE(vc_dados, '"', '');
      vc_dados    := Trim(vc_dados);

      IF(Upper(vc_dados) = 'NULL') THEN
        vc_dados := NULL;
      END IF;

      RETURN vc_dados;
    END;

    PROCEDURE p_prc_inserir IS
    BEGIN

      INSERT INTO exp_due_hist_situacao
      (
        due_situacao_id
      , due_id
      , numeroDUE
      , numeroRUC
      , situacaoDUE
      , dataSituacaoDUE
      , indicadorBloqueio
      , uaDespacho
      , responsaveluaDespacho
      , uaEmbarque
      , niDeclarante
      , niExportador
      , situacaoCarga
      , cdRecintoAdDespacho
      , coordenadasDespacho
      , cdRecintoAdEmbarque
      , tipoDeclarante
      , tipoExportador
      , controleAdministrativo
      , conteudo_json
      , creation_date
      , created_by
      , last_update_date
      , last_updated_by
      ) VALUES (
                 cmx_fnc_proxima_sequencia('exp_due_hist_situacao_SQ1')
               , pn_due_id
               , vc_numerodue
               , vc_numeroruc
               , vc_situacaodue
               , vd_datasituacaodue
               , vn_indicadorbloqueio
               , vc_uadespacho
               , vc_responsaveluadespacho
               , vc_uaembarque
               , vc_declarante_num
               , vc_exportadores_num
               , vc_situacaocarga
               , vc_cdrecintoaddespacho
               , vc_coordenadasdespacho
               , vc_cdrecintoadembarque
               , vc_declarante_tipo
               , vc_exportadores_tipo
               , vc_controleadministrativo
               , vc_clob
               , SYSDATE
               , pn_usuario_id
               , SYSDATE
               , pn_usuario_id
               );

      IF(vc_situacaodue = '70') THEN
        UPDATE exp_due SET dt_averbacao = vd_datasituacaodue
                     WHERE due_id      = pn_due_id;
      ELSIF(vc_situacaodue IN ('80', '81', '82', '83')) THEN
        UPDATE exp_due SET dt_cancel = vd_datasituacaodue
                     WHERE due_id      = pn_due_id;
      END IF;

      prc_atualiza_datas( pn_due_id
                        , Upper(vc_situacaodue)
                        , vd_datasituacaodue
                        );

    END p_prc_inserir;

  BEGIN
    vc_clob :=  fnc_base64_clob(gc_ret_b64);

    OPEN cur_due;
    FETCH cur_due INTO vc_numero;
    CLOSE cur_due;

    IF(pn_nr_linha IS NOT NULL) THEN
      vc_complemento := 'Número['||vc_numero||'], Nr. Linha['||pn_nr_linha||']'||' - ';
    END IF;

    IF(dbms_lob.getlength(vc_clob) = 0) THEN
      vb_erro  := TRUE;
      cmx_prc_gera_log_erros ( pn_evento_id
                            , vc_complemento||'Não foi encontrado informações no arquivo JSON.'
                            , 'E'
                            );
    END IF;

    IF(instr(vc_clob, '{') = 0) THEN
      vb_erro  := TRUE;
      cmx_prc_gera_log_erros ( pn_evento_id
                            , vc_complemento||SubStr(vc_clob, 1, 4000)
                            , 'E'
                            );
    END IF;

    IF NOT(vb_erro) THEN

      UPDATE exp_due SET json_retorno = vc_clob
                   WHERE due_id = pn_due_id;

      vc_etapa := 'Carregando JSON.';
      vt_obj_json := cmx_pkg_json.clob2JSON(vc_clob, '"');

      vc_etapa := 'Validando tamanho do JSON.';
      IF(vt_obj_json.Count <= 0) THEN
        vb_erro  := TRUE;
        cmx_prc_gera_log_erros ( pn_evento_id
                               , vc_complemento||'Erro ao carregar JSON.'
                               , 'E'
                               );
      END IF;

      IF NOT(vb_erro) THEN

        vc_etapa      := 'Lendo JSON.';
        vb_inserir    := FALSE;
        WHILE vn_count <= vt_obj_json.Count LOOP

          vc_tipo     := vt_obj_json(vn_count).type;
          vc_conteudo := vt_obj_json(vn_count).item;

          vc_conteudo := REPLACE(vc_conteudo, '"', '');
          vc_conteudo := Trim(vc_conteudo);

          IF(Upper(vc_conteudo) = 'NUMERODUE') THEN

            IF (vb_inserir) THEN

              vb_achou := FALSE;
              IF(vc_situacaodue IS NOT NULL) THEN
                vc_etapa := 'Verifica se a situação é igual a última situação da DUE.';
                OPEN  cur_verifica_situacao;
                FETCH cur_verifica_situacao INTO vr_situacao;
                vb_achou := cur_verifica_situacao%FOUND;
                CLOSE cur_verifica_situacao;

                IF NOT(vb_achou) OR (    vr_situacao.situacaodue <>  vc_situacaodue OR vr_situacao.indicadorbloqueio <> vn_indicadorbloqueio
                                      OR vr_situacao.situacaocarga <> vc_situacaocarga OR vr_situacao.controleadministrativo <> vc_controleadministrativo
                                    ) THEN
                  vc_etapa := 'Inserir JSON.';
                  p_prc_inserir;
                END IF;
              END IF;

              vb_inserir                := FALSE;
              vc_numerodue              := NULL;
              vc_numeroruc              := NULL;
              vc_situacaodue            := NULL;
              vn_situacao_id            := NULL;
              vd_datasituacaodue        := NULL;
              vn_indicadorbloqueio      := NULL;
              vc_controleadministrativo := NULL;
              vc_uaembarque             := NULL;
              vc_uadespacho             := NULL;
              vc_responsaveluadespacho  := NULL;
              vc_cdrecintoaddespacho    := NULL;
              vc_cdrecintoadembarque    := NULL;
              vc_coordenadasdespacho    := NULL;
              vc_recintodespacho        := NULL;
              vc_declarante_num         := NULL;
              vc_declarante_tipo        := NULL;
              vc_exportadores_num       := NULL;
              vc_exportadores_tipo      := NULL;
              vc_situacaocarga          := NULL;
              vn_situacaocarga_id       := NULL;
              vn_timestamp              := NULL;
            END IF;

            vc_etapa := 'Convertendo número da DUE.';

            vn_count       := vn_count + 2;
            vc_numerodue   := fnc_trata_campo(vn_count);
            vb_inserir     := TRUE;
          ELSIF(Upper(vc_conteudo) = 'NUMERORUC') THEN
            vc_etapa := 'Convertendo Nr. RUC da DUE.';

            vn_count       := vn_count + 2;
            vc_numeroruc   := fnc_trata_campo(vn_count);
            vb_inserir     := TRUE;
          ELSIF(Upper(vc_conteudo) = 'SITUACAODUE') THEN
            vc_etapa := 'Convertendo Situação da DUE.';

            vn_count       := vn_count + 2;
            vc_situacaodue := fnc_trata_campo(vn_count);
            vb_inserir     := TRUE;
          ELSIF(Upper(vc_conteudo) = 'DATASITUACAODUE') THEN
            vc_etapa := 'Convertendo Data da situação da DUE.';

            vn_count       := vn_count + 2;
            vc_conteudo    := fnc_trata_campo(vn_count);
            vc_conteudo    := SubStr(vc_conteudo, 1, 19);

            IF(vc_conteudo IS NOT NULL) THEN
              vd_datasituacaodue  := To_Date(vc_conteudo, 'RRRR-MM-DD HH24:MI:SS');
              vb_inserir          := TRUE;
            END IF;
          ELSIF(Upper(vc_conteudo) = 'INDICADORBLOQUEIO') THEN
            vc_etapa := 'Convertendo indicador de bloqueio da DUE.';

            vn_count       := vn_count + 2;
            vc_conteudo    := fnc_trata_campo(vn_count);

            IF(vc_conteudo IS NOT NULL) THEN
              vn_indicadorbloqueio := To_Number(vc_conteudo);
              vb_inserir           := TRUE;
            END IF;
          ELSIF(Upper(vc_conteudo) = 'CONTROLEADMINISTRATIVO') THEN
            vc_etapa := 'Convertendo Controle administrativo da DUE.';

            vn_count                  := vn_count + 2;
            vc_controleadministrativo := fnc_trata_campo(vn_count);
            vb_inserir                := TRUE;
          ELSIF(Upper(vc_conteudo) = 'UAEMBARQUE') THEN
            vc_etapa := 'Convertendo UAEMBARQUE da DUE.';

            vn_count       := vn_count + 2;
            vc_uaembarque  := fnc_trata_campo(vn_count);
            vb_inserir     := TRUE;
          ELSIF(Upper(vc_conteudo) = 'UADESPACHO') THEN
            vc_etapa := 'Convertendo UADESPACHO da DUE.';

            vn_count       := vn_count + 2;
            vc_uadespacho  := fnc_trata_campo(vn_count);
            vb_inserir     := TRUE;
          ELSIF(Upper(vc_conteudo) = 'RESPONSAVELUADESPACHO') THEN
            vc_etapa := 'Convertendo Responsável UADESPACHO da DUE.';

            vn_count                  := vn_count + 2;
            vc_responsaveluadespacho  := fnc_trata_campo(vn_count);
            vb_inserir                := TRUE;
          ELSIF(Upper(vc_conteudo) = 'CODIGORECINTOADUANEIRODESPACHO') THEN
            vc_etapa := 'Convertendo Código do recinto aduaneiro de despacho da DUE.';

            vn_count                := vn_count + 2;
            vc_cdrecintoaddespacho  := fnc_trata_campo(vn_count);
            vb_inserir              := TRUE;
          ELSIF(Upper(vc_conteudo) = 'CODIGORECINTOADUANEIROEMBARQUE') THEN
            vc_etapa := 'Convertendo Código do recinto aduaneiro de embarque da DUE.';

            vn_count                := vn_count + 2;
            vc_cdrecintoadembarque  := fnc_trata_campo(vn_count);
            vb_inserir              := TRUE;
          ELSIF(Upper(vc_conteudo) = 'COORDENADASDESPACHO') THEN
            vc_etapa := 'Convertendo Coordenadas de despacho da DUE.';

            vn_count                := vn_count + 2;
            vc_coordenadasdespacho  := fnc_trata_campo(vn_count);
            vb_inserir              := TRUE;
          ELSIF(Upper(vc_conteudo) = 'RECINTODESPACHO') THEN
            vc_etapa := 'Convertendo Recinto de despacho da DUE.';

            vn_count            := vn_count + 2;
            vc_recintodespacho  := fnc_trata_campo(vn_count);
            vb_inserir          := TRUE;
          ELSIF(Upper(vc_conteudo) = 'DECLARANTE') THEN
            vc_etapa := 'Convertendo Declarante da DUE.';

            vn_count       := vn_count + 2;
            vc_conteudo    := fnc_trata_campo(vn_count);

            IF(vc_conteudo = '{') THEN

              vn_count       := vn_count + 1;
              vc_conteudo    := fnc_trata_campo(vn_count);

              IF(Upper(vc_conteudo) = 'NUMERO') THEN
                vn_count          := vn_count + 2;
                vc_declarante_num := fnc_trata_campo(vn_count);
                vb_inserir        := TRUE;
              END IF;

              vn_count       := vn_count + 2;
              vc_conteudo    := fnc_trata_campo(vn_count);

              IF(Upper(vc_conteudo) = 'TIPO') THEN
                vn_count           := vn_count + 2;
                vc_declarante_tipo := fnc_trata_campo(vn_count);
                vb_inserir         := TRUE;
              END IF;
            END IF;

          ELSIF(Upper(vc_conteudo) = 'EXPORTADORES') THEN
            vc_etapa := 'Convertendo Exportadores da DUE.';

            vn_count       := vn_count + 3;
            vc_conteudo    := fnc_trata_campo(vn_count);

            IF(vc_conteudo = '{') THEN

              vn_count       := vn_count + 1;
              vc_conteudo    := fnc_trata_campo(vn_count);

              IF(Upper(vc_conteudo) = 'NUMERO') THEN
                vn_count            := vn_count + 2;
                vc_exportadores_num := fnc_trata_campo(vn_count);
                vb_inserir          := TRUE;
              END IF;

              vn_count       := vn_count + 2;
              vc_conteudo    := fnc_trata_campo(vn_count);

              IF(Upper(vc_conteudo) = 'TIPO') THEN
                vn_count             := vn_count + 2;
                vc_exportadores_tipo := fnc_trata_campo(vn_count);
                vb_inserir           := TRUE;
              END IF;
            END IF;

          ELSIF(Upper(vc_conteudo) = 'SITUACAOCARGA') THEN
            vc_etapa := 'Convertendo Situação da carga da DUE.';

            vn_count          := vn_count + 3;
            vc_situacaocarga  := fnc_trata_campo(vn_count);
            vb_inserir        := TRUE;
          END IF;

          vn_count := vn_count + 1;
        END LOOP;

        vb_achou := FALSE;
        IF(vc_situacaodue IS NOT NULL) THEN
          vc_etapa := 'Verifica se a situação é igual a última situação da DUE.';
          OPEN  cur_verifica_situacao;
          FETCH cur_verifica_situacao INTO vr_situacao;
          vb_achou := cur_verifica_situacao%FOUND;
          CLOSE cur_verifica_situacao;

          IF NOT(vb_achou) OR (    vr_situacao.situacaodue <>  vc_situacaodue OR vr_situacao.indicadorbloqueio <> vn_indicadorbloqueio
                                OR vr_situacao.situacaocarga <> vc_situacaocarga OR vr_situacao.controleadministrativo <> vc_controleadministrativo
                              ) THEN
            vc_etapa := 'Inserir JSON.';
            p_prc_inserir;
            vn_count := vn_count + 1;
          END IF;

          UPDATE exp_due SET situacaodue                = vc_situacaodue
                           , datasituacaodue            = vd_datasituacaodue
                           , indicadorbloqueio          = vn_indicadorbloqueio
                           , controleadministrativo     = vc_controleadministrativo
                           , situacaocarga              = vc_situacaocarga
                      WHERE due_id = pn_due_id;
        END IF;

      END IF;

    END IF;

    --cmx_prc_gera_log_erros(pn_evento_id, vc_complemento||' Retorno JSON['||SubStr(vc_clob, 1, 4000)||']','*');

    IF(vb_erro) THEN
      RETURN 'ERRO';
    ELSE
      RETURN NULL;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN

      IF(vc_complemento IS NOT NULL) THEN
        vc_complemento := vc_complemento||',';
      END IF;

      cmx_prc_gera_log_erros(pn_evento_id, vc_complemento||' Etapa['||vc_etapa||'], Conteúdo['||vc_conteudo||'] - '||SQLERRM,'E');
      RETURN 'ERRO';
  END fnc_proc_retorno_json;

  FUNCTION fnc_valida_trans_due( pn_due_id      NUMBER
                               , pn_usuario_id  NUMBER
                               , pn_evento_id   NUMBER DEFAULT NULL
                               , pn_nr_linha    NUMBER DEFAULT NULL
                               )
  RETURN NUMBER
  AS
    CURSOR cur_due
        IS
    SELECT due.*
      FROM exp_due due
     WHERE due_id = pn_due_id;

    CURSOR cur_nf
        IS
    SELECT eds.*
      FROM exp_vw_due_ship eds
     WHERE eds.due_id = pn_due_id
     ORDER BY due_ship_id;

    CURSOR cur_nfi(pn_due_ship_id NUMBER)
        IS
    SELECT edsi.*
      FROM exp_vw_due_ship_item edsi

     WHERE edsi.due_ship_id = pn_due_ship_id
  ORDER BY due_ship_item_id;

    CURSOR cur_forma
        IS
    SELECT due_add_info_id
      FROM exp_vw_due_add_info dai
     WHERE due_id = pn_due_id
       AND dai.statementtypecode = 'CUS';

    CURSOR cur_destaques(pc_ncm VARCHAR2)
        IS
    SELECT Count(*) destaques
      FROM cmx_tab_ncm_atributos
     WHERE codigo = pc_ncm
       AND Nvl(obrigatorio, 'N') = 'S'
       AND Nvl(ativo, 'N') = 'S';

    CURSOR cur_due_dest(pn_due_ship_item_id NUMBER)
        IS
    SELECT edsc.typecode     atributo
         , edsc.description  destaque
      FROM exp_vw_due_si_char edsc
     WHERE pn_due_ship_item_id = edsc.due_ship_item_id;

    CURSOR cur_erros(pn_evento_id NUMBER)
        IS
    SELECT cle.evento_id
      FROM cmx_log_erros cle
     WHERE cle.evento_id = pn_evento_id;

    CURSOR cur_pais_dest (pn_due_ship_item_id NUMBER)
       IS
    SELECT edd.countrycode
         , edd.gm_tariffquantity
      FROM exp_vw_due_si_dest edd
     WHERE edd.due_ship_item_id = pn_due_ship_item_id;

    CURSOR cur_enq (pn_due_ship_item_id NUMBER)
       IS
    SELECT ede.due_si_enq_id
      FROM exp_vw_due_si_enq ede
     WHERE ede.due_ship_item_id = pn_due_ship_item_id;

    CURSOR cur_atributo_ncm( pc_ncm      VARCHAR2
                           , pc_atributo VARCHAR2
                           )
        IS
    SELECT cna.codigo  atributo
      FROM cmx_tab_ncm_atributos cna
     WHERE cna.ncm      = pc_ncm
       AND cna.codigo   = pc_atributo;

    CURSOR cur_dominio_ncm( pc_ncm      VARCHAR2
                          , pc_dominio  VARCHAR2
                          , pc_atributo VARCHAR2
                          )
        IS
    SELECT cnac.codigo destaque
      FROM cmx_tab_ncm_atributos cna
         , cmx_tab_ncm_atr_compl cnac
     WHERE cna.ncm_atributo_id = cnac.ncm_atributo_id
       --AND cnac.tipo    = 'DO'
       AND cna.ncm      = pc_ncm
       AND (Upper(cna.formapreench_attr) <> 'LISTA_ESTATICA' OR cnac.codigo  = pc_dominio)
       AND (cna.codigo  = pc_atributo OR pc_atributo IS NULL);

    CURSOR cur_fat
        IS
    SELECT importer_name
         , importer_addr_country
         , importer_addr_line
         , ef.fatura_numero
         , ef.fatura_ano
      FROM exp_due_faturas edf
         , exp_faturas     ef
     WHERE edf.fatura_id = ef.fatura_id
       AND due_id = pn_due_id;

    CURSOR cur_enq_fin(pn_due_ship_item_id NUMBER)
        IS
    SELECT ede.due_si_enq_id
      FROM exp_due_si_enq ede
     WHERE ede.due_ship_item_id = pn_due_ship_item_id
       AND ede.enquadramento IN ('81501', '81502', '81503');

    vn_evento_id    NUMBER;
    vr_due          cur_due%ROWTYPE;
    vb_found        BOOLEAN;
    vb_erro         BOOLEAN := FALSE;
    vn_forma_id     NUMBER;
    vc_destaque     VARCHAR2(150);
    vn_destaques    NUMBER;
    vn_dummy        NUMBER;
    vc_atributo     VARCHAR2(10);
    vc_complemento  VARCHAR2(150);
    vb_erro_pais    BOOLEAN := FALSE;
    vc_pais_ant     VARCHAR2(10);

    vn_count        NUMBER := 0;
  BEGIN
    OPEN cur_due;
    FETCH cur_due INTO vr_due;
    vb_found      := cur_due%FOUND;
    CLOSE cur_due;

    IF vb_found THEN

      IF(pn_evento_id IS NULL) THEN
        vn_evento_id := cmx_fnc_gera_evento( 'Validando DUE com número de RUC: '|| vr_due.ucr
                                           , SYSDATE
                                           , pn_usuario_id
                                           );
      ELSE
        vn_evento_id := pn_evento_id;
      END IF;

      IF(pn_nr_linha IS NOT NULL) THEN
        vc_complemento := 'RUC['||vr_due.ucr||'], Nr. Linha['||pn_nr_linha||']'||' - ';
      END IF;

      IF vr_due.ucr IS NULL THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Número da RUC não preenchido','E');
      END IF;

      OPEN cur_forma;
      FETCH cur_forma INTO vn_forma_id;
      vb_found  := cur_forma%FOUND;
      CLOSE cur_forma;

      IF NOT vb_found THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Forma de exportação não preenchida na aba Informações Adicionais.','E');
      END IF;

      IF vr_due.doffice_identification IS NULL THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Local de despacho não preenchido na aba Local de Despacho.','E');
      END IF;

      /*
      IF vr_due.whs_identification IS NULL THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros( vn_evento_id
                              , vc_complemento||'Portal Único não está tratando informações de Despacho fora do recinto.'
                              , 'E'
                              , 'Favor preencher o recinto aduaneiro de embarque na aba Local de Despacho.'
                              );
      END IF;
      */

      IF vr_due.whs_type IS NULL THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Tipo de recinto aduaneiro de embarque não preenchido na aba Local de Despacho.','E');
      END IF;

      IF vr_due.exitoffice_identification IS NULL AND vr_due.whs_type <> '19' THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Local de embarque não preenchido na aba Local de Embarque.','E');
      END IF;

      IF vr_due.exitoffice_whs_identification IS NULL AND vr_due.exitoffice_whs_type = '281' THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Recinto aduaneiro de embarque não preenchido na aba Local de Embarque.','E');
      END IF;

      IF vr_due.exitoffice_whs_type IS NULL THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Tipo de recinto aduaneiro de embarque não preenchido na aba Local de Embarque.','E');
      END IF;

--      IF vr_due.importer_name IS NULL THEN
--        vb_erro := TRUE;
--        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Importador não preenchido na aba Importador.','E');
--      END IF;

--      IF vr_due.importer_addr_line IS NULL THEN
--        vb_erro := TRUE;
--        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Endereço do importador não preenchido na aba Importador.','E');
--      END IF;

--      IF vr_due.importer_addr_country IS NULL THEN
--        vb_erro := TRUE;
--        cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'País do importador não preenchido na aba Importador.','E');
--      END IF;

      FOR fat IN cur_fat LOOP

        IF(vn_count = 0) THEN
          vc_pais_ant := fat.importer_addr_country;
        END IF;

        IF fat.importer_name IS NULL THEN
          vb_erro := TRUE;
          cmx_prc_gera_log_erros( vn_evento_id
                                , vc_complemento||'Fatura['||fat.fatura_numero||'/'||fat.fatura_ano||'] - Importador não preenchido na aba Faturas.'
                                ,'E'
                                , 'Favor preencher o importador na aba (Faturas).'
                                );
        END IF;

        IF fat.importer_addr_line IS NULL THEN
          vb_erro := TRUE;
          cmx_prc_gera_log_erros( vn_evento_id
                                , vc_complemento||'Fatura['||fat.fatura_numero||'/'||fat.fatura_ano||'] - Endereço do importador não preenchido na aba Faturas.'
                                , 'E'
                                , 'Favor preencher o endereço do importador na aba (Faturas).'
                                );
        END IF;

        IF fat.importer_addr_country IS NULL THEN
          vb_erro := TRUE;
          cmx_prc_gera_log_erros( vn_evento_id
                                , vc_complemento||'Fatura['||fat.fatura_numero||'/'||fat.fatura_ano||'] - País do importador não preenchido na aba Faturas.'
                                , 'E'
                                , 'Favor preencher o país do importador na aba (Faturas).'
                                );
        END IF;

        IF(Nvl(fat.importer_addr_country, '-----') <> Nvl(vc_pais_ant, '-----')) THEN
          vb_erro_pais := TRUE;
        END IF;

        vc_pais_ant := fat.importer_addr_country;
        vn_count    := vn_count + 1;
      END LOOP;

      IF(vb_erro_pais) THEN
        vb_erro := TRUE;
        cmx_prc_gera_log_erros( vn_evento_id
                              , vc_complemento||'O país dos importadores não podem ser diferentes.'
                              , 'E'
                              );
      END IF;

      FOR nf IN cur_nf LOOP
        IF nf.ivc_identification IS NULL AND nf.ivc_addit_statement IS NULL  THEN
          vb_erro := TRUE;
          cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Preencha a chave NF ou o motivo de dispensa da NF na aba Notas Fiscais.','E');
        END IF;

        IF(nf.ivc_tradeterms_condition IS NULL) THEN
          vb_erro := TRUE;
          cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Incoterm não preenchido na aba Notas Fiscais.','E');
        END IF;

        FOR nfi IN cur_nfi(nf.due_ship_id)
        LOOP
          IF nfi.customsvalue IS NULL THEN
            vb_erro := TRUE;
            cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Valor FOB não preenchido.','E');
          END IF;

          vb_found := FALSE;
          OPEN  cur_enq_fin(nfi.due_ship_item_id);
          FETCH cur_enq_fin INTO vn_dummy;
          vb_found := cur_enq_fin%FOUND;
          CLOSE cur_enq_fin;

          IF(vb_found) THEN
            IF(Nvl(nfi.financedvalue,0) = 0 OR Nvl(nfi.financedvalue,0) > Nvl(nfi.cmmdty_value,0)) THEN
              vb_erro := TRUE;
              cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - O valor do financiamento deve ser maior que zero e menor ou igual ao VMCV.','E');
            END IF;
          END IF;

          vb_found := FALSE;
          FOR dest IN cur_due_dest(nfi.due_ship_item_id)
          LOOP

            IF dest.destaque IS NULL AND dest.atributo IS NULL THEN
              vb_erro := TRUE;
              cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Existe uma linha em branco na aba Atributos NCM, preencha as informações ou exclua a linha.','E');
            ELSE
              /* Validando o atributo do NCM */
              IF(dest.atributo IS NULL) THEN
                vb_erro := TRUE;
                cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Preencha o código do atributo para NCM['||nfi.ncm||'].','E');
              ELSE
                vb_found := FALSE;
                OPEN cur_atributo_ncm(nfi.ncm, dest.atributo);
                FETCH cur_atributo_ncm INTO vc_atributo;
                vb_found := cur_atributo_ncm%FOUND;
                CLOSE cur_atributo_ncm;

                IF NOT(vb_found) THEN
                  vb_erro := TRUE;
                  cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Atributo ['||dest.atributo||'] informado é inválido para a NCM['||nfi.ncm||'].','E');
                END IF;
              END IF;

              /* Validando o domínio do NCM */
              IF(dest.destaque IS NULL) THEN
                vb_erro := TRUE;
                cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Preencha o código do domínio para a NCM['||nfi.ncm||'].','E');
              ELSE
                vb_found := FALSE;
                OPEN cur_dominio_ncm(nfi.ncm, dest.destaque, dest.atributo);
                FETCH cur_dominio_ncm INTO vc_atributo;
                vb_found := cur_dominio_ncm%FOUND;
                CLOSE cur_dominio_ncm;

                IF NOT(vb_found) THEN
                  vb_erro := TRUE;
                  cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Domínio ['||dest.destaque||'] informado é inválido para a NCM['||nfi.ncm||'].','E');
                END IF;
              END IF;

              vb_found := TRUE;
            END IF;
          END LOOP; --cur_due_dest

          IF NOT vb_found THEN

            vn_destaques := 0;
            OPEN cur_destaques(nfi.ncm);
            FETCH cur_destaques INTO vn_destaques;
            CLOSE cur_destaques;

            IF(Nvl(vn_destaques ,0) > 0) THEN
              vb_erro := TRUE;
              cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Preencha o(s) atributo(s) para a NCM['||nfi.ncm||'].','E');
            END IF;
          END IF;

          FOR pais_dest IN cur_pais_dest(nfi.due_ship_item_id) LOOP
            IF pais_dest.countrycode IS NULL THEN
              vb_erro := TRUE;
              cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Preencha o país de destino.','E');
            END IF;

            IF pais_dest.gm_tariffquantity IS NULL THEN
              vb_erro := TRUE;
              cmx_prc_gera_log_erros( vn_evento_id
                                    , vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Preencha o campo quantidade exportada.'
                                    , 'E'
                                    , 'Por favor, verifique se está parametrizado corretamente a conversão para unidade de medida estatística.'
                                    );
            END IF;

          END LOOP;

          OPEN cur_enq (nfi.due_ship_item_id);
          FETCH cur_enq INTO vn_dummy;
          vb_found := cur_enq%FOUND;
          CLOSE cur_enq;

          IF NOT vb_found THEN
            vb_erro := TRUE;
            cmx_prc_gera_log_erros(vn_evento_id, vc_complemento||'Nota['||nf.numero_nf||'], Item [' || nfi.sequence || '] - Preencha o enquadramento.','E');
          END IF;

        END LOOP;
      END LOOP;

    FOR vr_add_info IN (SELECT due_add_info_id
                             , statementdescription
                             , cmx_pkg_tabelas.auxiliar('281', statementtypecode, 2) tam_maximo
                             , nvl (cmx_pkg_tabelas.auxiliar('281', statementtypecode, 3), 'N') truncar
                             , statementtypecode
                          FROM exp_due_add_info edai
                         WHERE due_id = pn_due_id) LOOP
      IF length (vr_add_info.statementdescription) > vr_add_info.tam_maximo THEN
         IF vr_add_info.truncar = 'S' THEN
           BEGIN
           UPDATE exp_due_add_info edai
              SET statementdescription = SubStr(statementdescription,1,vr_add_info.tam_maximo)
            WHERE edai.due_add_info_id = vr_add_info.due_add_info_id;
           EXCEPTION
             WHEN OTHERS THEN
               cmx_prc_gera_log_erros(vn_evento_id, cmx_fnc_texto_traduzido('Erro UPDATE Tamanho máximo do campo @@01@@ (@@02@@) - @@03@@', 'EXP_PKG_DUE','FNC_GERAR_DUE_024.2',null,vr_add_info.statementtypecode, vr_add_info.tam_maximo,sqlerrm),'E');
               vb_erro := TRUE;
           END;
         ELSE
          cmx_prc_gera_log_erros(vn_evento_id, cmx_fnc_texto_traduzido('Tamanho máximo do campo @@01@@ (@@02@@) excedido!', 'EXP_PKG_DUE','FNC_GERAR_DUE_024.1',null,vr_add_info.statementtypecode, vr_add_info.tam_maximo),'E');
          vb_erro := TRUE;
         END IF;
      END IF;
    END LOOP;

    FOR vr_add_info IN (SELECT due_gs_add_info_id
                             , statementdescription
                             , cmx_pkg_tabelas.auxiliar('281', statementtypecode, 2) tam_maximo
                             , nvl (cmx_pkg_tabelas.auxiliar('281', statementtypecode, 3), 'N') truncar
                             , statementtypecode
                          FROM exp_due_gs_add_info edai
                             , exp_due_ship i
                         WHERE i.due_ship_id = edai.due_ship_id
                           AND i.due_id = pn_due_id) LOOP
      IF length (vr_add_info.statementdescription) > vr_add_info.tam_maximo THEN
         IF vr_add_info.truncar = 'S' THEN
           BEGIN
           UPDATE exp_due_gs_add_info i
              SET statementdescription = SubStr(statementdescription,1,vr_add_info.tam_maximo)
            WHERE i.due_gs_add_info_id = vr_add_info.due_gs_add_info_id;
           EXCEPTION
             WHEN OTHERS THEN
               cmx_prc_gera_log_erros(vn_evento_id, cmx_fnc_texto_traduzido('Erro UPDATE Tamanho máximo do campo @@01@@ (@@02@@) - @@03@@', 'EXP_PKG_DUE','FNC_GERAR_DUE_024.2',null,vr_add_info.statementtypecode, vr_add_info.tam_maximo,sqlerrm),'E');
               vb_erro := TRUE;
           END;
         ELSE
          cmx_prc_gera_log_erros(vn_evento_id, cmx_fnc_texto_traduzido('Tamanho máximo do campo @@01@@ (@@02@@) excedido!', 'EXP_PKG_DUE','FNC_GERAR_DUE_024.1',null,vr_add_info.statementtypecode, vr_add_info.tam_maximo),'E');
          vb_erro := TRUE;
         END IF;
      END IF;
    END LOOP;

    FOR vr_add_info IN (SELECT due_gsi_add_info_id
                             , statementdescription
                             , cmx_pkg_tabelas.auxiliar('281', statementtypecode, 2) tam_maximo
                             , nvl (cmx_pkg_tabelas.auxiliar('281', statementtypecode, 3), 'N') truncar
                             , statementtypecode
                          FROM exp_due_gs_item_add_info edai
                             , exp_due_ship_item i
                         WHERE i.due_ship_item_id = edai.due_ship_item_id
                           AND i.due_id = pn_due_id) LOOP
      IF length (vr_add_info.statementdescription) > vr_add_info.tam_maximo THEN
         IF vr_add_info.truncar = 'S' THEN
          BEGIN
           UPDATE exp_due_gs_item_add_info i
              SET statementdescription = SubStr(statementdescription,1,vr_add_info.tam_maximo)
            WHERE i.due_gsi_add_info_id = vr_add_info.due_gsi_add_info_id;
           EXCEPTION
             WHEN OTHERS THEN
               cmx_prc_gera_log_erros(vn_evento_id, cmx_fnc_texto_traduzido('Erro UPDATE Tamanho máximo do campo @@01@@ (@@02@@) - @@03@@', 'EXP_PKG_DUE','FNC_GERAR_DUE_024.2',null,vr_add_info.statementtypecode, vr_add_info.tam_maximo,sqlerrm),'E');
               vb_erro := TRUE;
           END;
         ELSE
          cmx_prc_gera_log_erros(vn_evento_id, cmx_fnc_texto_traduzido('Tamanho máximo do campo @@01@@ (@@02@@) excedido!', 'EXP_PKG_DUE','FNC_GERAR_DUE_024.1',null,vr_add_info.statementtypecode, vr_add_info.tam_maximo),'E');
          vb_erro := TRUE;
         END IF;
      END IF;
    END LOOP;


    ELSE
      vb_erro := TRUE;
      vn_evento_id := cmx_fnc_gera_evento('PN_DUE_ID : [' || pn_due_id || ' ] não existe.',SYSDATE, pn_usuario_id);
    END IF;

    IF vb_erro THEN
      RETURN vn_evento_id;
    ELSE
      RETURN NULL;
    END IF;
  END fnc_valida_trans_due;

 FUNCTION fnc_atualiza_due( pn_due_id NUMBER
                          , pn_evento_id NUMBER
                          , pn_usuario_id NUMBER
                          ) RETURN NUMBER
  AS

    CURSOR cur_dados
        IS
    SELECT fatura_id
         , embarque_id
         , fatura_numero
         , fatura_ano
         , empresa_id
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         , importer_name
         , importer_addr_country
         , importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type
         , due_fatura_id
      FROM (SELECT ef.fatura_id
                 , ef.embarque_id
                 , ef.fatura_numero
                 , ef.fatura_ano
                 , ef.empresa_id
                 , exp_pkg_due.fnc_ind_due('EX0010' ,'F', ef.fatura_id )         doffice_identification
                 , NVL( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                      , exp_pkg_due.fnc_ind_due('EX0037_CNPJ' ,'F', ef.fatura_id )
                      )                                                          whs_identification
                 , Decode( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                         , NULL
                         , '22'
                         , '281'
                         )                                                       whs_type
                 , exp_pkg_due.fnc_ind_due('EX0063' ,'F', ef.fatura_id )         whs_latitude
                 , exp_pkg_due.fnc_ind_due('EX0064' ,'F', ef.fatura_id )         whs_longitude
                 , exp_pkg_due.fnc_ind_due('EX0062' ,'F', ef.fatura_id )         whs_addr_line
                 , exp_pkg_due.fnc_ind_due('EX0039' ,'F', ef.fatura_id )         currencytype
                 , exp_pkg_due.fnc_ind_due('EX0011' ,'F', ef.fatura_id )         exitoffice_identification
                 , exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )         exitoffice_whs_identification
                 , Decode( exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )
                         , NULL
                         , '22'
                         , '281'
                         )                                                       exitoffice_whs_type
                 , exp_pkg_due.fnc_ind_due('EX0008' ,'F', ef.fatura_id )         importer_name
                 , exp_pkg_due.fnc_ind_due('EX0009' ,'F', ef.fatura_id )         importer_addr_country
                 , exp_pkg_due.fnc_ind_due('EX0036' ,'F', ef.fatura_id )         importer_addr_line
                 , exp_pkg_due.fnc_ind_due('EX0040_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao
                 , exp_pkg_due.fnc_ind_due('EX0041_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao_type
                 , exp_pkg_due.fnc_ind_due('EX0040_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial
                 , exp_pkg_due.fnc_ind_due('EX0041_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial_type
                 , exp_pkg_due.fnc_ind_due('EX0040_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte
                 , exp_pkg_due.fnc_ind_due('EX0041_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte_type
                 , exp_pkg_due.fnc_ind_due('EX0042_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais
                 , exp_pkg_due.fnc_ind_due('EX0041_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais_type
                 , edft.due_fatura_id
              FROM exp_faturas ef
                , exp_due_faturas edft
            WHERE ef.fatura_id = edft.fatura_id
              AND edft.due_id = pn_due_id
          ) tbl
  ORDER BY fatura_ano
         , fatura_numero
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         --, importer_name
         , importer_addr_country
         --, importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type;

    CURSOR cur_due_nf IS
      SELECT fatura_nf_id, fatura_id
        FROM exp_due_ship
       WHERE fatura_nf_id IS NOT NULL
         AND due_id = pn_due_id;

    CURSOR cur_due_fat_nf IS
      SELECT efn.fatura_nf_id, efn.fatura_id
        FROM exp_due_faturas edf
           , exp_fatura_nf   efn
       WHERE edf.fatura_id = efn.fatura_id
         AND edf.due_id    = pn_due_id
         AND NOT EXISTS ( SELECT NULL
			                      FROM exp_due_ship    edfn
			                         , exp_due         ed
			                     WHERE edfn.due_id       = ed.due_id
			                       AND edfn.fatura_id    = efn.fatura_id
			                       AND ed.dt_cancel IS NULL
			                       AND edfn.fatura_nf_id = efn.fatura_nf_id
		                    );

    vr_fat_ant cur_dados%ROWTYPE;
    vb_erro              BOOLEAN;
    vn_due_id            NUMBER;
    vn_criacao           NUMBER;
    vc_ucr               VARCHAR2(35);
    vn_retorno           NUMBER;
    vn_qtde              NUMBER := 0;
  BEGIN
    -- verifica se alguma fatura tem informação divergente das demais.
    --vn_retorno := fnc_valida_due(pn_due_id, pn_evento_id );
    --IF vn_retorno IS NOT NULL THEN
    --  RETURN null;
    --END IF;

    --Inseri as notas fiscais na tabela temporária exp_due_fatura_nf_tmp
    DELETE FROM exp_due_fatura_nf_tmp;

    FOR nf IN cur_due_nf LOOP

      INSERT INTO exp_due_fatura_nf_tmp ( fatura_id
                                        , fatura_nf_id
                                        )
                                 VALUES ( nf.fatura_id
                                        , nf.fatura_nf_id
                                        );

      vn_qtde := vn_qtde + 1;
    END LOOP;

    IF(Nvl(vn_qtde,0) = 0) THEN

      FOR nf IN cur_due_fat_nf LOOP
        INSERT INTO exp_due_fatura_nf_tmp ( fatura_id
                                          , fatura_nf_id
                                          )
                                   VALUES ( nf.fatura_id
                                          , nf.fatura_nf_id
                                          );
      END LOOP;

    END IF;

    vn_qtde    := 0;
    vr_fat_ant := NULL;
    --OPEN cur_dados;
    --FETCH cur_dados INTO vr_fat_ant;
    --CLOSE cur_dados;

    FOR x IN cur_dados LOOP

      IF(vn_qtde = 0) THEN
        UPDATE exp_due
          SET doffice_identification           = vr_fat_ant.doffice_identification
            , whs_identification               = vr_fat_ant.whs_identification
            , whs_type                         = vr_fat_ant.whs_type
            , whs_latitude                     = vr_fat_ant.whs_latitude
            , whs_longitude                    = vr_fat_ant.whs_longitude
            , whs_addr_line                    = vr_fat_ant.whs_addr_line
            , currencytype                     = vr_fat_ant.currencytype
            --, declarant_identification         = vr_fat_ant.declarant_identification
            , exitoffice_identification        = vr_fat_ant.exitoffice_identification
            , exitoffice_whs_identification    = vr_fat_ant.exitoffice_whs_identification
            , exitoffice_whs_type              = vr_fat_ant.exitoffice_whs_type
    --         , importer_name                    = vr_fat_ant.importer_name
            , importer_addr_country            = vr_fat_ant.importer_addr_country
    --         , importer_addr_line               = vr_fat_ant.importer_addr_line
            , last_update_date                 = sysdate
            , last_updated_by                  = pn_usuario_id
        WHERE due_id = pn_due_id;
      END IF;

      UPDATE exp_due_faturas SET importer_name          = x.importer_name
                               , importer_addr_country  = x.importer_addr_country
                               , importer_addr_line     = x.importer_addr_line
                           WHERE due_fatura_id = x.due_fatura_id;

      vn_qtde := vn_qtde + 1;
    END LOOP;

    vn_due_id := fnc_criar_due(pn_due_id, pn_evento_id, pn_usuario_id);

    COMMIT;

    RETURN vn_due_id;
  END fnc_atualiza_due;

  FUNCTION fnc_ret_fatura_due (pn_due_id NUMBER) RETURN VARCHAR2
  IS
    CURSOR cur_fatura  IS
      SELECT DISTINCT SubStr(cmx_fnc_string_agg(ef1.fatura_numero|| '/' || ef1.fatura_ano),1,4000) fatura
        FROM exp_faturas ef1
           , exp_due_faturas edf
       WHERE ef1.fatura_id = edf.fatura_id
         AND edf.due_id = pn_due_id;

    vc_retorno VARCHAR2(4000) := NULL;
  BEGIN

    IF(pn_due_id IS NOT NULL) THEN
      OPEN  cur_fatura;
      FETCH cur_fatura INTO vc_retorno;
      CLOSE cur_fatura;
    END IF;

    vc_retorno := 'Fatura(s): '||vc_retorno;

    RETURN vc_retorno;
  END fnc_ret_fatura_due;

  PROCEDURE prc_busca_atributo_ncm( pn_due_id             NUMBER
                                  , pn_due_ship_item_id   NUMBER
                                  , pc_ncm                VARCHAR2
                                  , pn_atributo_id        NUMBER
                                  , pc_formula            VARCHAR2
                                  , pc_destaque           OUT VARCHAR2
                                  ) AS
  BEGIN

    IF(pc_formula IS NOT NULL) THEN
      EXECUTE IMMEDIATE pc_formula USING pn_due_id
                                       , pn_due_ship_item_id
                                       , pc_ncm
                                       , pn_atributo_id
                                       , OUT pc_destaque;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      pc_destaque     := NULL;
  END prc_busca_atributo_ncm;

  FUNCTION fnc_ret_descricao_item (pn_fatura_item_id NUMBER, pn_fat_item_det_id NUMBER) RETURN VARCHAR2 IS

    CURSOR cur_itens_dsc_pais(pn_item_id NUMBER)
        IS
    SELECT item.descricao
      FROM cmx_itens_dsc item
         , cmx_tabelas idioma
     WHERE idioma.tipo      = '905'
       AND idioma.codigo    = nvl(cmx_fnc_profile ( 'EXP_IDIOMA_BR'), 'PT')
       AND idioma.tabela_id = item.idioma_id
       AND item.tipo        = nvl(cmx_fnc_profile ('EXP_IDIOMA_TIPO_BR'), 'S')
       AND item.aplicacao   = 'E'
       AND item.item_id     = pn_item_id;

    CURSOR cur_fat_lin_item
        IS
    SELECT item_id, descricao, codigo
      FROM exp_fatura_itens
     WHERE fatura_item_id = pn_fatura_item_id;

    CURSOR cur_serie
        IS
    SELECT serie
      FROM exp_fatura_item_detalhes
     WHERE fatura_item_detalhe_id = pn_fat_item_det_id;

    vc_prof_cd_item     VARCHAR2(01) DEFAULT 'N';
    vc_descricao        VARCHAR2(4000);
    vc_descricao_item   VARCHAR2(4000);
    vc_codigo           VARCHAR2(256);
    vc_serie            VARCHAR2(250);
    vn_item_id          NUMBER := NULL;
    vc_geracao_re       cmx_profiles.conteudo%TYPE;
    vb_achou            BOOLEAN := FALSE;
  BEGIN

    vc_geracao_re := substr(cmx_fnc_profile('GERACAO_RE'),1,7);
    IF(vc_geracao_re IS NOT NULL ) THEN
      vc_prof_cd_item    := SUBSTR(vc_geracao_re,2,1);
    END IF;

    OPEN  cur_fat_lin_item;
    FETCH cur_fat_lin_item INTO vn_item_id, vc_descricao_item, vc_codigo;
    CLOSE cur_fat_lin_item;

    IF(vn_item_id IS NOT NULL) THEN
      OPEN  cur_itens_dsc_pais(vn_item_id);
      FETCH cur_itens_dsc_pais INTO vc_descricao;
      vb_achou := cur_itens_dsc_pais%FOUND;
      CLOSE cur_itens_dsc_pais;
    END IF;

    IF(vc_descricao IS NULL AND vn_item_id IS NULL) THEN
      vc_descricao := vc_descricao_item;
    ELSIF(vc_descricao IS NULL AND vn_item_id IS NOT NULL) THEN
      vc_descricao := cmx_pkg_itens.descricao(vn_item_id);
    END IF;

    IF vc_prof_cd_item = 'S' THEN
      vc_descricao := rtrim(ltrim(vc_codigo))||' - '||rtrim(ltrim(vc_descricao));
    END IF;

    OPEN  cur_serie;
    FETCH cur_serie INTO vc_serie;
    CLOSE cur_serie;

    IF(vc_serie IS NOT NULL) THEN
      vc_descricao := vc_descricao || ' Serie: '||vc_serie;
    END IF;

    RETURN vc_descricao;
  END;

  FUNCTION fnc_proc_retorno_cancel( pn_due_id      NUMBER
                                  , pn_usuario_id  NUMBER
                                  , pn_evento_id   NUMBER
                                  , pc_motivo      VARCHAR2
                                  ) RETURN VARCHAR2 IS

    CURSOR cur_retorno(pc_conteudo VARCHAR2)
        IS
    SELECT extract(Value(tbl), '//message/text()').getstringval() retorno
      FROM TABLE ( XMLSequence( extract ( XMLType(pc_conteudo)
                                        , '/'
                                        )
                              )
                 ) tbl;

    vc_clob     CLOB;
    vb_erro     BOOLEAN := FALSE;
    vc_retorno  VARCHAR2(4000);
  BEGIN

    vc_clob :=  fnc_base64_clob(gc_ret_b64);

    IF(Dbms_Lob.getlength(vc_clob) > 0) THEN

      vc_clob := '<msg>'||vc_clob||'</msg>';

      OPEN  cur_retorno(vc_clob);
      FETCH cur_retorno INTO vc_retorno;
      CLOSE cur_retorno;

      IF(InStr(Lower(vc_retorno), 'cancelada com sucesso') > 0) THEN

        UPDATE exp_due SET dt_cancel           = SYSDATE
                         , motivo_cancelamento = pc_motivo
                     WHERE due_id = pn_due_id;

        cmx_prc_gera_log_erros( pn_evento_id
                              , vc_retorno
                              , 'A'
                              );
      ELSE
        vb_erro := TRUE;
        cmx_prc_gera_log_erros( pn_evento_id
                              , 'Erro ['||SubStr(vc_clob,1,4000)||']'
                              , 'E'
                              );
      END IF;

    ELSE
      vb_erro := TRUE;
      cmx_prc_gera_log_erros( pn_evento_id
                            , 'Não foi possível solicitar o cancelamento da DUE.'
                            , 'E'
                            );
    END IF;

    IF(vb_erro) THEN
      RETURN 'ERRO';
    ELSE
      RETURN NULL;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      cmx_prc_gera_log_erros( pn_evento_id
                            , 'Erro ['||SubStr(vc_clob,1,4000)||']'
                            , 'E'
                            );
      RETURN 'ERRO';
  END fnc_proc_retorno_cancel;

  FUNCTION fnc_vlr_comissao ( pn_fatura_item_id  NUMBER DEFAULT NULL
                            , pn_ncm_id          NUMBER DEFAULT NULL
                            ) RETURN NUMBER AS

    CURSOR cur_comissao IS
      SELECT SUM(percentual)    percentual
           , SUM(valor)         valor
        FROM exp_fatura_item_representantes
       WHERE fatura_item_id = pn_fatura_item_id;

    CURSOR cur_base_calculo IS
      SELECT SUM(valor.valor)                valor_base
        FROM exp_fatura_item_valores         valor
           , exp_fatura_item_representantes  repre
       WHERE valor.tipo_id                   = repre.base_calculo_id
         AND repre.fatura_item_id            = valor.fatura_item_id
         AND valor.fatura_item_id            = pn_fatura_item_id;

    CURSOR cur_ncm IS
      SELECT percentual_maximo_comissao
        FROM cmx_tab_ncm
       WHERE ncm_id = pn_ncm_id;

    CURSOR cur_profiles IS
      SELECT conteudo
        FROM cmx_profiles
       WHERE campo = 'ORIGEM_COMISSAO';

    vbAchou        BOOLEAN;
    vnValor        NUMBER;
    vnBaseCalculo  NUMBER;
    vnPercentual   NUMBER;
    vcPegarFatura  VARCHAR2(01);
  BEGIN --FUNCTION comissao

    vnValor := 0;
    OPEN cur_profiles;
    FETCH cur_profiles INTO vcPegarFatura;
    CLOSE cur_profiles;

    vcPegarFatura := NVL(vcPegarFatura,'S');

    IF vcPegarFatura = 'S' THEN
      OPEN  cur_comissao;
      FETCH cur_comissao INTO vnPercentual, vnValor;
      vbAchou := cur_comissao%FOUND;
      CLOSE cur_comissao;
    ELSE
      IF vcPegarFatura = 'R' THEN

        OPEN  cur_comissao;
        FETCH cur_comissao INTO vnPercentual, vnValor;
        vbAchou := cur_comissao%FOUND;
        CLOSE cur_comissao;

        OPEN  cur_base_calculo;
        FETCH cur_base_calculo INTO vnBaseCalculo;
        vbAchou := cur_base_calculo%FOUND;
        CLOSE cur_base_calculo;

        IF nvl(vnBaseCalculo,0) = 0 or nvl(vnValor,0) = 0 THEN
            vnPercentual := 0;
        ELSE
            vnPercentual := ( vnValor / vnBaseCalculo ) * 100;
        END IF;
      ELSE
        OPEN  cur_ncm;
        FETCH cur_ncm INTO vnPercentual;
        vbAchou := cur_ncm%FOUND;
        CLOSE cur_ncm;
        IF (vnValor IS null) THEN
          vnValor := 20;
        END IF;
      END IF;
    END IF;

    RETURN (nvl (vnPercentual, 0));
  END fnc_vlr_comissao;

  PROCEDURE prc_atualiza_datas( pn_due_id    NUMBER
                              , pc_situacao  VARCHAR2
                              , pd_data      DATE
                              )
  IS
    CURSOR cur_fat
        IS
    SELECT ef.fatura_id
         , ef.embarque_id
      FROM exp_faturas ef
         , exp_due_faturas edf
     WHERE ef.fatura_id = edf.fatura_id
       AND edf.due_id   = pn_due_id;

    CURSOR cur_data
        IS
    SELECT ct_data.tabela_id
         , ct_data.auxiliar3
      FROM cmx_tabelas de_para
         , cmx_tabelas ct_data
     WHERE de_para.auxiliar2 = ct_data.codigo
       AND ct_data.tipo = '203'
       AND de_para.tipo = '288'
       AND pc_situacao  LIKE de_para.auxiliar1;

  BEGIN
    FOR vr_data IN cur_data
    LOOP
      FOR vr_fat IN cur_fat
      LOOP
        exp_prc_atualiza_data( vr_data.tabela_id
                             , vr_data.auxiliar3
                             , pd_data
                             , vr_fat.fatura_id
                             , vr_fat.embarque_id
                             );
      END LOOP;
    END LOOP;

  END prc_atualiza_datas;

  FUNCTION fnc_proc_retorno_situacao( pn_due_id      NUMBER
                                    , pn_usuario_id  NUMBER
                                    , pn_evento_id   NUMBER DEFAULT NULL
                                    , pn_nr_linha    NUMBER DEFAULT NULL
                                    ) RETURN VARCHAR2 IS

    CURSOR cur_listas(px_xml CLOB)
        IS
    SELECT extract(Value(tbl), '//eventosDoHistorico').getclobval()  listas
         , extract(Value(tbl), '//canal/text()').getstringval()      canal
         , extract(Value(tbl), '//solicitacoes').getclobval()        solicitacoes
      FROM TABLE ( xmlsequence( extract ( xmltype(px_xml)
                                        , '/lista'
                                        )
                              )
                 ) tbl;

    CURSOR cur_listas_hist(pc_xml CLOB)
        IS
    SELECT extract(Value(tbl), '/').getclobval()  lista
      FROM TABLE ( xmlsequence( extract ( xmltype(pc_xml)
                                        , '//eventosDoHistorico'
                                        )
                              )
                 ) tbl;

    CURSOR cur_listas_solic_hist(pc_xml CLOB)
        IS
    SELECT extract(Value(tbl), '/').getclobval()  lista
      FROM TABLE ( xmlsequence( extract ( xmltype(pc_xml)
                                        , '//solicitacoes'
                                        )
                              )
                 ) tbl;

    CURSOR cur_situacao(pc_xml CLOB)
        IS
    SELECT extract(Value(tbl), '//dataEHoraDoEvento/text()').getstringval()       dataevento
         , extract(Value(tbl), '//evento/text()').getstringval()                  situacao
         , extract(Value(tbl), '//responsavel/text()').getstringval()             responsavel
         , extract(Value(tbl), '//id/text()').getstringval()                      id
         , extract(Value(tbl), '//informacoesAdicionais/text()').getstringval()   informacoesAdicionais
         , extract(Value(tbl), '//motivo/text()').getstringval()                  motivo
      FROM TABLE ( xmlsequence( extract ( xmltype(pc_xml)
                                        , '/'
                                        )
                              )
                 ) tbl;

    CURSOR cur_solicitacao(pc_xml CLOB)
        IS
    SELECT extract(Value(tbl), '//tipoSolicitacao/text()').getstringval()             tipoSolicitacao
         , extract(Value(tbl), '//dataDaSolicitacao/text()').getstringval()           dataDaSolicitacao
         , extract(Value(tbl), '//usuarioResponsavel/text()').getstringval()          usuarioResponsavel
         , extract(Value(tbl), '//codigoDoStatusDaSolicitacao/text()').getstringval() codigoDoStatusDaSolicitacao
         , extract(Value(tbl), '//statusDaSolicitacao/text()').getstringval()         statusDaSolicitacao
         , extract(Value(tbl), '//dataDeApreciacao/text()').getstringval()            dataDeApreciacao
         , extract(Value(tbl), '//usuarioQueAnalisou/text()').getstringval()          usuarioQueAnalisou
         , extract(Value(tbl), '//motivo/text()').getstringval()                      motivo
         , extract(Value(tbl), '//numeroDoComprot/text()').getstringval()             numeroDoComprot
         , extract(Value(tbl), '//motivoDoIndeferimento/text()').getstringval()       motivoDoIndeferimento
      FROM TABLE ( xmlsequence( extract ( xmltype(pc_xml)
                                        , '/'
                                        )
                              )
                 ) tbl;

    CURSOR cur_due IS
      SELECT numero
        FROM exp_due
       WHERE due_id = pn_due_id;

    CURSOR cur_due_sit(pc_situacao VARCHAR2, pd_data DATE)
        IS
    SELECT due_situacao_id
      FROM exp_vw_due_hist_situacao
     WHERE due_id                  = pn_due_id
       AND Upper(situacaodue_desc) = pc_situacao
       AND (datasituacaodue =  pd_data OR pd_data IS NULL);

    CURSOR cur_due_solic(pc_tiposolicitacao VARCHAR2, pd_data DATE)
        IS
    SELECT due_solicitacao_id
      FROM exp_due_hist_solicitacao
     WHERE due_id                  = pn_due_id
       AND Upper(tiposolicitacao) = pc_tiposolicitacao
       AND (datadasolicitacao =  pd_data OR pd_data IS NULL);

    CURSOR cur_ult_status
        IS
    SELECT situacaodue
         , datasituacaodue
         , indicadorbloqueio
         , situacao_desc
         , controleadministrativo
         , situacaocarga
      FROM exp_due_hist_situacao
     WHERE due_id = pn_due_id
     ORDER BY datasituacaodue DESC, due_situacao_id desc;

    vr_situacao         cur_situacao%ROWTYPE;
    vr_solicitacao      cur_solicitacao%ROWTYPE;
    vr_cur_ult_status   cur_ult_status%ROWTYPE;
    vc_nr_due           VARCHAR2(14);
    vb_erro             BOOLEAN := FALSE;
    vc_clob             CLOB;
    vc_lista            CLOB;
    vc_lista_solic      CLOB;
    vb_achou            BOOLEAN := FALSE;
    vn_temp_id          NUMBER;
    vc_situacao         VARCHAR2(4000);
    vc_data             VARCHAR2(4000);
    vd_data             DATE;
    vd_data_solicitacao DATE;
    vd_data_apreciacao  DATE;
    vc_situacao_cod     VARCHAR2(20);
    vn_timestamp        NUMBER;

    vc_etapa            VARCHAR2(4000);
    vc_canal            VARCHAR2(4000);

    vc_motivo_cancelamento VARCHAR2(4000);
  BEGIN
    vc_clob :=  fnc_base64_clob(gc_ret_b64);

    vc_etapa := 'Recup. Nr. DUE';
    OPEN  cur_due;
    FETCH cur_due INTO vc_nr_due;
    CLOSE cur_due;

    IF(dbms_lob.getlength(vc_clob) > 0) THEN

      UPDATE exp_due SET xml_retorno = vc_clob
                     WHERE due_id = pn_due_id;

      --vc_clob := '<dueinfo>'||vc_clob||'</dueinfo>';
      --vc_lista := '<lista>'||vc_clob||'</lista>';
      vc_clob := '<lista>'||vc_clob||'</lista>';

      vc_etapa := 'Recup. Lista';
      OPEN  cur_listas(vc_clob);
      FETCH cur_listas INTO vc_lista, vc_canal, vc_lista_solic;
      CLOSE cur_listas;

      --IF(Dbms_Lob.getlength(vc_lista) > 0) THEN
      IF(InStr(vc_lista, 'eventosDoHistorico') > 0) THEN

        vc_lista := '<lista>'||vc_lista||'</lista>';

        vc_etapa := 'Recup. Lista situação';
        FOR x IN cur_listas_hist(vc_lista) LOOP

          vc_etapa := 'Recup. Situação';
          OPEN  cur_situacao(x.lista);
          FETCH cur_situacao INTO vr_situacao;
          CLOSE cur_situacao;

          --Verifica se o evento já foi cadastrado.
          vc_situacao := Upper(vr_situacao.situacao);
          vc_situacao_cod := NULL;
          IF(vc_situacao = 'CANCELAMENTO PELO EXPORTADOR') THEN
            vc_situacao := 'CANCELADA PELO EXPORTADOR';
            vc_situacao_cod := '80';
          ELSIF(vc_situacao = 'REGISTRO') THEN
            vc_situacao_cod := '10';
            vc_situacao := 'REGISTRADA';
          ELSIF(vc_situacao = 'AVERBAÇÃO') THEN
            vc_situacao_cod := '70';
            vc_situacao := 'AVERBADA';
          ELSIF(vc_situacao = 'DESEMBARAÇO') THEN
            vc_situacao_cod := '40';
            vc_situacao := 'DESEMBARAÇADA';
          ELSIF(vc_situacao = 'LIBERAÇÃO SEM CONFERÊNCIA ADUANEIRA') THEN
            vc_situacao_cod := '20';
            vc_situacao := 'LIBERADA SEM CONFERÊNCIA ADUANEIRA CANAL VERDE';
          ELSIF(vc_situacao = 'APRESENTAÇÃO PARA DESPACHO') THEN
            vc_situacao_cod := '11';
            vc_situacao := 'DECLARAÇÃO APRESENTADA PARA DESPACHO';
          END IF;

          vd_data := NULL;
          vc_data := NULL;
          IF(vr_situacao.dataevento IS NOT NULL) THEN

              BEGIN
                --EXECUTE IMMEDIATE 'ALTER SESSION SET TIME_ZONE=''-03:00''';
                --vc_data := To_Char(cast(to_timestamp_tz(vr_situacao.dataevento, 'yyyy-mm-dd"T"hh24:mi:ss.ff3tzh:tzm') AS TIMESTAMP WITH LOCAL TIME ZONE), 'RRRR-MM-DD HH24:MI:SS' );

                vc_data := To_Char(FROM_TZ(CAST(to_timestamp_tz(vr_situacao.dataevento,'yyyy-mm-dd"T"hh24:mi:ss.ff3tzh:tzm') as TIMESTAMP), 'UTC') AT TIME ZONE 'BRAZIL/EAST', 'YYYY-MM-DD HH24:MI:SS');
                vd_data :=  To_Date(vc_data, 'RRRR-MM-DD HH24:MI:SS');

              EXCEPTION
                WHEN OTHERS THEN
                  vc_data := SubStr(vr_situacao.dataevento, 1, InStr(vr_situacao.dataevento, '+')-1);
                  vc_data := SubStr(vc_data, 1, InStr(vc_data, '.')-1);
                  vc_data := REPLACE(vc_data, 'T', ' ');
                  vd_data :=  To_Date(vc_data, 'RRRR-MM-DD HH24:mi:ss');
              END;

          ELSE
              vc_data := NULL;
          END IF;

          vb_achou := FALSE;
          OPEN  cur_due_sit(vc_situacao, vd_data);
          FETCH cur_due_sit INTO vn_temp_id;
          vb_achou := cur_due_sit%FOUND;
          CLOSE cur_due_sit;

          IF NOT(vb_achou) THEN
            vc_etapa := 'Convertendo Data';
            INSERT INTO exp_due_hist_situacao ( due_situacao_id
                                              , due_id
                                              , situacaodue
                                              , situacao_desc
                                              , datasituacaodue
                                              , creation_date
                                              , created_by
                                              , last_update_date
                                              , last_updated_by
                                              , informacoesadicionais
                                              , motivo
                                              , responsaveluadespacho
                                              )
                                       VALUES ( cmx_fnc_proxima_sequencia('exp_due_hist_situacao_sq1')
                                              , pn_due_id
                                              , vc_situacao_cod
                                              , vc_situacao
                                              , vd_data
                                              , SYSDATE
                                              , pn_usuario_id
                                              , SYSDATE
                                              , pn_usuario_id
                                              , vr_situacao.informacoesAdicionais
                                              , vr_situacao.motivo
                                              , vr_situacao.responsavel
                                              );

            IF(vc_situacao = 'AVERBADA') THEN
              BEGIN
                UPDATE exp_due SET dt_averbacao = vd_data WHERE due_id = pn_due_id;
              EXCEPTION
                WHEN OTHERS THEN
                  cmx_prc_gera_log_erros( pn_evento_id
                                        , 'DUE['||vc_nr_due||'] - Não foi possível atualizar da Data de averbação. ['||sqlerrm||']'
                                        , 'A'
                                        );
              END;

            ELSIF(vc_situacao = 'CANCELADA PELO EXPORTADOR') THEN

              vc_motivo_cancelamento := vr_situacao.motivo;

              IF(vc_motivo_cancelamento IS NULL) THEN
                vc_motivo_cancelamento := vr_situacao.informacoesAdicionais;
              ELSE
                vc_motivo_cancelamento := vc_motivo_cancelamento ||' - '|| vr_situacao.informacoesAdicionais;
              END IF;

              UPDATE exp_due SET dt_cancel = vd_data
                               , motivo_cancelamento = SubStr(vc_motivo_cancelamento, 1, 550)
                           WHERE due_id = pn_due_id;
            END IF;

          END IF;

          prc_atualiza_datas( pn_due_id
                            , Upper(vr_situacao.situacao)
                            , vd_data
                            );


        END LOOP;

        --Gravar o último status da DUE
        OPEN  cur_ult_status;
        FETCH cur_ult_status INTO vr_cur_ult_status;
        CLOSE cur_ult_status;

        UPDATE exp_due SET situacaodue                = vr_cur_ult_status.situacaodue
                         , datasituacaodue            = vr_cur_ult_status.datasituacaodue
                         , indicadorbloqueio          = vr_cur_ult_status.indicadorbloqueio
                         , controleadministrativo     = vr_cur_ult_status.controleadministrativo
                         , situacao_desc              = vr_cur_ult_status.situacao_desc
                         , situacaocarga              = vr_cur_ult_status.situacaocarga
                         , canal                      = vc_canal
                     WHERE due_id = pn_due_id;

      ELSE
        vb_erro := TRUE;
        cmx_prc_gera_log_erros( pn_evento_id
                              , 'DUE['||vc_nr_due||'] Não foi possível recuperar a situação.'
                              , 'E'
                              );
      END IF;

      IF(InStr(vc_lista_solic, 'solicitacoes') > 0) THEN

        vc_lista := '<lista>'||vc_lista_solic||'</lista>';

        vc_etapa := 'Recup. Lista solicitacao';

        FOR x IN cur_listas_solic_hist(vc_lista) LOOP

          vc_etapa := 'Recup. Solicitação';
          OPEN  cur_solicitacao(x.lista);
          FETCH cur_solicitacao INTO vr_solicitacao;
          CLOSE cur_solicitacao;

          vd_data_solicitacao := NULL;
          vd_data_apreciacao  := NULL;
          vc_data             := NULL;

          IF(vr_solicitacao.dataDaSolicitacao IS NOT NULL) THEN
            BEGIN
              vc_data := To_Char(FROM_TZ(CAST(to_timestamp_tz(vr_solicitacao.dataDaSolicitacao,'yyyy-mm-dd"T"hh24:mi:ss.ff3tzh:tzm') as TIMESTAMP), 'UTC') AT TIME ZONE 'BRAZIL/EAST', 'YYYY-MM-DD HH24:MI:SS');
              vd_data_solicitacao :=  To_Date(vc_data, 'RRRR-MM-DD HH24:MI:SS');
            EXCEPTION
              WHEN OTHERS THEN
                vc_data := SubStr(vr_solicitacao.dataDaSolicitacao, 1, InStr(vr_solicitacao.dataDaSolicitacao, '+')-1);
                vc_data := SubStr(vc_data, 1, InStr(vc_data, '.')-1);
                vc_data := REPLACE(vc_data, 'T', ' ');
                vd_data_solicitacao :=  To_Date(vc_data, 'RRRR-MM-DD HH24:mi:ss');
            END;
          ELSE
              vc_data := NULL;
          END IF;

          IF(vr_solicitacao.dataDeApreciacao IS NOT NULL) THEN
            BEGIN
              vc_data := To_Char(FROM_TZ(CAST(to_timestamp_tz(vr_solicitacao.dataDeApreciacao,'yyyy-mm-dd"T"hh24:mi:ss.ff3tzh:tzm') as TIMESTAMP), 'UTC') AT TIME ZONE 'BRAZIL/EAST', 'YYYY-MM-DD HH24:MI:SS');
              vd_data_apreciacao :=  To_Date(vc_data, 'RRRR-MM-DD HH24:MI:SS');
            EXCEPTION
              WHEN OTHERS THEN
                vc_data := SubStr(vr_solicitacao.dataDeApreciacao, 1, InStr(vr_solicitacao.dataDeApreciacao, '+')-1);
                vc_data := SubStr(vc_data, 1, InStr(vc_data, '.')-1);
                vc_data := REPLACE(vc_data, 'T', ' ');
                vd_data_apreciacao :=  To_Date(vc_data, 'RRRR-MM-DD HH24:mi:ss');
            END;
          ELSE
              vc_data := NULL;
          END IF;

          vb_achou := FALSE;
          OPEN  cur_due_solic(vc_situacao, vd_data_solicitacao);
          FETCH cur_due_solic INTO vn_temp_id;
          vb_achou := cur_due_solic%FOUND;
          CLOSE cur_due_solic;

          IF NOT(vb_achou) THEN
            vc_etapa := 'Insert exp_due_hist_solicitacao';
            INSERT INTO exp_due_hist_solicitacao ( due_solicitacao_id
                                                 , due_id
                                                 , tiposolicitacao
                                                 , datadasolicitacao
                                                 , usuarioresponsavel
                                                 , codigodostatusdasolicitacao
                                                 , statusdasolicitacao
                                                 , datadeapreciacao
                                                 , usuarioqueanalisou
                                                 , motivo
                                                 , numerodocomprot
                                                 , motivodoindeferimento
                                                 , creation_date
                                                 , created_by
                                                 , last_update_date
                                                 , last_updated_by
                                              )
                                       VALUES ( cmx_fnc_proxima_sequencia('exp_due_hist_solicitacao_sq1')
                                              , pn_due_id
                                              , vr_solicitacao.tiposolicitacao
                                              , vd_data_solicitacao
                                              , vr_solicitacao.usuarioresponsavel
                                              , vr_solicitacao.codigodostatusdasolicitacao
                                              , vr_solicitacao.statusdasolicitacao
                                              , vd_data_apreciacao
                                              , vr_solicitacao.usuarioqueanalisou
                                              , vr_solicitacao.motivo
                                              , vr_solicitacao.numerodocomprot
                                              , vr_solicitacao.motivodoindeferimento
                                              , SYSDATE
                                              , pn_usuario_id
                                              , SYSDATE
                                              , pn_usuario_id
                                              );
          END IF;
        END LOOP;
      END IF;

    ELSE
      vb_erro := TRUE;
      cmx_prc_gera_log_erros( pn_evento_id
                            , 'DUE['||vc_nr_due||'] Não foi possível recuperar a situação.'
                            , 'E'
                            );
    END IF;

    IF(vb_erro) THEN
      RETURN 'ERRO';
    ELSE
      RETURN NULL;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      cmx_prc_gera_log_erros( pn_evento_id
                            , 'Etapa['||vc_etapa||'], Erro ['||SubStr(vc_clob,1,4000)||']'
                            , 'E'
                            );
      RETURN 'ERRO';
  END fnc_proc_retorno_situacao;

  FUNCTION fnc_normalizar_texto_xml(pc_texto_in VARCHAR2)
  RETURN VARCHAR2
  AS
    vc_texto_out VARCHAR2(32760);
    vc_caracter  VARCHAR2(10);
    vn_cont      NUMBER;
  BEGIN

    IF (length (pc_texto_in) > 0) THEN

      FOR vn_cont IN 1..length (pc_texto_in) LOOP

        vc_caracter  := substr (pc_texto_in, vn_cont, 1);

        IF ( ascii(vc_caracter) < 32)  AND  (ascii(vc_caracter) NOT IN ( 10, 13 ) ) THEN
          vc_caracter := '&#'||ascii(vc_caracter)||';';
        END IF;
        vc_texto_out := vc_texto_out || vc_caracter;

      END LOOP;

    END IF;

    vc_texto_out := REPLACE(vc_texto_out, '&#0;', '');
    vc_texto_out := REPLACE(vc_texto_out, '   ', ' ');

    RETURN vc_texto_out;
  END;

  PROCEDURE p_prc_inserir_ato( pn_fat_item_det_ato_id     NUMBER
                             , pn_fat_item_ato_id         NUMBER
                             , pn_due_ship_item_id        NUMBER
                             , pn_usuario_id              NUMBER
                             , pn_fatura_id               NUMBER
                             , pn_fatura_item_id          NUMBER
                             , pn_fatura_item_detalhe_id  NUMBER
                             , pn_due_si_adoc_id          NUMBER
                             , pn_quantidade_est          NUMBER
                             , pc_tipo                    VARCHAR2
                             ) IS

    CURSOR cur_atos(pn_fat_item_det_ato_id NUMBER)
        IS
    SELECT efia.numero
         , efia.nr_item_drawback
         --, Sum(Nvl(nullif(efidna.qtde_estatistica,0), efida.quantidade_drw))  quantidade
         , Sum(Nvl(nullif(efida.quantidade_re,0), efida.quantidade_drw))       quantidade
         , Sum(efida.valor18b)        valor
         , efia.ncm
         , efia.cnpj
      FROM exp_vw_fatura_item_atos        efia
         , exp_fatura_item_detalhe_atos   efida
         --, exp_vw_fatura_item_det_nf_ato  efidna
     WHERE efia.fatura_item_ato_id          = efida.fatura_item_ato_id
       --AND efida.fatura_item_detalhe_ato_id = efidna.fatura_item_detalhe_ato_id
       AND efida.fatura_item_detalhe_ato_id = pn_fat_item_det_ato_id
       AND efia.numero IS NOT NULL
  GROUP BY efia.numero
         , efia.nr_item_drawback
         , efia.ncm
         , efia.cnpj
         , efida.fatura_item_ato_id;

    CURSOR cur_ato_rd
        IS
    SELECT efia.fatura_item_ato_id
         , efia.rd_id
         , drd.caracteristica_id
         , drd.modalidade
      FROM exp_fatura_item_atos  efia
         , drw_registro_drawback drd
     WHERE efia.numero = drd.numero(+)
       AND fatura_item_ato_id = pn_fat_item_ato_id;

    CURSOR cur_ato_nf_nac(pn_fatura_item_det_id NUMBER)
        IS
    SELECT numero_nf
         , serie
         , data_nf
         , Nvl(qtde_re, qtde) qtde
         , valor
      FROM exp_fatura_item_detalhes_nfnac
     WHERE fatura_item_detalhe_id = pn_fatura_item_det_id;

    CURSOR cur_adoc_inv(pc_identification VARCHAR2, pc_data DATE)
        IS
    SELECT due_si_adoc_inv_id
      FROM exp_due_si_adoc_inv
     WHERE due_si_adoc_id = pn_due_si_adoc_id
       AND identification = pc_identification
       AND issuedatetime  = pc_data;

    vr_ato_rd         cur_ato_rd%ROWTYPE;
    vn_due_si_adoc_id NUMBER;
    vb_achou          BOOLEAN := FALSE;
    vn_adoc_inv_id    NUMBER;
    vn_quantidade     NUMBER := 0;

  BEGIN

    /*
    EX0075 ItemID
    EX0076 QuantityQuantity
    EX0077 ValueWithExchangeCoverAmount
    EX0078 ValueWithoutExchangeCoverAmount
    EX0083 DrawbackHsClassification
    EX0084 DrawbackRecipientId
    */
    OPEN  cur_ato_rd;
    FETCH cur_ato_rd INTO vr_ato_rd;
    CLOSE cur_ato_rd;

    IF(Nvl(pc_tipo,'I') = 'I') THEN
      FOR ato IN cur_atos(pn_fat_item_det_ato_id)
      LOOP

        vn_due_si_adoc_id := cmx_fnc_proxima_sequencia('exp_due_si_adoc_sq1');

        IF(Nvl(pn_quantidade_est,0) > 0) THEN
          vn_quantidade := pn_quantidade_est;
        ELSE
          vn_quantidade := ato.quantidade;
        END IF;

        INSERT INTO exp_due_si_adoc
        (
          due_si_adoc_id
        , due_ship_item_id
        , identification
        , category
        , creation_date
        , created_by
        , last_update_date
        , last_updated_by
        , itemid
        , quantity
        , vlrwithexcoveramount
        , vlrwithoutexcoveramount
        , drawbackhsclassification
        , drawbackrecipientid
        ) VALUES (
                    vn_due_si_adoc_id
                  , pn_due_ship_item_id
                  , ato.numero
                  , exp_pkg_due.fnc_ind_due('EX0024' ,'L', pn_fatura_id, NULL , pn_fatura_item_id)
                  , SYSDATE
                  , pn_usuario_id
                  , SYSDATE
                  , pn_usuario_id
                  , ato.nr_item_drawback
                  , vn_quantidade
                  , ato.valor
                  , 0
                  , ato.ncm
                  , ato.cnpj
                  );

        /* Verifica se o está preenchido o rd_id.
            Se não estiver preenchido, verifica se possui nota fiscal nacional para o ATO */
        IF(vr_ato_rd.rd_id IS NULL) THEN
          --Ato NF entrada nacional
          FOR ato_nac IN cur_ato_nf_nac(pn_fatura_item_detalhe_id) LOOP
            INSERT INTO exp_due_si_adoc_inv ( due_si_adoc_inv_id
                                            , due_si_adoc_id
                                            , identification
                                            , issuedatetime
                                            , typecode
                                            , customsvalueamount
                                            , quantityquantity
                                            , creation_date
                                            , created_by
                                            , last_update_date
                                            , last_updated_by
                                            )
                                    VALUES ( cmx_fnc_proxima_sequencia('exp_due_si_adoc_inv_sq1')
                                            , vn_due_si_adoc_id
                                            , ato_nac.numero_nf
                                            , ato_nac.data_nf
                                            , '388'
                                            , ato_nac.valor
                                            , ato_nac.qtde
                                            , SYSDATE
                                            , 0
                                            , SYSDATE
                                            , 0
                                            );
          END LOOP;
        END IF;

      END LOOP;

    ELSE

      FOR ato IN cur_atos(pn_fat_item_det_ato_id)
      LOOP

        IF(Nvl(pn_quantidade_est,0) > 0) THEN
          vn_quantidade := pn_quantidade_est;
        ELSE
          vn_quantidade := ato.quantidade;
        END IF;

        UPDATE exp_due_si_adoc SET quantity = Nvl(quantity,0) + Nvl(vn_quantidade,0)
                                  , vlrwithexcoveramount = Nvl(vlrwithexcoveramount,0) + Nvl(ato.valor,0)
                              WHERE due_si_adoc_id = pn_due_si_adoc_id;

        /* Verifica se o está preenchido o rd_id.
            Se não estiver preenchido, verifica se possui nota fiscal nacional para o ATO */
        IF(vr_ato_rd.rd_id IS NULL) THEN
          --Ato NF entrada nacional
          FOR ato_nac IN cur_ato_nf_nac(pn_fatura_item_detalhe_id) LOOP

            vb_achou := FALSE;
            OPEN  cur_adoc_inv(ato_nac.numero_nf, ato_nac.data_nf);
            FETCH cur_adoc_inv INTO vn_adoc_inv_id;
            vb_achou := cur_adoc_inv%FOUND;
            CLOSE cur_adoc_inv;

            IF(vb_achou) THEN
              UPDATE exp_due_si_adoc_inv SET customsvalueamount = Nvl(customsvalueamount,0) + Nvl(ato_nac.valor,0)
                                           , quantityquantity   = Nvl(quantityquantity,0) + Nvl(ato_nac.qtde,0)
                                       WHERE due_si_adoc_inv_id = vn_adoc_inv_id;
            ELSE
              INSERT INTO exp_due_si_adoc_inv ( due_si_adoc_inv_id
                                              , due_si_adoc_id
                                              , identification
                                              , issuedatetime
                                              , typecode
                                              , customsvalueamount
                                              , quantityquantity
                                              , creation_date
                                              , created_by
                                              , last_update_date
                                              , last_updated_by
                                              )
                                      VALUES ( cmx_fnc_proxima_sequencia('exp_due_si_adoc_inv_sq1')
                                              , pn_due_si_adoc_id
                                              , ato_nac.numero_nf
                                              , ato_nac.data_nf
                                              , '388'
                                              , ato_nac.valor
                                              , ato_nac.qtde
                                              , SYSDATE
                                              , 0
                                              , SYSDATE
                                              , 0
                                              );
            END IF;
          END LOOP;
        END IF;
      END LOOP;

    END IF;

  END p_prc_inserir_ato;

  PROCEDURE p_prc_inserir_ato_isencao( pn_due_ship_item_id        NUMBER
                                     , pn_fatura_det_nf_id        NUMBER
                                     , pn_usuario_id              NUMBER
                                     ) IS

    CURSOR cur_atos
        IS
    SELECT dxield.quantidade
         , dxield.categorycode
         , dxield.identification
         , dxield.drawbackrecipientid
         , dxield.drawbackhsclassification
         , dxield.valuewithexchangecoveramount
         , dxield.quantityquantity
         , dxield.itemid
      FROM drw_xml_isencao_export_lin_due dxield
         , drw_xml_isencao_exportacao_due dxied
         , exp_fatura_item_det_nf         efidn
     WHERE dxield.xml_exp_id           = dxied.xml_exp_id
       AND dxield.due_fatura_det_nf_id = efidn.fatura_det_nf_id
       AND efidn.fatura_det_nf_id      = pn_fatura_det_nf_id
       AND dxied.status                = 'A';

    CURSOR cur_verifica(pc_identification VARCHAR2)
        IS
    SELECT due_si_adoc_id
      FROM exp_due_si_adoc
     WHERE due_ship_item_id = pn_due_ship_item_id
       AND identification   = pc_identification;

    vb_achou          BOOLEAN := FALSE;
    vn_due_si_adoc_id NUMBER;
  BEGIN

    FOR ato IN cur_atos LOOP

      vb_achou := FALSE;
      OPEN  cur_verifica(ato.identification);
      FETCH cur_verifica INTO vn_due_si_adoc_id;
      vb_achou := cur_verifica%FOUND;
      CLOSE cur_verifica;

      IF(vb_achou) THEN
        UPDATE exp_due_si_adoc SET itemid                     = ato.itemid
                                 , quantity                   = Nvl(quantity,0) + Nvl(ato.quantityquantity,0)
                                 , vlrwithexcoveramount       = Nvl(vlrwithexcoveramount,0) + Nvl(ato.valuewithexchangecoveramount,0)
                                 , vlrwithoutexcoveramount    = 0
                                 , last_update_date           = SYSDATE
                                 , last_updated_by            = pn_usuario_id
                             WHERE due_si_adoc_id = vn_due_si_adoc_id;
      ELSE
        INSERT INTO exp_due_si_adoc
            (
              due_si_adoc_id
            , due_ship_item_id
            , identification
            , category
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            , itemid
            , quantity
            , vlrwithexcoveramount
            , vlrwithoutexcoveramount
            , drawbackhsclassification
            , drawbackrecipientid
            ) VALUES (
                        cmx_fnc_proxima_sequencia('exp_due_si_adoc_sq1')
                      , pn_due_ship_item_id
                      , ato.identification
                      , 'DBI'
                      , SYSDATE
                      , pn_usuario_id
                      , SYSDATE
                      , pn_usuario_id
                      , ato.itemid
                      , ato.quantityquantity
                      , ato.valuewithexchangecoveramount
                      , 0
                      , ato.drawbackhsclassification
                      , ato.drawbackrecipientid
                      );
      END IF;
    END LOOP;

  END p_prc_inserir_ato_isencao;

  FUNCTION exp_fnc_ret_estado(pn_fatura_id NUMBER) RETURN VARCHAR2 IS

    CURSOR cur_faturas
        IS
    SELECT cmx_pkg_tabelas.codigo(b.uf_id)
      FROM exp_faturas  a
         , cmx_empresas b
     WHERE b.empresa_id = a.empresa_id
       AND a.fatura_id = pn_fatura_id;

   vc_estado  VARCHAR2(02) := NULL;
  BEGIN

    OPEN  cur_faturas;
    FETCH cur_faturas INTO vc_estado;
    CLOSE cur_faturas;

    RETURN vc_estado;

  END exp_fnc_ret_estado;

  FUNCTION exp_fnc_ret_nome_cliente(pn_fatura_id NUMBER) RETURN VARCHAR2 IS

    CURSOR cur_faturas
        IS
    SELECT b.nome
      FROM exp_faturas a
         , exp_fatura_entidades b
     WHERE b.fatura_id         = a.fatura_id
       AND b.entidade_tipo_id  = cmx_pkg_tabelas.tabela_id('918', 'C')
       AND a.fatura_id         = pn_fatura_id;

    vc_nome VARCHAR2(200) := NULL;
  BEGIN

    OPEN  cur_faturas;
    FETCH cur_faturas INTO vc_nome;
    CLOSE cur_faturas;

    RETURN vc_nome;
  END exp_fnc_ret_nome_cliente;

  FUNCTION exp_fnc_ret_pais_cliente(pn_fatura_id NUMBER) RETURN VARCHAR2 IS


     CURSOR cur_faturas
        IS
    SELECT b.fatura_entidade_id
         , b.entidade_id
         , b.site_id
         , b.origem
      FROM exp_faturas a
         , exp_fatura_entidades b
     WHERE a.fatura_id         = b.fatura_id
       AND b.entidade_tipo_id  = cmx_pkg_tabelas.tabela_id('918', 'C')
       AND a.fatura_id         = pn_fatura_id;

    CURSOR cur_cliente(pn_site_id NUMBER)
        IS
    SELECT cmx_pkg_tabelas.auxiliar(c.pais_id,1)
      FROM exp_cliente_sites    c
     WHERE c.cliente_site_id   = pn_site_id;

    CURSOR cur_entidade(pn_site_id NUMBER)
        IS
    SELECT cmx_pkg_tabelas.auxiliar(e.pais_id,1)
      FROM exp_entidade_sites  e
     WHERE e.entidade_site_id   = pn_site_id;

    vr_faturas  cur_faturas%ROWTYPE;
    vc_pais     VARCHAR2(02) := NULL;
    vb_found    BOOLEAN := FALSE;
  BEGIN

    OPEN  cur_faturas;
    FETCH cur_faturas INTO vr_faturas;
    vb_found := cur_faturas%FOUND;
    CLOSE cur_faturas;

    -- Origem = 1 - Cliente; 2 - Entidade

    IF(Nvl(vr_faturas.origem, '2') = '2') THEN

      OPEN  cur_entidade(vr_faturas.site_id);
      FETCH cur_entidade INTO vc_pais;
      CLOSE cur_entidade;

    ELSE

      OPEN  cur_cliente(vr_faturas.site_id);
      FETCH cur_cliente INTO vc_pais;
      CLOSE cur_cliente;

    END IF;

    RETURN vc_pais;
  END exp_fnc_ret_pais_cliente;

  FUNCTION exp_fnc_ret_endereco_cliente(pn_fatura_id NUMBER) RETURN VARCHAR2 IS

    CURSOR cur_faturas
        IS
    SELECT b.endereco1
      FROM exp_faturas a
         , exp_fatura_entidades b
     WHERE b.fatura_id         = a.fatura_id
       AND b.entidade_tipo_id  = cmx_pkg_tabelas.tabela_id('918', 'C')
       AND a.fatura_id         = pn_fatura_id;

    vc_endereco VARCHAR2(200) := NULL;
  BEGIN

    OPEN  cur_faturas;
    FETCH cur_faturas INTO vc_endereco;
    CLOSE cur_faturas;

    RETURN vc_endereco;
  END exp_fnc_ret_endereco_cliente;

  FUNCTION exp_fnc_ret_pais_destino(pn_fatura_id NUMBER) RETURN VARCHAR2 IS
    vn_pais_id  NUMBER       := NULL ;
    vc_pais     VARCHAR2(02) := NULL ;
  BEGIN

    vn_pais_id := exp_pkg_informacoes.fnc_complemento_id( cmx_pkg_tabelas.tabela_id ('201','PAIS_DESTINO_FINAL')
                                                        , NULL
                                                        , pn_fatura_id
                                                        , NULL
                                                        , NULL
                                                        );

    vc_pais := cmx_pkg_tabelas.auxiliar(vn_pais_id ,1);

    RETURN vc_pais;
  END exp_fnc_ret_pais_destino;

  FUNCTION fnc_incluir_faturas( pn_due_tmp_id NUMBER
                              , pn_due_id     NUMBER
                              , pn_evento_id  NUMBER
                              , pn_usuario_id NUMBER
                              ) RETURN NUMBER
  IS

    CURSOR cur_dados
        IS
    SELECT fatura_id
         , embarque_id
         , fatura_numero
         , fatura_ano
         , empresa_id
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         --, declarant_identification
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         --, importer_name
         , importer_addr_country
         --, importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type
         --, ucr
         , motivo_dispensa_nf
      FROM (SELECT ef.fatura_id
                 , ef.embarque_id
                 , ef.fatura_numero
                 , ef.fatura_ano
                 , edft.empresa_id
                 , exp_pkg_due.fnc_ind_due('EX0010' ,'F', ef.fatura_id )         doffice_identification
                 , NVL( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                      , exp_pkg_due.fnc_ind_due('EX0037_CNPJ' ,'F', ef.fatura_id ))         whs_identification
                 , Decode( exp_pkg_due.fnc_ind_due('EX0037' ,'F', ef.fatura_id )
                         , NULL
                         , '22'
                         , '281'
                         )                                                       whs_type
                 , exp_pkg_due.fnc_ind_due('EX0063' ,'F', ef.fatura_id )         whs_latitude
                 , exp_pkg_due.fnc_ind_due('EX0064' ,'F', ef.fatura_id )         whs_longitude
                 , exp_pkg_due.fnc_ind_due('EX0062' ,'F', ef.fatura_id )         whs_addr_line
                 , exp_pkg_due.fnc_ind_due('EX0039' ,'F', ef.fatura_id )         currencytype
                 --, exp_pkg_due.fnc_ind_due('EX0003' ,'F', ef.fatura_id )         declarant_identification
                 , exp_pkg_due.fnc_ind_due('EX0011' ,'F', ef.fatura_id )         exitoffice_identification
                 , exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )         exitoffice_whs_identification
                 , Decode( exp_pkg_due.fnc_ind_due('EX0012' ,'F', ef.fatura_id )
                         , NULL
                         , '22'
                         , '281'
                         )                                                       exitoffice_whs_type
                 --, exp_pkg_due.fnc_ind_due('EX0008' ,'F', ef.fatura_id )         importer_name
                 , exp_pkg_due.fnc_ind_due('EX0009' ,'F', ef.fatura_id )         importer_addr_country
                 --, exp_pkg_due.fnc_ind_due('EX0036' ,'F', ef.fatura_id )         importer_addr_line
                 , exp_pkg_due.fnc_ind_due('EX0040_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao
                 , exp_pkg_due.fnc_ind_due('EX0041_FRM_EXP' ,'F', ef.fatura_id ) forma_exportacao_type
                 , exp_pkg_due.fnc_ind_due('EX0040_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial
                 , exp_pkg_due.fnc_ind_due('EX0041_SIT_ESP' ,'F', ef.fatura_id ) situacao_especial_type
                 , exp_pkg_due.fnc_ind_due('EX0040_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte
                 , exp_pkg_due.fnc_ind_due('EX0041_ESP_TRS' ,'F', ef.fatura_id ) caso_esp_transporte_type
                 , exp_pkg_due.fnc_ind_due('EX0042_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais
                 , exp_pkg_due.fnc_ind_due('EX0041_OBS_GER' ,'F', ef.fatura_id ) observacoes_gerais_type
                 --, exp_pkg_due.fnc_ind_due('EX0002' ,'F', ef.fatura_id )         ucr
                 , exp_pkg_due.fnc_ind_due('EX0067' ,'F', ef.fatura_id )         motivo_dispensa_nf
              FROM exp_faturas ef
                 , exp_due_fatura_tmp edft
             WHERE ef.fatura_id = edft.fatura_id
               AND edft.due_tmp_id = pn_due_tmp_id
           )
  ORDER BY fatura_ano
         , fatura_numero
         , doffice_identification
         , whs_identification
         , whs_type
         , whs_latitude
         , whs_longitude
         , whs_addr_line
         , currencytype
         --, declarant_identification
         , exitoffice_identification
         , exitoffice_whs_identification
         , exitoffice_whs_type
         --, importer_name
         , importer_addr_country
         --, importer_addr_line
         , forma_exportacao
         , forma_exportacao_type
         , situacao_especial
         , situacao_especial_type
         , caso_esp_transporte
         , caso_esp_transporte_type
         , observacoes_gerais
         , observacoes_gerais_type
         , motivo_dispensa_nf
         ;

    CURSOR cur_ruc
        IS
    SELECT ucr
      FROM exp_due
     WHERE due_id = pn_due_id;

    CURSOR cur_vinc_fat
       IS
   SELECT cmx_fnc_string_agg(fat.fatura_numero||'/'||fat.fatura_ano)
     FROM exp_due_faturas      dfat
        , exp_due              due
        , exp_due_fatura_tmp   tmp
        , exp_due_ship         ship
        , exp_faturas          fat
    WHERE dfat.due_id = due.due_id
      AND dfat.fatura_id = tmp.fatura_id
      AND dfat.fatura_id = ship.fatura_id
      AND ship.due_id   = due.due_id
      AND dfat.fatura_id = fat.fatura_id
      AND due.dt_cancel IS NULL
      AND ship.fatura_nf_id IS NULL
      AND tmp.due_tmp_id = pn_due_tmp_id
      AND due.due_id <> pn_due_id
      GROUP BY fat.fatura_numero, fat.fatura_ano;

    vr_fat_ant cur_dados%ROWTYPE;
    vb_erro              BOOLEAN;
    vn_criacao           NUMBER;
    vc_ucr               VARCHAR2(35) := NULL;
    vc_decl_identif      VARCHAR2(17);
    vc_faturas           VARCHAR2(4000) := NULL;
  BEGIN

    -- verifica se alguma fatura tem informação divergente das demais.
    vr_fat_ant := NULL;
    vb_erro    := FALSE;

    -- verifica se alguma fatura já possui DUE gerada do tipo embarque antecipado.
    OPEN  cur_vinc_fat;
    FETCH cur_vinc_fat INTO vc_faturas;
    CLOSE cur_vinc_fat;

    IF(vc_faturas IS NOT NULL) THEN
      cmx_prc_gera_log_erros(pn_evento_id, 'Não é possível gerar a DUE, pois a(s) fatura(s) ['||vc_faturas||'] já está(ão) vinculada(s) a uma DUE.','E');
      vb_erro := TRUE;
    END IF;

    FOR x IN cur_dados
    LOOP
      --IF x.doffice_identification IS NULL THEN
      --  cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ sem local de despacho preenchido.', 'EXP_PKG_DUE','FNC_GERAR_DUE_025',null,x.fatura_numero || '/' || x.fatura_ano),'E');
      --  vb_erro := TRUE;
      --END IF;

      IF vr_fat_ant.fatura_id IS NOT NULL THEN
        IF Nvl(x.doffice_identification       ,'-!-!-!')  <> Nvl(vr_fat_ant.doffice_identification       ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_026',null,x.fatura_numero || '/' || x.fatura_ano, 'doffice_identification'       , x.doffice_identification       ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_identification           ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_identification           ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_027',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_identification'           , x.whs_identification           ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_type                     ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_type                     ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_028',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_type'                     , x.whs_type                     ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_latitude                 ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_latitude                 ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_029',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_latitude'                 , x.whs_latitude                 ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_longitude                ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_longitude                ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_030',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_longitude'                , x.whs_longitude                ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.whs_addr_line                ,'-!-!-!')  <> Nvl(vr_fat_ant.whs_addr_line                ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_031',null,x.fatura_numero || '/' || x.fatura_ano, 'whs_addr_line'                , x.whs_addr_line                ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.currencytype                 ,'-!-!-!')  <> Nvl(vr_fat_ant.currencytype                 ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_032',null,x.fatura_numero || '/' || x.fatura_ano, 'currencytype'                 , x.currencytype                 ),'E');
          vb_erro := TRUE;
        END IF;

        --IF Nvl(x.declarant_identification     ,'-!-!-!')  <> Nvl(vr_fat_ant.declarant_identification     ,'-!-!-!') THEN
        -- cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_033',null,x.fatura_numero || '/' || x.fatura_ano, 'declarant_identification'     , x.declarant_identification     ),'E');
        --  vb_erro := TRUE;
        --END IF;

        IF Nvl(x.exitoffice_identification    ,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_identification    ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_034',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_identification'    , x.exitoffice_identification    ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.exitoffice_whs_identification,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_whs_identification,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_035',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_whs_identification', x.exitoffice_whs_identification),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.exitoffice_whs_type          ,'-!-!-!')  <> Nvl(vr_fat_ant.exitoffice_whs_type          ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_036',null,x.fatura_numero || '/' || x.fatura_ano, 'exitoffice_whs_type'          , x.exitoffice_whs_type          ),'E');
          vb_erro := TRUE;
        END IF;

--        IF Nvl(x.importer_name                ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_name                ,'-!-!-!') THEN
--          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_037',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_name'                , x.importer_name                ),'E');
--          vb_erro := TRUE;
--        END IF;

        IF Nvl(x.importer_addr_country        ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_addr_country        ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_038',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_addr_country'        , x.importer_addr_country        ),'E');
          vb_erro := TRUE;
        END IF;

--        IF Nvl(x.importer_addr_line           ,'-!-!-!')  <> Nvl(vr_fat_ant.importer_addr_line           ,'-!-!-!') THEN
--          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_039',null,x.fatura_numero || '/' || x.fatura_ano, 'importer_addr_line'           , x.importer_addr_line           ),'E');
--          vb_erro := TRUE;
--        END IF;

        IF Nvl(x.forma_exportacao             ,'-!-!-!')  <> Nvl(vr_fat_ant.forma_exportacao             ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_040',null,x.fatura_numero || '/' || x.fatura_ano, 'forma_exportacao'             , x.forma_exportacao             ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.forma_exportacao_type        ,'-!-!-!')  <> Nvl(vr_fat_ant.forma_exportacao_type        ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_041',null,x.fatura_numero || '/' || x.fatura_ano, 'forma_exportacao_type'        , x.forma_exportacao_type        ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.situacao_especial            ,'-!-!-!')  <> Nvl(vr_fat_ant.situacao_especial            ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_042',null,x.fatura_numero || '/' || x.fatura_ano, 'situacao_especial'            , x.situacao_especial            ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.situacao_especial_type       ,'-!-!-!')  <> Nvl(vr_fat_ant.situacao_especial_type       ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_043',null,x.fatura_numero || '/' || x.fatura_ano, 'situacao_especial_type'       , x.situacao_especial_type       ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.caso_esp_transporte          ,'-!-!-!')  <> Nvl(vr_fat_ant.caso_esp_transporte          ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_044',null,x.fatura_numero || '/' || x.fatura_ano, 'caso_esp_transporte'          , x.caso_esp_transporte          ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.caso_esp_transporte_type     ,'-!-!-!')  <> Nvl(vr_fat_ant.caso_esp_transporte_type     ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_045',null,x.fatura_numero || '/' || x.fatura_ano, 'caso_esp_transporte_type'     , x.caso_esp_transporte_type     ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.observacoes_gerais           ,'-!-!-!')  <> Nvl(vr_fat_ant.observacoes_gerais           ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_046',null,x.fatura_numero || '/' || x.fatura_ano, 'observacoes_gerais'           , x.observacoes_gerais           ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.observacoes_gerais_type      ,'-!-!-!')  <> Nvl(vr_fat_ant.observacoes_gerais_type      ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_047',null,x.fatura_numero || '/' || x.fatura_ano, 'observacoes_gerais_type'      , x.observacoes_gerais_type      ),'E');
          vb_erro := TRUE;
        END IF;

        IF Nvl(x.motivo_dispensa_nf      ,'-!-!-!')  <> Nvl(vr_fat_ant.motivo_dispensa_nf      ,'-!-!-!') THEN
          cmx_prc_gera_log_erros(pn_evento_id, cmx_fnc_texto_traduzido('Fatura @@01@@ gera quebra no campo @@02@@. Valor atual: @@03@@.', 'EXP_PKG_DUE','FNC_GERAR_DUE_047',null,x.fatura_numero || '/' || x.fatura_ano, 'motivo_dispensa_nf'      , Nvl(x.motivo_dispensa_nf, ' ')      ),'E');
          vb_erro := TRUE;
        END IF;

      END IF;

      vr_fat_ant := x;

    END LOOP;

    IF vb_erro THEN
      RETURN NULL;
    ELSE

      UPDATE exp_due
       SET doffice_identification           = vr_fat_ant.doffice_identification
         , whs_identification               = vr_fat_ant.whs_identification
         , whs_type                         = vr_fat_ant.whs_type
         , whs_latitude                     = vr_fat_ant.whs_latitude
         , whs_longitude                    = vr_fat_ant.whs_longitude
         , whs_addr_line                    = vr_fat_ant.whs_addr_line
         , currencytype                     = vr_fat_ant.currencytype
         --, declarant_identification         = vr_fat_ant.declarant_identification
         , exitoffice_identification        = vr_fat_ant.exitoffice_identification
         , exitoffice_whs_identification    = vr_fat_ant.exitoffice_whs_identification
         , exitoffice_whs_type              = vr_fat_ant.exitoffice_whs_type
--         , importer_name                    = vr_fat_ant.importer_name
         , importer_addr_country            = vr_fat_ant.importer_addr_country
--         , importer_addr_line               = vr_fat_ant.importer_addr_line
         , last_update_date                 = sysdate
         , last_updated_by                  = pn_usuario_id
     WHERE due_id = pn_due_id;

      OPEN  cur_ruc;
      FETCH cur_ruc INTO vc_ucr;
      CLOSE cur_ruc;

      DELETE FROM exp_due_faturas WHERE due_id = pn_due_id;

      INSERT INTO exp_due_faturas
      (
        due_fatura_id
      , due_id
      , fatura_id
      , creation_date
      , created_by
      , last_update_date
      , last_updated_by
      , importer_name
      , importer_addr_country
      , importer_addr_line
      ) SELECT cmx_fnc_proxima_sequencia('exp_due_faturas_sq1')
            , pn_due_id
            , edft.fatura_id
            , SYSDATE
            , pn_usuario_id
            , SYSDATE
            , pn_usuario_id
            , exp_pkg_due.fnc_ind_due('EX0008' ,'F', edft.fatura_id )
            , exp_pkg_due.fnc_ind_due('EX0009' ,'F', edft.fatura_id )
            , exp_pkg_due.fnc_ind_due('EX0036' ,'F', edft.fatura_id )
          FROM exp_due_fatura_tmp edft
        WHERE edft.due_tmp_id    = pn_due_tmp_id;

      prc_atual_compl( pn_due_id
                     , 'DUE_RUC'
                     , vc_ucr
                     , pn_usuario_id
                     );

      vn_criacao  := fnc_criar_due(pn_due_id, pn_evento_id, pn_usuario_id);

      IF vn_criacao IS NULL THEN
        DELETE FROM exp_due_faturas WHERE due_id = pn_due_id;
      END IF;

      COMMIT;
    END IF;

    RETURN pn_due_id;

  END fnc_incluir_faturas;

END;
/

