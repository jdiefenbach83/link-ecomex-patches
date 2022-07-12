PROMPT CREATE OR REPLACE PROCEDURE imp_prc_atualiza_di_li_ivc
CREATE OR REPLACE PROCEDURE imp_prc_atualiza_di_li_ivc(pn_invoice_id     NUMBER
                                                      ,pn_embarque_id    NUMBER
                                                      ,pn_organizacao_id NUMBER
                                                      ,pn_empresa_id     NUMBER
                                                      ,pn_moeda_id       NUMBER)
AS
  CURSOR cur_licenca_gerada IS
    SELECT ill.licenca_id
         , nat_operacao_id
      FROM imp_licencas_lin ill
         , imp_licencas     il
     WHERE ill.invoice_id = pn_invoice_id
       AND il.licenca_id = ill.licenca_id
       AND il.nr_registro IS NOT NULL
       AND ROWNUM = 1;

  CURSOR cur_declaracao_id_nac (pn_licenca_id NUMBER) IS
    SELECT id.declaracao_id
         , id.tp_declaracao_id
         , LTRIM(RTRIM(cmx_pkg_tabelas.codigo (id.tp_declaracao_id))) tp_declaracao
         , id.nac_sem_vinc_admissao
      FROM imp_declaracoes   id
     WHERE id.nr_lote_nacionalizacao IN (SELECT DISTINCT nr_lote_nacionalizacao
                                           FROM imp_licencas_lin
                                          WHERE licenca_id = pn_licenca_id);

  CURSOR cur_declaracao_id IS
    SELECT declaracao_id
         , tp_declaracao_id
         , LTRIM(RTRIM(cmx_pkg_tabelas.codigo (tp_declaracao_id))) tp_declaracao
         , empresa_id
         , da_id
         , nac_sem_vinc_admissao
      FROM imp_declaracoes
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_lock_linha_decl (pn_declaracao_id imp_declaracoes.declaracao_id%TYPE) IS
    SELECT null
      FROM imp_declaracoes_lin
     WHERE declaracao_id = pn_declaracao_id
       FOR UPDATE;

  CURSOR cur_max_linha_decl (pn_declaracao_id imp_declaracoes.declaracao_id%TYPE) IS
    SELECT nvl(max (linha_num), 0)
      FROM imp_declaracoes_lin
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_linhas_licencas IS
    SELECT ill.invoice_id
         , ill.invoice_lin_id
         , ill.licenca_id
         , ill.licenca_lin_id
         , ill.item_id
         , ill.descricao
         , ill.un_medida_id
         , ill.qtde
         , DECODE( iil.preco_unitario_m, null, ill.preco_unitario_m, iil.preco_unitario_m ) preco_unitario_m
         , ill.tp_classificacao
         , ill.class_fiscal_id
         , ill.naladi_sh_id
         , ill.ausencia_fabric
         , ill.fabric_id
         , ill.fabric_site_id
         , ill.fabric_part_number
         , ill.pais_origem_id
         , ill.pesoliq_tot
         , ill.pesoliq_unit
         , ill.regtrib_ii_id
         , ill.utilizacao_id
         , ill.ex_ncm_id
         , ill.ex_nbm_id
         , ill.ex_naladi_id
         , ill.ex_ipi_id
         , ill.ex_prac_id
         , ill.ex_antd_id
         , ill.da_id
         , ill.da_lin_id
         , ill.naladi_ncca_id_bkpdcl
         , ill.vida_util_bkpdcl
         , ill.rd_id
         , ill.fator_conversao_drw
         , ill.qtde_prod_drawback
         , ill.excecao_ii_id
         , ill.lsi
         , utl.cfop_id
         , pn_organizacao_id
         , ill.fundamento_legal_id
         , ill.aliq_ii_red
         , ill.perc_red_ii
         , ill.excecao_ipi_id
         , ill.regtrib_ipi_id
         , ill.ato_legal_id
         , ill.nr_ato_legal
         , ill.orgao_emissor_id
         , ill.ano_ato_legal
         , ill.aliq_ipi_red
         , ill.excecao_icms_id
         , ill.regtrib_icms_id
         , ill.aliq_icms
         , ill.aliq_icms_red
         , ill.perc_red_icms
         , ill.aliq_icms_fecp
         , ill.fundamento_legal_icms_id
         , ill.excecao_pis_cofins_id
         , ill.regtrib_pis_cofins_id
         , ill.aliq_pis
         , ill.aliq_cofins
         , ill.perc_reducao_base_pis_cofins
         , ill.fundamento_legal_pis_cofins_id
         , ill.flag_reducao_base_pis_cofins
         , ill.flegal_reducao_pis_cofins_id
         , ill.aliq_pis_reduzida
         , ill.aliq_cofins_reduzida
         , ill.regime_especial_icms
         , ill.aliq_pis_especifica
         , ill.aliq_cofins_especifica
         , ill.qtde_um_aliq_especifica_pc
         , ill.un_medida_aliq_especifica_pc
         , ill.excecao_antid_id
         , ill.aliq_antid
         , ill.aliq_antid_especifica
         , ill.tipo_unidade_medida_antid
         , ill.somatoria_quantidade
         , ill.um_aliq_especifica_antid_id
         , ill.cert_origem_mercosul_id
         , ill.acordo_aladi_id
         , ill.ato_legal_ncm_id
         , ill.orgao_emissor_ncm_id
         , ill.nr_ato_legal_ncm
         , ill.ano_ato_legal_ncm
         , ill.ato_legal_nbm_id
         , ill.orgao_emissor_nbm_id
         , ill.nr_ato_legal_nbm
         , ill.ano_ato_legal_nbm
         , ill.ato_legal_naladi_id
         , ill.orgao_emissor_naladi_id
         , ill.nr_ato_legal_naladi
         , ill.ano_ato_legal_naladi
         , ill.ato_legal_acordo_id
         , ill.orgao_emissor_acordo_id
         , ill.nr_ato_legal_acordo
         , ill.ano_ato_legal_acordo
         , ill.aliq_mva
         , ill.pro_emprego
         , ill.pro_empr_aliq_base
         , ill.pro_empr_aliq_antecip
         , ill.beneficio_pr
         , ill.pr_aliq_base
         , ill.pr_perc_diferido
         , ill.pr_perc_vr_devido
         , ill.pr_perc_minimo_base
         , ill.pr_perc_minimo_suspenso
         , ill.beneficio_sp
         , (SELECT ief.ins_estadual_id
              FROM imp_excecoes_fiscais ief
                 , cmx_ins_estaduais    cie
             WHERE cie.ins_estadual_id = ief.ins_estadual_id
               AND cie.empresa_id      = pn_empresa_id
               AND ief.excecao_id      = ill.excecao_icms_id)    ins_estadual_id
         , ill.enquadramento_legal_ipi_id
		     , aliq_cofins_recuperar
         , ill.beneficio_suspensao
         , ill.perc_beneficio_suspensao
      FROM imp_licencas_lin ill
         , imp_invoices_lin iil
         , cmx_utilizacoes  utl
     WHERE ill.invoice_id        = pn_invoice_id
       AND ill.invoice_lin_id    = iil.invoice_lin_id (+)
       AND utl.utilizacao_id (+) = ill.utilizacao_id;

  CURSOR cur_rd (pn_rd_id drw_registro_drawback.rd_id%TYPE) IS
    SELECT cfop_nf_importacao_id
         , fundamento_legal_pis_cofins_id
      FROM drw_registro_drawback
     WHERE rd_id = pn_rd_id;
     
  CURSOR cur_exfiscal_ii(pn_excecao_ii_id NUMBER) IS
    SELECT aliq_adval_igual_red                                                                                                  
      FROM imp_excecoes_fiscais
     WHERE excecao_id = pn_excecao_ii_id;


  CURSOR cur_exfiscal_antd(pn_excecao_antd_id NUMBER) IS
    SELECT ex.ato_legal_id
         , ex.nr_ato_legal
         , ex.orgao_emissor_id
         , ex.ano_ato_legal
      FROM imp_excecoes_fiscais ex
     WHERE ex.excecao_id = pn_excecao_antd_id;

  vc_aliq_adval_igual_red imp_excecoes_fiscais.aliq_adval_igual_red%TYPE;
  vr_exfiscal_antd        cur_exfiscal_antd%ROWTYPE;
     

  vc_tp_declaracao              cmx_tabelas.codigo%TYPE;
  vn_cfop_nf_importacao_id      cmx_tabelas.tabela_id%TYPE;
  vn_declaracao_lin_id          NUMBER := 0;
  vn_linha_num                  NUMBER := 0;
  vn_declaracao_id              NUMBER;
  vn_tp_declaracao_id           NUMBER;
  vn_adi_id                     NUMBER := 0;
  vn_fund_legal_icms_id         NUMBER := null;
  vn_fund_legal_pis_cofins_id   NUMBER := null;
  vc_step_error                 VARCHAR2(1000);
  vn_nat_operacao_id            NUMBER;

  vn_empresa_id                 NUMBER;
  vn_da_id                      NUMBER;
  vn_evento_id                  NUMBER := NULL;
  vb_erro_nacionalizacao        BOOLEAN:= FALSE;
  vb_li_gerada                  BOOLEAN:= FALSE;

  vn_licenca_id                 NUMBER;
  vb_achou                      BOOLEAN := FALSE;

  vc_nac_sem_vinc_admissao      VARCHAR2(1) := 'N';
BEGIN
  /* Primeiro verifico se existem licenças registradas para a invoice vinculada */
  OPEN cur_licenca_gerada;
  FETCH cur_licenca_gerada INTO vn_licenca_id
                              , vn_nat_operacao_id;
    vb_achou := cur_licenca_gerada%FOUND;
  CLOSE cur_licenca_gerada;

  IF vb_achou THEN
    /* Devo saber qual o ID da declaracao que ira receber as linhas de LI, para tanto,
      acesso a declaracao_id atraves do numero do embarque desta invoice. */
    vc_step_error := 'cur_declaracao_id';
    IF (pn_embarque_id IS NOT null) THEN
      OPEN  cur_declaracao_id;
      FETCH cur_declaracao_id INTO vn_declaracao_id
                                , vn_tp_declaracao_id
                                , vc_tp_declaracao
                                , vn_empresa_id
                                , vn_da_id
                                , vc_nac_sem_vinc_admissao;
      CLOSE cur_declaracao_id;
    ELSE
      OPEN  cur_declaracao_id_nac(vn_licenca_id);
      FETCH cur_declaracao_id_nac INTO vn_declaracao_id
                                    , vn_tp_declaracao_id
                                    , vc_tp_declaracao
                                    , vc_nac_sem_vinc_admissao;
      CLOSE cur_declaracao_id_nac;

    END IF;

    vc_step_error := null;

    /* So posso criar as linhas da declaracao, se o usuario ja criou o cabecalho da declaracao.
      Se a declaracao ainda nao foi criada, nao preciso me preocupar em inserir as linhas aqui,
      pois, quando a declaracao for criada, as licencas serao lidas e inseridas. */
    IF (vn_declaracao_id is not null) THEN
      /* Para os inserts abaixo, devo buscar na cmx_tabelas os IDs de regime de tributacao de
        IPI e ICMS para os codigo 4 (Integral IPI) e 1 (Integral ICMS), para grava-los como
        default na imp_declaracoes_lin, no entanto, podemos estar inserindo um registro de
        declaracao que ja foi anteriormente backupeado na linha da LI, portanto devemos
        nos atentar para nestes casos, gravar nos IDs de regime de tributacao o valor
        backupeado. */

      /* Devo dar um lock nas linhas da declaracao, para que eu possa pegar o proximo numero de
        linha e fazer os inserts abaixo. O lock so é liberado quando a ultima linha for
        incluida e o controle voltar ao form. */
      vc_step_error := 'cur_lock_linha_decl';
      OPEN  cur_lock_linha_decl (vn_declaracao_id);
      CLOSE cur_lock_linha_decl;
      vc_step_error := null;

      vc_step_error := 'cur_max_linha_decl';
      OPEN  cur_max_linha_decl (vn_declaracao_id);
      FETCH cur_max_linha_decl INTO vn_linha_num;
      CLOSE cur_max_linha_decl;
      vc_step_error := null;

      /* Insere todas as linhas da Licenca em evidencia como Declaracao */
      FOR cll IN cur_linhas_licencas LOOP
        vn_fund_legal_icms_id       := null;
        vn_fund_legal_pis_cofins_id := null;
        vn_linha_num                := vn_linha_num + 1;

        IF (cll.rd_id IS NOT null) THEN
          vn_fund_legal_icms_id  := null;

          OPEN  cur_rd (cll.rd_id);
          FETCH cur_rd INTO vn_cfop_nf_importacao_id, vn_fund_legal_pis_cofins_id;
          CLOSE cur_rd;
        ELSE
          vn_fund_legal_icms_id       := cll.fundamento_legal_icms_id;
          vn_fund_legal_pis_cofins_id := cll.fundamento_legal_pis_cofins_id;
        END IF;

        /* Se estivermos tratando uma LSI, iremos inserir linhas numa DSI, portanto,
          devemos criar a Adicao tambem, pois a trigger que quebra adicao na declaracao
          so é disparada para DI e NAO para DSI */
        vn_adi_id := Null;
        IF (vn_nat_operacao_id IS NOT null) THEN
          /* A origem destes parametros sao as linhas da invoice, portanto, alguns campos podem
            nao existir, por isso sao passados como NULL e poderao ser alterados na adicao da
            DSI, que sera gerada */
            
          OPEN cur_exfiscal_ii(cll.excecao_ii_id);
          FETCH cur_exfiscal_ii INTO vc_aliq_adval_igual_red;
          CLOSE cur_exfiscal_ii;

          vr_exfiscal_antd := NULL;
          IF cll.excecao_antid_id IS NOT NULL THEN
            OPEN cur_exfiscal_antd(cll.excecao_antid_id);
            FETCH cur_exfiscal_antd INTO vr_exfiscal_antd;
            CLOSE cur_exfiscal_antd;
          END IF;
            
          vc_step_error := 'imp_fnc_gera_adicao_dcl';
          vn_adi_id := imp_fnc_gera_adicao_dcl (
                          vn_declaracao_id
                        , vn_tp_declaracao_id
                        , null                        /* pn_declaracao_adi_id */
                        , cll.tp_classificacao
                        , cll.class_fiscal_id
                        , cll.invoice_lin_id
                        , cll.regtrib_ii_id
                        , cll.regtrib_ipi_id
                        , null                        /* pn_aliq_ipi_red */
                        , cll.perc_red_ii             /* pn_perc_red_ii */
                        , cll.aliq_ii_red             /* pn_aliq_ii_red */
                        , cll.rd_id
                        , cll.licenca_id
                        , cll.ausencia_fabric
                        , null                        /* pn_fabric_id */
                        , null                        /* pn_fabric_site_id */
                        , cll.pais_origem_id
                        , cll.item_id
                        , cll.naladi_sh_id
                        , null                        /* pn_naladi_ncca_id */
                        , cll.ex_ncm_id
                        , cll.ex_nbm_id
                        , cll.ex_naladi_id
                        , cll.ex_ipi_id
                        , cll.ex_prac_id
                        , cll.ex_antd_id
                        , cll.da_lin_id
                        , cll.vida_util_bkpdcl
                        , 'S'
                        , sysdate
                        , 0
                        , sysdate
                        , 0
                        , cll.fundamento_legal_id     /* pn_fundamento_legal_id */
                        , null
                        , null
                        , null
                        , null
                        , cll.regtrib_icms_id                /* pn_regtrib_icms_id             */
                        , cll.aliq_icms                      /* pn_aliq_icms                   */
                        , cll.aliq_icms_red                  /* pn_aliq_icms_red               */
                        , cll.perc_red_icms                  /* pn_perc_red_icms               */
                        , cll.aliq_icms_fecp                 /* pn_aliq_icms_fecp              */
                        , vn_fund_legal_icms_id              /* pn_fund_legal_icms_id          */
                        , cll.regtrib_pis_cofins_id          /* pn_regtrib_pis_cofins_id       */
                        , cll.aliq_pis                       /* pn_aliq_pis                    */
                        , cll.aliq_cofins                    /* pn_aliq_cofins                 */
                        , cll.perc_reducao_base_pis_cofins   /* pn_perc_red_base_pis_cofins    */
                        , vn_fund_legal_pis_cofins_id        /* pn_fund_legal_pis_cofins_id    */
                        , cll.flag_reducao_base_pis_cofins   /* pn_flag_red_base_pis_cofins    */
                        , cll.flegal_reducao_pis_cofins_id   /* pn_flegal_red_pis_cofins_id    */
                        , cll.aliq_pis_reduzida              /* pn_aliq_pis_reduzida           */
                        , cll.aliq_cofins_reduzida           /* pn_aliq_cofins_reduzida        */
                        , cll.regime_especial_icms           /* pc_regime_especial_icms        */
                        , cll.aliq_pis_especifica            /* pn_aliq_pis_especifica         */
                        , cll.aliq_cofins_especifica         /* pn_aliq_cofins_especifica      */
                        , cll.qtde_um_aliq_especifica_pc     /* pn_qtde_um_aliq_especifica_pc  */
                        , cll.un_medida_aliq_especifica_pc   /* pc_um_aliq_especifica_pc       */
                        , null                               /* pn_acordo_aladi_id             */
                        , null                               /* pn_cert_origem_mercosul_id     */
                        , null                               /* pn_aliq_antid_ad_valorem       */
                        , null                               /* pn_aliq_antid_especifica       */
                        , null                               /* pn_um_aliq_especifica_antid_id */
                        , null                               /* pc_somatoria_quantidade        */
                        , null                               /* pn_ato_legal_ii_id             */
                        , null                               /* pn_orgao_emissor_ii_id         */
                        , null                               /* pn_nr_ato_legal_ii             */
                        , null                               /* pn_ano_ato_legal_ii            */
                        , null                               /* pn_ato_legal_ii_id             */
                        , null                               /* pn_orgao_emissor_ii_id         */
                        , null                               /* pn_nr_ato_legal_ii             */
                        , null                               /* pn_ano_ato_legal_ii            */
                        , null                               /* pn_ato_legal_ii_id             */
                        , null                               /* pn_orgao_emissor_ii_id         */
                        , null                               /* pn_nr_ato_legal_ii             */
                        , null                               /* pn_ano_ato_legal_ii            */
                        , null                               /* pn_ato_legal_ii_id             */
                        , null                               /* pn_orgao_emissor_ii_id         */
                        , null                               /* pn_nr_ato_legal_ii             */
                        , null                               /* pn_ano_ato_legal_ii            */
                        , cll.aliq_mva                       /* pn_aliquota_mva                */
                        , cll.pro_emprego                    /* pc_pro_emprego                 */
                        , cll.pro_empr_aliq_base             /* pn_aliq_base_pro_emprego       */
                        , cll.pro_empr_aliq_antecip          /* pn_aliq_antecip_pro_emprego    */
                        , cll.beneficio_pr                   /* pc_beneficio_pr                */
                        , cll.pr_aliq_base                   /* pn_aliq_base_pr                */
                        , cll.pr_perc_diferido               /* pn_perc_diferido_pr            */
                        , cll.ins_estadual_id                /* pn_ins_estadual_id             */
                        , cll.pr_perc_vr_devido              /* pn_pr_perc_vr_devido           */
                        , cll.pr_perc_minimo_base            /* pn_pr_perc_minimo_base         */
                        , cll.pr_perc_minimo_suspenso        /* pn_pr_perc_minimo_suspenso     */
                        , cll.beneficio_sp                   /* pc_beneficio_sp                */
                        , cll.beneficio_suspensao            /* pc_beneficio_suspensao         */
                        , cll.perc_beneficio_suspensao       /* pn_perc_beneficio_suspensao    */
                        , vc_aliq_adval_igual_red            /* pc_aliq_adval_igual_red       */
                        , vr_exfiscal_antd.ato_legal_id      /* pn_ato_legal_antd_id          */
                        , vr_exfiscal_antd.orgao_emissor_id  /* pn_orgao_emissor_antd_id      */
                        , vr_exfiscal_antd.nr_ato_legal      /* pn_nr_ato_legal_antd          */
                        , vr_exfiscal_antd.ano_ato_legal     /* pn_ano_ato_legal_antd         */
                        );
          vc_step_error := null;
        END IF; /* (vn_nat_operacao_id is not null) */

        vc_step_error := 'Insert into imp_declaracoes_lin';
        vn_declaracao_lin_id := cmx_fnc_proxima_sequencia('imp_declaracoes_lin_sq1');

        IF (vc_tp_declaracao IN ('14','15') AND Nvl(vc_nac_sem_vinc_admissao,'N') = 'N') THEN
          imp_pkg_nacionalizacao.gerar( vn_declaracao_id
                                      , vc_tp_declaracao
                                      , vn_empresa_id
                                      , pn_embarque_id
                                      , cll.invoice_id
                                      , cll.invoice_lin_id
                                      , cll.item_id
                                      , cll.descricao
                                      , cll.un_medida_id
                                      , cll.qtde
                                      , cll.preco_unitario_m
                                      , cll.class_fiscal_id
                                      , cll.utilizacao_id
                                      , Nvl(vn_cfop_nf_importacao_id, cll.cfop_id)
                                      , cll.pesoliq_tot
                                      , cll.pesoliq_unit
                                      , cll.regtrib_ii_id
                                      , cll.regtrib_ipi_id  -- vn_id_regtrib_ipi
                                      , cll.regtrib_icms_id -- vn_id_regtrib_icms
                                      , cll.ex_ncm_id
                                      , cll.ex_nbm_id
                                      , cll.ex_naladi_id
                                      , cll.ex_prac_id
                                      , cll.ex_antd_id
                                      , cll.ex_ipi_id
                                      , cll.aliq_ii_red           /* vn_aliq_ii_red */
                                      , cll.perc_red_ii           /* vn_perc_red_ii */
                                      , cll.aliq_ipi_red
                                      , cll.aliq_icms_red                -- vn_aliq_icms_red
                                      , cll.perc_red_icms                -- vn_perc_red_icms
                                      , cll.aliq_icms                    -- vn_aliq_icms
                                      , 0
                                      , cll.excecao_icms_id              -- vn_excecao_icms_id
                                      , cll.excecao_ipi_id               -- vn_excecao_ipi_id
                                      , cll.excecao_ii_id
                                      , cll.aliq_pis                     -- vn_aliq_pis
                                      , cll.aliq_cofins                  -- vn_aliq_cofins
                                      , cll.perc_reducao_base_pis_cofins -- vn_perc_red_pis_cofins
                                      , cll.excecao_pis_cofins_id        -- vn_excecao_pis_cofins_id
                                      , cll.regtrib_pis_cofins_id        -- vn_id_regtrib_pis_cofins
                                      , cll.fundamento_legal_id          -- vn_fundamento_legal_id
                                      , cll.ato_legal_id
                                      , cll.orgao_emissor_id
                                      , cll.nr_ato_legal
                                      , cll.ano_ato_legal
                                      , Nvl(cll.da_id, vn_da_id)
                                      , cll.da_lin_id
                                      , cll.licenca_id
                                      , cll.licenca_lin_id
                                      , cll.ausencia_fabric
                                      , cll.fabric_id
                                      , cll.fabric_site_id
                                      , cll.fabric_part_number
                                      , cll.pais_origem_id
                                      , cll.naladi_sh_id
                                      , cll.naladi_ncca_id_bkpdcl
                                      , cll.rd_id
                                      , pn_moeda_id /* Para gerar a LI de Drawback precisamos da moeda id */
                                      , vn_linha_num
                                      , vn_evento_id
                                      , vb_erro_nacionalizacao
                                      , 'N'
                                      , 'N'
                                      , vb_li_gerada
                                      , cll.aliq_icms_fecp                 -- vn_aliq_icms_fecp_param
                                      , cll.fundamento_legal_icms_id       -- vn_fund_legal_icms_id
                                      , cll.fundamento_legal_pis_cofins_id -- vn_fund_legal_pis_cofins_id
                                      , cll.flegal_reducao_pis_cofins_id
                                      , cll.aliq_pis_reduzida
                                      , cll.aliq_cofins_reduzida
                                      , cll.flag_reducao_base_pis_cofins
                                      , cll.regime_especial_icms           -- pc_regime_especial_icms
                                      , cll.aliq_pis_especifica            -- pn_aliq_pis_especifica
                                      , cll.aliq_cofins_especifica         -- pn_aliq_cofins_especifica
                                      , cll.qtde_um_aliq_especifica_pc     -- pn_qtde_um_aliq_especifica_pc
                                      , cll.un_medida_aliq_especifica_pc   -- pc_um_aliq_especifica_pc
                                      , cll.excecao_antid_id               -- pn_excecao_antid_id
                                      , cll.aliq_antid                     -- pn_aliq_antid
                                      , null                                -- pn_basecalc_antid
                                      , cll.aliq_antid_especifica          -- pn_aliq_antid_especifica
                                      , null                                -- pn_qtde_um_aliq_especif_antid
                                      , cll.um_aliq_especifica_antid_id    -- pn_um_aliq_especifica_antid_id
                                      , cll.tipo_unidade_medida_antid      -- pc_tipo_unidade_medida_antid
                                      , cll.somatoria_quantidade           -- pc_somatoria_quantidade                                                                                                                                               cll.acordo_aladi_id
                                      , cll.ato_legal_ncm_id
                                      , cll.orgao_emissor_ncm_id
                                      , cll.nr_ato_legal_ncm
                                      , cll.ano_ato_legal_ncm
                                      , cll.ato_legal_nbm_id
                                      , cll.orgao_emissor_nbm_id
                                      , cll.nr_ato_legal_nbm
                                      , cll.ano_ato_legal_nbm
                                      , cll.ato_legal_naladi_id
                                      , cll.orgao_emissor_naladi_id
                                      , cll.nr_ato_legal_naladi
                                      , cll.ano_ato_legal_naladi
                                      , cll.ato_legal_acordo_id
                                      , cll.orgao_emissor_acordo_id
                                      , cll.nr_ato_legal_acordo
                                      , cll.ano_ato_legal_acordo
                                      , cll.aliq_mva
			                                , cll.aliq_cofins_recuperar );
        ELSE
          INSERT INTO imp_declaracoes_lin( declaracao_adi_id               /* 00 */
                                         , declaracao_lin_id               /* 01 */
                                         , declaracao_id                   /* 02 */
                                         , linha_num                       /* 03 */
                                         , invoice_id                      /* 04 */
                                         , invoice_lin_id                  /* 05 */
                                         , licenca_id                      /* 06 */
                                         , item_id                         /* 07 */
                                         , descricao                       /* 08 */
                                         , un_medida_id                    /* 09 */
                                         , qtde                            /* 10 */
                                         , preco_unitario_m                /* 11 */
                                         , tp_classificacao                /* 12 */
                                         , class_fiscal_id                 /* 13 */
                                         , naladi_sh_id                    /* 14 */
                                         , ausencia_fabric                 /* 15 */
                                         , fabric_id                       /* 16 */
                                         , fabric_site_id                  /* 17 */
                                         , fabric_part_number              /* 18 */
                                         , pais_origem_id                  /* 19 */
                                         , pesoliq_tot                     /* 20 */
                                         , pesoliq_unit                    /* 21 */
                                         , regtrib_ii_id                   /* 22 */
                                         , regtrib_ipi_id                  /* 23 */
                                         , regtrib_icms_id                 /* 24 */
                                         , utilizacao_id                   /* 25 */
                                         , ex_ncm_id                       /* 26 */
                                         , ex_nbm_id                       /* 27 */
                                         , ex_naladi_id                    /* 28 */
                                         , ex_ipi_id                       /* 29 */
                                         , ex_prac_id                      /* 30 */
                                         , ex_antd_id                      /* 31 */
                                         , da_id                           /* 32 */
                                         , da_lin_id                       /* 33 */
                                         , naladi_ncca_id                  /* 34 */
                                         , perc_red_icms                   /* 35 */
                                         , aliq_icms                       /* 36 */
                                         , aliq_icms_red                   /* 37 */
                                         , vida_util                       /* 38 */
                                         , licenca_lin_id                  /* 39 */
                                         , creation_date                   /* 40 */
                                         , created_by                      /* 41 */
                                         , last_update_date                /* 42 */
                                         , last_updated_by                 /* 43 */
                                         , nfe_a_imprimir                  /* 44 */
                                         , rd_id                           /* 45 */
                                         , qtde_prod_drawback              /* 46 */
                                         , fator_conversao_drw             /* 47 */
                                         , excecao_ii_id                   /* 48 */
                                         , grupo_acesso_id                 /* 49 */
                                         , regtrib_pis_cofins_id           /* 50 */
                                         , aliq_pis                        /* 51 */
                                         , aliq_cofins                     /* 52 */
                                         , perc_reducao_base_pis_cofins    /* 53 */
                                         , cfop_id                         /* 54 */
                                         , aliq_ipi_red                    /* 55 */
                                         , ato_legal_id                    /* 56 */
                                         , nr_ato_legal                    /* 57 */
                                         , orgao_emissor_id                /* 58 */
                                         , ano_ato_legal                   /* 59 */
                                         , excecao_ipi_id                  /* 60 */
                                         , excecao_icms_id                 /* 61 */
                                         , excecao_pis_cofins_id           /* 62 */
                                         , fundamento_legal_id             /* 63 */
                                         , aliq_ii_red                     /* 64 */
                                         , perc_red_ii                     /* 65 */
                                         , aliq_icms_fecp                  /* 66 */
                                         , fundamento_legal_icms_id        /* 67 */
                                         , fundamento_legal_pis_cofins_id  /* 68 */
                                         , flag_reducao_base_pis_cofins    /* 69 */
                                         , flegal_reducao_pis_cofins_id    /* 70 */
                                         , aliq_pis_reduzida               /* 71 */
                                         , aliq_cofins_reduzida            /* 72 */
                                         , regime_especial_icms            /* 73 */
                                         , aliq_pis_especifica             /* 74 */
                                         , aliq_cofins_especifica          /* 75 */
                                         , qtde_um_aliq_especifica_pc      /* 76 */
                                         , un_medida_aliq_especifica_pc    /* 77 */
                                         , excecao_antid_id                /* 78 */
                                         , aliq_antid                      /* 79 */
                                         , aliq_antid_especifica           /* 80 */
                                         , tipo_unidade_medida_antid       /* 81 */
                                         , somatoria_quantidade            /* 82 */
                                         , um_aliq_especifica_antid_id     /* 83 */
                                         , cert_origem_mercosul_id         /* 84 */
                                         , acordo_aladi_id                 /* 85 */
                                         , ato_legal_ncm_id                /* 86 */
                                         , orgao_emissor_ncm_id            /* 87 */
                                         , nr_ato_legal_ncm                /* 88 */
                                         , ano_ato_legal_ncm               /* 89 */
                                         , ato_legal_nbm_id                /* 90 */
                                         , orgao_emissor_nbm_id            /* 91 */
                                         , nr_ato_legal_nbm                /* 92 */
                                         , ano_ato_legal_nbm               /* 93 */
                                         , ato_legal_naladi_id             /* 94 */
                                         , orgao_emissor_naladi_id         /* 95 */
                                         , nr_ato_legal_naladi             /* 96 */
                                         , ano_ato_legal_naladi            /* 97 */
                                         , ato_legal_acordo_id             /* 98 */
                                         , orgao_emissor_acordo_id         /* 99 */
                                         , nr_ato_legal_acordo             /* 100 */
                                         , ano_ato_legal_acordo            /* 101 */
                                         , aliq_mva                        /* 102 */
                                         , pro_emprego                     /* 103 */
                                         , pro_empr_aliq_base              /* 104 */
                                         , pro_empr_aliq_antecip           /* 105 */
                                         , beneficio_pr                    /* 106 */
                                         , pr_aliq_base                    /* 107 */
                                         , pr_perc_diferido                /* 108 */
                                         , ins_estadual_id                 /* 109 */
                                         , pr_perc_vr_devido               /* 110 */
                                         , pr_perc_minimo_base             /* 111 */
                                         , pr_perc_minimo_suspenso         /* 112 */
                                         , beneficio_sp                    /* 113 */
                                         , enquadramento_legal_ipi_id      /* 114 */
                                         , aliq_cofins_recuperar           /* 115 */
                                         , beneficio_suspensao             /* 116 */
                                         , perc_beneficio_suspensao        /* 117 */
                                          )
                                   VALUES( decode (vn_nat_operacao_id, null, null, vn_adi_id)                            /* 00 */
                                         , vn_declaracao_lin_id                                                            /* 01 */
                                         , vn_declaracao_id                                                                /* 02 */
                                         , vn_linha_num                                                                    /* 03 */
                                         , cll.invoice_id                                                                  /* 04 */
                                         , cll.invoice_lin_id                                                              /* 05 */
                                         , cll.licenca_id                                                                  /* 06 */
                                         , cll.item_id                                                                     /* 07 */
                                         , cll.descricao                                                                   /* 08 */
                                         , cll.un_medida_id                                                                /* 09 */
                                         , cll.qtde                                                                        /* 10 */
                                         , cll.preco_unitario_m                                                            /* 11 */
                                         , cll.tp_classificacao                                                            /* 12 */
                                         , cll.class_fiscal_id                                                             /* 13 */
                                         , cll.naladi_sh_id                                                                /* 14 */
                                         , cll.ausencia_fabric                                                             /* 15 */
                                         , cll.fabric_id                                                                   /* 16 */
                                         , cll.fabric_site_id                                                              /* 17 */
                                         , cll.fabric_part_number                                                          /* 18 */
                                         , cll.pais_origem_id                                                              /* 19 */
                                         , cll.pesoliq_tot                                                                 /* 20 */
                                         , cll.pesoliq_unit                                                                /* 21 */
                                         , cll.regtrib_ii_id                                                               /* 22 */
                                         , cll.regtrib_ipi_id                                                              /* 23 */
                                         , cll.regtrib_icms_id                                                             /* 24 */
                                         , cll.utilizacao_id                                                               /* 25 */
                                         , cll.ex_ncm_id                                                                   /* 26 */
                                         , cll.ex_nbm_id                                                                   /* 27 */
                                         , cll.ex_naladi_id                                                                /* 28 */
                                         , cll.ex_ipi_id                                                                   /* 29 */
                                         , cll.ex_prac_id                                                                  /* 30 */
                                         , cll.ex_antd_id                                                                  /* 31 */
                                         , cll.da_id                                                                       /* 32 */
                                         , cll.da_lin_id                                                                   /* 33 */
                                         , cll.naladi_ncca_id_bkpdcl                                                       /* 34 */
                                         , cll.perc_red_icms                                                               /* 35 */
                                         , cll.aliq_icms                                                                   /* 36 */
                                         , cll.aliq_icms_red                                                               /* 37 */
                                         , cll.vida_util_bkpdcl    	                                                       /* 38 */
                                         , cll.licenca_lin_id                                                              /* 39 */
                                         , sysdate                                                                         /* 40 */
                                         , 0                                                                 /* 41 */
                                         , sysdate                                                                         /* 42 */
                                         , 0                                                            /* 43 */
                                         , 'N'                                                                             /* 44 */
                                         , cll.rd_id                                                                       /* 45 */
                                         , cll.qtde_prod_drawback                                                          /* 46 */
                                         , cll.fator_conversao_drw                                                         /* 47 */
                                         , cll.excecao_ii_id                                                               /* 48 */
                                         , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')                         /* 49 */
                                         , cll.regtrib_pis_cofins_id                                                       /* 50 */
                                         , cll.aliq_pis                                                                    /* 51 */
                                         , cll.aliq_cofins                                                                 /* 52 */
                                         , cll.perc_reducao_base_pis_cofins                                                /* 53 */
                                         , decode ( vn_cfop_nf_importacao_id, NULL, cll.cfop_id, vn_cfop_nf_importacao_id) /* 54 */
                                         , cll.aliq_ipi_red                                                                /* 55 */
                                         , cll.ato_legal_id                                                                /* 56 */
                                         , cll.nr_ato_legal                                                                /* 57 */
                                         , cll.orgao_emissor_id                                                            /* 58 */
                                         , cll.ano_ato_legal                                                               /* 59 */
                                         , cll.excecao_ipi_id                                                              /* 60 */
                                         , cll.excecao_icms_id                                                             /* 61 */
                                         , cll.excecao_pis_cofins_id                                                       /* 62 */
                                         , cll.fundamento_legal_id                                                         /* 63 */
                                         , cll.aliq_ii_red                                                                 /* 64 */
                                         , cll.perc_red_ii                                                                 /* 65 */
                                         , cll.aliq_icms_fecp                                                              /* 66 */
                                         , cll.fundamento_legal_icms_id                                                    /* 67 */
                                         , vn_fund_legal_pis_cofins_id                                                     /* 68 */
                                         , cll.flag_reducao_base_pis_cofins                                                /* 69 */
                                         , cll.flegal_reducao_pis_cofins_id                                                /* 70 */
                                         , cll.aliq_pis_reduzida                                                           /* 71 */
                                         , cll.aliq_cofins_reduzida                                                        /* 72 */
                                         , cll.regime_especial_icms                                                        /* 73 */
                                         , cll.aliq_pis_especifica                                                         /* 74 */
                                         , cll.aliq_cofins_especifica                                                      /* 75 */
                                         , cll.qtde_um_aliq_especifica_pc                                                  /* 76 */
                                         , cll.un_medida_aliq_especifica_pc                                                /* 77 */
                                         , cll.excecao_antid_id                                                            /* 78 */
                                         , cll.aliq_antid                                                                  /* 79 */
                                         , cll.aliq_antid_especifica                                                       /* 80 */
                                         , cll.tipo_unidade_medida_antid                                                   /* 81 */
                                         , cll.somatoria_quantidade                                                        /* 82 */
                                         , cll.um_aliq_especifica_antid_id                                                 /* 83 */
                                         , cll.cert_origem_mercosul_id                                                     /* 84 */
                                         , cll.acordo_aladi_id                                                             /* 85 */
                                         , cll.ato_legal_ncm_id                                                            /* 86 */
                                         , cll.orgao_emissor_ncm_id                                                        /* 87 */
                                         , cll.nr_ato_legal_ncm                                                            /* 88 */
                                         , cll.ano_ato_legal_ncm                                                           /* 89 */
                                         , cll.ato_legal_nbm_id                                                            /* 90 */
                                         , cll.orgao_emissor_nbm_id                                                        /* 91 */
                                         , cll.nr_ato_legal_nbm                                                            /* 92 */
                                         , cll.ano_ato_legal_nbm                                                           /* 93 */
                                         , cll.ato_legal_naladi_id                                                         /* 94 */
                                         , cll.orgao_emissor_naladi_id                                                     /* 95 */
                                         , cll.nr_ato_legal_naladi                                                         /* 96 */
                                         , cll.ano_ato_legal_naladi                                                        /* 97 */
                                         , cll.ato_legal_acordo_id                                                         /* 98 */
                                         , cll.orgao_emissor_acordo_id                                                     /* 99 */
                                         , cll.nr_ato_legal_acordo                                                         /* 100 */
                                         , cll.ano_ato_legal_acordo                                                        /* 101 */
                                         , cll.aliq_mva                                                                    /* 102 */
                                         , cll.pro_emprego                                                                 /* 103 */
                                         , cll.pro_empr_aliq_base                                                          /* 104 */
                                         , cll.pro_empr_aliq_antecip                                                       /* 105 */
                                         , cll.beneficio_pr                                                                /* 106 */
                                         , cll.pr_aliq_base                                                                /* 107 */
                                         , cll.pr_perc_diferido                                                            /* 108 */
                                         , cll.ins_estadual_id                                                             /* 109 */
                                         , cll.pr_perc_vr_devido                                                           /* 110 */
                                         , cll.pr_perc_minimo_base                                                         /* 111 */
                                         , cll.pr_perc_minimo_suspenso                                                     /* 112 */
                                         , cll.beneficio_sp                                                                /* 113 */
                                         , cll.enquadramento_legal_ipi_id                                                  /* 114 */
                                         , cll.aliq_cofins_recuperar                                                       /* 115 */
                                         , cll.beneficio_suspensao                                                         /* 116 */
                                         , cll.perc_beneficio_suspensao                                                    /* 117 */
                                         );
        END IF;

        /*Gravando a auditoria*/
        imp_prc_dcllin_auditoria   ( vn_declaracao_id
                                  , vn_declaracao_lin_id
                                  , cll.descricao
                                  , cll.qtde
                                  , cll.preco_unitario_m
                                  , 0
                                  , 'A'
                                  , 'N'
                                  );

        vc_step_error := null;
      END LOOP; /* cur_linhas_licencas */
    END IF; /* (vn_declaracao_id is not null) */
  END IF; /* vb_achou */
EXCEPTION
  WHEN others THEN
    IF (vn_evento_id IS NOT NULL) THEN
      raise_application_error (-20000, 'IMP_TRG_ATUALIZA_DI_LI_IVC [' || sqlerrm || ']. Erro na criação da linha da Declaração a partir de uma Licença. [' || vc_step_error || '] - Mais detalhes no evento do sistema '||vn_evento_id);
    ELSE
      raise_application_error (-20000, 'IMP_TRG_ATUALIZA_DI_LI_IVC [' || sqlerrm || ']. Erro na criação da linha da Declaração a partir de uma Licença. [' || vc_step_error || ']');
    END IF;
END imp_prc_atualiza_di_li_ivc;
/

