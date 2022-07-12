PROMPT CREATE OR REPLACE FUNCTION imp_fnc_gera_adicao_dcl_link
CREATE OR REPLACE FUNCTION imp_fnc_gera_adicao_dcl_link
                          ( pn_declaracao_id               NUMBER   /* 01 */
                          , pn_tp_declaracao_id            NUMBER   /* 02 */
                          , pn_declaracao_adi_id           NUMBER   /* 03 */
                          , pc_tp_classificacao            VARCHAR2 /* 04 */
                          , pn_class_fiscal_id             NUMBER   /* 05 */
                          , pn_invoice_lin_id              NUMBER   /* 06 */
                          , pn_regtrib_ii_id               NUMBER   /* 07 */
                          , pn_regtrib_ipi_id              NUMBER   /* 08 */
                          , pn_aliq_ipi_red                NUMBER   /* 09 */
                          , pn_perc_red_ii                 NUMBER   /* 10 */
                          , pn_aliq_ii_red                 NUMBER   /* 11 */
                          , pn_rd_id                       NUMBER   /* 12 */
                          , pn_licenca_id                  NUMBER   /* 13 */
                          , pn_ausencia_fabric             NUMBER   /* 14 */
                          , pn_fabric_id                   NUMBER   /* 15 */
                          , pn_fabric_site_id              NUMBER   /* 16 */
                          , pn_pais_origem_id              NUMBER   /* 17 */
                          , pn_item_id                     NUMBER   /* 18 */
                          , pn_naladi_sh_id                NUMBER   /* 19 */
                          , pn_naladi_ncca_id              NUMBER   /* 20 */
                          , pn_ex_ncm_id                   NUMBER   /* 21 */
                          , pn_ex_nbm_id                   NUMBER   /* 22 */
                          , pn_ex_naladi_id                NUMBER   /* 23 */
                          , pn_ex_ipi_id                   NUMBER   /* 24 */
                          , pn_ex_prac_id                  NUMBER   /* 25 */
                          , pn_ex_antd_id                  NUMBER   /* 26 */
                          , pn_da_lin_id                   NUMBER   /* 27 */
                          , pn_vida_util                   NUMBER   /* 28 */
                          , pc_dsi                         VARCHAR2 /* 29 */
                          , pd_creation_date               DATE     /* 30 */
                          , pn_created_by                  NUMBER   /* 31 */
                          , pd_last_update_date            DATE     /* 32 */
                          , pn_last_updated_by             NUMBER   /* 33 */
                          , pn_fundamento_legal_id         NUMBER   /* 34 */
                          , pn_ato_legal_id                NUMBER   /* 35 */
                          , pn_orgao_emissor_id            NUMBER   /* 36 */
                          , pn_nr_ato_legal                NUMBER   /* 37 */
                          , pn_ano_ato_legal               NUMBER   /* 38 */
                          , pn_regtrib_icms_id             NUMBER   /* 39 */
                          , pn_aliq_icms                   NUMBER   /* 40 */
                          , pn_aliq_icms_red               NUMBER   /* 41 */
                          , pn_perc_red_icms               NUMBER   /* 42 */
                          , pn_aliq_icms_fecp              NUMBER   /* 43 */
                          , pn_fund_legal_icms_id          NUMBER   /* 44 */
                          , pn_regtrib_pis_cofins_id       NUMBER   /* 45 */
                          , pn_aliq_pis                    NUMBER   /* 46 */
                          , pn_aliq_cofins                 NUMBER   /* 47 */
                          , pn_perc_red_base_pis_cofins    NUMBER   /* 48 */
                          , pn_fund_legal_pis_cofins_id    NUMBER   /* 49 */
                          , pc_flag_red_base_pis_cofins    VARCHAR2 /* 50 */
                          , pn_flegal_red_pis_cofins_id    NUMBER   /* 51 */
                          , pn_aliq_pis_reduzida           NUMBER   /* 52 */
                          , pn_aliq_cofins_reduzida        NUMBER   /* 53 */
                          , pc_regime_especial_icms        VARCHAR2 /* 54 */
                          , pn_aliq_pis_especifica         NUMBER   /* 55 */
                          , pn_aliq_cofins_especifica      NUMBER   /* 56 */
                          , pn_qtde_um_aliq_especifica_pc  NUMBER   /* 57 */
                          , pc_um_aliq_especifica_pc       VARCHAR2 /* 58 */
                          , pn_acordo_aladi_id             NUMBER   /* 59 */
                          , pn_cert_origem_mercosul_id     NUMBER   /* 60 */
                          , pn_aliq_antid_ad_valorem       NUMBER   /* 61 */
                          , pn_aliq_antid_especifica       NUMBER   /* 62 */
                          , pn_um_aliq_especifica_antid_id NUMBER   /* 63 */
                          , pc_somatoria_quantidade        VARCHAR2 /* 64 */
                          , pn_ato_legal_ncm_id            NUMBER   /* 65 */
                          , pn_orgao_emissor_ncm_id        NUMBER   /* 66 */
                          , pn_nr_ato_legal_ncm            NUMBER   /* 67 */
                          , pn_ano_ato_legal_ncm           NUMBER   /* 68 */
                          , pn_ato_legal_nbm_id            NUMBER   /* 69 */
                          , pn_orgao_emissor_nbm_id        NUMBER   /* 70 */
                          , pn_nr_ato_legal_nbm            NUMBER   /* 71 */
                          , pn_ano_ato_legal_nbm           NUMBER   /* 72 */
                          , pn_ato_legal_naladi_id         NUMBER   /* 73 */
                          , pn_orgao_emissor_naladi_id     NUMBER   /* 74 */
                          , pn_nr_ato_legal_naladi         NUMBER   /* 75 */
                          , pn_ano_ato_legal_naladi        NUMBER   /* 76 */
                          , pn_ato_legal_acordo_id         NUMBER   /* 77 */
                          , pn_orgao_emissor_acordo_id     NUMBER   /* 78 */
                          , pn_nr_ato_legal_acordo         NUMBER   /* 79 */
                          , pn_ano_ato_legal_acordo        NUMBER   /* 80 */
                          , pn_aliquota_mva                NUMBER   /* 81 */
                          , pc_pro_emprego                 VARCHAR2 /* 82 */
                          , pn_aliq_base_pro_emprego       NUMBER   /* 83 */
                          , pn_aliq_antecip_pro_emprego    NUMBER   /* 84 */
                          , pc_beneficio_pr                VARCHAR2 /* 85 */
                          , pn_aliq_base_pr                NUMBER   /* 86 */
                          , pn_perc_diferido_pr            NUMBER   /* 87 */
                          , pn_ins_estadual_id             NUMBER   /* 88 */
                          , pn_pr_perc_vr_devido           NUMBER   /* 89 */
                          , pn_pr_perc_minimo_base         NUMBER   /* 90 */
                          , pn_pr_perc_minimo_suspenso     NUMBER   /* 91 */
                          , pc_beneficio_sp                VARCHAR2 /* 92 */
                          , pn_benef_id                    NUMBER   DEFAULT NULL /* 93 */
                          , pn_vlr_frete_afrmm             NUMBER   DEFAULT NULL /* 94 */
                          , pc_beneficio_suspensao         VARCHAR2 DEFAULT NULL /* 95 */
                          , pn_perc_beneficio_suspensao    NUMBER   DEFAULT NULL /* 96 */
                          ) RETURN NUMBER AS

  vc_tp_declaracao            VARCHAR2(20)   := null;
  vn_dummy                    NUMBER         := null;
  vn_qtde_linhas_adi          NUMBER         := null;
  vn_declaracao_adi_id        NUMBER         := null;
  vn_export_id                NUMBER         := null;
  vn_export_site_id           NUMBER         := null;
  vn_moeda_id                 NUMBER         := null;
  vn_moeda_invoice_id         imp_invoices.moeda_id%TYPE;
  vn_incoterm_id              NUMBER         := null;
  vn_termo_id                 NUMBER         := null;
  vn_repres_id                NUMBER         := null;
  vn_repres_site_id           NUMBER         := null;
  vn_repres_banco_agencia_id  NUMBER         := null;
  vn_repres_pc_comissao       NUMBER         := null;
  vn_local_cvenda_id          NUMBER         := null;
  vc_material_usado           VARCHAR2(1)    := 'N';
  vc_bem_encomenda            VARCHAR2(1)    := 'N';
  vc_flag_vr_remeter          VARCHAR2(1)    := 'N';
  vn_utilizacao_id            NUMBER         := null;
  vc_nr_dcl_admissao          imp_declaracoes.nr_declaracao%Type := null;
  vb_achou_docvinc            BOOLEAN        := TRUE;
  vn_auxiliar                 NUMBER         := 0;
  vn_da_urfe_id               NUMBER         := null;
  vn_da_pais_proc_id          NUMBER         := null;
  vn_da_via_transporte_id     NUMBER         := null;
  vc_da_multimodal            VARCHAR2(1)    := null;
  vn_da_moeda_frete_id        NUMBER         := null;
  vn_da_moeda_seguro_id       NUMBER         := null;
  vn_cobertura_cambial        NUMBER         := null;
  vn_mde_pgto_id              NUMBER         := null;
  vn_motivo_sem_cobertura_id  NUMBER         := null;
  vn_inst_financeira_id       NUMBER         := null;
  vn_fundamento_legal_id      NUMBER         := null;
  vn_tp_acordo                NUMBER         := null;
  vn_acordo_aladi_id          NUMBER         := null;
  vn_nr_periodos              NUMBER         := null;
  vc_tp_periodos              VARCHAR2(1)    := null;
  vn_nr_parcelas              NUMBER         := null;
  vc_com_contrato             VARCHAR2(1)    := null;
  vb_primeira_vez             BOOLEAN        := TRUE;
  vn_primeira_parcela         NUMBER         := null;
  vn_ultima_parcela           NUMBER         := null;
  vc_parcelas_fixas           VARCHAR2(1)    := 'S';
  vn_aliq_ii_dev              NUMBER         := null;
  vn_aliq_ipi_dev             NUMBER         := null;
  vn_aliq_ii_mercosul         NUMBER         := null;
  vn_aliq_pis_dev             NUMBER         := null;
  vn_aliq_cofins_dev          NUMBER         := null;
  vb_mercosul                 BOOLEAN        := false;
  vn_aliq_ii_red              NUMBER         := null;
  vn_aliq_ii_acordo           NUMBER         := null;
  vc_nve_item                 varchar2(2000) := null;
  vn_motivo_tsp_id            NUMBER         := null;
  vc_destaque_extensao_item   VARCHAR2(2000) := null;
  vc_destaque_item            VARCHAR2(2000) := null;
  vn_pais_origem_id           NUMBER         := null;
  vn_naladi_sh_id             NUMBER         := null;
  vb_existe_pgto              BOOLEAN;
  vb_achou_dtr                BOOLEAN        := true;
  vb_pais_mercosul            BOOLEAN        := false;
  vn_dtr_numero               imp_dtr.dtr_numero%TYPE;
  vn_embarque_id              imp_embarques.embarque_id%TYPE;
  vc_fins_cambiais            imp_declaracoes.fins_cambiais%TYPE;
  vn_cert_origem_mercosul_id  imp_cert_origem_mercosul.cert_origem_mercosul_id%TYPE;
  vc_numero_rof               cam_contratos.contrato_numero%TYPE;
  vn_invoice_id               imp_invoices.invoice_id%TYPE;
  vn_perc_acordo              imp_cert_origem_mercosul.perc_acordo%TYPE;
  vn_certificado              imp_cert_origem_mercosul.certificado%TYPE;
  vb_quebra_nve               BOOLEAN;
  vb_quebra_destaque          BOOLEAN;
  vn_retorno                  NUMBER;
  vn_benef_id                 NUMBER;
  vn_vlr_frete_afrmm          NUMBER;
  vc_tp_classificacao         VARCHAR2(4);
  vn_class_fiscal_id          NUMBER;
  vn_class_fiscal_temp        NUMBER;
  vn_regtrib_ii_id            NUMBER;
  vb_achou                    BOOLEAN := FALSE;

  vn_mat_usado_enq_id         NUMBER;
  vn_mat_usado_oper_id        NUMBER;
  vc_mat_usado_marca          imp_invoices_lin.li_marca%TYPE;
  vc_mat_usado_n_serie        imp_invoices_lin.li_numero_serie%TYPE;
  vc_mat_usado_modelo         imp_invoices_lin.li_modelo%TYPE;
  vc_mat_usado_ano            imp_invoices_lin.li_ano_fabricacao%TYPE;
  vc_aplicacao                VARCHAR2(1)    := null;

  vc_tipo_ebq_tipo_fixo       cmx_tabelas.auxiliar1%TYPE;
  vc_tipo_ebq_ativo           cmx_tabelas.auxiliar1%TYPE;
  vc_tipo_ebq_regime          cmx_tabelas.auxiliar1%TYPE;
  vc_tipo_ebq_nac_terceiro    cmx_tabelas.auxiliar1%TYPE;

  /* Excecao específica para o tratamento do erro "ORA-00054: resource busy and
     acquire with NOWAIT specified".
  */
  ve_nowait  EXCEPTION;
  PRAGMA EXCEPTION_INIT (ve_nowait, -54);

  CURSOR cur_ex_tarifario (pn_assunto NUMBER, pn_ex_tarifario_id NUMBER) IS
    SELECT ato_legal_id
         , orgao_emissor_id
         , nr_ato_legal
         , ano_ato_legal
         , aliquota
      FROM imp_ex_tarifario
     WHERE assunto         = pn_assunto
       AND ex_tarifario_id = pn_ex_tarifario_id;

  vcur_ex1  cur_ex_tarifario%ROWTYPE;
  vcur_ex2  cur_ex_tarifario%ROWTYPE;
  vcur_ex3  cur_ex_tarifario%ROWTYPE;
  vcur_ex4  cur_ex_tarifario%ROWTYPE;
  vcur_ex5  cur_ex_tarifario%ROWTYPE;
  vcur_ex6  cur_ex_tarifario%ROWTYPE;

  CURSOR cur_licencas_destaque IS
    SELECT destaque
      FROM imp_licencas_destaque
     WHERE licenca_id = pn_licenca_id;

  CURSOR cur_destaque_item IS
    SELECT lpad (destaque_ncm_imp, 3, '0') destaque_ncm_imp
      FROM cmx_itens_ext
     WHERE item_id = pn_item_id;

  CURSOR cur_destaque_ncm IS
    SELECT lpad (ct.auxiliar2, 3, '0') auxiliar2
      FROM cmx_tabelas ct
         , cmx_tab_ncm ctn
     WHERE ctn.ncm_id   = pn_class_fiscal_id
       AND ct.tipo      = '134'
       AND ct.auxiliar1 = ctn.codigo;

  CURSOR cur_destaque_a_ser_inserido IS
    SELECT lpad (destaque, 3, '0') destaque
      FROM imp_tmp_destaque_linhas
     ORDER BY destaque;

  CURSOR cur_licencas_nve IS
    SELECT abrangencia
         , atributo
         , especificacao
      FROM imp_licencas_nve
     WHERE licenca_id = pn_licenca_id;

  -- na troca do order by deste cursor, deve-se repetir a ordenacao
  -- nas funcoes imp_fnc_busca_nve_li e imp_fnc_gera_adicao_li
  CURSOR cur_itens_nve IS
    SELECT abrangencia
         , atributo
         , especificacao
      FROM imp_itens_nve
     WHERE item_id = pn_item_id
     ORDER BY abrangencia
         , atributo
         , especificacao;

  CURSOR cur_naladi_sh IS
    SELECT naladi_sh_id
      FROM cmx_naladi_sh_ncm
     WHERE ncm_id = pn_class_fiscal_id;

  CURSOR cur_termo_pgto (pn_termo_id NUMBER) IS
    SELECT cobertura_cambial
         , mde_pgto_id
         , motivo_sem_cobertura_id
         , com_contrato
      FROM imp_termos_pgto
     WHERE termo_id = pn_termo_id;

  CURSOR cur_termo_pgto_lin (pn_termo_id NUMBER) IS
    SELECT data_fixa
         , percentual
         , valor_fixo
         , dias
         , dia_do_mes
         , meses
         , tp_pgto
      FROM imp_termos_pgto_lin
     WHERE termo_id = pn_termo_id
       AND nvl (tp_pgto,'P')='P';

  CURSOR cur_invoice IS
    SELECT ii.incoterm_id
         , ii.export_id
         , ii.export_site_id
         , ii.termo_id
         , ii.moeda_id
         , ii.local_cvenda_id
         , iil.repres_id
         , iil.repres_site_id
         , iil.repres_banco_agencia_id
         , iil.repres_pc_comissao
         , iil.material_usado
         , iil.bem_encomenda
         , iil.flag_vr_remeter
         , iil.utilizacao_id
         , ii.invoice_id
         , cu.aplicacao
         , iil.li_marca
         , iil.li_numero_serie
         , iil.li_modelo
         , iil.li_ano_fabricacao
         , iil.mat_usado_enq_id
         , iil.mat_usado_oper_id
      FROM imp_invoices     ii
         , imp_invoices_lin iil
         , cmx_utilizacoes  cu
     WHERE iil.invoice_lin_id = pn_invoice_lin_id
       AND ii.invoice_id      = iil.invoice_id
       AND iil.utilizacao_id   = cu.utilizacao_id(+);

  CURSOR cur_dcl_adi_docvinc IS
    SELECT 0
      FROM imp_dcl_adi_docvinc
     WHERE declaracao_adi_id = vn_declaracao_adi_id
       AND tp_dcto           = 2
       AND nr_dcto           = vc_nr_dcl_admissao;

  CURSOR cur_dcl_adi_pgto IS
    SELECT tp_pgto
         , contrato_num
         , banco_agencia_id
      FROM imp_dcl_adi_pgto
     WHERE declaracao_adi_id = vn_declaracao_adi_id
       AND tp_pgto <> 'P'
    ORDER BY tp_pgto, contrato_num, banco_agencia_id;

  CURSOR cur_tab_ncm IS
    SELECT aliq_ii
         , aliq_ipi
         , aliq_ii_mercosul
         , aliq_pis
         , aliq_cofins
      FROM cmx_tab_ncm
     WHERE ncm_id = pn_class_fiscal_id;

  CURSOR cur_pais_mercosul( pc_pais VARCHAR2 ) IS
    SELECT 1
      FROM cmx_tabelas
     WHERE tipo   = '903'
       AND codigo = pc_pais;

  CURSOR cur_aliq_trib_simp(pn_class_fiscal_id NUMBER) IS
    SELECT aliq_trib_simplificada
      FROM imp_trib_simplificada
     WHERE trib_simplificada_id = pn_class_fiscal_id;

  CURSOR cur_pgto_antecipado IS
    SELECT DISTINCT cc.contrato_numero
         , cc.instituicao_praca_id
         , (SELECT auxiliar1
              FROM cmx_tabelas
             WHERE auxiliar2 = cba.cd_banco
               AND auxiliar3 = cba.cd_agencia
               AND tipo      = '942'
           ) cd_praca
      FROM cam_documentos_antecipados  cda
         , cam_parcelas                cpa
         , cam_documentos              cdc
         , cam_parcelas                cpaa
         , cam_vinculacoes             cvca
         , cam_contratos               cc
         , cmx_bancos_agencias         cba
     WHERE cdc.tipo_id          = cmx_pkg_tabelas.tabela_id ('301','CI')
       AND cpa.parcela_id       = cda.parcela_id
       AND cdc.documento_id     = cpa.documento_id
       AND cpaa.documento_id    = cda.documento_antecipado_id
       AND cvca.parcela_id      = cpaa.parcela_id
       AND cc.contrato_id       = cvca.contrato_id
       AND cba.banco_agencia_id = cc.instituicao_praca_id
       AND cc.contrato_numero   NOT LIKE '%MINUTA%'
       AND cdc.documento_id     = (SELECT to_number (global_atributo1) documento_id
                                     FROM imp_invoices_lin invl
                                    WHERE invl.invoice_lin_id = pn_invoice_lin_id);

  CURSOR cur_pgto_avista IS
    SELECT cc.contrato_numero
         , cc.instituicao_praca_id
         , (SELECT auxiliar1
              FROM cmx_tabelas
             WHERE auxiliar2 = cba.cd_banco
               AND auxiliar3 = cba.cd_agencia
               AND tipo      = '942'
           ) cd_praca
      FROM cam_documentos doc
         , cam_parcelas cp
         , cam_vinculacoes cv
         , cam_contratos cc
         , cmx_bancos_agencias cba
     WHERE doc.tipo_id          = cmx_pkg_tabelas.tabela_id ('301','CI')
       AND cp.documento_id      = doc.documento_id
       AND cv.parcela_id        = cp.parcela_id
       AND cc.contrato_id       = cv.contrato_id
       AND cc.tipo_contrato_id  <> cmx_pkg_tabelas.tabela_id ('302','ROF')
       AND cc.contrato_numero   NOT LIKE '%MINUTA%'
       AND cba.banco_agencia_id = cc.instituicao_praca_id
       AND doc.documento_id     = (SELECT to_number (global_atributo1) documento_id
                                      FROM imp_invoices_lin invl
                                     WHERE invl.invoice_lin_id = pn_invoice_lin_id);

  CURSOR cur_rof (pn_invoice_id NUMBER) IS
    SELECT cc.contrato_numero
         , cmx_pkg_tabelas.tabela_id ('130', cc.atributo20) inst_financiadora_id
      FROM cam_vinculacoes cv
         , cam_parcelas    cp
         , cam_documentos  cd
         , cam_contratos   cc
     WHERE cc.contrato_id           = cv.contrato_id
       AND cc.tipo_contrato_id      = cmx_pkg_tabelas.tabela_id ('302','ROF')
       AND cv.parcela_id            = cp.parcela_id
       AND cp.documento_id          = cd.documento_id
       AND cd.invoice_importacao_id = pn_invoice_id;

  CURSOR cur_existe_pgto ( pn_decl_adi_id      NUMBER
                         , pn_banco_agencia_id NUMBER
                         , pc_contrato         VARCHAR2
                         , pc_tp_pgto          VARCHAR2
                         ) IS
    SELECT 0
      FROM imp_dcl_adi_pgto
     WHERE declaracao_id     = pn_declaracao_id
       AND declaracao_adi_id = pn_decl_adi_id
       AND tp_pgto           = pc_tp_pgto
       AND contrato_num      = pc_contrato
       AND banco_agencia_id  = pn_banco_agencia_id;

  CURSOR cur_lock_adi (pn_declaracao_adi_id NUMBER) IS
    SELECT null
      FROM imp_declaracoes_adi
     WHERE declaracao_adi_id = pn_declaracao_adi_id
       FOR UPDATE OF qtde_linhas, qtde_um_aliq_especifica_pc, vlr_frete
    NOWAIT;

  CURSOR cur_aplicacao (pn_utilizacao_id NUMBER) IS
    SELECT aplicacao
      FROM cmx_utilizacoes
     WHERE utilizacao_id = pn_utilizacao_id;

  CURSOR cur_tipo_fornec (vn_entidade_id NUMBER, vn_entidade_site_id NUMBER) IS
    SELECT vinc_imp_exp
      FROM imp_entidades_sites
     WHERE entidade_id      = vn_entidade_id
       AND entidade_site_id = vn_entidade_site_id;

  vc_vinc_imp_exp imp_declaracoes_adi.vinc_imp_exp%TYPE;

  CURSOR cur_embarque_id IS
    SELECT embarque_id
         , fins_cambiais
      FROM imp_declaracoes
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_verifica_dtr (pn_embarque_id NUMBER) IS
    SELECT dtr_numero
      FROM imp_dtr
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_perc_acordo IS
    SELECT perc_acordo
         , certificado
      FROM imp_cert_origem_mercosul     c
         , imp_cert_origem_mercosul_lin clin
     WHERE c.cert_origem_mercosul_id = clin.cert_origem_mercosul_id
       AND clin.invoice_lin_id = pn_invoice_lin_id;

  CURSOR cur_ncm IS
    SELECT aliq_ii_mercosul
      FROM cmx_tab_ncm
     WHERE ncm_id = pn_class_fiscal_id
       AND SYSDATE BETWEEN dtini_vig_ii_mercosul AND dtfim_vig_ii_mercosul;

  CURSOR cur_empresa IS
    SELECT empresa_id
      FROM imp_declaracoes
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_verif_tp_conhec IS
    SELECT con.via_transporte_id
      FROM imp_vw_altera_ce_mercante vw
         , imp_conhecimentos con
     WHERE vw.conhec_id = con.conhec_id
       AND declaracao_id = pn_declaracao_id;

  CURSOR cur_item_com_rcr IS
    SELECT rcr_lin.invoice_lin_id
      FROM imp_adm_temp_rcr_lin rcr_lin
         , imp_adm_temp_rcr     rcr
         , imp_declaracoes      id
     WHERE rcr_lin.invoice_lin_id  = pn_invoice_lin_id
       AND rcr_lin.rcr_id          = rcr.rcr_id
       AND rcr.embarque_id         = id.embarque_id
       AND rcr.processo_numero    IS NOT NULL
       AND id.declaracao_id        = pn_declaracao_id
  UNION ALL
    SELECT rat_lin.invoice_lin_id
      FROM imp_adm_temp_rat_lin rat_lin
         , imp_adm_temp_rat     rat
         , imp_declaracoes      id
     WHERE rat_lin.invoice_lin_id  = pn_invoice_lin_id
       AND rat_lin.rat_id          = rat.rat_id
       AND rat.embarque_id         = id.embarque_id
       AND id.declaracao_id        = pn_declaracao_id;

  CURSOR cur_aliq_dif_icms_pr (pn_empresa_id NUMBER) IS
    SELECT arredonda_aliq_diferim_icms_pr
      FROM imp_empresas_param
    WHERE empresa_id = pn_empresa_id;

  CURSOR cur_verifica_item(pn_invoice_id NUMBER) IS
    SELECT cie.trib_simplificada_id
        FROM cmx_itens_ext          cie
          , imp_trib_simplificada  its
          , imp_invoices_lin       iil
      WHERE cie.trib_simplificada_id = its.trib_simplificada_id
        AND cie.item_id              = iil.item_id
        AND iil.invoice_lin_id       = pn_invoice_id
        AND Trunc(SYSDATE) BETWEEN dtini_trib_simplificada AND dtfim_trib_simplificada;

  CURSOR cur_verifica_regtrib_ii_tsp IS
    SELECT cta.tabela_id
      FROM cmx_tabelas cta
    WHERE cta.tipo   = '104'
      AND cta.codigo IN (2,7) -- 2 IMUNIDADE / 7 TRIBUTACAO SIMPLIFICADA
      AND EXISTS (SELECT null
                    FROM cmx_tabelas ctb
                    WHERE ctb.tipo      = '107'
                      AND cta.codigo    = ctb.auxiliar2
                      AND ctb.auxiliar1 = (SELECT cta.codigo
	                                          FROM imp_declaracoes idcl
	                                              , cmx_tabelas     cta
	                                          WHERE declaracao_id    = pn_declaracao_id
	                                            AND tp_declaracao_id = tabela_id)
                  )
        ORDER BY cta.codigo DESC;

  vn_empresa_id          imp_declaracoes.empresa_id%TYPE;
  vn_conhec_id           imp_conhecimentos.conhec_id%TYPE;
  vb_linha_ivc_tem_rcr   BOOLEAN := FALSE;
  vc_admissao_temporaria imp_declaracoes_adi.admissao_temporaria%TYPE;
  vc_arredonda_aliq_dife_icms_pr imp_empresas_param.arredonda_aliq_diferim_icms_pr%TYPE;
  vb_achou_regtrib_ii_tsp BOOLEAN := FALSE;

  PROCEDURE prc_busca_licenca IS
    pragma autonomous_transaction;

    CURSOR cur_licencas IS
      SELECT tp_acordo
           , acordo_aladi_id
           , fundamento_legal_id
           , cobertura_cambial
           , mde_pgto_id
           , inst_financiadora_id
           , motivo_sem_cobertura_id
           , qtde_dias
           , material_usado
           , bem_encomenda
           , motivo_trib_simpl_dsi_id
           , cert_origem_mercosul_id
           , aplicacao
           , mat_usado_marca
           , mat_usado_n_serie
           , mat_usado_modelo
           , mat_usado_ano
           , mat_usado_enq_id
           , mat_usado_oper_id
        FROM imp_licencas
       WHERE licenca_id = pn_licenca_id;

  BEGIN
    OPEN  cur_licencas;
    FETCH cur_licencas INTO vn_tp_acordo
                          , vn_acordo_aladi_id
                          , vn_fundamento_legal_id
                          , vn_cobertura_cambial
                          , vn_mde_pgto_id
                          , vn_inst_financeira_id
                          , vn_motivo_sem_cobertura_id
                          , vn_nr_periodos
                          , vc_material_usado
                          , vc_bem_encomenda
                          , vn_motivo_tsp_id
                          , vn_cert_origem_mercosul_id
                          , vc_aplicacao
                          , vc_mat_usado_marca
                          , vc_mat_usado_n_serie
                          , vc_mat_usado_modelo
                          , vc_mat_usado_ano
                          , vn_mat_usado_enq_id
                          , vn_mat_usado_oper_id
                          ;
    CLOSE cur_licencas;

    COMMIT;
  END prc_busca_licenca;

  PROCEDURE prc_busca_da(pn_embarque_id NUMBER) IS
    pragma autonomous_transaction;

    CURSOR cur_verifica_da_terceiro IS
      SELECT nvl (cmx_pkg_tabelas.auxiliar (ie.tp_embarque_id,  1), 'N') tipo_fixo
           , nvl (cmx_pkg_tabelas.auxiliar (ie.tp_embarque_id,  6), 'N') ativo
           , nvl (cmx_pkg_tabelas.auxiliar (ie.tp_embarque_id,  9), 'N') regime
           , nvl (cmx_pkg_tabelas.auxiliar (ie.tp_embarque_id, 19), 'N') nac_terceiro
        FROM imp_embarques   ie
           --, imp_declaracoes id
       WHERE ie.embarque_id   = pn_embarque_id;--id.embarque_id
         --AND id.declaracao_id = pn_declaracao_id;;

    CURSOR cur_dados_nac_terceiro IS
      SELECT urf_pais_nac_id
           , pais_proc_nac_id
           , via_transp_nac_id
           , via_transp_multimodal_nac
           , moeda_da_nac_id
           , moeda_sg_da_nac_id
        FROM imp_invoices_lin iil
       WHERE iil.invoice_lin_id = pn_invoice_lin_id;

    CURSOR cur_dcl_admissao IS
      SELECT /*ida.export_id
           , ida.export_site_id
           , id.urfe_id
           , id.pais_proc_id
           , ic.via_transporte_id
           , ic.multimodal
           , ii.local_cvenda_id*/
             ii.moeda_id
           , ic.moeda_id moeda_frete_id
           , ie.moeda_seguro_id
           , ida.material_usado
           , ida.bem_encomenda
           , id.nr_declaracao
           /*, ii.incoterm_id
           , ida.aplicacao*/
        FROM imp_declaracoes_lin idl
           , imp_declaracoes_adi ida
           , imp_declaracoes     id
           , imp_embarques       ie
           , imp_conhecimentos   ic
           , imp_invoices        ii
       WHERE idl.declaracao_lin_id = pn_da_lin_id
         AND ida.declaracao_adi_id = idl.declaracao_adi_id
         AND id.declaracao_id      = idl.declaracao_id
         AND ie.embarque_id        = id.embarque_id
         AND ic.conhec_id          = ie.conhec_id
         AND ii.invoice_id         = idl.invoice_id;

    vb_achouDA      BOOLEAN := true;
  BEGIN
    OPEN  cur_verifica_da_terceiro;
    FETCH cur_verifica_da_terceiro INTO vc_tipo_ebq_tipo_fixo
                                      , vc_tipo_ebq_ativo
                                      , vc_tipo_ebq_regime
                                      , vc_tipo_ebq_nac_terceiro;
    CLOSE cur_verifica_da_terceiro;

    IF (vc_tipo_ebq_tipo_fixo    = 'NAC_DE_TERC' AND --NAC
        vc_tipo_ebq_ativo        = 'S'   AND
        vc_tipo_ebq_regime       = 'DE'  AND
        vc_tipo_ebq_nac_terceiro = 'S'   )
    THEN
      OPEN  cur_dados_nac_terceiro;
      FETCH cur_dados_nac_terceiro INTO vn_da_urfe_id
                                      , vn_da_pais_proc_id
                                      , vn_da_via_transporte_id
                                      , vc_da_multimodal
                                      , vn_da_moeda_frete_id
                                      , vn_da_moeda_seguro_id;
      CLOSE cur_dados_nac_terceiro;
    ELSIF (pn_da_lin_id IS NOT null) THEN
      OPEN  cur_dcl_admissao;
      FETCH cur_dcl_admissao INTO /*vn_export_id
                                , vn_export_site_id
                                , vn_da_urfe_id
                                , vn_da_pais_proc_id
                                , vn_da_via_transporte_id
                                , vc_da_multimodal
                                , vn_local_cvenda_id*/
                                  vn_moeda_id
                                , vn_da_moeda_frete_id
                                , vn_da_moeda_seguro_id
                                , vc_material_usado
                                , vc_bem_encomenda
                                , vc_nr_dcl_admissao;
                                /*, vn_incoterm_id
                                , vc_aplicacao;*/
      vb_achouDA := cur_dcl_admissao%FOUND;
      CLOSE cur_dcl_admissao;

      IF (not vb_achouDA) THEN
        raise_application_error(-20000, 'Declaração de admissão não encontrada.' );
      END IF;
    END IF; -- IF (pn_da_lin_id IS NOT null) THEN

    COMMIT;
  END prc_busca_da;

BEGIN

  DELETE FROM imp_tmp_destaque_linhas;

  -- Fundamento legal da Linha
  vn_fundamento_legal_id := pn_fundamento_legal_id;

  --tp_classificacao
  vc_tp_classificacao := pc_tp_classificacao;

  --pn_class_fiscal_id
  vn_class_fiscal_id := pn_class_fiscal_id;

  --pn_regtrib_ii_id
  vn_regtrib_ii_id := pn_regtrib_ii_id;

  vc_tp_declaracao := cmx_pkg_tabelas.codigo(pn_tp_declaracao_id);

  OPEN  cur_invoice;
  FETCH cur_invoice into vn_incoterm_id
                       , vn_export_id
                       , vn_export_site_id
                       , vn_termo_id
                       , vn_moeda_invoice_id
                       , vn_local_cvenda_id
                       , vn_repres_id
                       , vn_repres_site_id
                       , vn_repres_banco_agencia_id
                       , vn_repres_pc_comissao
                       , vc_material_usado
                       , vc_bem_encomenda
                       , vc_flag_vr_remeter
                       , vn_utilizacao_id
                       , vn_invoice_id
                       , vc_aplicacao
                       , vc_mat_usado_marca
                       , vc_mat_usado_n_serie
                       , vc_mat_usado_modelo
                       , vc_mat_usado_ano
                       , vn_mat_usado_enq_id
                       , vn_mat_usado_oper_id;
  CLOSE cur_invoice;

  OPEN  cur_embarque_id;
  FETCH cur_embarque_id INTO vn_embarque_id, vc_fins_cambiais;
  CLOSE cur_embarque_id;

  OPEN  cur_verifica_dtr (vn_embarque_id);
  FETCH cur_verifica_dtr INTO vn_dtr_numero;
  vb_achou_dtr := cur_verifica_dtr%FOUND;
  CLOSE cur_verifica_dtr;

  IF (NOT vb_achou_dtr) THEN
    prc_busca_da(vn_embarque_id);
  END IF; -- IF NOT vb_achou_dtr THEN

  OPEN  cur_tipo_fornec (vn_export_id, vn_export_site_id);
  FETCH cur_tipo_fornec INTO vc_vinc_imp_exp;
  CLOSE cur_tipo_fornec;

  -- Nos casos de nacionalização com invoice, dar-se-á preferência à moeda da
  -- invoice e não à moeda da admissão
  IF (vn_moeda_invoice_id IS NOT null) THEN
    vn_moeda_id := vn_moeda_invoice_id;
  END IF;

  IF (pn_licenca_id IS null) THEN
    vc_numero_rof           := null;
    vn_inst_financeira_id   := null;
    OPEN  cur_rof (vn_invoice_id);
    FETCH cur_rof INTO vc_numero_rof, vn_inst_financeira_id;
    CLOSE cur_rof;

    IF vc_numero_rof IS NOT null THEN
      vn_cobertura_cambial       := 3;
      vn_mde_pgto_id             := null;
      vn_motivo_sem_cobertura_id := null;
      vc_com_contrato            := 'N';
    ELSE
      OPEN  cur_termo_pgto (vn_termo_id);
      FETCH cur_termo_pgto INTO vn_cobertura_cambial
                              , vn_mde_pgto_id
                              , vn_motivo_sem_cobertura_id
                              , vc_com_contrato;
      CLOSE cur_termo_pgto;

      IF ( nvl ( vn_cobertura_cambial, 1) <> 4 ) THEN
        vn_nr_parcelas  := 0;
        vb_primeira_vez := TRUE;

        FOR lin IN cur_termo_pgto_lin (vn_termo_id) LOOP
          vn_nr_parcelas    := vn_nr_parcelas + 1;
          vn_ultima_parcela := lin.dias;
          IF (vb_primeira_vez) THEN
            vn_primeira_parcela := lin.dias;
            vb_primeira_vez     := FALSE;
          END IF;
        END LOOP;

        IF ((vn_ultima_parcela/vn_nr_parcelas) = vn_primeira_parcela) THEN
          vc_parcelas_fixas := 'S';
          vn_nr_periodos    := vn_primeira_parcela;
          vc_tp_periodos    := '1';
        ELSE
          vc_parcelas_fixas := 'N';
        END IF; -- IF ((vn_ultima_parcela/vn_nr_parcelas) = vn_primeira_parcela) THEN

      ELSE -- IF ( nvl ( vn_cobertura_cambial, 1) <> 4 ) THEN

        vn_cobertura_cambial       := 4;
        vn_mde_pgto_id             := null;
        vn_nr_periodos             := null;
        vc_tp_periodos             := '1';
        vn_nr_parcelas             := null;
        vc_parcelas_fixas          := 'S';
        vc_com_contrato            := 'N';

      END IF; -- IF ( nvl ( vn_cobertura_cambial, 1) <> 4 ) THEN
    END IF; -- vc_numero_rof

    IF (Nvl(pc_dsi,'N') = 'N') THEN
      IF (vc_tp_declaracao = '05') THEN      -- Adm. Temporaria
        IF (vn_fundamento_legal_id IS null) THEN
          vn_fundamento_legal_id := cmx_pkg_tabelas.tabela_id ('111', '31');
        END IF;

      ELSIF (vc_tp_declaracao = '04') THEN   -- Adm. Entreposto Industrial
        IF (vn_fundamento_legal_id IS null) THEN
          vn_fundamento_legal_id     := cmx_pkg_tabelas.tabela_id ('111', '74'); -- Automotivo
        END IF;

      ELSIF (vc_tp_declaracao = '10') THEN   -- Admissao em DEA
        /*
        Delivery 98857 - Esse tratamento foi transferido para a procedure imp_prc_gerar_declaracao
        IF (vn_fundamento_legal_id IS null) THEN
          vn_fundamento_legal_id := cmx_pkg_tabelas.tabela_id ('111', '58');
        END IF;
        */

        vn_cobertura_cambial       := 4;
        vn_motivo_sem_cobertura_id := cmx_pkg_tabelas.tabela_id( '123','52') ; -- Default siscomex

      ELSIF (vc_tp_declaracao = '16') THEN   -- Nacionalização Recof
        vn_motivo_sem_cobertura_id := cmx_pkg_tabelas.tabela_id( '123','51') ;
        vn_cobertura_cambial       := 4;

      ELSIF (vc_tp_declaracao = '17') AND (vc_fins_cambiais = 'S') THEN   -- Nacionalização DE/DAF para fins cambiais
        IF (vn_fundamento_legal_id IS null) THEN
          vn_fundamento_legal_id := cmx_pkg_tabelas.tabela_id ('111', '77');
        END IF;

      ELSIF (pn_rd_id is not null) THEN
        IF (vn_fundamento_legal_id IS null) THEN
          vn_fundamento_legal_id := cmx_pkg_tabelas.tabela_id ('111', '16');
        END IF;

      END IF; -- IF (vc_tp_declaracao = '05') THEN
    ELSE
      OPEN  cur_verifica_item(pn_invoice_lin_id);
      FETCH cur_verifica_item INTO vn_class_fiscal_temp;
      vb_achou := cur_verifica_item%FOUND;
      CLOSE cur_verifica_item;

      IF (vb_achou) THEN
        vc_tp_classificacao := '2';
        /*Delivery 97893
          Se na fatura estiver preenchido o TSP, ao gerar a DSI alterar o regime de tributação do II para TRIBUTAÇÃO SIMPLICADA ou IMUNIDADE*/
        --vn_regtrib_ii_id := cmx_pkg_tabelas.tabela_id( '104', '1');

        OPEN cur_verifica_regtrib_ii_tsp;
        FETCH cur_verifica_regtrib_ii_tsp INTO vn_regtrib_ii_id;
        vb_achou_regtrib_ii_tsp := cur_verifica_regtrib_ii_tsp%FOUND;
        CLOSE cur_verifica_regtrib_ii_tsp;

        IF (NOT vb_achou_regtrib_ii_tsp) THEN
          raise_application_error(-20000, 'Para o item com classificação TSP somente são permitidos os regimes de tributação "Simplificada" (7) ou "Imunidade" (2). '||
                                          'Estes códigos não foram encontrados no campo 2 da tabela do sistema nº. 107 (TABELA DE REGRA DE DSI POR NATUREZA DE OPERAÇÃO - SCX) '||
                                          'para a natureza de operação escolhida na DSI. '||
                                          'Cadastrar um dos códigos de regime de tributação na tabela do sistema nº. 107 ou escolher outra natureza de operação que possua '||
                                          'este cadastro e gerar a DSI.');
        END IF;

        vn_class_fiscal_id := vn_class_fiscal_temp;
      END IF;

    END IF;

    vn_acordo_aladi_id := pn_acordo_aladi_id;
    IF (pn_cert_origem_mercosul_id IS NOT null) THEN
      vn_tp_acordo := 2;
    END IF;

    vn_cert_origem_mercosul_id := pn_cert_origem_mercosul_id;
  ELSE
    prc_busca_licenca;
  END IF; -- IF (pn_licenca_id IS null) THEN

  ------
  -- Devemos tratar a NCM, nos casos de DSI
  ------
  IF vc_tp_classificacao = '1' THEN
    OPEN  cur_tab_ncm;
    FETCH cur_tab_ncm INTO vn_aliq_ii_dev
                         , vn_aliq_ipi_dev
                         , vn_aliq_ii_mercosul
                         , vn_aliq_pis_dev
                         , vn_aliq_cofins_dev;
    CLOSE cur_tab_ncm;
  ELSE
    -----
    -- Quando TSP,  aliquota de IPI = 0
    -------
    OPEN  cur_aliq_trib_simp(vn_class_fiscal_id);
    FETCH cur_aliq_trib_simp INTO vn_aliq_ii_dev;
    CLOSE cur_aliq_trib_simp;

    vn_aliq_ipi_dev := 0;
  END IF;

  --
  -- Como o ato legal, orgao emissor, no. do ato e ano do ato sao
  -- quebras de adicao, devemos popular os campos com o conteudo
  -- do ex, para nao ocasionarmos quebra de adicao indevida. Nos
  -- casos onde a excecao fiscal de IPI tinha ex-tarifario, a funcao
  -- estava gerando uma adicao por linha de dcl, ja que comparava os
  -- dados do ex trazidos para as variaveis abaixo (e gravadas nas
  -- adicoes) com os parametros da funcao que estavam nulos.
  --
  IF (pn_ex_ipi_id IS NOT null) THEN
    OPEN  cur_ex_tarifario (4, pn_ex_ipi_id);
    FETCH cur_ex_tarifario INTO vcur_ex4;
    CLOSE cur_ex_tarifario;

    vn_aliq_ipi_dev := vcur_ex4.aliquota;
  ELSE
    vcur_ex4.ato_legal_id     := pn_ato_legal_id ;
    vcur_ex4.orgao_emissor_id := pn_orgao_emissor_id;
    vcur_ex4.nr_ato_legal     := pn_nr_ato_legal ;
    vcur_ex4.ano_ato_legal    := pn_ano_ato_legal;
  END IF;

  --
  -- Como o ato legal, orgao emissor, no. do ato e ano do ato sao
  -- quebras de adicao, devemos popular os campos com o conteudo
  -- do ex, para nao ocasionarmos quebra de adicao indevida. Nos
  -- casos onde a excecao fiscal de II tinha ex-tarifario, a funcao
  -- estava gerando uma adicao por linha de dcl, ja que comparava os
  -- dados do ex trazidos para as variaveis abaixo (e gravadas nas
  -- adicoes) com os parametros da funcao que estavam nulos.
  --
  IF (pn_ex_prac_id IS NOT null) THEN
    OPEN  cur_ex_tarifario (5, pn_ex_prac_id);
    FETCH cur_ex_tarifario INTO vcur_ex5;
    CLOSE cur_ex_tarifario;

    vn_aliq_ii_dev := vcur_ex5.aliquota;
  ELSE
    vcur_ex5.ato_legal_id     := pn_ato_legal_acordo_id ;
    vcur_ex5.orgao_emissor_id := pn_orgao_emissor_acordo_id;
    vcur_ex5.nr_ato_legal     := pn_nr_ato_legal_acordo ;
    vcur_ex5.ano_ato_legal    := pn_ano_ato_legal_acordo;
  END IF;

  IF (pn_ex_ncm_id IS NOT null) THEN
    OPEN  cur_ex_tarifario (1, pn_ex_ncm_id);
    FETCH cur_ex_tarifario INTO vcur_ex1;
    CLOSE cur_ex_tarifario;

    -- Caso o NCM tenha Exceção Fiscal de Regime "Redução" para o Imposto de
    -- Importação (II), considerando a Ex-tarifário cadastrado utilizar
    -- alíquota integral informada no cadastro da NCM.
    IF (cmx_pkg_tabelas.codigo (vn_regtrib_ii_id) <> '4') THEN -- II redução
      vn_aliq_ii_dev := vcur_ex1.aliquota;
    END IF;
  ELSE
    vcur_ex1.ato_legal_id     := pn_ato_legal_ncm_id ;
    vcur_ex1.orgao_emissor_id := pn_orgao_emissor_ncm_id;
    vcur_ex1.nr_ato_legal     := pn_nr_ato_legal_ncm ;
    vcur_ex1.ano_ato_legal    := pn_ano_ato_legal_ncm;
  END IF;

  IF (pn_ex_nbm_id IS NOT null) THEN
    OPEN  cur_ex_tarifario (2, pn_ex_nbm_id);
    FETCH cur_ex_tarifario INTO vcur_ex2;
    CLOSE cur_ex_tarifario;

    vn_aliq_ipi_dev := vcur_ex2.aliquota;
  ELSE
    vcur_ex2.ato_legal_id     := pn_ato_legal_nbm_id ;
    vcur_ex2.orgao_emissor_id := pn_orgao_emissor_nbm_id;
    vcur_ex2.nr_ato_legal     := pn_nr_ato_legal_nbm ;
    vcur_ex2.ano_ato_legal    := pn_ano_ato_legal_nbm;
  END IF;

  IF (pn_ex_naladi_id IS NOT null) THEN
    OPEN  cur_ex_tarifario (3, pn_ex_naladi_id);
    FETCH cur_ex_tarifario INTO vcur_ex3;
    CLOSE cur_ex_tarifario;

    vn_aliq_ii_dev := vcur_ex3.aliquota;
  ELSE
    vcur_ex3.ato_legal_id     := pn_ato_legal_naladi_id ;
    vcur_ex3.orgao_emissor_id := pn_orgao_emissor_naladi_id;
    vcur_ex3.nr_ato_legal     := pn_nr_ato_legal_naladi ;
    vcur_ex3.ano_ato_legal    := pn_ano_ato_legal_naladi;
  END IF;

  /* Iniciando a montagem dos NVEs da LINHA que está sendo gravada agora */
  vc_nve_item := null;
  FOR nve IN cur_itens_nve LOOP
    vc_nve_item :=    vc_nve_item
                   || rtrim(ltrim(to_char( nve.abrangencia, '9' )))
                   || nve.atributo
                   || rtrim(ltrim(to_char(nve.especificacao,'9999'))) ;
  END LOOP;

  /* Iniciando a montagem dos valores de destaque da LINHA que está sendo gravada agora */
/*
  IF (pn_ex_ncm_id    IS NOT null) OR (pn_ex_nbm_id  IS NOT null) OR
     (pn_ex_naladi_id IS NOT null) OR (pn_ex_ipi_id  IS NOT null) OR
     (pn_ex_prac_id   IS NOT null) OR (pn_ex_antd_id IS NOT null)
  THEN
    INSERT INTO imp_tmp_destaque_linhas (destaque)
    VALUES (102);
  END IF;
*/

  OPEN  cur_destaque_item;
  FETCH cur_destaque_item INTO vc_destaque_extensao_item;
  CLOSE cur_destaque_item;

  IF (vc_destaque_extensao_item IS NOT null) THEN
    INSERT INTO imp_tmp_destaque_linhas (destaque)
    VALUES (vc_destaque_extensao_item);
  ELSE
    FOR i IN cur_destaque_ncm LOOP
      INSERT INTO imp_tmp_destaque_linhas (destaque)
      VALUES (i.auxiliar2);
    END LOOP;
  END IF; -- IF (vc_destaque_extensao_item IS NOT null) THEN

  vc_destaque_item := null;
  FOR dstq IN cur_destaque_a_ser_inserido LOOP
    vc_destaque_item := vc_destaque_item || dstq.destaque;
  END LOOP;

  IF (pn_pais_origem_id IS null) THEN
    IF (pn_ausencia_fabric = 1) THEN
      vn_pais_origem_id := imp_pkg_entidades.pais_id (vn_export_site_id);
    ELSIF (pn_ausencia_fabric = 2) THEN
      vn_pais_origem_id := imp_pkg_fabricantes.pais_id (pn_fabric_site_id);
    END IF;
  ELSE
    vn_pais_origem_id := pn_pais_origem_id;
  END IF;

  OPEN  cur_pais_mercosul (cmx_pkg_tabelas.codigo (vn_pais_origem_id));
  FETCH cur_pais_mercosul INTO vn_dummy;
  vb_pais_mercosul := cur_pais_mercosul%FOUND;
  CLOSE cur_pais_mercosul;

  IF (vb_pais_mercosul) AND (pn_naladi_sh_id IS null) THEN
    OPEN  cur_naladi_sh;
    FETCH cur_naladi_sh INTO vn_naladi_sh_id;
    CLOSE cur_naladi_sh;
  ELSE
    vn_naladi_sh_id := pn_naladi_sh_id;
  END IF;

  IF Nvl(pc_dsi,'N') = 'N' THEN
    -- Busca uma adição semelhante a linha atual. O FOR serve apenas para que
    -- possamos ordenar as adições e trazer a que tem menos linhas primeiro.
    -- Após ler a primeira adição o comando FOR é encerrado e as demais nem
    -- serão processadas.

    FOR i IN (SELECT /*+ INDEX(adi imp_decl_adi_decl_id_adi_idx) OPT_PARAM('_B_TREE_BITMAP_PLANS','FALSE') */
                     qtde_linhas
                   , adi.declaracao_adi_id
                   , NVL(da_moeda_frete_id,0) da_moeda_frete_id
                   , NVL(da_moeda_seguro_id,0) da_moeda_seguro_id
                   , adi.beneficio_mercante_id
                   , adi.vlr_frete
                   , licenca_id
                FROM imp_declaracoes_adi adi
               WHERE
                (
                  (pn_licenca_id IS NOT null) AND (adi.licenca_id = pn_licenca_id)
                 AND adi.declaracao_id                   = pn_declaracao_id
                 AND nvl (adi.beneficio_mercante_id, 0 ) = nvl (pn_benef_id            , 0)
                 AND nvl (da_moeda_frete_id        , 0 ) = nvl (vn_da_moeda_frete_id   , 0)
                 AND nvl (da_moeda_seguro_id       , 0 ) = nvl (vn_da_moeda_seguro_id  , 0)
                 AND nvl (da_urfe_id               , 0 ) = nvl (vn_da_urfe_id          , 0)
                 AND nvl (da_via_transporte_id     , 0 ) = nvl (vn_da_via_transporte_id, 0)
                 AND nvl (da_pais_proc_id          , 0 ) = nvl (vn_da_pais_proc_id     , 0)
                 AND nvl (da_multimodal            ,'N') = nvl (vc_da_multimodal       ,'N')
                 AND nvl(adi.export_id             ,0  ) = nvl(vn_export_id       ,0)
                 AND nvl(adi.export_site_id        ,0  ) = nvl(vn_export_site_id  ,0)
                 AND nvl(adi.incoterm_id           ,0  ) = nvl(vn_incoterm_id     ,0)
                 AND nvl(adi.moeda_id              ,0  ) = nvl(vn_moeda_id        ,0)
                 AND nvl(adi.material_usado        ,'*') = nvl(vc_material_usado  ,'*')
                 AND nvl(adi.bem_encomenda         ,'*') = nvl(vc_bem_encomenda   ,'*')
                 AND Nvl(adi.aplicacao, 'X')             = Nvl(vc_aplicacao, 'X')
                 AND Nvl(adi.mat_usado_enq_id , 0)      = Nvl(vn_mat_usado_enq_id  , 0)
                 AND Nvl(adi.mat_usado_oper_id, 0)      = Nvl(vn_mat_usado_oper_id , 0)
                 AND Nvl(adi.mat_usado_marca  , 0)      = Nvl(vc_mat_usado_marca  , 0)
                 AND Nvl(adi.mat_usado_modelo , 0)      = Nvl(vc_mat_usado_modelo , 0)
                 AND Nvl(adi.mat_usado_n_serie, 0)      = Nvl(vc_mat_usado_n_serie, 0)
                 AND Nvl(adi.mat_usado_ano    , 0)      = Nvl(vc_mat_usado_ano    , 0)
                 AND nvl (adi.local_cvenda_id     , 0)  = nvl (vn_local_cvenda_id     , 0)
                )
                     OR
                (
                     (pn_licenca_id IS null) AND (adi.licenca_id IS null)
                 AND adi.declaracao_id                   = pn_declaracao_id
                 AND nvl (adi.beneficio_mercante_id, 0 ) = nvl (pn_benef_id            , 0)
                 AND nvl(adi.tp_classificacao      ,'*') = nvl(pc_tp_classificacao,'*')
                 AND nvl(adi.class_fiscal_id       ,0)   = nvl(pn_class_fiscal_id ,0  )
                 AND nvl(adi.export_id             ,0)   = nvl(vn_export_id       ,0  )
                 AND nvl(adi.export_site_id        ,0)   = nvl(vn_export_site_id  ,0  )
                 AND nvl(adi.incoterm_id           ,0)   = nvl(vn_incoterm_id     ,0  )
                 AND nvl(adi.moeda_id              ,0)   = nvl(vn_moeda_id        ,0  )
                 AND nvl(adi.regtrib_ii_id         ,0)   = nvl(pn_regtrib_ii_id   ,0  )
                 AND (
                       (pn_regtrib_ipi_id        IS null)
                       OR
                       (adi.regtrib_ipi_id            = pn_regtrib_ipi_id)
                     )
                 AND nvl( adi.regtrib_icms_id,0)                             = nvl( pn_regtrib_icms_id ,0)
                 AND nvl (adi.aliq_icms                               ,  0 ) = nvl (pn_aliq_icms                   ,  0 )
                 AND nvl (adi.aliq_icms_red                           ,  0 ) = nvl (pn_aliq_icms_red               ,  0 )
                 AND nvl (adi.perc_red_icms                           ,  0 ) = nvl (pn_perc_red_icms               ,  0 )
                 AND nvl (adi.aliq_icms_fecp                          ,  0 ) = nvl (pn_aliq_icms_fecp              ,  0 )
                 AND nvl (adi.fundamento_legal_icms_id                ,  0 ) = nvl (pn_fund_legal_icms_id          ,  0 )
                 AND nvl (adi.regtrib_pis_cofins_id                   ,  0 ) = nvl (pn_regtrib_pis_cofins_id       ,  0 )
                 AND nvl (adi.flegal_reducao_pis_cofins_id            ,  0 ) = nvl (pn_flegal_red_pis_cofins_id    ,  0 )
                 AND nvl (adi.perc_reducao_base_pis_cofins            ,  0 ) = nvl (pn_perc_red_base_pis_cofins    ,  0 )
                 AND nvl (adi.aliq_pis_dev   , nvl (vn_aliq_pis_dev   , 0) ) = nvl (pn_aliq_pis                    ,  nvl (vn_aliq_pis_dev, 0))
                 AND nvl (adi.aliq_pis_reduzida                       ,  0 ) = nvl (pn_aliq_pis_reduzida           ,  0 )
                 AND nvl (adi.aliq_cofins_dev, nvl (vn_aliq_cofins_dev, 0) ) = nvl (pn_aliq_cofins                 ,  nvl (vn_aliq_cofins_dev, 0))
                 AND nvl (adi.aliq_cofins_reduzida                    ,  0 ) = nvl (pn_aliq_cofins_reduzida        ,  0 )
                 AND nvl (adi.fundamento_legal_pis_cofins_id          ,  0 ) = nvl (pn_fund_legal_pis_cofins_id    ,  0 )
                 AND nvl (adi.regime_especial_icms                    , 'N') = nvl (pc_regime_especial_icms        , 'N')
                 AND nvl (adi.aliq_pis_especifica                     , 0  ) = nvl (pn_aliq_pis_especifica         ,  0 )
                 AND nvl (adi.aliq_cofins_especifica                  , 0  ) = nvl (pn_aliq_cofins_especifica      ,  0 )
                 AND nvl (adi.un_medida_aliq_especifica_pc            , 'X') = nvl (pc_um_aliq_especifica_pc       , 'X')
                 AND nvl (adi.material_usado ,'*')                           = nvl(vc_material_usado,'*')
                 AND nvl (adi.bem_encomenda  ,'*')                           = nvl(vc_bem_encomenda ,'*')
                 AND Nvl (adi.aplicacao, 'X')            = Nvl(vc_aplicacao, 'X')
                 AND Nvl(adi.mat_usado_enq_id , 0)      = Nvl(vn_mat_usado_enq_id  , 0)
                 AND Nvl(adi.mat_usado_oper_id, 0)      = Nvl(vn_mat_usado_oper_id , 0)
                 AND Nvl(adi.mat_usado_marca  , 0)      = Nvl(vc_mat_usado_marca  , 0)
                 AND Nvl(adi.mat_usado_modelo , 0)      = Nvl(vc_mat_usado_modelo , 0)
                 AND Nvl(adi.mat_usado_n_serie, 0)      = Nvl(vc_mat_usado_n_serie, 0)
                 AND Nvl(adi.mat_usado_ano    , 0)      = Nvl(vc_mat_usado_ano    , 0)
                 AND nvl (adi.repres_id                               ,  0 ) = nvl (vn_repres_id                   ,  0 )
                 AND nvl (adi.repres_site_id                          ,  0 ) = nvl (vn_repres_site_id              ,  0 )
                 AND nvl (adi.repres_banco_agencia_id                 ,  0 ) = nvl (vn_repres_banco_agencia_id     ,  0 )
                 AND nvl (adi.rd_id                                   ,  0 ) = nvl (pn_rd_id                       ,  0 )
                 AND (
                      ((pn_ausencia_fabric = 1) AND (adi.ausencia_fabric = 1))
                      OR
                      (pn_ausencia_fabric = 2                 and
                       adi.fabric_id          = pn_fabric_id      and
                       adi.fabric_site_id     = pn_fabric_site_id
                      )
                      OR
                      (pn_ausencia_fabric = 3                 and
                       adi.pais_origem_id     = pn_pais_origem_id
                      )
                     )
                 AND nvl (adi.naladi_sh_id                    , 0 )       = nvl (vn_naladi_sh_id               , 0 )
                 AND nvl (adi.naladi_ncca_id                  , 0 )       = nvl (pn_naladi_ncca_id             , 0 )
                 AND nvl (adi.cobertura_cambial               , 0 )       = nvl (vn_cobertura_cambial          , 0 )
                 AND nvl (adi.mde_pgto_id                     , 0 )       = nvl (vn_mde_pgto_id                , 0 )
                 AND nvl (adi.motivo_sem_cobertura_id         , 0 )       = nvl (vn_motivo_sem_cobertura_id    , 0 )
                 AND nvl (adi.nr_rof                         , 'X')       = nvl (vc_numero_rof                 , 'X')
                 AND nvl (adi.inst_financiadora_id            , 0 )       = nvl (vn_inst_financeira_id         , 0 )
                 AND nvl (adi.nr_periodos                     , 0 )       = nvl (vn_nr_periodos                , 0 )
                 AND nvl (adi.tp_periodos                     ,'0')       = nvl (vc_tp_periodos                ,'0')
                 AND nvl (adi.nr_parcelas                     , 0 )       = nvl (vn_nr_parcelas                , 0 )
                 AND nvl (adi.da_moeda_frete_id               , 0 )       = nvl (vn_da_moeda_frete_id          , 0 )
                 AND nvl (adi.da_moeda_seguro_id              , 0 )       = nvl (vn_da_moeda_seguro_id         , 0 )
                 AND nvl (adi.da_urfe_id                      , 0 )       = nvl (vn_da_urfe_id                 , 0 )
                 AND nvl (adi.da_via_transporte_id            , 0 )       = nvl (vn_da_via_transporte_id       , 0 )
                 AND nvl (adi.da_pais_proc_id                 , 0 )       = nvl (vn_da_pais_proc_id            , 0 )
                 AND nvl (adi.da_multimodal                   ,'N')       = nvl (vc_da_multimodal              ,'N')
                 AND nvl (adi.local_cvenda_id                 , 0 )       = nvl (vn_local_cvenda_id            , 0 )
                 AND nvl (adi.vida_util                       , 0 )       = nvl (pn_vida_util                  , 0 )
                 AND nvl (adi.ex_ncm_id                       , 0 )       = nvl (pn_ex_ncm_id                  , 0 )
                 AND nvl (adi.ex_nbm_id                       , 0 )       = nvl (pn_ex_nbm_id                  , 0 )
                 AND nvl (adi.ex_naladi_id                    , 0 )       = nvl (pn_ex_naladi_id               , 0 )
                 AND nvl (adi.acordo_aladi_id                 , 0 )       = nvl (vn_acordo_aladi_id            , 0 )
                 AND nvl (adi.ex_ipi_id                       , 0 )       = nvl (pn_ex_ipi_id                  , 0 )
                 AND nvl (adi.ex_prac_id                      , 0 )       = nvl (pn_ex_prac_id                 , 0 )
                 AND nvl (adi.ex_antd_id                      , 0 )       = nvl (pn_ex_antd_id                 , 0 )
                 AND nvl (adi.fundamento_legal_id             , 0 )       = nvl (vn_fundamento_legal_id        , 0 )
                 AND nvl (adi.ato_legal_exipi_id              , 0 )       = nvl (vcur_ex4.ato_legal_id         , 0 )
                 AND nvl (adi.orgao_emissor_exipi_id          , 0 )       = nvl (vcur_ex4.orgao_emissor_id     , 0 )
                 AND nvl (adi.nr_ato_legal_exipi              , 0 )       = nvl (vcur_ex4.nr_ato_legal         , 0 )
                 AND nvl (adi.ano_ato_legal_exipi             , 0 )       = nvl (vcur_ex4.ano_ato_legal        , 0 )
                 AND nvl (adi.aliq_antdump                    , 0 )       = nvl (pn_aliq_antid_ad_valorem      , 0 )
                 AND nvl (adi.vr_aliq_esp_antdump             , 0 )       = nvl (pn_aliq_antid_especifica      , 0 )
                 AND nvl (adi.um_aliq_esp_antdump_id          , 0 )       = nvl (pn_um_aliq_especifica_antid_id, 0 )
                 AND nvl (adi.somatoria_quantidade            ,'X')       = nvl (pc_somatoria_quantidade       ,'X')
                 AND nvl (adi.cert_origem_mercosul_id         , 0 )       = nvl (vn_cert_origem_mercosul_id    , 0 )
                 AND nvl (adi.ato_legal_exncm_id              , 0 )       = nvl (vcur_ex1.ato_legal_id         , 0 )
                 AND nvl (adi.orgao_emissor_exncm_id          , 0 )       = nvl (vcur_ex1.orgao_emissor_id     , 0 )
                 AND nvl (adi.nr_ato_legal_exncm              , 0 )       = nvl (vcur_ex1.nr_ato_legal         , 0 )
                 AND nvl (adi.ano_ato_legal_exncm             , 0 )       = nvl (vcur_ex1.ano_ato_legal        , 0 )
                 AND nvl (adi.ato_legal_exnbm_id              , 0 )       = nvl (vcur_ex2.ato_legal_id         , 0 )
                 AND nvl (adi.orgao_emissor_exnbm_id          , 0 )       = nvl (vcur_ex2.orgao_emissor_id     , 0 )
                 AND nvl (adi.nr_ato_legal_exnbm              , 0 )       = nvl (vcur_ex2.nr_ato_legal         , 0 )
                 AND nvl (adi.ano_ato_legal_exnbm             , 0 )       = nvl (vcur_ex2.ano_ato_legal        , 0 )
                 AND nvl (adi.ato_legal_exnaladi_id           , 0 )       = nvl (vcur_ex3.ato_legal_id         , 0 )
                 AND nvl (adi.orgao_emissor_exnaladi_id       , 0 )       = nvl (vcur_ex3.orgao_emissor_id     , 0 )
                 AND nvl (adi.nr_ato_legal_exnaladi           , 0 )       = nvl (vcur_ex3.nr_ato_legal         , 0 )
                 AND nvl (adi.ano_ato_legal_exnaladi          , 0 )       = nvl (vcur_ex3.ano_ato_legal        , 0 )
                 AND nvl (adi.ato_legal_exprac_id             , 0 )       = nvl (vcur_ex5.ato_legal_id         , 0 )
                 AND nvl (adi.orgao_emissor_exprac_id         , 0 )       = nvl (vcur_ex5.orgao_emissor_id     , 0 )
                 AND nvl (adi.nr_ato_legal_exprac             , 0 )       = nvl (vcur_ex5.nr_ato_legal         , 0 )
                 AND nvl (adi.ano_ato_legal_exprac            , 0 )       = nvl (vcur_ex5.ano_ato_legal        , 0 )
                 AND nvl (adi.aliq_mva                        , 0 )       = nvl (pn_aliquota_mva               , 0 ) -- *** ICMS ST
                 AND nvl (adi.pro_emprego                     ,'N')       = nvl (pc_pro_emprego                ,'N')
                 AND nvl (adi.pro_empr_aliq_base              , 0 )       = nvl (pn_aliq_base_pro_emprego      , 0 )
                 AND nvl (adi.pro_empr_aliq_antecip           , 0 )       = nvl (pn_aliq_antecip_pro_emprego   , 0 )
                 AND nvl (adi.beneficio_pr                    ,'N')       = nvl (pc_beneficio_pr               ,'N')
                 AND nvl (adi.pr_aliq_base                    , 0 )       = nvl (pn_aliq_base_pr               , 0 )
                 AND nvl (adi.pr_perc_diferido                , 0 )       = nvl (pn_perc_diferido_pr           , 0 )
                 AND nvl (adi.pr_perc_vr_devido               , 0 )       = nvl (pn_pr_perc_vr_devido          , 0 )
                 AND nvl (adi.pr_perc_minimo_base             , 0 )       = nvl (pn_pr_perc_minimo_base        , 0 )
                 AND nvl (adi.pr_perc_minimo_suspenso         , 0 )       = nvl (pn_pr_perc_minimo_suspenso    , 0 )
                 AND nvl (adi.ins_estadual_id                 , 0 )       = nvl (pn_ins_estadual_id            , 0 )
                 AND imp_fnc_busca_nve      ('DI', adi.declaracao_adi_id) = nvl (vc_nve_item                   ,'*')
                 AND imp_fnc_busca_destaque ('DI', adi.declaracao_adi_id) = nvl (vc_destaque_item              ,'*')
                 AND Nvl (adi.beneficio_suspensao              ,'N')      = Nvl (pc_beneficio_suspensao        ,'N')
                 AND Nvl (adi.perc_beneficio_suspensao         , 0 )      = Nvl (pn_perc_beneficio_suspensao   , 0 )
                )
            ORDER BY qtde_linhas)
    LOOP
      vn_qtde_linhas_adi   := i.qtde_linhas;
      vn_declaracao_adi_id := i.declaracao_adi_id;
      vn_benef_id          := i.beneficio_mercante_id; /* Tratamento para quebra de benefício */
      EXIT;
    END LOOP;

  ELSE -- IF pc_dsi = 'N' THEN
    vn_qtde_linhas_adi := 0;
  END IF; -- IF pc_dsi = 'N' THEN

  ----------------------------------------------------------------------
  --- Busca a Qtd. de Itens da Adicao, se a quantidade for < 79 e > 0,
  --- quer dizer que ja existe adicao para esse NCM e a qtd. de itens
  --- ainda não superou 78 itens, portanto devemos gravar mais 1 na
  --- qtd. itens na adicao. Se a qtd. for = 79 ou 0, quer dizer que
  --- ou os itens chegaram a 78 ou não existe adicao, portanto deve-se
  --- criar uma nova adicao.
  ----------------------------------------------------------------------
  IF ((pn_declaracao_adi_id IS NOT null) AND (nvl(vn_declaracao_adi_id,0) <> pn_declaracao_adi_id)) THEN
    BEGIN
      OPEN  cur_lock_adi (pn_declaracao_adi_id);
      CLOSE cur_lock_adi;
    EXCEPTION
      WHEN ve_nowait THEN
        raise_application_error(-20000, 'Outro usuário ou outra sessão(janela) está alterando a adição desta linha! A gravação não poderá ser concluída!');
      WHEN OTHERS THEN
        raise_application_error(-20000, sqlerrm);
    END;

    UPDATE imp_declaracoes_adi
       SET qtde_linhas = qtde_linhas - 1
     WHERE declaracao_adi_id = pn_declaracao_adi_id;
  END IF;

  IF ((vn_qtde_linhas_adi < 80) AND (nvl(vn_qtde_linhas_adi,0) > 0) ) THEN
    IF (nvl(vn_declaracao_adi_id,0) <> nvl(pn_declaracao_adi_id,0)) THEN

      /* Tenta dar um lock na tabela antes de altera-la, pois, pode ser que outra estação esteja alterando a
         mesma adição. Se nao fizermos iso, o usuário terá que esperar muito tempo pela outra estação, causando
         a sensação de ambiente travado - Andre 23.12.2002.
      */

      BEGIN
        OPEN  cur_lock_adi (vn_declaracao_adi_id);
        CLOSE cur_lock_adi;
      EXCEPTION
        WHEN ve_nowait THEN
          raise_application_error(-20000, 'Outro usuário ou outra sessão(janela) está alterando a adição desta linha! A gravação não poderá ser concluída!');
        WHEN OTHERS THEN
          raise_application_error(-20000, sqlerrm);
      END;

      UPDATE imp_declaracoes_adi
         SET qtde_linhas                = qtde_linhas + 1
           , qtde_um_aliq_especifica_pc = qtde_um_aliq_especifica_pc + nvl (pn_qtde_um_aliq_especifica_pc, 0)
           , vlr_frete                  = vlr_frete + pn_vlr_frete_afrmm
       WHERE declaracao_adi_id = vn_declaracao_adi_id;
    END IF;

    /* Se houver benefício diferente, é criado uma nova adição */

  ELSIF ((vn_qtde_linhas_adi = 80) OR (nvl(vn_qtde_linhas_adi,0) = 0) ) THEN


    IF (pn_licenca_id IS NOT null) THEN
      prc_busca_licenca;

      vc_tp_periodos    := '1';
      vn_nr_parcelas    := 1;
      vc_parcelas_fixas := 'S';
    END IF;

    SELECT imp_declaracoes_adi_sq1.nextval INTO vn_declaracao_adi_id FROM dual;

    IF (pn_ex_antd_id IS NOT null) THEN
      OPEN  cur_ex_tarifario (6, pn_ex_antd_id);
      FETCH cur_ex_tarifario INTO vcur_ex6;
      CLOSE cur_ex_tarifario;

      vn_aliq_ii_dev := vcur_ex6.aliquota;
    END IF;

    OPEN  cur_perc_acordo;
    FETCH cur_perc_acordo INTO vn_perc_acordo, vn_certificado;
    CLOSE cur_perc_acordo;

    IF (vn_tp_acordo IS NOT null) THEN
      IF (vn_cert_origem_mercosul_id IS NOT null AND vn_certificado = 1) THEN
        vn_perc_acordo := 0;

        OPEN cur_ncm;
        FETCH cur_ncm INTO vn_perc_acordo;
        CLOSE cur_ncm;

        vn_aliq_ii_acordo := vn_perc_acordo;
      ELSE
        vn_aliq_ii_acordo := vn_perc_acordo;
      END IF;

      vn_aliq_ii_red    := null;
    ELSE
      vn_aliq_ii_acordo := null;
      vn_aliq_ii_red    := pn_aliq_ii_red;
    END IF;

    IF (pn_aliq_pis IS NOT null) THEN
      vn_aliq_pis_dev := pn_aliq_pis;
    END IF;

    IF (pn_aliq_cofins IS NOT null) THEN
      vn_aliq_cofins_dev := pn_aliq_cofins;
    END IF;

    /*
    OPEN  cur_aplicacao (vn_utilizacao_id);
    FETCH cur_aplicacao INTO vc_aplicacao;
    CLOSE cur_aplicacao;
    */

    IF (NOT vb_achou_dtr) THEN
      prc_busca_da(vn_embarque_id);
    END IF;

    OPEN  cur_empresa;
    FETCH cur_empresa INTO vn_empresa_id;
    CLOSE cur_empresa;

    OPEN  cur_aliq_dif_icms_pr(vn_empresa_id);
    FETCH cur_aliq_dif_icms_pr INTO vc_arredonda_aliq_dife_icms_pr;
    CLOSE cur_aliq_dif_icms_pr;

    OPEN  cur_verif_tp_conhec;
    FETCH cur_verif_tp_conhec INTO vn_conhec_id;
    CLOSE cur_verif_tp_conhec;

    OPEN  cur_item_com_rcr;
    FETCH cur_item_com_rcr INTO vn_dummy;
    vb_linha_ivc_tem_rcr := cur_item_com_rcr%FOUND;
    CLOSE cur_item_com_rcr;

    IF (vb_linha_ivc_tem_rcr OR (Nvl(pn_vida_util,0) > 0 AND vc_tp_declaracao = '12')) THEN
      vc_admissao_temporaria := 'S';
    ELSE
      vc_admissao_temporaria := 'N';
    END IF;

    INSERT INTO imp_declaracoes_adi
              ( /* 001 */ declaracao_id
              , /* 002 */ declaracao_adi_id
              , /* 003 */ adicao_num
              , /* 004 */ qtde_linhas
              , /* 005 */ export_id
              , /* 006 */ export_site_id
              , /* 007 */ ausencia_fabric
              , /* 008 */ fabric_id
              , /* 009 */ fabric_site_id
              , /* 010 */ pais_origem_id
              , /* 011 */ class_fiscal_id
              , /* 012 */ naladi_sh_id
              , /* 013 */ naladi_ncca_id
              , /* 014 */ rd_id
              , /* 015 */ moeda_id
              , /* 016 */ material_usado
              , /* 017 */ bem_encomenda
              , /* 018 */ aplicacao
              , /* 019 */ vinc_imp_exp
              , /* 020 */ cobertura_cambial
              , /* 021 */ mde_pgto_id
              , /* 022 */ motivo_sem_cobertura_id
              , /* 023 */ inst_financiadora_id
              , /* 024 */ parcelas_fixas
              , /* 025 */ tp_periodos
              , /* 026 */ nr_periodos
              , /* 027 */ nr_parcelas
              , /* 028 */ regtrib_ii_id
              , /* 029 */ aliq_ii_dev
              , /* 030 */ perc_red_ii
              , /* 031 */ aliq_ii_red
              , /* 032 */ aliq_ii_acordo
              , /* 033 */ fundamento_legal_id
              , /* 034 */ metodo_vr_aduaneiro_id
              , /* 035 */ regtrib_ipi_id
              , /* 036 */ tp_classificacao
              , /* 037 */ aliq_ipi_dev
              , /* 038 */ aliq_ipi_red
              , /* 039 */ incoterm_id
              , /* 040 */ licenca_id
              , /* 041 */ repres_id
              , /* 042 */ repres_site_id
              , /* 043 */ repres_pc_comissao
              , /* 044 */ repres_banco_agencia_id
              , /* 045 */ da_urfe_id
              , /* 046 */ da_via_transporte_id
              , /* 047 */ da_pais_proc_id
              , /* 048 */ da_multimodal
              , /* 049 */ local_cvenda_id
              , /* 050 */ vida_util
              , /* 051 */ tp_acordo
              , /* 052 */ acordo_aladi_id
              , /* 053 */ ex_ncm_id
              , /* 054 */ ato_legal_exncm_id
              , /* 055 */ orgao_emissor_exncm_id
              , /* 056 */ nr_ato_legal_exncm
              , /* 057 */ ano_ato_legal_exncm
              , /* 058 */ ex_nbm_id
              , /* 059 */ ato_legal_exnbm_id
              , /* 060 */ orgao_emissor_exnbm_id
              , /* 061 */ nr_ato_legal_exnbm
              , /* 062 */ ano_ato_legal_exnbm
              , /* 063 */ ex_naladi_id
              , /* 064 */ ato_legal_exnaladi_id
              , /* 065 */ orgao_emissor_exnaladi_id
              , /* 066 */ ano_ato_legal_exnaladi
              , /* 067 */ nr_ato_legal_exnaladi
              , /* 068 */ ex_ipi_id
              , /* 069 */ ato_legal_exipi_id
              , /* 070 */ orgao_emissor_exipi_id
              , /* 071 */ nr_ato_legal_exipi
              , /* 072 */ ano_ato_legal_exipi
              , /* 073 */ ex_prac_id
              , /* 074 */ ato_legal_exprac_id
              , /* 075 */ orgao_emissor_exprac_id
              , /* 076 */ nr_ato_legal_exprac
              , /* 077 */ ano_ato_legal_exprac
              , /* 078 */ ex_antd_id
              , /* 079 */ ato_legal_exantd_id
              , /* 080 */ orgao_emissor_exantd_id
              , /* 081 */ nr_ato_legal_exantd
              , /* 082 */ ano_ato_legal_exantd
              , /* 083 */ da_moeda_frete_id
              , /* 084 */ da_moeda_seguro_id
              , /* 085 */ creation_date
              , /* 086 */ created_by
              , /* 087 */ last_update_date
              , /* 088 */ last_updated_by
              , /* 089 */ grupo_acesso_id
              , /* 090 */ regtrib_icms_id
              , /* 091 */ aliq_icms
              , /* 092 */ aliq_icms_red
              , /* 093 */ perc_red_icms
              , /* 094 */ aliq_icms_fecp
              , /* 095 */ fundamento_legal_icms_id
              , /* 096 */ regtrib_pis_cofins_id
              , /* 097 */ flag_reducao_base_pis_cofins
              , /* 098 */ flegal_reducao_pis_cofins_id
              , /* 099 */ perc_reducao_base_pis_cofins
              , /* 100 */ aliq_pis_dev
              , /* 101 */ aliq_pis_reduzida
              , /* 102 */ aliq_cofins_dev
              , /* 103 */ aliq_cofins_reduzida
              , /* 104 */ fundamento_legal_pis_cofins_id
              , /* 105 */ regime_especial_icms
              , /* 106 */ aliq_pis_especifica
              , /* 107 */ aliq_cofins_especifica
              , /* 108 */ un_medida_aliq_especifica_pc
              , /* 109 */ qtde_um_aliq_especifica_pc
              , /* 110 */ aliq_antdump
              , /* 111 */ vr_aliq_esp_antdump
              , /* 112 */ um_aliq_esp_antdump_id
              , /* 113 */ somatoria_quantidade
              , /* 114 */ cert_origem_mercosul_id
              , /* 115 */ motivo_trib_simpl_dsi_id
              , /* 116 */ nr_rof
              , /* 117 */ aliq_mva
              , /* 118 */ pro_emprego
              , /* 119 */ pro_empr_aliq_base
              , /* 120 */ pro_empr_aliq_antecip
              , /* 121 */ beneficio_pr
              , /* 122 */ pr_aliq_base
              , /* 123 */ pr_perc_diferido
              , /* 124 */ ins_estadual_id
              , /* 125 */ pr_perc_vr_devido
              , /* 126 */ pr_perc_minimo_base
              , /* 127 */ pr_perc_minimo_suspenso
              , /* 128 */ beneficio_sp
              , /* 129 */ beneficio_mercante_id
              , /* 130 */ vlr_frete
              , /* 131 */ admissao_temporaria
              , /* 132 */ mat_usado_marca
              , /* 133 */ mat_usado_modelo
              , /* 134 */ mat_usado_n_serie
              , /* 135 */ mat_usado_ano
              , /* 136 */ mat_usado_enq_id
              , /* 137 */ mat_usado_oper_id
              , /* 138 */ arredonda_aliq_diferim_icms_pr
              , /* 139 */ beneficio_suspensao
              , /* 140 */ perc_beneficio_suspensao
              )
        VALUES( /* 001 */ pn_declaracao_id
              , /* 002 */ vn_declaracao_adi_id
              , /* 003 */ 0
              , /* 004 */ 1
              , /* 005 */ vn_export_id
              , /* 006 */ vn_export_site_id
              , /* 007 */ pn_ausencia_fabric
              , /* 008 */ pn_fabric_id
              , /* 009 */ pn_fabric_site_id
              , /* 010 */ pn_pais_origem_id
              , /* 011 */ vn_class_fiscal_id
              , /* 012 */ vn_naladi_sh_id
              , /* 013 */ pn_naladi_ncca_id
              , /* 014 */ pn_rd_id
              , /* 015 */ vn_moeda_id
              , /* 016 */ vc_material_usado
              , /* 017 */ vc_bem_encomenda
              , /* 018 */ vc_aplicacao
              , /* 019 */ nvl (vc_vinc_imp_exp, '1')
              , /* 020 */ vn_cobertura_cambial
              , /* 021 */ vn_mde_pgto_id
              , /* 022 */ vn_motivo_sem_cobertura_id
              , /* 023 */ vn_inst_financeira_id
              , /* 024 */ vc_parcelas_fixas
              , /* 025 */ vc_tp_periodos
              , /* 026 */ vn_nr_periodos
              , /* 027 */ vn_nr_parcelas
              , /* 028 */ vn_regtrib_ii_id
              , /* 029 */ vn_aliq_ii_dev
              , /* 030 */ pn_perc_red_ii
              , /* 031 */ vn_aliq_ii_red
              , /* 032 */ vn_aliq_ii_acordo
              , /* 033 */ vn_fundamento_legal_id
              , /* 034 */ cmx_pkg_tabelas.tabela_id('103','01')
              , /* 035 */ pn_regtrib_ipi_id
              , /* 036 */ vc_tp_classificacao
              , /* 037 */ vn_aliq_ipi_dev
              , /* 038 */ pn_aliq_ipi_red
              , /* 039 */ vn_incoterm_id
              , /* 040 */ pn_licenca_id
              , /* 041 */ vn_repres_id
              , /* 042 */ vn_repres_site_id
              , /* 043 */ vn_repres_pc_comissao
              , /* 044 */ vn_repres_banco_agencia_id
              , /* 045 */ vn_da_urfe_id
              , /* 046 */ vn_da_via_transporte_id
              , /* 047 */ vn_da_pais_proc_id
              , /* 048 */ vc_da_multimodal
              , /* 049 */ vn_local_cvenda_id
              , /* 050 */ pn_vida_util
              , /* 051 */ vn_tp_acordo
              , /* 052 */ vn_acordo_aladi_id
              , /* 053 */ pn_ex_ncm_id
              , /* 054 */ vcur_ex1.ato_legal_id
              , /* 055 */ vcur_ex1.orgao_emissor_id
              , /* 056 */ vcur_ex1.nr_ato_legal
              , /* 057 */ vcur_ex1.ano_ato_legal
              , /* 058 */ pn_ex_nbm_id
              , /* 059 */ vcur_ex2.ato_legal_id
              , /* 060 */ vcur_ex2.orgao_emissor_id
              , /* 061 */ vcur_ex2.nr_ato_legal
              , /* 062 */ vcur_ex2.ano_ato_legal
              , /* 063 */ pn_ex_naladi_id
              , /* 064 */ vcur_ex3.ato_legal_id
              , /* 065 */ vcur_ex3.orgao_emissor_id
              , /* 066 */ vcur_ex3.ano_ato_legal
              , /* 067 */ vcur_ex3.nr_ato_legal
              , /* 068 */ pn_ex_ipi_id
              , /* 069 */ vcur_ex4.ato_legal_id
              , /* 070 */ vcur_ex4.orgao_emissor_id
              , /* 071 */ vcur_ex4.nr_ato_legal
              , /* 072 */ vcur_ex4.ano_ato_legal
              , /* 073 */ pn_ex_prac_id
              , /* 074 */ vcur_ex5.ato_legal_id
              , /* 075 */ vcur_ex5.orgao_emissor_id
              , /* 076 */ vcur_ex5.nr_ato_legal
              , /* 077 */ vcur_ex5.ano_ato_legal
              , /* 078 */ pn_ex_antd_id
              , /* 079 */ vcur_ex6.ato_legal_id
              , /* 080 */ vcur_ex6.orgao_emissor_id
              , /* 081 */ vcur_ex6.nr_ato_legal
              , /* 082 */ vcur_ex6.ano_ato_legal
              , /* 083 */ vn_da_moeda_frete_id
              , /* 084 */ vn_da_moeda_seguro_id
              , /* 085 */ pd_creation_date
              , /* 086 */ pn_created_by
              , /* 087 */ pd_last_update_date
              , /* 088 */ pn_last_updated_by
              , /* 089 */ sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
              , /* 090 */ pn_regtrib_icms_id
              , /* 091 */ pn_aliq_icms
              , /* 092 */ pn_aliq_icms_red
              , /* 093 */ pn_perc_red_icms
              , /* 094 */ pn_aliq_icms_fecp
              , /* 095 */ pn_fund_legal_icms_id
              , /* 096 */ pn_regtrib_pis_cofins_id
              , /* 097 */ pc_flag_red_base_pis_cofins
              , /* 098 */ pn_flegal_red_pis_cofins_id
              , /* 099 */ pn_perc_red_base_pis_cofins
              , /* 100 */ vn_aliq_pis_dev
              , /* 101 */ pn_aliq_pis_reduzida
              , /* 102 */ vn_aliq_cofins_dev
              , /* 103 */ pn_aliq_cofins_reduzida
              , /* 104 */ pn_fund_legal_pis_cofins_id
              , /* 105 */ nvl (pc_regime_especial_icms, 'N')
              , /* 106 */ pn_aliq_pis_especifica
              , /* 107 */ pn_aliq_cofins_especifica
              , /* 108 */ pc_um_aliq_especifica_pc
              , /* 109 */ pn_qtde_um_aliq_especifica_pc
              , /* 110 */ pn_aliq_antid_ad_valorem
              , /* 111 */ pn_aliq_antid_especifica
              , /* 112 */ pn_um_aliq_especifica_antid_id
              , /* 113 */ pc_somatoria_quantidade
              , /* 114 */ vn_cert_origem_mercosul_id
              , /* 115 */ vn_motivo_tsp_id
              , /* 116 */ vc_numero_rof
              , /* 117 */ pn_aliquota_mva
              , /* 118 */ pc_pro_emprego
              , /* 119 */ pn_aliq_base_pro_emprego
              , /* 120 */ pn_aliq_antecip_pro_emprego
              , /* 121 */ pc_beneficio_pr
              , /* 122 */ pn_aliq_base_pr
              , /* 123 */ pn_perc_diferido_pr
              , /* 124 */ pn_ins_estadual_id
              , /* 125 */ pn_pr_perc_vr_devido
              , /* 126 */ pn_pr_perc_minimo_base
              , /* 127 */ pn_pr_perc_minimo_suspenso
              , /* 128 */ pc_beneficio_sp
              , /* 129 */ pn_benef_id
              , /* 130 */ pn_vlr_frete_afrmm
              , /* 131 */ vc_admissao_temporaria
              , /* 132 */ vc_mat_usado_marca
              , /* 133 */ vc_mat_usado_modelo
              , /* 134 */ vc_mat_usado_n_serie
              , /* 135 */ vc_mat_usado_ano
              , /* 136 */ vn_mat_usado_enq_id
              , /* 137 */ vn_mat_usado_oper_id
              , /* 138 */ vc_arredonda_aliq_dife_icms_pr
              , /* 139 */ pc_beneficio_suspensao
              , /* 140 */ pn_perc_beneficio_suspensao
              );

    IF Nvl(pc_dsi,'N') = 'N' THEN
      IF (pn_licenca_id IS NOT null) THEN
        FOR nve IN cur_licencas_nve LOOP
          INSERT INTO imp_dcl_adi_nve
                      ( declaracao_adi_id
                      , abrangencia
                      , atributo
                      , especificacao
                      , creation_date
                      , created_by
                      , last_update_date
                      , last_updated_by
                      , grupo_acesso_id
                      )
               VALUES ( vn_declaracao_adi_id
                      , nve.abrangencia
                      , nve.atributo
                      , nve.especificacao
                      , pd_creation_date
                      , pn_created_by
                      , pd_last_update_date
                      , pn_last_updated_by
                      , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                      );
        END LOOP;

        FOR dtq IN cur_licencas_destaque LOOP
          INSERT INTO imp_dcl_adi_destaque
                      (
                        declaracao_adi_id
                      , destaque
                      , creation_date
                      , created_by
                      , last_update_date
                      , last_updated_by
                      , grupo_acesso_id
                      )
                VALUES(
                        vn_declaracao_adi_id
                      , dtq.destaque
                      , pd_creation_date
                      , pn_created_by
                      , pd_last_update_date
                      , pn_last_updated_by
                      , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                      );
        END LOOP;

      ELSE -- IF (pn_licenca_id IS NOT null) THEN
        FOR nve IN cur_itens_nve LOOP
          INSERT INTO imp_dcl_adi_nve
                      (
                        declaracao_adi_id
                      , abrangencia
                      , atributo
                      , especificacao
                      , creation_date
                      , created_by
                      , last_update_date
                      , last_updated_by
                      , grupo_acesso_id
                      )
               VALUES (
                        vn_declaracao_adi_id
                      , nve.abrangencia
                      , nve.atributo
                      , nve.especificacao
                      , pd_creation_date
                      , pn_created_by
                      , pd_last_update_date
                      , pn_last_updated_by
                      , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                      );
        END LOOP; -- FOR nve IN cur_itens_nve LOOP

        FOR dstq IN cur_destaque_a_ser_inserido LOOP
          INSERT INTO imp_dcl_adi_destaque
                      (
                        declaracao_adi_id
                      , destaque
                      , creation_date
                      , created_by
                      , last_update_date
                      , last_updated_by
                      , grupo_acesso_id
                      )
                VALUES(
                        vn_declaracao_adi_id
                      , dstq.destaque
                      , pd_creation_date
                      , pn_created_by
                      , pd_last_update_date
                      , pn_last_updated_by
                      , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                      );
        END LOOP;

        FOR ant IN cur_pgto_antecipado LOOP
          OPEN  cur_existe_pgto ( vn_declaracao_adi_id
                                , ant.instituicao_praca_id
                                , ant.contrato_numero
                                , 'A'
                                );
          FETCH cur_existe_pgto INTO vn_auxiliar;
          vb_existe_pgto := cur_existe_pgto%FOUND;
          CLOSE cur_existe_pgto;

          IF NOT vb_existe_pgto THEN
            INSERT INTO imp_dcl_adi_pgto
                        (
                          declaracao_id
                        , declaracao_adi_id
                        , tp_pgto
                        , contrato_num
                        , banco_agencia_id
                        , valor_m
                        , praca
                        , creation_date
                        , created_by
                        , last_update_date
                        , last_updated_by
                        , grupo_acesso_id
                        )
                  VALUES(
                          pn_declaracao_id
                        , vn_declaracao_adi_id
                        , 'A'
                        , ant.contrato_numero
                        , ant.instituicao_praca_id
                        , 0
                        , ant.cd_praca
                        , pd_creation_date
                        , pn_created_by
                        , pd_last_update_date
                        , pn_last_updated_by
                        , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                        );
          END IF;
        END LOOP; -- FOR ant IN cur_pgto_antecipado LOOP

        FOR vis IN cur_pgto_avista LOOP
          OPEN  cur_existe_pgto ( vn_declaracao_adi_id
                                , vis.instituicao_praca_id
                                , vis.contrato_numero
                                , 'V'
                                );
          FETCH cur_existe_pgto INTO vn_auxiliar;
          vb_existe_pgto := cur_existe_pgto%FOUND;
          CLOSE cur_existe_pgto;

          IF NOT vb_existe_pgto THEN
            INSERT INTO imp_dcl_adi_pgto
                        (
                          declaracao_id
                        , declaracao_adi_id
                        , tp_pgto
                        , contrato_num
                        , banco_agencia_id
                        , valor_m
                        , praca
                        , creation_date
                        , created_by
                        , last_update_date
                        , last_updated_by
                        , grupo_acesso_id
                        )
                  VALUES(
                          pn_declaracao_id
                        , vn_declaracao_adi_id
                        , 'V'
                        , vis.contrato_numero
                        , vis.instituicao_praca_id
                        , 0
                        , vis.cd_praca
                        , pd_creation_date
                        , pn_created_by
                        , pd_last_update_date
                        , pn_last_updated_by
                        , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                        );
          END IF; -- IF NOT vb_existe_pgto THEN
        END LOOP; -- FOR vis IN cur_pgto_avista LOOP
      END IF; -- IF (pn_licenca_id IS NOT null) THEN
    ELSE -- pc_dsi = 'N' ==> ou seja, eh DSI
      IF (pn_licenca_id IS NOT null) THEN
        FOR dtq IN cur_licencas_destaque LOOP
          INSERT INTO imp_dcl_adi_destaque
                      (
                        declaracao_adi_id
                      , destaque
                      , creation_date
                      , created_by
                      , last_update_date
                      , last_updated_by
                      , grupo_acesso_id
                      )
                VALUES(
                        vn_declaracao_adi_id
                      , dtq.destaque
                      , pd_creation_date
                      , pn_created_by
                      , pd_last_update_date
                      , pn_last_updated_by
                      , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                      );
        END LOOP;
      END IF; -- IF (pn_licenca_id IS NOT null) THEN
    END IF; -- pc_dsi = 'N'
  END IF;

  IF ( NVL(vn_declaracao_adi_id,0) = 0 ) THEN
    raise_application_error(-20000, 'Adição não gerada, cheque as condições !!!');
  ELSE
    /* Serão inseridos os documentos vinculados apenas se o tipo de declaração for diferente
       de 17 - Nacionalização de DEA e 18 - Nacionalização de DAD.
       Até o momento, somente estão sendo tratadas as nacionalizações do tipo 17 e 18 pela
       package IMP_PKG_NACIONALIZACAO. Quando os outros tipos forem tratados pela package,
       esse código deverá ser revisto.
     */
    IF (vc_nr_dcl_admissao IS NOT null AND vc_tp_declaracao NOT IN ('17', '18')) THEN
      OPEN  cur_dcl_adi_docvinc;
      FETCH cur_dcl_adi_docvinc INTO vn_auxiliar;
      vb_achou_docvinc := cur_dcl_adi_docvinc%FOUND;
      CLOSE cur_dcl_adi_docvinc;

      IF (NOT vb_achou_docvinc) THEN
        INSERT INTO imp_dcl_adi_docvinc
                    (
                      declaracao_id
                    , declaracao_adi_id
                    , tp_dcto
                    , nr_dcto
                    , creation_date
                    , created_by
                    , last_update_date
                    , last_updated_by
                    , grupo_acesso_id
                    )
              VALUES(
                      pn_declaracao_id
                    , vn_declaracao_adi_id
                    , 2
                    , vc_nr_dcl_admissao
                    , pd_creation_date
                    , pn_created_by
                    , pd_last_update_date
                    , pn_last_updated_by
                    , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                    );
      END IF;
    END IF;
  END IF;

  RETURN (vn_declaracao_adi_id);
END imp_fnc_gera_adicao_dcl_link;

/

