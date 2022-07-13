CREATE OR REPLACE PACKAGE BODY imp_pkg_totaliza_ebq_link AS
  -- $Date:                                                         $
  -- $Revision:            $
  TYPE reg_lin_mercadoria_ivc IS RECORD
    (
      invoice_lin_id                    NUMBER
    , invoice_id                        NUMBER
    , invoice_num                       VARCHAR2(25)
    , linha_num                         NUMBER
    , qtde                              NUMBER
    , preco_unitario_m                  NUMBER
    , pesoliq_tot_ivc                   NUMBER
    , pesoliq_tot                       NUMBER
    , pesoliq_unit                      NUMBER
    , pesobrt_tot                       NUMBER
    , incoterm                          VARCHAR2(20)
    , tprateio_incoterm                 VARCHAR2(20)
    , flag_fr_embutido                  VARCHAR2(1)
    , flag_sg_embutido                  VARCHAR2(1)
    , vrt_frivc_m                       NUMBER
    , vrt_sgivc_m                       NUMBER
    , moeda_fob_id                      NUMBER
    , vrt_fob_m                         NUMBER
    , vrt_fob_mn                        NUMBER
    , vrt_fob_us                        NUMBER
    , vrt_dspfob_m                      NUMBER
    , vrt_dspfob_mn                     NUMBER
    , vrt_dspfob_us                     NUMBER
    , vrt_fr_m                          NUMBER
    , vrt_fr_total_m                    NUMBER -- Rateio do Frete completo (collect + prepaid)
    , vrt_fr_prepaid_m                  NUMBER
    , vrt_fr_collect_m                  NUMBER
    , vrt_fr_territorio_nacional_m      NUMBER
    , vrt_fr_mn                         NUMBER
    , vrt_fr_total_mn                   NUMBER
    , vrt_fr_prepaid_mn                 NUMBER
    , vrt_fr_collect_mn                 NUMBER
    , vrt_fr_territorio_nacional_mn     NUMBER
    , vrt_fr_us                         NUMBER
    , vrt_fr_total_us                   NUMBER
    , vrt_fr_prepaid_us                 NUMBER
    , vrt_fr_collect_us                 NUMBER
    , vrt_fr_territorio_nacional_us     NUMBER
    , vrt_sg_m                          NUMBER
    , vrt_sg_mn                         NUMBER
    , vrt_sg_us                         NUMBER
    , vrt_acres_m                       NUMBER
    , vrt_acres_mn                      NUMBER
    , vrt_acres_us                      NUMBER
    , vrt_ded_m                         NUMBER
    , vrt_ded_mn                        NUMBER
    , vrt_ded_us                        NUMBER
    , vrt_ajuste_base_icms_m            NUMBER
    , vrt_ajuste_base_icms_mn           NUMBER
    , vrt_ajuste_base_icms_us           NUMBER
    , vmle_li_m                         NUMBER
    , vmle_li_mn                        NUMBER
    , vmle_mn                           NUMBER
    , vmle_m                            NUMBER
    , vmle_us                           NUMBER
    , vmlc_m                            NUMBER
    , vmlc_mn                           NUMBER
    , vmlc_li_m                         NUMBER
    , taxa_mn_fob                       NUMBER
    , taxa_us_fob                       NUMBER
    , taxa_mn_fr                        NUMBER
    , taxa_us_fr                        NUMBER
    , taxa_mn_sg                        NUMBER
    , taxa_us_sg                        NUMBER
    , vrt_descivc_m                     NUMBER /*Desconto que não diminui o valor fob => desc_pgto */
    , vrt_descsivc_m                    NUMBER /*Desconto que diminui o valor fob     => desc_pgto_ipt  */
    , unidade_medida                    VARCHAR2(20)
    , vrt_dsp_ddu_m                     NUMBER
    , vrt_dsp_ddu_mn                    NUMBER
    , vrt_dsp_ddu_us                    NUMBER
    , flag_dsp_ddu_embutida             VARCHAR2(1)
    , flag_libera_peso_liquido          VARCHAR2(1)
    , numero_nf                         NUMBER
    , flag_fixa_pesoliq_tot             VARCHAR2(1)
    , tp_linha_codigo                   VARCHAR2(150)
    , class_fiscal_id                   NUMBER
    , item_id                           NUMBER
    , peso_bruto_nac                    NUMBER
    , flag_fixa_pesobrt_tot             VARCHAR2(1)
    );

  TYPE reg_lin_declaracao IS RECORD
    (
      declaracao_lin_id                 NUMBER
    , declaracao_id                     NUMBER
    , declaracao_adi_id                 NUMBER
    , linha_num                         NUMBER
    , invoice_id                        NUMBER
    , invoice_lin_id                    NUMBER
    , licenca_id                        NUMBER
    , qtde                              NUMBER
    , vru_fob_m                         NUMBER
--    , vr_desconto_m                NUMBER
    , pesobrt_tot                       NUMBER
    , pesoliq_tot                       NUMBER
    , pesoliq_unit                      NUMBER
    , regtrib_icms                      VARCHAR2(20)
    , regtrib_icms_id                   NUMBER
    , aliq_ii_rec                       NUMBER
    , aliq_ii_dev                       NUMBER
    , aliq_ipi_rec                      NUMBER
    , aliq_ipi_dev                      NUMBER
    , aliq_icms                         NUMBER
    , aliq_icms_red                     NUMBER
    , perc_red_icms                     NUMBER
    , basecalc_ii                       NUMBER
    , basecalc_ipi                      NUMBER
    , basecalc_icms                     NUMBER
    , valor_ii_dev                      NUMBER
    , valor_ipi_dev                     NUMBER
    , valor_icms_dev                    NUMBER
    , valor_ii                          NUMBER
    , valor_ipi                         NUMBER
    , valor_icms                        NUMBER
    , basecalc_icms_pro_emprego         NUMBER
    , valor_icms_pro_emprego            NUMBER
    , tp_declaracao                     VARCHAR2(20)
    , tpdcl_calcula_icms                VARCHAR2(20)
    , mscob_calcula_icms                VARCHAR2(20)
    , tpato_calcula_icms                VARCHAR2(20)
    , rd_id                             NUMBER
    , sit_tributaria                    VARCHAR2(20)
    , aliq_pis                          NUMBER
    , aliq_cofins                       NUMBER
    , perc_reducao_base_pis_cofins      NUMBER
    , basecalc_pis_cofins               NUMBER
    , valor_pis                         NUMBER
    , valor_cofins                      NUMBER
    , valor_pis_dev                     NUMBER
    , valor_cofins_dev                  NUMBER
    , basecalc_pis_cofins_integral      NUMBER
    , valor_pis_integral                NUMBER
    , valor_cofins_integral             NUMBER
    , regtrib_pis_cofins_id             NUMBER
    , moeda_fob_id                      NUMBER       -- campo para nacionalização
    , moeda_frete_id                    NUMBER       -- campo para nacionalização
    , moeda_seguro_id                   NUMBER       -- campo para nacionalização
    , vrt_fob_m                         NUMBER       -- campo para nacionalização
    , vrt_dspfob_m                      NUMBER       -- campo para nacionalização
    , vrt_fr_m                          NUMBER       -- campo para nacionalização
    , vrt_sg_m                          NUMBER       -- campo para nacionalização
    , incoterm                          VARCHAR2(20) -- campo para nacionalização
    , tprateio_incoterm                 VARCHAR2(20) -- campo para nacionalização
    , pesobrt_unit                      NUMBER       -- campo para nacionalização
    , moeda_inativa                     BOOLEAN      -- campo para nacionalização
    , vrt_fr_prepaid_m                  NUMBER
    , vrt_fr_collect_m                  NUMBER
    , vrt_fr_territorio_nacional_m      NUMBER
    , regtrib_ii                        VARCHAR2(1)
    , regtrib_ipi                       VARCHAR2(1)
    , vrt_dsp_ddu_m                     NUMBER
    , vrt_fr_total_m                    NUMBER
    , aliq_icms_fecp                    NUMBER
    , valor_icms_fecp                   NUMBER
    , vmlc_unit_m                       NUMBER
    , vmle_unit_m                       NUMBER
    , vmle_unit_mn                      NUMBER
    , tipo_unidade_medida_antid         VARCHAR2(1)
    , valor_antid_aliq_especifica       NUMBER
    , valor_antid_ad_valorem            NUMBER
    , qtde_um_aliq_especifica_antid     NUMBER
    , basecalc_antid                    NUMBER
    , valor_antid                       NUMBER
    , valor_antid_dev                   NUMBER
    , somatoria_quantidade              VARCHAR2(1)
    , aliq_antid_especifica             NUMBER
    , aliq_antid                        NUMBER
    , taxa_fob_mn                       NUMBER     /************** incluidas essas taxas para nacionalizações de recof **************/
    , taxa_fr_mn                        NUMBER     /************** incluidas essas taxas para nacionalizações de recof **************/
    , taxa_sg_mn                        NUMBER     /************** incluidas essas taxas para nacionalizações de recof **************/
    , valor_icms_da                     NUMBER
    , valor_ii_proporcional             NUMBER
    , valor_ipi_proporcional            NUMBER
    , valor_pis_proporcional            NUMBER
    , valor_cofins_proporcional         NUMBER
    , valor_antid_proporcional          NUMBER
    , licenca_lin_id                    NUMBER
    , aliq_mva                          NUMBER
    , basecalc_icms_st                  NUMBER
    , valor_icms_st                     NUMBER
    , pr_aliq_base                      NUMBER
    , pr_perc_diferido                  NUMBER
    , valor_diferido_icms_pr            NUMBER
    , valor_cred_presumido_pr           NUMBER
    , valor_cred_presumido_pr_devido    NUMBER
    , beneficio_pr_artigo               VARCHAR2(3)
    , pr_perc_vr_devido                 NUMBER
    , pr_perc_minimo_base               NUMBER
    , pr_perc_minimo_suspenso           NUMBER
    , valor_devido_icms_pr              NUMBER
    , valor_perc_vr_devido_icms_pr      NUMBER
    , valor_perc_minimo_base_icms_pr    NUMBER
    , valor_perc_susp_base_icms_pr      NUMBER
    , vlr_frete_afrmm                   NUMBER
    , vlr_base_dev                      NUMBER     /* valor cálculo AFRMM */
    , vlr_base_dev_mn                   NUMBER     /* valor cálculo AFRMM na moeda nacional */
    , valor_ajuste_base_icms_mn         NUMBER
    , vlr_base_a_recolher               NUMBER     /* valor cálculo AFRMM */
    , vlr_base_a_recolher_mn            NUMBER     /* valor cálculo AFRMM na moeda nacional */
    , aliq_cofins_recuperar             NUMBER
    , valor_cofins_recuperar            NUMBER
    , aliquota_cofins_custo             NUMBER
    , class_fiscal_id                   NUMBER
    , valor_fecp_dev                    NUMBER
    , valor_fecp_st                     NUMBER
    , valor_icms_sem_fecp               NUMBER
    , valor_icms_dev_sem_fecp           NUMBER
    , valor_icms_st_sem_fecp            NUMBER
    , aliq_cofins_reduzida              NUMBER
    , beneficio_suspensao               VARCHAR2(1)
    , perc_beneficio_suspensao          NUMBER
    );

  TYPE reg_adi_declaracao IS RECORD
    (
      declaracao_adi_id                 NUMBER
    , qtde_linhas                       NUMBER
    , peso_liquido                      NUMBER
    , qt_um_estat                       NUMBER
    , vrt_fob_m                         NUMBER
    , vrt_dspfob_m                      NUMBER
    , vrt_sg_m                          NUMBER
    , vrt_acres_m                       NUMBER
    , vrt_ded_m                         NUMBER
    , vrt_ajuste_base_icms_m            NUMBER
    , vrt_fob_mn                        NUMBER
    , vrt_dspfob_mn                     NUMBER
    , vrt_sg_mn                         NUMBER
    , vrt_acres_mn                      NUMBER
    , vrt_ded_mn                        NUMBER
    , vrt_ajuste_base_icms_mn           NUMBER
    , vrt_fob_us                        NUMBER
    , vrt_dspfob_us                     NUMBER
    , vrt_sg_us                         NUMBER
    , vrt_acres_us                      NUMBER
    , vrt_ded_us                        NUMBER
    , vrt_ajuste_base_icms_us           NUMBER
    , vrt_fr_m                          NUMBER
    , vrt_fr_total_m                    NUMBER -- Rateio do Frete completo (collect + prepaid)
    , vrt_fr_prepaid_m                  NUMBER
    , vrt_fr_collect_m                  NUMBER
    , vrt_fr_territorio_nacional_m      NUMBER
    , vrt_fr_mn                         NUMBER
    , vrt_fr_total_mn                   NUMBER
    , vrt_fr_prepaid_mn                 NUMBER
    , vrt_fr_collect_mn                 NUMBER
    , vrt_fr_territorio_nacional_mn     NUMBER
    , vrt_fr_us                         NUMBER
    , vrt_fr_total_us                   NUMBER
    , vrt_fr_prepaid_us                 NUMBER
    , vrt_fr_collect_us                 NUMBER
    , vrt_fr_territorio_nacional_us     NUMBER
    , basecalc_ii                       NUMBER
    , valor_ii_dev                      NUMBER
    , valor_ii_rec                      NUMBER
    , basecalc_ipi                      NUMBER
    , valor_ipi_dev                     NUMBER
    , valor_ipi_rec                     NUMBER
    , valor_icms                        NUMBER
    , basecalc_icms_pro_emprego         NUMBER
    , valor_icms_pro_emprego            NUMBER
    , vmlc_m                            NUMBER
    , vmlc_mn                           NUMBER
    , vmle_mn                           NUMBER
    , tp_acordo                         NUMBER
    , aliq_ii_dev                       NUMBER
    , aliq_ii_dev_original              NUMBER  --- para tp.declaracao 12 - consumo e adm.temporaria
    , aliq_ii_red                       NUMBER
    , aliq_ii_acordo                    NUMBER
    , perc_red_ii                       NUMBER
    , aliq_ii_rec                       NUMBER
    , aliq_ipi_dev                      NUMBER
    , aliq_ipi_dev_original             NUMBER  --- para tp.declaracao 12 - consumo e adm.temporaria
    , aliq_ipi_red                      NUMBER
    , aliq_ipi_rec                      NUMBER
    , valor_pis                         NUMBER
    , valor_cofins                      NUMBER
    , valor_pis_dev                     NUMBER
    , valor_cofins_dev                  NUMBER
    , basecalc_pis_cofins               NUMBER
    , valor_icms_dev                    NUMBER
    , basecalc_icms                     NUMBER
    , basecalc_pis_cofins_integral      NUMBER
    , valor_pis_integral                NUMBER
    , valor_cofins_integral             NUMBER
    , basecalc_antdump                  NUMBER
    , qt_um_aliq_esp_antdump            NUMBER
    , valor_antdump_aliq_especifica     NUMBER
    , valor_antdump_ad_valorem          NUMBER
    , valor_antdump                     NUMBER
    , valor_antdump_dev                 NUMBER
    , vr_aliq_esp_antdump_mn            NUMBER
    , fator_admissao_temporaria         NUMBER
    , valor_ii_proporcional             NUMBER
    , valor_ipi_proporcional            NUMBER
    , valor_pis_proporcional            NUMBER
    , valor_cofins_proporcional         NUMBER
    , valor_antid_proporcional          NUMBER
    , aliq_mva                          NUMBER
    , basecalc_icms_st                  NUMBER
    , valor_icms_st                     NUMBER
    , pr_aliq_base                      NUMBER
    , pr_perc_diferido                  NUMBER
    , valor_diferido_icms_pr            NUMBER
    , valor_cred_presumido_pr           NUMBER
    , valor_cred_presumido_pr_devido    NUMBER
    , beneficio_pr_artigo               VARCHAR2(3)
    , pr_perc_vr_devido                 NUMBER
    , pr_perc_minimo_base               NUMBER
    , pr_perc_minimo_suspenso           NUMBER
    , valor_devido_icms_pr              NUMBER
    , valor_perc_vr_devido_icms_pr      NUMBER
    , valor_perc_minimo_base_icms_pr    NUMBER
    , valor_perc_susp_base_icms_pr      NUMBER
    , vlr_base_dev                      NUMBER    /* valor cálculo AFRMM */
    , vlr_base_dev_mn                   NUMBER    /* valor cálculo AFRMM na moeda nacional */
    , vlr_base_a_recolher               NUMBER    /* valor cálculo AFRMM */
    , vlr_base_a_recolher_mn            NUMBER    /* valor cálculo AFRMM na moeda nacional */
    , vlr_frete_afrmm                   NUMBER
    , valor_fecp_dev                    NUMBER
    , valor_fecp                        NUMBER
    , valor_fecp_st                     NUMBER
    , valor_icms_sem_fecp               NUMBER
    , valor_icms_dev_sem_fecp           NUMBER
    , valor_icms_st_sem_fecp            NUMBER
    );

  TYPE reg_invoices_ad_lin IS RECORD
    (
      embarque_ad_id          NUMBER
    , invoice_lin_id          NUMBER
    , declaracao_lin_id       NUMBER   --- campo para nacionalizacao
    , declaracao_adi_id       NUMBER   --- campo para nacionalizacao
    , tp_acres_ded            VARCHAR2(1)
    , acres_ded_id            NUMBER
    , qtde_invoice            NUMBER
    , moeda_id                NUMBER
    , taxa_mn                 NUMBER
    , valor_m                 NUMBER
    , valor_mn                NUMBER
    , valor_us                NUMBER
    , ind_tb_ivc_lin       NUMBER
    , valor_ajuste_base_icms_m  NUMBER
    , valor_ajuste_base_icms_mn NUMBER
    , valor_ajuste_base_icms_us NUMBER
    );

  TYPE reg_ivc_lin_dsp IS RECORD
    (
      numerario_id              NUMBER
    , numerario_dsp_id          NUMBER
    , embarque_id               NUMBER
    , invoice_id                NUMBER
    , invoice_lin_id            NUMBER
    , declaracao_lin_id         NUMBER /************ para nacionalizacoes de recof *************/
    , valor_mn                  NUMBER
    , basecalc_icms             NUMBER
    , valor_icms                NUMBER
    , basecalc_icms_pro_emprego NUMBER
    , valor_icms_pro_emprego    NUMBER
    , basecalc_pis_cofins       NUMBER
    , valor_pis                 NUMBER
    , valor_cofins              NUMBER
    , valor_ajuste              NUMBER
    , qtde_linha_ivc            NUMBER
    , qtde_linha_dcl            NUMBER
    , valor_fecp                NUMBER
    );

  TYPE reg_rateio_acresded IS RECORD
    ( ind_tb_ivc_lin       NUMBER
    , vrt_acresded_m       NUMBER
    , vrt_acresded_mn      NUMBER
    , vrt_acresded_mfob    NUMBER
    , vrt_acresded_us      NUMBER
    , vrt_ajuste_base_icms_m    NUMBER
    , vrt_ajuste_base_icms_mn   NUMBER
    , vrt_ajuste_base_icms_mfob NUMBER
    , vrt_ajuste_base_icms_us   NUMBER
    , vrt_total            NUMBER
    );

  TYPE reg_declaracoes_ad_lin IS RECORD
    ( declaracao_lin_id       NUMBER
    , declaracao_adi_id       NUMBER
    , tp_acres_ded            VARCHAR2(1)
    , acres_ded_id            NUMBER
    , qtde                    NUMBER
    , moeda_id                NUMBER
    , taxa_mn                 NUMBER
    , valor_acres_m           NUMBER
    , valor_acres_mn          NUMBER
    , valor_acres_us          NUMBER
    , valor_ded_m             NUMBER
    , valor_ded_mn            NUMBER
    , valor_ded_us            NUMBER
    , valor_ajuste_base_icms_m             NUMBER
    , valor_ajuste_base_icms_mn            NUMBER
    , valor_ajuste_base_icms_us            NUMBER
    );

  TYPE reg_ivc_lin_da IS RECORD
    ( invoice_lin_id            NUMBER
    , da_lin_id                 NUMBER
    , licenca_lin_id            NUMBER
    , declaracao_lin_id         NUMBER
    , da_peso_liq_proporcional  NUMBER
    , da_peso_brt_proporcional  NUMBER
    );

  TYPE reg_dcl_adi_acresded IS RECORD
    ( declaracao_adi_id   NUMBER
    , tp_acres_ded        VARCHAR2(1)
    , acres_ded_id        NUMBER
    , moeda_id            NUMBER
    , valor_m             NUMBER
    , valor_mn            NUMBER
    , valor_ajuste_base_icms_m  NUMBER
    , valor_ajuste_base_icms_mn NUMBER
    );

  TYPE tb_adi_acresded IS TABLE OF reg_dcl_adi_acresded INDEX BY BINARY_INTEGER;
  TYPE typ_rateio_acresded    IS TABLE OF reg_rateio_acresded     INDEX BY BINARY_INTEGER;
  TYPE typ_lin_mercadoria_ivc IS TABLE OF reg_lin_mercadoria_ivc  INDEX BY BINARY_INTEGER;
  TYPE typ_lin_declaracao     IS TABLE OF reg_lin_declaracao      INDEX BY BINARY_INTEGER;
  TYPE typ_adi_declaracao     IS TABLE OF reg_adi_declaracao      INDEX BY BINARY_INTEGER;
  TYPE typ_ad_invoice_lin     IS TABLE OF reg_invoices_ad_lin     INDEX BY BINARY_INTEGER;
  TYPE typ_ivc_lin_dsp        IS TABLE OF reg_ivc_lin_dsp         INDEX BY BINARY_INTEGER;
  TYPE typ_ad_dcl_lin         IS TABLE OF reg_declaracoes_ad_lin  INDEX BY BINARY_INTEGER;
  TYPE typ_ivc_lin_da         IS TABLE OF reg_ivc_lin_da          INDEX BY BINARY_INTEGER;

  CURSOR cur_moeda_seguro (pn_embarque_id NUMBER) IS
    SELECT Decode( cmx_pkg_tabelas.codigo(ie.tp_embarque_id)
                 , 'DI_UN'
                 , Nvl(ie.prev_seg_moeda_id, (SELECT ipr.moeda_seguro_id
                                                FROM imp_po_remessa ipr
                                               WHERE ipr.nr_remessa = '1'
                                                 AND ipr.embarque_id = ie.embarque_id
                                                 ))
                 , ie.moeda_seguro_id
                 )
         , ie.aliq_seguro
         , ic.via_transporte_id
      FROM imp_embarques     ie
         , imp_conhecimentos ic
     WHERE ie.embarque_id = pn_embarque_id
       AND ic.conhec_id (+) = ie.conhec_id;

  tb_ivc_lin                     typ_lin_mercadoria_ivc;
  tb_dcl_lin                     typ_lin_declaracao;
  tb_dcl_adi                     typ_adi_declaracao;
  tb_ivc_lin_ad                  typ_ad_invoice_lin;
  tb_ivc_lin_dsp                 typ_ivc_lin_dsp;
  tb_rateio_acresded             typ_rateio_acresded;
  tb_dcl_lin_ad                  typ_ad_dcl_lin;
  tb_ivc_lin_da                  typ_ivc_lin_da;

  vn_global_ivc_lin              NUMBER := 0;
  vn_global_ivc_lin_da           NUMBER := 0;
  vn_global_ivc_lin_dsp          NUMBER := 0;
  vn_global_dcl_lin_dsp          NUMBER := 0;
  vn_global_ivc_ad_lin           NUMBER := 0;
  vn_global_dcl_lin              NUMBER := 0;
  vn_global_dcl_adi              NUMBER := 0;
  vn_global_pesoliq_ebq          NUMBER := 0;
  vn_global_pesobrt_ebq          NUMBER := 0;
  vn_global_pesobrt_nac          NUMBER := 0;
  vn_global_pesoliq_nac          NUMBER := 0;
  vn_global_vrt_cif_ii_ipi_mn    NUMBER := 0;
  vn_global_valor_aduaneiro      NUMBER := 0;
  vn_global_valor_ref_adicao     NUMBER := 0;
  vn_global_vrt_fob_ebq_mn       NUMBER := 0;
  vn_global_vrt_base_seguro      NUMBER := 0;
  vn_global_moeda_sg_id          NUMBER := 0;
  vn_global_moeda_fr_id          NUMBER := 0;
  vn_global_vrt_fob_ebq_us       NUMBER := 0;
  vn_global_vrt_dspfob_ebq_m     NUMBER := 0;
  vn_global_vrt_dspfob_ebq_mn    NUMBER := 0;
  vn_global_vrt_dspfob_ebq_us    NUMBER := 0;
  vn_global_vrt_vmle_ebq_mn      NUMBER := 0;
  vn_global_vrt_fr_m             NUMBER := 0;
  vn_global_vrt_fr_total_m       NUMBER := 0;
  vn_global_vrt_fr_prepaid_m     NUMBER := 0;
  vn_global_vrt_fr_collect_m     NUMBER := 0;
  vn_global_vrt_fr_terr_nac_m    NUMBER := 0;
  vn_global_vrt_fr_mn            NUMBER := 0;
  vn_global_vrt_fr_total_mn      NUMBER := 0;
  vn_global_vrt_fr_prepaid_mn    NUMBER := 0;
  vn_global_vrt_fr_collect_mn    NUMBER := 0;
  vn_global_vrt_fr_terr_nac_mn   NUMBER := 0;
  vn_global_vrt_fr_total_us      NUMBER := 0; -- Variável global usada apenas para comparar o frete destacado na invoice com o frete da declaração(proporcional) para os casos de declaração do tipo '14'
  vn_global_vrt_sg_ebq_m         NUMBER := 0;
  vn_global_vrt_sg_ebq_mn        NUMBER := 0;
  vn_global_vrt_sg_ebq_us        NUMBER := 0;
  vn_global_vrt_ii_mn            NUMBER := 0;
  vn_global_vrt_ipi_mn           NUMBER := 0;
  vn_global_vrt_icms_mn          NUMBER := 0;
  vn_global_vrt_pis_mn           NUMBER := 0;
  vn_global_vrt_cofins_mn        NUMBER := 0;
  vn_global_vrt_antidumping_mn   NUMBER := 0;
  vn_global_vrt_ii_prop_mn       NUMBER := 0;
  vn_global_vrt_ipi_prop_mn      NUMBER := 0;
  vn_global_vrt_pis_prop_mn      NUMBER := 0;
  vn_global_vrt_cofins_prop_mn   NUMBER := 0;
  vn_global_vrt_antid_prop_mn    NUMBER := 0;
  vn_global_dcl_lin_ad_nac       NUMBER := 0;
  vn_global_vrt_multa_li_mn      NUMBER := 0;
  vc_global_tp_base_seguro       VARCHAR2(1) := null;
  vc_global_data_base_seguro     cmx_tabelas.codigo%TYPE := null;
  vc_global_incide_aliq_icms_pc  imp_empresas_param.incidir_perc_red_aliq_icms_pc%TYPE := null;
  vc_global_calc_icms_imp_dev    imp_empresas_param.calcula_icms_com_impostos_dev%TYPE := null;
  vc_global_calc_icms_imp_dev_de imp_empresas_param.calcula_icms_com_impost_dev_de%TYPE := null;
  vc_global_calc_icms_ip_dev_rcf imp_empresas_param.calcula_icms_com_ipt_dev_recof%TYPE := null;
  vc_global_calc_icms_ip_dev_drw  imp_empresas_param.calcula_icms_com_ipt_dev_drw%TYPE   := null;
  vc_global_bicms_cons_adm_temp  imp_empresas_param.base_icms_consumo_adm_tmp%TYPE      := null;
  vc_global_aprov_num_auto       VARCHAR2(1) := null;
  vc_global_tpbase_retif_a_maior VARCHAR2(1) := null;
  vc_global_deduz_po_termo       VARCHAR2(1) := null;
  vn_global_conhec_id            NUMBER := 0;
  vc_global_tx_util_fixa         NUMBER := 0;
  vn_global_meses_permanencia    NUMBER := 0;
  vn_global_meses_permanec_icms  NUMBER := null;
  vn_global_evento_id            NUMBER := 0;
  vc_global_ebq_totalizado       VARCHAR2(1) := 'S';
  vc_global_dcl_totalizada       VARCHAR2(1) := 'S';
  vd_global_creation_date        DATE   := null;
  vn_global_created_by           NUMBER := 0;
  vd_global_last_update_date     DATE   := null;
  vn_global_last_updated_by      NUMBER := 0;
  vn_global_grupo_acesso_id      NUMBER;
  vc_global_embute_ii_bc_piscof  VARCHAR2(1) := null;
  vn_global_vrt_icms_st_mn       NUMBER := 0;
  vc_global_nac_sem_admissao     VARCHAR2(1) := 'N';
  vc_global_verif_di_unica       cmx_tabelas.auxiliar1%TYPE;
  vn_vlr_sg_rem_mn               NUMBER := 0;
  vn_vlr_frete                   NUMBER := 0;
  vn_vlr_base_dev                NUMBER := 0;
  vn_vlr_base_dev_mn             NUMBER := 0;
  vc_global_via_transporte       cmx_tabelas.codigo%TYPE;
  vn_global_vrt_fecp_mn          NUMBER := 0;
  vn_global_vrt_fecp_st_mn       NUMBER := 0;
  vn_global_vrt_icms_mn_sem_fecp NUMBER := 0;
  vn_global_vrt_icms_st_mn_sfecp  NUMBER := 0;

  -- ***********************************************************************
  -- Procedure que gera o erro em outra sessão de banco.
  -- ***********************************************************************
  PROCEDURE prc_gera_log_erros ( pc_mensagem    VARCHAR2
                               , pc_tp_erro     VARCHAR2
                               , pc_flag_tabela VARCHAR2
                               , pc_solucao     VARCHAR2 DEFAULT NULL
                               ) IS
  BEGIN
    cmx_prc_gera_log_erros (
       vn_global_evento_id
     , pc_mensagem
     , pc_tp_erro
     , pc_solucao
    );

    IF (pc_tp_erro='E') THEN
      IF (nvl (pc_flag_tabela,'X') IN ('A','D')) THEN  --- Ambos ou Declaração
        vc_global_dcl_totalizada := 'N';
      END IF;

      IF (nvl (pc_flag_tabela,'X') IN ('A','E')) THEN  --- Ambos ou Embarque
        vc_global_ebq_totalizado := 'N';
      END IF;
    END IF;
  END prc_gera_log_erros;

  -- ***********************************************************************
  -- Procedure para inicialização das variaveis globais
  -- ***********************************************************************
  PROCEDURE imp_prc_zera_globais IS
  BEGIN
    vn_global_ivc_lin            := 0;
    vn_global_ivc_lin_da         := 0;
    vn_global_ivc_ad_lin         := 0;
    vn_global_ivc_lin_dsp        := 0;
    vn_global_dcl_lin_dsp        := 0;
    vn_global_dcl_lin            := 0;
    vn_global_dcl_adi            := 0;
    vn_global_pesoliq_ebq        := 0;
    vn_global_pesobrt_ebq        := 0;
    vn_global_pesoliq_nac        := 0;
    vn_global_pesobrt_nac        := 0;
    vn_global_vrt_cif_ii_ipi_mn  := 0;
    vn_global_valor_aduaneiro    := 0;
    vn_global_vrt_fob_ebq_mn     := 0;
    vn_global_vrt_base_seguro    := 0;
    vn_global_vrt_fob_ebq_us     := 0;
    vn_global_vrt_dspfob_ebq_m   := 0;
    vn_global_vrt_dspfob_ebq_mn  := 0;
    vn_global_vrt_dspfob_ebq_us  := 0;
    vn_global_vrt_vmle_ebq_mn    := 0;
    vn_global_vrt_fr_m           := 0;
    vn_global_moeda_fr_id        := 0;
    vn_global_vrt_fr_total_m     := 0;
    vn_global_vrt_fr_prepaid_m   := 0;
    vn_global_vrt_fr_collect_m   := 0;
    vn_global_vrt_fr_terr_nac_m  := 0;
    vn_global_vrt_fr_mn          := 0;
    vn_global_vrt_fr_total_mn    := 0;
    vn_global_vrt_fr_prepaid_mn  := 0;
    vn_global_vrt_fr_collect_mn  := 0;
    vn_global_vrt_fr_terr_nac_mn := 0;
    vn_global_vrt_fr_total_us    := 0;
    vn_global_vrt_sg_ebq_m       := 0;
    vn_global_vrt_sg_ebq_mn      := 0;
    vn_global_vrt_sg_ebq_us      := 0;
    vn_global_vrt_ii_mn          := 0;
    vn_global_vrt_ipi_mn         := 0;
    vn_global_vrt_icms_mn        := 0;
    vn_global_vrt_pis_mn         := 0;
    vn_global_vrt_cofins_mn      := 0;
    vn_global_vrt_antidumping_mn := 0;
    vn_global_vrt_ii_prop_mn     := 0;
    vn_global_vrt_ipi_prop_mn    := 0;
    vn_global_vrt_pis_prop_mn    := 0;
    vn_global_vrt_cofins_prop_mn := 0;
    vn_global_vrt_antid_prop_mn  := 0;
    vn_global_dcl_lin_ad_nac     := 0;
    vn_global_vrt_icms_st_mn     := 0;
    vn_global_vrt_fecp_mn        := 0;
    vn_global_vrt_fecp_st_mn     := 0;
    vn_global_vrt_icms_mn_sem_fecp := 0;
    vn_global_vrt_icms_st_mn_sfecp := 0;
    tb_ivc_lin.delete;
    tb_dcl_lin.delete;
    tb_dcl_adi.delete;
    tb_ivc_lin_ad.delete;
    tb_ivc_lin_dsp.delete;
    tb_rateio_acresded.delete;
    tb_dcl_lin_ad.delete;
    tb_ivc_lin_da.delete;
  END imp_prc_zera_globais;

  PROCEDURE prc_verifica_ex_recof(  pn_embarque_id     imp_embarques.embarque_id%TYPE
                                  , pn_declaracao_id   imp_declaracoes.declaracao_id%TYPE
                                 ) IS

    CURSOR cur_tp_embarque IS
      SELECT tp_embarque_id
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_existe_declaracao IS
      SELECT declaracao_id
        FROM imp_declaracoes
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_existe_licenca IS
      SELECT licenca_id, nr_registro
        FROM imp_licencas
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_decl_lin IS
      SELECT dcl.excecao_ii_id         excecao_ii_id
            ,Nvl(exl.recof,'N')        recof
            ,dc.referencia             referencia
            ,dcl.linha_num             nr_linha
        FROM imp_declaracoes_lin       dcl
            ,imp_excecoes_fiscais      exl
            ,imp_declaracoes           dc
       WHERE dcl.declaracao_id          = pn_declaracao_id
         AND dcl.excecao_ii_id          = exl.excecao_id  (+)
         AND dcl.declaracao_id          = dc.declaracao_id;


    vn_tp_embarque         imp_embarques.tp_embarque_id%TYPE := NULL;
    vn_declaracao_id       imp_declaracoes.declaracao_id%TYPE := NULL;
    vn_licenca_id          imp_licencas.licenca_id%TYPE := NULL;
    vc_nr_registro_li      imp_licencas.nr_registro%TYPE := NULL;
    vb_misto               BOOLEAN := FALSE;
    vb_recof               BOOLEAN := FALSE;
    vc_tp_alerta           VARCHAR2(1)   := NULL;
    vc_mensagem_alerta     VARCHAR2(400) := NULL;
    vc_mensagem_solucao    VARCHAR2(400) := NULL;

  BEGIN

    OPEN cur_tp_embarque;
    FETCH cur_tp_embarque INTO vn_tp_embarque;
    CLOSE cur_tp_embarque;

    OPEN cur_existe_declaracao;
    FETCH cur_existe_declaracao INTO vn_declaracao_id;
    CLOSE cur_existe_declaracao;

    OPEN cur_existe_licenca;
    FETCH cur_existe_licenca INTO vn_licenca_id, vc_nr_registro_li;
    CLOSE cur_existe_licenca;

  --  IF (vn_tp_embarque IN (cmx_pkg_tabelas.tabela_id(901,'RCF'),cmx_pkg_tabelas.tabela_id(901,'RCF_MISTO'))) THEN
    IF cmx_pkg_tabelas.auxiliar (vn_tp_embarque, 1) = 'RCF' AND cmx_pkg_tabelas.auxiliar (vn_tp_embarque, 18)  IN ('RECOF','MISTO') AND vn_declaracao_id IS NOT NULL THEN

      -- Percorre as linhas da declaração para verificar o tipo do embarque correto.
      FOR a IN cur_decl_lin LOOP
        IF (Upper(a.recof) = 'N') THEN
          vb_misto  := TRUE;
        ELSE
          vb_recof  := TRUE;
        END IF;
      END LOOP;

      IF   ((cmx_pkg_tabelas.auxiliar (vn_tp_embarque, 18) = 'RECOF') AND vb_misto)
        OR ((cmx_pkg_tabelas.auxiliar (vn_tp_embarque, 18) = 'MISTO') AND vb_misto AND NOT vb_recof)
        OR ((cmx_pkg_tabelas.auxiliar (vn_tp_embarque, 18) = 'MISTO') AND NOT vb_misto) THEN

        IF ( (vn_licenca_id IS NULL) OR (vn_licenca_id IS NOT NULL AND vc_nr_registro_li IS NOT NULL) ) THEN
          vc_tp_alerta        := 'E';
          vc_mensagem_alerta  := 'RECOF MISTO: O Tipo de Embarque utilizado não está de acordo com as informações fiscais dos itens considerados na DI.';
          vc_mensagem_solucao := 'Favor, trocar o Tipo do Embarque ou revisar as Exceções Fiscais vinculadas às linhas da LI ou DI.';

          vc_global_ebq_totalizado := 'N';
          vc_global_dcl_totalizada := 'N';

        ELSIF (vn_licenca_id IS NOT NULL AND vc_nr_registro_li IS NULL) THEN
          vc_tp_alerta        := 'A';
          vc_mensagem_alerta  := 'RECOF MISTO: O Tipo de Embarque utilizado não está de acordo com as informações fiscais dos itens considerados na DI, mas foi verificado que o processo possui LI(s) não registrada(s).';
          vc_mensagem_solucao := 'Favor registrar a(s) LI(s) pendentes.';

          vc_global_ebq_totalizado := 'S';
          vc_global_dcl_totalizada := 'S';
        END IF;

        cmx_prc_gera_log_erros (
              vn_global_evento_id
            , vc_mensagem_alerta  --, 'RECOF MISTO: O Tipo de Embarque utilizado não está de acordo com as informações fiscais dos itens considerados no processo.'
            , vc_tp_alerta        --'E'
            , vc_mensagem_solucao --'Favor, trocar o Tipo do Embarque ou revisar as Exceções Fiscais vinculadas às linhas da LI ou DI.'
            );

      END IF;
    END IF; -- Fim IF (vn_tp_embarque IN (cmx_pkg_tabelas.tabela_id(901,'RCF'),cmx_pkg_tabelas.tabela_id(901,'RCF_MISTO'))) THEN

  END prc_verifica_ex_recof;

  PROCEDURE prc_validar_ncm ( pn_declaracao_id NUMBER
                            , pc_dsi           VARCHAR2
                            , pn_embarque_id   NUMBER
                            ) IS

    CURSOR cur_licenca_lin IS
      SELECT l.linha_num
           , i.invoice_num
           , l.ex_ncm_id
           , l.ex_ipi_id
           , l.item_id
           , l.excecao_ii_id
           , l.excecao_ipi_id
           , cmx_pkg_itens.codigo(l.item_id)      item_codigo
           , cmx_pkg_itens.ncm(l.item_id)         item_ncm_id
        FROM imp_licencas_lin  l
           , imp_invoices      i
       WHERE l.invoice_id    = i.invoice_id
         AND l.embarque_id   = pn_embarque_id
         AND ( l.ex_ncm_id   IS NOT NULL
             OR l.ex_ipi_id  IS NOT NULL
             )
        ORDER BY l.linha_num;

    CURSOR cur_declaracao_lin IS
      SELECT l.linha_num
           , i.invoice_num
           , l.ex_ncm_id
           , l.ex_ipi_id
           , l.item_id
           , l.excecao_ii_id
           , l.excecao_ipi_id
           , cmx_pkg_itens.codigo(l.item_id)      item_codigo
           , cmx_pkg_itens.ncm(l.item_id)         item_ncm_id
        FROM imp_declaracoes_lin  l
           , imp_invoices         i
       WHERE l.invoice_id    = i.invoice_id
         AND l.declaracao_id = pn_declaracao_id
         AND ( l.ex_ncm_id   IS NOT NULL
             OR l.ex_ipi_id  IS NOT NULL
             )
        ORDER BY l.linha_num;

    CURSOR cur_ex_tarifario(pn_ex_id NUMBER) IS
      SELECT ncm_id, numero
        FROM imp_ex_tarifario
       WHERE ex_tarifario_id = pn_ex_id;

    CURSOR cur_excecao_fiscal(pn_excecao_id NUMBER) IS
      SELECT descricao
        FROM imp_excecoes_fiscais
       WHERE excecao_id = pn_excecao_id;

    vc_log_tipo  VARCHAR2(1000);
    vc_log_desc  VARCHAR2(32767);
    vc_log_solu  VARCHAR2(32767);
    vn_ncm_id    NUMBER;
    vn_numero    NUMBER;
    vc_excecao   VARCHAR2(150);
    vb_achou     BOOLEAN;
  BEGIN
    FOR ivc IN 1..vn_global_ivc_lin LOOP

      vn_ncm_id := tb_ivc_lin(ivc).class_fiscal_id;

      cmx_prc_validar_ncm ( pn_declaracao_id => pn_declaracao_id
                          , pc_flag_dsi      => pc_dsi
                          , pn_item_id       => tb_ivc_lin(ivc).item_id
                          , pc_substitui_ncm => 'N'
                          , pn_ncm_id        => vn_ncm_id
                          , pc_log_tipo      => vc_log_tipo
                          , pc_log_desc      => vc_log_desc
                          , pc_log_solu      => vc_log_solu );

      IF(vc_log_tipo = 'E')THEN
        prc_gera_log_erros ( vc_log_desc||Chr(10)||vc_log_solu
                           , vc_log_tipo
                           , 'A' );
      END IF;

    END LOOP;

    ----------------------------------------------------------------------------
    -- Delivery 102268: Verificar se NCM de um item vinculado a um EX (II ou IPI) é a mesma
    --                  NCM inserida no cadastro do material
    ----------------------------------------------------------------------------
    IF(pn_declaracao_id IS NOT NULL) THEN
      FOR x IN cur_declaracao_lin LOOP

        IF(x.ex_ipi_id IS NOT NULL) THEN

          OPEN  cur_excecao_fiscal(x.excecao_ipi_id);
          FETCH cur_excecao_fiscal INTO vc_excecao;
          CLOSE cur_excecao_fiscal;

          vb_achou  := FALSE;
          vn_ncm_id := NULL;
          vn_numero := NULL;
          OPEN  cur_ex_tarifario(x.ex_ipi_id);
          FETCH cur_ex_tarifario INTO vn_ncm_id, vn_numero;
          vb_achou := cur_ex_tarifario%FOUND;
          CLOSE cur_ex_tarifario;

          IF(vb_achou AND x.item_ncm_id <> vn_ncm_id) THEN
            prc_gera_log_erros ( 'Linha ['||x.linha_num||'] - A NCM ['||cmx_pkg_itens.ncm_codigo(x.item_id)||'] do item ['||x.item_codigo||'] está diferente '||
                                 'da NCM ['||cmx_pkg_classificacao.codigo(vn_ncm_id, 1)||'] vinculada ao '||
                                 'EX Tarifário ['||LPad(vn_numero,3,'0')||'] - Exceção fiscal ['||vc_excecao||'].'
                               , 'E'
                               , 'A'
                               , 'Altere a NCM no cadastro do material ou revise o cadastro da exceção fiscal vinculado ao EX Tarifário para prosseguir com o processo.'
                               );
          END IF;
        END IF;

        IF(x.ex_ncm_id IS NOT NULL) THEN

          OPEN  cur_excecao_fiscal(x.excecao_ii_id);
          FETCH cur_excecao_fiscal INTO vc_excecao;
          CLOSE cur_excecao_fiscal;

          vb_achou  := FALSE;
          vn_ncm_id := NULL;
          vn_numero := NULL;
          OPEN  cur_ex_tarifario(x.ex_ncm_id);
          FETCH cur_ex_tarifario INTO vn_ncm_id, vn_numero;
          vb_achou := cur_ex_tarifario%FOUND;
          CLOSE cur_ex_tarifario;

          IF(vb_achou AND x.item_ncm_id <> vn_ncm_id) THEN
            prc_gera_log_erros ( 'Linha ['||x.linha_num||'] - A NCM ['||cmx_pkg_itens.ncm_codigo(x.item_id)||'] do item ['||x.item_codigo||'] está diferente '||
                                 'da NCM ['||cmx_pkg_classificacao.codigo(vn_ncm_id, 1)||'] vinculada ao '||
                                 'EX Tarifário ['||LPad(vn_numero,3,'0')||'] - Exceção fiscal ['||vc_excecao||'].'
                               , 'E'
                               , 'A'
                               , 'Altere a NCM no cadastro do material ou revise o cadastro da exceção fiscal vinculado ao EX Tarifário para prosseguir com o processo.'
                               );
          END IF;

        END IF;

      END LOOP;

    ELSE
      FOR x IN cur_licenca_lin LOOP

        IF(x.ex_ipi_id IS NOT NULL) THEN

          OPEN  cur_excecao_fiscal(x.excecao_ipi_id);
          FETCH cur_excecao_fiscal INTO vc_excecao;
          CLOSE cur_excecao_fiscal;

          vb_achou  := FALSE;
          vn_ncm_id := NULL;
          vn_numero := NULL;
          OPEN  cur_ex_tarifario(x.ex_ipi_id);
          FETCH cur_ex_tarifario INTO vn_ncm_id, vn_numero;
          vb_achou := cur_ex_tarifario%FOUND;
          CLOSE cur_ex_tarifario;

          IF(vb_achou AND x.item_ncm_id <> vn_ncm_id) THEN
            prc_gera_log_erros ( 'Linha ['||x.linha_num||'] - A NCM ['||cmx_pkg_itens.ncm_codigo(x.item_id)||'] do item ['||x.item_codigo||'] está diferente '||
                                'da NCM ['||cmx_pkg_classificacao.codigo(vn_ncm_id, 1)||'] vinculada ao '||
                                'EX Tarifário ['||LPad(vn_numero,3,'0')||'] - Exceção fiscal ['||vc_excecao||'].'
                              , 'E'
                              , 'A'
                              , 'Altere a NCM no cadastro do material ou revise o cadastro da exceção fiscal vinculado ao EX Tarifário para prosseguir com o processo.'
                              );
          END IF;
        END IF;

        IF(x.ex_ncm_id IS NOT NULL) THEN

          OPEN  cur_excecao_fiscal(x.excecao_ii_id);
          FETCH cur_excecao_fiscal INTO vc_excecao;
          CLOSE cur_excecao_fiscal;

          vb_achou  := FALSE;
          vn_ncm_id := NULL;
          vn_numero := NULL;
          OPEN  cur_ex_tarifario(x.ex_ncm_id);
          FETCH cur_ex_tarifario INTO vn_ncm_id, vn_numero;
          vb_achou := cur_ex_tarifario%FOUND;
          CLOSE cur_ex_tarifario;

          IF (vb_achou AND x.item_ncm_id <> vn_ncm_id) THEN
            prc_gera_log_erros ( 'Linha ['||x.linha_num||'] - A NCM ['||cmx_pkg_itens.ncm_codigo(x.item_id)||'] do item ['||x.item_codigo||'] está diferente '||
                                'da NCM ['||cmx_pkg_classificacao.codigo(vn_ncm_id, 1)||'] vinculada ao '||
                                'EX Tarifário ['||LPad(vn_numero,3,'0')||'] - Exceção fiscal ['||vc_excecao||'].'
                              , 'E'
                              , 'A'
                              , 'Altere a NCM no cadastro do material ou revise o cadastro da exceção fiscal vinculado ao EX Tarifário para prosseguir com o processo.'
                              );
          END IF;
        END IF;
      END LOOP;
    END IF;
  END prc_validar_ncm;

  -- ***********************************************************************
  -- Procedure para carregar parametros utilizados pela rotina
  -- ***********************************************************************
  PROCEDURE imp_prc_carrega_parametros (pn_empresa_id  NUMBER) IS
    CURSOR cur_empresas_param IS
      SELECT nvl(tp_base_seguro,'F')
           , nvl(taxa_utilizacao_fixa,0)
           , deduz_po_com_termo_pgto
           , embutir_ii_base_piscofins
           , cmx_pkg_tabelas.codigo (data_base_seguro_id) data_base_seguro
           , incidir_perc_red_aliq_icms_pc
           , aprova_numerarios_automatico
           , tp_basecalc_recebto_a_maior
           , nvl (calcula_icms_com_impostos_dev, 'N')
           , nvl (calcula_icms_com_impost_dev_de, 'N')
           , nvl (calcula_icms_com_ipt_dev_recof, 'N')
           , nvl (base_icms_consumo_adm_tmp, 'I')
           , nvl (calcula_icms_com_ipt_dev_drw, 'N')      calcula_icms_com_ipt_dev_drw
        FROM imp_empresas_param
       WHERE empresa_id = pn_empresa_id;

    vb_achou_param  BOOLEAN := FALSE;

  BEGIN
    OPEN  cur_empresas_param;
    FETCH cur_empresas_param INTO vc_global_tp_base_seguro
                                , vc_global_tx_util_fixa
                                , vc_global_deduz_po_termo
                                , vc_global_embute_ii_bc_piscof
                                , vc_global_data_base_seguro
                                , vc_global_incide_aliq_icms_pc
                                , vc_global_aprov_num_auto
                                , vc_global_tpbase_retif_a_maior
                                , vc_global_calc_icms_imp_dev
                                , vc_global_calc_icms_imp_dev_de
                                , vc_global_calc_icms_ip_dev_rcf
                                , vc_global_bicms_cons_adm_temp
                                , vc_global_calc_icms_ip_dev_drw
                                ;
    vb_achou_param := cur_empresas_param%FOUND;
    CLOSE cur_empresas_param;

    IF NOT vb_achou_param THEN
      prc_gera_log_erros ('Empresa do embarque não parametrizada...', 'E', 'A');
    END IF;
  END imp_prc_carrega_parametros;

  -- ***********************************************************************
  -- Rotina para busca de taxa de conversão
  -- ***********************************************************************
  PROCEDURE imp_prc_busca_taxa_conversao (pn_moeda_id             NUMBER,
                                          pd_data_totalizar       DATE,
                                          pn_taxa_mn         OUT  NUMBER,
                                          pn_taxa_us         OUT  NUMBER,
                                          pc_complemento          VARCHAR2 ) IS
  BEGIN
    pn_taxa_mn := 0;
    pn_taxa_us := 0;

    IF (Nvl (pn_moeda_id, 0) <> 0) THEN
      IF (pd_data_totalizar IS NOT null) THEN

        cmx_pkg_taxas.prc_taxa_mn_par_us_local_opc (
               pn_moeda_id
             , pd_data_totalizar
             , 'FISCAL'
             , pn_taxa_mn
             , pn_taxa_us
            );

        IF (pn_taxa_mn IS null AND pn_taxa_us IS null) THEN
          prc_gera_log_erros
           ( cmx_fnc_texto_traduzido
              ( 'Taxas não encontradas... (Moeda: @@01@@  Data: @@02@@ ) - @@03 .'
              , 'imp_pkg_totaliza_ebq'
              , '004'
              , NULL
              , cmx_pkg_tabelas.codigo (pn_moeda_id)
              , to_char(pd_data_totalizar,'dd/mm/rrrr')
              , pc_complemento )
           , 'E'
           , 'A');
        ELSE
          IF ( nvl( pn_taxa_mn,0)  = 0 ) THEN
            prc_gera_log_erros
             ( cmx_fnc_texto_traduzido
                ( 'Taxa para BRL moeda zerada... (Moeda: @@01@@ Data: @@02@@) - @@03@@'
                , 'imp_pkg_totaliza_ebq'
                , '005'
                , NULL
                , cmx_pkg_tabelas.codigo (pn_moeda_id)
                , to_char(pd_data_totalizar,'dd/mm/rrrr')
                , pc_complemento )
             , 'E'
             , 'A');
          END IF;

          IF ( nvl( pn_taxa_us,0)  = 0 ) THEN
            prc_gera_log_erros
             ( cmx_fnc_texto_traduzido
                ( 'Paridade para USD zerada... (Moeda: @@01@@  Data: @@02@@)  - @@03'  , 'E', 'A'
                , 'imp_pkg_totaliza_ebq'
                , '006'
                , NULL
                , cmx_pkg_tabelas.codigo (pn_moeda_id)
                , To_Char(pd_data_totalizar, 'DD/MM/RRRR')
                , pc_complemento
                )
             , 'E'
             , 'A');
          END IF;
        END IF;
      ELSE
        prc_gera_log_erros
         ( cmx_fnc_texto_traduzido
            ( 'Data não informada para a busca das taxas de conversão... ( @@01@@ ) '
            , 'imp_pkg_totaliza_ebq'
            , '007'
            , NULL
            , To_Char(pd_data_totalizar, 'DD/MM/RRRR'))
         , 'E'
         , 'A');
      END IF;
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros
       ( cmx_fnc_texto_traduzido
          ( 'Erro na busca da taxa de conversão: '
          , 'imp_pkg_totaliza_ebq'
          , '008'
          , NULL
          , SQLERRM )
       , 'E'
       , 'A'
       );
  END imp_prc_busca_taxa_conversao;

  -- ***********************************************************************
  -- Procedure imp_ajusta_valores_acresded
  -- ajusta os valores de acrescimo/deducao se o valor for menor que 1 centavo
  -- tira um centavo da adicao que tiver a mesma linha da invoice com maior valor
  -- ***********************************************************************
  PROCEDURE prc_ajusta_valores_acresded ( pn_declaracao_id  IN NUMBER
                                        , pd_data_conversao IN DATE
                                        , pn_ultima_adi_ad  IN NUMBER
                                        , ptb_ad_adi        IN OUT nocopy TB_ADI_ACRESDED
                                        )
  AS

  CURSOR cur_adi_ad
      IS
  SELECT declaracao_adi_id
       , acres_ded_id
       , moeda_id
       , valor_m
       , valor_mn
    FROM imp_dcl_adi_acresded
   WHERE declaracao_id = pn_declaracao_id
     AND Round(valor_m,2) < 0.01;

  CURSOR cur_adi(pn_declaracao_adi_id NUMBER, pn_acres_ded_id NUMBER)
      IS
  SELECT idaad.declaracao_adi_id
       , idaad.valor_mn / nullif(idaad.valor_m,0) taxa_mn
    FROM imp_dcl_adi_acresded idaad
   WHERE idaad.acres_ded_id = pn_acres_ded_id
     AND idaad.declaracao_adi_id IN (SELECT idl2.declaracao_adi_id
                                       FROM imp_declaracoes_lin idl1
                                          , imp_declaracoes_lin idl2
                                      WHERE idl1.invoice_lin_id    = idl2.invoice_lin_id
                                        AND idl1.declaracao_id     = idl2.declaracao_id
                                        AND idl1.declaracao_adi_id = pn_declaracao_adi_id)
     AND idaad.valor_m > 0.01
ORDER BY idaad.valor_m DESC;


  vn_taxa_mn        NUMBER := 0;
  vn_taxa_us        NUMBER := 0;

  vb_found             BOOLEAN;
  vn_declaracao_adi_id NUMBER;

  BEGIN

    FOR x IN cur_adi_ad
    LOOP
      OPEN cur_adi(x.declaracao_adi_id, x.acres_ded_id);
      FETCH cur_adi INTO vn_declaracao_adi_id, vn_taxa_mn;
      vb_found := cur_adi%FOUND;
      CLOSE cur_adi;

      IF vb_found THEN
        -- obter a taxa
        imp_prc_busca_taxa_conversao(x.moeda_id, pd_data_conversao, vn_taxa_mn, vn_taxa_us, 'Acres./Ded.');

        -- tira um centavo da maior
        UPDATE imp_dcl_adi_acresded
          SET valor_m = valor_m - 0.01
            , valor_mn = Round((valor_m -0.01) * vn_taxa_mn,2)
        WHERE declaracao_adi_id = vn_declaracao_adi_id
          AND acres_ded_id      = x.acres_ded_id;

        -- adiciona um centavo na menor
        UPDATE imp_dcl_adi_acresded
          SET valor_m = valor_m + 0.01
            , valor_mn = Round((valor_m + 0.01) * vn_taxa_mn,2)
        WHERE declaracao_adi_id = x.declaracao_adi_id
          AND acres_ded_id      = x.acres_ded_id;

        -- ajusta os valores da tabela interna
        --FOR i IN ptb_ad_adi.first..ptb_ad_adi.last
        --LOOP
        --  IF ptb_ad_adi(i).declaracao_adi_id = vn_declaracao_adi_id AND ptb_ad_adi(i).acres_ded_id = x.acres_ded_id THEN
        --    ptb_ad_adi(i).valor_m := ptb_ad_adi(i).valor_m - 0.01;
        --    ptb_ad_adi(i).valor_mn := Round((ptb_ad_adi(i).valor_m - 0.01) * vn_taxa_mn,2);
        --  END IF;
        --
        --  IF ptb_ad_adi(i).declaracao_adi_id = x.declaracao_adi_id AND ptb_ad_adi(i).acres_ded_id = x.acres_ded_id THEN
        --    ptb_ad_adi(i).valor_m := ptb_ad_adi(i).valor_m + 0.01;
        --    ptb_ad_adi(i).valor_mn := Round((ptb_ad_adi(i).valor_m + 0.01) * vn_taxa_mn,2);
        --  END IF;
        --
        --END LOOP;

      --ELSE
      --  -- tira os valores zerados.
      --  DELETE FROM imp_dcl_adi_acresded
      --   WHERE declaracao_adi_id = x.declaracao_adi_id
      --     AND acres_ded_id      = x.acres_ded_id;
      --
      --  prc_gera_log_erros ('Não é possível ajustar os acréscimos das adições pois não há de onde tirar o valor mínimo.', 'A', 'D');
      END IF;

    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      prc_gera_log_erros ('Ajuste dos acréscimos e deduções' || sqlerrm, 'E', 'D');
  END; -- prc_ajusta_valores_acresded

  -- ***********************************************************************
  -- Procedure que verifica o tipo do embarque, caso for DI_UNICA alguns
  -- valores serão calculados diferentemente.
  -- ***********************************************************************
  PROCEDURE prc_verif_di_unica (pn_embarque_id  NUMBER) IS

    CURSOR cur_tp_embarque IS
      SELECT tp_embarque_id
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_verif_di_unica(pn_tp_embarque_id NUMBER) IS
      SELECT auxiliar1
        FROM cmx_tabelas
       WHERE tabela_id = pn_tp_embarque_id;

    vn_tp_embarque_id NUMBER;
  BEGIN
    OPEN  cur_tp_embarque;
    FETCH cur_tp_embarque INTO vn_tp_embarque_id;
    CLOSE cur_tp_embarque;

    OPEN  cur_verif_di_unica (vn_tp_embarque_id);
    FETCH cur_verif_di_unica INTO vc_global_verif_di_unica;
    CLOSE cur_verif_di_unica;

  END prc_verif_di_unica;

  -- ***********************************************************************
  -- Esta procedure carregará numa PL/SQL table todas as linhas tipo mercadoria
  -- para evitar outros acessos a tabela IMP_INVOICES.
  -- ***********************************************************************
  PROCEDURE imp_prc_carrega_linhas_ivc (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER) IS
    CURSOR cur_invoices_lin IS
      SELECT iil.invoice_lin_id
           , iil.invoice_id
           , nvl(ii.peso_liquido,0) peso_liquido
           , iil.pesoliq_unit
           , imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) qtde
           , iil.preco_unitario_m
           , iil.nr_linha linha_num
           , ii.flag_fr_embutido
           , ii.flag_sg_embutido
           , ii.moeda_id
           , ii.invoice_num
           , iil.nr_linha
           , decode (nvl (iil.flag_fixa_pesoliq_tot, 'N'), 'S', iil.pesoliq_tot, round (nvl ((iil.pesoliq_unit * imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)), 0), 5)  ) pesoliq_tot
           , cti.codigo    incoterm
           , cti.auxiliar1 tprateio_incoterm
           , substr(cmx_pkg_tabelas.codigo( iil.un_medida_id ),1,20) unidade_medida
           , ii.flag_dsp_ddu_embutida
           , nvl (iil.flag_libera_peso_liquido, 'N') flag_libera_peso_liquido
           , iil.vrt_fr_m
           , iil.vrt_fr_mn
           , iil.vrt_fr_us
           , iil.vrt_fr_prepaid_m
           , iil.vrt_fr_prepaid_mn
           , iil.vrt_fr_prepaid_us
           , iil.vrt_fr_collect_m
           , iil.vrt_fr_collect_mn
           , iil.vrt_fr_collect_us
           , iil.vrt_fr_territorio_nacional_m
           , iil.vrt_fr_territorio_nacional_mn
           , iil.vrt_fr_territorio_nacional_us
           , iil.vrt_fr_total_m
           , iil.vrt_fr_total_mn
           , iil.vrt_fr_total_us
           , iil.vrt_frivc_m
           , iil.vrt_sg_m
           , iil.vrt_sg_mn
           , iil.vrt_sg_us
           , nvl (iil.flag_fixa_pesoliq_tot, 'N') flag_fixa_pesoliq_tot
           , cmx_pkg_tabelas.auxiliar(iil.tp_linha_id,1) tp_linha_codigo
           , iil.class_fiscal_id
           , iil.item_id
           , iil.peso_bruto_nac
           , nvl (iil.flag_fixa_pesobrt_tot, 'N') flag_fixa_pesobrt_tot
           , iil.pesobrt_tot
        FROM imp_invoices         ii
           , imp_invoices_lin     iil
           , cmx_tabelas          cti
       WHERE ii.embarque_id    = pn_embarque_id
         AND iil.invoice_id    = ii.invoice_id
         AND cmx_pkg_tabelas.auxiliar(iil.tp_linha_id,1) = 'M'
         AND cti.tabela_id (+) = ii.incoterm_id
    ORDER BY iil.invoice_id, iil.invoice_lin_id;

    CURSOR cur_nota_fiscal_lin (pn_invoice_lin_id NUMBER) IS
      SELECT inf.numero_nf
        FROM imp_nota_fiscal      inf
           , imp_nota_fiscal_lin  infl
       WHERE inf.dt_cancel IS null
         AND infl.nota_fiscal_id = inf.nota_fiscal_id
         AND infl.invoice_lin_id = pn_invoice_lin_id;

    CURSOR cur_peso_liquido_DA_di (pn_invoice_lin_id_nac NUMBER) IS
      SELECT sum ((iil_da.pesoliq_tot / imp_fnc_qtde_laudo(iil_da.invoice_lin_id, iil_da.laudo_id, iil_da.qtde, iil_da.qtde_descarregada)) * idl.qtde) peso_liq_proporcional
           , sum ((iil_da.pesobrt_tot / imp_fnc_qtde_laudo(iil_da.invoice_lin_id, iil_da.laudo_id, iil_da.qtde, iil_da.qtde_descarregada)) * idl.qtde) peso_brt_proporcional
           , idl.da_lin_id
           , idl.declaracao_lin_id
        FROM imp_declaracoes_lin idlda
           , imp_invoices_lin    iil_da
           , imp_declaracoes_lin idl
       WHERE iil_da.invoice_lin_id    = idlda.invoice_lin_id
         AND idlda.declaracao_lin_id  = idl.da_lin_id
         AND idl.invoice_lin_id       = pn_invoice_lin_id_nac
         AND idl.licenca_id          IS null
       GROUP BY idl.da_lin_id, idl.declaracao_lin_id;

    CURSOR cur_peso_liquido_DA_li (pn_invoice_lin_id_nac NUMBER) IS
      SELECT sum ((iil_da.pesoliq_tot / imp_fnc_qtde_laudo(iil_da.invoice_lin_id, iil_da.laudo_id, iil_da.qtde, iil_da.qtde_descarregada)) * ill.qtde) peso_liq_proporcional
           , sum ((iil_da.pesobrt_tot / imp_fnc_qtde_laudo(iil_da.invoice_lin_id, iil_da.laudo_id, iil_da.qtde, iil_da.qtde_descarregada)) * ill.qtde) peso_brt_proporcional
           , ill.da_lin_id
           , ill.licenca_lin_id
        FROM imp_declaracoes_lin idlda
           , imp_invoices_lin    iil_da
           , imp_licencas_lin    ill
       WHERE iil_da.invoice_lin_id   = idlda.invoice_lin_id
         AND idlda.declaracao_lin_id = ill.da_lin_id
         AND ill.invoice_lin_id      = pn_invoice_lin_id_nac
       GROUP BY ill.da_lin_id, ill.licenca_lin_id;

    CURSOR cur_tp_embarque IS
      SELECT ebq.tp_embarque_id
        FROM imp_embarques ebq
           , cmx_tabelas   tp_ebq
       WHERE ebq.embarque_id     = pn_embarque_id
         AND ebq.tp_embarque_id  = tp_ebq.tabela_id
         AND tp_ebq.auxiliar1    = 'NAC'
         AND tp_ebq.auxiliar9   IN ('DE', 'DAF');

    pn_erro_peso_liquido NUMBER := 0;
    vn_numero_nf         NUMBER := null;
    vn_vrt_frete_mn      NUMBER := 0;
    vn_vrt_seguro_mn     NUMBER := 0;
    vn_dummy             NUMBER  := 0;
    vn_pesoliq_tot_da    NUMBER  := 0;
    vb_ebq_nac_de_daf    BOOLEAN := false;

  BEGIN
    OPEN  cur_tp_embarque;
    FETCH cur_tp_embarque INTO vn_dummy;
    vb_ebq_nac_de_daf := cur_tp_embarque%FOUND;
    CLOSE cur_tp_embarque;

    FOR ivc IN cur_invoices_lin LOOP
      vn_pesoliq_tot_da   := 0;
      vn_global_ivc_lin   := vn_global_ivc_lin + 1;

      tb_ivc_lin(vn_global_ivc_lin).invoice_lin_id           := ivc.invoice_lin_id;
      tb_ivc_lin(vn_global_ivc_lin).invoice_id               := ivc.invoice_id;
      tb_ivc_lin(vn_global_ivc_lin).invoice_num              := ivc.invoice_num;
      tb_ivc_lin(vn_global_ivc_lin).linha_num                := ivc.linha_num;
      tb_ivc_lin(vn_global_ivc_lin).qtde                     := ivc.qtde;
      tb_ivc_lin(vn_global_ivc_lin).preco_unitario_m         := ivc.preco_unitario_m;
      tb_ivc_lin(vn_global_ivc_lin).tp_linha_codigo          := ivc.tp_linha_codigo;
      tb_ivc_lin(vn_global_ivc_lin).class_fiscal_id          := ivc.class_fiscal_id;
      tb_ivc_lin(vn_global_ivc_lin).item_id                  := ivc.item_id;
      tb_ivc_lin(vn_global_ivc_lin).peso_bruto_nac           := ivc.peso_bruto_nac;

      IF (pn_tp_declaracao = 17) OR (vb_ebq_nac_de_daf) THEN
        FOR da_di IN cur_peso_liquido_DA_di (ivc.invoice_lin_id) LOOP
          vn_global_ivc_lin_da := vn_global_ivc_lin_da + 1;

          tb_ivc_lin_da(vn_global_ivc_lin_da).invoice_lin_id           := ivc.invoice_lin_id;
          tb_ivc_lin_da(vn_global_ivc_lin_da).da_lin_id                := da_di.da_lin_id;
          tb_ivc_lin_da(vn_global_ivc_lin_da).da_peso_liq_proporcional := da_di.peso_liq_proporcional;
          tb_ivc_lin_da(vn_global_ivc_lin_da).da_peso_brt_proporcional := da_di.peso_brt_proporcional;
          tb_ivc_lin_da(vn_global_ivc_lin_da).declaracao_lin_id        := da_di.declaracao_lin_id;

          vn_pesoliq_tot_da := vn_pesoliq_tot_da + da_di.peso_liq_proporcional;
        END LOOP;

        FOR da_li IN cur_peso_liquido_DA_li (ivc.invoice_lin_id) LOOP
          vn_global_ivc_lin_da := vn_global_ivc_lin_da + 1;

          tb_ivc_lin_da(vn_global_ivc_lin_da).invoice_lin_id           := ivc.invoice_lin_id;
          tb_ivc_lin_da(vn_global_ivc_lin_da).da_lin_id                := da_li.da_lin_id;
          tb_ivc_lin_da(vn_global_ivc_lin_da).da_peso_liq_proporcional := da_li.peso_liq_proporcional;
          tb_ivc_lin_da(vn_global_ivc_lin_da).da_peso_brt_proporcional := da_li.peso_brt_proporcional;
          tb_ivc_lin_da(vn_global_ivc_lin_da).licenca_lin_id           := da_li.licenca_lin_id;

          vn_pesoliq_tot_da := vn_pesoliq_tot_da + da_li.peso_liq_proporcional;
        END LOOP;

        IF (vn_pesoliq_tot_da = 0) THEN
          vn_pesoliq_tot_da := ivc.pesoliq_tot;
        END IF;

        tb_ivc_lin(vn_global_ivc_lin).pesoliq_tot            := vn_pesoliq_tot_da;

      ELSE
        tb_ivc_lin(vn_global_ivc_lin).pesoliq_tot            := ivc.pesoliq_tot;
      END IF;

      tb_ivc_lin(vn_global_ivc_lin).pesoliq_unit             := ivc.pesoliq_unit;
      tb_ivc_lin(vn_global_ivc_lin).pesoliq_tot_ivc          := ivc.peso_liquido;
      tb_ivc_lin(vn_global_ivc_lin).flag_fr_embutido         := ivc.flag_fr_embutido;
      tb_ivc_lin(vn_global_ivc_lin).flag_sg_embutido         := ivc.flag_sg_embutido;
      tb_ivc_lin(vn_global_ivc_lin).vrt_fob_m                := round(ivc.preco_unitario_m * ivc.qtde,2);
      tb_ivc_lin(vn_global_ivc_lin).moeda_fob_id             := ivc.moeda_id;
      tb_ivc_lin(vn_global_ivc_lin).incoterm                 := ivc.incoterm;
      tb_ivc_lin(vn_global_ivc_lin).tprateio_incoterm        := ivc.tprateio_incoterm;
      tb_ivc_lin(vn_global_ivc_lin).unidade_medida           := ivc.unidade_medida;
      tb_ivc_lin(vn_global_ivc_lin).flag_dsp_ddu_embutida    := ivc.flag_dsp_ddu_embutida;
      tb_ivc_lin(vn_global_ivc_lin).flag_libera_peso_liquido := ivc.flag_libera_peso_liquido;
      tb_ivc_lin(vn_global_ivc_lin).flag_fixa_pesoliq_tot    := ivc.flag_fixa_pesoliq_tot;
      tb_ivc_lin(vn_global_ivc_lin).flag_fixa_pesobrt_tot    := ivc.flag_fixa_pesobrt_tot;
      tb_ivc_lin(vn_global_ivc_lin).pesobrt_tot              := ivc.pesobrt_tot;

      --------------------------------------------------------------------------------------------------
      -- Esses campos somente serão preenchidos quando a totalização for de uma declaração que está
      -- sendo retificada. Iremos guardar esses valores pois quando for efetuado o novo rateio do
      -- frete o sistema permaneça com os rateios para linhas que já tem nota fiscal gerada.
      --------------------------------------------------------------------------------------------------
      vn_numero_nf := null;

      IF vc_global_tpbase_retif_a_maior = 'F' THEN
        OPEN  cur_nota_fiscal_lin (ivc.invoice_lin_id);
        FETCH cur_nota_fiscal_lin INTO vn_numero_nf;
        CLOSE cur_nota_fiscal_lin;
      END IF;

      IF (vn_numero_nf IS NOT null) THEN
        tb_ivc_lin(vn_global_ivc_lin).numero_nf                     := vn_numero_nf;

        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_m                      := ivc.vrt_fr_m;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_total_m                := ivc.vrt_fr_total_m;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_prepaid_m              := ivc.vrt_fr_prepaid_m;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_collect_m              := ivc.vrt_fr_collect_m;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_territorio_nacional_m  := ivc.vrt_fr_territorio_nacional_m;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_mn                     := ivc.vrt_fr_mn;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_total_mn               := ivc.vrt_fr_total_mn;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_prepaid_mn             := ivc.vrt_fr_prepaid_mn;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_collect_mn             := ivc.vrt_fr_collect_mn;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_territorio_nacional_mn := ivc.vrt_fr_territorio_nacional_mn;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_us                     := ivc.vrt_fr_us;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_total_us               := ivc.vrt_fr_total_us;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_prepaid_us             := ivc.vrt_fr_prepaid_us;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_collect_us             := ivc.vrt_fr_collect_us;
        tb_ivc_lin(vn_global_ivc_lin).vrt_fr_territorio_nacional_us := ivc.vrt_fr_territorio_nacional_us;
        tb_ivc_lin(vn_global_ivc_lin).vrt_frivc_m                   := ivc.vrt_frivc_m;
        tb_ivc_lin(vn_global_ivc_lin).vrt_sg_m                      := ivc.vrt_sg_m;
        tb_ivc_lin(vn_global_ivc_lin).vrt_sg_mn                     := ivc.vrt_sg_mn;
        tb_ivc_lin(vn_global_ivc_lin).vrt_sg_us                     := ivc.vrt_sg_us;
      END IF;
      --------------------------------------------------------------------------------------------------

      IF (nvl(ivc.pesoliq_unit,0) = 0) AND (ivc.flag_fixa_pesoliq_tot = 'N') THEN
        prc_gera_log_erros ('Invoice '||ivc.invoice_num||', linha '||ivc.nr_linha||': Peso líquido zerado.', 'A', 'A');
        pn_erro_peso_liquido := pn_erro_peso_liquido + 1;
      END IF;
    END LOOP;

    IF (pn_erro_peso_liquido > 0) THEN
      prc_gera_log_erros ('Existem linhas de invoice com peso líquido zerado.','E','A');
    END IF;

    IF (vn_global_ivc_lin = 0) THEN
      prc_gera_log_erros ('Não existem linhas de invoice...', 'E', 'A');
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro ao carregar as linhas da invoice: ' || sqlerrm, 'E', 'A');
  END imp_prc_carrega_linhas_ivc;

  -- ***********************************************************************
  -- Carga de linhas de declaração de nacionalização
  -- ***********************************************************************
  PROCEDURE imp_prc_carrega_linhas_dcl_nac (pn_declaracao_id NUMBER, pd_data_conversao DATE) IS
    CURSOR cur_declaracoes_lin_nac IS
      SELECT ida.declaracao_adi_id
           , idl.declaracao_lin_id
           , ida.moeda_id
           , ida.da_moeda_frete_id
           , ida.da_moeda_seguro_id
           , idda.moeda_frete_id      da_moeda_frete_id_original
           , idda.moeda_seguro_id     da_moeda_seguro_id_original
           , imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, idl.qtde, iil.qtde_descarregada) qtde
           , ((iil.vrt_fob_m                     / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fob_m
           , ((iil.vrt_dspfob_m                  / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_dspfob_m
           , ((iil.vrt_fr_m                      / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_m
           , ((iil.vrt_fr_total_m                / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_total_m
           , ((iil.vrt_fr_prepaid_m              / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_prepaid_m
           , ((iil.vrt_fr_collect_m              / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_collect_m
           , ((iil.vrt_fr_territorio_nacional_m  / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_territorio_nacional_m
           , ((iil.vrt_sg_m                      / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_sg_m
           , ((iil.vrt_sg_us                     / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_sg_us
           , ((iil.vrt_dsp_ddu_m                 / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_dsp_ddu_m
           , nvl((iil.pesoliq_tot                / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)), 0)          pesoliq_unit
           , nvl((iil.pesobrt_tot                / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)), 0)          pesobrt_unit
           , ((iil.vrt_fr_us                     / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_us
           , ((iil.vrt_fr_total_us               / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_total_us
           , ((iil.vrt_fr_prepaid_us             / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_prepaid_us
           , ((iil.vrt_fr_collect_us             / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_collect_us
           , ((iil.vrt_fr_territorio_nacional_us / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_fr_territorio_nacional_us
           , idl.linha_num
           , idl.licenca_id
           , idl.regtrib_icms_id
           , idl.invoice_lin_id
           , idl.invoice_id
           , cticms.codigo       regtrib_icms
           , idl.aliq_icms
           , idl.aliq_icms_red
           , idl.perc_red_icms
           , idl.aliq_icms_fecp
           , ctd.codigo          tp_declaracao
           , idl.rd_id
           , cticms.auxiliar1    sit_tributaria
           , ctd.auxiliar1       tpdcl_calcula_icms
           , cmx_pkg_tabelas.auxiliar (ida.motivo_sem_cobertura_id,1)     mscob_calcula_icms
           , 'S' tpato_calcula_icms
           , nvl(idl.aliq_pis   ,0) aliq_pis
           , nvl(idl.aliq_cofins,0) aliq_cofins
           , nvl(idl.perc_reducao_base_pis_cofins,0) perc_reducao_base_pis_cofins
           , idl.regtrib_pis_cofins_id
           , idl.tipo_unidade_medida_antid
           , idl.somatoria_quantidade
           , idl.aliq_antid_especifica
           , idl.aliq_antid
           , cti.codigo    incoterm
           , cti.auxiliar1 tprateio_incoterm
           , cmx_pkg_tabelas.codigo(idl.regtrib_ii_id) regtrib_ii
           , cmx_pkg_tabelas.codigo(idl.regtrib_ipi_id) regtrib_ipi
           , idl.aliq_ii_rec
           , idl.aliq_ipi_rec
           , idlda.valor_icms valor_icms_da
           , idl.licenca_lin_id
           , idl.aliq_mva
           , idl.pr_aliq_base
           , idl.pr_perc_diferido
           , idl.valor_diferido_icms_pr
           , idl.valor_cred_presumido_pr
           , idl.valor_cred_presumido_pr_devido
           , idl.beneficio_pr_artigo
           , idl.pr_perc_vr_devido
           , idl.pr_perc_minimo_base
           , idl.pr_perc_minimo_suspenso
           , idl.valor_devido_icms_pr
           , idl.valor_perc_vr_devido_icms_pr
           , idl.valor_perc_minimo_base_icms_pr
           , idl.valor_perc_susp_base_icms_pr
           , idl.aliq_cofins_recuperar
           , idl.class_fiscal_id
           , idl.aliq_cofins_reduzida
           , idl.beneficio_suspensao
           , idl.perc_beneficio_suspensao
        FROM imp_declaracoes_lin   idl
           , imp_declaracoes_adi   ida
           , imp_declaracoes_lin   idlda
           , imp_declaracoes       idda
           , imp_invoices_lin      iil
           , imp_declaracoes       id
           , drw_registro_drawback dac
           , cmx_tabelas           cticms
           , cmx_tabelas           ctd
           , cmx_tabelas           cti
       WHERE id.declaracao_id          = pn_declaracao_id
         AND idl.declaracao_id         = id.declaracao_id
         AND ida.declaracao_adi_id     = idl.declaracao_adi_id
         AND idlda.declaracao_lin_id   = idl.da_lin_id
         and idda.declaracao_id        = idlda.declaracao_id
         AND iil.invoice_lin_id        = idlda.invoice_lin_id
         AND dac.rd_id(+)              = idl.rd_id
         AND cticms.tabela_id          = idl.regtrib_icms_id
         AND ctd.tabela_id             = id.tp_declaracao_id
         AND cti.tabela_id             = ida.incoterm_id
       ORDER BY idl.invoice_id
              , idl.invoice_lin_id;

    vn_taxa_mn                NUMBER := 0;
    vn_taxa_us                NUMBER := 0;
    vn_dummy                  NUMBER;
    vn_taxa_fob_mn            NUMBER := 0;
    vn_taxa_fr_mn             NUMBER := 0;
    vn_taxa_sg_mn             NUMBER := 0;

    vn_da_moeda_frete_id      NUMBER := 0;
    vn_da_vrt_fr_m            NUMBER := 0;
    vn_da_vrt_fr_total_m      NUMBER := 0;
    vn_da_vrt_fr_prepaid_m    NUMBER := 0;
    vn_da_vrt_fr_collect_m    NUMBER := 0;
    vn_da_vrt_fr_tnacional_m  NUMBER := 0;
    vn_da_moeda_seguro_id     NUMBER := 0;
    vn_da_vrt_sg_m            NUMBER := 0;

    vb_moeda_inativa          BOOLEAN := false;

  BEGIN
    FOR dcl IN cur_declaracoes_lin_nac LOOP
      vn_global_dcl_lin := vn_global_dcl_lin + 1;

      vn_da_moeda_frete_id       := dcl.da_moeda_frete_id;
      vn_da_vrt_fr_m             := dcl.vrt_fr_m;
      vn_da_vrt_fr_total_m       := dcl.vrt_fr_total_m;
      vn_da_vrt_fr_prepaid_m     := dcl.vrt_fr_prepaid_m;
      vn_da_vrt_fr_collect_m     := dcl.vrt_fr_collect_m;
      vn_da_vrt_fr_tnacional_m   := dcl.vrt_fr_territorio_nacional_m;

      vn_da_moeda_seguro_id      := dcl.da_moeda_seguro_id;
      vn_da_vrt_sg_m             := dcl.vrt_sg_m;

      IF (cmx_pkg_tabelas.auxiliar (dcl.da_moeda_frete_id_original,7) IS NOT null) THEN
        vn_da_moeda_frete_id     := cmx_pkg_tabelas.auxiliar_tabela_id('906','220',1);
        vn_da_vrt_fr_m           := dcl.vrt_fr_us;
        vn_da_vrt_fr_total_m     := dcl.vrt_fr_total_us;
        vn_da_vrt_fr_prepaid_m   := dcl.vrt_fr_prepaid_us;
        vn_da_vrt_fr_collect_m   := dcl.vrt_fr_collect_us;
        vn_da_vrt_fr_tnacional_m := dcl.vrt_fr_territorio_nacional_us;

        vb_moeda_inativa     := true;
      END IF;

      IF (cmx_pkg_tabelas.auxiliar (dcl.da_moeda_seguro_id_original,7) IS NOT null) THEN
        vn_da_moeda_seguro_id    := cmx_pkg_tabelas.auxiliar_tabela_id('906','220',1);
        vn_da_vrt_sg_m           := dcl.vrt_sg_us;

        vb_moeda_inativa     := true;
      END IF;

      /* Preenche as taxas de conversão para as moedas FOB, FR, SG */
      IF vn_global_dcl_lin = 1 OR nvl (tb_dcl_lin(vn_global_dcl_lin-1).moeda_fob_id, 0) <> dcl.moeda_id THEN
        imp_prc_busca_taxa_conversao (
           dcl.moeda_id
         , pd_data_conversao
         , vn_taxa_fob_mn
         , vn_dummy
         , 'FOB'
        );
      END IF;

      IF vn_global_dcl_lin = 1 OR nvl (tb_dcl_lin(vn_global_dcl_lin-1).moeda_frete_id, 0) <> vn_da_moeda_frete_id THEN
        imp_prc_busca_taxa_conversao (
           vn_da_moeda_frete_id
         , pd_data_conversao
         , vn_taxa_fr_mn
        , vn_dummy
         , 'Frete'
        );
      END IF;

      IF vn_global_dcl_lin = 1 OR nvl (tb_dcl_lin(vn_global_dcl_lin-1).moeda_seguro_id, 0) <> vn_da_moeda_seguro_id THEN
        imp_prc_busca_taxa_conversao (
           vn_da_moeda_seguro_id
         , pd_data_conversao
         , vn_taxa_sg_mn
         , vn_dummy
         , 'Seguro'
        );
      END IF;

      tb_dcl_lin(vn_global_dcl_lin).declaracao_adi_id                   := dcl.declaracao_adi_id;
      tb_dcl_lin(vn_global_dcl_lin).declaracao_lin_id                   := dcl.declaracao_lin_id;
      tb_dcl_lin(vn_global_dcl_lin).invoice_lin_id                      := dcl.invoice_lin_id;
      tb_dcl_lin(vn_global_dcl_lin).invoice_id                          := dcl.invoice_id;
      tb_dcl_lin(vn_global_dcl_lin).moeda_fob_id                        := dcl.moeda_id;
      tb_dcl_lin(vn_global_dcl_lin).moeda_frete_id                      := vn_da_moeda_frete_id;
      tb_dcl_lin(vn_global_dcl_lin).moeda_seguro_id                     := vn_da_moeda_seguro_id;
      tb_dcl_lin(vn_global_dcl_lin).taxa_fob_mn                         := vn_taxa_fob_mn;
      tb_dcl_lin(vn_global_dcl_lin).taxa_fr_mn                          := vn_taxa_fr_mn;
      tb_dcl_lin(vn_global_dcl_lin).taxa_sg_mn                          := vn_taxa_sg_mn;
      tb_dcl_lin(vn_global_dcl_lin).qtde                                := dcl.qtde;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fob_m                           := dcl.vrt_fob_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_dspfob_m                        := dcl.vrt_dspfob_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_m                            := vn_da_vrt_fr_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_total_m                      := vn_da_vrt_fr_total_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_prepaid_m                    := vn_da_vrt_fr_prepaid_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_collect_m                    := vn_da_vrt_fr_collect_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_territorio_nacional_m        := vn_da_vrt_fr_tnacional_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_sg_m                            := vn_da_vrt_sg_m;
      tb_dcl_lin(vn_global_dcl_lin).vrt_dsp_ddu_m                       := dcl.vrt_dsp_ddu_m;
      tb_dcl_lin(vn_global_dcl_lin).pesoliq_unit                        := dcl.pesoliq_unit;
      tb_dcl_lin(vn_global_dcl_lin).pesoliq_tot                         := round (dcl.pesoliq_unit * dcl.qtde, 5); -- Rodrigo Peso



      IF (tb_dcl_lin(vn_global_dcl_lin).pesoliq_tot = 0) THEN
        tb_dcl_lin(vn_global_dcl_lin).pesoliq_tot := 1/100000;
      END IF;

      tb_dcl_lin(vn_global_dcl_lin).pesobrt_unit                        := dcl.pesobrt_unit;
      tb_dcl_lin(vn_global_dcl_lin).pesobrt_tot                         := round (dcl.pesobrt_unit * dcl.qtde, 5); -- Rodrigo Peso

      IF (tb_dcl_lin(vn_global_dcl_lin).pesobrt_tot = 0) THEN
        tb_dcl_lin(vn_global_dcl_lin).pesobrt_tot := 1/100000;
      END IF;
      tb_dcl_lin(vn_global_dcl_lin).linha_num                           := dcl.linha_num;
      tb_dcl_lin(vn_global_dcl_lin).licenca_id                          := dcl.licenca_id;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_icms                        := dcl.regtrib_icms;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_icms_id                     := dcl.regtrib_icms_id;
      tb_dcl_lin(vn_global_dcl_lin).sit_tributaria                      := dcl.sit_tributaria;
      tb_dcl_lin(vn_global_dcl_lin).aliq_icms                           := dcl.aliq_icms;
      tb_dcl_lin(vn_global_dcl_lin).aliq_icms_red                       := dcl.aliq_icms_red;
      tb_dcl_lin(vn_global_dcl_lin).perc_red_icms                       := dcl.perc_red_icms;
      tb_dcl_lin(vn_global_dcl_lin).tp_declaracao                       := dcl.tp_declaracao;
      tb_dcl_lin(vn_global_dcl_lin).rd_id                               := dcl.rd_id;
      tb_dcl_lin(vn_global_dcl_lin).aliq_pis                            := dcl.aliq_pis;
      tb_dcl_lin(vn_global_dcl_lin).aliq_cofins                         := dcl.aliq_cofins;
      tb_dcl_lin(vn_global_dcl_lin).perc_reducao_base_pis_cofins        := dcl.perc_reducao_base_pis_cofins;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_pis_cofins_id               := dcl.regtrib_pis_cofins_id;
      tb_dcl_lin(vn_global_dcl_lin).tpdcl_calcula_icms                  := NVL(dcl.tpdcl_calcula_icms,'S');
      tb_dcl_lin(vn_global_dcl_lin).mscob_calcula_icms                  := NVL(dcl.mscob_calcula_icms,'S');
      tb_dcl_lin(vn_global_dcl_lin).tpato_calcula_icms                  := NVL(dcl.tpato_calcula_icms,'N');
      tb_dcl_lin(vn_global_dcl_lin).incoterm                            := dcl.incoterm;
      tb_dcl_lin(vn_global_dcl_lin).tprateio_incoterm                   := dcl.tprateio_incoterm;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_ii                          := dcl.regtrib_ii;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_ipi                         := dcl.regtrib_ipi;
      tb_dcl_lin(vn_global_dcl_lin).aliq_icms_fecp                      := nvl(dcl.aliq_icms_fecp,0);
      tb_dcl_lin(vn_global_dcl_lin).moeda_inativa                       := vb_moeda_inativa;
      tb_dcl_lin(vn_global_dcl_lin).tipo_unidade_medida_antid           := dcl.tipo_unidade_medida_antid;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid_aliq_especifica         := null;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid_ad_valorem              := null;
      tb_dcl_lin(vn_global_dcl_lin).qtde_um_aliq_especifica_antid       := null;
      tb_dcl_lin(vn_global_dcl_lin).basecalc_antid                      := null;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid                         := null;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid_dev                     := null;
      tb_dcl_lin(vn_global_dcl_lin).somatoria_quantidade                := dcl.somatoria_quantidade;
      tb_dcl_lin(vn_global_dcl_lin).aliq_antid_especifica               := dcl.aliq_antid_especifica;
      tb_dcl_lin(vn_global_dcl_lin).aliq_antid                          := dcl.aliq_antid;
      tb_dcl_lin(vn_global_dcl_lin).aliq_ii_rec                         := dcl.aliq_ii_rec;
      tb_dcl_lin(vn_global_dcl_lin).aliq_ipi_rec                        := dcl.aliq_ipi_rec;
      tb_dcl_lin(vn_global_dcl_lin).valor_icms_da                       := dcl.valor_icms_da;
      tb_dcl_lin(vn_global_dcl_lin).licenca_lin_id                      := dcl.licenca_lin_id;
      tb_dcl_lin(vn_global_dcl_lin).aliq_mva                            := dcl.aliq_mva;
      tb_dcl_lin(vn_global_dcl_lin).pr_aliq_base                        := dcl.pr_aliq_base;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_diferido                    := dcl.pr_perc_diferido;
      tb_dcl_lin(vn_global_dcl_lin).valor_diferido_icms_pr              := dcl.valor_diferido_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_cred_presumido_pr             := dcl.valor_cred_presumido_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_cred_presumido_pr_devido      := dcl.valor_cred_presumido_pr_devido;
      tb_dcl_lin(vn_global_dcl_lin).beneficio_pr_artigo                 := dcl.beneficio_pr_artigo;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_vr_devido                   := dcl.pr_perc_vr_devido;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_minimo_base                 := dcl.pr_perc_minimo_base;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_minimo_suspenso             := dcl.pr_perc_minimo_suspenso;
      tb_dcl_lin(vn_global_dcl_lin).valor_devido_icms_pr                := dcl.valor_devido_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_perc_vr_devido_icms_pr        := dcl.valor_perc_vr_devido_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_perc_minimo_base_icms_pr      := dcl.valor_perc_minimo_base_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_perc_susp_base_icms_pr        := dcl.valor_perc_susp_base_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).aliq_cofins_recuperar               := dcl.aliq_cofins_recuperar;
      tb_dcl_lin(vn_global_dcl_lin).class_fiscal_id                     := dcl.class_fiscal_id;
      tb_dcl_lin(vn_global_dcl_lin).aliq_cofins_reduzida                := dcl.aliq_cofins_reduzida;
      tb_dcl_lin(vn_global_dcl_lin).beneficio_suspensao                 := dcl.beneficio_suspensao;
      tb_dcl_lin(vn_global_dcl_lin).perc_beneficio_suspensao            := dcl.perc_beneficio_suspensao;
    END LOOP;

    IF (vn_global_dcl_lin = 0) THEN
      prc_gera_log_erros ('Não existem linhas de declaração...', 'A', 'D');
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro ao carregar as linhas da declaração: ' || sqlerrm, 'E', 'D');
  END imp_prc_carrega_linhas_dcl_nac;

  -- ***********************************************************************
  -- Esta procedure carregará numa PL/SQL table todas as linhas de declaração
  -- para evitar outros acessos a tabela IMP_DECLARACOES_LIN.
  -- Somente carregaremos as linhas da declaração quando todas as linhas da
  -- invoice tiverem sido incluídas na declaração. Isto ocorre porque temos
  -- que fazer o rateio por adição, e quando temos LI (ou uma linha de invoice
  -- que ainda não foi carregada) as linhas ficarão pendentes até o registro
  -- da licença.
  -- ***********************************************************************
  PROCEDURE imp_prc_carrega_linhas_dcl ( pn_embarque_id    NUMBER
                                       , pn_declaracao_id  NUMBER
                                       , pd_data_conversao DATE) IS
    CURSOR cur_count_invoices_lin IS
      SELECT COUNT (iil.invoice_lin_id) qtde_linhas_ivc
           , iil.invoice_id
        FROM imp_invoices         ii
           , imp_invoices_lin     iil
       WHERE ii.embarque_id   = pn_embarque_id
         AND iil.invoice_id   = ii.invoice_id
         AND (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) - nvl(iil.qtde_utilizada,0)) = 0
         AND cmx_pkg_tabelas.auxiliar (iil.tp_linha_id,1) = 'M'
    GROUP BY iil.invoice_id;

    CURSOR cur_count_declaracoes_lin (pn_invoice_id NUMBER) IS
      SELECT ii.invoice_num
           , COUNT (idl.invoice_lin_id)
        FROM (SELECT DISTINCT
                     invoice_lin_id
                   , invoice_id
                FROM imp_declaracoes_lin
               WHERE declaracao_id = pn_declaracao_id
                 AND invoice_id    = pn_invoice_id
             ) idl
           , imp_invoices ii
       WHERE ii.invoice_id = idl.invoice_id
       GROUP BY ii.invoice_num;

    CURSOR cur_declaracoes_lin IS
      SELECT idl.declaracao_lin_id
           , idl.declaracao_id
           , idl.declaracao_adi_id
           , idl.linha_num
           , idl.invoice_id
           , idl.invoice_lin_id
           , idl.licenca_id
           , imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, idl.qtde, iil.qtde_descarregada) qtde
           , idl.pesoliq_unit
           , idl.regtrib_icms_id
           , cticms.codigo       regtrib_icms
           , idl.aliq_icms
           , idl.aliq_icms_red
           , idl.perc_red_icms
           , ctd.codigo          tp_declaracao
           , idl.rd_id
           , cticms.auxiliar1    sit_tributaria
           , ctd.auxiliar1       tpdcl_calcula_icms
           , ctmsc.auxiliar1     mscob_calcula_icms
           , 'S' tpato_calcula_icms
           , nvl(idl.aliq_pis, 0) aliq_pis
           , nvl(idl.aliq_cofins,0) aliq_cofins
           , nvl(idl.perc_reducao_base_pis_cofins,0) perc_reducao_base_pis_cofins
           , idl.regtrib_pis_cofins_id
           , id.tempo_permanencia
           , cmx_pkg_tabelas.codigo(idl.regtrib_ii_id) regtrib_ii
           , cmx_pkg_tabelas.codigo(idl.regtrib_ipi_id) regtrib_ipi
           , idl.aliq_icms_fecp
           , idl.tipo_unidade_medida_antid
           , idl.somatoria_quantidade
           , idl.aliq_antid_especifica
           , idl.aliq_antid
           , idl.licenca_lin_id
           , idl.aliq_mva
           , idl.pr_aliq_base
           , idl.pr_perc_diferido
           , idl.valor_diferido_icms_pr
           , idl.valor_cred_presumido_pr
           , idl.valor_cred_presumido_pr_devido
           , idl.beneficio_pr_artigo
           , idl.pr_perc_vr_devido
           , idl.pr_perc_minimo_base
           , idl.pr_perc_minimo_suspenso
           , idl.valor_devido_icms_pr
           , idl.valor_perc_vr_devido_icms_pr
           , idl.valor_perc_minimo_base_icms_pr
           , idl.valor_perc_susp_base_icms_pr
           , idl.aliq_cofins_recuperar
           , idl.class_fiscal_id
           , idl.aliq_cofins_reduzida
           , idl.beneficio_suspensao
           , idl.perc_beneficio_suspensao
        FROM imp_declaracoes_lin      idl
           , imp_declaracoes_adi      ida
           , imp_declaracoes          id
           , imp_invoices_lin         iil
           , drw_registro_drawback    dac
           , cmx_tabelas              cticms
           , cmx_tabelas              ctd
           , cmx_tabelas              ctmsc
       WHERE id.embarque_id            = pn_embarque_id
         AND idl.declaracao_id         = id.declaracao_id
         AND idl.invoice_lin_id        = iil.invoice_lin_id
         AND ida.declaracao_adi_id     = idl.declaracao_adi_id
         AND dac.rd_id(+)              = idl.rd_id
         AND cticms.tabela_id(+)       = idl.regtrib_icms_id
         AND ctd.tabela_id             = id.tp_declaracao_id
         AND ctmsc.tabela_id(+)        = ida.motivo_sem_cobertura_id
         AND Nvl(cmx_pkg_tabelas.codigo(idl.un_medida_id), '<NULL>') <> 'CONTINUACAO' --- Ignorar qualquer rateio para os itens de continuação do REPETRO
    ORDER BY idl.invoice_id, idl.invoice_lin_id;

    vn_qtde_linhas_dcl   NUMBER := 0;
    vn_invoice_num       imp_invoices.invoice_num%TYPE := null;

  BEGIN
    FOR ivc IN cur_count_invoices_lin LOOP
      OPEN  cur_count_declaracoes_lin (ivc.invoice_id);
      FETCH cur_count_declaracoes_lin INTO vn_invoice_num, vn_qtde_linhas_dcl;
      CLOSE cur_count_declaracoes_lin;

      IF (nvl(ivc.qtde_linhas_ivc,0) <> nvl(vn_qtde_linhas_dcl,0)) THEN
        prc_gera_log_erros ('Existe pendência de linhas de invoice para a declaração. As linhas da invoice [' || vn_invoice_num || '] não foram totalmente alocadas em declaração ou licenças.',  'A', 'D');
        EXIT;
      END IF;
    END LOOP;

    FOR dcl IN cur_declaracoes_lin LOOP

      vn_global_dcl_lin := vn_global_dcl_lin + 1;

      tb_dcl_lin(vn_global_dcl_lin).declaracao_lin_id              := dcl.declaracao_lin_id;
      tb_dcl_lin(vn_global_dcl_lin).declaracao_id                  := dcl.declaracao_id;
      tb_dcl_lin(vn_global_dcl_lin).declaracao_adi_id              := dcl.declaracao_adi_id;
      tb_dcl_lin(vn_global_dcl_lin).linha_num                      := dcl.linha_num;
      tb_dcl_lin(vn_global_dcl_lin).invoice_id                     := dcl.invoice_id;
      tb_dcl_lin(vn_global_dcl_lin).invoice_lin_id                 := dcl.invoice_lin_id;
      tb_dcl_lin(vn_global_dcl_lin).licenca_id                     := dcl.licenca_id;
      tb_dcl_lin(vn_global_dcl_lin).qtde                           := dcl.qtde;
      tb_dcl_lin(vn_global_dcl_lin).pesoliq_unit                   := dcl.pesoliq_unit;
      tb_dcl_lin(vn_global_dcl_lin).pesoliq_tot                    := dcl.pesoliq_unit * dcl.qtde;


      tb_dcl_lin(vn_global_dcl_lin).regtrib_icms                   := dcl.regtrib_icms;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_icms_id                := dcl.regtrib_icms_id;
      tb_dcl_lin(vn_global_dcl_lin).sit_tributaria                 := dcl.sit_tributaria;
      tb_dcl_lin(vn_global_dcl_lin).aliq_icms                      := dcl.aliq_icms;
      tb_dcl_lin(vn_global_dcl_lin).aliq_icms_red                  := dcl.aliq_icms_red;
      tb_dcl_lin(vn_global_dcl_lin).perc_red_icms                  := dcl.perc_red_icms;
      tb_dcl_lin(vn_global_dcl_lin).tp_declaracao                  := dcl.tp_declaracao;
      tb_dcl_lin(vn_global_dcl_lin).rd_id                          := dcl.rd_id;
      tb_dcl_lin(vn_global_dcl_lin).tpdcl_calcula_icms             := NVL(dcl.tpdcl_calcula_icms,'S');
      tb_dcl_lin(vn_global_dcl_lin).mscob_calcula_icms             := NVL(dcl.mscob_calcula_icms,'S');
      tb_dcl_lin(vn_global_dcl_lin).tpato_calcula_icms             := NVL(dcl.tpato_calcula_icms,'N');
      tb_dcl_lin(vn_global_dcl_lin).aliq_pis                       := dcl.aliq_pis;
      tb_dcl_lin(vn_global_dcl_lin).aliq_cofins                    := dcl.aliq_cofins;
      tb_dcl_lin(vn_global_dcl_lin).perc_reducao_base_pis_cofins   := dcl.perc_reducao_base_pis_cofins;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_pis_cofins_id          := dcl.regtrib_pis_cofins_id;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_ii                     := dcl.regtrib_ii;
      tb_dcl_lin(vn_global_dcl_lin).regtrib_ipi                    := dcl.regtrib_ipi;
      vn_global_meses_permanencia                                  := nvl (dcl.tempo_permanencia,0);
      vn_global_meses_permanec_icms                                := null;
      tb_dcl_lin(vn_global_dcl_lin).vrt_dsp_ddu_m                  := 0;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_m                       := 0;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_total_m                 := 0;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_prepaid_m               := 0;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_collect_m               := 0;
      tb_dcl_lin(vn_global_dcl_lin).vrt_fr_territorio_nacional_m   := 0;
      tb_dcl_lin(vn_global_dcl_lin).aliq_icms_fecp                 := nvl(dcl.aliq_icms_fecp,0);
      tb_dcl_lin(vn_global_dcl_lin).valor_icms_fecp                := 0;
      tb_dcl_lin(vn_global_dcl_lin).tipo_unidade_medida_antid      := dcl.tipo_unidade_medida_antid;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid_aliq_especifica    := null;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid_ad_valorem         := null;
      tb_dcl_lin(vn_global_dcl_lin).qtde_um_aliq_especifica_antid  := null;
      tb_dcl_lin(vn_global_dcl_lin).basecalc_antid                 := null;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid                    := null;
      tb_dcl_lin(vn_global_dcl_lin).valor_antid_dev                := null;
      tb_dcl_lin(vn_global_dcl_lin).somatoria_quantidade           := dcl.somatoria_quantidade;
      tb_dcl_lin(vn_global_dcl_lin).aliq_antid_especifica          := dcl.aliq_antid_especifica;
      tb_dcl_lin(vn_global_dcl_lin).aliq_antid                     := dcl.aliq_antid;
      tb_dcl_lin(vn_global_dcl_lin).licenca_lin_id                 := dcl.licenca_lin_id;
      tb_dcl_lin(vn_global_dcl_lin).aliq_mva                       := dcl.aliq_mva;
      tb_dcl_lin(vn_global_dcl_lin).pr_aliq_base                   := dcl.pr_aliq_base;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_diferido               := dcl.pr_perc_diferido;
      tb_dcl_lin(vn_global_dcl_lin).valor_diferido_icms_pr         := dcl.valor_diferido_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_cred_presumido_pr        := dcl.valor_cred_presumido_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_cred_presumido_pr_devido := dcl.valor_cred_presumido_pr_devido;
      tb_dcl_lin(vn_global_dcl_lin).beneficio_pr_artigo            := dcl.beneficio_pr_artigo;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_vr_devido              := dcl.pr_perc_vr_devido;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_minimo_base            := dcl.pr_perc_minimo_base;
      tb_dcl_lin(vn_global_dcl_lin).pr_perc_minimo_suspenso        := dcl.pr_perc_minimo_suspenso;
      tb_dcl_lin(vn_global_dcl_lin).valor_devido_icms_pr           := dcl.valor_devido_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_perc_vr_devido_icms_pr   := dcl.valor_perc_vr_devido_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_perc_minimo_base_icms_pr := dcl.valor_perc_minimo_base_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).valor_perc_susp_base_icms_pr   := dcl.valor_perc_susp_base_icms_pr;
      tb_dcl_lin(vn_global_dcl_lin).aliq_cofins_recuperar          := dcl.aliq_cofins_recuperar;
      tb_dcl_lin(vn_global_dcl_lin).class_fiscal_id                := dcl.class_fiscal_id;
      tb_dcl_lin(vn_global_dcl_lin).aliq_cofins_reduzida           := dcl.aliq_cofins_reduzida;
      tb_dcl_lin(vn_global_dcl_lin).beneficio_suspensao            := dcl.beneficio_suspensao;
      tb_dcl_lin(vn_global_dcl_lin).perc_beneficio_suspensao       := dcl.perc_beneficio_suspensao;
    END LOOP;

    IF (vn_global_dcl_lin = 0) THEN
      prc_gera_log_erros ('Não existem linhas de declaração...', 'A', 'D');
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro ao carregar as linhas da declaração: ' || sqlerrm, 'E', 'D');
  END imp_prc_carrega_linhas_dcl;

  -- ***********************************************************************
  -- Esta procedure rateará as diferenças de pesos líquidos entre a invoice
  -- e os pesos informados nas linhas da invoice.
  -- ***********************************************************************
  PROCEDURE imp_prc_acerta_pesos_liq_e_brt (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER, pn_tp_embarque_id NUMBER) IS
    vn_ivc_anterior_id      NUMBER := 0;
    vn_ivc_somapesoliq_lin  NUMBER := 0;
    vn_ind_pesoliq_ivc      NUMBER := 0;
    vn_pesobrt_ebq          NUMBER := 0;
    vn_ind_pesobrt          NUMBER := 0;
    vn_ivcsoma              NUMBER := 0;
    vn_soma_rateio_pesoliq  NUMBER := 0;
    vn_soma_rateio_pesobrt  NUMBER := 0;
    vn_pesoliq_rateado      NUMBER := 0;
    vn_maior_pesoliq        NUMBER := 0;
    vn_maior_pesoliq_ind    NUMBER := 0;
    vn_ivc_somapesoliq_kg   NUMBER := 0;
    vn_ivc_ultimo_item      NUMBER := 0;
    vn_peso_liq_embalagem   NUMBER := 0;

    CURSOR cur_conta_linhas_peso_liberado (pn_invoice_id NUMBER) IS
      SELECT count(*)
        FROM imp_invoices_lin
       WHERE invoice_id   = pn_invoice_id
         AND cmx_pkg_tabelas.codigo(un_medida_id)    = 'KG'
         AND cmx_pkg_tabelas.auxiliar(tp_linha_id,1) = 'M'
         AND nvl (flag_libera_peso_liquido, 'N')     = 'S';

    CURSOR cur_pesobrt_conhec IS
      SELECT NVL(ic.peso_bruto,0) peso_bruto
           , ie.conhec_id
        FROM imp_conhecimentos ic,
             imp_embarques     ie
       WHERE ie.embarque_id = pn_embarque_id
         AND ic.conhec_id   = ie.conhec_id;

    CURSOR cur_tp_embarque IS
      SELECT ebq.tp_embarque_id
        FROM imp_embarques ebq
       WHERE ebq.embarque_id     = pn_embarque_id;

    CURSOR cur_ebq_nac_de_daf (pn_cur_tp_embarque_id NUMBER )IS
      SELECT 1
        FROM cmx_tabelas   tp_ebq
       WHERE tp_ebq.tabela_id    = pn_cur_tp_embarque_id
         AND tp_ebq.auxiliar1    = 'NAC'
         AND tp_ebq.auxiliar9   IN ('DE', 'DAF');

    CURSOR cur_peso_bruto_rem IS
      SELECT Sum(con.peso_bruto)
        FROM imp_conhecimentos con
       WHERE con.conhec_id IN (SELECT re.conhec_id
                                 FROM imp_po_remessa re
                                WHERE re.embarque_id = pn_embarque_id
                                  AND re.nr_remessa  = '1');

    CURSOR cur_verif_retif_rem(pn_embarque_id NUMBER) IS
      SELECT retificada
        FROM imp_po_remessa
       WHERE po_remessa_id = (SELECT po_remessa_id
                                FROM imp_po_remessa
                               WHERE embarque_id = pn_embarque_id
                                 AND nr_remessa = '1');

    CURSOR cur_peso_liq_rem IS
      SELECT Sum(inv.peso_liquido)
        FROM imp_invoices inv
       WHERE EXISTS (SELECT re.po_remessa_id
                       FROM imp_po_remessa re
                      WHERE re.po_remessa_id = inv.remessa_id
                        AND re.embarque_id = pn_embarque_id);

  CURSOR cur_peso_di_unica IS
    SELECT prev_peso_bruto
      FROM imp_embarques
     WHERE embarque_id = pn_embarque_id;

    vn_peso_di_unica     imp_embarques.embarque_id%TYPE;

    vn_dummy                       NUMBER  := 0;
    vn_linhas_kg_com_peso_liberado NUMBER  := 0;
    vn_ivc_somapesoliq_fixo        NUMBER  := 0;
    vn_ivc_somapesoliq_tot_rateado NUMBER  := 0;
    vb_ebq_nac_de_daf              BOOLEAN := false;

    vn_soma_pesobrt_rem            NUMBER := 0;
    vc_rem_retif                   VARCHAR2(1);
    vn_soma_pesoliq_rem            NUMBER := 0;
    vn_peso_total_di_unica_incial  NUMBER;
    vn_indice_di_unica             NUMBER;
    vn_peso_rateio_di_unica        NUMBER;
    vn_peso_total_ivc              NUMBER;
    vn_fat_rateio_di_unica         NUMBER;
    vn_tp_embarque_id              NUMBER;
    vn_rateio_pesoliq_ebq          NUMBER := 0;
    vn_pesobrt_fixo_ebq            NUMBER := 0;

  BEGIN

    OPEN  cur_tp_embarque;
    FETCH cur_tp_embarque INTO vn_tp_embarque_id;
    CLOSE cur_tp_embarque;

    OPEN  cur_ebq_nac_de_daf(vn_tp_embarque_id);
    FETCH cur_ebq_nac_de_daf INTO vn_dummy;
    vb_ebq_nac_de_daf := cur_ebq_nac_de_daf%FOUND;
    CLOSE cur_ebq_nac_de_daf;

    OPEN  cur_verif_retif_rem(pn_embarque_id);
    FETCH cur_verif_retif_rem INTO vc_rem_retif;
    CLOSE cur_verif_retif_rem;

    IF (vc_rem_retif = 'S') THEN
      IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
/*
        OPEN  cur_peso_bruto_rem;
        FETCH cur_peso_bruto_rem INTO vn_soma_pesobrt_rem;
        CLOSE cur_peso_bruto_rem;
*/
        OPEN cur_peso_liq_rem;
        FETCH cur_peso_liq_rem INTO vn_soma_pesoliq_rem;
        CLOSE cur_peso_liq_rem;


        -- Somando o valor liquido total das invoices
        vn_ivc_anterior_id := 0;
        vn_peso_total_di_unica_incial := 0;
        FOR ivcA IN 1..vn_global_ivc_lin LOOP

          IF (vn_ivc_anterior_id <> tb_ivc_lin(ivcA).invoice_id) THEN
            vn_peso_total_di_unica_incial := vn_peso_total_di_unica_incial + tb_ivc_lin(ivcA).pesoliq_tot;
            vn_ivc_anterior_id := tb_ivc_lin(ivcA).invoice_id;
          END IF;
        END LOOP;

        -- Calculando Indice para que seja feito novo rateio, vamos usar o tot_ivc para aplicar o rateio que já é feito hoje.
        vn_ivc_anterior_id := 0;
        FOR ivcA IN 1..vn_global_ivc_lin LOOP

          IF (vn_ivc_anterior_id <> tb_ivc_lin(ivcA).invoice_id) THEN
            vn_indice_di_unica      := tb_ivc_lin(ivcA).pesoliq_tot_ivc / vn_peso_total_di_unica_incial;
            vn_ivc_anterior_id      := tb_ivc_lin(ivcA).invoice_id;
            vn_peso_rateio_di_unica := Round(vn_indice_di_unica * vn_peso_total_di_unica_incial,5);

          END IF;
          tb_ivc_lin(ivcA).pesoliq_tot_ivc := Round(vn_indice_di_unica * vn_peso_total_di_unica_incial,5);

        END LOOP;

        -- Ajustando a diferença no ultimo id
        FOR ivcA IN 1..vn_global_ivc_lin LOOP

          IF (vn_ivc_anterior_id = tb_ivc_lin(ivcA).invoice_id) THEN
            tb_ivc_lin(ivcA).pesoliq_tot_ivc := tb_ivc_lin(ivcA).pesoliq_tot_ivc - ( vn_peso_total_di_unica_incial - vn_peso_rateio_di_unica );
          END IF;

        END LOOP;

      END IF;
    END IF;

    vn_peso_liq_embalagem := 0;

    FOR ivc IN 1..vn_global_ivc_lin LOOP
      IF (tb_ivc_lin(ivc).pesoliq_tot_ivc > 0) AND (pn_tp_declaracao <> 17) AND (NOT vb_ebq_nac_de_daf) THEN
        IF (vn_ivc_anterior_id <> tb_ivc_lin(ivc).invoice_id) THEN
          vn_ivcsoma                     := ivc;
          vn_ivc_somapesoliq_lin         := 0;
          vn_ind_pesoliq_ivc             := 0;
          vn_soma_rateio_pesoliq         := 0;
          vn_maior_pesoliq               := 0;
          vn_maior_pesoliq_ind           := 0;
          vn_ivc_somapesoliq_kg          := 0;
          vn_linhas_kg_com_peso_liberado := 0;
          vn_ivc_somapesoliq_fixo        := 0;
          vn_ivc_somapesoliq_tot_rateado := 0;

          /* Contamos quantas linhas mercadoria existem na invoice como o peso liquido liberado, qdo U.M. = KG */
          OPEN  cur_conta_linhas_peso_liberado (tb_ivc_lin(ivc).invoice_id);
          FETCH cur_conta_linhas_peso_liberado INTO vn_linhas_kg_com_peso_liberado;
          CLOSE cur_conta_linhas_peso_liberado;

          /* Soma-se o peso dos itens com unidade de medida KG */
          WHILE ((vn_ivcsoma <= vn_global_ivc_lin) AND (tb_ivc_lin(vn_ivcsoma).invoice_id = tb_ivc_lin(ivc).invoice_id)) LOOP
            IF (tb_ivc_lin(vn_ivcsoma).unidade_medida           = 'KG') AND
               (tb_ivc_lin(vn_ivcsoma).flag_libera_peso_liquido = 'N' ) THEN
                vn_ivc_somapesoliq_kg := vn_ivc_somapesoliq_kg + nvl(tb_ivc_lin(vn_ivcsoma).pesoliq_tot,0);
 	          END IF;

            IF (tb_ivc_lin(vn_ivcsoma).flag_fixa_pesoliq_tot = 'S' ) THEN
              vn_ivc_somapesoliq_fixo := vn_ivc_somapesoliq_fixo + nvl(tb_ivc_lin(vn_ivcsoma).pesoliq_tot,0);
            END IF;

            vn_ivcsoma := vn_ivcsoma + 1;
          END LOOP;

          /* Retornamos o indice na posicao Inicial */
          vn_ivcsoma := ivc;

          /* Verificando se o peso liquido total da invoice é menor ou igual a soma dos pesos KG */
          IF (vn_ivc_somapesoliq_kg > tb_ivc_lin(ivc).pesoliq_tot_ivc) AND (vn_linhas_kg_com_peso_liberado = 0) THEN
           prc_gera_log_erros ('Somatória dos pesos líquido com unidade de Medida "KG" das linhas da invoice é maior que o peso liquido total informado na invoice...', 'E', 'A');
          END IF;

          /* Soma-se todas as linhas da invoice em evidencia para se obter o peso liquido resultante da multiplicacao
             quantidade * peso liquido unitario
          */
          vn_ivc_ultimo_item := ivc ;

          WHILE ((vn_ivcsoma <= vn_global_ivc_lin) AND (tb_ivc_lin(vn_ivcsoma).invoice_id = tb_ivc_lin(ivc).invoice_id)) LOOP
            IF ((tb_ivc_lin(vn_ivcsoma).unidade_medida <> 'KG') OR
               ((tb_ivc_lin(vn_ivcsoma).unidade_medida = 'KG') AND (tb_ivc_lin(vn_ivcsoma).flag_libera_peso_liquido = 'S'))) AND
               (tb_ivc_lin(vn_ivcsoma).flag_fixa_pesoliq_tot = 'N')  THEN
              vn_ivc_somapesoliq_lin := vn_ivc_somapesoliq_lin + nvl(tb_ivc_lin(vn_ivcsoma).pesoliq_tot,0);
              vn_ivc_ultimo_item     := vn_ivcsoma;
            END IF;

            vn_ivcsoma             := vn_ivcsoma + 1;
          END LOOP;

          IF (vn_ivc_somapesoliq_lin > 0) THEN
             /* Calcula o quanto a somatoria dos pesos das linhas representam no peso total da invoice */
             vn_ind_pesoliq_ivc := (tb_ivc_lin(ivc).pesoliq_tot_ivc - vn_ivc_somapesoliq_kg - vn_ivc_somapesoliq_lin - vn_ivc_somapesoliq_fixo) / vn_ivc_somapesoliq_lin;
          END IF;

          vn_ivc_anterior_id := tb_ivc_lin(ivc).invoice_id;
        END IF;

        IF (cmx_fnc_profile ('IMP_TOTALIZA_RATEIO_PESO_IVC') = 'S') THEN
          IF ((tb_ivc_lin(ivc).unidade_medida <> 'KG') OR
             ((tb_ivc_lin(ivc).unidade_medida = 'KG') AND (tb_ivc_lin(ivc).flag_libera_peso_liquido = 'S'))) AND
             (tb_ivc_lin(ivc).flag_fixa_pesoliq_tot = 'N') THEN
            vn_pesoliq_rateado := round(nvl((tb_ivc_lin(ivc).pesoliq_tot * vn_ind_pesoliq_ivc),0),5);

            /* Guardando maior peso liquido para jogar a diferenca na linha de maior peso liquido */
            IF ( vn_pesoliq_rateado > vn_maior_pesoliq ) THEN
              vn_maior_pesoliq_ind := ivc ;
              vn_maior_pesoliq     := vn_pesoliq_rateado ;
            END IF;

            /* Jogando diferenca na linha de maior valor */
            IF (ivc = (vn_ivc_ultimo_item)) THEN
              vn_pesoliq_rateado := (tb_ivc_lin(ivc).pesoliq_tot_ivc - vn_ivc_somapesoliq_kg - vn_ivc_somapesoliq_lin - vn_ivc_somapesoliq_fixo ) - vn_soma_rateio_pesoliq;
            END IF;

            tb_ivc_lin(ivc).pesoliq_tot    := tb_ivc_lin(ivc).pesoliq_tot    + vn_pesoliq_rateado;

            vn_soma_rateio_pesoliq         := vn_soma_rateio_pesoliq         + vn_pesoliq_rateado;
            vn_ivc_somapesoliq_tot_rateado := vn_ivc_somapesoliq_tot_rateado + tb_ivc_lin(ivc).pesoliq_tot;
          END IF; -- IF (tb_ivc_lin(ivc).unidade_medida <> 'KG') OR
        END IF; -- cmx_fnc_profile('IMP_TOTALIZA_RATEIO_PESO_IVC') = 'S'
      END IF; -- IF (tb_ivc_lin(ivc).pesoliq_tot_ivc > 0) THEN

      IF (tb_ivc_lin(ivc).tp_linha_codigo = 'E') THEN
        vn_peso_liq_embalagem := vn_peso_liq_embalagem + tb_ivc_lin(ivc).pesoliq_tot+vn_soma_pesoliq_rem;
      END IF;

      vn_global_pesoliq_ebq := vn_global_pesoliq_ebq + tb_ivc_lin(ivc).pesoliq_tot+vn_soma_pesoliq_rem;

      IF (tb_ivc_lin(ivc).flag_fixa_pesobrt_tot = 'N') THEN
        vn_rateio_pesoliq_ebq := vn_rateio_pesoliq_ebq + tb_ivc_lin(ivc).pesoliq_tot;
      END IF;

    END LOOP;


    IF pn_tp_declaracao < 13 OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'S') THEN
      OPEN  cur_pesobrt_conhec;
      FETCH cur_pesobrt_conhec into vn_pesobrt_ebq, vn_global_conhec_id;
      CLOSE cur_pesobrt_conhec;

      vn_ind_pesobrt := 0;

      vn_pesobrt_fixo_ebq := 0;
      FOR ivc IN 1..vn_global_ivc_lin LOOP
        IF (tb_ivc_lin(ivc).flag_fixa_pesobrt_tot = 'S') THEN
          vn_pesobrt_fixo_ebq := vn_pesobrt_fixo_ebq + tb_ivc_lin(ivc).pesobrt_tot;
        END IF;
      END LOOP;


--      vn_pesobrt_ebq := vn_pesobrt_ebq+vn_soma_pesobrt_rem;

      IF (vn_pesobrt_ebq > 0) THEN
        IF (nvl(vn_global_pesoliq_ebq,0) > 0) THEN
          IF ( (vn_global_pesoliq_ebq - vn_peso_liq_embalagem) > vn_pesobrt_ebq) THEN
            prc_gera_log_erros ('Peso bruto do conhecimento menor que peso líquido.', 'A', null);
          END IF;

          IF (vn_pesobrt_fixo_ebq > 0 AND vn_rateio_pesoliq_ebq > 0) THEN -- se tiver peso bruto fixo e ainda tiver linhas para ratear se não faz da forma atual
            vn_ind_pesobrt := (vn_pesobrt_ebq - vn_pesobrt_fixo_ebq) / vn_rateio_pesoliq_ebq;
          ELSE
            vn_ind_pesobrt := vn_pesobrt_ebq / (vn_global_pesoliq_ebq - vn_peso_liq_embalagem);
          END IF;

        ELSE
          prc_gera_log_erros ('Somatória dos pesos líquido das linhas da invoice zerados.', 'E', 'A');
        END IF;

        IF (vn_rateio_pesoliq_ebq > 0) AND (vn_pesobrt_ebq - vn_pesobrt_fixo_ebq) > 0 THEN -- vai ser maior que zero se tiver linhas para ratear o peso bruto.

          FOR ivc IN 1..vn_global_ivc_lin LOOP
            IF (tb_ivc_lin(ivc).tp_linha_codigo <> 'E') THEN  -- não considera peso bruto nas linhas de embalagem retornável
              IF (ivc = vn_global_ivc_lin) THEN
                tb_ivc_lin(ivc).pesobrt_tot := (vn_pesobrt_ebq - vn_pesobrt_fixo_ebq) - vn_soma_rateio_pesobrt;
              ELSE
                tb_ivc_lin(ivc).pesobrt_tot := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_pesobrt;
              END IF;
              vn_soma_rateio_pesobrt := vn_soma_rateio_pesobrt + tb_ivc_lin(ivc).pesobrt_tot;
            END IF;
          END LOOP;
        ELSE
          IF vn_pesobrt_ebq > vn_pesobrt_fixo_ebq THEN
            prc_gera_log_erros
            ( cmx_fnc_texto_traduzido
                ( 'Peso bruto informado no conhecimento é maior que o peso bruto informado nas invoices.'
                , 'imp_pkg_totaliza_ebq'
                , '153'
              , NULL )
            , 'E'
            , 'A');
          END IF;

          IF vn_pesobrt_ebq < vn_pesobrt_fixo_ebq THEN
            prc_gera_log_erros
            ( cmx_fnc_texto_traduzido
                ( 'Peso bruto informado nas linhas da invoice é maior que o peso bruto informado no conhecimento.'
                , 'imp_pkg_totaliza_ebq'
                , '154'
              , NULL )
            , 'E'
            , 'A');

          END IF;
        END IF;

      ELSE
        IF (Nvl(vc_global_verif_di_unica, '*') <> 'DI_UNICA') THEN
          IF (  Nvl (pn_tp_declaracao, '00') = '15'
             OR Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id,1),'XX') = 'NAC_DE_TERC'
             OR ( Nvl (pn_tp_declaracao, '00') IN ('13', '14')
                AND cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id, 1) IS NOT NULL ) ) THEN
             NULL;
          ELSE
              prc_gera_log_erros ('Peso bruto do conhecimento não informado, rateio não efetuado.', 'A', null);
          END IF;
        ELSE
          OPEN  cur_peso_di_unica;
          FETCH cur_peso_di_unica INTO vn_peso_di_unica;
          CLOSE cur_peso_di_unica;

          OPEN  cur_peso_bruto_rem;
          FETCH cur_peso_bruto_rem INTO vn_soma_pesobrt_rem;
          CLOSE cur_peso_bruto_rem;

          vn_peso_total_ivc := 0;
          FOR ivc IN 1..vn_global_ivc_lin LOOP
            vn_peso_total_ivc := vn_peso_total_ivc + tb_ivc_lin(ivc).pesoliq_tot;
          END LOOP;

          vn_fat_rateio_di_unica := 0;
            IF (vn_peso_di_unica > 0) THEN
              vn_fat_rateio_di_unica := vn_peso_di_unica / vn_peso_total_ivc;
            ELSE
              vn_fat_rateio_di_unica := vn_soma_pesobrt_rem / vn_peso_total_ivc;
            END IF;

          FOR ivc IN 1..vn_global_ivc_lin LOOP
            tb_ivc_lin(ivc).pesobrt_tot := tb_ivc_lin(ivc).pesoliq_tot * vn_fat_rateio_di_unica;
          END LOOP;

          IF (Nvl(vn_peso_di_unica, 0) = 0 AND Nvl(vn_soma_pesobrt_rem, 0) = 0) THEN
            prc_gera_log_erros ('Peso bruto do planejamento de DI única não informado, rateio não efetuado.', 'A', null);
          END IF;

          --Comentado a pedido da Izabela 26/07/2017
          --IF ((vn_peso_di_unica > 0 AND vn_global_pesoliq_ebq > vn_peso_di_unica)
          -- OR (vn_peso_di_unica = 0 AND vn_soma_pesobrt_rem > 0 AND vn_global_pesoliq_ebq > vn_soma_pesobrt_rem) ) THEN
          --  prc_gera_log_erros ('Peso bruto da DI única menor que peso líquido.', 'A', null);
          --END IF;

        END IF;
      END IF;

      IF ( pn_tp_declaracao IN (13,14) ) THEN
        vn_global_pesobrt_nac := vn_soma_rateio_pesobrt;
        vn_global_pesoliq_nac := vn_global_pesoliq_ebq;
      END IF;

    ELSIF pn_tp_declaracao = 16 THEN -- NACIONALIZACAO RECOF
      vn_global_pesoliq_nac := 0;
      vn_global_pesobrt_nac := 0;

      FOR dcll IN 1..vn_global_dcl_lin LOOP
        vn_global_pesoliq_nac := vn_global_pesoliq_nac + tb_dcl_lin(dcll).pesoliq_tot;
        vn_global_pesobrt_nac := vn_global_pesobrt_nac + tb_dcl_lin(dcll).pesobrt_tot;
      END LOOP;

      vn_global_pesoliq_nac := round (vn_global_pesoliq_nac, 5);
      vn_global_pesobrt_nac := round (vn_global_pesobrt_nac, 5);

    ELSE  -- NACIONALIZACAO

      IF ((pn_tp_declaracao = 17) OR (vb_ebq_nac_de_daf))  THEN

        IF (Nvl(cmx_pkg_tabelas.auxiliar(pn_tp_embarque_id,1),'XX') <> 'NAC_DE_TERC') THEN
          vn_global_pesoliq_nac := 0;


          FOR dcll IN 1..vn_global_dcl_lin LOOP

            vn_global_pesoliq_nac := vn_global_pesoliq_nac + Round (tb_dcl_lin(dcll).pesoliq_unit * tb_dcl_lin(dcll).qtde, 5);
          END LOOP;

          FOR ivcl IN 1..vn_global_ivc_lin LOOP
            tb_ivc_lin(ivcl).pesobrt_tot := 0;

            FOR ivcl_da IN 1..vn_global_ivc_lin_da LOOP
              IF (tb_ivc_lin(ivcl).invoice_lin_id = tb_ivc_lin_da(ivcl_da).invoice_lin_id) THEN
                tb_ivc_lin(ivcl).pesobrt_tot := tb_ivc_lin(ivcl).pesobrt_tot + tb_ivc_lin_da(ivcl_da).da_peso_brt_proporcional;
              END IF;
            END LOOP;

            vn_global_pesobrt_nac := vn_global_pesobrt_nac + tb_ivc_lin(ivcl).pesobrt_tot;
          END LOOP;

          FOR dcll IN 1..vn_global_dcl_lin LOOP
            FOR ivcl_da IN 1..vn_global_ivc_lin_da LOOP
              IF (tb_ivc_lin_da(ivcl_da).declaracao_lin_id IS NOT null) AND (tb_dcl_lin(dcll).declaracao_lin_id = tb_ivc_lin_da(ivcl_da).declaracao_lin_id) THEN
                tb_dcl_lin(dcll).pesobrt_unit := tb_ivc_lin_da(ivcl_da).da_peso_brt_proporcional / tb_dcl_lin(dcll).qtde;
                tb_dcl_lin(dcll).pesobrt_tot  := tb_ivc_lin_da(ivcl_da).da_peso_brt_proporcional;
              END IF;

              IF (tb_ivc_lin_da(ivcl_da).declaracao_lin_id IS null) AND (tb_dcl_lin(dcll).licenca_lin_id = tb_ivc_lin_da(ivcl_da).licenca_lin_id) THEN
                tb_dcl_lin(dcll).pesobrt_unit := tb_ivc_lin_da(ivcl_da).da_peso_brt_proporcional / tb_dcl_lin(dcll).qtde;
                tb_dcl_lin(dcll).pesobrt_tot  := tb_ivc_lin_da(ivcl_da).da_peso_brt_proporcional;
              END IF;
            END LOOP;
          END LOOP;
        ELSE

          vn_global_pesoliq_nac := vn_global_pesoliq_ebq;


          FOR ivcl IN 1..vn_global_ivc_lin LOOP
            tb_ivc_lin(ivcl).pesobrt_tot := tb_ivc_lin(ivcl).peso_bruto_nac;
            vn_global_pesobrt_nac := vn_global_pesobrt_nac + tb_ivc_lin(ivcl).pesobrt_tot;

          END LOOP;
          vn_global_pesobrt_nac := vn_global_pesobrt_nac+vn_soma_pesobrt_rem;

        END IF;
      ELSE
        vn_global_pesoliq_nac := vn_global_pesoliq_ebq;

        FOR ivcl IN 1..vn_global_dcl_lin LOOP
          tb_ivc_lin(ivcl).pesobrt_tot := 0;
          FOR dcll IN 1..vn_global_dcl_lin LOOP
            IF tb_ivc_lin(ivcl).invoice_lin_id = tb_dcl_lin(dcll).invoice_lin_id THEN
              tb_ivc_lin(ivcl).pesobrt_tot := tb_ivc_lin(ivcl).pesobrt_tot + tb_dcl_lin(dcll).pesobrt_unit * tb_dcl_lin(dcll).qtde;
            END IF;
          END LOOP;

          vn_global_pesobrt_nac := vn_global_pesobrt_nac + tb_ivc_lin(ivcl).pesobrt_tot;
        END LOOP;
        vn_global_pesobrt_nac := vn_global_pesobrt_nac+vn_soma_pesobrt_rem;
      END IF; -- IF (pn_tp_declaracao = 17) OR (vb_ebq_nac_de_daf) THEN
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no rateio dos pesos líquidos e brutos: ' || sqlerrm, 'E', 'A');
  END imp_prc_acerta_pesos_liq_e_brt;

  -- ***********************************************************************
  -- Esta procedure ira buscar todas as linhas de mercadoria das invoices e
  -- ratear os valores dsp.fob, frete internacional e seguro internacional quando
  -- houver na invoice. Isto ocorre para que tenhamos o valor FOB de cada linha
  -- nos casos onde o frete ou seguro estiver embutido e para ratear os valores
  -- de despesas FOB que não estão inclusas no preço unitário.
  -- ***********************************************************************
  PROCEDURE imp_prc_rateia_valores_invoice (pn_embarque_id NUMBER, pd_data_totalizar DATE) IS
    vn_ivc_anterior_id            NUMBER := 0;
    vn_vrt_dspfob_ivc             NUMBER := 0;
    vn_vrt_fr_ivc                 NUMBER := 0;
    vn_vrt_sg_ivc                 NUMBER := 0;

    vn_maior_valor_dspfob_rateada NUMBER := 0;
    vn_linha_maior_valor_dspfob   NUMBER := 0;
    vn_diferenca_dspfob           NUMBER := 0;
    vn_qtde_linhas_ivc            NUMBER := 0;
    vn_ultima_linha_ivc           NUMBER := 0;

    vn_ind_dspfob_ivc             NUMBER := 0;
    vn_ind_fr_ivc                 NUMBER := 0;
    vn_ind_sg_ivc                 NUMBER := 0;

    vn_ivcfob                     NUMBER := 0;
    vn_vrt_fob_ivc                NUMBER := 0;

    vn_soma_rateio_frivc          NUMBER := 0;
    vn_soma_rateio_sgivc          NUMBER := 0;
    vn_soma_rateio_dspfob         NUMBER := 0;

    vn_moeda_id                   NUMBER := 0;
    vn_taxa_mn                    NUMBER := 0;
    vn_taxa_us                    NUMBER := 0;
    vn_pesoliq_tot_ivc            NUMBER := 0;

    vb_achou_fr_destacado         BOOLEAN := false;

    vn_fob_tot_ivc                NUMBER := 0;
    vn_vrt_desc_ivc               NUMBER := 0;
    vn_vrt_descs_ivc              NUMBER := 0;
    vn_ind_desc_ivc               NUMBER := 0;
    vn_ind_descs_ivc              NUMBER := 0;

    vn_soma_rateio_descivc        NUMBER := 0;
    vn_soma_rateio_descsivc       NUMBER := 0;
    vn_diferenca_frete            NUMBER := 0;
    vn_vrt_dsp_ddu                NUMBER := 0;
    vn_ind_dsp_ddu                NUMBER := 0;
    vn_soma_rateio_dsp_ddu        NUMBER := 0;

    vn_fob_antes_acerto           NUMBER;
    vc_tp_linha                   VARCHAR2(1);
    vn_pais_id                    NUMBER;

    CURSOR cur_vrt_ivc_por_tipo (pn_invoice_id NUMBER, pc_tp_valor varchar2) IS
      SELECT nvl(SUM(nvl(imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * iil.preco_unitario_m,0)),0)
        FROM imp_invoices_lin  iil,
             cmx_tabelas       ct
       WHERE iil.invoice_id = pn_invoice_id
         AND ct.tabela_id   = iil.tp_linha_id
         AND ct.auxiliar1   = pc_tp_valor;

    CURSOR cur_qtde_linhas_mercadoria (pn_invoice_id NUMBER) IS
      SELECT count(*) qtde_linhas
        FROM imp_invoices_lin
       WHERE invoice_id  = pn_invoice_id
         AND cmx_pkg_tabelas.auxiliar(tp_linha_id,1) = 'M';

    CURSOR cur_tp_linha(pn_invoice_id NUMBER) IS
      SELECT 'M'
        FROM imp_invoices_lin
       WHERE invoice_id  = pn_invoice_id
         AND 'M'         = cmx_pkg_tabelas.auxiliar(tp_linha_id,1);

   CURSOR cur_pais_embarque IS
      SELECT cmx_pkg_empresas.pais_id(ebq.empresa_id) AS pais_id
        FROM imp_embarques ebq
       WHERE ebq.embarque_id     = pn_embarque_id;


  BEGIN

    OPEN  cur_pais_embarque;
    FETCH cur_pais_embarque INTO vn_pais_id;
    CLOSE cur_pais_embarque;

    -------------------------------------------------------------------
    -- Faremos um loop nas linhas e quando trocar a invoice buscaremos
    -- os valores das linhas de frete internacional para ratear nas
    -- linhas tipo mercadoria
    -------------------------------------------------------------------
    FOR ivc IN 1..vn_global_ivc_lin LOOP

      OPEN cur_tp_linha(tb_ivc_lin(ivc).invoice_id);
      FETCH cur_tp_linha INTO vc_tp_linha;
      CLOSE cur_tp_linha;

      IF (vc_tp_linha = 'M') THEN -- só executa se existir pelo menos uma linha de mercadoria

        imp_prc_busca_taxa_conversao (tb_ivc_lin(ivc).moeda_fob_id,
                                      pd_data_totalizar,
                                      vn_taxa_mn,
                                      vn_taxa_us,
                                      'Invoice');

        IF (vn_ivc_anterior_id <> tb_ivc_lin(ivc).invoice_id) THEN
          vn_soma_rateio_frivc    := 0;
          vn_ind_fr_ivc           := 0;
          vn_vrt_fr_ivc           := 0;
          vn_pesoliq_tot_ivc      := 0;
          vn_fob_tot_ivc          := 0;
          vn_vrt_desc_ivc         := 0;
          vn_vrt_descs_ivc        := 0;
          vn_ind_desc_ivc         := 0;
          vn_ind_descs_ivc        := 0;
          vn_soma_rateio_descivc  := 0;
          vn_soma_rateio_descsivc := 0;
          vn_vrt_dsp_ddu          := 0;
          vn_ind_dsp_ddu          := 0;
          vn_soma_rateio_dsp_ddu  := 0;

          OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'I' );
          FETCH cur_vrt_ivc_por_tipo INTO vn_vrt_fr_ivc;
          CLOSE cur_vrt_ivc_por_tipo;

          /* Obtendo valor total FOB da invoice para ratear o desconto */
          OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'M' );
          FETCH cur_vrt_ivc_por_tipo INTO vn_fob_tot_ivc ;
          CLOSE cur_vrt_ivc_por_tipo;

          /* Obtendo descontos! */
          OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'T' );
          FETCH cur_vrt_ivc_por_tipo INTO vn_vrt_desc_ivc;
          CLOSE cur_vrt_ivc_por_tipo;

          OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'U' );
          FETCH cur_vrt_ivc_por_tipo INTO vn_vrt_descs_ivc;
          CLOSE cur_vrt_ivc_por_tipo;

          vn_ind_desc_ivc  := vn_vrt_desc_ivc / vn_fob_tot_ivc ;
          vn_ind_descs_ivc := vn_vrt_descs_ivc / vn_fob_tot_ivc ;

          /* Obtendo despesas nacionais */
          OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'N' );
          FETCH cur_vrt_ivc_por_tipo INTO vn_vrt_dsp_ddu;
          CLOSE cur_vrt_ivc_por_tipo;

          vn_ind_dsp_ddu := vn_vrt_dsp_ddu / vn_fob_tot_ivc ;

          IF (nvl(vn_vrt_fr_ivc,0) = 0) THEN  --- não existe frete destacado na fatura
            --------------------------------------------------------------
            -- soma os FRETES e PESOS já rateados pela rotina anterior
            --------------------------------------------------------------
            FOR ivc2 IN ivc..vn_global_ivc_lin LOOP
              IF (tb_ivc_lin(ivc).invoice_id = tb_ivc_lin(ivc2).invoice_id) THEN
                vn_vrt_fr_ivc      := nvl(vn_vrt_fr_ivc     ,0) + nvl(tb_ivc_lin(ivc2).vrt_fr_mn,0);
                vn_pesoliq_tot_ivc := nvl(vn_pesoliq_tot_ivc,0) + tb_ivc_lin(ivc2).pesoliq_tot;
              END IF;
            END LOOP;
            --------------------------------------------------------------

            vn_vrt_fr_ivc := vn_vrt_fr_ivc / vn_taxa_mn;
          ELSE
            --------------------------------------------------------------
            -- soma os PESOS já rateados pela rotina anterior
            --------------------------------------------------------------
            FOR ivc2 IN ivc..vn_global_ivc_lin LOOP
              IF (tb_ivc_lin(ivc).invoice_id = tb_ivc_lin(ivc2).invoice_id) THEN
                vn_pesoliq_tot_ivc := nvl(vn_pesoliq_tot_ivc,0) + tb_ivc_lin(ivc2).pesoliq_tot;
              END IF;
            END LOOP;
            --------------------------------------------------------------
          END IF;

          IF( Nvl(cmx_pkg_tabelas.auxiliar(vn_pais_id, '19'), 'PESO') = 'PESO' )THEN
            IF (vn_pesoliq_tot_ivc > 0) THEN
              vn_ind_fr_ivc := nvl(vn_vrt_fr_ivc / vn_pesoliq_tot_ivc,0);
            ELSE
              prc_gera_log_erros ('Peso líquido total zerado, frete internacional não rateado...', 'E', 'A');
            END IF;
          ELSE
            vn_ind_fr_ivc := nvl(vn_vrt_fr_ivc / vn_fob_tot_ivc,0);
          END IF;

          vn_ivc_anterior_id := tb_ivc_lin(ivc).invoice_id;
        END IF;

        IF (ivc = vn_global_ivc_lin) THEN
          IF (tb_ivc_lin(ivc).numero_nf IS null) THEN
            tb_ivc_lin(ivc).vrt_frivc_m     := vn_vrt_fr_ivc    - vn_soma_rateio_frivc;
          END IF;
          tb_ivc_lin(ivc).vrt_descivc_m   := vn_vrt_desc_ivc  - vn_soma_rateio_descivc;
          tb_ivc_lin(ivc).vrt_descsivc_m  := vn_vrt_descs_ivc - vn_soma_rateio_descsivc;
          tb_ivc_lin(ivc).vrt_dsp_ddu_m   := vn_vrt_dsp_ddu   - vn_soma_rateio_dsp_ddu;
        ELSE
          IF (tb_ivc_lin(ivc).numero_nf IS null) THEN
            IF( Nvl(cmx_pkg_tabelas.auxiliar(vn_pais_id, '19'), 'PESO') = 'PESO' )THEN
              tb_ivc_lin(ivc).vrt_frivc_m     := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_fr_ivc;
            ELSE
              tb_ivc_lin(ivc).vrt_frivc_m     := tb_ivc_lin(ivc).vrt_fob_m * vn_ind_fr_ivc;
            END IF;
          END IF;
          tb_ivc_lin(ivc).vrt_descivc_m   := tb_ivc_lin(ivc).vrt_fob_m   * vn_ind_desc_ivc;
          tb_ivc_lin(ivc).vrt_descsivc_m  := tb_ivc_lin(ivc).vrt_fob_m   * vn_ind_descs_ivc;
          tb_ivc_lin(ivc).vrt_dsp_ddu_m   := tb_ivc_lin(ivc).vrt_fob_m   * vn_ind_dsp_ddu;
        END IF;

        /* OBTENDO VALOR CORRETO DO FOB ( somando desconto - O valor do desconto é sempre negativo, pois a quantidade é negativa! ) */
        /* Existem 2 tipos de descontos:
        * Desconto que será subtraído do valor fob, para que não sejam recolhidos impostos sobre ele. ( U ). => DESCS (Desconto SEM imposto)
        * Desconto que não será subtraído do valor fob, sendo assim, será calculado impostos sobre ele. ( T ) . => DESC ( Desconto COM imposto)
        * Ambos os descontos serão NEGATIVOS pois a quantidade será sempre -1 na linha da fatura e o valor unitário será positivo. Ao fazer qde X preço o resultado será negativo
        * Para efeito de Câmbio, os dois descontos serão considerados para geração do documento de câmbio, ou seja, o documento de câmbio será com desconto.
        */
        IF (tb_ivc_lin(ivc).vrt_descsivc_m <> 0) THEN
          tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_m + tb_ivc_lin(ivc).vrt_descsivc_m ;
        END IF;

        -- OBTENDO VALOR CORRETO DO FOB (descontando frete embutido)
        IF (tb_ivc_lin(ivc).flag_fr_embutido = 'S') THEN
          tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_m - tb_ivc_lin(ivc).vrt_frivc_m;
        END IF;

        -- Quando frete da Invoice Diferente do Frete do Conhecimentos temos que ajustar o FOB
        -- para que a ficha cambial fique igual ao valor na Condição de Venda.

        -- Se o tb_ivc_lin(ivc).vrt_fr_total_m for 0 não foi encontrado conhecimento de transporte,
        -- então não devemos ajustar o FOB.
        IF (nvl (tb_ivc_lin(ivc).vrt_fr_total_m, 0) > 0) AND (tb_ivc_lin(ivc).incoterm <> 'DAF') THEN
          IF substr (tb_ivc_lin(ivc).incoterm, 1, 1) IN ('D', 'C') THEN
            vn_diferenca_frete         := (nvl (tb_ivc_lin(ivc).vrt_fr_total_m, 0) * nvl (tb_ivc_lin(ivc).taxa_mn_fr, 0) / vn_taxa_mn ) - nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0);
            vn_fob_antes_acerto        := tb_ivc_lin(ivc).vrt_fob_m;

            IF ( tb_ivc_lin(ivc).flag_dsp_ddu_embutida = 'S' ) then
              tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_m
                                          - nvl (vn_diferenca_frete, 0)
                                          - tb_ivc_lin(ivc).vrt_dsp_ddu_m;
            ELSE
              tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_m
                                          - nvl (vn_diferenca_frete, 0);
            END IF;

            IF tb_ivc_lin(ivc).vrt_fob_m <= 0 THEN
              prc_gera_log_erros ('Erro no rateio dos valores da invoice ' || tb_ivc_lin(ivc).invoice_num  ||
    	                        ' Linha ' ||to_char(tb_ivc_lin(ivc).linha_num) || ': FOB negativo após acerto contra frete do conhecimento ' || Chr(10) ||
                              ' FOB atual : ' || To_Char( vn_fob_antes_acerto ) || Chr(10) ||
                              ' Frete Invoice: ' ||  To_Char( tb_ivc_lin(ivc).vrt_frivc_m ) || Chr(10) ||
                              ' Frete Conhecimento: ' || To_Char( (nvl (tb_ivc_lin(ivc).vrt_fr_total_m, 0) * tb_ivc_lin(ivc).taxa_mn_fr / vn_taxa_mn )) || Chr(10) ||
                              ' Diferenca : ' || To_Char(vn_diferenca_frete)   , 'E', 'A');
            END IF;
          END IF;
        END IF;

        vn_soma_rateio_frivc    := vn_soma_rateio_frivc    + tb_ivc_lin(ivc).vrt_frivc_m;
        vn_soma_rateio_descivc  := vn_soma_rateio_descivc  + tb_ivc_lin(ivc).vrt_descivc_m;
        vn_soma_rateio_descsivc := vn_soma_rateio_descsivc + tb_ivc_lin(ivc).vrt_descsivc_m;
        vn_soma_rateio_dsp_ddu  := vn_soma_rateio_dsp_ddu  + tb_ivc_lin(ivc).vrt_dsp_ddu_m;
      END IF; -- só executa se existir pelo menos uma linha de mercadoria
    END LOOP;
    -------------------------------------------------------------------

    -------------------------------------------------------------------
    -- Com o valor FOB das linhas encontrado, faremos novamente um loop
    -- nas linhas e quando trocar a invoice buscaremos os valores das
    -- linhas de seguro internacional e despesas FOB para ratear nas
    -- linhas tipo mercadoria
    -------------------------------------------------------------------
    vn_ivc_anterior_id            := 0;
    vn_maior_valor_dspfob_rateada := 0;
    vn_linha_maior_valor_dspfob   := 0;
    vn_diferenca_dspfob           := 0;
    vn_qtde_linhas_ivc            := 0;
    vn_ultima_linha_ivc           := 0;

    FOR ivc IN 1..vn_global_ivc_lin LOOP

      OPEN cur_tp_linha(tb_ivc_lin(ivc).invoice_id);
      FETCH cur_tp_linha INTO vc_tp_linha;
      CLOSE cur_tp_linha;

      IF (vc_tp_linha = 'M') THEN -- só executa se existir pelo menos uma linha de mercadoria

        imp_prc_busca_taxa_conversao (tb_ivc_lin(ivc).moeda_fob_id,
                                      pd_data_totalizar,
                                      vn_taxa_mn,
                                      vn_taxa_us,
                                      'Invoice');

        IF (vn_ivc_anterior_id <> tb_ivc_lin(ivc).invoice_id) THEN
          vn_soma_rateio_dspfob         := 0;
          vn_soma_rateio_sgivc          := 0;
          vn_ivcfob                     := ivc;
          vn_vrt_fob_ivc                := 0;
          vn_vrt_fr_ivc                 := 0;
          vn_vrt_dspfob_ivc             := 0;
          vn_ind_dspfob_ivc             := 0;
          vn_vrt_sg_ivc                 := 0;
          vn_ind_sg_ivc                 := 0;
          vn_pesoliq_tot_ivc            := 0;
          vn_maior_valor_dspfob_rateada := 0;
          vn_linha_maior_valor_dspfob   := 0;
          vn_diferenca_dspfob           := 0;
          vn_qtde_linhas_ivc            := 0;
          vn_ultima_linha_ivc           := 0;

          OPEN  cur_qtde_linhas_mercadoria (tb_ivc_lin(ivc).invoice_id);
          FETCH cur_qtde_linhas_mercadoria INTO vn_qtde_linhas_ivc;
          CLOSE cur_qtde_linhas_mercadoria;

          vn_ultima_linha_ivc := (ivc + vn_qtde_linhas_ivc) - 1;

          OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'D' );
          FETCH cur_vrt_ivc_por_tipo INTO vn_vrt_dspfob_ivc;
          CLOSE cur_vrt_ivc_por_tipo;

          vn_global_vrt_dspfob_ebq_m := vn_global_vrt_dspfob_ebq_m + vn_vrt_dspfob_ivc;
          OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'S' );
          FETCH cur_vrt_ivc_por_tipo INTO vn_vrt_sg_ivc;
          CLOSE cur_vrt_ivc_por_tipo;

          WHILE ((vn_ivcfob <= vn_global_ivc_lin) AND (tb_ivc_lin(vn_ivcfob).invoice_id = tb_ivc_lin(ivc).invoice_id)) LOOP
            vn_vrt_fob_ivc := vn_vrt_fob_ivc + nvl(tb_ivc_lin(vn_ivcfob).vrt_fob_m,0);
            vn_vrt_fr_ivc  := vn_vrt_fr_ivc  + nvl(tb_ivc_lin(vn_ivcfob).vrt_frivc_m,0);
            vn_pesoliq_tot_ivc := vn_pesoliq_tot_ivc + nvl(tb_ivc_lin(vn_ivcfob).pesoliq_tot,0);
            vn_ivcfob      := vn_ivcfob + 1;
          END LOOP;

          IF (vn_vrt_dspfob_ivc > 0) THEN
            IF (vn_pesoliq_tot_ivc    > 0) THEN
              vn_ind_dspfob_ivc := vn_vrt_dspfob_ivc / vn_pesoliq_tot_ivc ;
            ELSE
              prc_gera_log_erros ('Peso Líquido da invoice zerado, despesas FOB não rateadas...', 'E', 'A');
            END IF;
          END IF;

          IF (vn_vrt_sg_ivc > 0) THEN
            IF (vn_vrt_fob_ivc > 0) THEN
              vn_ind_sg_ivc    := vn_vrt_sg_ivc / ( vn_vrt_fob_ivc + vn_vrt_dspfob_ivc );
            ELSE
              prc_gera_log_erros ('Valor FOB da invoice zerado, seguro internacional não rateado...', 'E', 'A');
            END IF;
          END IF;

          vn_ivc_anterior_id := tb_ivc_lin(ivc).invoice_id;

        END IF;

        tb_ivc_lin(ivc).taxa_mn_fob := vn_taxa_mn;
        tb_ivc_lin(ivc).taxa_us_fob := vn_taxa_us;

        tb_ivc_lin(ivc).vrt_dspfob_m := round (nvl (tb_ivc_lin(ivc).pesoliq_tot * vn_ind_dspfob_ivc, 0), 2);
        vn_soma_rateio_dspfob        := vn_soma_rateio_dspfob + tb_ivc_lin(ivc).vrt_dspfob_m;

        IF (tb_ivc_lin(ivc).vrt_dspfob_m > vn_maior_valor_dspfob_rateada) THEN
          vn_linha_maior_valor_dspfob   := ivc;
          vn_maior_valor_dspfob_rateada := tb_ivc_lin(ivc).vrt_dspfob_m;
        END IF;

        /* Quando temos uma despesa FOB muito pequena (por exemplo 0,01) a
          multiplicacao entre o peso liquido e o indice gera um valor muito
          pequeno e ao aplicar-se o round nesse valor obtemos o valor 0 (zero)
          Desta forma quando chegamos ao momento de atribuir a diferenca entre
          o valor rateado e o valor da despesa FOB, temos as variaveis
          vn_soma_rateio_dspfob e vn_linha_maior_valor_dspfob preenchidas com
          zero gerando um valor de diferenca (vn_diferenca_dspfob) mas ocasionando
          o erro no_data_found ao fazer as atribuições da diferenca para a linha
          com o maior valor de despesa FOB.
          Exemplo:
          vn_linha_maior_valor_dspfob = 0
          vn_diferenca_dspfob := vn_vrt_dspfob_ivc - vn_soma_rateio_dspfob
          vn_diferenca_dspfob := 0,01 - 0
          vn_diferenca_dspfob := 0,01
        */
        IF (ivc = vn_ultima_linha_ivc) THEN
          IF nvl (vn_vrt_dspfob_ivc, 0) > 0 THEN
            vn_diferenca_dspfob := vn_vrt_dspfob_ivc - vn_soma_rateio_dspfob;

            IF (vn_linha_maior_valor_dspfob > 0) THEN
              tb_ivc_lin(vn_linha_maior_valor_dspfob).vrt_dspfob_m  := tb_ivc_lin(vn_linha_maior_valor_dspfob).vrt_dspfob_m + vn_diferenca_dspfob;
              tb_ivc_lin(vn_linha_maior_valor_dspfob).vrt_dspfob_mn := tb_ivc_lin(vn_linha_maior_valor_dspfob).vrt_dspfob_m * vn_taxa_mn;
              tb_ivc_lin(vn_linha_maior_valor_dspfob).vrt_dspfob_us := tb_ivc_lin(vn_linha_maior_valor_dspfob).vrt_dspfob_m * vn_taxa_us;
            ELSE
              tb_ivc_lin(ivc).vrt_dspfob_m  := tb_ivc_lin(ivc).vrt_dspfob_m + vn_diferenca_dspfob;
              tb_ivc_lin(ivc).vrt_dspfob_mn := tb_ivc_lin(ivc).vrt_dspfob_m * vn_taxa_mn;
              tb_ivc_lin(ivc).vrt_dspfob_us := tb_ivc_lin(ivc).vrt_dspfob_m * vn_taxa_us;
            END IF; -- IF (vn_linha_maior_valor_dspfob > 0) THEN
          END IF; -- IF nvl (vn_vrt_dspfob_ivc, 0) > 0 THEN
        END IF; -- IF (ivc = vn_ultima_linha_ivc) THEN

        IF (ivc = vn_global_ivc_lin) THEN
          tb_ivc_lin(ivc).vrt_sgivc_m := vn_vrt_sg_ivc - vn_soma_rateio_sgivc;
        ELSE
          tb_ivc_lin(ivc).vrt_sgivc_m := ( tb_ivc_lin(ivc).vrt_fob_m + tb_ivc_lin(ivc).vrt_dspfob_m ) * vn_ind_sg_ivc;
        END IF;

        IF (tb_ivc_lin(ivc).flag_sg_embutido = 'S') THEN
          tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_m - tb_ivc_lin(ivc).vrt_sgivc_m;
        END IF;

        tb_ivc_lin(ivc).vrt_dspfob_mn := tb_ivc_lin(ivc).vrt_dspfob_m * vn_taxa_mn;
        tb_ivc_lin(ivc).vrt_fob_mn    := tb_ivc_lin(ivc).vrt_fob_m    * vn_taxa_mn;
        tb_ivc_lin(ivc).vrt_dspfob_us := tb_ivc_lin(ivc).vrt_dspfob_m * vn_taxa_us;
        tb_ivc_lin(ivc).vrt_fob_us    := tb_ivc_lin(ivc).vrt_fob_m    * vn_taxa_us;

        tb_ivc_lin(ivc).vrt_dsp_ddu_mn := tb_ivc_lin(ivc).vrt_dsp_ddu_m * vn_taxa_mn;
        tb_ivc_lin(ivc).vrt_dsp_ddu_us := tb_ivc_lin(ivc).vrt_dsp_ddu_m * vn_taxa_us;

        vn_soma_rateio_sgivc         := vn_soma_rateio_sgivc        + tb_ivc_lin(ivc).vrt_sgivc_m;

        vn_global_vrt_fob_ebq_mn     := vn_global_vrt_fob_ebq_mn    + tb_ivc_lin(ivc).vrt_fob_mn;
        vn_global_vrt_fob_ebq_us     := vn_global_vrt_fob_ebq_us    + tb_ivc_lin(ivc).vrt_fob_us;

        IF ( vn_global_moeda_sg_id IS NOT null ) THEN
          vn_global_vrt_base_seguro    := vn_global_vrt_base_seguro
                                      + cmx_pkg_taxas.fnc_converte (
                                          tb_ivc_lin(ivc).vrt_fob_m+tb_ivc_lin(ivc).vrt_dspfob_m
                                        , tb_ivc_lin(ivc).moeda_fob_id
                                        , vn_global_moeda_sg_id
                                        , nvl (imp_fnc_busca_dt_cronog (pn_embarque_id, vc_global_data_base_seguro, 'R'), pd_data_totalizar)
                                        , 'FISCAL'
                                        );
        END IF;
        vn_global_vrt_dspfob_ebq_m   := vn_global_vrt_dspfob_ebq_m  + tb_ivc_lin(ivc).vrt_dspfob_m;
        vn_global_vrt_dspfob_ebq_mn  := vn_global_vrt_dspfob_ebq_mn + tb_ivc_lin(ivc).vrt_dspfob_mn;
        vn_global_vrt_dspfob_ebq_us  := vn_global_vrt_dspfob_ebq_us + tb_ivc_lin(ivc).vrt_dspfob_us;
      END IF; -- só executa se existir pelo menos uma linha de mercadoria
    END LOOP;
    -------------------------------------------------------------------
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no rateio dos valores da invoice: ' || sqlerrm, 'E', 'A');
  END imp_prc_rateia_valores_invoice;

  -- ***********************************************************************
  -- Esta procedure ira buscar todas as linhas de mercadoria das invoices e
  -- ratear o valor de frete internacional do conhecimento de transporte.
  -- ***********************************************************************
  PROCEDURE imp_prc_processa_fr_internac (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER, pd_data_totalizar DATE, pn_declaracao_id NUMBER) IS
    vn_moeda_fr_id         NUMBER := 0;

    vn_taxa_mn             NUMBER := 0;
    vn_taxa_us             NUMBER := 0;
    vn_taxa_ivc_mn         NUMBER := 0;
    vn_taxa_ivc_us         NUMBER := 0;

    vn_ind_fr_m            NUMBER := 0; -- Frete utilizado para base de calculo
    vn_ind_fr_total_m      NUMBER := 0; -- Soma do collect + prepaid
    vn_ind_fr_collect_m    NUMBER := 0;
    vn_ind_fr_prepaid_m    NUMBER := 0;
    vn_ind_fr_terr_nac_m   NUMBER := 0;

    vn_soma_fr_m           NUMBER := 0;
    vn_soma_fr_total_m     NUMBER := 0;
    vn_soma_fr_collect_m   NUMBER := 0;
    vn_soma_fr_prepaid_m   NUMBER := 0;
    vn_soma_fr_terr_nac_m  NUMBER := 0;
    vn_soma_fr_mn          NUMBER := 0;
    vn_soma_fr_total_mn    NUMBER := 0;
    vn_soma_fr_collect_mn  NUMBER := 0;
    vn_soma_fr_prepaid_mn  NUMBER := 0;
    vn_soma_fr_terr_nac_mn NUMBER := 0;
    vn_soma_fr_us          NUMBER := 0;
    vn_soma_fr_total_us    NUMBER := 0;
    vn_soma_fr_collect_us  NUMBER := 0;
    vn_soma_fr_prepaid_us  NUMBER := 0;
    vn_soma_fr_terr_nac_us NUMBER := 0;
    vn_convertido          NUMBER := 0;
    vn_da_conhec_id        NUMBER;
    vb_achou_conhec        BOOLEAN := FALSE;

    vn_prev_conhec_moeda_id NUMBER;
    vn_vlr_total_prev       imp_embarques.prev_valor_total_m%TYPE;
    vn_vlr_fr_total_prev    NUMBER;
    vn_vlr_prepaid_prev     imp_embarques.prev_vlr_prepaid%TYPE;
    vn_vlr_collect_prev     imp_embarques.prev_vlr_collect%TYPE;
    vn_vlr_ter_nac_prev     imp_embarques.prev_vlr_ter_nac%TYPE;

    vn_moeda_id_rem             imp_conhecimentos.moeda_id%TYPE;
    vn_vrt_fr_m_rem             imp_conhecimentos.valor_total_m%TYPE;
    vn_vrt_fr_total_m_rem       NUMBER;
    vn_vrt_fr_prepaid_m_rem     imp_conhecimentos.valor_prepaid_m%TYPE;
    vn_vrt_fr_collect_m_rem     imp_conhecimentos.valor_collect_m%TYPE;
    vn_vrt_fr_terr_nac_m_rem    imp_conhecimentos.valor_terr_nacional_m%TYPE;

    vn_moeda_id_rem_tot             NUMBER;
    vn_vrt_fr_m_rem_tot             NUMBER;
    vn_vrt_fr_total_m_rem_tot       NUMBER;
    vn_vrt_fr_prepaid_m_rem_tot     NUMBER;
    vn_vrt_fr_collect_m_rem_tot     NUMBER;
    vn_vrt_fr_terr_nac_m_rem_tot    NUMBER;

    CURSOR cur_conhecimento IS
      SELECT ic.moeda_id
           , nvl (ic.valor_total_m, 0)
           , nvl (ic.valor_prepaid_m, 0) + nvl (ic.valor_collect_m, 0)
           , nvl (ic.valor_prepaid_m, 0)
           , nvl (ic.valor_collect_m, 0)
           , nvl (ic.valor_terr_nacional_m, 0)
        FROM imp_conhecimentos ic,
             imp_embarques     ie
       WHERE ie.embarque_id = pn_embarque_id
         AND ic.conhec_id   = ie.conhec_id;

    CURSOR cur_conhec_rem IS
      SELECT ic.moeda_id
           , nvl (ic.valor_total_m, 0)
           , nvl (ic.valor_prepaid_m, 0) + nvl (ic.valor_collect_m, 0)
           , nvl (ic.valor_prepaid_m, 0)
           , nvl (ic.valor_collect_m, 0)
           , nvl (ic.valor_terr_nacional_m, 0)
        FROM imp_conhecimentos ic,
             imp_po_remessa    re
       WHERE re.embarque_id = pn_embarque_id
         AND ic.conhec_id   = re.conhec_id
         AND re.nr_remessa  = 1;

    CURSOR cur_vlr_previstos IS
      SELECT prev_conhec_moeda_id
           , Nvl(prev_valor_total_m, 0)
           , Nvl(prev_vlr_prepaid,0) + Nvl(prev_vlr_collect,0)
           , Nvl(prev_vlr_prepaid,0)
           , Nvl(prev_vlr_collect,0)
           , Nvl(prev_vlr_ter_nac,0)
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_linhas_li( pn_da_conhec_id NUMBER ) IS
      SELECT imp_conhecimentos_da.moeda_frete_id
           , ((iil.vrt_fr_m                     / idlda.qtde) * imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada))  vrt_fr_m
           , ((iil.vrt_fr_total_m               / idlda.qtde) * imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada))  vrt_fr_total_m
           , ((iil.vrt_fr_prepaid_m             / idlda.qtde) * imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada))  vrt_fr_prepaid_m
           , ((iil.vrt_fr_collect_m             / idlda.qtde) * imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada))  vrt_fr_collect_m
           , ((iil.vrt_fr_territorio_nacional_m / idlda.qtde) * imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada))  vrt_fr_territorio_nacional_m
	         , ill.invoice_lin_id
        FROM imp_declaracoes_adi   ida
           , imp_declaracoes_lin   idlda
           , imp_invoices_lin      iil
       	   , imp_licencas_lin      ill
       	   , imp_embarques         ie
           , (SELECT ic.moeda_id moeda_frete_id
                FROM imp_conhecimentos ic
               WHERE ic.conhec_id = pn_da_conhec_id
             ) imp_conhecimentos_da
       WHERE ie.embarque_id            = pn_embarque_id
         AND ie.embarque_id            = ill.embarque_id
         AND idlda.declaracao_lin_id   = ill.da_lin_id
         AND ida.declaracao_adi_id     = idlda.declaracao_adi_id
 	       AND iil.invoice_lin_id        = idlda.invoice_lin_id
         AND NOT EXISTS (SELECT null
                           FROM imp_declaracoes_lin
                          WHERE ill.licenca_lin_id = imp_declaracoes_lin.licenca_lin_id
                        );

    CURSOR cur_da_id IS
     SELECT conhec_id
       FROM imp_embarques   ie
          , imp_declaracoes da
          , imp_declaracoes di
      WHERE di.embarque_id = pn_embarque_id
        AND da.declaracao_id = di.da_id
        AND ie.embarque_id   = da.embarque_id ;

    CURSOR cur_checa_retif IS
      SELECT retificada
        FROM imp_po_remessa
       WHERE po_remessa_id = (SELECT Max(po_remessa_id)
                                FROM imp_po_remessa
                               WHERE embarque_id = pn_embarque_id);

    CURSOR cur_conhec_rem_total IS
      SELECT (SELECT ic.moeda_id
                FROM imp_conhecimentos ic
                   , imp_po_remessa re
               WHERE re.embarque_id = pn_embarque_id
                 AND ic.conhec_id   = re.conhec_id
                 AND re.nr_remessa = 1) moeda_id
           , Sum(nvl (ic.valor_total_m, 0))
           , Sum(nvl (ic.valor_prepaid_m, 0) + nvl (ic.valor_collect_m, 0))
           , Sum(nvl (ic.valor_prepaid_m, 0))
           , Sum(nvl (ic.valor_collect_m, 0))
           , Sum(nvl (ic.valor_terr_nacional_m, 0))
        FROM imp_conhecimentos ic,
             imp_po_remessa    re
       WHERE re.embarque_id = pn_embarque_id
         AND ic.conhec_id   = re.conhec_id
       GROUP BY 1;

    CURSOR cur_tp_embarque IS
      SELECT ebq.tp_embarque_id
           , cmx_pkg_empresas.pais_id(ebq.empresa_id) AS pais_id
        FROM imp_embarques ebq
       WHERE ebq.embarque_id     = pn_embarque_id;

    CURSOR cur_ebq_nac_de_daf (pn_cur_tp_embarque_id NUMBER )IS
      SELECT tab.auxiliar1
        FROM cmx_tabelas tab
        WHERE tab.tabela_id = pn_cur_tp_embarque_id
        AND tab.auxiliar1   IN ('NAC', 'NAC_TERC')    /* Alterado para atender o embarque de nacionalizacao de terceiro 06.01.2017 */
        AND tab.auxiliar9   IN ('DE', 'DAF');

    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    CURSOR cur_valores_ivc_da IS
      SELECT iil.valor_frete
           , iil.moeda_da_nac_id
           , iil.invoice_lin_id
        FROM imp_invoices_lin      iil
       	   , imp_invoices          ii--, imp_licencas_lin      ill
       	   , imp_embarques         ie
       WHERE ie.embarque_id            = pn_embarque_id
         AND ie.embarque_id            = ii.embarque_id
         AND ii.invoice_id             = iil.invoice_id;
    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

    CURSOR cur_sobreescrita_frete IS
      SELECT
          Nvl(atributo6, 'N') sobreescrever
        , atributo7 moeda_id
        , Nvl(atributo8, 0) valor_prepaid
        , Nvl(atributo9, 0) valor_collect
        , Nvl(atributo10, 0) valor_terr_nac
      FROM
          imp_declaracoes
      WHERE
          declaracao_id = pn_declaracao_id;

    vc_retificada        imp_po_remessa.retificada%TYPE;
    vc_embarque_nac      VARCHAR2(20);
    vn_tp_embarque_id    NUMBER;
    vn_pais_id               NUMBER;
    vn_valor_total_invoices  NUMBER;

    vc_sobreescrever_frete CHAR(1);
    vn_valor_prepaid NUMBER;
    vn_valor_collect NUMBER;
    vn_valor_terr_nac NUMBER;

  BEGIN
    OPEN  cur_tp_embarque;
    FETCH cur_tp_embarque INTO vn_tp_embarque_id, vn_pais_id;
    CLOSE cur_tp_embarque;

    OPEN  cur_ebq_nac_de_daf(vn_tp_embarque_id);
    FETCH cur_ebq_nac_de_daf INTO vc_embarque_nac;
    CLOSE cur_ebq_nac_de_daf;

    --Customização UHK
    OPEN  cur_sobreescrita_frete;
    FETCH cur_sobreescrita_frete INTO vc_sobreescrever_frete
                                    , vn_moeda_fr_id
                                    , vn_valor_prepaid
                                    , vn_valor_collect
                                    , vn_valor_terr_nac;

    IF ( Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id,1),'XX') <> 'NAC_DE_TERC' ) THEN
      -- Rateando conhecimento para Nacionalização de Admissão temporaria tambem
       --Customização UHK
       IF( (NVL(vc_sobreescrever_frete, 'N') = 'N' AND (pn_tp_declaracao < 13 OR vc_global_nac_sem_admissao  = 'S' ) AND ( Nvl(vc_embarque_nac,'XX') NOT IN ('NAC', 'NAC_TERC'))) OR
        (NVL(vc_sobreescrever_frete, 'N') = 'S' AND (pn_tp_declaracao = 14 ))
        --AND ( pn_tp_declaracao NOT IN(13, 14) AND cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id, 1) IS NULL )
      )THEN
        IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
        /* Aqui verifica se o tipo do embarque é DI ÚNICA e utiliza os dados da remessa nr 1 ou dos valores previstos no planejamento */
          OPEN cur_vlr_previstos;
          FETCH cur_vlr_previstos INTO vn_prev_conhec_moeda_id
                                    , vn_vlr_total_prev
                                    , vn_vlr_fr_total_prev
                                    , vn_vlr_prepaid_prev
                                    , vn_vlr_collect_prev
                                    , vn_vlr_ter_nac_prev;
          CLOSE cur_vlr_previstos;
          IF (vn_prev_conhec_moeda_id IS NULL) THEN
            OPEN cur_checa_retif;
            FETCH cur_checa_retif INTO vc_retificada;
            CLOSE cur_checa_retif;

            IF (vc_retificada = 'S') THEN
              OPEN cur_conhec_rem_total;
              FETCH cur_conhec_rem_total INTO vn_moeda_id_rem_tot
                                            , vn_vrt_fr_m_rem_tot
                                            , vn_vrt_fr_total_m_rem_tot
                                            , vn_vrt_fr_prepaid_m_rem_tot
                                            , vn_vrt_fr_collect_m_rem_tot
                                            , vn_vrt_fr_terr_nac_m_rem_tot;
              vb_achou_conhec := cur_conhec_rem_total%FOUND;
              CLOSE cur_conhec_rem_total;

              vn_moeda_fr_id                := vn_moeda_id_rem_tot;
              vn_global_vrt_fr_m            := vn_vrt_fr_m_rem_tot;
              vn_global_vrt_fr_total_m      := vn_vrt_fr_total_m_rem_tot;
              vn_global_vrt_fr_prepaid_m    := vn_vrt_fr_prepaid_m_rem_tot;
              vn_global_vrt_fr_collect_m    := vn_vrt_fr_collect_m_rem_tot;
              vn_global_vrt_fr_terr_nac_m   := vn_vrt_fr_terr_nac_m_rem_tot;

              imp_prc_busca_taxa_conversao ( vn_moeda_fr_id
                                          , pd_data_totalizar
                                          , vn_taxa_mn
                                          , vn_taxa_us
                                          , 'Conhec.Transporte'
                                          );

              vn_global_vrt_fr_mn          := round (vn_global_vrt_fr_m          * vn_taxa_mn, 7);
              vn_global_vrt_fr_total_mn    := round (vn_global_vrt_fr_total_m    * vn_taxa_mn, 7);
              vn_global_vrt_fr_prepaid_mn  := round (vn_global_vrt_fr_prepaid_m  * vn_taxa_mn, 7);
              vn_global_vrt_fr_collect_mn  := round (vn_global_vrt_fr_collect_m  * vn_taxa_mn, 7);
              vn_global_vrt_fr_terr_nac_mn := round (vn_global_vrt_fr_terr_nac_m * vn_taxa_mn, 7);

            ELSE
              OPEN cur_conhec_rem;
              FETCH cur_conhec_rem INTO vn_moeda_id_rem
                                      , vn_vrt_fr_m_rem
                                      , vn_vrt_fr_total_m_rem
                                      , vn_vrt_fr_prepaid_m_rem
                                      , vn_vrt_fr_collect_m_rem
                                      , vn_vrt_fr_terr_nac_m_rem;
              vb_achou_conhec := cur_conhec_rem%FOUND;
              CLOSE cur_conhec_rem;

              vn_moeda_fr_id                := vn_moeda_id_rem;
              vn_global_vrt_fr_m            := vn_vrt_fr_m_rem;
              vn_global_vrt_fr_total_m      := vn_vrt_fr_total_m_rem;
              vn_global_vrt_fr_prepaid_m    := vn_vrt_fr_prepaid_m_rem;
              vn_global_vrt_fr_collect_m    := vn_vrt_fr_collect_m_rem;
              vn_global_vrt_fr_terr_nac_m   := vn_vrt_fr_terr_nac_m_rem;

              imp_prc_busca_taxa_conversao ( vn_moeda_fr_id
                                          , pd_data_totalizar
                                          , vn_taxa_mn
                                          , vn_taxa_us
                                          , 'Conhec.Transporte'
                                          );

              vn_global_vrt_fr_mn          := round (vn_global_vrt_fr_m          * vn_taxa_mn, 7);
              vn_global_vrt_fr_total_mn    := round (vn_global_vrt_fr_total_m    * vn_taxa_mn, 7);
              vn_global_vrt_fr_prepaid_mn  := round (vn_global_vrt_fr_prepaid_m  * vn_taxa_mn, 7);
              vn_global_vrt_fr_collect_mn  := round (vn_global_vrt_fr_collect_m  * vn_taxa_mn, 7);
              vn_global_vrt_fr_terr_nac_mn := round (vn_global_vrt_fr_terr_nac_m * vn_taxa_mn, 7);
            END IF;
          ELSE
            vn_moeda_fr_id                := vn_prev_conhec_moeda_id;
            vn_global_vrt_fr_m            := vn_vlr_total_prev;
            vn_global_vrt_fr_total_m      := vn_vlr_fr_total_prev;
            vn_global_vrt_fr_prepaid_m    := vn_vlr_prepaid_prev;
            vn_global_vrt_fr_collect_m    := vn_vlr_collect_prev;
            vn_global_vrt_fr_terr_nac_m   := vn_vlr_ter_nac_prev;

            imp_prc_busca_taxa_conversao ( vn_moeda_fr_id
                                        , pd_data_totalizar
                                        , vn_taxa_mn
                                        , vn_taxa_us
                                        , 'Conhec.Transporte'
                                        );

            vn_global_vrt_fr_mn          := round (vn_global_vrt_fr_m          * vn_taxa_mn, 7);
            vn_global_vrt_fr_total_mn    := round (vn_global_vrt_fr_total_m    * vn_taxa_mn, 7);
            vn_global_vrt_fr_prepaid_mn  := round (vn_global_vrt_fr_prepaid_m  * vn_taxa_mn, 7);
            vn_global_vrt_fr_collect_mn  := round (vn_global_vrt_fr_collect_m  * vn_taxa_mn, 7);
            vn_global_vrt_fr_terr_nac_mn := round (vn_global_vrt_fr_terr_nac_m * vn_taxa_mn, 7);
          END IF;
        ELSE --IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
          --Customização UHK
          IF vc_sobreescrever_frete = 'S' THEN
            vn_global_vrt_fr_m := vn_valor_prepaid + vn_valor_collect - vn_valor_terr_nac;
            vn_global_vrt_fr_total_m := vn_valor_prepaid + vn_valor_collect;
            vn_global_vrt_fr_prepaid_m := vn_valor_prepaid;
            vn_global_vrt_fr_collect_m := vn_valor_collect;
            vn_global_vrt_fr_terr_nac_m :=  vn_valor_terr_nac;

            vb_achou_conhec := TRUE;
          ELSE
            OPEN  cur_conhecimento;
            FETCH cur_conhecimento INTO vn_moeda_fr_id
                                    , vn_global_vrt_fr_m
                                    , vn_global_vrt_fr_total_m
                                    , vn_global_vrt_fr_prepaid_m
                                    , vn_global_vrt_fr_collect_m
                                    , vn_global_vrt_fr_terr_nac_m;
            vb_achou_conhec := cur_conhecimento%FOUND;
            CLOSE cur_conhecimento;
          END IF;

          vn_global_moeda_fr_id := vn_moeda_fr_id;
          IF (NOT vb_achou_conhec AND Nvl (pn_tp_declaracao, '00') NOT IN ('13', '14', '15')) THEN
            prc_gera_log_erros ('Conhecimento de transporte não informado para o embarque, frete internacional não rateado...', 'A', 'D');
          ELSE
            imp_prc_busca_taxa_conversao ( vn_moeda_fr_id
                                        , pd_data_totalizar
                                        , vn_taxa_mn
                                        , vn_taxa_us
                                        , 'Conhec.Transporte'
                                        );
          END IF;

          vn_global_vrt_fr_mn          := round (vn_global_vrt_fr_m          * vn_taxa_mn, 7);
          vn_global_vrt_fr_total_mn    := round (vn_global_vrt_fr_total_m    * vn_taxa_mn, 7);
          vn_global_vrt_fr_prepaid_mn  := round (vn_global_vrt_fr_prepaid_m  * vn_taxa_mn, 7);
          vn_global_vrt_fr_collect_mn  := round (vn_global_vrt_fr_collect_m  * vn_taxa_mn, 7);
          vn_global_vrt_fr_terr_nac_mn := round (vn_global_vrt_fr_terr_nac_m * vn_taxa_mn, 7);
        END IF;
        IF (vc_global_tp_base_seguro <> 'F') AND (vn_global_moeda_sg_id IS NOT null )THEN
          IF nvl( vn_global_vrt_fr_m, 0) > 0 THEN
            vn_convertido := cmx_pkg_taxas.fnc_converte ( vn_global_vrt_fr_m
                                                        , vn_moeda_fr_id
                                                        , vn_global_moeda_sg_id
                                                        , nvl (imp_fnc_busca_dt_cronog (pn_embarque_id, vc_global_data_base_seguro, 'R'), pd_data_totalizar)
                                                        , 'FISCAL'
                                                        );
          ELSE
            vn_convertido := 0;
          END IF; -- IF nvl( vn_global_vrt_fr_m, 0) > 0 THEN

          vn_global_vrt_base_seguro := vn_global_vrt_base_seguro + vn_convertido;

        END IF; -- IF (vc_global_tp_base_seguro <> 'F') AND (vn_global_moeda_sg_id IS NOT null )THEN

      IF( Nvl(cmx_pkg_tabelas.auxiliar(vn_pais_id, '19'), 'PESO') = 'PESO' )THEN

        IF (nvl (vn_global_pesoliq_ebq, 0) > 0) THEN
          vn_ind_fr_m           := vn_global_vrt_fr_m          / vn_global_pesoliq_ebq;
          vn_ind_fr_total_m     := vn_global_vrt_fr_total_m    / vn_global_pesoliq_ebq;
          vn_ind_fr_prepaid_m   := vn_global_vrt_fr_prepaid_m  / vn_global_pesoliq_ebq;
          vn_ind_fr_collect_m   := vn_global_vrt_fr_collect_m  / vn_global_pesoliq_ebq;
          vn_ind_fr_terr_nac_m  := vn_global_vrt_fr_terr_nac_m / vn_global_pesoliq_ebq;
        ELSE
          vn_ind_fr_m           := 0;
          vn_ind_fr_total_m     := 0;
          vn_ind_fr_prepaid_m   := 0;
          vn_ind_fr_collect_m   := 0;
          vn_ind_fr_terr_nac_m  := 0;
        END IF;

      /* FOB */
      ELSE
        vn_valor_total_invoices := 0;

        FOR ivc IN 1..vn_global_ivc_lin LOOP
          vn_valor_total_invoices := vn_valor_total_invoices + tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m;
        END LOOP;

        IF (nvl (vn_global_pesoliq_ebq, 0) > 0) THEN
          vn_ind_fr_m           := vn_global_vrt_fr_m          / vn_valor_total_invoices;
          vn_ind_fr_total_m     := vn_global_vrt_fr_total_m    / vn_valor_total_invoices;
          vn_ind_fr_prepaid_m   := vn_global_vrt_fr_prepaid_m  / vn_valor_total_invoices;
          vn_ind_fr_collect_m   := vn_global_vrt_fr_collect_m  / vn_valor_total_invoices;
          vn_ind_fr_terr_nac_m  := vn_global_vrt_fr_terr_nac_m / vn_valor_total_invoices;
        ELSE
          vn_ind_fr_m           := 0;
          vn_ind_fr_total_m     := 0;
          vn_ind_fr_prepaid_m   := 0;
          vn_ind_fr_collect_m   := 0;
          vn_ind_fr_terr_nac_m  := 0;
        END IF;

      END IF;

        FOR ivc IN 1..vn_global_ivc_lin LOOP
          tb_ivc_lin(ivc).taxa_mn_fr := vn_taxa_mn;
          tb_ivc_lin(ivc).taxa_us_fr := vn_taxa_us;

          IF tb_ivc_lin(ivc).numero_nf IS null THEN
            IF (ivc = vn_global_ivc_lin) THEN
              tb_ivc_lin(ivc).vrt_fr_m                      := vn_global_vrt_fr_m           - vn_soma_fr_m;
              tb_ivc_lin(ivc).vrt_fr_total_m                := vn_global_vrt_fr_total_m     - vn_soma_fr_total_m;
              tb_ivc_lin(ivc).vrt_fr_prepaid_m              := vn_global_vrt_fr_prepaid_m   - vn_soma_fr_prepaid_m;
              tb_ivc_lin(ivc).vrt_fr_collect_m              := vn_global_vrt_fr_collect_m   - vn_soma_fr_collect_m;
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m  := vn_global_vrt_fr_terr_nac_m  - vn_soma_fr_terr_nac_m;
              tb_ivc_lin(ivc).vrt_fr_mn                     := vn_global_vrt_fr_mn          - vn_soma_fr_mn;
              tb_ivc_lin(ivc).vrt_fr_total_mn               := vn_global_vrt_fr_total_mn    - vn_soma_fr_total_mn;
              tb_ivc_lin(ivc).vrt_fr_prepaid_mn             := vn_global_vrt_fr_prepaid_mn  - vn_soma_fr_prepaid_mn;
              tb_ivc_lin(ivc).vrt_fr_collect_mn             := vn_global_vrt_fr_collect_mn  - vn_soma_fr_collect_mn;
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn := vn_global_vrt_fr_terr_nac_mn - vn_soma_fr_terr_nac_mn;
              tb_ivc_lin(ivc).vrt_fr_us                     := round (vn_global_vrt_fr_m          * vn_taxa_us, 2) - vn_soma_fr_us;
              tb_ivc_lin(ivc).vrt_fr_total_us               := round (vn_global_vrt_fr_total_m    * vn_taxa_us, 2) - vn_soma_fr_total_us;
              tb_ivc_lin(ivc).vrt_fr_prepaid_us             := round (vn_global_vrt_fr_prepaid_m  * vn_taxa_us, 2) - vn_soma_fr_prepaid_us;
              tb_ivc_lin(ivc).vrt_fr_collect_us             := round (vn_global_vrt_fr_collect_m  * vn_taxa_us, 2) - vn_soma_fr_collect_us;
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us := round (vn_global_vrt_fr_terr_nac_m * vn_taxa_us, 2) - vn_soma_fr_terr_nac_us;
            ELSE

            IF( Nvl(cmx_pkg_tabelas.auxiliar(vn_pais_id, '19'), 'PESO') = 'PESO' )THEN
              tb_ivc_lin(ivc).vrt_fr_m                      := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_fr_m;
              tb_ivc_lin(ivc).vrt_fr_total_m                := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_fr_total_m;
              tb_ivc_lin(ivc).vrt_fr_prepaid_m              := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_fr_prepaid_m;
              tb_ivc_lin(ivc).vrt_fr_collect_m              := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_fr_collect_m;
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m  := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_fr_terr_nac_m;

            /* FOB */
            ELSE
              tb_ivc_lin(ivc).vrt_fr_m                      := (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m) * vn_ind_fr_m;
              tb_ivc_lin(ivc).vrt_fr_total_m                := (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m) * vn_ind_fr_total_m;
              tb_ivc_lin(ivc).vrt_fr_prepaid_m              := (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m) * vn_ind_fr_prepaid_m;
              tb_ivc_lin(ivc).vrt_fr_collect_m              := (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m) * vn_ind_fr_collect_m;
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m  := (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m) * vn_ind_fr_terr_nac_m;
            END IF;

              tb_ivc_lin(ivc).vrt_fr_mn                     := tb_ivc_lin(ivc).vrt_fr_m                     * vn_taxa_mn;
              tb_ivc_lin(ivc).vrt_fr_total_mn               := tb_ivc_lin(ivc).vrt_fr_total_m               * vn_taxa_mn;
              tb_ivc_lin(ivc).vrt_fr_prepaid_mn             := tb_ivc_lin(ivc).vrt_fr_prepaid_m             * vn_taxa_mn;
              tb_ivc_lin(ivc).vrt_fr_collect_mn             := tb_ivc_lin(ivc).vrt_fr_collect_m             * vn_taxa_mn;
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn := tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m * vn_taxa_mn;
              tb_ivc_lin(ivc).vrt_fr_us                     := tb_ivc_lin(ivc).vrt_fr_m                     * vn_taxa_us;
              tb_ivc_lin(ivc).vrt_fr_total_us               := tb_ivc_lin(ivc).vrt_fr_total_m               * vn_taxa_us;
              tb_ivc_lin(ivc).vrt_fr_prepaid_us             := tb_ivc_lin(ivc).vrt_fr_prepaid_m             * vn_taxa_us;
              tb_ivc_lin(ivc).vrt_fr_collect_us             := tb_ivc_lin(ivc).vrt_fr_collect_m             * vn_taxa_us;
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us := tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m * vn_taxa_us;
            END IF;
          END IF;

          vn_soma_fr_m           := vn_soma_fr_m           + tb_ivc_lin(ivc).vrt_fr_m;
          vn_soma_fr_total_m     := vn_soma_fr_total_m     + tb_ivc_lin(ivc).vrt_fr_total_m;
          vn_soma_fr_prepaid_m   := vn_soma_fr_prepaid_m   + tb_ivc_lin(ivc).vrt_fr_prepaid_m;
          vn_soma_fr_collect_m   := vn_soma_fr_collect_m   + tb_ivc_lin(ivc).vrt_fr_collect_m;
          vn_soma_fr_terr_nac_m  := vn_soma_fr_terr_nac_m  + tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m;
          vn_soma_fr_mn          := vn_soma_fr_mn          + tb_ivc_lin(ivc).vrt_fr_mn;
          vn_soma_fr_total_mn    := vn_soma_fr_total_mn    + tb_ivc_lin(ivc).vrt_fr_total_mn;
          vn_soma_fr_prepaid_mn  := vn_soma_fr_prepaid_mn  + tb_ivc_lin(ivc).vrt_fr_prepaid_mn;
          vn_soma_fr_collect_mn  := vn_soma_fr_collect_mn  + tb_ivc_lin(ivc).vrt_fr_collect_mn;
          vn_soma_fr_terr_nac_mn := vn_soma_fr_terr_nac_mn + tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn;
          vn_soma_fr_us          := vn_soma_fr_us          + tb_ivc_lin(ivc).vrt_fr_us;
          vn_soma_fr_total_us    := vn_soma_fr_total_us    + tb_ivc_lin(ivc).vrt_fr_total_us;
          vn_soma_fr_prepaid_us  := vn_soma_fr_prepaid_us  + tb_ivc_lin(ivc).vrt_fr_prepaid_us;
          vn_soma_fr_collect_us  := vn_soma_fr_collect_us  + tb_ivc_lin(ivc).vrt_fr_collect_us;
          vn_soma_fr_terr_nac_us := vn_soma_fr_terr_nac_us + tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us;

        END LOOP;

        --Customização UHK
        IF vc_sobreescrever_frete = 'S' THEN
          FOR dcl IN 1..vn_global_dcl_lin LOOP
            FOR ivc IN 1..vn_global_ivc_lin LOOP
              IF tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id THEN
                tb_dcl_lin(dcl).vrt_fr_m := tb_ivc_lin(ivc).vrt_fr_m;
                tb_dcl_lin(dcl).vrt_fr_total_m := tb_ivc_lin(ivc).vrt_fr_total_m;
                tb_dcl_lin(dcl).vrt_fr_prepaid_m := tb_ivc_lin(ivc).vrt_fr_prepaid_m;
                tb_dcl_lin(dcl).vrt_fr_collect_m := tb_ivc_lin(ivc).vrt_fr_collect_m;
                tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m := tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m;
              END IF;
            END LOOP;
          END LOOP;
        END IF;

      --END IF;
      ELSE -- NACIONALIZACAO
        -- Primeiro devemos zerar as linhas da invoices para carregar os valores em LI
        FOR ivc IN 1..vn_global_ivc_lin LOOP
          tb_ivc_lin(ivc).vrt_fr_m                        := 0;
          tb_ivc_lin(ivc).vrt_fr_total_m                  := 0;
          tb_ivc_lin(ivc).vrt_fr_prepaid_m                := 0;
          tb_ivc_lin(ivc).vrt_fr_collect_m                := 0;
          tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m    := 0;
          tb_ivc_lin(ivc).vrt_fr_mn                       := 0;
          tb_ivc_lin(ivc).vrt_fr_total_mn                 := 0;
          tb_ivc_lin(ivc).vrt_fr_prepaid_mn               := 0;
          tb_ivc_lin(ivc).vrt_fr_collect_mn               := 0;
          tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn   := 0;
          tb_ivc_lin(ivc).vrt_fr_us                       := 0;
          tb_ivc_lin(ivc).vrt_fr_total_us                 := 0;
          tb_ivc_lin(ivc).vrt_fr_prepaid_us               := 0;
          tb_ivc_lin(ivc).vrt_fr_collect_us               := 0;
          tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us   := 0;

          vn_global_vrt_fr_m                              := 0;
          vn_global_vrt_fr_total_m                        := 0;
          vn_global_vrt_fr_prepaid_m                      := 0;
          vn_global_vrt_fr_collect_m                      := 0;
          vn_global_vrt_fr_terr_nac_m                     := 0;
          vn_global_vrt_fr_mn                             := 0;
          vn_global_vrt_fr_total_mn                       := 0;
          vn_global_vrt_fr_prepaid_mn                     := 0;
          vn_global_vrt_fr_collect_mn                     := 0;
          vn_global_vrt_fr_terr_nac_mn                    := 0;
          vn_global_vrt_fr_total_us                       := 0;
        END LOOP;

        IF (pn_tp_declaracao = 15 OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N')) then
          -- Devemos identificar qual conhecimento de Transporte dessa DA para podermos
          -- encontrar a moeda da LI processo da nacionalização para as DIs do tipo '14'
          OPEN  cur_da_id ;
          FETCH cur_da_id INTO vn_da_conhec_id;
          CLOSE cur_da_id ;
        END IF;

        -- Se possuir linhas de declaracao
        FOR dcl IN 1..vn_global_dcl_lin LOOP

          /* A cada linha de declaração busca a taxa de conversão para a moeda do frete. Quando é nacionalização podem existir várias moedas de frete diferentes. */
          imp_prc_busca_taxa_conversao (
            tb_dcl_lin(dcl).moeda_frete_id
          , pd_data_totalizar
          , vn_taxa_mn
          , vn_taxa_us
          , 'Moeda do frete internacional da D.A.'
          );

          FOR ivc IN 1..vn_global_ivc_lin LOOP
            IF tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id THEN
              -- O valor do frete na moeda não pode ser calculado para nacionalização de DE
              -- pois a linha de invoice pode estar atrelada a DAs diferentes e ter frete
              -- em moedas diferentes, para o tipo 14 sempre será uma DA
              IF (pn_tp_declaracao = 15 OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N')) THEN
                tb_ivc_lin(ivc).vrt_fr_m                      := nvl (tb_ivc_lin(ivc).vrt_fr_m                     , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_m                     , 0);
                tb_ivc_lin(ivc).vrt_fr_total_m                := nvl (tb_ivc_lin(ivc).vrt_fr_total_m               , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_total_m               , 0);
                tb_ivc_lin(ivc).vrt_fr_prepaid_m              := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_m             , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_prepaid_m             , 0);
                tb_ivc_lin(ivc).vrt_fr_collect_m              := nvl (tb_ivc_lin(ivc).vrt_fr_collect_m             , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_collect_m             , 0);
                tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m  := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m , 0);
              END IF;

              tb_ivc_lin(ivc).vrt_fr_mn                     := nvl (tb_ivc_lin(ivc).vrt_fr_mn                    , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_m                     * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_total_mn               := nvl (tb_ivc_lin(ivc).vrt_fr_total_mn              , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_total_m               * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_prepaid_mn             := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_mn            , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_prepaid_m             * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_collect_mn             := nvl (tb_ivc_lin(ivc).vrt_fr_collect_mn            , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_collect_m             * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn, 0) + nvl (tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_us                     := nvl (tb_ivc_lin(ivc).vrt_fr_us                    , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_m                     * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_total_us               := nvl (tb_ivc_lin(ivc).vrt_fr_total_us              , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_total_m               * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_prepaid_us             := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_us            , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_prepaid_m             * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_collect_us             := nvl (tb_ivc_lin(ivc).vrt_fr_collect_us            , 0) + nvl (tb_dcl_lin(dcl).vrt_fr_collect_m             * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us, 0) + nvl (tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m * vn_taxa_us, 0);


              IF (pn_tp_declaracao IN (17)) THEN
                imp_prc_busca_taxa_conversao (
                  tb_ivc_lin(ivc).moeda_fob_id
                , pd_data_totalizar
                , vn_taxa_ivc_mn
                , vn_taxa_ivc_us
                , 'Moeda do frete internacional da D.A.'
                );

                tb_ivc_lin(ivc).vrt_fr_m                      := nvl (tb_ivc_lin(ivc).vrt_fr_mn                    , 0) / vn_taxa_ivc_mn;
                tb_ivc_lin(ivc).vrt_fr_total_m                := nvl (tb_ivc_lin(ivc).vrt_fr_total_mn              , 0) / vn_taxa_ivc_mn;
                tb_ivc_lin(ivc).vrt_fr_prepaid_m              := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_mn            , 0) / vn_taxa_ivc_mn;
                tb_ivc_lin(ivc).vrt_fr_collect_m              := nvl (tb_ivc_lin(ivc).vrt_fr_collect_mn            , 0) / vn_taxa_ivc_mn;
                tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m  := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn, 0) / vn_taxa_ivc_mn;
              END IF;

              IF (pn_tp_declaracao IN (13, 14, 15, 17)) THEN
                IF (pn_tp_declaracao IN (13, 14, 15)) THEN
                  tb_ivc_lin(ivc).taxa_mn_fr := vn_taxa_mn;
                  tb_ivc_lin(ivc).taxa_us_fr := vn_taxa_us;
                ELSIF (pn_tp_declaracao IN (17)) THEN
                  tb_ivc_lin(ivc).taxa_mn_fr := vn_taxa_ivc_mn;
                  tb_ivc_lin(ivc).taxa_us_fr := vn_taxa_ivc_us;
                END IF;

                /* Só preenche os valores na moeda para o tipo 14 pois ele só pode ter uma DA,
                * então o frete só terá uma moeda, para os outros tipos, a DI poderá ter várias
                * DAs, então não é possível somar de moedas diferentes, só serão preenchidos
                * os valores em moeda nacional
                */
                --Customização UHK
                vn_global_vrt_fr_m           := nvl (vn_global_vrt_fr_m          , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_m                        , 0)/*, 2)*/;
                vn_global_vrt_fr_total_m     := nvl (vn_global_vrt_fr_total_m    , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_total_m                  , 0)/*, 2)*/;
                vn_global_vrt_fr_prepaid_m   := nvl (vn_global_vrt_fr_prepaid_m  , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_prepaid_m                , 0)/*, 2)*/;
                vn_global_vrt_fr_collect_m   := nvl (vn_global_vrt_fr_collect_m  , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_collect_m                , 0)/*, 2)*/;
                vn_global_vrt_fr_terr_nac_m  := nvl (vn_global_vrt_fr_terr_nac_m , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m    , 0)/*, 2)*/;
                -- Variável global usada apenas para comparar o frete destacado na invoice com
                -- o frete da declaração(proporcional) para os casos de declaração do tipo '14'
                vn_global_vrt_fr_total_us    := nvl (vn_global_vrt_fr_total_us   , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_total_m * vn_taxa_us, 0)/*, 2)*/;
              END IF;

              vn_global_vrt_fr_mn          := nvl (vn_global_vrt_fr_mn         , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_m                        * vn_taxa_mn, 0)/*, 2)*/;
              vn_global_vrt_fr_total_mn    := nvl (vn_global_vrt_fr_total_mn   , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_total_m                  * vn_taxa_mn, 0)/*, 2)*/;
              vn_global_vrt_fr_prepaid_mn  := nvl (vn_global_vrt_fr_prepaid_mn , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_prepaid_m                * vn_taxa_mn, 0)/*, 2)*/;
              vn_global_vrt_fr_collect_mn  := nvl (vn_global_vrt_fr_collect_mn , 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_collect_m                * vn_taxa_mn, 0)/*, 2)*/;
              vn_global_vrt_fr_terr_nac_mn := nvl (vn_global_vrt_fr_terr_nac_mn, 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m    * vn_taxa_mn, 0)/*, 2)*/;

              IF (vc_global_tp_base_seguro <> 'F') AND (vn_global_moeda_sg_id IS NOT null) THEN
                vn_global_vrt_base_seguro    := vn_global_vrt_base_seguro +
                                              + cmx_pkg_taxas.fnc_converte (
                                                  vn_global_vrt_fr_m
                                                , tb_dcl_lin(dcl).moeda_frete_id
                                                , vn_global_moeda_sg_id
                                                , nvl (imp_fnc_busca_dt_cronog (pn_embarque_id, vc_global_data_base_seguro, 'R'), pd_data_totalizar)
                                                , 'FISCAL'
                                                );
              END IF;
            END IF;
          END LOOP;
        END LOOP;

        -- Se existir linhas de LI temos que somar os valores delas tb.
        FOR li IN cur_linhas_li (vn_da_conhec_id) LOOP
          imp_prc_busca_taxa_conversao ( li.moeda_frete_id
                                      , pd_data_totalizar
                                      , vn_taxa_mn
                                      , vn_taxa_us
                                      , 'Moeda do frete internacional da D.A.'
                                      );

          FOR ivc IN 1..vn_global_ivc_lin LOOP
            IF tb_ivc_lin(ivc).invoice_lin_id = li.invoice_lin_id THEN
              -- O valor do frete na moeda não pode ser calculado para nacionalização de DE
              -- pois a linha de invoice pode estar atrelada a DAs diferentes e ter frete
              -- em moedas diferentes, para o tipo 14 sempre será uma DA
              IF (pn_tp_declaracao = 15 OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N')) THEN
                tb_ivc_lin(ivc).vrt_fr_m                      := nvl (tb_ivc_lin(ivc).vrt_fr_m                     , 0) + nvl (li.vrt_fr_m                    , 0);
                tb_ivc_lin(ivc).vrt_fr_total_m                := nvl (tb_ivc_lin(ivc).vrt_fr_total_m               , 0) + nvl (li.vrt_fr_total_m              , 0);
                tb_ivc_lin(ivc).vrt_fr_prepaid_m              := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_m             , 0) + nvl (li.vrt_fr_prepaid_m            , 0);
                tb_ivc_lin(ivc).vrt_fr_collect_m              := nvl (tb_ivc_lin(ivc).vrt_fr_collect_m             , 0) + nvl (li.vrt_fr_collect_m            , 0);
                tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m  := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m , 0) + nvl (li.vrt_fr_territorio_nacional_m, 0);
              END IF;

              tb_ivc_lin(ivc).vrt_fr_mn                     := nvl (tb_ivc_lin(ivc).vrt_fr_mn                    , 0) + nvl (li.vrt_fr_m                     * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_total_mn               := nvl (tb_ivc_lin(ivc).vrt_fr_total_mn              , 0) + nvl (li.vrt_fr_total_m               * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_prepaid_mn             := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_mn            , 0) + nvl (li.vrt_fr_prepaid_m             * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_collect_mn             := nvl (tb_ivc_lin(ivc).vrt_fr_collect_mn            , 0) + nvl (li.vrt_fr_collect_m             * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn, 0) + nvl (li.vrt_fr_territorio_nacional_m * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_fr_us                     := nvl (tb_ivc_lin(ivc).vrt_fr_us                    , 0) + nvl (li.vrt_fr_m                     * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_total_us               := nvl (tb_ivc_lin(ivc).vrt_fr_total_us              , 0) + nvl (li.vrt_fr_total_m               * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_prepaid_us             := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_us            , 0) + nvl (li.vrt_fr_prepaid_m             * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_collect_us             := nvl (tb_ivc_lin(ivc).vrt_fr_collect_us            , 0) + nvl (li.vrt_fr_collect_m             * vn_taxa_us, 0);
              tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us, 0) + nvl (li.vrt_fr_territorio_nacional_m * vn_taxa_us, 0);

              IF (pn_tp_declaracao = 15 OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N')) THEN
                tb_ivc_lin(ivc).taxa_mn_fr := vn_taxa_mn;
                tb_ivc_lin(ivc).taxa_us_fr := vn_taxa_us;

                /* Só preenche os valores na moeda para o tipo 14 pois ele só pode ter uma DA,
                * então o frete só terá uma moeda, para os outros tipos, a DI poderá ter várias
                * DAs, então não é possível somar de moedas diferentes, só serão preenchidos
                * os valores em moeda nacional
                */
                vn_global_vrt_fr_m           := nvl (vn_global_vrt_fr_m          , 0) + round (nvl (li.vrt_fr_m                     , 0), 2);
                vn_global_vrt_fr_total_m     := nvl (vn_global_vrt_fr_total_m    , 0) + round (nvl (li.vrt_fr_total_m               , 0), 2);
                vn_global_vrt_fr_prepaid_m   := nvl (vn_global_vrt_fr_prepaid_m  , 0) + round (nvl (li.vrt_fr_prepaid_m             , 0), 2);
                vn_global_vrt_fr_collect_m   := nvl (vn_global_vrt_fr_collect_m  , 0) + round (nvl (li.vrt_fr_collect_m             , 0), 2);
                vn_global_vrt_fr_terr_nac_m  := nvl (vn_global_vrt_fr_terr_nac_m , 0) + round (nvl (li.vrt_fr_territorio_nacional_m , 0), 2);
                -- Variável global usada apenas para comparar o frete destacado na invoice com
                -- o frete da declaração(proporcional) para os casos de declaração do tipo '14'
                vn_global_vrt_fr_total_us    := nvl (vn_global_vrt_fr_total_us   , 0) + round (nvl (li.vrt_fr_total_m * vn_taxa_us, 0), 2);
              END IF;

              vn_global_vrt_fr_mn          := nvl (vn_global_vrt_fr_mn         , 0) + round (nvl (li.vrt_fr_m                     * vn_taxa_mn, 0), 2);
              vn_global_vrt_fr_total_mn    := nvl (vn_global_vrt_fr_total_mn   , 0) + round (nvl (li.vrt_fr_total_m               * vn_taxa_mn, 0), 2);
              vn_global_vrt_fr_prepaid_mn  := nvl (vn_global_vrt_fr_prepaid_mn , 0) + round (nvl (li.vrt_fr_prepaid_m             * vn_taxa_mn, 0), 2);
              vn_global_vrt_fr_collect_mn  := nvl (vn_global_vrt_fr_collect_mn , 0) + round (nvl (li.vrt_fr_collect_m             * vn_taxa_mn, 0), 2);
              vn_global_vrt_fr_terr_nac_mn := nvl (vn_global_vrt_fr_terr_nac_mn, 0) + round (nvl (li.vrt_fr_territorio_nacional_m * vn_taxa_mn, 0), 2);
            END IF;
  	      END LOOP;
        END LOOP;
      END IF;
    ELSE /*IF ( Nvl(vc_embarque_nac,'XX') = 'NAC_DE_TERC' ) THEN*/

      FOR da IN cur_valores_ivc_da LOOP
        imp_prc_busca_taxa_conversao (
          da.moeda_da_nac_id
        , pd_data_totalizar
        , vn_taxa_mn
        , vn_taxa_us
        , 'Moeda do frete internacional da D.A. da invoice'
        );

        FOR ivc IN 1..vn_global_ivc_lin LOOP

          IF tb_ivc_lin(ivc).invoice_lin_id = da.invoice_lin_id THEN
            tb_ivc_lin(ivc).vrt_fr_total_mn := nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0) + nvl (da.valor_frete * vn_taxa_mn, 0);
            tb_ivc_lin(ivc).vrt_fr_total_us := nvl (tb_ivc_lin(ivc).vrt_fr_total_us, 0) + nvl (da.valor_frete * vn_taxa_us, 0);
            tb_ivc_lin(ivc).vrt_fr_total_m  := nvl (tb_ivc_lin(ivc).vrt_fr_total_m, 0)  + nvl (da.valor_frete,0);

            tb_ivc_lin(ivc).vrt_fr_m        := nvl (tb_ivc_lin(ivc).vrt_fr_m, 0)        + nvl (da.valor_frete             , 0);
            tb_ivc_lin(ivc).vrt_fr_mn := nvl (tb_ivc_lin(ivc).vrt_fr_mn, 0) + nvl (da.valor_frete * vn_taxa_mn, 0);
            tb_ivc_lin(ivc).vrt_fr_us := nvl (tb_ivc_lin(ivc).vrt_fr_us, 0) + nvl (da.valor_frete * vn_taxa_us, 0);

            vn_global_vrt_fr_mn          := nvl (vn_global_vrt_fr_mn      , 0) + round (nvl (da.valor_frete * vn_taxa_mn, 0), 2);
            vn_global_vrt_fr_total_mn    := nvl (vn_global_vrt_fr_total_mn, 0) + round (nvl (da.valor_frete * vn_taxa_mn, 0), 2);
            vn_global_vrt_fr_total_us    := nvl (vn_global_vrt_fr_total_us, 0) + round (nvl (da.valor_frete * vn_taxa_us, 0), 2);

          END IF;

        END LOOP;
      END LOOP;
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no processamento do frete internacional: ' || sqlerrm, 'E', 'A');
  END imp_prc_processa_fr_internac;

  -- ***********************************************************************
  -- Esta procedure tentara identificar qual o valor FOB, SEGURO das linhas de invoices cujos incoterms possuam seguro.
  -- Para encontrar esses valores partimos dos conceitos que FOB COM SEGURO + SEGURO = TOTAL IVC COM SEGURO - FRETE IVC COM SEGURO
  -- Derivando matematicamente a afirmação acima conseguimos identificar o FOB correto dessas invoices com equacao:
  --
  -- FOB^2 - (VRT_IVC_SEGURO - VRT_FRETE_IVC_SEGURO - FRT_FOB_IVS_SEM_SEGURO).FOB - ( (VRT_IVC_SEGURO - VRT_FRETE_SEGURO).VRT_FOB_IVC_SEM_SEGURO) = 0
  -- Resolvendo a equacao do segundo grau:
  -- FOB = (VRT_IVC_SEGURO - VRT_FRETE_IVC_SEGURO - FRT_VOB_IVS_SEM_SEGURO) + RAIZ_QUADRADA( - (VRT_IVC_SEGURO - VRT_FRETE_IVC_SEGURO - FRT_FOB_IVS_SEM_SEGURO)^2 + 4( (VRT_IVC_SEGURO - VRT_FRETE_SEGURO).VRT_FOB_IVC_SEM_SEGURO) ) / 2
  -- ***********************************************************************
  PROCEDURE imp_prc_processa_sg_embutido (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER, pd_data_totalizar DATE, pn_tp_embarque_id NUMBER) IS

    CURSOR cur_embarque IS
      SELECT ie.moeda_seguro_id
           , nvl(ie.vrt_sg_m,0)
           , nvl(ie.aliq_seguro,0)
        FROM imp_embarques     ie
       WHERE ie.embarque_id = pn_embarque_id;

    CURSOR cur_ivc_seguro IS
      --SELECT sum(ivc.valor_total) valor_total, moeda_id
      SELECT sum(ivc.valor_total) - Nvl((SELECT Sum(qtde*preco_unitario_m)
                                           FROM imp_invoices_lin iil
                                         WHERE iil.embarque_id = pn_embarque_id
                                            AND cmx_pkg_tabelas.auxiliar(iil.tp_linha_id,1) = 'E'), 0) valor_total
           , moeda_id
        FROM cmx_tabelas  ct
           , imp_invoices ivc
       WHERE ivc.embarque_id                                = pn_embarque_id
         AND ct.tabela_id                                   = ivc.incoterm_id
         AND instr(ct.auxiliar1,'S')                        > 0
       GROUP BY moeda_id;

    CURSOR cur_vlr_previsto IS
      SELECT prev_seg_moeda_id
           , Nvl(prev_seg_vlr_seg_m, 0)
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_remessas IS
      SELECT moeda_seguro_id
           , vrt_sg_m
        FROM imp_po_remessa
       WHERE embarque_id = pn_embarque_id
         AND nr_remessa = 1;

    CURSOR cur_seguro_da IS
      SELECT ie_da.moeda_seguro_id
           , sum ((ivcda_lin.vrt_sg_m / imp_fnc_qtde_laudo(ivcda_lin.invoice_lin_id, ivcda_lin.laudo_id, ivcda_lin.qtde, ivcda_lin.qtde_descarregada)) * idl.qtde)
        FROM imp_embarques       ie
           , imp_declaracoes     di
           , imp_declaracoes     da
           , imp_declaracoes_lin da_lin
           , imp_invoices_lin    ivcda_lin
           , imp_declaracoes_lin idl
           , imp_embarques       ie_da
       WHERE ie.embarque_id           = pn_embarque_id
         AND ie.embarque_id           = di.embarque_id
         AND di.da_id                 = da.declaracao_id
         AND di.declaracao_id         = idl.declaracao_id
         AND da.declaracao_id         = da_lin.declaracao_id
         AND da_lin.invoice_lin_id    = ivcda_lin.invoice_lin_id
         AND da_lin.declaracao_lin_id = idl.da_lin_id
         AND da.embarque_id           = ie_da.embarque_id
       GROUP BY ie_da.moeda_seguro_id;

     CURSOR cur_seguro_nac(pn_invoice_lin_id NUMBER)
         IS
      SELECT ill.moeda_sg_da_nac_id moeda_seguro_id
           , ill.valor_seguro valor_seguro
           , ill.moeda_da_nac_id     moeda_frete_id
           , ill.valor_frete
        FROM imp_invoices_lin ill
       WHERE ill.invoice_lin_id = pn_invoice_lin_id;

    CURSOR cur_ultima_rem IS
    SELECT ice.peso_liquido
         , ice.peso_bruto
         , Nvl(valor_prepaid_m,0) + Nvl(valor_collect_m,0) frete_int
         , Nvl(valor_prepaid_m,0)        fr_prepaid
         , Nvl(valor_collect_m,0)        fr_collect
         , Nvl(valor_terr_nacional_m,0)  fr_terr_nac
      FROM imp_vw_conhec_ebq ice
     WHERE ice.embarque_id = pn_embarque_id
       AND ultima_remessa = 'S';

   CURSOR cur_seguro
    IS
    SELECT Sum(ipr.vrt_sg_mn ) vrt_sg_tot_mn
      FROM imp_po_remessa ipr
     WHERE ipr.embarque_id=pn_embarque_id;

    vn_vrt_fob_ivc_sem_seguro  NUMBER := 0;
    vn_vrt_ivc_seguro          NUMBER := 0;
    vn_vrt_frete_ivc_seguro    NUMBER := 0;
    vn_vrt_fob_ivc_seguro      NUMBER := 0;
    vn_vrt_seguro              NUMBER := 0;
    vn_frete_aux               NUMBER := 0;
    vn_fr_collect_ajusta_vn_b  NUMBER := 0;
    vn_moeda_sg_id             NUMBER := 0;
    vn_aliq_seguro             NUMBER := 0;
    vn_taxa_seguro             NUMBER := 0;
    vn_taxa_seguro_us          NUMBER := 0;
    vn_taxa_mn                 NUMBER := 0;
    vn_taxa_us                 NUMBER := 0;
    vn_a                       NUMBER := 0;
    vn_b                       NUMBER := 0;
    vn_c                       NUMBER := 0;
    vn_ind_seguro              NUMBER := 0;
    vn_fob_seguro              NUMBER := 0;

    vn_moeda_id_vlr_prev       imp_embarques.prev_seg_moeda_id%TYPE;
    vn_vlr_seg_prev            imp_embarques.prev_seg_vlr_seg_m%TYPE;

    vn_moeda_id_rem            imp_po_remessa.moeda_seguro_id%TYPE;
    vn_vlr_seg_rem             imp_po_remessa.vrt_sg_m%TYPE;
    vn_vrt_dsp_ddu             NUMBER := 0;
    vn_vrt_dsp_ddu_total       NUMBER := 0;
    vb_ultima_rem              BOOLEAN;
    vr_ultima_rem              cur_ultima_rem%ROWTYPE;
    vn_seg_di_unica            NUMBER;
    vn_vlr_seg_nac             NUMBER;
    vr_seguro_nac              cur_seguro_nac%rowtype;
    vn_taxa_frete_mn           NUMBER;
    vn_taxa_frete_us           NUMBER;
    vn_seguro_aux              NUMBER;

  BEGIN
    -- Rateando também para Nacionalização de Admissão Temporaria
    -- Para outras Nacionalizações obtemos o valor do seguro das Admissões
    IF ((pn_tp_declaracao <= 15 OR vc_global_nac_sem_admissao = 'S') AND Nvl(cmx_pkg_tabelas.auxiliar(pn_tp_embarque_id,1),'XX') <> 'NAC_DE_TERC' ) THEN
      IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
        OPEN  cur_ultima_rem;
        FETCH cur_ultima_rem INTO vr_ultima_rem;
        vb_ultima_rem  := cur_ultima_rem%FOUND;
        CLOSE cur_ultima_rem;

        IF NOT vb_ultima_rem THEN

          OPEN cur_vlr_previsto;
          FETCH cur_vlr_previsto INTO vn_moeda_id_vlr_prev
                                    , vn_vlr_seg_prev;
          CLOSE cur_vlr_previsto;

          IF (vn_moeda_id_vlr_prev IS NOT NULL) THEN
            vn_moeda_sg_id := vn_moeda_id_vlr_prev;
            vn_global_vrt_sg_ebq_m := vn_vlr_seg_prev;
          ELSE
            OPEN cur_remessas;
            FETCH cur_remessas INTO vn_moeda_id_rem
                                  , vn_vlr_seg_rem;
            CLOSE cur_remessas;

            vn_moeda_sg_id := vn_moeda_id_rem;
            vn_global_vrt_sg_ebq_m := vn_vlr_seg_rem;
          END IF;
        ELSE
          imp_prc_busca_taxa_conversao (vn_global_moeda_sg_id,
                                        pd_data_totalizar,
                                        vn_taxa_mn,
                                        vn_taxa_us,
                                       'SEGURO DI UNICA');

          OPEN cur_seguro;
          FETCH cur_seguro INTO vn_seg_di_unica;
          CLOSE cur_seguro;

          vn_moeda_sg_id  := vn_global_moeda_sg_id;
          vn_moeda_id_rem := vn_global_moeda_sg_id;
          vn_vlr_seg_rem := vn_seg_di_unica / vn_taxa_mn;
          vn_global_vrt_sg_ebq_m   := vn_vlr_seg_rem;

        END IF;
      ELSE
        IF (pn_tp_declaracao < 13) OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'S') THEN
          OPEN  cur_embarque;
          FETCH cur_embarque INTO vn_moeda_sg_id
                                , vn_global_vrt_sg_ebq_m
                                , vn_aliq_seguro;
          CLOSE cur_embarque;
        ELSE
          OPEN  cur_seguro_da;
          FETCH cur_seguro_da INTO vn_moeda_sg_id
                                 , vn_global_vrt_sg_ebq_m;
          CLOSE cur_seguro_da;
        END IF;

      END IF;

      imp_prc_busca_taxa_conversao (vn_moeda_sg_id,
                                    pd_data_totalizar,
                                    vn_taxa_seguro,
                                    vn_taxa_seguro_us,
                                    'Seguro');

      IF (Nvl (vn_aliq_seguro, 0) <> 0) THEN
        vn_global_vrt_sg_ebq_m := Nvl (round (vn_global_vrt_base_seguro * (vn_aliq_seguro/100),2),0);
      END IF;

      vn_vrt_seguro := Round(vn_global_vrt_sg_ebq_m * vn_taxa_seguro,2);
       -- Depois de ser executado o rateio do Frete Internacional podemos identificar qual o valor
       -- VRT_FOB_IVC_SEM_SEGURO
       FOR ivc IN 1..vn_global_ivc_lin LOOP
         IF ( instr(tb_ivc_lin(ivc).tprateio_incoterm,'S') = 0 ) THEN
             vn_vrt_fob_ivc_sem_seguro := vn_vrt_fob_ivc_sem_seguro  + nvl (tb_ivc_lin(ivc).vrt_fob_mn   , 0);
         END IF;
       END LOOP;

       -- Depois podemos identificar VRT_FRETE_IVC_SEGURO
       FOR ivc IN 1..vn_global_ivc_lin LOOP
         IF ( instr(tb_ivc_lin(ivc).tprateio_incoterm,'S') > 0 ) AND (instr(tb_ivc_lin(ivc).tprateio_incoterm,'F') > 0  )  THEN
           vn_vrt_frete_ivc_seguro := vn_vrt_frete_ivc_seguro + nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0);

           IF( nvl(tb_ivc_lin(ivc).flag_fr_embutido,'N') = 'N') AND (nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn,0) > 0 ) THEN
              vn_fr_collect_ajusta_vn_b := vn_fr_collect_ajusta_vn_b  + nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn,0);
           END IF;

         ELSIF ( nvl(tb_ivc_lin(ivc).flag_fr_embutido,'N') = 'N') AND (nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn,0) > 0 ) THEN
              vn_fr_collect_ajusta_vn_b := vn_fr_collect_ajusta_vn_b  + nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn,0);

         END IF;

         -- Calculo da DDu embutida
         IF (instr(tb_ivc_lin(ivc).tprateio_incoterm,'N') > 0 ) THEN
           vn_vrt_dsp_ddu_total :=  vn_vrt_dsp_ddu_total + nvl(tb_ivc_lin(ivc).vrt_dsp_ddu_mn,0);
         END IF;
       END LOOP;

       -- Depois identificamos os valor total das Invoices com seguro
       FOR i in cur_ivc_seguro LOOP
          imp_prc_busca_taxa_conversao ( i.moeda_id
                                       , pd_data_totalizar
                                       , vn_taxa_mn
                                       , vn_taxa_us
                                       , 'Valor total Invoices com Seguro');

          vn_vrt_ivc_seguro := vn_vrt_ivc_seguro + (i.valor_total * vn_taxa_mn);

       END LOOP;

      -- Aplicar a formula e achar o fob total das invoices com seguro
      -- FOB = (VRT_IVC_SEGURO - VRT_FRETE_IVC_SEGURO - FRT_VOB_IVS_SEM_SEGURO) + RAIZ_QUADRADA( - (VRT_IVC_SEGURO - VRT_FRETE_IVC_SEGURO - FRT_FOB_IVS_SEM_SEGURO)^2 + 4( (VRT_IVC_SEGURO - VRT_FRETE_SEGURO).VRT_FOB_IVC_SEM_SEGURO) ) / 2
      -- Quando temos invoices onde o seguro é embutido e o frete é destacado e o usuario preencheu o frete collect no conhecimento
      -- temos que ajustar a valor de vn_b para que ele considere o fob e não o fob - collect.
      -- Por isso foi inserido na formula original de vn_b o ajuste do collect.
      vn_a := 1;
      vn_b := -1 * (vn_vrt_ivc_seguro - vn_vrt_frete_ivc_seguro - vn_vrt_fob_ivc_sem_seguro - vn_vrt_seguro + vn_fr_collect_ajusta_vn_b - vn_vrt_dsp_ddu_total);
      vn_c := -1 * ( (vn_vrt_ivc_seguro - vn_vrt_frete_ivc_seguro) * vn_vrt_fob_ivc_sem_seguro);
      vn_vrt_fob_ivc_seguro := ( -1 * vn_b + SQRT( (power(vn_b,2)) - (4 * vn_a * vn_c )))/2;

      -- Com o valor FOB correto das Invoices com seguro encontrado podemos identificar o indice do Seguro que deve ser usado.
      -- indice = seguro total / fob total
      --Customização UHK
      IF (vn_vrt_fob_ivc_seguro+vn_vrt_fob_ivc_sem_seguro) = 0 THEN
        vn_ind_seguro := 1;
      ELSE
        vn_ind_seguro := vn_vrt_seguro / (vn_vrt_fob_ivc_seguro+vn_vrt_fob_ivc_sem_seguro+vn_fr_collect_ajusta_vn_b);
      END IF;
      -- Para as invoices que possuem seguro embutido no Incoterm podemos dizer que
      -- com o indice do seguro calculado podemos obter o fob atraves da diferenca entre VALOR LINHA - FRETE = FOB+SEGURO
      -- como SEGRURO é composto pelo FOB*INDICE, podemos obter o fob atraves da formula
      -- FOB = (FOB+SEGURO)/(1+indice seguro).
       -- Depois podemos identificar VRT_FRETE_IVC_SEGURO

	   FOR ivc IN 1..vn_global_ivc_lin LOOP
--         IF ( tb_ivc_lin(ivc).flag_sg_embutido = 'S' and tb_ivc_lin(ivc).flag_fr_embutido = 'S'  ) THEN
         IF ( tb_ivc_lin(ivc).flag_sg_embutido = 'S' ) THEN

           IF( tb_ivc_lin(ivc).flag_fr_embutido = 'S'  ) THEN
             vn_frete_aux := nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0);
           ELSE
             -- utilizamos a taxa do fob aqui pq o valor VRT_FRIVC_M eh o frete da invoice, logo, ele esta na moeda da invoice
             vn_frete_aux := (nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0) - nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn, 0)) - (nvl (tb_ivc_lin(ivc).vrt_frivc_m , 0) * tb_ivc_lin(ivc).taxa_mn_fob);
           END IF;

           --vn_fob_seguro := (round (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m, 2) * tb_ivc_lin(ivc).taxa_mn_fob)  + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) - vn_frete_aux - nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);
           vn_fob_seguro := (round ( tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m + tb_ivc_lin(ivc).vrt_descsivc_m , 2) * tb_ivc_lin(ivc).taxa_mn_fob)  + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) - vn_frete_aux - nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);

		       IF( tb_ivc_lin(ivc).flag_fr_embutido = 'S') THEN
              tb_ivc_lin(ivc).vrt_fob_mn := vn_fob_seguro / (1+vn_ind_seguro) - nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0)  ;
           ELSE
              tb_ivc_lin(ivc).vrt_fob_mn := (vn_fob_seguro / (1+vn_ind_seguro)) - nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn,0) - nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) ;
           END IF;

           tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_mn / tb_ivc_lin(ivc).taxa_mn_fob;
           tb_ivc_lin(ivc).vrt_fob_us  := tb_ivc_lin(ivc).vrt_fob_m * tb_ivc_lin(ivc).taxa_us_fob;
         END IF;
       END LOOP;

       -- Calculando o seguro para que seja possivel efetuar o vmle correto.
       FOR ivc IN 1..vn_global_ivc_lin LOOP
         IF( tb_ivc_lin(ivc).flag_fr_embutido = 'S') THEN
          tb_ivc_lin(ivc).vrt_sg_mn := (tb_ivc_lin(ivc).vrt_fob_mn + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0))  * vn_ind_seguro;
         ELSE
          tb_ivc_lin(ivc).vrt_sg_mn := (tb_ivc_lin(ivc).vrt_fob_mn + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) + nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn,0)) * vn_ind_seguro;
         END IF;
       END LOOP;

       -- recalculando a global do FOB apos acerto do seguro nas linhas da invoice
       vn_global_vrt_fob_ebq_mn := 0;
       vn_global_vrt_fob_ebq_us := 0;
       FOR ivc IN 1..vn_global_ivc_lin LOOP
         vn_global_vrt_fob_ebq_mn := vn_global_vrt_fob_ebq_mn + tb_ivc_lin(ivc).vrt_fob_mn;
         vn_global_vrt_fob_ebq_us := vn_global_vrt_fob_ebq_us + tb_ivc_lin(ivc).vrt_fob_us;
       END LOOP;
    ELSIF (pn_tp_declaracao = 17 AND Nvl(cmx_pkg_tabelas.auxiliar(pn_tp_embarque_id,1),'XX') = 'NAC_DE_TERC' )THEN

	    FOR ivc IN 1..vn_global_ivc_lin LOOP
        OPEN cur_seguro_nac(tb_ivc_lin(ivc).invoice_lin_id);
        FETCH cur_seguro_nac INTO vr_seguro_nac;
        CLOSE cur_seguro_nac;

        imp_prc_busca_taxa_conversao (vr_seguro_nac.moeda_seguro_id,
                                  pd_data_totalizar,
                                  vn_taxa_seguro,
                                  vn_taxa_seguro_us,
                                  'SEGURO_DI17');

        imp_prc_busca_taxa_conversao (vr_seguro_nac.moeda_frete_id,
                                  pd_data_totalizar,
                                  vn_taxa_frete_mn,
                                  vn_taxa_frete_us,
                                  'FRETE_DI17');



        IF ( tb_ivc_lin(ivc).flag_sg_embutido = 'S' ) THEN
          vn_seguro_aux := vr_seguro_nac.valor_seguro * vn_taxa_seguro;

          tb_ivc_lin(ivc).vrt_frivc_m := vn_frete_aux / tb_ivc_lin(ivc).taxa_mn_fob;

          IF( tb_ivc_lin(ivc).flag_fr_embutido = 'S'  ) THEN
            vn_frete_aux := vr_seguro_nac.valor_frete * vn_taxa_frete_mn;
--            tb_ivc_lin(ivc).vrt_frivc_m := vn_frete_aux / tb_ivc_lin(ivc).taxa_mn_fob;
          ELSE
            -- utilizamos a taxa do fob aqui pq o valor VRT_FRIVC_M eh o frete da invoice, logo, ele esta na moeda da invoice
            --vn_frete_aux := (nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0) - nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn, 0)) - (nvl (tb_ivc_lin(ivc).vrt_frivc_m , 0) * tb_ivc_lin(ivc).taxa_mn_fob);
              vn_frete_aux  := 0;


          END IF;

          --vn_fob_seguro := (round (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m, 2) * tb_ivc_lin(ivc).taxa_mn_fob)  + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) - vn_frete_aux - nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);
          vn_fob_seguro := (round ( tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m + tb_ivc_lin(ivc).vrt_descsivc_m , 2) * tb_ivc_lin(ivc).taxa_mn_fob)  + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) - vn_frete_aux - nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);

		      IF( tb_ivc_lin(ivc).flag_fr_embutido = 'S') THEN
            tb_ivc_lin(ivc).vrt_fob_mn := vn_fob_seguro - vn_seguro_aux - nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0)  ;
          ELSE
            tb_ivc_lin(ivc).vrt_fob_mn := (vn_fob_seguro - vn_seguro_aux) - nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn,0) - nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) ;
          END IF;

          tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_mn / tb_ivc_lin(ivc).taxa_mn_fob;
          tb_ivc_lin(ivc).vrt_fob_us  := tb_ivc_lin(ivc).vrt_fob_m * tb_ivc_lin(ivc).taxa_us_fob;
        ELSE
          IF( tb_ivc_lin(ivc).flag_fr_embutido = 'S'  ) THEN
            vn_frete_aux := vr_seguro_nac.valor_frete * vn_taxa_frete_mn;
            tb_ivc_lin(ivc).vrt_frivc_m := vn_frete_aux / tb_ivc_lin(ivc).taxa_mn_fob;
          ELSE
            -- utilizamos a taxa do fob aqui pq o valor VRT_FRIVC_M eh o frete da invoice, logo, ele esta na moeda da invoice
            vn_frete_aux := (nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0) - nvl(tb_ivc_lin(ivc).vrt_fr_collect_mn, 0)) - (nvl (tb_ivc_lin(ivc).vrt_frivc_m , 0) * tb_ivc_lin(ivc).taxa_mn_fob);
          END IF;

          --vn_fob_seguro := (round (tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m, 2) * tb_ivc_lin(ivc).taxa_mn_fob)  + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) - vn_frete_aux - nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);
          vn_fob_seguro := (round ( tb_ivc_lin(ivc).qtde * tb_ivc_lin(ivc).preco_unitario_m + tb_ivc_lin(ivc).vrt_descsivc_m , 2) * tb_ivc_lin(ivc).taxa_mn_fob)  + nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) - vn_frete_aux - nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);

		      IF( tb_ivc_lin(ivc).flag_fr_embutido = 'S') THEN
            tb_ivc_lin(ivc).vrt_fob_mn := vn_fob_seguro  - nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0)  ;
          tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_mn / tb_ivc_lin(ivc).taxa_mn_fob;
          tb_ivc_lin(ivc).vrt_fob_us  := tb_ivc_lin(ivc).vrt_fob_m * tb_ivc_lin(ivc).taxa_us_fob;
          END IF;


        END IF;

        tb_ivc_lin(ivc).vrt_sg_mn := vn_seguro_aux;
        tb_ivc_lin(ivc).vrt_sg_m  := vn_seguro_aux /  tb_ivc_lin(ivc).taxa_mn_fob;
        tb_ivc_lin(ivc).vrt_sg_us := tb_ivc_lin(ivc).vrt_sg_m *  tb_ivc_lin(ivc).taxa_us_fob;


      END LOOP;


      -- recalculando a global do FOB apos acerto do seguro nas linhas da invoice
      vn_global_vrt_fob_ebq_mn := 0;
      vn_global_vrt_fob_ebq_us := 0;
      FOR ivc IN 1..vn_global_ivc_lin LOOP
        vn_global_vrt_fob_ebq_mn := vn_global_vrt_fob_ebq_mn + tb_ivc_lin(ivc).vrt_fob_mn;
        vn_global_vrt_fob_ebq_us := vn_global_vrt_fob_ebq_us + tb_ivc_lin(ivc).vrt_fob_us;

      END LOOP;


    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no processamento do seguro internacional embutido: ' || sqlerrm, 'E', 'A');
  END imp_prc_processa_sg_embutido;

  -- ***********************************************************************
  -- Esta procedure ira buscar todas as linhas de mercadoria das invoices e
  -- ratear o valor de seguro internacional do embarque.
  -- ***********************************************************************
  PROCEDURE imp_prc_processa_sg_internac (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER, pd_data_totalizar DATE) IS
    vn_moeda_sg_id          NUMBER  := 0;
    vn_ind_sg_mn            NUMBER  := 0;
    vn_taxa_mn              NUMBER  := 0;
    vn_taxa_us              NUMBER  := 0;
    vn_base_seguro          NUMBER  := 0;
    vn_aliq_seguro          NUMBER  := 0;
    vn_soma_sg_internac     NUMBER  := 0;
    vn_soma_sg_internac_mn  NUMBER  := 0;
    vc_aux                  cmx_tabelas.auxiliar1%TYPE := null;
    vn_remessa              NUMBER  := 0;
    vn_tp_embarque_id       NUMBER;

    CURSOR cur_embarque IS
      SELECT Nvl (ie.moeda_seguro_id, ie.prev_seg_moeda_id)
           , decode (  Nvl (ie.vrt_sg_m, 0)
                     , 0
                     , Nvl (ie.prev_seg_vlr_seg_m, 0)
                     , Nvl (ie.vrt_sg_m, 0)
                    )
           , nvl(ie.aliq_seguro,0)
           , tp_embarque_id
        FROM imp_embarques     ie
       WHERE ie.embarque_id = pn_embarque_id;

    CURSOR cur_embarque_di_unica_plan IS
      SELECT ie.prev_seg_moeda_id
           , Nvl (ie.prev_seg_vlr_seg_m, 0)
           , nvl(ie.prev_aliq_seguro,0)
        FROM imp_embarques     ie
       WHERE ie.embarque_id = pn_embarque_id;

    CURSOR cur_embarque_di_unica_rem IS
      SELECT moeda_seguro_id
           , vrt_sg_m
           , aliq_seguro
        FROM imp_po_remessa re
       WHERE re.embarque_id = pn_embarque_id
         AND re.nr_remessa  = '1';

    CURSOR cur_ultima_rem IS
    SELECT ice.peso_liquido
         , ice.peso_bruto
         , Nvl(valor_prepaid_m,0) + Nvl(valor_collect_m,0) frete_int
         , Nvl(valor_prepaid_m,0)        fr_prepaid
         , Nvl(valor_collect_m,0)        fr_collect
         , Nvl(valor_terr_nacional_m,0)  fr_terr_nac
      FROM imp_vw_conhec_ebq ice
     WHERE ice.embarque_id = pn_embarque_id
       AND ultima_remessa = 'S';

    CURSOR cur_seguro
    IS
    SELECT Sum(ipr.vrt_sg_mn ) vrt_sg_tot_mn
      FROM imp_po_remessa ipr
     WHERE ipr.embarque_id=pn_embarque_id;

    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    CURSOR cur_valores_ivc_da IS
      SELECT iil.valor_seguro
           , iil.moeda_sg_da_nac_id
           , iil.invoice_lin_id
        FROM imp_invoices_lin      iil
       	   , imp_invoices          ii
       	   , imp_embarques         ie
       WHERE ie.embarque_id            = pn_embarque_id
         AND ie.embarque_id            = ii.embarque_id
         AND ii.invoice_id            = iil.invoice_id;
    /*---------------------------------------------------------------------------------------------------------------------------------------------------------------*/

    vr_ultima_rem cur_ultima_rem%ROWTYPE;
    vb_ultima_rem  BOOLEAN := FALSE;
    vn_seg_di_unica NUMBER;
    vn_vlr_seg_rem NUMBER;


   BEGIN
    OPEN  cur_embarque;
    FETCH cur_embarque INTO vn_moeda_sg_id
                          , vn_global_vrt_sg_ebq_m
                          , vn_aliq_seguro
                          , vn_tp_embarque_id;
    CLOSE cur_embarque;

    -- Rateando também para Nacionalização de Admissão Temporaria
    IF (Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id, 1),'XX') <> 'NAC_DE_TERC') THEN
      IF pn_tp_declaracao < 13 OR vc_global_nac_sem_admissao = 'S' THEN
        IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN

          OPEN  cur_embarque_di_unica_plan;
          FETCH cur_embarque_di_unica_plan INTO vn_moeda_sg_id
                                              , vn_global_vrt_sg_ebq_m
                                              , vn_aliq_seguro;
          CLOSE cur_embarque_di_unica_plan;

          OPEN  cur_ultima_rem;
          FETCH cur_ultima_rem INTO vr_ultima_rem;
          vb_ultima_rem  := cur_ultima_rem%FOUND;
          CLOSE cur_ultima_rem;

          IF vb_ultima_rem THEN
            imp_prc_busca_taxa_conversao (vn_global_moeda_sg_id,
                                          pd_data_totalizar,
                                          vn_taxa_mn,
                                          vn_taxa_us,
                                        'SEGURO DI UNICA');

            OPEN cur_seguro;
            FETCH cur_seguro INTO vn_seg_di_unica;
            CLOSE cur_seguro;

            vn_moeda_sg_id := vn_global_moeda_sg_id;
            vn_vlr_seg_rem := vn_seg_di_unica / vn_taxa_mn;
            vn_global_vrt_sg_ebq_m   := vn_vlr_seg_rem;

          END IF;

          IF (vn_global_vrt_base_seguro > 0) AND (vn_aliq_seguro >0) AND (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
            -- Se a aliquota é maior que zero, precisamos calcular o seguro
            -- para calcular, precisamos verificar se utilizaremos o Frete ou não, de acordo com a parametrizacao
            -- da tela de  Parametros de Importacao.
            vn_global_vrt_sg_ebq_m  := round (vn_global_vrt_base_seguro * (vn_aliq_seguro/100),2); ---teste sem round de 2

          END IF;

          IF (Nvl(vn_moeda_sg_id,0) = 0) THEN
            vn_aliq_seguro := 0;
            vn_global_vrt_sg_ebq_m := 0;
          END IF;


          IF (vn_global_vrt_sg_ebq_m = 0 AND vn_aliq_seguro = 0) THEN
            OPEN  cur_embarque_di_unica_rem;
            FETCH cur_embarque_di_unica_rem INTO vn_moeda_sg_id
                                              , vn_global_vrt_sg_ebq_m
                                              , vn_aliq_seguro;
            CLOSE cur_embarque_di_unica_rem;
            vn_remessa := 1;
          END IF;

          IF ( vn_moeda_sg_id IS NULL OR vn_moeda_sg_id = 0) THEN
            prc_gera_log_erros ('Moeda do seguro na DI única não informada, cálculo e rateio não efetuados...', 'A', null);
          END IF;

          IF ((nvl(vn_global_vrt_sg_ebq_m,0) = 0) AND (NVL(vn_aliq_seguro,0) = 0)) THEN
            prc_gera_log_erros ('Alíquota ou valor do seguro na DI única não informados, cálculo e rateio não efetuados...', 'A', null);
          END IF;
        ELSE
          OPEN  cur_embarque;
          FETCH cur_embarque INTO vn_moeda_sg_id
                                , vn_global_vrt_sg_ebq_m
                                , vn_aliq_seguro
                                , vn_tp_embarque_id;
          CLOSE cur_embarque;

          IF ( vn_moeda_sg_id IS NULL) THEN

            IF (  Nvl (pn_tp_declaracao, '00') = '15'
              OR ( Nvl (pn_tp_declaracao, '00') IN ('13', '14')
                  AND cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id, 1) IS NOT NULL ) ) THEN
              NULL;

            ELSE
              prc_gera_log_erros ('Moeda do seguro não informada, cálculo e rateio não efetuados...', 'A', null);
            END IF;

          END IF;

          IF ((nvl(vn_global_vrt_sg_ebq_m,0) = 0) AND (NVL(vn_aliq_seguro,0) = 0)) THEN
            prc_gera_log_erros ('Alíquota ou valor do seguro não informados, cálculo e rateio não efetuados...', 'A', null);
          END IF;
        END IF;

        imp_prc_busca_taxa_conversao (vn_moeda_sg_id,
                                      pd_data_totalizar,
                                      vn_taxa_mn,
                                      vn_taxa_us,
                                      'Seguro');

        vn_base_seguro := vn_global_vrt_base_seguro;

        -- Pinha
        -- Acrescentei a verificação se é DI_UNICA, pois se for a aliq virá preenchida da remessa ou planejamento
        -- E não temos o valor da base nesses processos.
        IF (vn_aliq_seguro > 0) AND (Nvl(vc_global_verif_di_unica, '*') <> 'DI_UNICA') THEN
          -- Se a aliquota é maior que zero, precisamos calcular o seguro
          -- para calcular, precisamos verificar se utilizaremos o Frete ou não, de acordo com a parametrizacao
          -- da tela de  Parametros de Importacao.
          vn_global_vrt_sg_ebq_m  := round (vn_base_seguro * (vn_aliq_seguro/100),2); ---teste sem round de 2
        END IF;

        vn_global_vrt_sg_ebq_mn := round (vn_global_vrt_sg_ebq_m * vn_taxa_mn,2);
        vn_global_vrt_sg_ebq_us := round (vn_global_vrt_sg_ebq_m * vn_taxa_us,2);
        vn_ind_sg_mn            := 0;

        IF (vn_remessa = 0 ) THEN
          IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
            IF NOT vb_ultima_rem THEN
              UPDATE imp_embarques
                SET prev_seg_vlr_seg_m = Decode(Nvl(vn_moeda_sg_id,0),0,0, vn_global_vrt_sg_ebq_m)
                  , prev_seg_vlr_seg_mn = Decode(Nvl(vn_moeda_sg_id,0),0,0, vn_global_vrt_sg_ebq_mn)
                  , moeda_seguro_id     = vn_global_moeda_sg_id
              WHERE embarque_id = pn_embarque_id;
            END IF;
          END IF;
        ELSE
            UPDATE imp_embarques
              SET prev_seg_vlr_seg_m = 0
                , prev_seg_vlr_seg_mn = NULL
                , prev_aliq_seguro    = NULL
                , prev_seg_moeda_id   = NULL
                , moeda_seguro_id     = vn_global_moeda_sg_id
            WHERE embarque_id = pn_embarque_id;
        END IF;

        -- Pinha
        -- Acrescentei a verificação se é DI_UNICA, pois não temos o valor da base nesses processos.
        IF (vn_base_seguro > 0) OR (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
          vn_ind_sg_mn := vn_global_vrt_sg_ebq_mn / vn_global_vrt_vmle_ebq_mn;
        END IF;

        FOR ivc IN 1..vn_global_ivc_lin LOOP
          tb_ivc_lin(ivc).taxa_mn_sg := vn_taxa_mn;
          tb_ivc_lin(ivc).taxa_us_sg := vn_taxa_us;

          IF tb_ivc_lin(ivc).numero_nf IS null THEN
            IF (ivc = vn_global_ivc_lin) THEN
              tb_ivc_lin(ivc).vrt_sg_mn := vn_global_vrt_sg_ebq_mn - vn_soma_sg_internac_mn;
            ELSE
              tb_ivc_lin(ivc).vrt_sg_mn := tb_ivc_lin(ivc).vmle_mn * vn_ind_sg_mn;
            END IF;

            IF (vn_taxa_mn > 0) THEN
              tb_ivc_lin(ivc).vrt_sg_m  := tb_ivc_lin(ivc).vrt_sg_mn / vn_taxa_mn;
            ELSE
              tb_ivc_lin(ivc).vrt_sg_m  := 0;
            END IF;

            tb_ivc_lin(ivc).vrt_sg_us := tb_ivc_lin(ivc).vrt_sg_m * vn_taxa_us;
          END IF;

          vn_soma_sg_internac    := vn_soma_sg_internac    + tb_ivc_lin(ivc).vrt_sg_m;
          vn_soma_sg_internac_mn := vn_soma_sg_internac_mn + tb_ivc_lin(ivc).vrt_sg_mn;
        END LOOP;

      ELSE  -- NACIONALIZACAO
        --Customização UHK
        vn_global_vrt_sg_ebq_m:= 0;
        --Zerando variaveis para não apresentar problema quando se totaliza duas vezes seguidas
        FOR dcl IN 1..vn_global_dcl_lin LOOP
          FOR ivc IN 1..vn_global_ivc_lin LOOP
            tb_ivc_lin(ivc).vrt_sg_m   := 0;
            tb_ivc_lin(ivc).vrt_sg_mn  := 0;
            tb_ivc_lin(ivc).vrt_sg_us  := 0;
            tb_ivc_lin(ivc).taxa_mn_sg := 0;
            tb_ivc_lin(ivc).taxa_us_sg := 0;
          END LOOP;
        END LOOP;

        FOR dcl IN 1..vn_global_dcl_lin LOOP

          /* Para cada linha de declaração busca a taxa da moeda do seguro. Quando é nacionalização pode existir seguro em diversas moedas. */
          imp_prc_busca_taxa_conversao (
            tb_dcl_lin(dcl).moeda_seguro_id
          , pd_data_totalizar
          , vn_taxa_mn
          , vn_taxa_us
          , 'Moeda do seguro internacional da D.A.'
          );

          FOR ivc IN 1..vn_global_ivc_lin LOOP
            IF tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id THEN
              -- O valor do seguro na moeda não pode ser calculado para nacionalização de DE
              -- pois a linha de invoice pode estar atrelada a DAs diferentes e ter seguro
              -- em moedas diferentes, para o tipo 14 sempre será uma DA
              IF (pn_tp_declaracao = 15 OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N')) THEN
                tb_ivc_lin(ivc).vrt_sg_m  := nvl (tb_ivc_lin(ivc).vrt_sg_m , 0) + nvl (tb_dcl_lin(dcl).vrt_sg_m, 0);
              END IF;

              tb_ivc_lin(ivc).vrt_sg_mn := nvl (tb_ivc_lin(ivc).vrt_sg_mn, 0) + nvl (tb_dcl_lin(dcl).vrt_sg_m * vn_taxa_mn, 0);
              tb_ivc_lin(ivc).vrt_sg_us := nvl (tb_ivc_lin(ivc).vrt_sg_us, 0) + nvl (tb_dcl_lin(dcl).vrt_sg_m * vn_taxa_us, 0);

              IF (pn_tp_declaracao = 15) OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N') THEN
                tb_ivc_lin(ivc).taxa_mn_sg := vn_taxa_mn;
                tb_ivc_lin(ivc).taxa_us_sg := vn_taxa_us;
              END IF;
              --Customização UHK
              vn_global_vrt_sg_ebq_us := nvl (vn_global_vrt_sg_ebq_us, 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_sg_m * vn_taxa_us, 0)/*, 2)*/;
              vn_global_vrt_sg_ebq_mn := nvl (vn_global_vrt_sg_ebq_mn, 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_sg_m * vn_taxa_mn, 0)/*, 2)*/;
              vn_global_vrt_sg_ebq_m  := nvl (vn_global_vrt_sg_ebq_m, 0) + /*round (*/nvl (tb_dcl_lin(dcl).vrt_sg_m, 0)/*, 2)*/;

              
            END IF;
          END LOOP;
        END LOOP;
      END IF;
    ELSE /*Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id, 1),'XX') = 'NAC_DE_TERC'*/

      --FOR dcl IN 1..vn_global_dcl_lin LOOP
        FOR ivc IN 1..vn_global_ivc_lin LOOP
          tb_ivc_lin(ivc).vrt_sg_m   := 0;
          tb_ivc_lin(ivc).vrt_sg_mn  := 0;
          tb_ivc_lin(ivc).vrt_sg_us  := 0;
          tb_ivc_lin(ivc).taxa_mn_sg := 0;
          tb_ivc_lin(ivc).taxa_us_sg := 0;
        END LOOP;
      --END LOOP;

      FOR da IN cur_valores_ivc_da LOOP
        imp_prc_busca_taxa_conversao (
          da.moeda_sg_da_nac_id
        , pd_data_totalizar
        , vn_taxa_mn
        , vn_taxa_us
        , 'Moeda do seguro internacional da D.A. da invoice'
        );
        FOR ivc IN 1..vn_global_ivc_lin LOOP
          IF tb_ivc_lin(ivc).invoice_lin_id = da.invoice_lin_id THEN

            tb_ivc_lin(ivc).vrt_sg_m  := nvl (tb_ivc_lin(ivc).vrt_sg_m , 0) + nvl (da.valor_seguro             , 0);
            tb_ivc_lin(ivc).vrt_sg_mn := nvl (tb_ivc_lin(ivc).vrt_sg_mn, 0) + nvl (da.valor_seguro * vn_taxa_mn, 0);
            tb_ivc_lin(ivc).vrt_sg_us := nvl (tb_ivc_lin(ivc).vrt_sg_us, 0) + nvl (da.valor_seguro * vn_taxa_us, 0);
          END IF;


        END LOOP;
      END LOOP;

    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no processamento do seguro internacional: ' || sqlerrm, 'E', 'A');
  END imp_prc_processa_sg_internac;

  -- ***********************************************************************
  -- Esta procedure ira buscar todas as linhas de mercadoria das invoices e
  -- ratear o valor dos acréscimos e deduções do valor aduaneiro do embarque.
  -- ***********************************************************************
  PROCEDURE imp_prc_rateio_acres_ded( pc_tp_rateio      VARCHAR2
                                    , pn_taxa_mn        NUMBER
                                    , pn_taxa_us        NUMBER
                                    , pn_valor_ad       NUMBER
                                    , pc_tipo_acresded  VARCHAR2
                                    , pn_embarque_ad_id NUMBER
                                    , pn_acres_ded_id   NUMBER
                                    , pn_moeda_id       NUMBER
                                    , pn_valor_ajuste_base_icms NUMBER
                                    , pd_data_totalizar DATE
                                    )  AS


    --CURSOR cur_adi(pn_invoice_lin_id NUMBER)
    --    IS
    --SELECT Count(DISTINCT declaracao_adi_id) dcl
    --  FROM imp_declaracoes_lin  idl
    -- WHERE idl.invoice_lin_id = pn_invoice_lin_id;

    CURSOR cur_adi(pn_invoice_lin_id NUMBER)
        IS
    SELECT Nvl(Count(*),0) dcl
      FROM (
             SELECT idl.declaracao_id
                  , idl.invoice_lin_id
                  , idl.declaracao_adi_id
                  , Count(*) OVER(PARTITION BY idl.invoice_lin_id) adicoes
                  , Count(*) OVER(PARTITION BY idl.declaracao_adi_id) invoices
                  , Row_Number() OVER(PARTITION BY idl.declaracao_adi_id ORDER BY Decode( pc_tp_rateio
                                                                                        , 'F', idl.qtde * idl.preco_unitario_m
                                                                                        , idl.pesoliq_tot
                                                                                        )   DESC) maior
                  , idl.qtde * idl.preco_unitario_m
               FROM imp_declaracoes_lin  idl
              WHERE EXISTS (SELECT 1
                              FROM imp_declaracoes_lin idl2
                             WHERE idl.declaracao_id = idl2.declaracao_id
                               AND idl2.invoice_lin_id = pn_invoice_lin_id
                           )
          ) a
     WHERE a.invoice_lin_id = pn_invoice_lin_id
       AND a.maior = 1;



    vn_soma_acresded_m NUMBER := 0;
    vn_soma_ajuste_base_icms_m NUMBER := 0;
    vn_ind_rateio      NUMBER := 0;
    vn_ind_rateio_ajuste_base_icms NUMBER := 0;
    vn_valor_total     NUMBER := 0;
    vc_tp_acresded     VARCHAR2(1);
    vc_erro            VARCHAR2(2000);


    vn_maior_lin       NUMBER := 1;
    vn_adicoes         NUMBER;
    vn_minimo          NUMBER;
    vn_ajuste          NUMBER;
    vn_adicoes_tot     NUMBER;
    vb_primeira_vez    BOOLEAN := true;

    vn_maior_lin_ajuste            NUMBER := 0;
    vn_valor_mn_atual              NUMBER := 0;

    vn_taxa_us_ad                  NUMBER := 0;
    vn_taxa_mn_ad                  NUMBER := 0;

    vn_dif_reais                   NUMBER := 0;
    vn_dif_moeda_ivc               NUMBER := 0;

  BEGIN
    vc_erro := 'Antes rateio';

    /* Identificando o valor total para efetuar o indice para rateio */
    FOR ivc IN tb_rateio_acresded.first..tb_rateio_acresded.last LOOP


      vc_erro := 'Antes vrt_total';
      IF ( pc_tp_rateio = 'F' ) THEN
          tb_rateio_acresded(ivc).vrt_total := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_fob_mn / pn_taxa_mn, 0);
      ELSE
          tb_rateio_acresded(ivc).vrt_total := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).pesoliq_tot, 0);
      END IF;

      vn_valor_total := vn_valor_total + tb_rateio_acresded(ivc).vrt_total;
    END LOOP;

    vc_erro := 'calculando indice para rateio';
    /* calculando o indice para rateio */
    vn_ind_rateio := pn_valor_ad / vn_valor_total;
    vn_ind_rateio_ajuste_base_icms := pn_valor_ajuste_base_icms / vn_valor_total;

    vc_erro := 'efetuando rateio';

    /* Efetuando o Rateio */
    FOR ivc IN tb_rateio_acresded.first..tb_rateio_acresded.last LOOP
        tb_rateio_acresded(ivc).vrt_acresded_m    := round(tb_rateio_acresded(ivc).vrt_total * vn_ind_rateio,2);
        tb_rateio_acresded(ivc).vrt_ajuste_base_icms_m    := round(tb_rateio_acresded(ivc).vrt_total * vn_ind_rateio_ajuste_base_icms,2);
        vn_soma_acresded_m := vn_soma_acresded_m + tb_rateio_acresded(ivc).vrt_acresded_m;
        vn_soma_ajuste_base_icms_m := vn_soma_ajuste_base_icms_m + tb_rateio_acresded(ivc).vrt_ajuste_base_icms_m  ;
      tb_rateio_acresded(ivc).vrt_acresded_mn := round(nvl(tb_rateio_acresded(ivc).vrt_acresded_m * pn_taxa_mn,0),2);
      tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mn   := round(nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_m * pn_taxa_mn,0),2);

      IF (tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).taxa_mn_fob > 0) THEN
        tb_rateio_acresded(ivc).vrt_acresded_mfob := nvl( tb_rateio_acresded(ivc).vrt_acresded_mn  / tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).taxa_mn_fob,0);
        tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mfob := nvl( tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mn  / tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).taxa_mn_fob,0);
      ELSE
        tb_rateio_acresded(ivc).vrt_acresded_mfob := 0;
      END IF;

      tb_rateio_acresded(ivc).vrt_acresded_us   := nvl(tb_rateio_acresded(ivc).vrt_acresded_m * pn_taxa_us,0);
      tb_rateio_acresded(ivc).vrt_ajuste_base_icms_us   := nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_m * pn_taxa_us,0);

      IF (pc_tipo_acresded  = '119') THEN
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_acres_m  := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_acres_m ,0) + nvl(tb_rateio_acresded(ivc).vrt_acresded_mfob,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_acres_mn := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_acres_mn,0) + nvl(tb_rateio_acresded(ivc).vrt_acresded_mn,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_acres_us := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_acres_us,0) + nvl(tb_rateio_acresded(ivc).vrt_acresded_us,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_m  := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_m ,0) + (nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mfob,0) * -1);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_mn := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_mn,0) + (nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mn,0)   * -1);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_us := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_us,0) + (nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_us,0)   * -1);
        vc_tp_acresded := 'A';
      ELSE
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ded_m    := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ded_m,0)  + nvl(tb_rateio_acresded(ivc).vrt_acresded_mfob,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ded_mn   := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ded_mn,0) + nvl(tb_rateio_acresded(ivc).vrt_acresded_mn,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ded_us   := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ded_us,0) + nvl(tb_rateio_acresded(ivc).vrt_acresded_us,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_m    := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_m,0)  + nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mfob,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_mn   := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_mn,0) + nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mn,0);
        tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_us   := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_us ,0)+ nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_us,0);

        vc_tp_acresded := 'D';
      END IF;

      vn_global_ivc_ad_lin := vn_global_ivc_ad_lin + 1;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).embarque_ad_id := pn_embarque_ad_id;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).invoice_lin_id := tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).invoice_lin_id;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).tp_acres_ded   := vc_tp_acresded;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).acres_ded_id   := pn_acres_ded_id;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).qtde_invoice   := tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).qtde;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).moeda_id       := pn_moeda_id;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).taxa_mn        := pn_taxa_mn;
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_m        := nvl(tb_rateio_acresded(ivc).vrt_acresded_m,0);
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_mn       := nvl(tb_rateio_acresded(ivc).vrt_acresded_mn,0);
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_us       := nvl(tb_rateio_acresded(ivc).vrt_acresded_us,0);
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_m  := nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_m,0);
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_mn := nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mn,0);
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_us := nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_us,0);
      tb_ivc_lin_ad(vn_global_ivc_ad_lin).ind_tb_ivc_lin := tb_rateio_acresded(ivc).ind_tb_ivc_lin;

      IF (vb_primeira_vez) THEN
        vn_maior_lin    := vn_global_ivc_ad_lin;
        vb_primeira_vez := false;
      END IF;

      IF (tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_m > tb_ivc_lin_ad(vn_maior_lin).valor_m) THEN
         vn_maior_lin := vn_global_ivc_ad_lin;
      END IF;
    END LOOP; -- FOR ivc IN tb_rateio_acresded.first..tb_rateio_acresded.last LOOP

    --1-jogando a diferenca na linha de maior valor

    tb_ivc_lin_ad(vn_maior_lin).valor_m   := tb_ivc_lin_ad(vn_maior_lin).valor_m  + nvl( pn_valor_ad - vn_soma_acresded_m,0);
    tb_ivc_lin_ad(vn_maior_lin).valor_us  := nvl(tb_ivc_lin_ad(vn_maior_lin).valor_m * pn_taxa_us,0);
    tb_ivc_lin_ad(vn_maior_lin).valor_mn  := nvl(tb_ivc_lin_ad(vn_maior_lin).valor_m * pn_taxa_mn,0);

    /* pegando a taxa para calcular o acrescimo em dolar */
    imp_prc_busca_taxa_conversao ( tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).moeda_fob_id
                                 , pd_data_totalizar
                                 , vn_taxa_mn_ad
                                 , vn_taxa_us_ad
                                 , 'Rateio acres/ded ivc_lin');

    /* A diferenca entre o valor do acrescimo rateado e o valor original está na moeda do acrescimo         */
    /* consquentemente, temos que primeiro passa-lo para reais para depois passa-lo para a moeda da invoice */
    vn_dif_reais     := 0;
    vn_dif_moeda_ivc := 0;

    vn_dif_reais     := nvl( pn_valor_ad - vn_soma_acresded_m,0) * pn_taxa_mn;
    vn_dif_moeda_ivc := vn_dif_reais / tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).taxa_mn_fob;

          IF (pc_tipo_acresded  = '119') THEN
      tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_acres_m  := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_acres_m  + nvl (vn_dif_moeda_ivc, 0);
      tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_acres_mn := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_acres_mn + nvl (vn_dif_reais, 0);
      tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_acres_us := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_acres_m * vn_taxa_us_ad;
            vc_tp_acresded := 'A';
          ELSE
      tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ded_m    := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ded_m  + nvl (vn_dif_moeda_ivc, 0);
      tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ded_mn   := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ded_mn + nvl (vn_dif_reais, 0);
      tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ded_us   := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ded_m * vn_taxa_us_ad;
            vc_tp_acresded := 'D';
          END IF;

    vc_erro := 'depois rateio';

--    vc_erro := 'Pegando a linha de maior valor para ajuste rateio valor minimo fatura';
--    vn_maior_lin_ajuste := 0;
--    vn_valor_mn_atual   := 0;
--    FOR ad_lin_maior_valor IN tb_ivc_lin_ad.first..tb_ivc_lin_ad.last LOOP
--      IF (tb_ivc_lin_ad(ad_lin_maior_valor).embarque_ad_id = pn_embarque_ad_id) THEN
--        IF (tb_ivc_lin_ad(ad_lin_maior_valor).valor_mn > vn_valor_mn_atual) THEN
--          vn_valor_mn_atual   := tb_ivc_lin_ad(ad_lin_maior_valor).valor_mn;
--          vn_maior_lin_ajuste := ad_lin_maior_valor;
--        END IF;
--      END IF;
--    END LOOP; -- FOR ad_lin_maior_valor IN tb_ivc_lin_ad.first..tb_ivc_lin_ad.last LOOP

--    vc_erro := 'ajuste rateio valor minimo fatura';
--    vn_adicoes_tot := 0;
--    FOR ivc IN tb_ivc_lin_ad.first..tb_ivc_lin_ad.last LOOP
--      OPEN cur_adi(tb_ivc_lin_ad(ivc).invoice_lin_id);
--      FETCH cur_adi INTO vn_adicoes;
--      CLOSE cur_adi;

--      vn_adicoes_tot := vn_adicoes_tot + vn_adicoes;
--      vn_minimo      := vn_adicoes * 0.01;

--      IF (tb_ivc_lin_ad(ivc).valor_m < vn_minimo) AND (tb_ivc_lin_ad(ivc).embarque_ad_id = pn_embarque_ad_id) THEN
--        -- ajusta a linha de maior valor
--        vn_ajuste := (vn_minimo - tb_ivc_lin_ad(ivc).valor_m) * 100;
--        FOR i IN 1..vn_ajuste LOOP
--          tb_ivc_lin_ad(vn_maior_lin_ajuste).valor_m  := tb_ivc_lin_ad(vn_maior_lin_ajuste).valor_m - 0.01;
--          tb_ivc_lin_ad(vn_maior_lin_ajuste).valor_us := nvl(tb_ivc_lin_ad(vn_maior_lin_ajuste).valor_m * pn_taxa_us,0);
--          tb_ivc_lin_ad(vn_maior_lin_ajuste).valor_mn := nvl(tb_ivc_lin_ad(vn_maior_lin_ajuste).valor_m * pn_taxa_mn,0);

--          -- ajusta o valor da menor linha
--          tb_ivc_lin_ad(ivc).valor_m   := tb_ivc_lin_ad(ivc).valor_m + 0.01;
--          tb_ivc_lin_ad(ivc).valor_us  := nvl(tb_ivc_lin_ad(ivc).valor_m * pn_taxa_us,0);
--          tb_ivc_lin_ad(ivc).valor_mn  := nvl(tb_ivc_lin_ad(ivc).valor_m * pn_taxa_mn,0);

--          IF (pc_tipo_acresded  = '119') THEN
--            tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_acres_m  := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_acres_m - (0.01 / tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).taxa_mn_fob);
--            tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_acres_mn := Round(tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_acres_m * tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).taxa_mn_fob,2);
--            tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_acres_us := Round(tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_acres_mn * pn_taxa_us,2);
--            --tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ajuste_base_icms_m  := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_m ,0) + (nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mfob,0) * -1);
--            --tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ajuste_base_icms_mn := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_mn,0) + (nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_mn,0)   * -1);
--            --tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin).ind_tb_ivc_lin).vrt_ajuste_base_icms_us := nvl(tb_ivc_lin(tb_rateio_acresded(ivc).ind_tb_ivc_lin).vrt_ajuste_base_icms_us,0) + (nvl(tb_rateio_acresded(ivc).vrt_ajuste_base_icms_us,0)   * -1);
--            vc_tp_acresded := 'A';
--          ELSE
--            tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_ded_m    := tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_ded_m - (0.01 /tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).taxa_mn_fob);
--            tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_ded_mn   := Round(tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_ded_m * tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).taxa_mn_fob,2);
--            tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_ded_us   := Round(tb_ivc_lin(tb_ivc_lin_ad(vn_maior_lin_ajuste).ind_tb_ivc_lin).vrt_ded_mn * pn_taxa_us,2);
--            vc_tp_acresded := 'D';
--          END IF;

--          IF (pc_tipo_acresded  = '119') THEN
--            tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_acres_m  := tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_acres_m + (0.01/tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).taxa_mn_fob);
--            tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_acres_mn := Round(tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_acres_m * tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).taxa_mn_fob,2);
--            tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_acres_us := Round(tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_acres_mn * pn_taxa_us,2);
--            vc_tp_acresded := 'A';
--          ELSE
--            tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_ded_m    := tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_ded_m  + (0.01/tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).taxa_mn_fob);
--            tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_ded_mn   := Round(tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_ded_m * tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).taxa_mn_fob,2);
--            tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_ded_us   := Round(tb_ivc_lin(tb_ivc_lin_ad(ivc).ind_tb_ivc_lin).vrt_ded_mn * pn_taxa_us,2);
--            vc_tp_acresded := 'D';
--          END IF;

--          -- verifica quem é o maior depois do ajuste;
--          FOR ivcm IN tb_ivc_lin_ad.first..tb_ivc_lin_ad.last LOOP
--            IF (tb_ivc_lin_ad(vn_maior_lin_ajuste).valor_m < tb_ivc_lin_ad(ivcm).valor_m) AND (tb_ivc_lin_ad(ivcm).valor_m > 0.01) AND (tb_ivc_lin_ad(ivcm).embarque_ad_id = pn_embarque_ad_id)  THEN
--              vn_maior_lin_ajuste := ivcm;
--            END IF;
--          END LOOP; -- FOR ivcm IN tb_ivc_lin_ad.first..tb_ivc_lin_ad.last LOOP
--        END LOOP; -- FOR i IN 1..vn_ajuste LOOP
--      END IF; -- IF (tb_ivc_lin_ad(ivc).valor_m < vn_minimo) AND (tb_ivc_lin_ad(ivc).embarque_ad_id = pn_embarque_ad_id) THEN
--    END LOOP; -- FOR ivc IN tb_ivc_lin_ad.first..tb_ivc_lin_ad.last LOOP

    IF (vn_adicoes_tot/100) > pn_valor_ad AND pn_valor_ad > 0 THEN
      Raise_Application_Error (-20000, 'Não é possível realizar o rateio dos acréscimo/dedução nas linhas da fatura pois não ha saldo para colocar o valor mínimo. Valor necessário ' || To_Char(vn_adicoes_tot / 100,'FM999G999G999G999G999G990D00') || ' - Valor do acréscimo/dedução ' || To_Char(pn_valor_ad ,'FM999G999G999G999G999G990D00') || '.' );
    END IF;

EXCEPTION
WHEN others THEN
 Raise_Application_Error (-20000, 'Erro no rateio de AD - ['||pn_embarque_ad_id||']['||tb_rateio_acresded.first||']['||tb_rateio_acresded.last||']'||vc_erro||'-'||sqlerrm);

  END imp_prc_rateio_acres_ded;

  PROCEDURE imp_prc_tmp_rateio_acresded( pc_tipo           VARCHAR2
                                       , pn_invoice_id     NUMBER
                                       , pn_embarque_ad_id NUMBER
                                       , pn_embarque_id    NUMBER
                                       ) AS

    CURSOR cur_por_invoice IS
      SELECT invoice_lin_id
        FROM imp_invoices_lin  iil,
             cmx_tabelas       ct
       WHERE iil.invoice_id = pn_invoice_id
         AND ct.tabela_id   = iil.tp_linha_id
         AND ct.auxiliar1   = 'M'
    ORDER BY invoice_lin_id ;

    CURSOR cur_por_embarque IS
      SELECT invoice_lin_id
        FROM imp_invoices_lin  iil,
             cmx_tabelas       ct
       WHERE iil.embarque_id = pn_embarque_id
         AND ct.tabela_id    = iil.tp_linha_id
         AND ct.auxiliar1    = 'M'
         AND iil.invoice_lin_id NOT IN ( SELECT invoice_lin_id
                                           FROM imp_invoices_lin         iil
                                              , imp_embarques_ad_invoice ieadi
                                          WHERE ieadi.embarque_ad_id = pn_embarque_ad_id
                                            AND ieadi.invoice_id     = iil.invoice_id
                                       )
    ORDER BY invoice_lin_id ;

    CURSOR cur_por_item IS
      SELECT invoice_lin_id
        FROM imp_embarques_ad_lin ieadi
       WHERE ieadi.embarque_ad_id = pn_embarque_ad_id
    ORDER BY invoice_lin_id;

    vn_indice_tmp NUMBER := 0;

    FUNCTION fnc_achar_indice( pn_invoice_lin_id NUMBER ) RETURN NUMBER AS

      vn_indice NUMBER := 0;

    BEGIN

      WHILE TRUE LOOP

        vn_indice := vn_indice + 1;

        IF( tb_ivc_lin(vn_indice).invoice_lin_id = pn_invoice_lin_id ) THEN
          EXIT;
        END IF;

        IF( vn_indice = vn_global_ivc_lin ) THEN
          EXIT;
        END IF;

      END LOOP;

      RETURN ( vn_indice );
    END fnc_achar_indice;

  BEGIN

    -- Zerar tabela
    tb_rateio_acresded.delete;

    IF ( pc_tipo = 'POR INVOICE' ) THEN
      -- Abrir cursor por invoice
      -- Popular tabela TMP
      FOR i IN cur_por_invoice LOOP
        vn_indice_tmp := vn_indice_tmp + 1;
        tb_rateio_acresded(vn_indice_tmp).ind_tb_ivc_lin     := fnc_achar_indice(i.invoice_lin_id);
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_m     := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_mn    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_mfob  := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_us    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_m     := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_mn    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_mfob  := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_us    := 0;

      END LOOP;


    ELSIF( pc_tipo = 'POR EMBARQUE' ) THEN
      -- Abrir cursor por embarque
      FOR i IN cur_por_embarque LOOP
        vn_indice_tmp := vn_indice_tmp + 1;
        tb_rateio_acresded(vn_indice_tmp).ind_tb_ivc_lin  := fnc_achar_indice(i.invoice_lin_id);
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_m     := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_mn    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_mfob  := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_us    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_m     := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_mn    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_mfob  := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_us    := 0;
      END LOOP;

    ELSIF( pc_tipo = 'POR ITEM' ) THEN
      -- abrir cursor por item
      FOR i IN cur_por_item LOOP
        vn_indice_tmp := vn_indice_tmp + 1;
        tb_rateio_acresded(vn_indice_tmp).ind_tb_ivc_lin  := fnc_achar_indice(i.invoice_lin_id);
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_m     := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_mn    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_mfob  := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_acresded_us    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_m     := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_mn    := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_mfob  := 0;
        tb_rateio_acresded(vn_indice_tmp).vrt_ajuste_base_icms_us    := 0;

      END LOOP;

    END IF;

  END imp_prc_tmp_rateio_acresded;

  FUNCTION fnc_busca_ad_lin_maior_valor (pn_acres_ded_id NUMBER) RETURN NUMBER IS
    vn_ind             NUMBER;
    vn_ind_maior_valor NUMBER := 0;
    vn_maior_valor     NUMBER := 0;
  BEGIN
    FOR vn_ind IN 1..vn_global_ivc_ad_lin LOOP
      IF tb_ivc_lin_ad(vn_ind).acres_ded_id = pn_acres_ded_id THEN
        IF tb_ivc_lin_ad(vn_ind).valor_m > vn_maior_valor AND tb_ivc_lin_ad(vn_ind).valor_m <> 0.01 THEN
          vn_maior_valor := tb_ivc_lin_ad(vn_ind).valor_m;
          vn_ind_maior_valor := vn_ind;
        END IF;
      END IF;
    END LOOP;
    RETURN vn_ind_maior_valor;
  END;

  FUNCTION fnc_busca_primeira_lin_ad (pn_declaracao_adi_id NUMBER, pn_acres_ded_id NUMBER) RETURN NUMBER IS
    vn_ind             NUMBER;
  BEGIN
--    cmx_prc_teste_execucao('busca primeira linha: vn_global_ivc_ad_lin='||vn_global_ivc_ad_lin,9988);
    FOR vn_ind IN 1..vn_global_ivc_ad_lin LOOP
      IF tb_ivc_lin_ad(vn_ind).declaracao_adi_id IS null THEN
        SELECT declaracao_adi_id
          INTO tb_ivc_lin_ad(vn_ind).declaracao_adi_id
          FROM imp_declaracoes_lin idl
         WHERE invoice_lin_id = tb_ivc_lin_ad(vn_ind).invoice_lin_id;
      END IF;
--      cmx_prc_teste_execucao('busca primeira linha: vn_global_ivc_ad_lin='||vn_global_ivc_ad_lin||' tb_ivc_lin_ad(vn_ind).declaracao_adi_id['||tb_ivc_lin_ad(vn_ind).declaracao_adi_id ||'] tb_ivc_lin_ad(vn_ind).invoice_lin_id['||tb_ivc_lin_ad(vn_ind).invoice_lin_id||']',9988);
      IF tb_ivc_lin_ad(vn_ind).acres_ded_id = pn_acres_ded_id AND tb_ivc_lin_ad(vn_ind).declaracao_adi_id = pn_declaracao_adi_id THEN
        RETURN vn_ind;
      END IF;
    END LOOP;
    RETURN 0;
  END;

  PROCEDURE prc_tratar_adicoes_zeradas (tb_ad_adi IN OUT tb_adi_acresded, pn_acres_ded_id NUMBER, pn_taxa_mn NUMBER) IS
    vn_ind                 NUMBER;
    vn_ind_lin_ad          NUMBER;
    vn_ind_lin_maior_valor NUMBER;

  BEGIN
--    cmx_prc_teste_Execucao ('tb_ad_adi.count['||tb_ad_adi.count||']', 9988);
    FOR vn_ind IN 1..tb_ad_adi.count LOOP
      IF nvl (tb_ad_adi(vn_ind).valor_m, 0) = 0 AND (tb_ad_adi(vn_ind).acres_ded_id = pn_acres_ded_id) THEN
        -- atribui 0.01
        tb_ad_adi(vn_ind).valor_m  := 0.01;
        tb_ad_adi(vn_ind).valor_mn := tb_ad_adi(vn_ind).valor_m * pn_taxa_mn;
        vn_ind_lin_maior_valor     := fnc_busca_ad_lin_maior_valor (tb_ad_adi(vn_ind).acres_ded_id);
--        cmx_prc_teste_Execucao ('tb_ad_adi(vn_ind).valor_m ['||tb_ad_adi(vn_ind).valor_m  ||']
--tb_ad_adi(vn_ind).valor_mn['||tb_ad_adi(vn_ind).valor_mn ||']
--vn_ind_lin_maior_valor    ['||vn_ind_lin_maior_valor     ||']',9988);
        IF vn_ind_lin_maior_valor <> 0 THEN
          -- soma 0.01 na linha de maior valor (sempre vai achar linhas em outra adicao, pois a que está sendo ajustada está zerada)
          tb_ivc_lin_ad(vn_ind_lin_maior_valor).valor_m  := tb_ivc_lin_ad(vn_ind_lin_maior_valor).valor_m - 0.01;
          tb_ivc_lin_ad(vn_ind_lin_maior_valor).valor_mn := tb_ivc_lin_ad(vn_ind_lin_maior_valor).valor_mn - tb_ad_adi(vn_ind).valor_mn;

--          cmx_prc_teste_Execucao ('buscando linha adi_id['||tb_ad_adi(vn_ind).declaracao_adi_id||'] ad_id['||tb_ad_adi(vn_ind).acres_ded_id||']', 9988 );
          vn_ind_lin_ad := fnc_busca_primeira_lin_ad (tb_ad_adi(vn_ind).declaracao_adi_id, tb_ad_adi(vn_ind).acres_ded_id);
          IF vn_ind_lin_ad <> 0 THEN
--            cmx_prc_teste_Execucao ('vn_ind_lin_ad['||vn_ind_lin_ad||']', 9988);
            tb_ivc_lin_ad(vn_ind_lin_ad).valor_m  := tb_ivc_lin_ad(vn_ind_lin_ad).valor_m + 0.01;
            tb_ivc_lin_ad(vn_ind_lin_ad).valor_mn := tb_ivc_lin_ad(vn_ind_lin_ad).valor_mn + tb_ad_adi(vn_ind).valor_mn;
          ELSE
            raise_application_error (-20000, 'não há linhas na adição para fazer o ajuste de +0.01');
          END IF;
        ELSE
          raise_application_error (-20000, 'não há linhas na adição para fazer o ajuste de -0.01');
        END IF;
      END IF;
    END LOOP;
  END;

  PROCEDURE imp_grava_acreded_adicao_dcl (pn_declaracao_id NUMBER, ptb_ad_adi IN OUT tb_adi_acresded)IS
    BEGIN
    FOR adi IN 1..ptb_ad_adi.Count /*vn_ultima_adi_ad*/ LOOP
--        IF (tb_ad_adi(adi).valor_m > 0) THEN
          INSERT INTO imp_dcl_adi_acresded
                      ( declaracao_id
                      , declaracao_adi_id
                      , tp_acres_ded
                      , acres_ded_id
                      , moeda_id
                      , valor_m
                      , valor_mn
                      , valor_ajuste_base_icms_m
                      , valor_ajuste_base_icms_mn
                      , creation_date
                      , created_by
                      , last_update_date
                      , last_updated_by
                      , grupo_acesso_id
                      )
                VALUES( pn_declaracao_id
                      , ptb_ad_adi(adi).declaracao_adi_id
                      , ptb_ad_adi(adi).tp_acres_ded
                      , ptb_ad_adi(adi).acres_ded_id
                      , ptb_ad_adi(adi).moeda_id
                      , ptb_ad_adi(adi).valor_m
                      , ptb_ad_adi(adi).valor_mn
                      , ptb_ad_adi(adi).valor_ajuste_base_icms_m
                      , ptb_ad_adi(adi).valor_ajuste_base_icms_mn
                      , vd_global_creation_date
                      , vn_global_created_by
                      , vd_global_last_update_date
                      , vn_global_last_updated_by
                      , vn_global_grupo_acesso_id
                      );
--        END IF;
      END LOOP;

      -- ajusta os valores dos acrescimos zerados.
--      prc_ajusta_valores_acresded(pn_declaracao_id, pd_data_conversao,vn_ultima_adi_ad,ptb_ad_adi);

    EXCEPTION
      WHEN others THEN
        prc_gera_log_erros ('Erro na gravação do acréscimo/dedução da adição: ' || sqlerrm, 'E', 'D');
    END imp_grava_acreded_adicao_dcl;

  PROCEDURE imp_carrega_ad_adicao_dcl_nac (ptb_ad_adi IN OUT tb_adi_acresded) IS
      vn_ant_declaracao_adi_id  NUMBER      := 0;
	  vn_ant_tp_acres_ded       VARCHAR2(1) := 'X';
	  vn_ant_acres_ded_id       NUMBER      := 0;
	  vn_ant_moeda_id           NUMBER      := 0;
      vn_ultima_adi_ad          NUMBER;

    BEGIN
      vn_ultima_adi_ad := 0;
      FOR ad IN 1..vn_global_ivc_ad_lin LOOP

        IF (vn_ant_declaracao_adi_id <> tb_ivc_lin_ad(ad).declaracao_adi_id) OR
		         (vn_ant_tp_acres_ded <>  tb_ivc_lin_ad(ad).tp_acres_ded ) OR
		         (vn_ant_acres_ded_id <>  tb_ivc_lin_ad(ad).acres_ded_id ) OR
		         (vn_ant_moeda_id     <>  tb_ivc_lin_ad(ad).moeda_id     ) THEN

          vn_ultima_adi_ad := vn_ultima_adi_ad + 1;
          vn_ant_declaracao_adi_id := tb_ivc_lin_ad(ad).declaracao_adi_id;
          vn_ant_tp_acres_ded      := tb_ivc_lin_ad(ad).tp_acres_ded;
      		  vn_ant_acres_ded_id      := tb_ivc_lin_ad(ad).acres_ded_id;
		        vn_ant_moeda_id          := tb_ivc_lin_ad(ad).moeda_id;
        END IF;

        ptb_ad_adi(vn_ultima_adi_ad).declaracao_adi_id := tb_ivc_lin_ad(ad).declaracao_adi_id;
        ptb_ad_adi(vn_ultima_adi_ad).tp_acres_ded      := tb_ivc_lin_ad(ad).tp_acres_ded;
        ptb_ad_adi(vn_ultima_adi_ad).acres_ded_id      := tb_ivc_lin_ad(ad).acres_ded_id;
        ptb_ad_adi(vn_ultima_adi_ad).moeda_id          := tb_ivc_lin_ad(ad).moeda_id;
        ptb_ad_adi(vn_ultima_adi_ad).valor_m           := Round(nvl(ptb_ad_adi(vn_ultima_adi_ad).valor_m,0) + tb_ivc_lin_ad(ad).valor_m,2);
        ptb_ad_adi(vn_ultima_adi_ad).valor_mn          := Round(nvl(ptb_ad_adi(vn_ultima_adi_ad).valor_mn,0) + tb_ivc_lin_ad(ad).valor_mn,2);
        ptb_ad_adi(vn_ultima_adi_ad).valor_ajuste_base_icms_m  := nvl(ptb_ad_adi(vn_ultima_adi_ad).valor_ajuste_base_icms_m,0)  + tb_ivc_lin_ad(ad).valor_ajuste_base_icms_m;
        ptb_ad_adi(vn_ultima_adi_ad).valor_ajuste_base_icms_mn := nvl(ptb_ad_adi(vn_ultima_adi_ad).valor_ajuste_base_icms_mn,0) + tb_ivc_lin_ad(ad).valor_ajuste_base_icms_mn;

      END LOOP;  --- acresded
  --    cmx_prc_teste_Execucao ('vn_ultima_adi_ad['||vn_ultima_adi_ad||']', 9988);
    EXCEPTION
      WHEN others THEN
        prc_gera_log_erros ('Erro ao carregar o acréscimo/dedução da adição: ' || sqlerrm, 'E', 'D');
    END imp_carrega_ad_adicao_dcl_nac;

  PROCEDURE imp_carrega_ad_adicao_dcl (ptb_ad_adi IN OUT tb_adi_acresded) IS
      vb_achou_adicao   BOOLEAN := FALSE;
      vn_ultima_adi_ad  NUMBER;
      vn_ind_ad_mn      NUMBER  := 0;
      vn_soma_ad_mn     NUMBER  := 0;
      vn_soma_qtde      NUMBER  := 0;
      vn_rateio_ad_mn   NUMBER  := 0;
      vn_rateio_ad_m    NUMBER  := 0;
      vb_primeira_vez   BOOLEAN := TRUE;
      vc_step_error     VARCHAR2(1000);

      vn_ind_ajuste_base_icms_mn    NUMBER := 0;
      vn_soma_ajuste_base_icms_mn   NUMBER := 0;
      vn_rateio_ajuste_base_icms_mn NUMBER := 0;
      vn_rateio_ajuste_base_icms_m  NUMBER := 0;

    BEGIN
    vn_ultima_adi_ad                              := 0;
    vc_step_error := 'imp_carrega_ad_adicao_dcl: '||vn_global_ivc_ad_lin||' tb_ivc_lin_ad.count['||tb_ivc_lin_ad.count||'] vn_global_dcl_lin['||vn_global_dcl_lin||']';
--    cmx_prc_teste_execucao(vc_step_error,9988);
      FOR ad IN 1..vn_global_ivc_ad_lin LOOP

        vc_step_error := 'loop('||ad||'). calcula indice';
        IF (tb_ivc_lin_ad(ad).qtde_invoice > 0) THEN
          vn_ind_ad_mn := NVL(tb_ivc_lin_ad(ad).valor_mn / tb_ivc_lin_ad(ad).qtde_invoice,0);
          vn_ind_ajuste_base_icms_mn := NVL(tb_ivc_lin_ad(ad).valor_ajuste_base_icms_mn / tb_ivc_lin_ad(ad).qtde_invoice,0);
        ELSE
          vn_ind_ad_mn := 0;
          vn_ind_ajuste_base_icms_mn := 0;
        END IF;

        vn_soma_ad_mn := 0;
        vn_soma_ajuste_base_icms_mn := 0;
        vn_soma_qtde  := 0;

        vc_step_error := 'loop decl: '||vn_global_dcl_lin;
        FOR dcl IN 1..vn_global_dcl_lin LOOP

          vc_step_error := 'loop decl('||dcl||').busca linha invoice ad.count['||tb_ivc_lin_ad.count||'] dcl.count['||tb_dcl_lin.count||']';
          IF (tb_ivc_lin_ad(ad).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id) THEN

            vc_step_error := 'loop decl('||dcl||').soma qtd';
            vn_soma_qtde := vn_soma_qtde + tb_dcl_lin(dcl).qtde;

            IF (tb_ivc_lin_ad(ad).qtde_invoice = vn_soma_qtde) THEN
              vn_rateio_ad_mn := NVL(tb_ivc_lin_ad(ad).valor_mn, 0) - vn_soma_ad_mn;
              vn_rateio_ajuste_base_icms_mn := NVL(tb_ivc_lin_ad(ad).valor_ajuste_base_icms_mn, 0) - vn_soma_ajuste_base_icms_mn;
            ELSE
              vn_rateio_ad_mn := tb_dcl_lin(dcl).qtde * vn_ind_ad_mn;
              vn_rateio_ajuste_base_icms_mn := tb_dcl_lin(dcl).qtde * vn_ind_ajuste_base_icms_mn;
            END IF;
            vn_soma_ad_mn := vn_soma_ad_mn + vn_rateio_ad_mn;
            vn_soma_ajuste_base_icms_mn := vn_soma_ajuste_base_icms_mn + vn_rateio_ajuste_base_icms_mn;

            IF (tb_ivc_lin_ad(ad).taxa_mn > 0) THEN
              --  vn_rateio_ad_m := tb_ivc_lin_ad(ad).valor_mn / tb_ivc_lin_ad(ad).taxa_mn;
              vn_rateio_ad_m := vn_rateio_ad_mn / tb_ivc_lin_ad(ad).taxa_mn;
              vn_rateio_ajuste_base_icms_m := vn_rateio_ajuste_base_icms_mn / tb_ivc_lin_ad(ad).taxa_mn;
            ELSE
              vn_rateio_ad_m := 0;
              vn_rateio_ajuste_base_icms_m := 0;
            END IF;

            vb_achou_adicao := FALSE;

            IF (vb_primeira_vez) THEN
              vb_primeira_vez  := FALSE;
            ELSE
              FOR adi IN 1..vn_ultima_adi_ad LOOP
                IF (
                     (ptb_ad_adi(adi).declaracao_adi_id = tb_dcl_lin(dcl).declaracao_adi_id)
                     AND
                     (ptb_ad_adi(adi).acres_ded_id = tb_ivc_lin_ad(ad).acres_ded_id)
                     AND
                     (ptb_ad_adi(adi).moeda_id = tb_ivc_lin_ad(ad).moeda_id)
                   )
                     THEN
                  vb_achou_adicao := TRUE;
                  ptb_ad_adi(adi).valor_m  := Round(ptb_ad_adi(adi).valor_m  + vn_rateio_ad_m,2);
                  ptb_ad_adi(adi).valor_mn := Round(ptb_ad_adi(adi).valor_mn + vn_rateio_ad_mn,2);
                  ptb_ad_adi(adi).valor_ajuste_base_icms_m  := ptb_ad_adi(adi).valor_ajuste_base_icms_m  + vn_rateio_ajuste_base_icms_m;
                  ptb_ad_adi(adi).valor_ajuste_base_icms_mn := ptb_ad_adi(adi).valor_ajuste_base_icms_mn + vn_rateio_ajuste_base_icms_mn;
                END IF;
              END LOOP;

            END IF;
          vc_step_error := 'depois loop1 tb_dcl_lin.count['||tb_dcl_lin.count||'] dcl['||dcl||'] tb_ivc_lin_ad.count['||tb_ivc_lin_ad.count||'] ad['||ad||']';
            IF (not vb_achou_adicao) THEN
              vn_ultima_adi_ad                              := vn_ultima_adi_ad + 1;
              ptb_ad_adi(vn_ultima_adi_ad).declaracao_adi_id := tb_dcl_lin(dcl).declaracao_adi_id;
              ptb_ad_adi(vn_ultima_adi_ad).tp_acres_ded      := tb_ivc_lin_ad(ad).tp_acres_ded;
              ptb_ad_adi(vn_ultima_adi_ad).acres_ded_id      := tb_ivc_lin_ad(ad).acres_ded_id;
              ptb_ad_adi(vn_ultima_adi_ad).moeda_id          := tb_ivc_lin_ad(ad).moeda_id;
              ptb_ad_adi(vn_ultima_adi_ad).valor_m           := Round(vn_rateio_ad_m,2);
              ptb_ad_adi(vn_ultima_adi_ad).valor_mn          := Round(vn_rateio_ad_mn,2);
              ptb_ad_adi(vn_ultima_adi_ad).valor_ajuste_base_icms_m  := vn_rateio_ajuste_base_icms_m;
              ptb_ad_adi(vn_ultima_adi_ad).valor_ajuste_base_icms_mn := vn_rateio_ajuste_base_icms_mn;
            END IF;
          END IF;
        END LOOP;  --- declaracao
      vc_step_error := 'depois loop2';
      END LOOP;  --- acresded
    vc_step_error := 'fim';
--    cmx_prc_teste_Execucao ('vn_ultima_adi_ad['||vn_ultima_adi_ad||'] ptb_ad_adi.count['||ptb_ad_adi.count||'] ptb_ad_adi.last['||ptb_ad_adi.last||']', 9988);
    EXCEPTION
      WHEN others THEN
      prc_gera_log_erros ('Erro ao carregar o acréscimo/dedução da adição['||vc_step_error||']: ' || sqlerrm, 'E', 'D');
    END imp_carrega_ad_adicao_dcl;

  -- ***********************************************************************
  -- Esta procedure ira buscar todas as linhas de mercadoria das invoices e
  -- ratear o valor dos acréscimos e deduções do valor aduaneiro do embarque.
  -- ***********************************************************************
  PROCEDURE imp_prc_processa_acresded (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER, pn_declaracao_id NUMBER, pd_data_totalizar DATE) IS
    vb_rateia_linha      BOOLEAN := TRUE;
    vn_auxiliar          NUMBER  := 0;
    vn_ind_acresded      NUMBER  := 0;
    vn_vrt_acresded_mfob NUMBER  := 0;
    vn_vrt_ajuste_mfob   NUMBER  := 0;
    vn_vrt_acresded_m    NUMBER  := 0;
    vn_vrt_acresded_us   NUMBER  := 0;
    vn_vrt_acresded_mn   NUMBER  := 0;
    vn_taxa_mn           NUMBER  := 0;
    vn_taxa_us           NUMBER  := 0;
    vn_ultima_linha      NUMBER  := 0;
    vn_soma_acresded_m   NUMBER  := 0;
    vn_ivc_anterior_id   NUMBER  := 0;
    vn_ivcad             NUMBER  := 0;
    vn_vrt_fob_ivc       NUMBER  := 0;
    vn_pesoliq_ivc       NUMBER  := 0;
    vc_tp_acresded       VARCHAR2(1) := null;
    vn_valor_invoices    NUMBER := 0;
    vn_valor_invoices_ajuste NUMBER := 0;
    vc_error             VARCHAR2(200) := NULL;
    tb_ad_adi            tb_adi_acresded;

    CURSOR cur_embarque_ad IS
      SELECT iead.embarque_ad_id
            , iead.acres_ded_id
            , iead.moeda_id
            , iead.abrangencia
            , iead.valor_m
            , iead.valor_mn
            , iead.valor_ajuste_base_icms_m
            , iead.valor_ajuste_base_icms_mn
            , ct.tipo
            , ct.auxiliar1 tipo_rateio
        FROM  imp_embarques_ad iead
            , cmx_tabelas      ct
       WHERE iead.embarque_id = pn_embarque_id
         AND ct.tabela_id     = iead.acres_ded_id
       FOR UPDATE OF iead.valor_mn;

    CURSOR cur_embarque_ad_invoice( pn_embarque_ad_id NUMBER ) IS
      SELECT ieadi.invoice_id
           , ieadi.valor
           , ieadi.valor_ajuste_base_icms
        FROM imp_embarques_ad_invoice ieadi
       WHERE ieadi.embarque_ad_id = pn_embarque_ad_id;

    CURSOR cur_embarques_ad_lin(pn_embarque_ad_id NUMBER) IS
      SELECT invoice_lin_id
        FROM imp_embarques_ad_lin
      WHERE embarque_ad_id = pn_embarque_ad_id;

    CURSOR cur_declaracoes_lin_nac IS
      SELECT idl.declaracao_lin_id
           , idl.declaracao_adi_id
           , idl.invoice_lin_id
           , idl.invoice_id
           , iea.moeda_id
           , iea.embarque_ad_id
           , decode(ctt.tipo,'119','A','D') tp_acres_ded
           , iea.acres_ded_id
           , ((iial.valor_m / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde) valor_m
		       , (( (iial.valor_ajuste_base_icms_m + nvl (valor_m_emb_retornavel, 0)) / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde) valor_ajuste_base_icms_m
		         , idl.qtde qtde_invoice -- Verificar qual quantidade devemos jogar aqui
        FROM imp_declaracoes_lin  idl
           , imp_declaracoes_lin  idlda
           , imp_invoices_ad_lin  iial
           , imp_invoices_lin     iil
           , imp_embarques_ad     iea
           , cmx_tabelas          ctt
       WHERE idl.declaracao_id     = pn_declaracao_id
         AND idlda.declaracao_lin_id   = idl.da_lin_id
         AND iial.invoice_lin_id   = idlda.invoice_lin_id
         AND iil.invoice_lin_id    = iial.invoice_lin_id
         AND iea.embarque_ad_id    = iial.embarque_ad_id
         AND ctt.tabela_id         = iea.acres_ded_id
    ORDER BY idl.declaracao_adi_id
           , decode(ctt.tipo,'119','A','D')
           , iea.acres_ded_id;

  BEGIN

    /* Zerando os acres/deduções das invoices */
    FOR ivc IN 1..vn_global_ivc_lin LOOP
      tb_ivc_lin(ivc).vrt_acres_m  := 0;
      tb_ivc_lin(ivc).vrt_acres_mn := 0;
      tb_ivc_lin(ivc).vrt_acres_us := 0;
      tb_ivc_lin(ivc).vrt_ded_m    := 0;
      tb_ivc_lin(ivc).vrt_ded_mn   := 0;
      tb_ivc_lin(ivc).vrt_ded_us   := 0;
      tb_ivc_lin(ivc).vrt_ajuste_base_icms_m  := 0;
      tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn := 0;
      tb_ivc_lin(ivc).vrt_ajuste_base_icms_us := 0;

    END LOOP;

    -- Rateando também para Nacionalização de Admissão Temporaria
    -- Customização UHK
    IF (pn_tp_declaracao < /*13*/15 OR vc_global_nac_sem_admissao = 'S' ) THEN

      vc_error := 'Abrindo cursor acres/ded do embarque';
      /* Identificando os acres/ded lançados no embarque */
      FOR ad IN cur_embarque_ad LOOP

        vc_error := 'Buscando taxa de conversão';
        /* calculando o valor do acres/ded em reais */
        imp_prc_busca_taxa_conversao (ad.moeda_id,
                                      pd_data_totalizar,
                                      vn_taxa_mn,
                                      vn_taxa_us,
                                      'Acres./Ded.');

        /* atualizando a tabela */
        UPDATE imp_embarques_ad
           SET valor_mn = nvl(valor_m * vn_taxa_mn,0)
           , valor_ajuste_base_icms_mn = nvl(valor_ajuste_base_icms_m * vn_taxa_mn,0)
         WHERE CURRENT OF cur_embarque_ad;

        /* Identificando as linhas de invoice que receberam o rateio
           Devemos lembrar que a opção invoice da tela pode conter um
           valor menor que o valor do acrescimo/dedução, portanto podemos
           efetuar dois rateios.
        */
        IF (ad.abrangencia = 'E') THEN

          vn_valor_invoices := 0;
          vn_valor_invoices_ajuste := 0;
          vc_error := 'Abrindo cursor dos acres/ded por invoice';
          FOR i IN cur_embarque_ad_invoice(ad.embarque_ad_id) LOOP

            vn_valor_invoices := vn_valor_invoices + i.valor;
            vn_valor_invoices_ajuste := vn_valor_invoices_ajuste + nvl (i.valor_ajuste_base_icms, 0);

            vc_error := 'Carregando linhas por invoice';
            /* popular tabela */
            imp_prc_tmp_rateio_acresded( 'POR INVOICE'
                                       , i.invoice_id
                                       , ad.embarque_ad_id
                                       , pn_embarque_id
                                       );

            vc_error := 'Rateando linhas por invoice';
            /* efetua rateio */
            imp_prc_rateio_acres_ded( ad.tipo_rateio
                                    , vn_taxa_mn
                                    , vn_taxa_us
                                    , i.valor
                                    , ad.tipo
                                    , ad.embarque_ad_id
                                    , ad.acres_ded_id
                                    , ad.moeda_id
                                    , i.valor_ajuste_base_icms
                                    , pd_data_totalizar
                                    );

          END LOOP;

          /* Se sobrar saldo rateio para o resto das linhas do embarque */
          IF ( ( ad.valor_m - vn_valor_invoices) > 0 ) THEN

            vc_error := 'Carregando linhas por embarque';
            /* popular tabela com linhas de invoices não selecionadas */
            imp_prc_tmp_rateio_acresded( 'POR EMBARQUE'
                                       , NULL
                                       , ad.embarque_ad_id
                                       , pn_embarque_id
                                       );


            vc_error := 'Rateando linhas por embarque';
            /* efetua rateio */
            imp_prc_rateio_acres_ded( ad.tipo_rateio
                                    , vn_taxa_mn
                                    , vn_taxa_us
                                    , (ad.valor_m - vn_valor_invoices)
                                    , ad.tipo
                                    , ad.embarque_ad_id
                                    , ad.acres_ded_id
                                    , ad.moeda_id
                                    , (ad.valor_ajuste_base_icms_m - vn_valor_invoices_ajuste)
                                    , pd_data_totalizar
                                    );

          END IF;

        ELSE

          vc_error := 'Carregando linhas por item';
          /* popular tabela com linhas de invoices não selecionadas */
          imp_prc_tmp_rateio_acresded( 'POR ITEM'
                                     , NULL
                                     , ad.embarque_ad_id
                                     , pn_embarque_id
                                     );

          vc_error := 'Rateando linhas por item';
          /* efetua rateio */
          imp_prc_rateio_acres_ded( ad.tipo_rateio
                                  , vn_taxa_mn
                                  , vn_taxa_us
                                  , ad.valor_m
                                  , ad.tipo
                                  , ad.embarque_ad_id
                                  , ad.acres_ded_id
                                  , ad.moeda_id
                                  , ad.valor_ajuste_base_icms_m
                                  , pd_data_totalizar
                                  );
        END IF;

    --    cmx_prc_teste_execucao ('Ajustando 0.01 ['||ad.acres_ded_id||']',9988);
        -- ajustar 0.01 para cada adição
        -- carregar tabela de acrescimos por adição a partir das linhas
        IF pn_tp_declaracao < 13  OR (pn_tp_declaracao IN (13, 14) OR vc_global_nac_sem_admissao = 'S') THEN
          imp_carrega_ad_adicao_dcl (tb_ad_adi);
        ELSE
          imp_carrega_ad_adicao_dcl_nac (tb_ad_adi);
        END IF;

        prc_tratar_adicoes_zeradas (tb_ad_adi, ad.acres_ded_id, vn_taxa_mn);

      END LOOP;

    ELSE  -- NACIONALIZACAO

      FOR ad IN cur_declaracoes_lin_nac LOOP
        imp_prc_busca_taxa_conversao (ad.moeda_id,
                                      pd_data_totalizar,
                                      vn_taxa_mn,
                                      vn_taxa_us,
                                      'Acres./Ded.');

        vn_global_ivc_ad_lin := vn_global_ivc_ad_lin + 1;

        tb_ivc_lin_ad(vn_global_ivc_ad_lin).embarque_ad_id    := ad.embarque_ad_id;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).declaracao_lin_id := ad.declaracao_lin_id;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).declaracao_adi_id := ad.declaracao_adi_id;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).tp_acres_ded      := ad.tp_acres_ded;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).acres_ded_id      := ad.acres_ded_id;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).moeda_id          := ad.moeda_id;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).taxa_mn           := vn_taxa_mn;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_m           := ad.valor_m;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_mn          := ad.valor_m * vn_taxa_mn;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_us          := ad.valor_m * vn_taxa_us;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).invoice_lin_id    := ad.invoice_lin_id;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).qtde_invoice      := ad.qtde_invoice;
        tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_mn          := ad.valor_ajuste_base_icms_m * vn_taxa_mn;

        FOR ivc IN 1..vn_global_ivc_lin LOOP
          IF tb_ivc_lin(ivc).invoice_lin_id = ad.invoice_lin_id THEN
            IF nvl(tb_ivc_lin(ivc).taxa_mn_fob,0) > 0 THEN
              vn_vrt_acresded_mfob := nvl(tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_mn / tb_ivc_lin(ivc).taxa_mn_fob,0);
              vn_vrt_ajuste_mfob := nvl(tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_mn / tb_ivc_lin(ivc).taxa_mn_fob,0);
            ELSE
              prc_gera_log_erros ('Taxa de conversão da moeda da invoice não encontrada.', 'E', 'A');
              vn_vrt_acresded_mfob := 0;
              vn_vrt_ajuste_mfob := 0;
            END IF;
            IF (ad.tp_acres_ded = 'A') THEN
              tb_ivc_lin(ivc).vrt_acres_m  := tb_ivc_lin(ivc).vrt_acres_m  + vn_vrt_acresded_mfob;
              tb_ivc_lin(ivc).vrt_acres_mn := tb_ivc_lin(ivc).vrt_acres_mn + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_mn;
              tb_ivc_lin(ivc).vrt_acres_us := tb_ivc_lin(ivc).vrt_acres_us + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_us;

              tb_ivc_lin(ivc).vrt_ajuste_base_icms_m  := tb_ivc_lin(ivc).vrt_ajuste_base_icms_m  + vn_vrt_ajuste_mfob                                            * -1;
              tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn := tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_mn * -1;
              tb_ivc_lin(ivc).vrt_ajuste_base_icms_us := tb_ivc_lin(ivc).vrt_ajuste_base_icms_us + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_us * -1;

            ELSE
              tb_ivc_lin(ivc).vrt_ded_m    := tb_ivc_lin(ivc).vrt_ded_m    + vn_vrt_acresded_mfob;
              tb_ivc_lin(ivc).vrt_ded_mn   := tb_ivc_lin(ivc).vrt_ded_mn   + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_mn;
              tb_ivc_lin(ivc).vrt_ded_us   := tb_ivc_lin(ivc).vrt_ded_us   + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_us;
              tb_ivc_lin(ivc).vrt_ajuste_base_icms_m  := tb_ivc_lin(ivc).vrt_ajuste_base_icms_m  + vn_vrt_ajuste_mfob;
              tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn := tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_mn;
              tb_ivc_lin(ivc).vrt_ajuste_base_icms_us := tb_ivc_lin(ivc).vrt_ajuste_base_icms_us + tb_ivc_lin_ad(vn_global_ivc_ad_lin).valor_ajuste_base_icms_us;
            END IF;
          END IF;
        END LOOP;
      END LOOP;
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no calculo dos acréscimos/deduções: ' || vc_error ||sqlerrm, 'E', 'A');
  END imp_prc_processa_acresded;
  -- ***********************************************************************

  -- ***********************************************************************
  -- Calculando VMLE e VMLC...
  -- ***********************************************************************
  PROCEDURE imp_prc_calcula_vmle (pn_embarque_id NUMBER) IS

    vn_vmlc_li_mn NUMBER := 0;

  BEGIN
    FOR ivc IN 1..vn_global_ivc_lin LOOP
      -- Quando LI não devemos somar acrescimos nem deduções
      tb_ivc_lin(ivc).vmle_li_mn := nvl (tb_ivc_lin(ivc).vrt_fob_mn   , 0)
                                  + nvl (tb_ivc_lin(ivc).vrt_dspfob_mn, 0);

      IF (tb_ivc_lin(ivc).incoterm IN ('CIP', 'CPT', 'DDU', 'DAT', 'DAP')) THEN
        tb_ivc_lin(ivc).vmle_mn    := nvl (tb_ivc_lin(ivc).vrt_fob_mn    , 0)
                                    + nvl (tb_ivc_lin(ivc).vrt_dspfob_mn , 0)
                                    + nvl (tb_ivc_lin(ivc).vrt_acres_mn  , 0)
                                    - (nvl (tb_ivc_lin(ivc).vrt_ded_mn, 0) - nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn, 0))
                                    + nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0); -- para casos <> DDU, este campo sempre vai estar zerado!;
      ELSE
        tb_ivc_lin(ivc).vmle_mn    := nvl (tb_ivc_lin(ivc).vrt_fob_mn    , 0)
                                    + nvl (tb_ivc_lin(ivc).vrt_dspfob_mn , 0)
                                    + nvl (tb_ivc_lin(ivc).vrt_acres_mn  , 0)
                                    - nvl (tb_ivc_lin(ivc).vrt_ded_mn    , 0)
                                    + nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0); -- para casos <> DDU, este campo sempre vai estar zerado!;
      END IF;

      tb_ivc_lin(ivc).vmlc_mn    := nvl (tb_ivc_lin(ivc).vrt_fob_mn   , 0)
                                  + nvl (tb_ivc_lin(ivc).vrt_dspfob_mn, 0);

      vn_vmlc_li_mn              := nvl (tb_ivc_lin(ivc).vrt_fob_mn   , 0)
                                  + nvl (tb_ivc_lin(ivc).vrt_dspfob_mn, 0);

      IF (instr (tb_ivc_lin(ivc).tprateio_incoterm, 'F') <> 0) THEN
        IF (tb_ivc_lin(ivc).incoterm = 'DAF') THEN
          vn_vmlc_li_mn           := vn_vmlc_li_mn           + (nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0) * tb_ivc_lin(ivc).taxa_mn_fob);
          tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + (nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0) * tb_ivc_lin(ivc).taxa_mn_fob);
        ELSE
          /* CASO NÃO EXISTA CONHECIMENTO E O FRETE ESTA EMBUTIDO NA INVOICE, DEVEMOS USAR O DA INVOICE NA LI */
          IF( (nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0) > 0) AND (nvl (tb_ivc_lin(ivc).vrt_fr_total_m, 0) = 0 ) ) THEN
            vn_vmlc_li_mn           := vn_vmlc_li_mn           + (nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0) * tb_ivc_lin(ivc).taxa_mn_fob);
            tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + (nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0) * tb_ivc_lin(ivc).taxa_mn_fob);
          ELSE
            vn_vmlc_li_mn           := vn_vmlc_li_mn           + nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0);
            tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0);

            /* caso o frete esteja constando no Incoterm e tenha-se preenchido o campo collect no conhecimento ajustamos o vmle da LI com a diferença
               entre o prepaid e o collect
            */
            IF( nvl (tb_ivc_lin(ivc).vrt_fr_collect_mn, 0) > 0 ) THEN
              tb_ivc_lin(ivc).vmle_li_mn := tb_ivc_lin(ivc).vmle_li_mn + nvl (tb_ivc_lin(ivc).vrt_fr_collect_mn, 0);
            END IF;
          END IF;
        END IF;
      END IF;

      IF (instr (tb_ivc_lin(ivc).tprateio_incoterm, 'S') <> 0) THEN
        vn_vmlc_li_mn           := vn_vmlc_li_mn           + nvl (tb_ivc_lin(ivc).vrt_sg_mn, 0);
        tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + nvl (tb_ivc_lin(ivc).vrt_sg_mn, 0);
      END IF;

      IF (instr (tb_ivc_lin(ivc).tprateio_incoterm, 'N') <> 0) THEN
        vn_vmlc_li_mn           := vn_vmlc_li_mn           + nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);
        tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);
      END IF;

      IF (tb_ivc_lin(ivc).taxa_mn_fob > 0) THEN
        tb_ivc_lin(ivc).vmle_m    := tb_ivc_lin(ivc).vmle_mn    / tb_ivc_lin(ivc).taxa_mn_fob;
        tb_ivc_lin(ivc).vmle_li_m := tb_ivc_lin(ivc).vmle_li_mn / tb_ivc_lin(ivc).taxa_mn_fob;
        tb_ivc_lin(ivc).vmlc_m    := tb_ivc_lin(ivc).vmlc_mn    / tb_ivc_lin(ivc).taxa_mn_fob;
        tb_ivc_lin(ivc).vmlc_li_m := vn_vmlc_li_mn              / tb_ivc_lin(ivc).taxa_mn_fob;
      END IF;

      tb_ivc_lin(ivc).vmle_us   := tb_ivc_lin(ivc).vmle_m * tb_ivc_lin(ivc).taxa_us_fob;
      vn_global_vrt_vmle_ebq_mn := vn_global_vrt_vmle_ebq_mn + tb_ivc_lin(ivc).vmle_mn;
    END LOOP;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no cálculo do VMLE: ' || sqlerrm, 'E', 'A');
  END imp_prc_calcula_vmle;

  -- ***********************************************************************
  -- Recalculando VMLC nas linhas da invoice para casos com seguro embutido
  -- ***********************************************************************
  PROCEDURE imp_prc_recalcula_vmlc IS
    CURSOR cur_vrt_ivc_por_tipo (pn_invoice_id NUMBER, pc_tp_valor varchar2) IS
      SELECT nvl (sum (nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * preco_unitario_m, 0)), 0)
        FROM imp_invoices_lin  iil,
             cmx_tabelas       ct
       WHERE iil.invoice_id = pn_invoice_id
         AND ct.tabela_id   = iil.tp_linha_id
         AND ct.auxiliar1   = pc_tp_valor;

    vn_vrt_sgivc  NUMBER := 0;
    vn_vmlc_li_mn NUMBER := 0;

  BEGIN
    FOR ivc IN 1..vn_global_ivc_lin LOOP
      vn_vmlc_li_mn := 0;

      OPEN  cur_vrt_ivc_por_tipo( tb_ivc_lin(ivc).invoice_id, 'S' );
      FETCH cur_vrt_ivc_por_tipo INTO vn_vrt_sgivc;
      CLOSE cur_vrt_ivc_por_tipo;

      IF     (instr (tb_ivc_lin(ivc).tprateio_incoterm, 'S') <> 0)
         AND (tb_ivc_lin(ivc).flag_sg_embutido = 'S')
         AND (vn_vrt_sgivc > 0)
      THEN
        tb_ivc_lin(ivc).vmlc_mn :=  nvl (tb_ivc_lin(ivc).vrt_fob_mn   , 0)
                                  + nvl (tb_ivc_lin(ivc).vrt_dspfob_mn, 0);

        vn_vmlc_li_mn           := nvl (tb_ivc_lin(ivc).vrt_fob_mn   , 0)
                                  + nvl (tb_ivc_lin(ivc).vrt_dspfob_mn, 0);

        IF (instr (tb_ivc_lin(ivc).tprateio_incoterm, 'F') <> 0) THEN
          IF (tb_ivc_lin(ivc).incoterm = 'DAF') THEN
            vn_vmlc_li_mn           := vn_vmlc_li_mn           + (nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0) * tb_ivc_lin(ivc).taxa_mn_fob);
            tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + (nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0) * tb_ivc_lin(ivc).taxa_mn_fob);
          ELSE
            vn_vmlc_li_mn           := vn_vmlc_li_mn           + nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0);
            tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + nvl (tb_ivc_lin(ivc).vrt_fr_total_mn, 0);
          END IF;
        END IF;

        IF (instr (tb_ivc_lin(ivc).tprateio_incoterm, 'S') <> 0) THEN
          vn_vmlc_li_mn           := vn_vmlc_li_mn           + nvl (tb_ivc_lin(ivc).vrt_sg_mn, 0);
          tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + nvl (tb_ivc_lin(ivc).vrt_sg_mn, 0);
        END IF;

        IF (instr (tb_ivc_lin(ivc).tprateio_incoterm, 'N') <> 0) THEN
          vn_vmlc_li_mn           := vn_vmlc_li_mn           + nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);
          tb_ivc_lin(ivc).vmlc_mn := tb_ivc_lin(ivc).vmlc_mn + nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn, 0);
        END IF;

        IF (tb_ivc_lin(ivc).taxa_mn_fob > 0) THEN
          tb_ivc_lin(ivc).vmlc_m    := tb_ivc_lin(ivc).vmlc_mn / tb_ivc_lin(ivc).taxa_mn_fob;
          tb_ivc_lin(ivc).vmlc_li_m := vn_vmlc_li_mn           / tb_ivc_lin(ivc).taxa_mn_fob;
        END IF;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no recalculo do VMLC das linhas da IVC para incoterms CIF, CIP, DES, DEQ, DDU, DDP: ' || sqlerrm, 'E', 'A');
  END imp_prc_recalcula_vmlc;

  -- ***********************************************************************
  -- Verificando se o embarque possuir somente invoices CFR/CIF ou qualquer
  -- condicao de venda onde o frete esteja no preco da condicao de venda
  -- e a soma dos fretes destacados das invoices for diferente do frete do
  -- conhecimento deve ser mostrada uma mensagem de alerta.
  -- ***********************************************************************
  PROCEDURE imp_prc_checa_frete_ivc_vs_bl ( pn_embarque_id    NUMBER
                                          , vd_data_conversao DATE   ) IS

    /* Acesso ao conhecimento para saber a necessidade de buscar a conversão.
       Fiz cursor separado porque o cursor com as taxas gera erro quando não tem
       frete internacional.
       * 08 - TUBO CONDUTOR
       * 09 - MEIOS PROPRIOS
       * 10 - ENTRADA FICTA
    */
    CURSOR cur_entrada_ficta ( pn_cur_embarque_id NUMBER )IS
      SELECT cmx_pkg_tabelas.codigo (ic.via_transporte_id) via_transporte
       FROM imp_conhecimentos ic
          , imp_embarques     ie
      WHERE ie.embarque_id = pn_cur_embarque_id
        AND ie.conhec_id   = ic.conhec_id ;

    CURSOR cur_embarque_nac IS
      SELECT ie.embarque_id
	      FROM imp_embarques       ie
           , imp_declaracoes     id_da
           , imp_declaracoes_lin idl_da
           , imp_declaracoes_lin idl
           , imp_declaracoes     id
	    WHERE id.embarque_id       = pn_embarque_id
        AND id.declaracao_id     = idl.declaracao_id
        AND idl.da_lin_id        = idl_da.declaracao_lin_id
        AND idl_da.declaracao_id = id_da.declaracao_id
        AND id_da.embarque_id    = ie.embarque_id;

    CURSOR cur_via_di_unica IS
      SELECT cmx_pkg_tabelas.codigo (con.via_transporte_id) via_transporte
        FROM imp_conhecimentos con
       WHERE con.conhec_id IN (SELECT re.conhec_id
                                 FROM imp_po_remessa re
                                WHERE re.embarque_id = pn_embarque_id
                                  AND re.nr_remessa  = '1');



    CURSOR cur_frete_invoice IS
      SELECT round(SUM( cmx_pkg_taxas.fnc_converte ( nvl(imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * iil.preco_unitario_m,0)
                                                   , ii.moeda_id
                                                   , cmx_pkg_tabelas.tabela_id ('906','USD')
                                                   , vd_data_conversao
                                                   , 'FISCAL' )),2) vrt_fr_us_invoice
        FROM imp_invoices_lin  iil
           , imp_invoices      ii
           , cmx_tabelas       ct
       WHERE iil.embarque_id = pn_embarque_id
         AND ii.invoice_id   = iil.invoice_id
         AND ct.tabela_id    = iil.tp_linha_id
         AND ct.auxiliar1    = 'I';

    CURSOR cur_frete_conhecimento IS
      SELECT round(cmx_pkg_taxas.fnc_converte ( nvl (ic.valor_prepaid_m, 0) + nvl (ic.valor_collect_m, 0)
                                              , ic.moeda_id
                                              , cmx_pkg_tabelas.tabela_id ('906','USD')
                                              , vd_data_conversao
                                              , 'FISCAL' ),2) vrt_fr_us_conhecimento
       FROM imp_conhecimentos ic
          , imp_embarques     ie
      WHERE ie.embarque_id = pn_embarque_id
        AND ie.conhec_id   = ic.conhec_id ;


    CURSOR cur_ultima_rem IS
    SELECT Sum(round(cmx_pkg_taxas.fnc_converte ( nvl (ice.valor_prepaid_m, 0) + nvl (ice.valor_collect_m, 0)
                                              , ice.moeda_id
                                              , cmx_pkg_tabelas.tabela_id ('906','USD')
                                              , vd_data_conversao
                                              , 'FISCAL' ),2)) vrt_fr_us_conhecimento
      FROM imp_vw_conhec_ebq ice
     WHERE ice.embarque_id = pn_embarque_id
       AND ultima_remessa = 'S';



    vn_fr_invoice      NUMBER :=0;
    vn_fr_conhecimento NUMBER :=0;

    vr_ultima_rem cur_ultima_rem%ROWTYPE;
    vb_ultima_rem      BOOLEAN;
    vn_embarque_id     NUMBER;

  BEGIN

    IF (Nvl(vc_global_verif_di_unica, '*') <> 'DI_UNICA') THEN

      IF (Nvl(vc_global_verif_di_unica, '*') = 'NAC') THEN

        OPEN cur_embarque_nac;
        FETCH cur_embarque_nac INTO vn_embarque_id;
        CLOSE cur_embarque_nac;

        OPEN  cur_entrada_ficta( vn_embarque_id );
        FETCH cur_entrada_ficta INTO vc_global_via_transporte;
        CLOSE cur_entrada_ficta;

      ELSE

        OPEN  cur_entrada_ficta( pn_embarque_id );
        FETCH cur_entrada_ficta INTO vc_global_via_transporte;
        CLOSE cur_entrada_ficta;

      END IF;

    ELSE
      OPEN  cur_via_di_unica;
      FETCH cur_via_di_unica INTO vc_global_via_transporte;
      CLOSE cur_via_di_unica;

    END IF;

    IF (Nvl(vc_global_via_transporte,'******') NOT IN ('08', '09', '10')) THEN
       OPEN  cur_frete_invoice;
      FETCH cur_frete_invoice INTO vn_fr_invoice;
      CLOSE cur_frete_invoice;

      OPEN  cur_frete_conhecimento;
      FETCH cur_frete_conhecimento INTO vn_fr_conhecimento;
      CLOSE cur_frete_conhecimento;


      IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
        OPEN  cur_ultima_rem;
        FETCH cur_ultima_rem INTO vr_ultima_rem;
        vb_ultima_rem  := cur_ultima_rem%FOUND;
        CLOSE cur_ultima_rem;

        IF vb_ultima_rem THEN
          vn_fr_conhecimento := vr_ultima_rem.vrt_fr_us_conhecimento;
        END IF;

      END IF;


      -- Se houver frete destacado na invoice
      -- verificar se ele bate com o frete do conhecimento
      -- Os valores dos fretes da invoice e do conhecimento foram transformados
      -- para USD para serem comparados.
      IF ( nvl(vn_fr_invoice,0) > 0 ) AND
         ( nvl(vn_fr_conhecimento,0) > 0 ) AND
         ( vn_fr_invoice <> vn_fr_conhecimento )
      THEN
        prc_gera_log_erros ('A soma dos fretes destacados nas invoices é diferente do valor do frete informado no conhecimento. [Frete Invoice(s):  USD '||rtrim(ltrim(to_char(vn_fr_invoice,'999G999G999G990D00')))||'][Frete Conhecimento: USD '||rtrim(ltrim(to_char(vn_fr_conhecimento,'999G999G999G990D00')))||']','A', 'A');
      END IF;
    END IF; -- IF (vc_global_via_transporte NOT IN ('08', '09', '10')) THEN

  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na checagem do frete da(s) invoice(s) contra o conhecimento: ' || sqlerrm, 'E', 'A');
  END imp_prc_checa_frete_ivc_vs_bl;

  -- ***********************************************************************
  -- Verificando se o embarque possuir somente invoices CFR/CIF ou qualquer
  -- condicao de venda onde o frete esteja no preco da condicao de venda
  -- e a soma dos fretes destacados das invoices for diferente do frete do
  -- conhecimento utilizado na nacionalização deve ser mostrada uma
  -- mensagem de alerta. O frete da nacionalização que será comparado é o
  -- frete proporcional ao que está sendo nacionalizado.
  -- ***********************************************************************
  PROCEDURE imp_prc_checa_frete_ivc_vs_da ( pn_embarque_id    NUMBER
                                          , vd_data_conversao DATE) IS
    CURSOR cur_frete_invoice IS
      SELECT round (SUM (cmx_pkg_taxas.fnc_converte ( nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * iil.preco_unitario_m, 0)
                                                    , ii.moeda_id
                                                    , cmx_pkg_tabelas.tabela_id ('906','USD')
                                                    , vd_data_conversao
                                                    , 'FISCAL' )
                                                    )
                   , 2
                   ) vrt_fr_us_invoice
        FROM imp_invoices_lin  iil
           , imp_invoices      ii
           , cmx_tabelas       ct
       WHERE iil.embarque_id = pn_embarque_id
         AND ii.invoice_id   = iil.invoice_id
         AND ct.tabela_id    = iil.tp_linha_id
         AND ct.auxiliar1    = 'I';

    vn_fr_invoice      NUMBER := 0;
    vn_fr_conhecimento NUMBER := 0;
  BEGIN

    OPEN  cur_frete_invoice;
    FETCH cur_frete_invoice INTO vn_fr_invoice;
    CLOSE cur_frete_invoice;

    -- Joga na variável a somatória do frete em dolar (VN_GLOBAL_VRT_FR_TOTAL_US)
    -- A global VN_GLOBAL_VRT_FR_TOTAL_US foi criada e preenchida especialmente para essa verificação
    vn_fr_conhecimento := nvl (vn_global_vrt_fr_total_us, 0);

    -- Se houver frete destacado na invoice, verificar se
    -- ele bate com o frete da declaracao(proporcional)
    -- Os valores dos fretes da invoice e do conhecimento foram
    -- transformados para USD para serem comparados.
    IF  (nvl (vn_fr_invoice     , 0) > 0)
    AND (nvl (vn_fr_conhecimento, 0) > 0)
    --Customização UHK
    AND (Round(vn_fr_invoice, 2) <> Round(vn_fr_conhecimento, 2))
    THEN
      prc_gera_log_erros ('A soma dos fretes destacados nas invoices é diferente do valor do frete informado no conhecimento da DA. [Frete Invoice(s):  USD '||rtrim(ltrim(to_char(vn_fr_invoice,'999G999G999G990D00')))||'][Frete Conhecimento da Admissão: USD '||rtrim(ltrim(to_char(vn_fr_conhecimento,'999G999G999G990D00')))||']','A', 'A');
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na checagem do frete da(s) invoice(s) contra o conhecimento da DA: ' || sqlerrm, 'E', 'A');
  END imp_prc_checa_frete_ivc_vs_da;

  -- ***********************************************************************
  -- Se o embarque possuir invoices com seguro internacional embutido
  -- precisamos checar o rateio do seguro internacional contra o rateio do
  -- seguro informado na invoice. Se eles forem diferentes, o usuario deve
  -- alterar a invoice informando o valor do seguro rateado pelo sistema.
  -- Se essa medida nao for tomada, o SISCOMEX apresentara erro no calculo
  -- do VMLC e o registro da DI nao sera possivel.
  -- ***********************************************************************
  PROCEDURE imp_prc_checa_seguro_ivc_vs_eb ( pn_embarque_id     NUMBER
                                           , vd_data_conversao  DATE
                                           , pn_moeda_seguro_id NUMBER) IS

    CURSOR cur_invoice_num (pn_invoice_id NUMBER) IS
      SELECT invoice_num
        FROM imp_invoices
       WHERE invoice_id = pn_invoice_id;

    vc_invoice_num      imp_invoices.invoice_num%TYPE;
    vn_ivc_anterior_id  NUMBER  := null;
    vn_sg_invoice       NUMBER  := null;
    vn_sg_embarque      NUMBER  := null;
    vb_primeira_vez     BOOLEAN := true;

  BEGIN
    IF (pn_moeda_seguro_id IS NOT null) THEN
      vn_ivc_anterior_id := 0;

      FOR ivc IN 1..vn_global_ivc_lin LOOP
        IF (vb_primeira_vez) THEN
           vn_ivc_anterior_id := tb_ivc_lin(ivc).invoice_id;
           vb_primeira_vez    := false;
        END IF;

        IF (vn_ivc_anterior_id <> tb_ivc_lin(ivc).invoice_id) THEN
          vn_sg_invoice  := round (vn_sg_invoice , 2);
          vn_sg_embarque := round (vn_sg_embarque, 2);

          IF (nvl (vn_sg_invoice, 0) > 0) AND (nvl (vn_sg_embarque, 0) > 0) AND (nvl (vn_sg_invoice, 0) <> nvl (vn_sg_embarque, 0)) THEN
            OPEN  cur_invoice_num (vn_ivc_anterior_id);
            FETCH cur_invoice_num INTO vc_invoice_num;
            CLOSE cur_invoice_num;

            prc_gera_log_erros ('O valor do seguro [' || rtrim(ltrim(to_char(vn_sg_invoice,'999G999G999G990D00'))) || ']' || ' da invoice ' || vc_invoice_num ||
                                ', está diferente do valor do seguro rateado pelo sistema [' || rtrim(ltrim(to_char(vn_sg_embarque,'999G999G999G990D00'))) || ']' ||
                                '. Por favor, acerte o seguro na invoice de acordo com o rateio efetuado. ' ||
                                'Essa diferença gera divergências no VMLC calculado pelo SISCOMEX.'
                               , 'E'
                               , 'A');
          END IF;

          vn_ivc_anterior_id := tb_ivc_lin(ivc).invoice_id;
          vn_sg_invoice      := 0;
          vn_sg_embarque     := 0;
        END IF; -- IF (vn_ivc_anterior_id <> tb_ivc_lin(ivc).invoice_id) THEN

        vn_sg_invoice      := nvl (vn_sg_invoice , 0) + tb_ivc_lin(ivc).vrt_sgivc_m;
        vn_sg_embarque     := nvl (vn_sg_embarque, 0) + cmx_pkg_taxas.fnc_converte ( nvl (tb_ivc_lin(ivc).vrt_sg_m, 0)
                                                                                   , pn_moeda_seguro_id
                                                                                   , tb_ivc_lin(ivc).moeda_fob_id
                                                                                   , vd_data_conversao
                                                                                   , 'FISCAL');
      END LOOP;

      vn_sg_invoice  := round (vn_sg_invoice , 2);
      vn_sg_embarque := round (vn_sg_embarque, 2);

      IF (nvl (vn_sg_invoice, 0) > 0) AND (nvl (vn_sg_embarque, 0) > 0) AND (nvl (vn_sg_invoice, 0) <> nvl (vn_sg_embarque, 0)) THEN
        OPEN  cur_invoice_num (vn_ivc_anterior_id);
        FETCH cur_invoice_num INTO vc_invoice_num;
        CLOSE cur_invoice_num;

        prc_gera_log_erros ('O valor do seguro [' || rtrim(ltrim(to_char(vn_sg_invoice,'999G999G999G990D00'))) || ']' || ' da invoice ' || vc_invoice_num ||
                            ', está diferente do valor do seguro rateado pelo sistema [' || rtrim(ltrim(to_char(vn_sg_embarque,'999G999G999G990D00'))) || ']' ||
                            '. Por favor, acerte o seguro na invoice de acordo com o rateio efetuado. ' ||
                            'Essa diferença gera divergências no VMLC calculado pelo SISCOMEX.'
                           , 'E'
                           , 'A');
      END IF;
    END IF; -- IF (pn_moeda_seguro_id IS NOT null) THEN
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na checagem do seguro da(s) invoice(s) contra o seguro rateado do embarque para a(s) invoice(s): ' || sqlerrm, 'E', 'A');
  END imp_prc_checa_seguro_ivc_vs_eb;

  -- ***********************************************************************
  -- Rotina para gravação de numerarios
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_rateio_numerario (pn_embarque_id NUMBER) IS
      CURSOR cur_icms_pc_existe (pn_invoice_lin_id NUMBER, pn_numerario_dsp_id NUMBER, pn_declaracao_lin_id NUMBER) IS
        SELECT invoice_lin_dsp_dcl_icms_id
          FROM imp_invoices_lin_dsp_dcl_icms
         WHERE invoice_lin_id    = pn_invoice_lin_id
           AND numerario_dsp_id  = pn_numerario_dsp_id
           AND declaracao_lin_id = pn_declaracao_lin_id;

    CURSOR cur_existe_ivc_lin_dsp (pn_invoice_lin_id NUMBER, pn_numerario_dsp_id NUMBER) IS
      SELECT invoice_id
        FROM imp_invoices_lin_dsp
       WHERE invoice_lin_id   = pn_invoice_lin_id
         AND numerario_dsp_id = pn_numerario_dsp_id;

    vb_existe_icms_pc      BOOLEAN := false;
    vb_existe_ivc_lin_dsp  BOOLEAN := false;
    vn_invoice_id          NUMBER;
    vn_id_icms_pc          NUMBER;
    vn_numerario_dsp_id    NUMBER;

  BEGIN
    IF (vn_global_ivc_lin_dsp > 0) THEN
      DELETE FROM imp_invoices_lin_dsp
      WHERE embarque_id  = pn_embarque_id;
    END IF;

    IF (vn_global_dcl_lin_dsp > 0) THEN
      DELETE FROM imp_declaracoes_lin_dsp dsp
       WHERE declaracao_lin_id IN (SELECT declaracao_lin_id
                                     FROM imp_declaracoes_lin idl
                                        , imp_declaracoes id
                                    WHERE idl.declaracao_id=id.declaracao_id
                                      AND id.embarque_id  = pn_embarque_id); /************* deletar da imp_declaracoes_lin_dsp ************/
    END IF;

    FOR ivcd IN 1..vn_global_ivc_lin_dsp LOOP
      vn_numerario_dsp_id := 0;

      BEGIN
        SELECT numerario_dsp_id
          INTO vn_numerario_dsp_id
          FROM imp_numerarios_dsp
         WHERE numerario_dsp_id = tb_ivc_lin_dsp(ivcd).numerario_dsp_id;
      EXCEPTION
      WHEN No_Data_Found THEN
        vn_numerario_dsp_id := NULL;
      END;

      IF (tb_ivc_lin_dsp(ivcd).valor_mn <> 0) AND (Nvl(vn_numerario_dsp_id, 0) <> 0) THEN
        INSERT INTO imp_invoices_lin_dsp
                    (
                      invoice_id
                    , invoice_lin_id
                    , embarque_id
                    , numerario_dsp_id
                    , valor_mn
                    , numerario_id
                    , basecalc_icms
                    , valor_icms
                    , basecalc_icms_pro_emprego
                    , valor_icms_pro_emprego
                    , basecalc_pis_cofins
                    , valor_pis
                    , valor_cofins
                    , creation_date
                    , created_by
                    , last_update_date
                    , last_updated_by
                    , grupo_acesso_id
                    , valor_ajuste
                    , qtde_linha_ivc
                    , valor_fecp
                    )
              VALUES(
                      tb_ivc_lin_dsp(ivcd).invoice_id
                    , tb_ivc_lin_dsp(ivcd).invoice_lin_id
                    , tb_ivc_lin_dsp(ivcd).embarque_id
                    , tb_ivc_lin_dsp(ivcd).numerario_dsp_id
                    , tb_ivc_lin_dsp(ivcd).valor_mn
                    , tb_ivc_lin_dsp(ivcd).numerario_id
                    , tb_ivc_lin_dsp(ivcd).basecalc_icms
                    , tb_ivc_lin_dsp(ivcd).valor_icms
                    , tb_ivc_lin_dsp(ivcd).basecalc_icms_pro_emprego
                    , tb_ivc_lin_dsp(ivcd).valor_icms_pro_emprego
                    , tb_ivc_lin_dsp(ivcd).basecalc_pis_cofins
                    , tb_ivc_lin_dsp(ivcd).valor_pis
                    , tb_ivc_lin_dsp(ivcd).valor_cofins
                    , vd_global_creation_date
                    , vn_global_created_by
                    , vd_global_last_update_date
                    , vn_global_last_updated_by
                    , vn_global_grupo_acesso_id
                    , tb_ivc_lin_dsp(ivcd).valor_ajuste
                    , tb_ivc_lin_dsp(ivcd).qtde_linha_ivc
                    , tb_ivc_lin_dsp(ivcd).valor_fecp
                    );
      END IF; -- IF (tb_ivc_lin_dsp(ivcd).valor_mn <> 0) THEN
    END LOOP;

    /********** para nacionalizacoes gravar na imp_declaracoes_lin_dsp **********/
    FOR dcld IN 1..vn_global_dcl_lin_dsp LOOP

      vn_numerario_dsp_id := 0;

      SELECT numerario_dsp_id
        INTO vn_numerario_dsp_id
        FROM imp_numerarios_dsp
       WHERE numerario_dsp_id = tb_ivc_lin_dsp(dcld).numerario_dsp_id;

      IF (tb_ivc_lin_dsp(dcld).valor_mn <> 0) AND (Nvl(vn_numerario_dsp_id, 0) <> 0) THEN
        INSERT INTO imp_declaracoes_lin_dsp
                    (
                      declaracao_lin_id
                    , numerario_dsp_id
                    , valor_mn
                    , numerario_id
                    , creation_date
                    , created_by
                    , last_update_date
                    , last_updated_by
                    , grupo_acesso_id
                    , valor_ajuste
                    , qtde_linha_dcl
                    )
              VALUES(
                      tb_ivc_lin_dsp(dcld).declaracao_lin_id   -- declaracao_lin_id
                    , tb_ivc_lin_dsp(dcld).numerario_dsp_id    -- numerario_dsp_id
                    , tb_ivc_lin_dsp(dcld).valor_mn            -- valor_mn
                    , tb_ivc_lin_dsp(dcld).numerario_id        -- numerario_id
                    , vd_global_creation_date                  -- creation_date
                    , vn_global_created_by                     -- created_by
                    , vd_global_last_update_date               -- last_update_date
                    , vn_global_last_updated_by                -- last_updated_by
                    , vn_global_grupo_acesso_id                -- grupo_acesso_id
                    , tb_ivc_lin_dsp(dcld).valor_ajuste
                    , tb_ivc_lin_dsp(dcld).qtde_linha_dcl
                    );
      END IF;
    END LOOP;

    FOR i IN (SELECT *
                FROM imp_ivc_lin_dsp_dcl_icms_tmp tmp
               WHERE tmp.numerario_id IN (SELECT numerario_id
                                            FROM imp_numerarios_rateio_ebq
                                           WHERE embarque_id = pn_embarque_id)
                 AND EXISTS (SELECT 1
                               FROM imp_invoices_lin_dsp iild
                              WHERE iild.invoice_lin_id   = tmp.invoice_lin_id
                                AND iild.numerario_dsp_id = tmp.numerario_dsp_id))
    LOOP
      vb_existe_ivc_lin_dsp := false;
      vb_existe_icms_pc     := false;

      OPEN  cur_existe_ivc_lin_dsp (i.invoice_lin_id, i.numerario_dsp_id);
      FETCH cur_existe_ivc_lin_dsp INTO vn_invoice_id;
      vb_existe_ivc_lin_dsp := cur_existe_ivc_lin_dsp%FOUND;
      CLOSE cur_existe_ivc_lin_dsp;

      IF (vb_existe_ivc_lin_dsp) THEN
        OPEN  cur_icms_pc_existe (i.invoice_lin_id, i.numerario_dsp_id, i.declaracao_lin_id);
        FETCH cur_icms_pc_existe INTO vn_id_icms_pc;
        vb_existe_icms_pc := cur_icms_pc_existe%FOUND;
        CLOSE cur_icms_pc_existe;

        IF (vb_existe_icms_pc) THEN
          UPDATE imp_invoices_lin_dsp_dcl_icms
             SET basecalc_icms = i.basecalc_icms
               , valor_icms    = i.valor_icms
               , valor_fecp    = i.valor_fecp
           WHERE invoice_lin_id    = i.invoice_lin_id
             AND numerario_dsp_id  = i.numerario_dsp_id
             AND declaracao_lin_id = i.declaracao_lin_id;
        ELSE
          INSERT INTO imp_invoices_lin_dsp_dcl_icms (
             invoice_lin_dsp_dcl_icms_id
           , invoice_lin_id
           , numerario_dsp_id
           , declaracao_lin_id
           , numerario_id
           , basecalc_icms
           , valor_icms
           , valor_fecp
           )
          VALUES (
             /* invoice_lin_dsp_dcl_icms_id */ imp_ivc_lin_dsp_dcl_icms_sq1.nextval
           , /* invoice_lin_id              */ i.invoice_lin_id
           , /* numerario_dsp_id            */ i.numerario_dsp_id
           , /* declaracao_lin_id           */ i.declaracao_lin_id
           , /* numerario_id                */ i.numerario_id
           , /* basecalc_icms               */ i.basecalc_icms
           , /* valor_icms                  */ i.valor_icms
           , /* valor_fecp                  */ i.valor_fecp
          );
        END IF; -- IF (vb_existe_icms_pc) THEN
      END IF; -- IF (vb_existe_ivc_lin_dsp) THEN
    END LOOP; -- FOR i IN (SELECT *

    FOR i IN (SELECT *
                FROM imp_ivc_lin_dsp_dcl_pc_tmp  tmp
               WHERE tmp.numerario_id IN (SELECT numerario_id
                                            FROM imp_numerarios_rateio_ebq
                                           WHERE embarque_id = pn_embarque_id)
                 AND EXISTS (SELECT 1
                               FROM imp_invoices_lin_dsp iild
                              WHERE iild.invoice_lin_id   = tmp.invoice_lin_id
                                AND iild.numerario_dsp_id = tmp.numerario_dsp_id))
    LOOP
      vb_existe_ivc_lin_dsp := false;
      vb_existe_icms_pc     := false;

      OPEN  cur_existe_ivc_lin_dsp (i.invoice_lin_id, i.numerario_dsp_id);
      FETCH cur_existe_ivc_lin_dsp INTO vn_invoice_id;
      vb_existe_ivc_lin_dsp := cur_existe_ivc_lin_dsp%FOUND;
      CLOSE cur_existe_ivc_lin_dsp;

      IF (vb_existe_ivc_lin_dsp) THEN
        OPEN  cur_icms_pc_existe (i.invoice_lin_id, i.numerario_dsp_id, i.declaracao_lin_id);
        FETCH cur_icms_pc_existe INTO vn_id_icms_pc;
        vb_existe_icms_pc := cur_icms_pc_existe%FOUND;
        CLOSE cur_icms_pc_existe;

        IF (vb_existe_icms_pc) THEN
          UPDATE imp_invoices_lin_dsp_dcl_icms
             SET basecalc_pis_cofins = i.basecalc_pis_cofins
               , valor_pis           = i.valor_pis
               , valor_cofins        = i.valor_cofins
           WHERE invoice_lin_id    = i.invoice_lin_id
             AND numerario_dsp_id  = i.numerario_dsp_id
             AND declaracao_lin_id = i.declaracao_lin_id;
        ELSE
          INSERT INTO imp_invoices_lin_dsp_dcl_icms (
             invoice_lin_dsp_dcl_icms_id
           , invoice_lin_id
           , numerario_dsp_id
           , declaracao_lin_id
           , numerario_id
           , basecalc_pis_cofins
           , valor_pis
           , valor_cofins
           )
          VALUES (
             /* invoice_lin_dsp_dcl_icms_id */ imp_ivc_lin_dsp_dcl_icms_sq1.nextval
           , /* invoice_lin_id              */ i.invoice_lin_id
           , /* numerario_dsp_id            */ i.numerario_dsp_id
           , /* declaracao_lin_id           */ i.declaracao_lin_id
           , /* numerario_id                */ i.numerario_id
           , /* basecalc_pis_cofins         */ i.basecalc_pis_cofins
           , /* valor_pis                   */ i.valor_pis
           , /* valor_cofins                */ i.valor_cofins
          );
        END IF; -- IF (vb_existe_icms_pc) THEN
      END IF; -- IF (vb_existe_ivc_lin_dsp) THEN
    END LOOP; -- FOR i IN (SELECT *
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na gravação do rateio dos numerários: ' || sqlerrm, 'E', 'A');
  END imp_prc_grava_rateio_numerario;

  -- ***********************************************************************
  -- Rotina para distribuir a diferenca encontrada no rateio da despesa
  -- ***********************************************************************
  PROCEDURE prc_distribui_diferenca ( pn_diferenca           NUMBER
                                    , pc_dsp_gera_icms       VARCHAR2
                                    , pc_dsp_gera_pis_cofins VARCHAR2
                                    , pn_inicio              NUMBER
                                    , pc_origem              VARCHAR2
                                    , pn_valor_despesa       NUMBER
                                    , pn_embarque_id         NUMBER
                                    ) IS

-- Delivery 103957: melhoria de performance INICIO
--    CURSOR cur_ratear_linha(pn_invoice_lin_id NUMBER) IS
--      SELECT Decode(iil.qtde, Nvl(NULL, 0), 'N', 'S') ratear
--        FROM imp_vw_valores_base_rateio iil
--      WHERE iil.embarque_id     = pn_embarque_id
--        AND iil.invoice_lin_id = pn_invoice_lin_id;
-- Delivery 103957: melhoria de performance FIM

    vn_diferenca                   NUMBER  := 0;
    vn_basecalc_icms               NUMBER  := 0;
    vn_valor_icms                  NUMBER  := 0;
    vn_basecalc_icms_pro_emprego   NUMBER  := 0;
    vn_valor_icms_pro_emprego      NUMBER  := 0;
    vn_basecalc_pis_cofins         NUMBER  := 0;
    vn_valor_pis                   NUMBER  := 0;
    vn_valor_cofins                NUMBER  := 0;
    vn_qtde                        NUMBER  := 0;
    vn_invoice_lin_id              NUMBER  := null;
    vn_declaracao_lin_id           NUMBER  := null;
    vb_teve_linha_ajustada         BOOLEAN := false;
    vn_valor_fecp                  NUMBER  := 0;
    vc_ratear                      VARCHAR2(1);

  BEGIN
    vn_diferenca := abs (pn_diferenca);

    FOR diff IN pn_inicio..vn_global_ivc_lin_dsp LOOP
-- Delivery 103957: melhoria de performance INICIO
--        OPEN cur_ratear_linha(tb_ivc_lin_dsp(diff).invoice_lin_id);
--        FETCH cur_ratear_linha INTO vc_ratear;
--        CLOSE cur_ratear_linha;

--        IF Nvl(vc_ratear,'N') = 'S' THEN

      IF(tb_ivc_lin_dsp(diff).valor_mn <> 0)THEN
-- Delivery 103957: melhoria de performance FIM

        IF (pn_diferenca > 0) THEN
          tb_ivc_lin_dsp(diff).valor_mn     := tb_ivc_lin_dsp(diff).valor_mn + (1/100);
          tb_ivc_lin_dsp(diff).valor_ajuste := nvl (tb_ivc_lin_dsp(diff).valor_ajuste, 0) + (1/100);
          vb_teve_linha_ajustada            := true;
          vn_diferenca                      := vn_diferenca - (1/100);
        ELSE
          IF (pn_valor_despesa < 0) OR
            ((pn_valor_despesa > 0) AND (tb_ivc_lin_dsp(diff).valor_mn - (1/100) >= 0))
          THEN
            tb_ivc_lin_dsp(diff).valor_mn     := tb_ivc_lin_dsp(diff).valor_mn - (1/100);
            tb_ivc_lin_dsp(diff).valor_ajuste := nvl (tb_ivc_lin_dsp(diff).valor_ajuste, 0) - (1/100);
            vb_teve_linha_ajustada            := true;
            vn_diferenca                      := vn_diferenca - (1/100);
          END IF;
        END IF;

        EXIT WHEN vn_diferenca = 0;

        IF (diff = vn_global_ivc_lin_dsp) AND (vn_diferenca > 0) THEN
          IF (vb_teve_linha_ajustada) THEN
            vb_teve_linha_ajustada := false;
          ELSE
            prc_gera_log_erros ( 'Problemas no rateio da diferenca da despesa [PRC_DISTRIBUI_DIFERENCA].'
                              , 'E'
                              , 'A');
            EXIT;
          END IF; -- IF (vb_teve_linha_ajustada) THEN
        END IF; -- IF (diff = vn_global_ivc_lin_dsp) AND (vn_diferenca > 0) THEN
      END IF; -- IF Nvl(vc_ratear,'N') = 'S' THEN
    END LOOP; -- FOR diff IN 1..vn_global_ivc_lin_dsp LOOP

    -- recalculando icms e pis/cofins para as despesa que tiveram seus valores alterados
    FOR calcipt IN pn_inicio..vn_global_ivc_lin_dsp LOOP
-- Delivery 103957: melhoria de performance INICIO
--      OPEN cur_ratear_linha(tb_ivc_lin_dsp(calcipt).invoice_lin_id);
--      FETCH cur_ratear_linha INTO vc_ratear;
--      CLOSE cur_ratear_linha;

--      IF Nvl(vc_ratear,'S') = 'S' THEN

      IF(tb_ivc_lin_dsp(calcipt).qtde_linha_ivc <> 0)THEN
-- Delivery 103957: melhoria de performance FIM

        vn_basecalc_icms             := 0;
        vn_valor_icms                := 0;
        vn_basecalc_icms_pro_emprego := 0;
        vn_valor_icms_pro_emprego    := 0;
        vn_basecalc_pis_cofins       := 0;
        vn_valor_pis                 := 0;
        vn_valor_cofins              := 0;
        vn_qtde                      := 0;
        vn_invoice_lin_id            := null;
        vn_declaracao_lin_id         := null;
        vn_valor_fecp                := 0;

        IF (pc_origem = 'NAC') THEN
          vn_qtde                := tb_ivc_lin_dsp(calcipt).qtde_linha_dcl;
          vn_invoice_lin_id      := null;
          vn_declaracao_lin_id   := tb_ivc_lin_dsp(calcipt).declaracao_lin_id;
        ELSE
          vn_qtde                := tb_ivc_lin_dsp(calcipt).qtde_linha_ivc;
          vn_invoice_lin_id      := tb_ivc_lin_dsp(calcipt).invoice_lin_id;
          vn_declaracao_lin_id   := null;
        END IF;

        IF (pc_dsp_gera_icms = 'S' AND vn_qtde >0) THEN
          imp_pkg_calcula_icms.imp_prc_icms_numerario ( vn_invoice_lin_id
                                                      , vn_declaracao_lin_id
                                                      , tb_ivc_lin_dsp(calcipt).valor_mn / vn_qtde
                                                      , vn_basecalc_icms
                                                      , vn_valor_icms
                                                      , vn_basecalc_icms_pro_emprego
                                                      , vn_valor_icms_pro_emprego
                                                      , tb_ivc_lin_dsp(calcipt).numerario_dsp_id
                                                      , tb_ivc_lin_dsp(calcipt).numerario_id
                                                      , vn_valor_fecp
                                                      );
        ELSE
          vn_basecalc_icms             := 0;
          vn_valor_icms                := 0;
          vn_basecalc_icms_pro_emprego := 0;
          vn_valor_icms_pro_emprego    := 0;
          vn_valor_fecp                := 0;
        END IF;

        IF (pc_dsp_gera_pis_cofins = 'S' AND vn_qtde >0) THEN
          imp_pkg_calcula_pis_cofins.imp_prc_piscofins_numerario ( vn_invoice_lin_id
                                                                , vn_declaracao_lin_id
                                                                , tb_ivc_lin_dsp(calcipt).valor_mn / vn_qtde
                                                                , vn_basecalc_pis_cofins
                                                                , vn_valor_pis
                                                                , vn_valor_cofins
                                                                , tb_ivc_lin_dsp(calcipt).numerario_dsp_id
                                                                , tb_ivc_lin_dsp(calcipt).numerario_id
                                                                );
        ELSE
          vn_basecalc_pis_cofins := 0;
          vn_valor_pis           := 0;
          vn_valor_cofins        := 0;
        END IF;

        tb_ivc_lin_dsp(calcipt).basecalc_icms             := vn_basecalc_icms;
        tb_ivc_lin_dsp(calcipt).valor_icms                := vn_valor_icms;
        tb_ivc_lin_dsp(calcipt).basecalc_icms_pro_emprego := vn_basecalc_icms_pro_emprego;
        tb_ivc_lin_dsp(calcipt).valor_icms_pro_emprego    := vn_valor_icms_pro_emprego;
        tb_ivc_lin_dsp(calcipt).basecalc_pis_cofins       := vn_basecalc_pis_cofins;
        tb_ivc_lin_dsp(calcipt).valor_pis                 := vn_valor_pis;
        tb_ivc_lin_dsp(calcipt).valor_cofins              := vn_valor_cofins;
        tb_ivc_lin_dsp(calcipt).valor_fecp                := vn_valor_fecp;
      END IF; --IF Nvl(vc_ratear,'S') = 'S' THEN
    END LOOP; -- FOR calcimpt IN vn_global_ivc_lin_dsp LOOP
  END prc_distribui_diferenca;

  -- ***********************************************************************
  -- Rotina para rateio de numerários
  -- ***********************************************************************
  PROCEDURE imp_prc_rateia_numerarios (pn_embarque_id  NUMBER) IS
    vn_ind_rateio                 NUMBER := 0;
    vn_soma_valor_mn              NUMBER := 0;
    vn_valor_mn                   NUMBER := 0;
    vn_basecalc_icms              NUMBER := 0;
    vn_valor_icms                 NUMBER := 0;
    vn_basecalc_icms_pro_emprego  NUMBER := 0;
    vn_valor_icms_pro_emprego     NUMBER := 0;
    vn_vrt_ii_ipi_mn              NUMBER := 0;
    vn_valor_aduaneiro            NUMBER := 0;
    vb_primeira_vez_ind           BOOLEAN := true;
    vb_primeira_vez_va            BOOLEAN := true;
    vn_basecalc_pis_cofins        NUMBER := 0;
    vn_valor_pis                  NUMBER := 0;
    vn_valor_cofins               NUMBER := 0;
    vn_linha_de_maior_valor       NUMBER := 0;
    vn_maior_valor_dsp            NUMBER := 0;
    vn_diferenca_dsp              NUMBER := 0;
    vb_existe_nf                  BOOLEAN := false;
    vb_primeira_dsp               BOOLEAN := true;
    vn_inicio                     NUMBER  := 1;
    vn_valor_fecp                 NUMBER := 0;

    CURSOR cur_numerarios_dsp IS
      SELECT inre.numerario_id
           , inre.numerario_dsp_id
           , inre.valor_mn
           , cnp.tp_rateio
           , cnp.gera_icms
           , cnp.gera_pis_cofins
           , cnp.tp_nota
        FROM imp_numerarios_rateio_ebq inre
           , imp_numerarios_dsp   ind
           , cmx_numerarios_param cnp
       WHERE inre.embarque_id     = pn_embarque_id
         AND ind.numerario_dsp_id = inre.numerario_dsp_id
         AND cnp.numer_param_id   = ind.numer_param_id
         AND NOT EXISTS ( SELECT 1
                            FROM imp_embarques ebq
                               , cmx_empresas   ce
                               , cmx_numerarios_param_uf cnpu
                            WHERE ebq.embarque_id     = inre.embarque_id
                              AND ce.empresa_id       = ebq.empresa_id
                              AND cnpu.numer_param_id = ind.numer_param_id
                              AND cnpu.uf_id          = ce.uf_id
                        )
       UNION ALL
      SELECT inre.numerario_id
           , inre.numerario_dsp_id
           , inre.valor_mn
           , cnp.tp_rateio
           , cnpu .gera_icms
           , cnp.gera_pis_cofins
           , cnpu.tp_nota
        FROM imp_embarques              ebq
           , cmx_empresas               ce
           , cmx_numerarios_param_uf    cnpu
           , imp_numerarios_rateio_ebq  inre
           , imp_numerarios_dsp         ind
           , cmx_numerarios_param       cnp
       WHERE inre.embarque_id     = pn_embarque_id
         AND ind.numerario_dsp_id = inre.numerario_dsp_id
         AND cnp.numer_param_id   = ind.numer_param_id
         AND ebq.embarque_id      = inre.embarque_id
         AND ce.empresa_id        = ebq.empresa_id
         AND cnpu.numer_param_id  = ind.numer_param_id
         AND cnpu.uf_id           = ce.uf_id;

    CURSOR cur_ivc_lin_dsp (pn_numerario_dsp_id NUMBER, pn_invoice_lin_id NUMBER) IS
      SELECT valor_mn
           , basecalc_icms
           , valor_icms
           , basecalc_icms_pro_emprego
           , valor_icms_pro_emprego
           , basecalc_pis_cofins
           , valor_pis
           , valor_cofins
           , valor_fecp
       FROM imp_invoices_lin_dsp
      WHERE invoice_lin_id   = pn_invoice_lin_id
        AND numerario_dsp_id = pn_numerario_dsp_id;

-- Delivery 103957: melhoria de performance INICIO
--    CURSOR cur_num_rateio_embarque(pn_numerario_id NUMBER) IS
--      SELECT 1
--        FROM imp_vw_valores_base_rateio iilw
--           , imp_numerarios_itens       ini
--       WHERE iilw.embarque_id    = pn_embarque_id
--         AND iilw.invoice_lin_id = ini.invoice_lin_id (+)
--         AND ini.numerario_id(+) = pn_numerario_id;
-- Delivery 103957: melhoria de performance FIM

--    CURSOR cur_num_rateio_itens(pn_numerario_id NUMBER, pn_invoice_lin_id NUMBER) IS
--      SELECT Sum( decode ( ini.invoice_lin_id, NULL, iil.qtde, decode( ini.rateio, 'S', iil.qtde), 0 ) ) AS qtde
--        FROM imp_numerarios_itens       ini
--           , imp_vw_valores_base_rateio iil
--       WHERE iil.embarque_id     = pn_embarque_id
--         AND iil.invoice_lin_id  = ini.invoice_lin_id(+)
--         AND ini.numerario_id(+) = pn_numerario_id
--         AND iil.invoice_lin_id  = pn_invoice_lin_id;

    vn_num_rateio_embarque          NUMBER;
    --vr_num_rateio_itens             cur_num_rateio_itens%ROWTYPE;
    vn_num_rateio_itens_qtde        NUMBER;

-- Delivery 103957: melhoria de performance INICIO
--    vb_cur_num_rateio_embarque      BOOLEAN;
-- Delivery 103957: melhoria de performance FIM

    vb_cur_num_rateio_itens         BOOLEAN;

    vn_vrt_fob_mn_ind_rateio        NUMBER;
    vn_vrt_fob_mn_linha             NUMBER;
    vn_valor_aduaneiro_ind_rateio   NUMBER;
    vn_valor_aduaneiro_linha        NUMBER;
    vn_vrt_cif_mn_ind_rateio        NUMBER;
    vn_vrt_cif_mn_linha             NUMBER;
    vn_pesoliq_tot_ind_rateio       NUMBER;
    vn_pesoliq_tot_linha            NUMBER;

    vn_vrt_fob_mn                   NUMBER;
    vn_vrt_dspfob_mn                NUMBER;
    vn_pesoliq_tot                  NUMBER;
    vn_vmle_mn                      NUMBER;
    vn_vrt_fr_mn                    NUMBER;
    vn_vrt_sg_mn                    NUMBER;
    vn_qtde                         NUMBER;
    vn_pesobrt_tot_ind_rateio       NUMBER;
    vn_pesobrt_tot_linha            NUMBER;
    vn_pesobrt_tot                  NUMBER;


    vn_valor_ref_adicao_ind_rateio  NUMBER;
    --vn_valor_ref_adicao             NUMBER;
    vn_valor_ref_adicao_linha       NUMBER;
    vn_valor_ref_adicao_tot         NUMBER;
    vb_gera_icms                    BOOLEAN;
    vb_found                        BOOLEAN := TRUE;
    vn_dummy                        NUMBER;

    FUNCTION fnc_existe_nf (pn_numerario_dsp_id NUMBER) RETURN BOOLEAN IS
      vc_dummy VARCHAR2 (1);

    BEGIN
      SELECT null
        INTO vc_dummy
        FROM imp_nota_fiscal_lin_dsp
       WHERE embarque_id = pn_embarque_id
         AND numerario_dsp_id = pn_numerario_dsp_id;

      RETURN true;
    EXCEPTION
      WHEN no_data_found THEN
         RETURN false;
      WHEN too_many_rows THEN
        RETURN true;
    END;

  BEGIN
    vb_primeira_vez_ind    := true;
    vb_primeira_vez_va     := true;
    vb_primeira_dsp        := true;
    vn_inicio              := 1;

    DELETE FROM imp_ivc_lin_dsp_dcl_icms_tmp
     WHERE numerario_id IN (SELECT numerario_id
                              FROM imp_numerarios_rateio_ebq
                             WHERE embarque_id = pn_embarque_id);

    DELETE FROM imp_ivc_lin_dsp_dcl_pc_tmp
     WHERE numerario_id IN (SELECT numerario_id
                              FROM imp_numerarios_rateio_ebq
                             WHERE embarque_id = pn_embarque_id);

    FOR dsp IN cur_numerarios_dsp LOOP

      vn_vrt_fob_mn_ind_rateio       := 0;
      vn_vrt_cif_mn_ind_rateio       := 0;
      vn_pesoliq_tot_ind_rateio      := 0;
      vn_valor_aduaneiro_ind_rateio  := 0;
      vn_valor_ref_adicao_ind_rateio := 0;
      vn_pesobrt_tot_ind_rateio      := 0;

      -- Calcular os totais de FOB, CIF, PESO e VALOR ADUANEIRO com base no rateio opcional de itens do numerario
      FOR ivcR IN 1..vn_global_ivc_lin LOOP

        -- Calcular total por linha
        vn_vrt_fob_mn_linha       := 0;
        vn_vrt_cif_mn_linha       := 0;
        vn_pesoliq_tot_linha      := 0;
        vn_valor_aduaneiro_linha  := 0;
        vn_valor_ref_adicao_linha := 0;

        -- FOB
        vn_vrt_fob_mn_linha := nvl (tb_ivc_lin(ivcR).vrt_fob_mn   , 0)
                             + nvl (tb_ivc_lin(ivcR).vrt_dspfob_mn, 0);

        -- CIF
        vn_vrt_cif_mn_linha  := (
                               nvl(tb_ivc_lin(ivcR).vrt_fob_mn   ,0) +
                               nvl(tb_ivc_lin(ivcR).vrt_dspfob_mn,0) +
                               nvl(tb_ivc_lin(ivcR).vrt_fr_mn    ,0) +
                               nvl(tb_ivc_lin(ivcR).vrt_sg_mn    ,0)
                               );

        FOR dclC IN 1..vn_global_dcl_lin LOOP

          IF tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dclC).invoice_lin_id THEN
            vn_vrt_cif_mn_linha := vn_vrt_cif_mn_linha                +
                                    nvl(tb_dcl_lin(dclC).valor_ii  ,0) +
                                    nvl(tb_dcl_lin(dclC).valor_ipi ,0) ;

          END IF;
        END LOOP;

        -- PESO LIQUIDO
        vn_pesoliq_tot_linha := tb_ivc_lin(ivcR).pesoliq_tot;

        -- PESO BRUTO
        vn_pesobrt_tot_linha := tb_ivc_lin(ivcR).pesobrt_tot;

        -- VALOR ADUARNEIRO
        vn_valor_aduaneiro_linha := ( nvl (tb_ivc_lin(ivcR).vmle_mn  , 0) +
                                      nvl (tb_ivc_lin(ivcR).vrt_fr_mn, 0) +
                                      nvl (tb_ivc_lin(ivcR).vrt_sg_mn, 0) );

        -- ADICAO
-- Delivery 103957: melhoria de performance INICIO
        vn_valor_ref_adicao_linha := 1;
        IF (dsp.tp_rateio = 'D') THEN  --- Adicao
          vn_valor_ref_adicao_linha := imp_fnc_valor_ref_adicoes ( dsp.numerario_id
                                                               , tb_ivc_lin(ivcR).invoice_lin_id );
        END IF;
-- Delivery 103957: melhoria de performance FIM


        -- Calcular e acumular total rateado por qtd de item
-- Delivery 103957: melhoria de performance INICIO
--        OPEN cur_num_rateio_embarque(dsp.numerario_id);
--        FETCH cur_num_rateio_embarque INTO vn_num_rateio_embarque;
--        vb_cur_num_rateio_embarque := cur_num_rateio_embarque%FOUND;
--        CLOSE cur_num_rateio_embarque;
-- Delivery 103957: melhoria de performance FIM

--        vr_num_rateio_itens  := NULL;
--        OPEN cur_num_rateio_itens(dsp.numerario_id, tb_ivc_lin(ivcR).invoice_lin_id );
--        FETCH cur_num_rateio_itens INTO vr_num_rateio_itens;
--        vb_cur_num_rateio_itens := cur_num_rateio_itens%FOUND;
--        CLOSE cur_num_rateio_itens;

        vn_num_rateio_itens_qtde := imp_fnc_qtde_dcl_num_dsp(tb_ivc_lin(ivcR).invoice_lin_id, dsp.numerario_id, tb_ivc_lin(ivcR).qtde, vc_global_tpbase_retif_a_maior);

-- Delivery 103957: melhoria de performance INICIO
--        /* Verificar se existe parametrizacao de rateio de itens para o Embarque para
--           evitar aplicacao da regra de rateio simples em linhas de invoice não informadas nos itens do numerario
--        */
--        IF(vb_cur_num_rateio_embarque)THEN
-- Delivery 103957: melhoria de performance FIM

--          IF(vb_cur_num_rateio_itens)THEN

            IF(vn_num_rateio_itens_qtde > 0 )THEN

              vn_vrt_fob_mn_ind_rateio      := vn_vrt_fob_mn_ind_rateio
                                            + ((vn_vrt_fob_mn_linha / tb_ivc_lin(ivcR).qtde) * vn_num_rateio_itens_qtde);

              vn_vrt_cif_mn_ind_rateio      := vn_vrt_cif_mn_ind_rateio
                                            +  ((vn_vrt_cif_mn_linha / tb_ivc_lin(ivcR).qtde) * vn_num_rateio_itens_qtde);

              vn_pesoliq_tot_ind_rateio     := vn_pesoliq_tot_ind_rateio
                                            + ((vn_pesoliq_tot_linha / tb_ivc_lin(ivcR).qtde) * vn_num_rateio_itens_qtde);

              vn_pesobrt_tot_ind_rateio     := vn_pesobrt_tot_ind_rateio
                                            + ((vn_pesobrt_tot_linha / tb_ivc_lin(ivcR).qtde) * vn_num_rateio_itens_qtde);

              vn_valor_aduaneiro_ind_rateio := vn_valor_aduaneiro_ind_rateio
                                            + ((vn_valor_aduaneiro_linha / tb_ivc_lin(ivcR).qtde) * vn_num_rateio_itens_qtde);

              vn_valor_ref_adicao_ind_rateio := (vn_valor_ref_adicao_ind_rateio + vn_valor_ref_adicao_linha);

            END IF;

--          END IF;

-- Delivery 103957: melhoria de performance INICIO
--        ELSE -- Regra de rateio simples

--          vn_vrt_fob_mn_ind_rateio      := vn_vrt_fob_mn_ind_rateio
--                                         + vn_vrt_fob_mn_linha;

--          vn_vrt_cif_mn_ind_rateio      := vn_vrt_cif_mn_ind_rateio
--                                         + vn_vrt_cif_mn_linha;

--          vn_pesoliq_tot_ind_rateio     := vn_pesoliq_tot_ind_rateio
--                                         + vn_pesoliq_tot_linha;

--          vn_valor_aduaneiro_ind_rateio := vn_valor_aduaneiro_ind_rateio
--                                         + vn_valor_aduaneiro_linha;

--          vn_valor_ref_adicao_ind_rateio := vn_valor_ref_adicao_ind_rateio
--                                          + vn_valor_ref_adicao_linha;
--        END IF;
-- Delivery 103957: melhoria de performance FIM

      END LOOP;

      -- Calculo do indice de rateio
      vn_ind_rateio    := 0;
      vn_soma_valor_mn := 0;

      IF (dsp.tp_rateio = 'F') THEN
        IF (vn_global_vrt_fob_ebq_mn > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_vrt_fob_mn_ind_rateio;
        END IF;

      ELSIF (dsp.tp_rateio = 'C') THEN  --- CIF + II + IPI
        IF vb_primeira_vez_ind THEN
          vb_primeira_vez_ind := false;

          FOR ivcC IN 1..vn_global_ivc_lin LOOP

            vn_global_vrt_cif_ii_ipi_mn  := vn_global_vrt_cif_ii_ipi_mn
                                            +
                                            (
                                             nvl(tb_ivc_lin(ivcC).vrt_fob_mn   ,0) +
                                             nvl(tb_ivc_lin(ivcC).vrt_dspfob_mn,0) +
                                             nvl(tb_ivc_lin(ivcC).vrt_fr_mn    ,0) +
                                             nvl(tb_ivc_lin(ivcC).vrt_sg_mn    ,0)
                                            );

          END LOOP;

          FOR dclC IN 1..vn_global_dcl_lin LOOP
              vn_global_vrt_cif_ii_ipi_mn := vn_global_vrt_cif_ii_ipi_mn        +
                                             nvl(tb_dcl_lin(dclC).valor_ii  ,0) +
                                             nvl(tb_dcl_lin(dclC).valor_ipi ,0) ;
          END LOOP;
        END IF;

        IF (vn_vrt_cif_mn_ind_rateio > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_vrt_cif_mn_ind_rateio;
        END IF;

      ELSIF (dsp.tp_rateio = 'P') THEN  --- peso liquido
        IF (vn_pesoliq_tot_ind_rateio > 0) THEN
            vn_ind_rateio := dsp.valor_mn / vn_pesoliq_tot_ind_rateio;
        END IF;

      ELSIF (dsp.tp_rateio = 'B') THEN  --- peso bruto
        IF (vn_pesobrt_tot_ind_rateio > 0) THEN
            vn_ind_rateio := dsp.valor_mn / vn_pesobrt_tot_ind_rateio;
        END IF;

      ELSIF (dsp.tp_rateio = 'A') THEN  --- valor aduaneiro
        IF vb_primeira_vez_va THEN
          vb_primeira_vez_va := false;

          FOR ivcC IN 1..vn_global_ivc_lin LOOP
            vn_global_valor_aduaneiro := vn_global_valor_aduaneiro + (nvl (tb_ivc_lin(ivcC).vmle_mn  , 0) +
                                                                      nvl (tb_ivc_lin(ivcC).vrt_fr_mn, 0) +
                                                                      nvl (tb_ivc_lin(ivcC).vrt_sg_mn, 0));
          END LOOP;
        END IF;

        IF (vn_valor_aduaneiro_ind_rateio > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_valor_aduaneiro_ind_rateio;
        END IF;

      ELSIF (dsp.tp_rateio = 'D') THEN  --- Adicao
        IF (vn_valor_ref_adicao_ind_rateio > 0) THEN
            vn_ind_rateio := dsp.valor_mn / vn_valor_ref_adicao_ind_rateio;
        END IF;

      END IF; -- IF (dsp.tp_rateio = 'F') THEN

      vn_linha_de_maior_valor := 0;
      vn_maior_valor_dsp      := 0;
      vn_diferenca_dsp        := 0;
      vb_existe_nf            := false;

      FOR ivc IN 1..vn_global_ivc_lin LOOP
        vn_global_ivc_lin_dsp        := vn_global_ivc_lin_dsp + 1;
        vn_valor_mn                  := 0;
        vn_basecalc_icms             := 0;
        vn_valor_icms                := 0;
        vn_basecalc_icms_pro_emprego := 0;
        vn_valor_icms_pro_emprego    := 0;
        vn_basecalc_pis_cofins       := 0;
        vn_valor_pis                 := 0;
        vn_valor_cofins              := 0;
        vn_valor_fecp                := 0;
        --

        vb_existe_nf := fnc_existe_nf (dsp.numerario_dsp_id);

        IF (NOT vb_existe_nf) THEN

          -- Calcular valor do custo com base no rateio opcional de itens do numerario
          vn_qtde             := tb_ivc_lin(ivc).qtde;

-- Delivery 103957: melhoria de performance INICIO
--          OPEN cur_num_rateio_embarque(dsp.numerario_id);
--          FETCH cur_num_rateio_embarque INTO vn_num_rateio_embarque;
--          vb_cur_num_rateio_embarque := cur_num_rateio_embarque%FOUND;
--          CLOSE cur_num_rateio_embarque;
-- Delivery 103957: melhoria de performance FIM

--          vr_num_rateio_itens := NULL;
--          OPEN cur_num_rateio_itens(dsp.numerario_id, tb_ivc_lin(ivc).invoice_lin_id );
--          FETCH cur_num_rateio_itens INTO vr_num_rateio_itens;
--          vb_cur_num_rateio_itens := cur_num_rateio_itens%FOUND;
--          CLOSE cur_num_rateio_itens;


          vn_num_rateio_itens_qtde := imp_fnc_qtde_dcl_num_dsp(tb_ivc_lin(ivc).invoice_lin_id , dsp.numerario_id, tb_ivc_lin(ivc).qtde , vc_global_tpbase_retif_a_maior);

-- Delivery 103957: melhoria de performance INICIO
--          /* Verificar se existe parametrizacao de rateio de itens para o Embarque para
--             evitar aplicacao da regra de rateio simples em linhas de invoice não informadas nos itens do numerario
--          */
--          IF(vb_cur_num_rateio_embarque)THEN
-- Delivery 103957: melhoria de performance FIM

--            IF(vb_cur_num_rateio_itens)THEN

              IF( vn_num_rateio_itens_qtde > 0 )THEN
                -- Com rateio por item ligado
                vn_vrt_fob_mn    := ((tb_ivc_lin(ivc).vrt_fob_mn    / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);
                vn_vrt_dspfob_mn := ((tb_ivc_lin(ivc).vrt_dspfob_mn / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);
                vn_pesoliq_tot   := ((tb_ivc_lin(ivc).pesoliq_tot   / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);
                vn_pesobrt_tot   := ((tb_ivc_lin(ivc).pesobrt_tot   / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);
                vn_vmle_mn       := ((tb_ivc_lin(ivc).vmle_mn       / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);
                vn_vrt_fr_mn     := ((tb_ivc_lin(ivc).vrt_fr_mn     / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);
                vn_vrt_sg_mn     := ((tb_ivc_lin(ivc).vrt_sg_mn     / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);
                vn_qtde          := vn_num_rateio_itens_qtde;

-- Delivery 103957: melhoria de performance INICIO
                vn_valor_ref_adicao_tot := 1;
                IF(dsp.tp_rateio = 'D')THEN --- Adicao
                vn_valor_ref_adicao_tot := imp_fnc_valor_ref_adicoes ( dsp.numerario_id, tb_ivc_lin(ivc).invoice_lin_id );
                END IF;
-- Delivery 103957: melhoria de performance FIM

                IF (dsp.tp_rateio = 'F') THEN
                  vn_valor_mn := (vn_vrt_fob_mn + vn_vrt_dspfob_mn) * vn_ind_rateio;

                ELSIF (dsp.tp_rateio = 'C') THEN
                  vn_vrt_ii_ipi_mn := 0;

                  FOR dclC IN 1..vn_global_dcl_lin LOOP
                    IF tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(dclC).invoice_lin_id THEN
                        vn_vrt_ii_ipi_mn := vn_vrt_ii_ipi_mn                   +
                                            nvl(tb_dcl_lin(dclC).valor_ii  ,0) +
                                            nvl(tb_dcl_lin(dclC).valor_ipi ,0) ;
                    END IF;
                  END LOOP; -- FOR dclC IN 1..vn_global_dcl_lin LOOP

                  vn_vrt_ii_ipi_mn := ((vn_vrt_ii_ipi_mn / tb_ivc_lin(ivc).qtde) * vn_num_rateio_itens_qtde);

                  vn_valor_mn := (
                                  nvl(vn_vrt_fob_mn   ,0) +
                                  nvl(vn_vrt_dspfob_mn,0) +
                                  nvl(vn_vrt_fr_mn    ,0) +
                                  nvl(vn_vrt_sg_mn    ,0) +
                                  vn_vrt_ii_ipi_mn
                                ) * vn_ind_rateio;

                ELSIF (dsp.tp_rateio = 'P') THEN
                  vn_valor_mn := vn_pesoliq_tot * vn_ind_rateio;

                ELSIF (dsp.tp_rateio = 'B') THEN
                  vn_valor_mn := vn_pesobrt_tot * vn_ind_rateio;

                ELSIF (dsp.tp_rateio = 'A') THEN
                  vn_valor_mn := (nvl (vn_vmle_mn  , 0) +
                                  nvl (vn_vrt_fr_mn, 0) +
                                  nvl (vn_vrt_sg_mn, 0) ) * vn_ind_rateio;

                ELSIF (dsp.tp_rateio = 'D') THEN
                  vn_valor_mn := vn_valor_ref_adicao_tot * vn_ind_rateio;

                END IF; -- IF (dsp.tp_rateio = 'F') THEN

              ELSE
                -- Com rateio por item desligado
                vn_valor_mn := 0;

              END IF;

--            END IF;

-- Delivery 103957: melhoria de performance INICIO
--          ELSE
--            -- Calculo de rateio simples
--            IF (dsp.tp_rateio = 'F') THEN
--              vn_valor_mn := (tb_ivc_lin(ivc).vrt_fob_mn + tb_ivc_lin(ivc).vrt_dspfob_mn) * vn_ind_rateio;

--            ELSIF (dsp.tp_rateio = 'C') THEN
--              vn_vrt_ii_ipi_mn := 0;

--              FOR dclC IN 1..vn_global_dcl_lin LOOP
--                IF tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(dclC).invoice_lin_id THEN
--                    vn_vrt_ii_ipi_mn := vn_vrt_ii_ipi_mn                   +
--                                        nvl(tb_dcl_lin(dclC).valor_ii  ,0) +
--                                        nvl(tb_dcl_lin(dclC).valor_ipi ,0) ;
--                END IF;
--              END LOOP; -- FOR dclC IN 1..vn_global_dcl_lin LOOP

--              vn_valor_mn := (
--                              nvl(tb_ivc_lin(ivc).vrt_fob_mn   ,0) +
--                              nvl(tb_ivc_lin(ivc).vrt_dspfob_mn,0) +
--                              nvl(tb_ivc_lin(ivc).vrt_fr_mn    ,0) +
--                              nvl(tb_ivc_lin(ivc).vrt_sg_mn    ,0) +
--                              vn_vrt_ii_ipi_mn
--                            ) * vn_ind_rateio;

--            ELSIF (dsp.tp_rateio = 'P') THEN
--              vn_valor_mn := tb_ivc_lin(ivc).pesoliq_tot * vn_ind_rateio;

--            ELSIF (dsp.tp_rateio = 'A') THEN
--              vn_valor_mn := (nvl (tb_ivc_lin(ivc).vmle_mn  , 0) +
--                              nvl (tb_ivc_lin(ivc).vrt_fr_mn, 0) +
--                              nvl (tb_ivc_lin(ivc).vrt_sg_mn, 0) ) * vn_ind_rateio;

--            ELSIF (dsp.tp_rateio = 'D') THEN
--              vn_valor_mn := ( imp_fnc_valor_ref_adicoes ( dsp.numerario_id
--                                                         , tb_ivc_lin(ivc).invoice_lin_id )
--                              * vn_ind_rateio );

--            END IF; -- IF (dsp.tp_rateio = 'F') THEN
--
--          END IF;
-- Delivery 103957: melhoria de performance FIM

          vn_valor_mn      := round (vn_valor_mn, 2);
          vn_soma_valor_mn := vn_soma_valor_mn + vn_valor_mn;

          IF (vn_valor_mn > vn_maior_valor_dsp) THEN
            vn_maior_valor_dsp      := vn_valor_mn;
            vn_linha_de_maior_valor := vn_global_ivc_lin_dsp;
          END IF;

          IF (dsp.gera_icms = 'S' AND vn_valor_mn > 0) THEN
            imp_pkg_calcula_icms.imp_prc_icms_numerario
                                 (
                                   tb_ivc_lin(ivc).invoice_lin_id
                                 , null -- declaracao_lin_id
                                 , vn_valor_mn / vn_qtde
                                 , vn_basecalc_icms
                                 , vn_valor_icms
                                 , vn_basecalc_icms_pro_emprego
                                 , vn_valor_icms_pro_emprego
                                 , dsp.numerario_dsp_id
                                 , dsp.numerario_id
                                 , vn_valor_fecp
                                 );
          ELSE
            vn_basecalc_icms             := 0;
            vn_valor_icms                := 0;
            vn_basecalc_icms_pro_emprego := 0;
            vn_valor_icms_pro_emprego    := 0;
            vn_valor_fecp                := 0;
          END IF;

          IF (dsp.gera_pis_cofins = 'S' AND vn_valor_mn >0) THEN
            imp_pkg_calcula_pis_cofins.imp_prc_piscofins_numerario
                                       (
                                         tb_ivc_lin(ivc).invoice_lin_id
                                       , null -- declaracao_lin_id
                                       , vn_valor_mn / vn_qtde
                                       , vn_basecalc_pis_cofins
                                       , vn_valor_pis
                                       , vn_valor_cofins
                                       , dsp.numerario_dsp_id
                                       , dsp.numerario_id
                                       );
          ELSE
            vn_basecalc_pis_cofins := 0;
            vn_valor_pis          := 0;
            vn_valor_cofins       := 0;
          END IF;
        ELSE
          OPEN  cur_ivc_lin_dsp (dsp.numerario_dsp_id, tb_ivc_lin(ivc).invoice_lin_id);
          FETCH cur_ivc_lin_dsp INTO vn_valor_mn
                                   , vn_basecalc_icms
                                   , vn_valor_icms
                                   , vn_basecalc_icms_pro_emprego
                                   , vn_valor_icms_pro_emprego
                                   , vn_basecalc_pis_cofins
                                   , vn_valor_pis
                                   , vn_valor_cofins
                                   , vn_valor_fecp;
          CLOSE cur_ivc_lin_dsp;

          vn_soma_valor_mn := vn_soma_valor_mn + vn_valor_mn;
        END IF;

        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).numerario_id              := dsp.numerario_id;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).numerario_dsp_id          := dsp.numerario_dsp_id;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).embarque_id               := pn_embarque_id;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).invoice_id                := tb_ivc_lin(ivc).invoice_id;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).invoice_lin_id            := tb_ivc_lin(ivc).invoice_lin_id;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_mn                  := vn_valor_mn;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).basecalc_icms             := vn_basecalc_icms;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_icms                := vn_valor_icms;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).basecalc_icms_pro_emprego := vn_basecalc_icms_pro_emprego;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_icms_pro_emprego    := vn_valor_icms_pro_emprego;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).basecalc_pis_cofins       := vn_basecalc_pis_cofins;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_pis                 := vn_valor_pis;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_cofins              := vn_valor_cofins;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).qtde_linha_ivc            := vn_qtde;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).qtde_linha_dcl            := null;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_ajuste              := 0;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_fecp                := vn_valor_fecp;

        IF (ivc = vn_global_ivc_lin) THEN
          IF (vb_primeira_dsp) THEN
            vb_primeira_dsp := false;
            vn_inicio       := 1;
          ELSE
            vn_inicio := vn_inicio + vn_global_ivc_lin;
          END IF;

          vn_diferenca_dsp := dsp.valor_mn - vn_soma_valor_mn;

          IF (vn_diferenca_dsp <> 0) THEN
            prc_distribui_diferenca ( vn_diferenca_dsp
                                    , dsp.gera_icms
                                    , dsp.gera_pis_cofins
                                    , vn_inicio
                                    , 'NORMAL'
                                    , dsp.valor_mn
                                    , pn_embarque_id
                                    );
          END IF; -- IF (vn_diferenca_dsp <> 0) THEN
        END IF; -- IF (ivc = vn_global_ivc_lin) AND (NOT vb_existe_nf) THEN
      END LOOP; -- FOR ivc IN 1..vn_global_ivc_lin LOOP
    END LOOP;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na geração do rateio dos numerários: '|| sqlerrm, 'E', 'A');
  END imp_prc_rateia_numerarios;



  -- ***********************************************************************
  -- Rotina para rateio de numerários para nacionalizacoes de recof
  -- ***********************************************************************
  PROCEDURE imp_prc_rateia_numerarios_nac (pn_embarque_id  NUMBER) IS
    vn_ind_rateio                 NUMBER  := 0;
    vn_soma_valor_mn              NUMBER  := 0;
    vn_valor_mn                   NUMBER  := 0;
    vn_basecalc_icms              NUMBER  := 0;
    vn_valor_icms                 NUMBER  := 0;
    vn_basecalc_icms_pro_emprego  NUMBER  := 0;
    vn_valor_icms_pro_emprego     NUMBER  := 0;
    vn_vrt_ii_ipi_mn              NUMBER  := 0;
    vn_valor_aduaneiro            NUMBER  := 0;
    vb_primeira_vez               BOOLEAN := true;
    vb_primeira_vez_va            BOOLEAN := true;
    vn_basecalc_pis_cofins        NUMBER  := 0;
    vn_valor_pis                  NUMBER  := 0;
    vn_valor_cofins               NUMBER  := 0;
    vn_linha_de_maior_valor       NUMBER  := 0;
    vn_maior_valor_dsp            NUMBER  := 0;
    vn_diferenca_dsp              NUMBER  := 0;
    vb_primeira_dsp               BOOLEAN := true;
    vn_inicio                     NUMBER  := 1;
    vn_valor_fecp                 NUMBER  := 0;

    CURSOR cur_numerarios_dsp IS
      SELECT inre.numerario_id
           , inre.numerario_dsp_id
           , inre.valor_mn
           , cnp.tp_rateio
           , cnp.gera_icms
           , cnp.gera_pis_cofins
           , cnp.tp_nota
        FROM imp_numerarios_rateio_ebq inre
           , imp_numerarios_dsp   ind
           , cmx_numerarios_param cnp
       WHERE inre.embarque_id     = pn_embarque_id
         AND ind.numerario_dsp_id = inre.numerario_dsp_id
         AND cnp.numer_param_id   = ind.numer_param_id
         AND NOT EXISTS ( SELECT 1
                            FROM imp_embarques ebq
                               , cmx_empresas   ce
                               , cmx_numerarios_param_uf cnpu
                            WHERE ebq.embarque_id     = inre.embarque_id
                              AND ce.empresa_id       = ebq.empresa_id
                              AND cnpu.numer_param_id = ind.numer_param_id
                              AND cnpu.uf_id          = ce.uf_id
                        )
       UNION ALL
      SELECT inre.numerario_id
           , inre.numerario_dsp_id
           , inre.valor_mn
           , cnp.tp_rateio
           , cnpu .gera_icms
           , cnp.gera_pis_cofins
           , cnpu.tp_nota
        FROM imp_embarques              ebq
           , cmx_empresas               ce
           , cmx_numerarios_param_uf    cnpu
           , imp_numerarios_rateio_ebq  inre
           , imp_numerarios_dsp         ind
           , cmx_numerarios_param       cnp
       WHERE inre.embarque_id     = pn_embarque_id
         AND ind.numerario_dsp_id = inre.numerario_dsp_id
         AND cnp.numer_param_id   = ind.numer_param_id
         AND ebq.embarque_id      = inre.embarque_id
         AND ce.empresa_id        = ebq.empresa_id
         AND cnpu.numer_param_id  = ind.numer_param_id
         AND cnpu.uf_id           = ce.uf_id;

    CURSOR cur_ivc_lin_dsp (pn_numerario_dsp_id NUMBER, pn_declaracao_lin_id NUMBER) IS
      SELECT valor_mn
       FROM imp_declaracoes_lin_dsp
      WHERE declaracao_lin_id   = pn_declaracao_lin_id
        AND numerario_dsp_id = pn_numerario_dsp_id;

  BEGIN
    vb_primeira_vez    := true;
    vb_primeira_vez_va := true;
    vb_primeira_dsp    := true;
    vn_inicio          := 1;

    FOR dsp IN cur_numerarios_dsp LOOP
      vn_ind_rateio    := 0;
      vn_soma_valor_mn := 0;

      IF (dsp.tp_rateio = 'F') THEN
        vn_global_vrt_fob_ebq_mn    := 0;
        vn_global_vrt_dspfob_ebq_mn := 0;
        FOR dclC IN 1..vn_global_dcl_lin LOOP
          vn_global_vrt_fob_ebq_mn    := vn_global_vrt_fob_ebq_mn    + nvl(tb_dcl_lin(dclC).vrt_fob_m    * tb_dcl_lin(dclC).taxa_fob_mn,0);
          vn_global_vrt_dspfob_ebq_mn := vn_global_vrt_dspfob_ebq_mn + nvl(tb_dcl_lin(dclC).vrt_dspfob_m * tb_dcl_lin(dclC).taxa_fob_mn,0);
        END LOOP;
        IF (vn_global_vrt_fob_ebq_mn > 0) THEN
          vn_ind_rateio := dsp.valor_mn / (vn_global_vrt_fob_ebq_mn + vn_global_vrt_dspfob_ebq_mn);
        END IF;
      ELSIF (dsp.tp_rateio = 'C') THEN  --- CIF + II + IPI
        IF vb_primeira_vez THEN
          vb_primeira_vez := false;
          FOR dclC IN 1..vn_global_dcl_lin LOOP
            vn_global_vrt_cif_ii_ipi_mn  := vn_global_vrt_cif_ii_ipi_mn
                                            + (
                                               (
                                                (nvl(tb_dcl_lin(dclC).vrt_fob_m,0) + nvl(tb_dcl_lin(dclC).vrt_dspfob_m,0)) * tb_dcl_lin(dclC).taxa_fob_mn +
                                                nvl(tb_dcl_lin(dclC).vrt_fr_m                                              * tb_dcl_lin(dclC).taxa_fr_mn,0) +
                                                nvl(tb_dcl_lin(dclC).vrt_sg_m                                              * tb_dcl_lin(dclC).taxa_sg_mn,0)
                                               ) * (1 + nvl(tb_dcl_lin(dclC).aliq_ii_rec/100, 0))
                                              ) * (1 + nvl(tb_dcl_lin(dclC).aliq_ipi_rec/100, 0));
          END LOOP;
        END IF;
        IF (vn_global_vrt_cif_ii_ipi_mn > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_global_vrt_cif_ii_ipi_mn;
        END IF;

      ELSIF (dsp.tp_rateio = 'P') THEN  --- peso liquido
        vn_global_pesoliq_ebq := 0;
        FOR dclC IN 1..vn_global_dcl_lin LOOP
          vn_global_pesoliq_ebq    := vn_global_pesoliq_ebq + nvl (tb_dcl_lin(dclC).pesoliq_unit, 0) * nvl (tb_dcl_lin(dclC).qtde, 0);
        END LOOP;

        IF (vn_global_pesoliq_ebq > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_global_pesoliq_ebq;
        END IF;

      ELSIF (dsp.tp_rateio = 'B') THEN  --- peso bruto
        vn_global_pesobrt_ebq := 0;
        FOR dclC IN 1..vn_global_dcl_lin LOOP
          vn_global_pesobrt_ebq    := vn_global_pesobrt_ebq + nvl (tb_dcl_lin (dclC).pesobrt_unit, 0) * nvl (tb_dcl_lin (dclC).qtde, 0);
        END LOOP;

        IF (vn_global_pesobrt_ebq > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_global_pesobrt_ebq;
        END IF;

      ELSIF (dsp.tp_rateio = 'A') THEN  --- valor aduaneiro
        IF vb_primeira_vez_va THEN
          vb_primeira_vez_va := false;

          FOR dclC IN 1..vn_global_dcl_lin LOOP
            vn_global_valor_aduaneiro := vn_global_valor_aduaneiro +
                                         (nvl (tb_dcl_lin(dclC).vrt_fob_m, 0) + nvl (tb_dcl_lin(dclC).vrt_dspfob_m, 0)) * nvl (tb_dcl_lin(dclC).taxa_fob_mn, 0) +
                                         nvl (tb_dcl_lin(dclC).vrt_fr_m,  0)                                             * nvl (tb_dcl_lin(dclC).taxa_fr_mn,  0) +
                                         nvl (tb_dcl_lin(dclC).vrt_sg_m,  0)                                             * nvl (tb_dcl_lin(dclC).taxa_sg_mn,  0);
          END LOOP;
        END IF;
        IF (vn_global_valor_aduaneiro > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_global_valor_aduaneiro;
        END IF;

      ELSIF (dsp.tp_rateio = 'D') THEN  --- Adicao
        vn_global_valor_ref_adicao := 0;
        FOR dclC IN 1..vn_global_dcl_lin LOOP
          vn_global_valor_ref_adicao    := vn_global_valor_ref_adicao
                                         + Nvl( imp_fnc_valor_ref_adicoes( dsp.numerario_id, tb_ivc_lin(dclC).invoice_lin_id ), 0 );


        END LOOP;

        IF (vn_global_valor_ref_adicao > 0) THEN
          vn_ind_rateio := dsp.valor_mn / vn_global_valor_ref_adicao;
        END IF;

      END IF; -- IF (dsp.tp_rateio = 'F') THEN

      vn_linha_de_maior_valor := 0;
      vn_maior_valor_dsp      := 0;
      vn_diferenca_dsp        := 0;

      FOR dcl IN 1..vn_global_dcl_lin LOOP             /************ percorrer linhas da declaracao **************/
        vn_global_dcl_lin_dsp := vn_global_dcl_lin_dsp + 1;

--        IF (tb_ivc_lin(dcl).numero_nf IS null) THEN   ************ fazer controle de retificação para nacionalizações de recof ***************
          IF (dsp.tp_rateio = 'F') THEN
            vn_valor_mn := round (round ((tb_dcl_lin(dcl).vrt_fob_m + tb_dcl_lin(dcl).vrt_dspfob_m) * tb_dcl_lin(dcl).taxa_fob_mn, 2)  * vn_ind_rateio,2);
          ELSIF (dsp.tp_rateio = 'C') THEN
            vn_valor_mn := round (
                              round (
                                 round (
                                   (
                                    round ((nvl(tb_dcl_lin(dcl).vrt_fob_m, 0) + nvl(tb_dcl_lin(dcl).vrt_dspfob_m,0)) * tb_dcl_lin(dcl).taxa_fob_mn, 2) +
                                    round (nvl(tb_dcl_lin(dcl).vrt_fr_m     * tb_dcl_lin(dcl).taxa_fr_mn,  0), 2) +
                                    round (nvl(tb_dcl_lin(dcl).vrt_sg_m     * tb_dcl_lin(dcl).taxa_sg_mn,  0), 2)
                                   ) * (1 + nvl(tb_dcl_lin(dcl).aliq_ii_rec / 100, 0))
                                  , 2
                                 ) * (1 + nvl(tb_dcl_lin(dcl).aliq_ipi_rec / 100, 0))
                               , 2
                              ) * vn_ind_rateio
                            , 2
                           );

          ELSIF (dsp.tp_rateio = 'P') THEN
            vn_valor_mn := round (tb_dcl_lin(dcl).pesoliq_tot * vn_ind_rateio, 7);

          ELSIF (dsp.tp_rateio = 'B') THEN
            vn_valor_mn := round (tb_dcl_lin(dcl).pesobrt_tot * vn_ind_rateio, 7);

          ELSIF (dsp.tp_rateio = 'A') THEN
            vn_valor_mn := round (
                              (
                               round ((nvl (tb_dcl_lin(dcl).vrt_fob_m, 0) + nvl (tb_dcl_lin(dcl).vrt_dspfob_m, 0))  * nvl (tb_dcl_lin(dcl).taxa_fob_mn, 0), 2) +
                               round (nvl (tb_dcl_lin(dcl).vrt_fr_m,  0)                                             * nvl (tb_dcl_lin(dcl).taxa_fr_mn,  0), 2) +
                               round (nvl (tb_dcl_lin(dcl).vrt_sg_m,  0)                                             * nvl (tb_dcl_lin(dcl).taxa_sg_mn,  0), 2)
                              ) * vn_ind_rateio
                            , 2
                           );

          ELSIF (dsp.tp_rateio = 'D') THEN
            vn_valor_mn := round ( imp_fnc_valor_ref_adicoes ( dsp.numerario_id
                                                             , tb_ivc_lin(dcl).invoice_lin_id )
                                  * vn_ind_rateio, 2 );

          END IF; -- IF (dsp.tp_rateio = 'F') THEN

          vn_valor_mn      := round (vn_valor_mn, 2);
          vn_soma_valor_mn := vn_soma_valor_mn + vn_valor_mn;

          IF (vn_valor_mn > vn_maior_valor_dsp) THEN
            vn_maior_valor_dsp      := vn_valor_mn;
            vn_linha_de_maior_valor := vn_global_dcl_lin_dsp;
          END IF;

          IF (dsp.gera_icms = 'S') THEN
            imp_pkg_calcula_icms.imp_prc_icms_numerario
                                 (
                                   null -- invoice_lin_id
                                 , tb_dcl_lin(dcl).declaracao_lin_id
                                 , vn_valor_mn / tb_dcl_lin(dcl).qtde
                                 , vn_basecalc_icms
                                 , vn_valor_icms
                                 , vn_basecalc_icms_pro_emprego
                                 , vn_valor_icms_pro_emprego
                                 , dsp.numerario_dsp_id
                                 , dsp.numerario_id
                                 , vn_valor_fecp
                                 );
          ELSE
            vn_basecalc_icms             := 0;
            vn_valor_icms                := 0;
            vn_basecalc_icms_pro_emprego := 0;
            vn_valor_icms_pro_emprego    := 0;
            vn_valor_fecp                := 0;
          END IF;

          IF (dsp.gera_pis_cofins = 'S') THEN
            imp_pkg_calcula_pis_cofins.imp_prc_piscofins_numerario
                                       (
                                         null -- invoice_lin_id
                                       , tb_dcl_lin(dcl).declaracao_lin_id
                                       , vn_valor_mn / tb_dcl_lin(dcl).qtde
                                       , vn_basecalc_pis_cofins
                                       , vn_valor_pis
                                       , vn_valor_cofins
                                       , dsp.numerario_dsp_id
                                       , dsp.numerario_id
                                       );
          ELSE
            vn_basecalc_pis_cofins := 0;
            vn_valor_pis          := 0;
            vn_valor_cofins       := 0;
          END IF;
--         ELSE      ************** controle de retificação para nacionalizações de recof ******************
--           OPEN  cur_ivc_lin_dsp (dsp.numerario_dsp_id, tb_ivc_lin(dcl).invoice_lin_id);
--           FETCH cur_ivc_lin_dsp INTO vn_valor_mn
--                                    , vn_basecalc_icms
--                                    , vn_valor_icms
--                                    , vn_basecalc_icms_pro_emprego
--                                    , vn_valor_icms_pro_emprego
--                                    , vn_basecalc_pis_cofins
--                                    , vn_valor_pis
--                                    , vn_valor_cofins;
--           CLOSE cur_ivc_lin_dsp;
--
--           vn_soma_valor_mn := vn_soma_valor_mn + vn_valor_mn;
--         END IF;

        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).numerario_id              := dsp.numerario_id;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).numerario_dsp_id          := dsp.numerario_dsp_id;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).embarque_id               := pn_embarque_id;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).invoice_id                := null;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).invoice_lin_id            := null;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).declaracao_lin_id         := tb_dcl_lin(dcl).declaracao_lin_id;  /******************** gravar o declaracao_lin_id ********************/
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).valor_mn                  := vn_valor_mn;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).basecalc_icms             := vn_basecalc_icms;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).valor_icms                := vn_valor_icms;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).basecalc_icms_pro_emprego := vn_basecalc_icms_pro_emprego;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).valor_icms_pro_emprego    := vn_valor_icms_pro_emprego;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).basecalc_pis_cofins       := vn_basecalc_pis_cofins;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).valor_pis                 := vn_valor_pis;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).valor_cofins              := vn_valor_cofins;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).qtde_linha_ivc            := null;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).qtde_linha_dcl            := tb_dcl_lin(dcl).qtde;
        tb_ivc_lin_dsp(vn_global_ivc_lin_dsp).valor_ajuste              := 0;
        tb_ivc_lin_dsp(vn_global_dcl_lin_dsp).valor_fecp                := vn_valor_fecp;

        IF (dcl = vn_global_dcl_lin) THEN
          IF (vb_primeira_dsp) THEN
            vb_primeira_dsp := false;
            vn_inicio       := 1;
          ELSE
            vn_inicio := vn_inicio + vn_global_ivc_lin;
          END IF;

          vn_diferenca_dsp := dsp.valor_mn - vn_soma_valor_mn;

          IF (vn_diferenca_dsp <> 0) THEN
            prc_distribui_diferenca ( vn_diferenca_dsp
                                    , dsp.gera_icms
                                    , dsp.gera_pis_cofins
                                    , vn_inicio
                                    , 'NAC'
                                    , dsp.valor_mn
                                    , pn_embarque_id
                                    );
          END IF; -- IF (vn_diferenca_dsp <> 0) THEN
        END IF; -- IF (ivc = vn_global_ivc_lin) THEN
     END LOOP;
    END LOOP;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na geração do rateio dos numerários: ' || sqlerrm, 'E', 'A');
  END imp_prc_rateia_numerarios_nac;

    PROCEDURE imp_prc_calcula_afrmm ( pn_tp_declaracao  NUMBER
                                  , pd_data_conversao DATE
                                  , pc_dsi            VARCHAR2
                                  , pn_embarque_id    NUMBER
                                  ) IS

    TYPE reg_dcl_vlr_rateio IS RECORD
    ( declaracao_lin_id NUMBER
    , declaracao_adi_id NUMBER
    , invoice_lin_id    NUMBER
    , vlrt_fob          NUMBER
    , vlrt_cif_ii_ipi   NUMBER
    , tot_pesoliq       NUMBER
    , vlrt_aduaneiro    NUMBER
    , vlrt_adicao       NUMBER
    , tot_pesobrt       NUMBER
    );

    CURSOR cur_vlr_frete_afrmm ( pn_cur_embarque_id NUMBER, pd_data_conversao DATE )IS
      SELECT Nvl (ice.valor_prepaid_m, 0)
           + Nvl (ice.valor_collect_m, 0)
           + Nvl ( ( SELECT Sum (cmx_pkg_taxas.fnc_converte_opcional ( ied_afrmm.valor_m
                                                                      , ied_afrmm.moeda_id
                                                                      , ice.moeda_id
                                                                      , pd_data_conversao
                                                                      , 'FISCAL'))
                       FROM imp_embarques_ad_afrmm ied_afrmm
                          , cmx_tabelas ct
                      WHERE ied_afrmm.embarque_id = ice.embarque_id
                        AND ied_afrmm.tabela_id   = ct.tabela_id
                        AND ct.tipo               = '119' )
                   , 0 )
           - Nvl ( ( SELECT Sum (cmx_pkg_taxas.fnc_converte_opcional ( ied_afrmm.valor_m
                                                                     , ied_afrmm.moeda_id
                                                                     , ice.moeda_id
                                                                     , pd_data_conversao
                                                                     , 'FISCAL'))
                       FROM imp_embarques_ad_afrmm ied_afrmm
                          , cmx_tabelas ct
                      WHERE ied_afrmm.embarque_id = ice.embarque_id
                        AND ied_afrmm.tabela_id   = ct.tabela_id
                        AND ct.tipo               = '120' )
                   , 0 )
           , ice.moeda_id
        FROM imp_vw_conhec_ebq  ice
       WHERE ice.embarque_id = pn_cur_embarque_id;

    CURSOR cur_mod_despacho IS
      SELECT Nvl(id.mde_despacho         , '1') mde_despacho
           , Nvl(id.retif_flag_calc_afrmm, 'N') retif_flag_calc_afrmm
	      FROM imp_declaracoes id
	     WHERE id.embarque_id  = pn_embarque_id;

    CURSOR cur_embarque_nac IS
      SELECT ie.embarque_id
	      FROM imp_embarques       ie
           , imp_declaracoes     id_da
           , imp_declaracoes_lin idl_da
           , imp_declaracoes_lin idl
           , imp_declaracoes     id
	    WHERE id.embarque_id       = pn_embarque_id
        AND id.declaracao_id     = idl.declaracao_id
        AND idl.da_lin_id        = idl_da.declaracao_lin_id
        AND idl_da.declaracao_id = id_da.declaracao_id
        AND id_da.embarque_id    = ie.embarque_id;

    CURSOR cur_vlr_afrmm_nac ( pn_cur_declaracao_lin_id NUMBER
                             , pn_cur_qtde              NUMBER )IS
      SELECT ( ( idl_da.vlr_frete              / idl_da.qtde ) * pn_cur_qtde ) AS vlr_frete
           , ( ( idl_da.vlr_base_dev           / idl_da.qtde ) * pn_cur_qtde ) AS vlr_base_dev
           , ( ( idl_da.vlr_base_a_recolher    / idl_da.qtde ) * pn_cur_qtde ) AS vlr_base_a_recolher
	      FROM imp_declaracoes_lin idl_da
           , imp_declaracoes_lin idl
	    WHERE idl.declaracao_lin_id = pn_cur_declaracao_lin_id
        AND idl.da_lin_id         = idl_da.declaracao_lin_id;

    CURSOR cur_perc_benef IS
      SELECT Nvl ((perc_afrmm_imp / 100), 0)
        FROM imp_param_ce_mercante;

    CURSOR cur_verif_benef_lin(pn_declaracao_lin_id NUMBER) IS
      SELECT beneficio_mercante_id
        FROM imp_declaracoes_lin
       WHERE declaracao_lin_id = pn_declaracao_lin_id;

    CURSOR cur_verif_benef_adi (pn_declaracao_adi_id NUMBER) IS
      SELECT beneficio_mercante_id
        FROM imp_declaracoes_adi
       WHERE declaracao_adi_id = pn_declaracao_adi_id;

--    CURSOR cur_param_dmm(pn_empresa_id NUMBER) IS
--      SELECT cnp.tp_rateio
--        FROM imp_empresas_param_dmm  iepd
--           , cmx_numerarios_param    cnp
--       WHERE iepd.numer_param_id = cnp.numer_param_id
--         AND iepd.empresa_id     = pn_empresa_id
--         AND cmx_pkg_tabelas.auxiliar(cnp.cd_numerario_id, 1) = 'AFRMM';

    CURSOR cur_param_dmm(pn_empresa_id NUMBER) IS
      SELECT cnp.tp_rateio_afrmm tp_rateio
        FROM imp_param_ce_mercante    cnp;
         

    CURSOR cur_embarque IS
      SELECT empresa_id
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_vlrt_ii_ipi(pn_invoice_lin_id NUMBER) IS
      SELECT Sum(Nvl(l.valor_ii,0) + Nvl(l.valor_ipi,0)) valor
        FROM imp_declaracoes_lin l
           , imp_declaracoes     d
       WHERE l.declaracao_id  = d.declaracao_id
         AND l.invoice_lin_id = pn_invoice_lin_id
         AND d.embarque_id    = pn_embarque_id
         AND Nvl(Upper(cmx_pkg_tabelas.auxiliar(l.fundamento_legal_id, 5)),'RATEAR') = 'RATEAR';

    CURSOR cur_vlrt_ii_ipi_lin(pn_declaracao_lin_id NUMBER) IS
      SELECT Sum(Nvl(valor_ii,0) + Nvl(valor_ipi,0)) valor
        FROM imp_declaracoes_lin
       WHERE declaracao_lin_id = pn_declaracao_lin_id;

    CURSOR cur_item_ratear IS
      SELECT Count(Decode( Nvl(Upper(cmx_pkg_tabelas.auxiliar(l.fundamento_legal_id, 5)),'RATEAR')
                         , 'RATEAR'
                         , '1'
                         , NULL
                         )
                  )       qtde_item_ratear
           , Count(1)     qtde_total
        FROM imp_declaracoes_lin l
           , imp_declaracoes     d
       WHERE l.declaracao_id  = d.declaracao_id
         AND d.embarque_id    = pn_embarque_id;

    CURSOR cur_qtde_itens(pn_invoice_lin_id NUMBER) IS
      SELECT Sum(idl.qtde) qtde
        FROM imp_invoices_lin     iil
           , imp_declaracoes_lin  idl
       WHERE iil.invoice_lin_id = idl.invoice_lin_id
         AND iil.invoice_lin_id = pn_invoice_lin_id
         AND Nvl(Upper(cmx_pkg_tabelas.auxiliar(idl.fundamento_legal_id, 5)),'RATEAR') = 'RATEAR';

    CURSOR cur_ratear_di_lin(pn_declaracao_lin_id NUMBER) IS
      SELECT declaracao_lin_id
        FROM imp_declaracoes_lin
       WHERE declaracao_lin_id = pn_declaracao_lin_id
         AND Nvl(Upper(cmx_pkg_tabelas.auxiliar(fundamento_legal_id, 5)),'RATEAR') = 'RATEAR';

    CURSOR cur_qtde_adi(pn_invoice_lin_id NUMBER) IS
      SELECT vlr_ref
        FROM (  SELECT (  1
                      / nullif(Count(DISTINCT ida.declaracao_adi_id) OVER (PARTITION BY ida.declaracao_id), 0)                          -- qtd total de adicoes
                      / nullif(Count(idlt.declaracao_lin_id)         OVER (PARTITION BY idlt.declaracao_id, idlt.declaracao_adi_id), 0) -- qtd linhas que a adicao esta
                      ) AS vlr_ref
                      , idlt.invoice_lin_id
                  FROM imp_declaracoes_adi  ida
                    , imp_declaracoes_lin  idlt
                    , imp_declaracoes_lin  idl
                WHERE idl.invoice_lin_id = pn_invoice_lin_id
                  AND idl.declaracao_id = idlt.declaracao_id
                  AND idlt.declaracao_adi_id = ida.declaracao_adi_id
                  AND Nvl(Upper(cmx_pkg_tabelas.auxiliar(idlt.fundamento_legal_id, 5)),'RATEAR') = 'RATEAR'
                  AND Nvl(Upper(cmx_pkg_tabelas.auxiliar(idl.fundamento_legal_id, 5)),'RATEAR') = 'RATEAR'
             ) tbl
        WHERE invoice_lin_id = pn_invoice_lin_id;

    CURSOR cur_aliq_ii_ipi_lin(pn_declaracao_adi_id NUMBER) IS
      SELECT adi.tp_acordo
           , cmx_pkg_tabelas.codigo(adi.regtrib_ii_id)  regtrib_ii
           , cmx_pkg_tabelas.codigo(adi.regtrib_ipi_id) regtrib_ipi
           , adi.perc_red_ii
           , adi.aliq_ii_acordo
           , adi.aliq_ii_dev
           , adi.aliq_ipi_dev
           , adi.aliq_ii_red
           , adi.aliq_ipi_red
        FROM imp_declaracoes_adi adi
       WHERE adi.declaracao_adi_id = pn_declaracao_adi_id;

    TYPE type_dcl_vlr_rateio      IS TABLE OF reg_dcl_vlr_rateio INDEX BY BINARY_INTEGER;
    tbl_dcl_vlr_rateio            type_dcl_vlr_rateio;

    vr_item_ratear                cur_item_ratear%ROWTYPE;
    vn_beneficio_mercante_id      imp_declaracoes_lin.beneficio_mercante_id%TYPE;
    vn_perc_afrmm                 imp_param_ce_mercante.perc_afrmm_imp%TYPE;
    vn_vlr_base_a_recolher        imp_declaracoes_lin.vlr_base_a_recolher%TYPE;
    vn_vlr_base_a_recolher_mn     NUMBER;
    vn_vlr_frete_afrmm            NUMBER;
    vn_vlr_frete_afrmm_mn         NUMBER;
    vn_valor_base_calc_afrmm      NUMBER;
    vn_valor_base_calc_afrmm_mn   NUMBER;
    vn_taxa_afrmm_mn              NUMBER;

    vn_embarque_id                NUMBER;
    vn_moeda_id_afrmm             NUMBER;
    vc_result                     VARCHAR2(150);
    vr_mod_despacho               cur_mod_despacho%ROWTYPE;

    vd_dt_afrmm                   DATE;

    vb_erro_taxa                  BOOLEAN := FALSE;
    vb_erro_data                  BOOLEAN := FALSE;

    vc_linhas_beneficio           VARCHAR2(32000);
    vb_beneficio_parcial          BOOLEAN := FALSE;

    vc_tp_rateio                  VARCHAR2(1);
    vb_dmm                        BOOLEAN := FALSE;

    vn_vrt_fob_ebq_m              NUMBER := 0;
    vn_vrt_cif_ii_ipi_m           NUMBER := 0;
    vn_pesoliq_tot                NUMBER := 0;
    vn_pesobrt_tot                NUMBER := 0;
    vn_vrt_aduaneiro              NUMBER := 0;
    vn_vrt_ref_adicao             NUMBER := 0;

    vn_vrt_fob_ebq_lin            NUMBER := 0;
    vn_vrt_cif_ii_ipi_lin         NUMBER := 0;
    vn_pesoliq_tot_lin            NUMBER := 0;
    vn_pesobrt_tot_lin            NUMBER := 0;
    vn_valor_aduaneiro_lin        NUMBER := 0;
    vn_empresa_id                 NUMBER := 0;
    vn_vrt_ref_adicao_lin         NUMBER := 0;
    vn_vlrt_ii_ipi                NUMBER := 0;

    vn_taxa_usd                   NUMBER := 0;
    vn_paridade_usd               NUMBER := 0;
    vn_qtde_itens                 NUMBER := 0;
    vn_dummy                      NUMBER := 0;
    vn_vlr_ref                    NUMBER := 0;
    vn_soma_total_frt             NUMBER := 0;
    vn_diferenca_frt              NUMBER := 0;
    vn_soma_base_calc_afrmm       NUMBER := 0;
    vn_soma_base_a_recolher_afrmm NUMBER := 0;
    vn_dif_base_afrmm             NUMBER := 0;
    vn_dif_base_a_recolher_afrmm  NUMBER := 0;
    vb_ratear_td_itens            BOOLEAN := FALSE;
    vb_ratear                     BOOLEAN := FALSE;

    vn_ii_valor                   NUMBER := 0;
    vn_ipi_valor                  NUMBER := 0;
    vn_aliq_ii                    NUMBER := 0;
    vn_aliq_ipi                   NUMBER := 0;
    vn_lin_cif_ii_ipi_m           NUMBER := 0;
    vn_aliq_ii_dev                NUMBER := 0;
    vr_cur_aliq_ii_ipi_lin        cur_aliq_ii_ipi_lin%ROWTYPE;

    PROCEDURE p_prc_converter_moeda_nacional( pd_dt_afrmm                      DATE
                                            , pn_vlr_base_dev_mn        IN OUT NUMBER
                                            , pn_vlr_base_a_recolher_mn IN OUT NUMBER
                                            , pn_moeda_id_afrmm                NUMBER
                                            , pc_result                    OUT VARCHAR2 ) IS

    /* Deve-se aplicar a taxa de conversão para reais seguindo a taxa FISCAL na data realizada do pagamento do AFRMM informada no cronograma do embarque.
       O que identifica a data de pagamento é a data inserida no cronograma do embarque cujo atributo 8 = AFRMM.
    */

      CURSOR cur_licen IS
        SELECT 1
          FROM imp_licencas il
         WHERE embarque_id = pn_embarque_id
           AND nr_registro IS NULL;

      vn_aux              NUMBER;
      vn_taxa_moeda_afrmm NUMBER;

      vn_vlr_base_dev_mn        NUMBER;
      vn_vlr_base_a_recolher_mn NUMBER;

    BEGIN

      pc_result                 := 'SUCESSO';
      vn_vlr_base_dev_mn        := NULL;
      vn_vlr_base_a_recolher_mn := NULL;

      IF(  Nvl( pn_vlr_base_dev_mn       , 0 ) <> 0
        OR Nvl( pn_vlr_base_a_recolher_mn, 0 ) <> 0 )THEN

        IF( pd_dt_afrmm IS NULL )THEN

            OPEN cur_licen;
            FETCH cur_licen INTO vn_aux;
            CLOSE cur_licen;

            /* Retirar a trava de data de pagamento de AFRMM quando existirem linhas de licença não registradas (exemplo, drawback, PEXPAM, ZFM). */
            IF(vn_aux IS NULL)THEN
              pc_result := 'ERRO_DATA';
            END IF;

        ELSE
          vn_taxa_moeda_afrmm := cmx_pkg_taxas.fnc_taxa_mn_opcional (pn_moeda_id_afrmm, pd_dt_afrmm, 'FISCAL');

          IF( vn_taxa_moeda_afrmm IS NULL )THEN
            pc_result := 'ERRO_TAXA';

          ELSE

            vn_vlr_base_dev_mn        := pn_vlr_base_dev_mn        * vn_taxa_moeda_afrmm;
            vn_vlr_base_a_recolher_mn := pn_vlr_base_a_recolher_mn * vn_taxa_moeda_afrmm;

          END IF;

        END IF;

      END IF;

      pn_vlr_base_dev_mn        := vn_vlr_base_dev_mn;
      pn_vlr_base_a_recolher_mn := vn_vlr_base_a_recolher_mn;

    END p_prc_converter_moeda_nacional;

  BEGIN

    /*
    Modalidades de despacho:
    1 - Normal
    2 - Antecipado
    3 - Simplificado
    4 - Antecipado e simplificado
    5 - Entrega fracionada
    6 - Antecipado com entrega fracionada
    */
    OPEN cur_mod_despacho;
    FETCH cur_mod_despacho INTO vr_mod_despacho;
    CLOSE cur_mod_despacho;

    --INICIO Jira - NSI-436
    OPEN  cur_embarque;
    FETCH cur_embarque INTO vn_empresa_id;
    CLOSE cur_embarque;

    OPEN  cur_param_dmm(vn_empresa_id);
    FETCH cur_param_dmm INTO vc_tp_rateio;
    vb_dmm := cur_param_dmm%FOUND;
    CLOSE cur_param_dmm;

    IF(vc_tp_rateio IS NULL) THEN
      vc_tp_rateio := 'P';
    END IF;

    imp_prc_busca_taxa_conversao ( cmx_pkg_tabelas.tabela_id ('906', 'USD')
                                 , pd_data_conversao
                                 , vn_taxa_usd
                                 , vn_paridade_usd
                                 , 'Taxa US AFRMM (imp_prc_calcula_afrmm).'
                                 );

    vb_ratear_td_itens := FALSE;
    OPEN  cur_item_ratear;
    FETCH cur_item_ratear INTO vr_item_ratear;
    CLOSE cur_item_ratear;

    IF(Nvl(vr_item_ratear.qtde_item_ratear,0) = Nvl(vr_item_ratear.qtde_total,0) OR Nvl(vr_item_ratear.qtde_item_ratear,0) = 0) THEN
      vb_ratear_td_itens := TRUE;
    END IF;

    --FIM Jira - NSI-436

    IF  ( cmx_fnc_profile('UTILIZA_AFRMM')             = 'S'                )
    AND ( Nvl(vc_global_verif_di_unica, '*')          <> 'DI_UNICA'         )
    AND ( vc_global_via_transporte                    IN ('01', '02', '03') )
    AND ( pn_tp_declaracao                        NOT IN ('04', '16')       )
    AND (  vr_mod_despacho.mde_despacho           NOT IN ('2' , '4', '6')
        OR vr_mod_despacho.retif_flag_calc_afrmm  = 'S'                     ) THEN

      vn_vlr_frete_afrmm  := 0;
      vn_moeda_id_afrmm   := NULL;
      vc_linhas_beneficio := NULL;
      vd_dt_afrmm         := Trunc( imp_fnc_datas_cronogramas( pn_embarque_id, cmx_pkg_tabelas.auxiliar_tabela_id('131', 'AFRMM', '8'), 'R' ) );

      vn_perc_afrmm := 0;
      OPEN cur_perc_benef;
      FETCH cur_perc_benef INTO vn_perc_afrmm;
      CLOSE cur_perc_benef;

      /* NACIONALIZACOES*/
      IF (Nvl(vc_global_verif_di_unica, '*') = 'NAC') THEN

        OPEN cur_embarque_nac;
        FETCH cur_embarque_nac INTO vn_embarque_id;
        CLOSE cur_embarque_nac;

        -- Reutilizado o cursor para buscar a moeda_id. O valor do frete não será utilizado
        OPEN  cur_vlr_frete_afrmm( vn_embarque_id, vd_dt_afrmm );
        FETCH cur_vlr_frete_afrmm INTO vn_vlr_frete_afrmm
                                     , vn_moeda_id_afrmm;
        CLOSE cur_vlr_frete_afrmm;

        FOR dcl IN 1..vn_global_dcl_lin LOOP

          tb_dcl_lin(dcl).vlr_frete_afrmm         := 0;
          tb_dcl_lin(dcl).vlr_base_dev            := 0;
          tb_dcl_lin(dcl).vlr_base_a_recolher     := 0;
          tb_dcl_lin(dcl).vlr_base_dev_mn         := 0;
          tb_dcl_lin(dcl).vlr_base_a_recolher_mn  := 0;

          OPEN cur_vlr_afrmm_nac ( tb_dcl_lin(dcl).declaracao_lin_id
                                 , tb_dcl_lin(dcl).qtde );
          FETCH cur_vlr_afrmm_nac INTO tb_dcl_lin(dcl).vlr_frete_afrmm
                                     , tb_dcl_lin(dcl).vlr_base_dev
                                     , tb_dcl_lin(dcl).vlr_base_a_recolher;
          CLOSE cur_vlr_afrmm_nac;

          vn_beneficio_mercante_id := NULL;
          OPEN  cur_verif_benef_lin (tb_dcl_lin(dcl).declaracao_lin_id);
          FETCH cur_verif_benef_lin INTO vn_beneficio_mercante_id;
          CLOSE cur_verif_benef_lin;

          IF (vn_beneficio_mercante_id IS NOT NULL) THEN
            tb_dcl_lin(dcl).vlr_base_a_recolher := 0;
            vc_linhas_beneficio                 := vc_linhas_beneficio||tb_dcl_lin(dcl).linha_num||', ';
          ELSE
            tb_dcl_lin(dcl).vlr_base_a_recolher := tb_dcl_lin(dcl).vlr_frete_afrmm * vn_perc_afrmm;
            vb_beneficio_parcial                := TRUE;
          END IF;

          tb_dcl_lin(dcl).vlr_base_dev_mn        := tb_dcl_lin(dcl).vlr_base_dev;
          tb_dcl_lin(dcl).vlr_base_a_recolher_mn := tb_dcl_lin(dcl).vlr_base_a_recolher;

          p_prc_converter_moeda_nacional( pd_dt_afrmm               => vd_dt_afrmm
                                        , pn_vlr_base_dev_mn        => tb_dcl_lin(dcl).vlr_base_dev_mn
                                        , pn_vlr_base_a_recolher_mn => tb_dcl_lin(dcl).vlr_base_a_recolher_mn
                                        , pn_moeda_id_afrmm         => vn_moeda_id_afrmm
                                        , pc_result                 => vc_result );

          -- Arredondar com 2 decimais pois os valores serão base para numerário de AFRMM
          tb_dcl_lin(dcl).vlr_frete_afrmm         := Round(Nvl(tb_dcl_lin(dcl).vlr_frete_afrmm,0)       , 2);
          tb_dcl_lin(dcl).vlr_base_dev            := Round(Nvl(tb_dcl_lin(dcl).vlr_base_dev,0)          , 2);
          tb_dcl_lin(dcl).vlr_base_dev_mn         := Round(Nvl(tb_dcl_lin(dcl).vlr_base_dev_mn,0)       , 2);
          tb_dcl_lin(dcl).vlr_base_a_recolher     := Round(Nvl(tb_dcl_lin(dcl).vlr_base_a_recolher,0)   , 2);
          tb_dcl_lin(dcl).vlr_base_a_recolher_mn  := Round(Nvl(tb_dcl_lin(dcl).vlr_base_a_recolher_mn,0), 2);

          IF( vc_result = 'ERRO_TAXA' )THEN
            vb_erro_taxa := TRUE;
          ELSIF( vc_result = 'ERRO_DATA' )THEN
            vb_erro_data := TRUE;
          END IF;

        END LOOP;

        FOR adi IN 1..vn_global_dcl_adi LOOP

          tb_dcl_adi(adi).vlr_frete_afrmm        := 0;
          tb_dcl_adi(adi).vlr_base_dev           := 0;
          tb_dcl_adi(adi).vlr_base_a_recolher    := 0;
          tb_dcl_adi(adi).vlr_base_dev_mn        := 0;
          tb_dcl_adi(adi).vlr_base_a_recolher_mn := 0;

          FOR dcl IN 1..vn_global_dcl_lin LOOP

            IF( tb_dcl_lin(dcl).declaracao_adi_id = tb_dcl_adi(adi).declaracao_adi_id )THEN
              -- Não foi feito arredondamento pois é apenas a soma das linhas já arredondadas
              tb_dcl_adi(adi).vlr_frete_afrmm        := tb_dcl_adi(adi).vlr_frete_afrmm        + tb_dcl_lin(dcl).vlr_frete_afrmm       ;
              tb_dcl_adi(adi).vlr_base_dev           := tb_dcl_adi(adi).vlr_base_dev           + tb_dcl_lin(dcl).vlr_base_dev          ;
              tb_dcl_adi(adi).vlr_base_a_recolher    := tb_dcl_adi(adi).vlr_base_a_recolher    + tb_dcl_lin(dcl).vlr_base_a_recolher   ;
              tb_dcl_adi(adi).vlr_base_dev_mn        := tb_dcl_adi(adi).vlr_base_dev_mn        + tb_dcl_lin(dcl).vlr_base_dev_mn       ;
              tb_dcl_adi(adi).vlr_base_a_recolher_mn := tb_dcl_adi(adi).vlr_base_a_recolher_mn + tb_dcl_lin(dcl).vlr_base_a_recolher_mn;

            END IF;

          END LOOP;

        END LOOP;

      ELSE

        OPEN  cur_vlr_frete_afrmm( pn_embarque_id, vd_dt_afrmm );
        FETCH cur_vlr_frete_afrmm INTO vn_vlr_frete_afrmm
                                     , vn_moeda_id_afrmm;
        CLOSE cur_vlr_frete_afrmm;

        vn_valor_base_calc_afrmm := vn_vlr_frete_afrmm * vn_perc_afrmm;
        vn_taxa_afrmm_mn := cmx_pkg_taxas.fnc_taxa_mn_opcional (vn_moeda_id_afrmm, vd_dt_afrmm, 'FISCAL');
        vn_vlr_frete_afrmm_mn := vn_vlr_frete_afrmm * vn_taxa_afrmm_mn;
        vn_valor_base_calc_afrmm_mn := vn_vlr_frete_afrmm_mn * vn_perc_afrmm;

        --INICIO Jira - NSI-436
        FOR ivcR IN 1..vn_global_ivc_lin LOOP

          vn_qtde_itens := nvl (tb_ivc_lin(ivcR).qtde, 0);
          vn_vlr_ref    := imp_fnc_valor_ref_adicoes (NULL, tb_ivc_lin(ivcR).invoice_lin_id);

----------spt          IF NOT(vb_ratear_td_itens) THEN
----------spt
----------spt            vn_qtde_itens := 0;
----------spt            OPEN cur_qtde_itens(tb_ivc_lin(ivcR).invoice_lin_id);
----------spt            FETCH cur_qtde_itens INTO vn_qtde_itens;
----------spt            CLOSE cur_qtde_itens;
----------spt
----------spt            OPEN  cur_qtde_adi(tb_ivc_lin(ivcR).invoice_lin_id);
----------spt            FETCH cur_qtde_adi INTO vn_vlr_ref;
----------spt            CLOSE cur_qtde_adi;
----------spt
----------spt          END IF;

          IF(Nvl(vn_qtde_itens,0) > 0) THEN
            vn_vrt_fob_ebq_m    := Nvl(vn_vrt_fob_ebq_m,0) + ( ( ( nvl (tb_ivc_lin(ivcR).vrt_fob_m, 0) +
                                                                  nvl (tb_ivc_lin(ivcR).vrt_dspfob_m, 0)
                                                                ) / nvl (tb_ivc_lin(ivcR).qtde, 0)
                                                              ) * Nvl(vn_qtde_itens,0)
                                                            );

            /*Valor IPI e II da linha da declaração*/

  --          FOR dclC IN 1..vn_global_dcl_lin LOOP
  --            IF tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dclC).invoice_lin_id THEN
  --              vn_vrt_cif_ii_ipi_m := vn_vrt_cif_ii_ipi_m                 +
  --                                      nvl(tb_dcl_lin(dclC).valor_ii  ,0) +
  --                                      nvl(tb_dcl_lin(dclC).valor_ipi ,0) ;
  --            END IF;
  --          END LOOP;

            vn_vlrt_ii_ipi      := 0;
            vn_lin_cif_ii_ipi_m := 0;
--            OPEN  cur_vlrt_ii_ipi(tb_ivc_lin(ivcR).invoice_lin_id);
--            FETCH cur_vlrt_ii_ipi INTO vn_vlrt_ii_ipi;
--            CLOSE cur_vlrt_ii_ipi;

--            vn_vlrt_ii_ipi := vn_vlrt_ii_ipi / vn_taxa_usd;

            vn_vrt_cif_ii_ipi_m := vn_vrt_cif_ii_ipi_m + ( ( ( nvl(tb_ivc_lin(ivcR).vrt_fob_m,0)    +
                                                               nvl(tb_ivc_lin(ivcR).vrt_dspfob_m,0) +
                                                               nvl(tb_ivc_lin(ivcR).vrt_fr_m,0)     +
                                                               nvl(tb_ivc_lin(ivcR).vrt_sg_m,0)
                                                             ) / nvl (tb_ivc_lin(ivcR).qtde, 0)
                                                           )  * Nvl(vn_qtde_itens,0)
                                                        );

            vn_lin_cif_ii_ipi_m := ( ( (  ( nvl(tb_ivc_lin(ivcR).vrt_fob_m,0)    +
                                            nvl(tb_ivc_lin(ivcR).vrt_dspfob_m,0) +
                                            nvl(tb_ivc_lin(ivcR).vrt_fr_m,0)     +
                                            nvl(tb_ivc_lin(ivcR).vrt_sg_m,0)     +
                                            nvl(tb_ivc_lin(ivcR).vrt_acres_m,0)
                                           ) - nvl(tb_ivc_lin(ivcR).vrt_ded_m,0)
                                       ) / nvl (tb_ivc_lin(ivcR).qtde, 0)
                                     )  * Nvl(vn_qtde_itens,0)
                                   );

            --vn_vrt_cif_ii_ipi_m := vn_vrt_cif_ii_ipi_m + Nvl(vn_vlrt_ii_ipi,0);
            FOR dclC IN 1..vn_global_dcl_lin LOOP
              IF tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dclC).invoice_lin_id THEN

                vn_ii_valor     := 0;
                vn_ipi_valor    := 0;
                vn_aliq_ii      := 0;
                vn_aliq_ipi     := 0;
                vn_aliq_ii_dev  := 0;
                --

                OPEN  cur_aliq_ii_ipi_lin(tb_dcl_lin(dclC).declaracao_adi_id);
                FETCH cur_aliq_ii_ipi_lin INTO vr_cur_aliq_ii_ipi_lin;
                CLOSE cur_aliq_ii_ipi_lin;

                --Aliq. II
                IF     (vr_cur_aliq_ii_ipi_lin.tp_acordo IS NOT null)
                  AND (   (vr_cur_aliq_ii_ipi_lin.regtrib_ii IN ('1', '5'))
                        OR (vr_cur_aliq_ii_ipi_lin.regtrib_ii = '4' AND vr_cur_aliq_ii_ipi_lin.perc_red_ii > 0)
                      )
                THEN
                  vn_aliq_ii_dev := nvl (vr_cur_aliq_ii_ipi_lin.aliq_ii_acordo, 0);
                ELSE
                  vn_aliq_ii_dev := vr_cur_aliq_ii_ipi_lin.aliq_ii_dev;
                END IF;

                IF (vr_cur_aliq_ii_ipi_lin.regtrib_ii = '4') THEN -- REDUÇÃO
                  IF (vr_cur_aliq_ii_ipi_lin.perc_red_ii > 0) Then
                    vn_aliq_ii := vn_aliq_ii_dev - (vn_aliq_ii_dev * (vr_cur_aliq_ii_ipi_lin.perc_red_ii / 100));
                  ELSE
                    vn_aliq_ii := vr_cur_aliq_ii_ipi_lin.aliq_ii_red;
                  END IF;

                ELSIF (vr_cur_aliq_ii_ipi_lin.regtrib_ii = '1') THEN  -- INTEGRAL

                  IF (vr_cur_aliq_ii_ipi_lin.tp_acordo IS NOT null) THEN
                    vn_aliq_ii := nvl (vr_cur_aliq_ii_ipi_lin.aliq_ii_acordo, 0);
                  ELSE
                    vn_aliq_ii := vn_aliq_ii_dev;
                  END IF;

                ELSIF (vr_cur_aliq_ii_ipi_lin.regtrib_ii IN ('7','8')) THEN  -- TRIB.SIMPL., TRIB.SIMPL.BAGAGEM
                  vn_aliq_ii := vn_aliq_ii_dev;
                END IF;

                --Aliq. IPI
                IF    (vr_cur_aliq_ii_ipi_lin.regtrib_ipi = '2') Then     -- REDUCAO
                  vn_aliq_ipi := vr_cur_aliq_ii_ipi_lin.aliq_ipi_red;
                ELSIF (vr_cur_aliq_ii_ipi_lin.regtrib_ipi = '4') Then     -- INTEGRAL
                  vn_aliq_ipi := vr_cur_aliq_ii_ipi_lin.aliq_ipi_dev;
                END IF;
                --

                vn_ii_valor         := Round(Nvl(vn_lin_cif_ii_ipi_m,0) * (Nvl(vn_aliq_ii,0) / 100),2);
                vn_ipi_valor        := Round((Nvl(vn_lin_cif_ii_ipi_m,0) + Nvl(vn_ii_valor,0)) * (Nvl(vn_aliq_ipi,0) / 100),2);

                vn_vrt_cif_ii_ipi_m := vn_vrt_cif_ii_ipi_m + Nvl(vn_ii_valor,0) + Nvl(vn_ipi_valor,0);
              END IF;
            END LOOP;

            vn_pesoliq_tot      := vn_pesoliq_tot + ( ( tb_ivc_lin(ivcR).pesoliq_tot / nvl (tb_ivc_lin(ivcR).qtde, 0)) * Nvl(vn_qtde_itens,0) );
            vn_pesobrt_tot      := vn_pesobrt_tot + ( ( tb_ivc_lin(ivcR).pesobrt_tot / nvl (tb_ivc_lin(ivcR).qtde, 0)) * Nvl(vn_qtde_itens,0) );

            vn_vrt_aduaneiro  := vn_vrt_aduaneiro + ( ( ( nvl (tb_ivc_lin(ivcR).vmle_m  , 0)    +
                                                          nvl (tb_ivc_lin(ivcR).vrt_fr_m,  0)    +
                                                          nvl (tb_ivc_lin(ivcR).vrt_sg_m,  0)
                                                        ) / nvl (tb_ivc_lin(ivcR).qtde, 0)
                                                      )  * Nvl(vn_qtde_itens,0)
                                                    );

            vn_vrt_ref_adicao := vn_vrt_ref_adicao + Nvl(vn_vlr_ref,0);
          END IF;

        END LOOP;
        --FIM Jira - NSI-436

        vn_soma_total_frt             := 0;
        vn_soma_base_calc_afrmm       := 0;
        vn_soma_base_a_recolher_afrmm := 0;

        FOR dcl IN 1..vn_global_dcl_lin LOOP
          vn_beneficio_mercante_id := NULL;
          vn_vlr_frete             := 0;
          vn_vlr_base_dev          := 0;
          vn_vlr_base_a_recolher   := 0;
          vn_vlr_base_dev_mn       := 0;
          vn_vlr_base_a_recolher_mn:= 0;
          vb_ratear                := FALSE;

          --INICIO Jira - NSI-436
          tbl_dcl_vlr_rateio(dcl).declaracao_lin_id := tb_dcl_lin(dcl).declaracao_lin_id;
          tbl_dcl_vlr_rateio(dcl).declaracao_adi_id := tb_dcl_lin(dcl).declaracao_adi_id;
          tbl_dcl_vlr_rateio(dcl).invoice_lin_id    := tb_dcl_lin(dcl).invoice_lin_id;
          tbl_dcl_vlr_rateio(dcl).vlrt_fob          := 0;
          tbl_dcl_vlr_rateio(dcl).vlrt_cif_ii_ipi   := 0;
          tbl_dcl_vlr_rateio(dcl).tot_pesoliq       := 0;
          tbl_dcl_vlr_rateio(dcl).vlrt_aduaneiro    := 0;
          tbl_dcl_vlr_rateio(dcl).vlrt_adicao       := 0;

-----------spt          IF NOT(vb_ratear_td_itens) THEN
-----------spt            OPEN  cur_ratear_di_lin(tb_dcl_lin(dcl).declaracao_lin_id);
-----------spt            FETCH cur_ratear_di_lin INTO vn_dummy;
-----------spt            vb_ratear := cur_ratear_di_lin%FOUND;
-----------spt            CLOSE cur_ratear_di_lin;
-----------spt          ELSE
-----------spt            vb_ratear := TRUE;
-----------spt          END IF;
-----------spt
-----------spt          IF(vb_ratear) THEN
            OPEN  cur_verif_benef_lin (tb_dcl_lin(dcl).declaracao_lin_id);
            FETCH cur_verif_benef_lin INTO vn_beneficio_mercante_id;
            CLOSE cur_verif_benef_lin;

            IF (vn_beneficio_mercante_id IS NOT NULL) THEN
              vn_vlr_base_a_recolher := 0;
              vn_vlr_base_a_recolher_mn := 0;
              vc_linhas_beneficio    := vc_linhas_beneficio||tb_dcl_lin(dcl).linha_num||', ';
            ELSE
              vn_vlr_base_a_recolher := vn_valor_base_calc_afrmm;
              vn_vlr_base_a_recolher_mn := vn_valor_base_calc_afrmm_mn;
              vb_beneficio_parcial   := TRUE;
            END IF;

            IF (vc_tp_rateio = 'F') THEN

              vn_vrt_fob_ebq_lin := 0;
              FOR ivcR IN 1..vn_global_ivc_lin LOOP
                IF(tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id) THEN
                  vn_vrt_fob_ebq_lin := ((nvl (tb_ivc_lin(ivcR).vrt_fob_m, 0) + nvl (tb_ivc_lin(ivcR).vrt_dspfob_m, 0)) / Nvl(tb_ivc_lin(ivcR).qtde,0)) * Nvl(tb_dcl_lin(dcl).qtde,0);
                END IF;
              END LOOP;
              tbl_dcl_vlr_rateio(dcl).vlrt_fob := vn_vrt_fob_ebq_lin;

              vn_vlr_frete           := (vn_vlr_frete_afrmm / vn_vrt_fob_ebq_m) * vn_vrt_fob_ebq_lin;
              vn_vlr_base_dev        := (vn_valor_base_calc_afrmm / vn_vrt_fob_ebq_m) * vn_vrt_fob_ebq_lin;
              vn_vlr_base_a_recolher := (vn_vlr_base_a_recolher / vn_vrt_fob_ebq_m) * vn_vrt_fob_ebq_lin;
              vn_vlr_base_dev_mn        := (vn_valor_base_calc_afrmm_mn / vn_vrt_fob_ebq_m) * vn_vrt_fob_ebq_lin;
              vn_vlr_base_a_recolher_mn := (vn_vlr_base_a_recolher_mn / vn_vrt_fob_ebq_m) * vn_vrt_fob_ebq_lin;
            ELSIF (vc_tp_rateio = 'C') THEN

              vn_vrt_cif_ii_ipi_lin := 0;
              vn_lin_cif_ii_ipi_m   := 0;

              FOR ivcR IN 1..vn_global_ivc_lin LOOP
                IF(tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id) THEN
                  vn_vrt_cif_ii_ipi_lin := (( nvl(tb_ivc_lin(ivcR).vrt_fob_m,0)    +
                                              nvl(tb_ivc_lin(ivcR).vrt_dspfob_m,0) +
                                              nvl(tb_ivc_lin(ivcR).vrt_fr_m,0)     +
                                              nvl(tb_ivc_lin(ivcR).vrt_sg_m,0)
                                            ) / Nvl(tb_ivc_lin(ivcR).qtde,0)) * Nvl(tb_dcl_lin(dcl).qtde,0);

                  vn_lin_cif_ii_ipi_m := ( ( (  ( nvl(tb_ivc_lin(ivcR).vrt_fob_m,0)    +
                                                  nvl(tb_ivc_lin(ivcR).vrt_dspfob_m,0) +
                                                  nvl(tb_ivc_lin(ivcR).vrt_fr_m,0)     +
                                                  nvl(tb_ivc_lin(ivcR).vrt_sg_m,0)     +
                                                  nvl(tb_ivc_lin(ivcR).vrt_acres_m,0)
                                                ) - nvl(tb_ivc_lin(ivcR).vrt_ded_m,0)
                                            ) / nvl (tb_ivc_lin(ivcR).qtde, 0)
                                          )  * Nvl(vn_qtde_itens,0)
                                        );
                END IF;
              END LOOP;
--             vn_vrt_cif_ii_ipi_lin                   := vn_vrt_cif_ii_ipi_lin             +
--                                                       nvl(tb_dcl_lin(dcl).valor_ii  ,0) +
--                                                       nvl(tb_dcl_lin(dcl).valor_ipi ,0);
--              vn_vlrt_ii_ipi := 0;
--              OPEN  cur_vlrt_ii_ipi_lin(tb_dcl_lin(dcl).declaracao_lin_id);
--              FETCH cur_vlrt_ii_ipi_lin INTO vn_vlrt_ii_ipi;
--              CLOSE cur_vlrt_ii_ipi_lin;

--              vn_vlrt_ii_ipi := vn_vlrt_ii_ipi / vn_taxa_usd;

              vn_ii_valor     := 0;
              vn_ipi_valor    := 0;
              vn_aliq_ii      := 0;
              vn_aliq_ipi     := 0;
              vn_aliq_ii_dev  := 0;
              --

              OPEN  cur_aliq_ii_ipi_lin(tb_dcl_lin(dcl).declaracao_adi_id);
              FETCH cur_aliq_ii_ipi_lin INTO vr_cur_aliq_ii_ipi_lin;
              CLOSE cur_aliq_ii_ipi_lin;

              --Aliq. II
              IF     (vr_cur_aliq_ii_ipi_lin.tp_acordo IS NOT null)
                AND (   (vr_cur_aliq_ii_ipi_lin.regtrib_ii IN ('1', '5'))
                      OR (vr_cur_aliq_ii_ipi_lin.regtrib_ii = '4' AND vr_cur_aliq_ii_ipi_lin.perc_red_ii > 0)
                    )
              THEN
                vn_aliq_ii_dev := nvl (vr_cur_aliq_ii_ipi_lin.aliq_ii_acordo, 0);
              ELSE
                vn_aliq_ii_dev := vr_cur_aliq_ii_ipi_lin.aliq_ii_dev;
              END IF;

              IF (vr_cur_aliq_ii_ipi_lin.regtrib_ii = '4') THEN -- REDUÇÃO
                IF (vr_cur_aliq_ii_ipi_lin.perc_red_ii > 0) Then
                  vn_aliq_ii := vn_aliq_ii_dev - (vn_aliq_ii_dev * (vr_cur_aliq_ii_ipi_lin.perc_red_ii / 100));
                ELSE
                  vn_aliq_ii := vr_cur_aliq_ii_ipi_lin.aliq_ii_red;
                END IF;

              ELSIF (vr_cur_aliq_ii_ipi_lin.regtrib_ii = '1') THEN  -- INTEGRAL

                IF (vr_cur_aliq_ii_ipi_lin.tp_acordo IS NOT null) THEN
                  vn_aliq_ii := nvl (vr_cur_aliq_ii_ipi_lin.aliq_ii_acordo, 0);
                ELSE
                  vn_aliq_ii := vn_aliq_ii_dev;
                END IF;

              ELSIF (vr_cur_aliq_ii_ipi_lin.regtrib_ii IN ('7','8')) THEN  -- TRIB.SIMPL., TRIB.SIMPL.BAGAGEM
                vn_aliq_ii := vn_aliq_ii_dev;
              END IF;

              --Aliq. IPI
              IF    (vr_cur_aliq_ii_ipi_lin.regtrib_ipi = '2') Then     -- REDUCAO
                vn_aliq_ipi := vr_cur_aliq_ii_ipi_lin.aliq_ipi_red;
              ELSIF (vr_cur_aliq_ii_ipi_lin.regtrib_ipi = '4') Then     -- INTEGRAL
                vn_aliq_ipi := vr_cur_aliq_ii_ipi_lin.aliq_ipi_dev;
              END IF;
              --

              vn_ii_valor         := Round(Nvl(vn_lin_cif_ii_ipi_m,0) * (Nvl(vn_aliq_ii,0) / 100),2);
              vn_ipi_valor        := Round((Nvl(vn_lin_cif_ii_ipi_m,0) + Nvl(vn_ii_valor,0)) * (Nvl(vn_aliq_ipi,0) / 100),2);

              vn_vrt_cif_ii_ipi_lin := vn_vrt_cif_ii_ipi_lin + Nvl(vn_ii_valor,0) + Nvl(vn_ipi_valor,0);
              --vn_vrt_cif_ii_ipi_lin := vn_vrt_cif_ii_ipi_lin + vn_vlrt_ii_ipi;
              tbl_dcl_vlr_rateio(dcl).vlrt_cif_ii_ipi := vn_vrt_cif_ii_ipi_lin;

              vn_vlr_frete           := (vn_vlr_frete_afrmm / vn_vrt_cif_ii_ipi_m) * vn_vrt_cif_ii_ipi_lin;
              vn_vlr_base_dev        := (vn_valor_base_calc_afrmm / vn_vrt_cif_ii_ipi_m) * vn_vrt_cif_ii_ipi_lin;
              vn_vlr_base_a_recolher := (vn_vlr_base_a_recolher / vn_vrt_cif_ii_ipi_m) * vn_vrt_cif_ii_ipi_lin;
              vn_vlr_base_dev_mn        := (vn_valor_base_calc_afrmm_mn / vn_vrt_cif_ii_ipi_m) * vn_vrt_cif_ii_ipi_lin;
              vn_vlr_base_a_recolher_mn := (vn_vlr_base_a_recolher_mn / vn_vrt_cif_ii_ipi_m) * vn_vrt_cif_ii_ipi_lin;

            ELSIF (vc_tp_rateio = 'P') THEN

              vn_pesoliq_tot_lin := 0;
              FOR ivcR IN 1..vn_global_ivc_lin LOOP
                IF(tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id) THEN
                  vn_pesoliq_tot_lin := (tb_ivc_lin(ivcR).pesoliq_tot / Nvl(tb_ivc_lin(ivcR).qtde,0)) * Nvl(tb_dcl_lin(dcl).qtde,0);
                END IF;
              END LOOP;
              tbl_dcl_vlr_rateio(dcl).tot_pesoliq := vn_pesoliq_tot_lin;

              vn_vlr_frete           := (vn_vlr_frete_afrmm / vn_pesoliq_tot) * vn_pesoliq_tot_lin;
              vn_vlr_base_dev        := (vn_valor_base_calc_afrmm / vn_pesoliq_tot) * vn_pesoliq_tot_lin;
              vn_vlr_base_a_recolher := (vn_vlr_base_a_recolher / vn_pesoliq_tot) * vn_pesoliq_tot_lin;
              vn_vlr_base_dev_mn        := (vn_valor_base_calc_afrmm_mn / vn_pesoliq_tot) * vn_pesoliq_tot_lin;
              vn_vlr_base_a_recolher_mn := (vn_vlr_base_a_recolher_mn / vn_pesoliq_tot) * vn_pesoliq_tot_lin;

            ELSIF (vc_tp_rateio = 'B') THEN

              vn_pesobrt_tot_lin := 0;
              FOR ivcR IN 1..vn_global_ivc_lin LOOP
                IF(tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id) THEN
                  vn_pesobrt_tot_lin := (tb_ivc_lin(ivcR).pesobrt_tot / Nvl(tb_ivc_lin(ivcR).qtde,0)) * Nvl(tb_dcl_lin(dcl).qtde,0);
                END IF;
              END LOOP;
              tbl_dcl_vlr_rateio(dcl).tot_pesobrt := vn_pesobrt_tot_lin;

              vn_vlr_frete           := (vn_vlr_frete_afrmm / vn_pesobrt_tot) * vn_pesobrt_tot_lin;
              vn_vlr_base_dev        := (vn_valor_base_calc_afrmm / vn_pesobrt_tot) * vn_pesobrt_tot_lin;
              vn_vlr_base_a_recolher := (vn_vlr_base_a_recolher / vn_pesobrt_tot) * vn_pesobrt_tot_lin;
              vn_vlr_base_dev_mn        := (vn_valor_base_calc_afrmm_mn / vn_pesobrt_tot) * vn_pesobrt_tot_lin;
              vn_vlr_base_a_recolher_mn := (vn_vlr_base_a_recolher_mn / vn_pesobrt_tot) * vn_pesobrt_tot_lin;

            ELSIF (vc_tp_rateio = 'A') THEN

              vn_valor_aduaneiro_lin := 0;
              FOR ivcR IN 1..vn_global_ivc_lin LOOP
                IF(tb_ivc_lin(ivcR).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id) THEN
                  vn_valor_aduaneiro_lin := (( nvl (tb_ivc_lin(ivcR).vmle_m  , 0)    +
                                              nvl (tb_ivc_lin(ivcR).vrt_fr_m,  0)    +
                                              nvl (tb_ivc_lin(ivcR).vrt_sg_m,  0)
                                            ) / Nvl(tb_ivc_lin(ivcR).qtde,0) ) * Nvl(tb_dcl_lin(dcl).qtde,0);
                END IF;
              END LOOP;
              tbl_dcl_vlr_rateio(dcl).vlrt_aduaneiro := vn_valor_aduaneiro_lin;

              vn_vlr_frete           := (vn_vlr_frete_afrmm / vn_vrt_aduaneiro) * vn_valor_aduaneiro_lin;
              vn_vlr_base_dev        := (vn_valor_base_calc_afrmm / vn_vrt_aduaneiro) * vn_valor_aduaneiro_lin;
              vn_vlr_base_a_recolher := (vn_vlr_base_a_recolher / vn_vrt_aduaneiro) * vn_valor_aduaneiro_lin;
              vn_vlr_base_dev_mn        := (vn_valor_base_calc_afrmm_mn / vn_vrt_aduaneiro) * vn_valor_aduaneiro_lin;
              vn_vlr_base_a_recolher_mn := (vn_vlr_base_a_recolher_mn / vn_vrt_aduaneiro) * vn_valor_aduaneiro_lin;

            ELSIF (vc_tp_rateio = 'D') THEN

              vn_vlr_ref := Nvl(imp_fnc_valor_ref_adicoes (NULL, tb_dcl_lin(dcl).invoice_lin_id),0);
              OPEN  cur_qtde_adi(tb_dcl_lin(dcl).invoice_lin_id);
              FETCH cur_qtde_adi INTO vn_vlr_ref;
              CLOSE cur_qtde_adi;

              tbl_dcl_vlr_rateio(dcl).vlrt_adicao := Nvl(vn_vlr_ref,0);

              vn_vlr_frete           := (vn_vlr_frete_afrmm / vn_vrt_ref_adicao) * Nvl(vn_vlr_ref,0);
              vn_vlr_base_dev        := (vn_valor_base_calc_afrmm / vn_vrt_ref_adicao) * Nvl(vn_vlr_ref,0);
              vn_vlr_base_a_recolher := (vn_vlr_base_a_recolher / vn_vrt_ref_adicao) * Nvl(vn_vlr_ref,0);
              vn_vlr_base_dev_mn        := (vn_valor_base_calc_afrmm_mn / vn_vrt_ref_adicao) * Nvl(vn_vlr_ref,0);
              vn_vlr_base_a_recolher_mn := (vn_vlr_base_a_recolher_mn / vn_vrt_ref_adicao) * Nvl(vn_vlr_ref,0);
            END IF;

  --          vn_vlr_frete           := (vn_vlr_frete_afrmm / vn_global_pesoliq_ebq) * tb_dcl_lin(dcl).pesoliq_tot;
  --          vn_vlr_base_dev        := (vn_valor_base_calc_afrmm / vn_global_pesoliq_ebq) * tb_dcl_lin(dcl).pesoliq_tot;
  --          vn_vlr_base_a_recolher := (vn_vlr_base_a_recolher / vn_global_pesoliq_ebq) * tb_dcl_lin(dcl).pesoliq_tot;
-------------spt          END IF;
          --Fim - Jira - NSI-436

          tb_dcl_lin(dcl).vlr_frete_afrmm        := vn_vlr_frete;
          tb_dcl_lin(dcl).vlr_base_dev           := vn_vlr_base_dev;
          tb_dcl_lin(dcl).vlr_base_a_recolher    := vn_vlr_base_a_recolher;
          tb_dcl_lin(dcl).vlr_base_dev_mn        := vn_vlr_base_dev;
          tb_dcl_lin(dcl).vlr_base_a_recolher_mn := vn_vlr_base_a_recolher;

          p_prc_converter_moeda_nacional( pd_dt_afrmm               => vd_dt_afrmm
                                        , pn_vlr_base_dev_mn        => tb_dcl_lin(dcl).vlr_base_dev_mn
                                        , pn_vlr_base_a_recolher_mn => tb_dcl_lin(dcl).vlr_base_a_recolher_mn
                                        , pn_moeda_id_afrmm         => vn_moeda_id_afrmm
                                        , pc_result                 => vc_result );

          tb_dcl_lin(dcl).vlr_base_dev_mn        :=   vn_vlr_base_dev_mn;
          tb_dcl_lin(dcl).vlr_base_a_recolher_mn :=   vn_vlr_base_a_recolher_mn;

          -- Arredondar com 2 decimais pois os valores serão base para numerário de AFRMM
          tb_dcl_lin(dcl).vlr_frete_afrmm         := Round(Nvl(tb_dcl_lin(dcl).vlr_frete_afrmm,0)       , 2);
          tb_dcl_lin(dcl).vlr_base_dev            := Round(Nvl(tb_dcl_lin(dcl).vlr_base_dev,0)          , 2);
          tb_dcl_lin(dcl).vlr_base_dev_mn         := Round(Nvl(tb_dcl_lin(dcl).vlr_base_dev_mn,0)       , 2);
          tb_dcl_lin(dcl).vlr_base_a_recolher     := Round(Nvl(tb_dcl_lin(dcl).vlr_base_a_recolher,0)   , 2);
          tb_dcl_lin(dcl).vlr_base_a_recolher_mn  := Round(Nvl(tb_dcl_lin(dcl).vlr_base_a_recolher_mn,0), 2);

          vn_soma_total_frt             := vn_soma_total_frt + tb_dcl_lin(dcl).vlr_frete_afrmm;
          vn_soma_base_calc_afrmm       := vn_soma_base_calc_afrmm + tb_dcl_lin(dcl).vlr_base_dev;
          vn_soma_base_a_recolher_afrmm := vn_soma_base_a_recolher_afrmm + tb_dcl_lin(dcl).vlr_base_a_recolher;

          IF( vc_result = 'ERRO_TAXA' )THEN
            vb_erro_taxa := TRUE;
          ELSIF( vc_result = 'ERRO_DATA' )THEN
            vb_erro_data := TRUE;
          END IF;

        END LOOP;

        IF(Nvl(vn_soma_total_frt,0) > 0) OR (Nvl(vn_soma_base_calc_afrmm,0) > 0 OR Nvl(vn_soma_base_a_recolher_afrmm,0) > 0) THEN
          vn_diferenca_frt              := Nvl(vn_vlr_frete_afrmm,0) - Nvl(vn_soma_total_frt,0);
          vn_dif_base_afrmm             := Nvl(vn_valor_base_calc_afrmm,0) - Nvl(vn_soma_base_calc_afrmm,0);

          IF(Nvl(vn_soma_base_a_recolher_afrmm,0) > 0) THEN
            vn_dif_base_a_recolher_afrmm  := Nvl(vn_valor_base_calc_afrmm,0) - Nvl(vn_soma_base_a_recolher_afrmm,0);
          ELSE
            vn_dif_base_a_recolher_afrmm  := 0;
          END IF;

          vn_diferenca_frt              := Round(vn_diferenca_frt,2);
          vn_dif_base_afrmm             := Round(vn_dif_base_afrmm,2);
          vn_dif_base_a_recolher_afrmm  := Round(vn_dif_base_a_recolher_afrmm,2);

          IF(Nvl(Abs(vn_diferenca_frt),0) > 0 OR Nvl(Abs(vn_dif_base_afrmm),0) > 0 OR Nvl(Abs(vn_dif_base_a_recolher_afrmm),0) > 0) THEN
            FOR dcl IN 1..vn_global_dcl_lin LOOP

              IF(Nvl(Abs(vn_diferenca_frt),0) > 0 AND Nvl(tb_dcl_lin(dcl).vlr_frete_afrmm,0) > 0) THEN
                IF(Nvl(vn_diferenca_frt,0) > 0) THEN
                  tb_dcl_lin(dcl).vlr_frete_afrmm := tb_dcl_lin(dcl).vlr_frete_afrmm + (1/100);
                  vn_diferenca_frt := vn_diferenca_frt - (1/100);
                ELSE
                  tb_dcl_lin(dcl).vlr_frete_afrmm := tb_dcl_lin(dcl).vlr_frete_afrmm - (1/100);
                  vn_diferenca_frt := vn_diferenca_frt + (1/100);
                END IF;
              END IF;

              IF(Nvl(Abs(vn_dif_base_afrmm),0) > 0 AND Nvl(tb_dcl_lin(dcl).vlr_base_dev,0) > 0) THEN
                IF(Nvl(vn_dif_base_afrmm,0) > 0) THEN
                  tb_dcl_lin(dcl).vlr_base_dev := tb_dcl_lin(dcl).vlr_base_dev + (1/100);
                  vn_dif_base_afrmm := vn_dif_base_afrmm - (1/100);
                ELSE
                  tb_dcl_lin(dcl).vlr_base_dev := tb_dcl_lin(dcl).vlr_base_dev - (1/100);
                  vn_dif_base_afrmm := vn_dif_base_afrmm + (1/100);
                END IF;
              END IF;

              IF(Nvl(Abs(vn_dif_base_a_recolher_afrmm),0) > 0 AND Nvl(tb_dcl_lin(dcl).vlr_base_a_recolher,0) > 0) THEN
                IF(Nvl(vn_dif_base_a_recolher_afrmm,0) > 0) THEN
                  tb_dcl_lin(dcl).vlr_base_a_recolher := tb_dcl_lin(dcl).vlr_base_a_recolher + (1/100);
                  vn_dif_base_a_recolher_afrmm := vn_dif_base_a_recolher_afrmm - (1/100);
                ELSE
                  tb_dcl_lin(dcl).vlr_base_a_recolher := tb_dcl_lin(dcl).vlr_base_a_recolher - (1/100);
                  vn_dif_base_a_recolher_afrmm := vn_dif_base_a_recolher_afrmm + (1/100);
                END IF;
              END IF;

              --IF(Nvl(tb_dcl_lin(dcl).vlr_base_dev,0) > 0  OR Nvl(tb_dcl_lin(dcl).vlr_base_a_recolher,0) > 0) THEN
              --  tb_dcl_lin(dcl).vlr_base_dev_mn        := tb_dcl_lin(dcl).vlr_base_dev;
              --  tb_dcl_lin(dcl).vlr_base_a_recolher_mn := tb_dcl_lin(dcl).vlr_base_a_recolher;
              --
              --  p_prc_converter_moeda_nacional( pd_dt_afrmm               => vd_dt_afrmm
              --                                , pn_vlr_base_dev_mn        => tb_dcl_lin(dcl).vlr_base_dev_mn
              --                                , pn_vlr_base_a_recolher_mn => tb_dcl_lin(dcl).vlr_base_a_recolher_mn
              --                                , pn_moeda_id_afrmm         => vn_moeda_id_afrmm
              --                                , pc_result                 => vc_result );
              --
              --  tb_dcl_lin(dcl).vlr_base_dev_mn         := Round(Nvl(tb_dcl_lin(dcl).vlr_base_dev_mn,0)       , 2);
              --  tb_dcl_lin(dcl).vlr_base_a_recolher_mn  := Round(Nvl(tb_dcl_lin(dcl).vlr_base_a_recolher_mn,0), 2);
              --END IF;

            END LOOP;
          END IF;

        END IF;

        FOR adi IN 1..vn_global_dcl_adi LOOP
          tb_dcl_adi(adi).vlr_frete_afrmm        := 0;
          tb_dcl_adi(adi).vlr_base_dev           := 0;
          tb_dcl_adi(adi).vlr_base_a_recolher    := 0;
          tb_dcl_adi(adi).vlr_base_dev_mn        := 0;
          tb_dcl_adi(adi).vlr_base_a_recolher_mn := 0;

          FOR dcl IN 1..vn_global_dcl_lin LOOP
            IF(tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(dcl).declaracao_adi_id) THEN
              tb_dcl_adi(adi).vlr_frete_afrmm        := tb_dcl_adi(adi).vlr_frete_afrmm        + tb_dcl_lin(dcl).vlr_frete_afrmm        ;
              tb_dcl_adi(adi).vlr_base_dev           := tb_dcl_adi(adi).vlr_base_dev           + tb_dcl_lin(dcl).vlr_base_dev           ;
              tb_dcl_adi(adi).vlr_base_a_recolher    := tb_dcl_adi(adi).vlr_base_a_recolher    + tb_dcl_lin(dcl).vlr_base_a_recolher    ;
              tb_dcl_adi(adi).vlr_base_dev_mn        := tb_dcl_adi(adi).vlr_base_dev_mn        + tb_dcl_lin(dcl).vlr_base_dev_mn        ;
              tb_dcl_adi(adi).vlr_base_a_recolher_mn := tb_dcl_adi(adi).vlr_base_a_recolher_mn + tb_dcl_lin(dcl).vlr_base_a_recolher_mn ;
            END IF;
          END LOOP;

        END LOOP;

      END IF;

      /* gerar log ao final do processo */
      IF( vb_erro_data )THEN

        vc_linhas_beneficio := SubStr(vc_linhas_beneficio, 1, Length(vc_linhas_beneficio)-2);
        IF(vc_linhas_beneficio IS NOT NULL)THEN
          vc_linhas_beneficio := '['||vc_linhas_beneficio||']';
        END IF;

        IF( vb_beneficio_parcial )THEN
          prc_gera_log_erros
          ( cmx_fnc_texto_traduzido
             ( 'O valor em REAIS do AFRMM e valor do ICMS das linhas @@01@@ não serão calculados, pois a data realizada do pagamento do AFRMM precisa estar informada no cronograma do embarque.'||Chr(10)||
                               'Preencher a data realizada do pagamento do AFRMM no cronograma do embarque (verificar na tabela 131 qual a data correspondente ao pagamento, cujo atributo 8 = AFRMM).'
             , 'imp_pkg_totaliza_ebq'
             , '110'
             , NULL
             , vc_linhas_beneficio)
                              , 'E'
          , 'A');

        ELSE

          prc_gera_log_erros
          ( cmx_fnc_texto_traduzido
             ( 'O valor em REAIS do AFRMM das linhas @@01@@ não serão calculados, pois conforme o Art. 9 da Lei 10893/04 na navegação de longo curso, quando o frete estiver expresso em moeda estrangeira, a conversão para o padrão monetário nacional será feita com base na taxa vigente na data do efetivo pagamento do AFRMM.'||Chr(10)||
                               'Preencher a data realizada do pagamento do AFRMM no cronograma do embarque (verificar na tabela 131 qual a data correspondente ao pagamento, cujo atributo 8 = AFRMM).'
             , 'imp_pkg_totaliza_ebq'
             , '111'
             , NULL
             , vc_linhas_beneficio)
                              , 'A'
          , 'A');

        END IF;

      ELSIF( vb_erro_taxa )THEN
          prc_gera_log_erros
          ( cmx_fnc_texto_traduzido
             ( 'Taxa FISCAL da moeda [@@01@@] não cadastrada para a data realizada do pagamento do AFRMM [@@02@@]'||Chr(10)||
                            'Parametrizar o cadastro de taxas para a moeda \ data realizada.'
             , 'imp_pkg_totaliza_ebq'
             , '112'
             , NULL
             , cmx_pkg_tabelas.codigo(vn_moeda_id_afrmm)
             , To_Char(vd_dt_afrmm, 'DD/MM/YYYY'))
                          , 'E'
          , 'A');


      END IF;

    END IF;

  EXCEPTION
    WHEN others THEN
       prc_gera_log_erros
       ( cmx_fnc_texto_traduzido
          ( 'Erro ao calcular afrmm: @@01@@'
          , 'imp_pkg_totaliza_ebq'
          , '113'
          , NULL
          , SQLERRM  )
       , 'E'
       , 'D');

  END imp_prc_calcula_afrmm;

  -- ***********************************************************************
  -- Esta rotina fará o rateio dos valores das linhas das invoices para as linhas das
  -- declarações agrupando em suas respectivas adições. Após o cálculo dos impostos
  -- nas adições, será feito o rateio do valor dos impostos para as linhas daquela
  -- adição.
  -- ***********************************************************************
  PROCEDURE imp_prc_calcula_impostos ( pn_embarque_id    NUMBER
                                     , pn_tp_declaracao  NUMBER
                                     , pd_data_conversao DATE
                                     , pn_empresa_id     NUMBER
                                     , pc_tp_declaracao  VARCHAR2
                                     , pc_dsi            VARCHAR2
                                     , pn_declaracao_id  NUMBER
                                     , pn_tp_embarque_id NUMBER) IS

    vn_dcl                    NUMBER  := 0;
    vn_soma_fob_mn            NUMBER  := 0;
    vn_soma_dspfob_mn         NUMBER  := 0;
    vn_soma_acres_mn          NUMBER  := 0;
    vn_soma_ded_mn            NUMBER  := 0;
    vn_soma_ajuste_base_icms_mn NUMBER  := 0;
    vn_soma_vmle_mn           NUMBER  := 0;
    vn_soma_fr_mn             NUMBER  := 0;
    vn_soma_fr_total_mn       NUMBER  := 0;
    vn_soma_fr_prepaid_mn     NUMBER  := 0;
    vn_soma_fr_collect_mn     NUMBER  := 0;
    vn_soma_fr_terr_nac_mn    NUMBER  := 0;
    vn_soma_sg_mn             NUMBER  := 0;
    vn_soma_dsp_ddu_mn        NUMBER  := 0;
    vn_soma_pesoliq_ivc_linha NUMBER  := 0;
    vn_rateio_fob_mn          NUMBER  := 0;
    vn_rateio_dspfob_mn       NUMBER  := 0;
    vn_rateio_acres_mn        NUMBER  := 0;
    vn_rateio_ded_mn          NUMBER  := 0;
    vn_rateio_ajuste_base_icms_mn NUMBER  := 0;
    vn_rateio_vmle_mn         NUMBER  := 0;
    vn_rateio_fr_mn           NUMBER  := 0;
    vn_rateio_fr_total_mn     NUMBER  := 0;
    vn_rateio_fr_prepaid_mn   NUMBER  := 0;
    vn_rateio_fr_collect_mn   NUMBER  := 0;
    vn_rateio_fr_terr_nac_mn  NUMBER  := 0;
    vn_rateio_sg_mn           NUMBER  := 0;
    vn_rateio_fob_m           NUMBER  := 0;
    vn_rateio_dspfob_m        NUMBER  := 0;
    vn_rateio_acres_m         NUMBER  := 0;
    vn_rateio_ded_m           NUMBER  := 0;
    vn_rateio_ajuste_base_icms_m NUMBER  := 0;
    vn_rateio_fr_m            NUMBER  := 0;
    vn_rateio_fr_total_m      NUMBER  := 0;
    vn_rateio_fr_prepaid_m    NUMBER  := 0;
    vn_rateio_fr_collect_m    NUMBER  := 0;
    vn_rateio_fr_terr_nac_m   NUMBER  := 0;
    vn_rateio_sg_m            NUMBER  := 0;
    vn_rateio_fr_us           NUMBER  := 0;
    vn_rateio_fr_total_us     NUMBER  := 0;
    vn_rateio_fr_prepaid_us   NUMBER  := 0;
    vn_rateio_fr_collect_us   NUMBER  := 0;
    vn_rateio_fr_terr_nac_us  NUMBER  := 0;
    vn_rateio_sg_us           NUMBER  := 0;
    vn_rateio_dsp_ddu         NUMBER  := 0;
    vn_ind_fob_mn             NUMBER  := 0;
    vn_ind_dspfob_mn          NUMBER  := 0;
    vn_ind_acres_mn           NUMBER  := 0;
    vn_ind_ded_mn             NUMBER  := 0;
    vn_ind_ajuste_base_icms_mn NUMBER  := 0;
    vn_ind_vmle_mn            NUMBER  := 0;
    vn_ind_fr_mn              NUMBER  := 0;
    vn_ind_fr_total_mn        NUMBER  := 0;
    vn_ind_fr_prepaid_mn      NUMBER  := 0;
    vn_ind_fr_collect_mn      NUMBER  := 0;
    vn_ind_fr_terr_nac_mn     NUMBER  := 0;
    vn_ind_sg_mn              NUMBER  := 0;
    vn_ind_dsp_ddu_mn         NUMBER  := 0;
    vn_taxa_mn_fob            NUMBER  := null;
    vn_taxa_us_fob            NUMBER  := null;
    vn_taxa_mn_fr             NUMBER  := null;
    vn_taxa_us_fr             NUMBER  := null;
    vn_taxa_mn_sg             NUMBER  := null;
    vn_taxa_us_sg             NUMBER  := null;
    vn_vrt_vmle_mn            NUMBER  := 0;
    vn_vrt_fr_mn              NUMBER  := 0;
    vn_vrt_sg_mn              NUMBER  := 0;
    vn_vrt_acres_mn           NUMBER  := 0;
    vn_vrt_ded_mn             NUMBER  := 0;
    vb_primeira_vez           BOOLEAN := true;
    vn_ant_declaracao_adi_id  NUMBER  := 0;
    vn_vmlc_m_adi             NUMBER  := 0;
    vn_vmlc_mn_adi            NUMBER  := 0;
    vn_peso_liq_da            NUMBER  := 0;
    vn_peso_brt_da            NUMBER  := 0;
    vn_da_lin_id              NUMBER  := null;
    vn_licenca_id             NUMBER  := null;

    CURSOR cur_peso_liq_linha_da (pn_ivc_lin_id NUMBER, pn_da_lin_id NUMBER, pn_dcl_lin_id NUMBER) IS
      SELECT da_peso_liq_proporcional
           , da_peso_brt_proporcional
        FROM imp_invoices_lin_da
       WHERE invoice_lin_id    = pn_ivc_lin_id
         AND da_lin_id         = pn_da_lin_id
         AND declaracao_lin_id = pn_dcl_lin_id;

    CURSOR cur_peso_brt_linha_da (pn_ivc_lin_id NUMBER, pn_da_lin_id NUMBER, pn_lic_lin_id NUMBER) IS
      SELECT da_peso_brt_proporcional
        FROM imp_invoices_lin_da
       WHERE invoice_lin_id = pn_ivc_lin_id
         AND da_lin_id      = pn_da_lin_id
         AND licenca_lin_id = pn_lic_lin_id;

    CURSOR cur_linha_di_tem_li (pn_declaracao_lin_id NUMBER) IS
      SELECT da_lin_id
           , licenca_id
        FROM imp_declaracoes_lin
       WHERE declaracao_lin_id = pn_declaracao_lin_id;

    PROCEDURE imp_carrega_adicao_dcl ( pn_declaracao_adi_id     NUMBER
                                     , pn_pesoliq_tot           NUMBER
                                     , pn_taxa_mn_fob           NUMBER
                                     , pn_taxa_us_fob           NUMBER
                                     , pn_taxa_us_fr            NUMBER
                                     , pn_taxa_us_sg            NUMBER
                                     , pc_incoterm              VARCHAR2
                                     , pn_tprateio_incoterm     VARCHAR2
                                     , pn_quantidade            NUMBER
                                     , pn_declaracao_lin_id     NUMBER
                                     , pn_vmlc_m            OUT NUMBER
                                     , pn_vmlc_mn           OUT NUMBER
                                     ) IS

      vb_achou_adicao           BOOLEAN := FALSE;
      vn_rateio_fob_us          NUMBER := 0;
      vn_rateio_dspfob_us       NUMBER := 0;
      vn_rateio_acres_us        NUMBER := 0;
      vn_rateio_ded_us          NUMBER := 0;
      vn_rateio_ajuste_base_icms_us          NUMBER := 0;
      vn_vmlc_m                 NUMBER := 0;
      vn_vmlc_mn                NUMBER := 0;

      CURSOR cur_dcl_adi_docvinc(pn_adi_id NUMBER ) IS
        SELECT Count(1)
          FROM imp_dcl_adi_docvinc
         WHERE declaracao_adi_id = pn_adi_id;
      vn_doc_vinc NUMBER;

      CURSOR cur_adicao_num(pn_adi_id NUMBER ) IS
        SELECT adicao_num
          FROM imp_declaracoes_adi
         WHERE declaracao_adi_id = pn_adi_id;
      vn_adi_num NUMBER;

      FUNCTION fnc_busca_qt_um_estat (pn_adicao_id NUMBER ) RETURN NUMBER IS
        CURSOR cur_fator_conversao IS
          SELECT nvl (cie.fator_conversao, 0) fator_conversao
            FROM cmx_itens_ext       cie
               , imp_declaracoes_lin idl
           WHERE pn_declaracao_lin_id = idl.declaracao_lin_id
             AND idl.item_id          = cie.item_id (+);

        CURSOR cur_um_estatistica IS
          SELECT ct.codigo
            FROM cmx_tabelas ct
               , imp_declaracoes_adi ida
               , cmx_tab_ncm ncm
           WHERE ida.declaracao_adi_id = pn_adicao_id
             AND ncm.ncm_id            = ida.class_fiscal_id
             AND ct.tabela_id          = ncm.un_medida_id;

        vn_fator_conversao  cmx_itens_ext.fator_conversao%TYPE;
        vn_um_siscomex      cmx_tabelas.codigo%TYPE;

      BEGIN
        vn_fator_conversao := 0;
        vn_um_siscomex     := null;

        OPEN  cur_fator_conversao;
        FETCH cur_fator_conversao INTO vn_fator_conversao;
        CLOSE cur_fator_conversao;

        OPEN  cur_um_estatistica;
        FETCH cur_um_estatistica INTO vn_um_siscomex;
        CLOSE cur_um_estatistica;

        IF (nvl(vn_um_siscomex,'XX') = '24') THEN
          RETURN (0);
        ELSIF (nvl(vn_um_siscomex,'XX') = '10') THEN
          RETURN (pn_pesoliq_tot);
        ELSE
          IF (vn_fator_conversao <> 0) THEN
            RETURN (pn_quantidade * vn_fator_conversao);
          ELSE
            RETURN (pn_quantidade);
          END IF; -- IF (vn_fator_conversao <> 0) THEN
        END IF;
      EXCEPTION
        WHEN others THEN
          prc_gera_log_erros ('Erro ao calcular a un.medida estatística: ' || sqlerrm, 'E', 'A');
      END fnc_busca_qt_um_estat;

    BEGIN  -- imp_carrega_adicao_dcl
      vb_achou_adicao           := FALSE;
      vn_rateio_fob_us          := vn_rateio_fob_m              * pn_taxa_us_fob;
      vn_rateio_dspfob_us       := vn_rateio_dspfob_m           * pn_taxa_us_fob;
      vn_rateio_acres_us        := vn_rateio_acres_m            * pn_taxa_us_fob;
      vn_rateio_ded_us          := vn_rateio_ded_m              * pn_taxa_us_fob;
      vn_rateio_ajuste_base_icms_us := vn_rateio_ajuste_base_icms_m  * pn_taxa_us_fob;

      IF pn_tp_declaracao <= 13 OR vc_global_nac_sem_admissao = 'S' THEN -- Para nacionalização (pn_tp_declaracao > 13) os campos de US já foram calculados
        vn_rateio_fr_us           := vn_rateio_fr_m               * pn_taxa_us_fr;
        vn_rateio_fr_total_us     := vn_rateio_fr_total_m         * pn_taxa_us_fr;
        vn_rateio_fr_prepaid_us   := vn_rateio_fr_prepaid_m       * pn_taxa_us_fr;
        vn_rateio_fr_collect_us   := vn_rateio_fr_collect_m       * pn_taxa_us_fr;
        vn_rateio_fr_terr_nac_us  := vn_rateio_fr_terr_nac_m      * pn_taxa_us_fr;
        vn_rateio_sg_us           := vn_rateio_sg_m               * pn_taxa_us_sg;
      END IF;


      vn_vmlc_mn := nvl (vn_rateio_fob_mn, 0) + nvl (vn_rateio_dspfob_mn, 0);

      -- Devemos utilizar o valor total do frete quando formos calcular o valor
      -- na condição de venda, com excecao do incoterm DAF que nao considera o
      -- valor do frete em territorio nacional.
      IF (instr(pn_tprateio_incoterm, 'F') <> 0) THEN
        IF (pc_incoterm = 'DAF') THEN
          vn_vmlc_mn := vn_vmlc_mn + nvl (vn_rateio_fr_mn, 0);
        ELSE
          vn_vmlc_mn := vn_vmlc_mn + nvl (vn_rateio_fr_total_mn, 0);
        END IF;
      END IF;

      IF (instr(pn_tprateio_incoterm, 'S') <> 0) THEN
        vn_vmlc_mn := vn_vmlc_mn + nvl (vn_rateio_sg_mn, 0);
      END IF;

      IF (instr(pn_tprateio_incoterm, 'N') <> 0) THEN
        vn_vmlc_mn := vn_vmlc_mn + nvl (vn_rateio_dsp_ddu, 0);
      END IF;

      IF (pn_taxa_mn_fob > 0) THEN
        vn_vmlc_m := vn_vmlc_mn / pn_taxa_mn_fob;
      END IF;

      pn_vmlc_m  := vn_vmlc_m;
      pn_vmlc_mn := vn_vmlc_mn;

      OPEN cur_dcl_adi_docvinc(pn_declaracao_adi_id);
      FETCH cur_dcl_adi_docvinc INTO vn_doc_vinc;
      CLOSE cur_dcl_adi_docvinc;

      IF Nvl(vn_doc_vinc,0) > 10 THEN
        OPEN cur_adicao_num(pn_declaracao_adi_id);
        FETCH cur_adicao_num INTO vn_adi_num;
        CLOSE cur_adicao_num;

        prc_gera_log_erros ('Adição ['||vn_adi_num||'] - Existem mais de 10 ocorrências de documento vinculado, serão geradas na estrutura própria somente 10 devido a limitação do Siscomex.', 'A', 'D');
      END IF;


      IF (vb_primeira_vez) THEN
        vb_primeira_vez  := FALSE;
      ELSE
        FOR adi IN 1..vn_global_dcl_adi LOOP
          IF (tb_dcl_adi(adi).declaracao_adi_id = pn_declaracao_adi_id) THEN
            vb_achou_adicao := TRUE;
            tb_dcl_adi(adi).qtde_linhas                   := tb_dcl_adi(adi).qtde_linhas                   + 1;
            tb_dcl_adi(adi).peso_liquido                  := tb_dcl_adi(adi).peso_liquido                  + pn_pesoliq_tot;
            tb_dcl_adi(adi).qt_um_estat                   := nvl(tb_dcl_adi(adi).qt_um_estat, 0)           + fnc_busca_qt_um_estat (pn_declaracao_adi_id);
            tb_dcl_adi(adi).vrt_fob_m                     := tb_dcl_adi(adi).vrt_fob_m                     + vn_rateio_fob_m;
            tb_dcl_adi(adi).vrt_dspfob_m                  := tb_dcl_adi(adi).vrt_dspfob_m                  + vn_rateio_dspfob_m;
            tb_dcl_adi(adi).vrt_fr_m                      := tb_dcl_adi(adi).vrt_fr_m                      + vn_rateio_fr_m;
            tb_dcl_adi(adi).vrt_fr_total_m                := tb_dcl_adi(adi).vrt_fr_total_m                + vn_rateio_fr_total_m;
            tb_dcl_adi(adi).vrt_fr_prepaid_m              := tb_dcl_adi(adi).vrt_fr_prepaid_m              + vn_rateio_fr_prepaid_m;
            tb_dcl_adi(adi).vrt_fr_collect_m              := tb_dcl_adi(adi).vrt_fr_collect_m              + vn_rateio_fr_collect_m;
            tb_dcl_adi(adi).vrt_fr_territorio_nacional_m  := tb_dcl_adi(adi).vrt_fr_territorio_nacional_m  + vn_rateio_fr_terr_nac_m;
            tb_dcl_adi(adi).vrt_sg_m                      := tb_dcl_adi(adi).vrt_sg_m                      + vn_rateio_sg_m;
            tb_dcl_adi(adi).vrt_acres_m                   := tb_dcl_adi(adi).vrt_acres_m                   + vn_rateio_acres_m;
            tb_dcl_adi(adi).vrt_ded_m                     := tb_dcl_adi(adi).vrt_ded_m                     + vn_rateio_ded_m;
            tb_dcl_adi(adi).vrt_ajuste_base_icms_m        := tb_dcl_adi(adi).vrt_ajuste_base_icms_m        + vn_rateio_ajuste_base_icms_m;
            tb_dcl_adi(adi).vrt_fob_mn                    := tb_dcl_adi(adi).vrt_fob_mn                    + vn_rateio_fob_mn;
            tb_dcl_adi(adi).vrt_dspfob_mn                 := tb_dcl_adi(adi).vrt_dspfob_mn                 + vn_rateio_dspfob_mn;
            tb_dcl_adi(adi).vrt_fr_mn                     := tb_dcl_adi(adi).vrt_fr_mn                     + vn_rateio_fr_mn;
            tb_dcl_adi(adi).vrt_fr_total_mn               := tb_dcl_adi(adi).vrt_fr_total_mn               + vn_rateio_fr_total_mn;
            tb_dcl_adi(adi).vrt_fr_prepaid_mn             := tb_dcl_adi(adi).vrt_fr_prepaid_mn             + vn_rateio_fr_prepaid_mn;
            tb_dcl_adi(adi).vrt_fr_collect_mn             := tb_dcl_adi(adi).vrt_fr_collect_mn             + vn_rateio_fr_collect_mn;
            tb_dcl_adi(adi).vrt_fr_territorio_nacional_mn := tb_dcl_adi(adi).vrt_fr_territorio_nacional_mn + vn_rateio_fr_terr_nac_mn;
            tb_dcl_adi(adi).vrt_sg_mn                     := tb_dcl_adi(adi).vrt_sg_mn                     + vn_rateio_sg_mn;
            tb_dcl_adi(adi).vrt_acres_mn                  := tb_dcl_adi(adi).vrt_acres_mn                  + vn_rateio_acres_mn;
            tb_dcl_adi(adi).vrt_ded_mn                    := tb_dcl_adi(adi).vrt_ded_mn                    + vn_rateio_ded_mn;
            tb_dcl_adi(adi).vrt_ajuste_base_icms_mn       := tb_dcl_adi(adi).vrt_ajuste_base_icms_mn       + vn_rateio_ajuste_base_icms_mn;
            tb_dcl_adi(adi).vrt_fob_us                    := tb_dcl_adi(adi).vrt_fob_us                    + vn_rateio_fob_us;
            tb_dcl_adi(adi).vrt_dspfob_us                 := tb_dcl_adi(adi).vrt_dspfob_us                 + vn_rateio_dspfob_us;
            tb_dcl_adi(adi).vrt_fr_us                     := tb_dcl_adi(adi).vrt_fr_us                     + vn_rateio_fr_us;
            tb_dcl_adi(adi).vrt_fr_total_us               := tb_dcl_adi(adi).vrt_fr_total_us               + vn_rateio_fr_total_us;
            tb_dcl_adi(adi).vrt_fr_prepaid_us             := tb_dcl_adi(adi).vrt_fr_prepaid_us             + vn_rateio_fr_prepaid_us;
            tb_dcl_adi(adi).vrt_fr_collect_us             := tb_dcl_adi(adi).vrt_fr_collect_us             + vn_rateio_fr_collect_us;
            tb_dcl_adi(adi).vrt_fr_territorio_nacional_us := tb_dcl_adi(adi).vrt_fr_territorio_nacional_us + vn_rateio_fr_terr_nac_us;
            tb_dcl_adi(adi).vrt_sg_us                     := tb_dcl_adi(adi).vrt_sg_us                     + vn_rateio_sg_us;
            tb_dcl_adi(adi).vrt_acres_us                  := tb_dcl_adi(adi).vrt_acres_us                  + vn_rateio_acres_us;
            tb_dcl_adi(adi).vrt_ded_us                    := tb_dcl_adi(adi).vrt_ded_us                    + vn_rateio_ded_us;
            tb_dcl_adi(adi).vrt_ajuste_base_icms_us       := tb_dcl_adi(adi).vrt_ajuste_base_icms_us       + vn_rateio_ajuste_base_icms_us;
            tb_dcl_adi(adi).vmlc_m                        := tb_dcl_adi(adi).vmlc_m                        + vn_vmlc_m;
            tb_dcl_adi(adi).vmlc_mn                       := tb_dcl_adi(adi).vmlc_mn                       + vn_vmlc_mn;
            tb_dcl_adi(adi).vmle_mn                       := tb_dcl_adi(adi).vmle_mn                       + vn_rateio_vmle_mn;
          END IF;
        END LOOP;
      END IF;

      IF (not vb_achou_adicao) THEN
        vn_global_dcl_adi                                           := vn_global_dcl_adi + 1;
        tb_dcl_adi(vn_global_dcl_adi).declaracao_adi_id             := pn_declaracao_adi_id;
        tb_dcl_adi(vn_global_dcl_adi).qtde_linhas                   := 1;
        tb_dcl_adi(vn_global_dcl_adi).peso_liquido                  := pn_pesoliq_tot;
--        tb_dcl_adi(vn_global_dcl_adi).qt_um_estat       := nvl(tb_dcl_adi(vn_global_dcl_adi).qt_um_estat,0)   +
--                                                           fnc_busca_qt_um_estat( pn_declaracao_adi_id );
        tb_dcl_adi(vn_global_dcl_adi).qt_um_estat                   := fnc_busca_qt_um_estat (pn_declaracao_adi_id);
        tb_dcl_adi(vn_global_dcl_adi).vrt_fob_m                     := vn_rateio_fob_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_dspfob_m                  := vn_rateio_dspfob_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_m                      := vn_rateio_fr_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_total_m                := vn_rateio_fr_total_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_prepaid_m              := vn_rateio_fr_prepaid_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_collect_m              := vn_rateio_fr_collect_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_territorio_nacional_m  := vn_rateio_fr_terr_nac_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_sg_m                      := vn_rateio_sg_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_acres_m                   := vn_rateio_acres_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_ded_m                     := vn_rateio_ded_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_ajuste_base_icms_m        := vn_rateio_ajuste_base_icms_m;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fob_mn                    := vn_rateio_fob_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_dspfob_mn                 := vn_rateio_dspfob_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_mn                     := vn_rateio_fr_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_total_mn               := vn_rateio_fr_total_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_prepaid_mn             := vn_rateio_fr_prepaid_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_collect_mn             := vn_rateio_fr_collect_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_territorio_nacional_mn := vn_rateio_fr_terr_nac_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_sg_mn                     := vn_rateio_sg_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_acres_mn                  := vn_rateio_acres_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_ded_mn                    := vn_rateio_ded_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_ajuste_base_icms_mn       := vn_rateio_ajuste_base_icms_mn;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fob_us                    := vn_rateio_fob_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_dspfob_us                 := vn_rateio_dspfob_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_us                     := vn_rateio_fr_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_total_us               := vn_rateio_fr_total_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_prepaid_us             := vn_rateio_fr_prepaid_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_collect_us             := vn_rateio_fr_collect_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_fr_territorio_nacional_us := vn_rateio_fr_terr_nac_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_sg_us                     := vn_rateio_sg_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_acres_us                  := vn_rateio_acres_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_ded_us                    := vn_rateio_ded_us;
        tb_dcl_adi(vn_global_dcl_adi).vrt_ajuste_base_icms_us       := vn_rateio_ajuste_base_icms_us;
        tb_dcl_adi(vn_global_dcl_adi).vmlc_m                        := vn_vmlc_m;
        tb_dcl_adi(vn_global_dcl_adi).vmlc_mn                       := vn_vmlc_mn;
        tb_dcl_adi(vn_global_dcl_adi).vmle_mn                       := vn_rateio_vmle_mn;
      END IF;

    EXCEPTION
      WHEN others THEN
        prc_gera_log_erros ('Erro ao carregar as adições da declaração: ' || sqlerrm, 'E', 'D');
    END imp_carrega_adicao_dcl;

    PROCEDURE p_prc_carrega_dcl_lin_ad_nac (pn_declaracao_id  NUMBER) AS
--      TYPE reg_dcl_adi_acresded IS RECORD
--        ( declaracao_adi_id   NUMBER
--        , tp_acres_ded        VARCHAR2(1)
--        , acres_ded_id        NUMBER
--        , moeda_id            NUMBER
--        , valor_m             NUMBER
--        , valor_mn            NUMBER
--        );

--      TYPE tb_adi_acresded IS TABLE OF reg_dcl_adi_acresded INDEX BY BINARY_INTEGER;

      CURSOR cur_ad_dcl_lin_nac IS
        SELECT ida.declaracao_adi_id
             , idl.declaracao_lin_id
             , idl.qtde                                qtde_nacionalizada
             , decode (ctt.tipo,'119','A','D')         tp_acres_ded
             , ((iial.valor_m / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * idl.qtde)  vrt_acres_ded
             , iial.moeda_id                           da_moeda_ad_id
             , iea.acres_ded_id
          FROM imp_declaracoes_lin   idl
             , imp_declaracoes_adi   ida
             , imp_declaracoes_lin   idlda
             , imp_declaracoes       idda
             , imp_invoices_ad_lin   iial
             , imp_invoices_lin      iil
             , imp_embarques_ad      iea
             , imp_declaracoes       id
             , cmx_tabelas          ctt
         WHERE id.declaracao_id        = pn_declaracao_id
           AND idl.declaracao_id       = id.declaracao_id
           AND ida.declaracao_adi_id   = idl.declaracao_adi_id
           AND idlda.declaracao_lin_id = idl.da_lin_id
           AND idda.declaracao_id      = idlda.declaracao_id
           AND idlda.invoice_lin_id    = iil.invoice_lin_id
           AND iil.invoice_lin_id      = iial.invoice_lin_id
           AND iial.embarque_ad_id     = iea.embarque_ad_id
           AND iea.acres_ded_id        = ctt.tabela_id
         ORDER BY ida.declaracao_adi_id
		              , decode (ctt.tipo,'119','A','D')
		              , iea.acres_ded_id
		              , iial.moeda_id
                , idl.invoice_id
                , idl.invoice_lin_id;

   	  vn_ant_tp_acres_ded       VARCHAR2(1)   := 'X';
      vc_erro                   VARCHAR2(100) := null;
      vn_ant_declaracao_adi_id  NUMBER        := 0;
   	  vn_ant_acres_ded_id       NUMBER        := 0;
   	  vn_ant_moeda_id           NUMBER        := 0;
      vn_acres_ded_moeda_id     NUMBER        := 0;
      vn_taxa_acres_ded_mn      NUMBER        := 0;
      vn_taxa_acres_ded_us      NUMBER        := 0;
      vn_ultima_adi_ad          NUMBER        := 0;
      vb_adicao_tem_acrescimo   BOOLEAN       := false;
      tb_ad_adi                 tb_adi_acresded;

    BEGIN
      vn_ultima_adi_ad        := 0;
      vb_adicao_tem_acrescimo := false;

      vc_erro := '(deletando plsql table TB_AD_ADI)';
      tb_ad_adi.delete;

      vc_erro := '(entrando no loop)';
      FOR dcl_lin_ad_nac IN cur_ad_dcl_lin_nac LOOP
        vn_global_dcl_lin_ad_nac := vn_global_dcl_lin_ad_nac + 1;

        vc_erro := '(verificando se a moeda do acrescimo mudou)';
        IF (vn_acres_ded_moeda_id <> dcl_lin_ad_nac.da_moeda_ad_id) THEN
          vn_acres_ded_moeda_id := dcl_lin_ad_nac.da_moeda_ad_id;

          vc_erro := '(buscando taxa do acrescimo)';
          imp_prc_busca_taxa_conversao (
               vn_acres_ded_moeda_id
             , pd_data_conversao
             , vn_taxa_acres_ded_mn
             , vn_taxa_acres_ded_us
             , 'Acres/Ded nacionalizacao Recof'
            );
        END IF;

        vc_erro := '(atribuindo valores)';
        tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).declaracao_lin_id := dcl_lin_ad_nac.declaracao_lin_id;
        tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).declaracao_adi_id := dcl_lin_ad_nac.declaracao_adi_id;
        tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).tp_acres_ded      := dcl_lin_ad_nac.tp_acres_ded;
        tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).acres_ded_id      := dcl_lin_ad_nac.acres_ded_id;
        tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).qtde              := dcl_lin_ad_nac.qtde_nacionalizada;
        tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).moeda_id          := vn_acres_ded_moeda_id;
        tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).taxa_mn           := vn_taxa_acres_ded_mn;

        IF (dcl_lin_ad_nac.tp_acres_ded = 'A') THEN
          IF (round (dcl_lin_ad_nac.vrt_acres_ded, 2) = 0) AND (round (nvl (dcl_lin_ad_nac.vrt_acres_ded * vn_taxa_acres_ded_mn, 0), 2) <> 0) THEN
            tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_m  := 1/100;
          ELSE
            tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_m  := round (dcl_lin_ad_nac.vrt_acres_ded, 2);
          END IF;

          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_mn := round (nvl (tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_m * vn_taxa_acres_ded_mn, 0), 2);
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_us := round (nvl (tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_m * vn_taxa_acres_ded_us, 0), 2);
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_m    := 0;
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_mn   := 0;
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_us   := 0;
        ELSE
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_m  := 0;
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_mn := 0;
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_acres_us := 0;

          IF (round (dcl_lin_ad_nac.vrt_acres_ded, 2) = 0) AND (round (nvl (dcl_lin_ad_nac.vrt_acres_ded * vn_taxa_acres_ded_mn, 0), 2) <> 0) THEN
            tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_m  := 1/100;
          ELSE
            tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_m  := round (dcl_lin_ad_nac.vrt_acres_ded, 2);
          END IF;

          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_mn   := round (nvl (tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_m * vn_taxa_acres_ded_mn, 0), 2);
          tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_us   := round (nvl (tb_dcl_lin_ad(vn_global_dcl_lin_ad_nac).valor_ded_m * vn_taxa_acres_ded_us, 0), 2);
        END IF;
      END LOOP;

      vc_erro := '(entrando no loop que ira popular a plsql table TB_AD_ADI)';
      FOR ad IN 1..vn_global_dcl_lin_ad_nac LOOP
        IF (nvl (tb_dcl_lin_ad(ad).valor_acres_mn, 0) <> 0) OR (nvl (tb_dcl_lin_ad(ad).valor_ded_mn, 0) <> 0) THEN
          vb_adicao_tem_acrescimo := true;

          IF (vn_ant_declaracao_adi_id <> tb_dcl_lin_ad(ad).declaracao_adi_id) OR
		           (vn_ant_tp_acres_ded <>  tb_dcl_lin_ad(ad).tp_acres_ded ) OR
		           (vn_ant_acres_ded_id <>  tb_dcl_lin_ad(ad).acres_ded_id ) OR
		           (vn_ant_moeda_id     <>  tb_dcl_lin_ad(ad).moeda_id     ) THEN

            vn_ultima_adi_ad := vn_ultima_adi_ad + 1;
            vn_ant_declaracao_adi_id := tb_dcl_lin_ad(ad).declaracao_adi_id;
            vn_ant_tp_acres_ded      := tb_dcl_lin_ad(ad).tp_acres_ded;
        		  vn_ant_acres_ded_id      := tb_dcl_lin_ad(ad).acres_ded_id;
		          vn_ant_moeda_id          := tb_dcl_lin_ad(ad).moeda_id;
          END IF;

          vc_erro := '(atribuindo variaveis para a plsql table TB_AD_ADI)';
          tb_ad_adi(vn_ultima_adi_ad).declaracao_adi_id := tb_dcl_lin_ad(ad).declaracao_adi_id;
          tb_ad_adi(vn_ultima_adi_ad).tp_acres_ded      := tb_dcl_lin_ad(ad).tp_acres_ded;
          tb_ad_adi(vn_ultima_adi_ad).acres_ded_id      := tb_dcl_lin_ad(ad).acres_ded_id;
          tb_ad_adi(vn_ultima_adi_ad).moeda_id          := tb_dcl_lin_ad(ad).moeda_id;

          IF (tb_dcl_lin_ad(ad).tp_acres_ded = 'A') THEN
            tb_ad_adi(vn_ultima_adi_ad).valor_m  := nvl(tb_ad_adi(vn_ultima_adi_ad).valor_m,0) + tb_dcl_lin_ad(ad).valor_acres_m;
            tb_ad_adi(vn_ultima_adi_ad).valor_mn := nvl(tb_ad_adi(vn_ultima_adi_ad).valor_mn,0) + tb_dcl_lin_ad(ad).valor_acres_mn;
          ELSE
            tb_ad_adi(vn_ultima_adi_ad).valor_m  := nvl(tb_ad_adi(vn_ultima_adi_ad).valor_m,0) + tb_dcl_lin_ad(ad).valor_ded_m;
            tb_ad_adi(vn_ultima_adi_ad).valor_mn := nvl(tb_ad_adi(vn_ultima_adi_ad).valor_mn,0) + tb_dcl_lin_ad(ad).valor_ded_mn;
          END IF;
        END IF; -- IF (nvl (tb_dcl_lin_ad(ad).valor_acres_m, 0) <> 0) OR (nvl (tb_dcl_lin_ad(ad).valor_ded_m, 0) <> 0) THEN
      END LOOP; -- FOR ad IN 1..vn_global_dcl_lin_ad_nac LOOP

      IF (vb_adicao_tem_acrescimo) THEN
        vc_erro := '(deletando a imp_dcl_adi_acresded)';
        DELETE FROM imp_dcl_adi_acresded
         WHERE declaracao_id = pn_declaracao_id;

        vc_erro := '(entrando no loop da insercao imp_dcl_adi_acresded)';
        FOR adi IN 1..vn_ultima_adi_ad LOOP
--          IF (tb_ad_adi(adi).valor_m > 0) THEN
            vc_erro := '(inserindo dados na imp_dcl_adi_acresded)';
            INSERT INTO imp_dcl_adi_acresded
                        ( declaracao_id
                        , declaracao_adi_id
                        , tp_acres_ded
                        , acres_ded_id
                        , moeda_id
                        , valor_m
                        , valor_mn
                        , creation_date
                        , created_by
                        , last_update_date
                        , last_updated_by
                        , grupo_acesso_id
                        )
                  VALUES( pn_declaracao_id
                        , tb_ad_adi(adi).declaracao_adi_id
                        , tb_ad_adi(adi).tp_acres_ded
                        , tb_ad_adi(adi).acres_ded_id
                        , tb_ad_adi(adi).moeda_id
                        , tb_ad_adi(adi).valor_m
                        , tb_ad_adi(adi).valor_mn
                        , vd_global_creation_date
                        , vn_global_created_by
                        , vd_global_last_update_date
                        , vn_global_last_updated_by
                        , vn_global_grupo_acesso_id
                        );
--          END IF;
        END LOOP;

	      -- ajusta os valores dos acrescimos zerados.
        prc_ajusta_valores_acresded(pn_declaracao_id, pd_data_conversao,vn_ultima_adi_ad,tb_ad_adi);

    END IF; -- IF (vb_adicao_tem_acrescimo) THEN

      vc_erro := null;
    EXCEPTION
      WHEN others THEN
        prc_gera_log_erros ('Erro ao carregar acrescimos e deducoes para DI de Recof ' || vc_erro || '. ' || sqlerrm, 'E', 'D');
    END p_prc_carrega_dcl_lin_ad_nac;

    PROCEDURE imp_prc_calcula_impostos_adi (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER, pn_empresa_id NUMBER, pc_dsi VARCHAR2) IS
      CURSOR cur_declaracao_adi (pn_dcl_adi_id    NUMBER) IS
        SELECT ida.aliq_ii_dev
             , ida.aliq_ii_red
             , ida.aliq_ii_acordo
             , ida.perc_red_ii
             , ida.tp_acordo
             , ida.aliq_ipi_dev
             , ida.aliq_ipi_red
             , ida.regtrib_ii_id
             , ida.regtrib_ipi_id
             , nvl (decode (ida.admissao_temporaria, 'S', 0, ida.vida_util), 0) * 12  vida_util_em_meses
             , nvl (ida.admissao_temporaria, 'N') admissao_temporaria
             , ida.vida_util
             , ida.zerar_impostos_proporcionais
             , cmx_pkg_tabelas.codigo(ida.regtrib_ii_id)  regtrib_ii
             , cmx_pkg_tabelas.codigo(ida.regtrib_ipi_id) regtrib_ipi
             , cmx_pkg_tabelas.codigo(ida.regtrib_pis_cofins_id) regtrib_pis_cofins
             , ida.class_fiscal_id
             , ida.regtrib_icms_id
             , ida.aliq_icms
             , ida.aliq_icms_red
             , ida.perc_red_icms
             , ida.regtrib_pis_cofins_id
             , ida.aliq_pis_dev
             , ida.aliq_cofins_dev
             , ida.perc_reducao_base_pis_cofins
             , ida.aliq_icms_fecp
             , ida.aliq_pis_reduzida
             , ida.aliq_cofins_reduzida
             , ida.aliq_pis_especifica
             , ida.aliq_cofins_especifica
             , ida.qtde_um_aliq_especifica_pc
             , ida.vr_aliq_esp_antdump
             , ida.somatoria_quantidade
             , ida.aliq_antdump
             , ida.ex_prac_id
             , ida.ex_ncm_id
             , ida.ex_nbm_id
             , cmx_pkg_tabelas.codigo (ida.fundamento_legal_id) fund_legal_ii
             , ida.aliq_mva
             , ida.pr_aliq_base
             , ida.pr_perc_diferido
          FROM imp_declaracoes_adi ida
         WHERE declaracao_adi_id = pn_dcl_adi_id;

      -- Cursor identico ao do calculo do ICMS
      CURSOR cur_numer_com_baseicms ( pn_qtde_dcl NUMBER, pn_invoice_lin_id NUMBER, pn_declaracao_lin_id NUMBER ) IS
        SELECT Sum ( imp_fnc_qtde_dcl_lin_num_itens ( pn_qtde_dcl
                                                    , pn_declaracao_lin_id
                                                    , pn_invoice_lin_id
                                                    , ind.numerario_id )
                    * ( iild.valor_mn / imp_fnc_qtde_laudo( iil.invoice_lin_id
                                                          , iil.laudo_id
                                                          , iil.qtde
                                                          , iil.qtde_descarregada ) ) )  AS valor_unit_mn
          FROM imp_invoices_lin_dsp iild
             , imp_invoices_lin     iil
             , imp_numerarios_dsp   ind
             , cmx_numerarios_param cnp
         WHERE iild.invoice_lin_id  = pn_invoice_lin_id
           AND iil.invoice_lin_id   = iild.invoice_lin_id
           AND ind.numerario_dsp_id = iild.numerario_dsp_id
           AND cnp.numer_param_id   = ind.numer_param_id
           AND cnp.tp_nota          = 'NFE'
           AND cnp.gera_pis_cofins  = 'S'
           AND NOT EXISTS ( SELECT 1
                              FROM imp_embarques ebq
                                 , cmx_empresas   ce
                                 , cmx_numerarios_param_uf cnpu
                             WHERE ebq.embarque_id = iil.embarque_id
                               AND ce.empresa_id = ebq.empresa_id
                               AND cnpu.numer_param_id = ind.numer_param_id
                               AND cnpu.uf_id          = ce.uf_id
                          )
        UNION ALL
        SELECT Sum ( imp_fnc_qtde_dcl_lin_num_itens ( pn_qtde_dcl
                                                    , pn_declaracao_lin_id
                                                    , pn_invoice_lin_id
                                                    , ind.numerario_id )
                    * ( iild.valor_mn / imp_fnc_qtde_laudo( iil.invoice_lin_id
                                                          , iil.laudo_id
                                                          , iil.qtde
                                                          , iil.qtde_descarregada ) ) )  AS valor_unit_mn
          FROM imp_invoices_lin_dsp iild
             , imp_invoices_lin     iil
             , imp_embarques        ebq
             , cmx_empresas         ce
             , cmx_numerarios_param_uf cnpu
             , imp_numerarios_dsp   ind
             , cmx_numerarios_param cnp
         WHERE iild.invoice_lin_id  = pn_invoice_lin_id
           AND iil.invoice_lin_id   = iild.invoice_lin_id
           AND ind.numerario_dsp_id = iild.numerario_dsp_id
           AND cnp.numer_param_id   = ind.numer_param_id
           AND ebq.embarque_id      = iil.embarque_id
           AND ebq.empresa_id       = ce.empresa_id
           AND cnpu.numer_param_id  = cnp.numer_param_id
           AND cnpu.uf_id           = ce.uf_id
           AND cnpu.tp_nota          = 'NFE'
           AND cnp.gera_pis_cofins  = 'S';
           --AND cnp.gera_icms        = 'S';

      /************ Despesas para nacionalizações de recof ***********/
      CURSOR cur_numer_com_baseicms_recof (pn_declaracao_lin_id NUMBER) IS
        SELECT sum (idld.valor_mn) valor_unit_mn
          FROM imp_declaracoes         id
             , imp_declaracoes_lin     idl
             , imp_declaracoes_lin_dsp idld
             , imp_numerarios_dsp      ind
             , cmx_numerarios_param    cnp
         WHERE idld.declaracao_lin_id = pn_declaracao_lin_id
           AND idl.declaracao_lin_id  = idld.declaracao_lin_id
           AND ind.numerario_dsp_id = idld.numerario_dsp_id
           AND cnp.numer_param_id   = ind.numer_param_id
           AND id.declaracao_id     = idl.declaracao_id
           AND cnp.tp_nota          = 'NFE'
           AND cnp.gera_pis_cofins  = 'S'
           AND NOT EXISTS ( SELECT 1
                              FROM cmx_empresas   ce
                                 , cmx_numerarios_param_uf cnpu
                             WHERE ce.empresa_id = id.empresa_id
                               AND cnpu.numer_param_id = ind.numer_param_id
                               AND cnpu.uf_id          = ce.uf_id
                          )
        UNION ALL
        SELECT sum (idld.valor_mn) valor_unit_mn
          FROM imp_declaracoes         id
             , imp_declaracoes_lin     idl
             , imp_declaracoes_lin_dsp idld
             , imp_numerarios_dsp      ind
             , cmx_empresas            ce
             , cmx_numerarios_param_uf cnpu
             , cmx_numerarios_param    cnp
         WHERE idld.declaracao_lin_id = pn_declaracao_lin_id
           AND idl.declaracao_lin_id  = idld.declaracao_lin_id
           AND ind.numerario_dsp_id   = idld.numerario_dsp_id
           AND cnp.numer_param_id     = ind.numer_param_id
           AND id.declaracao_id       = idl.declaracao_id
           AND id.empresa_id          = ce.empresa_id
           AND cnpu.numer_param_id    = cnp.numer_param_id
           AND cnpu.uf_id             = ce.uf_id
           AND cnpu.tp_nota            = 'NFE'
           AND cnp.gera_pis_cofins    = 'S';

      CURSOR cur_numer_com_baseicms_adi( pn_declaracao_adi_id NUMBER ) IS
        SELECT sum (valor_mn * fator)
          FROM (SELECT iild.valor_mn
                     , (idl.qtde / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) fator
                     , idl.invoice_lin_id
                     , iil.invoice_lin_id
                       FROM imp_invoices_lin_dsp iild
                          , imp_invoices_lin     iil
                          , imp_declaracoes      id
                          , imp_declaracoes_lin  idl
                          , imp_numerarios_dsp   ind
                          , cmx_numerarios_param cnp
                      WHERE idl.declaracao_adi_id = pn_declaracao_adi_id
                        AND idl.invoice_lin_id    = iil.invoice_lin_id
                        AND iil.invoice_lin_id    = iild.invoice_lin_id
                        AND ind.numerario_dsp_id  = iild.numerario_dsp_id
                        AND idl.declaracao_id     = id.declaracao_id
                        AND cnp.numer_param_id    = ind.numer_param_id
                        AND cnp.tp_nota           = 'NFE'
                        AND cnp.gera_pis_cofins   = 'S'
                        AND NOT EXISTS ( SELECT 1
                                           FROM cmx_empresas   ce
                                              , cmx_numerarios_param_uf cnpu
                                          WHERE ce.empresa_id = id.empresa_id
                                            AND cnpu.numer_param_id = ind.numer_param_id
                                            AND cnpu.uf_id          = ce.uf_id
                                       )
                       /*************** fazer UNION com imp_declaracoes_lin_dsp ***************/
                      UNION ALL
                     SELECT idld.valor_mn  valor_mn
                          , 1 fator
                          , idl.invoice_lin_id
                          , null invoice_lin_id
                       FROM imp_declaracoes_lin_dsp idld
                          , imp_declaracoes_lin     idl
                          , imp_declaracoes         id
                          , cmx_empresas            ce
                          , cmx_numerarios_param_uf cnpu
                          , imp_numerarios_dsp      ind
                          , cmx_numerarios_param    cnp
                      WHERE idl.declaracao_adi_id = pn_declaracao_adi_id
                        AND idl.declaracao_lin_id = idld.declaracao_lin_id
                        AND idl.invoice_lin_id    IS null
                        AND ind.numerario_dsp_id  = idld.numerario_dsp_id
                        AND cnp.numer_param_id    = ind.numer_param_id
                        AND id.declaracao_id      = ce.empresa_id
                        AND cnpu.numer_param_id   = cnp.numer_param_id
                        AND cnpu.uf_id            = ce.uf_id
                        AND cnpu.tp_nota           = 'NFE'
                         AND cnp.gera_pis_cofins   = 'S'
               );

      CURSOR cur_ncm_tec( pn_class_fiscal_id NUMBER ) IS
        SELECT aliq_ii, aliq_ipi, aliq_pis, aliq_cofins, aliq_ii_mercosul
          FROM cmx_tab_ncm
         WHERE ncm_id = pn_class_fiscal_id;

      --Customização UHK
      CURSOR cur_quantidade_antidumping (pn_declaracao_adi_id NUMBER) IS
        SELECT sum ( decode ( cmx_pkg_tabelas.codigo (idl.um_aliq_especifica_antid_id)
                            , 'TON'
                            , (pesoliq_tot / 1000)
                            , decode ( idl.tipo_unidade_medida_antid, 'P', pesoliq_tot, qtde)
                            )
                   ), cmx_pkg_tabelas.codigo (idl.um_aliq_especifica_antid_id)
          FROM imp_declaracoes_lin idl
         WHERE idl.declaracao_adi_id = pn_declaracao_adi_id
         GROUP BY idl.tipo_unidade_medida_antid
                , idl.um_aliq_especifica_antid_id;

      CURSOR cur_estado_urf IS
        SELECT nvl (cmx_pkg_tabelas.auxiliar (id.urfd_id, 5), '*') urfd_estado
             , nvl (cmx_pkg_tabelas.auxiliar (id.urfe_id, 5), '*') urfe_estado
          FROM imp_embarques   ie
             , imp_declaracoes id
         WHERE id.embarque_id = ie.embarque_id
           AND ie.embarque_id = pn_embarque_id;

      /*chl/
      CURSOR cur_busca_ex(pn_adi_id NUMBER) IS
        SELECT excecao_ipi_id
          FROM imp_declaracoes_lin
         WHERE declaracao_id = pn_declaracao_id
           AND declaracao_adi_id = pn_adi_id;

      CURSOR cur_ex_ipi(pn_id NUMBER) IS
        SELECT aliquota
          FROM imp_excecoes_fiscais
         WHERE excecao_id = pn_id;

      vn_ipi_id   NUMBER;
      vn_ipi_aliq NUMBER;
      /chl*/

      cr_adi                          cur_declaracao_adi%ROWTYPE;
      --vn_vrt_dsp_icms               NUMBER      := 0;
      vn_vrt_dsp_pis_cofins           NUMBER      := 0;
      vn_aliq_ii_dev                  NUMBER      := 0;
      vn_aliq_ii_rec                  NUMBER      := 0;
      vn_aliq_ipi_rec                 NUMBER      := 0;
      vn_aliq_ii_tec                  NUMBER      := 0;
      vn_aliq_ii_merc                 NUMBER      := 0;
      vn_aliq_ipi_tec                 NUMBER      := 0;
      vn_aliq_pis_tec                 NUMBER      := 0;
      vn_aliq_cofins_tec              NUMBER      := 0;
      vn_aliq_pis_rec                 NUMBER      := 0;
      vn_aliq_cofins_rec              NUMBER      := 0;
      vn_valor_pis                    NUMBER      := 0;
      vn_valor_cofins                 NUMBER      := 0;
      vn_valor_pis_dev                NUMBER      := 0;
      vn_valor_cofins_dev             NUMBER      := 0;
      vn_basecalc_pis_cofins          NUMBER      := 0;
      vn_basecalc_pis_cofins_integr   NUMBER      := 0;
      vn_valor_pis_integral           NUMBER      := 0;
      vn_valor_cofins_integral        NUMBER      := 0;
      vn_base_ipi_para_icms           NUMBER      := 0;
      vn_valor_ipi_para_icms          NUMBER      := 0;
      vn_valor_pis_para_icms          NUMBER      := 0;
      vn_valor_cofins_para_icms       NUMBER      := 0;
      vn_valor_antid_para_icms        NUMBER      := 0;
      vn_taxa_fob_mn                  NUMBER      := 0;
      vn_taxa_fob_us                  NUMBER      := 0;
      vn_taxa_frete_mn                NUMBER      := 0;
      vn_taxa_frete_us                NUMBER      := 0;
      vn_taxa_seguro_mn               NUMBER      := 0;
      vn_taxa_seguro_us               NUMBER      := 0;
      vn_taxa_usd                     NUMBER      := 0;
      vn_paridade_usd                 NUMBER      := 0;
      vn_dummy                        NUMBER      := 0;
      vc_urfd_estado                  VARCHAR2(2) := null;
      vc_urfe_estado                  VARCHAR2(2) := null;
      vc_transbordo_icms_pr           VARCHAR2(1) := null;
      vb_adicao_consumo_adm_temp      boolean     := false;

      vt_rateio_basecalc_ii_lin       cmx_pkg_rateio.typ_rateio;
      vt_rateio_valor_ii_lin_rec      cmx_pkg_rateio.typ_rateio;
      vt_rateio_valor_ii_lin_dev      cmx_pkg_rateio.typ_rateio;
      vt_rateio_basecalc_ipi_lin      cmx_pkg_rateio.typ_rateio;
      vt_rateio_valor_ipi_lin_rec     cmx_pkg_rateio.typ_rateio;
      vt_rateio_valor_ipi_lin_dev     cmx_pkg_rateio.typ_rateio;
      vt_rateio_valor_base_pc         cmx_pkg_rateio.typ_rateio;
      vt_rateio_valor_base_pc_integr  cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_pis_rec            cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_cof_rec            cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_pis_dev            cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_cof_dev            cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_pis_integral       cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_cof_integral       cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_antid_aliq_espec   cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_antid_ad_valorem   cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_ii_proporcional    cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_ipi_proporcional   cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_pis_proporcional   cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_cofins_proporc     cmx_pkg_rateio.typ_rateio;
      vt_rateio_vr_antid_proporc      cmx_pkg_rateio.typ_rateio;
      vc_trace                        VARCHAR2(1000);
      vn_counter_linhas_adicao        NUMBER := 0;
      vc_un_med_aliq_especifica_pc VARCHAR2(200);

    BEGIN
      FOR adi IN 1..vn_global_dcl_adi LOOP
        vc_trace := 'Zerando variaveis';
        tb_dcl_adi(adi).valor_icms                     := 0;
        tb_dcl_adi(adi).valor_icms_dev                 := 0;
        tb_dcl_adi(adi).basecalc_icms                  := 0;
        tb_dcl_adi(adi).valor_icms_pro_emprego         := 0;
        tb_dcl_adi(adi).basecalc_icms_pro_emprego      := 0;
        tb_dcl_adi(adi).valor_pis                      := 0;
        tb_dcl_adi(adi).valor_cofins                   := 0;
        tb_dcl_adi(adi).valor_pis_dev                  := 0;
        tb_dcl_adi(adi).valor_cofins_dev               := 0;
        tb_dcl_adi(adi).basecalc_pis_cofins            := 0;
        tb_dcl_adi(adi).basecalc_pis_cofins_integral   := 0;
        tb_dcl_adi(adi).valor_pis_integral             := 0;
        tb_dcl_adi(adi).valor_cofins_integral          := 0;
        tb_dcl_adi(adi).basecalc_antdump               := 0;
        tb_dcl_adi(adi).qt_um_aliq_esp_antdump         := 0;
        tb_dcl_adi(adi).fator_admissao_temporaria      := 0;
        tb_dcl_adi(adi).basecalc_icms_st               := 0;
        tb_dcl_adi(adi).valor_icms_st                  := 0;
        tb_dcl_adi(adi).valor_diferido_icms_pr         := 0;
        tb_dcl_adi(adi).valor_cred_presumido_pr        := 0;
        tb_dcl_adi(adi).valor_cred_presumido_pr_devido := 0;
        tb_dcl_adi(adi).valor_devido_icms_pr           := 0;
        tb_dcl_adi(adi).valor_perc_vr_devido_icms_pr   := 0;
        tb_dcl_adi(adi).valor_perc_minimo_base_icms_pr := 0;
        tb_dcl_adi(adi).valor_perc_susp_base_icms_pr   := 0;
        vn_aliq_ii_tec                                 := 0;
        vn_aliq_ipi_tec                                := 0;
        vn_aliq_pis_tec                                := 0;
        vn_aliq_cofins_tec                             := 0;
        vn_taxa_usd                                    := 0;
        vn_paridade_usd                                := 0;
        vn_aliq_ii_dev                                 := 0;
        vb_adicao_consumo_adm_temp                     := false;
        tb_dcl_adi(adi).valor_fecp_dev                 := 0;
        tb_dcl_adi(adi).valor_fecp                     := 0;
        tb_dcl_adi(adi).valor_fecp_st                  := 0;
        tb_dcl_adi(adi).valor_icms_sem_fecp            := 0;
        tb_dcl_adi(adi).valor_icms_dev_sem_fecp        := 0;
        tb_dcl_adi(adi).valor_icms_st_sem_fecp         := 0;


        OPEN  cur_declaracao_adi ( tb_dcl_adi(adi).declaracao_adi_id );
        FETCH cur_declaracao_adi INTO cr_adi;
        CLOSE cur_declaracao_adi;

	       -- Devemos utilizar sempre a aliquota da TEC
     	  -- para que possamos calcular corretamente as aliquotas
        OPEN  cur_ncm_tec( cr_adi.class_fiscal_id ) ;
        FETCH cur_ncm_tec INTO vn_aliq_ii_tec, vn_aliq_ipi_tec, vn_aliq_pis_tec, vn_aliq_cofins_tec, vn_aliq_ii_merc;
        CLOSE cur_ncm_tec;

        /* OS CALCULOS ABAIXO FORAM COMENTADOS EM VIRTUDE DA ALTERACAO NO
           SISCOMEX. NOTICIA DO SISCOMEX NUMERO 0009 DE 26/02/2007.

        IF (pn_tp_declaracao = '12') THEN
          IF (cr_adi.ex_prac_id IS null AND cr_adi.ex_ncm_id IS null) THEN
            cr_adi.aliq_ii_dev  := vn_aliq_ii_tec;
          END IF;
          IF (cr_adi.ex_nbm_id IS null) THEN
            cr_adi.aliq_ipi_dev := vn_aliq_ipi_tec;
          END IF;
        END IF;
        */
        vc_trace := 'Base calculo II ' ;
        tb_dcl_adi(adi).basecalc_ii := ROUND( nvl(tb_dcl_adi(adi).vmle_mn     ,0) +
                                              nvl(tb_dcl_adi(adi).vrt_fr_mn   ,0) +
                                              nvl(tb_dcl_adi(adi).vrt_sg_mn   ,0) , 2 );

        IF     (cr_adi.tp_acordo IS NOT null)
           AND (   (cr_adi.regtrib_ii IN ('1', '5'))
                OR (cr_adi.regtrib_ii = '4' AND cr_adi.perc_red_ii > 0)
               )
        THEN
          vn_aliq_ii_dev := nvl (cr_adi.aliq_ii_acordo, 0);
        ELSE
          vn_aliq_ii_dev := cr_adi.aliq_ii_dev;
        END IF;

        tb_dcl_adi(adi).aliq_ii_dev  := cr_adi.aliq_ii_dev;
        tb_dcl_adi(adi).aliq_ipi_dev := cr_adi.aliq_ipi_dev;

        tb_dcl_adi(adi).aliq_ii_acordo := vn_aliq_ii_merc;

        vc_trace := 'Regime tributação do II';
        IF ( tb_dcl_adi(adi).basecalc_ii > 0 ) THEN
          vn_aliq_ii_rec := 0;

          IF (cr_adi.regtrib_ii = '4') THEN -- REDUÇÃO
            IF (cr_adi.perc_red_ii > 0) Then
              vn_aliq_ii_rec := vn_aliq_ii_dev - (vn_aliq_ii_dev * (cr_adi.perc_red_ii / 100));
            ELSE
              vn_aliq_ii_rec := cr_adi.aliq_ii_red;
            END IF;

          ELSIF (cr_adi.regtrib_ii = '1') THEN  -- INTEGRAL

            IF (cr_adi.tp_acordo IS NOT null) THEN
              vn_aliq_ii_rec := nvl (cr_adi.aliq_ii_acordo, 0);
            ELSE
              vn_aliq_ii_rec := vn_aliq_ii_dev;
            END IF;

          ELSIF (cr_adi.regtrib_ii IN ('7','8')) THEN  -- TRIB.SIMPL., TRIB.SIMPL.BAGAGEM
            vn_aliq_ii_rec := vn_aliq_ii_dev;
          END IF;

          /* OS CALCULOS ABAIXO FORAM COMENTADOS EM VIRTUDE DA ALTERACAO NO
             SISCOMEX. NOTICIA DO SISCOMEX NUMERO 0009 DE 26/02/2007.

          vc_trace := 'Cálculo proporcional do II CONSUMO E ADMISSÃO TEMPORARIA';
          ------------------------------------------------------------------------------------
          -- Cálculo proporcional do CONSUMO E ADMISSÃO TEMPORARIA
          --
          -- Quando é efetuado uma admissão temporária com pagamento
          -- proporcional de tributo devemos achar a alíquota
          -- proporcional ao tempo de permanencia, veja a formula:
          --
          -- A = (Base de Calculo * Alíquota Integral)
          --         +-                                         -+
          -- B = A * |1 - ((12 * Vida Util) - Tempo Permanencia) |
          --         |    -------------------------------------- |
          --         |               (12 * Vida Util)            |
          --         +-                                         -+
          -- A é igual a pagamento integral e B pagamento proporcional
          -- Para achar a alíquota basta fazer regra de 3
          -- A -> 100% (alíquota integral)
          -- B ->  x   (alíquota proporcional)
          -- Vida Util -> anos
          -- Tempo permanencia -> meses
          ------------------------------------------------------------------------------------
          IF (pn_tp_declaracao = '12') THEN
            -- Devemos utilizar sempre a aliquota da TEC
            -- para que possamos calcular o tempo de permanencia
            IF (cr_adi.vida_util_em_meses > 0) THEN
              vn_aliq_ii_rec := round( ( (tb_dcl_adi(adi).aliq_ii_dev/100) * ( vn_global_meses_permanencia / cr_adi.vida_util_em_meses) ) * 100,2);
            ELSE     -- Caso a vida util nao esteja preenchida e não seja EX considerar a aliquota da TEC. Para EX deixar a que está na adição.
              IF (cr_adi.ex_prac_id IS null AND cr_adi.ex_ncm_id IS null) THEN
                vn_aliq_ii_rec := tb_dcl_adi(adi).aliq_ii_dev;
              ELSE
                prc_gera_log_erros ('A vida útil não está preenchida para a adição '||to_char (adi)||' e existe EX tarifário!'||Chr(10)||
                                    'Verifique se a alíquota de II para ela está correta.', 'A','D');
              END IF;
            END IF;

            tb_dcl_adi(adi).aliq_ii_dev_original := tb_dcl_adi(adi).aliq_ii_dev;
            tb_dcl_adi(adi).aliq_ii_dev          := vn_aliq_ii_rec;

            -- Atualizado esta variavel porque o pis/cofins não lê a pl/sql table
            cr_adi.aliq_ii_dev                   := vn_aliq_ii_rec;

            IF cr_adi.regtrib_ii IN ('2','3','5','6') THEN -- IMUNIDADE, ISENCAO, SUSPENSAO, NAO INCIDENCIA
              vn_aliq_ii_rec := 0;
            END IF;
          END IF;
          ------------------------------------------------------------------------------------
          */
          /*chl/
          vn_ipi_id := NULL;
          vn_ipi_aliq := NULL;


          OPEN cur_busca_ex(tb_dcl_adi(adi).declaracao_adi_id);
          FETCH cur_busca_ex INTO vn_ipi_id;
          CLOSE cur_busca_ex;

          OPEN cur_ex_ipi(vn_ipi_id);
          FETCH cur_ex_ipi INTO vn_ipi_aliq;
          CLOSE cur_ex_ipi;
          /chl*/

          ----------------------
          -- IPI
          ----------------------
          vn_aliq_ipi_rec := 0;
          IF    (cr_adi.regtrib_ipi = '2') Then     -- REDUCAO
            vn_aliq_ipi_rec := cr_adi.aliq_ipi_red; --chl     Nvl(vn_ipi_aliq, cr_adi.aliq_ipi_red);
          ELSIF (cr_adi.regtrib_ipi = '4') Then     -- INTEGRAL
            vn_aliq_ipi_rec := tb_dcl_adi(adi).aliq_ipi_dev; --chl   Nvl(vn_ipi_aliq, tb_dcl_adi(adi).aliq_ipi_dev);
          END IF;
          ----------------------

          /* OS CALCULOS ABAIXO FORAM COMENTADOS EM VIRTUDE DA ALTERACAO NO
             SISCOMEX. NOTICIA DO SISCOMEX NUMERO 0009 DE 26/02/2007.

          vc_trace := 'Cálculo proporcional do IPI CONSUMO E ADMISSÃO TEMPORARIA';
          ------------------------------------------------------------------------------------
          -- Cálculo proporcional do CONSUMO E ADMISSÃO TEMPORARIA.
          ------------------------------------------------------------------------------------
          IF (pn_tp_declaracao = '12') THEN
            IF (cr_adi.vida_util_em_meses > 0) THEN
              vn_aliq_ipi_rec := round(
                                  (
                                    ( (tb_dcl_adi(adi).aliq_ipi_dev /100) * vn_global_meses_permanencia * (1 + (tb_dcl_adi(adi).aliq_ii_dev_original/100)) ) /
                                    ( cr_adi.vida_util_em_meses + ((tb_dcl_adi(adi).aliq_ii_dev_original/100) * vn_global_meses_permanencia) )
                                    *
                                    100
                                  )
                                 , 2 );
            ELSE
              IF (cr_adi.ex_nbm_id IS null) THEN
                vn_aliq_ipi_rec := tb_dcl_adi(adi).aliq_ipi_dev;
              ELSE
                prc_gera_log_erros ('A vida útil não está preenchida para a adição '||to_char (adi)||' e existe EX tarifário!'||Chr(10)||
                                    'Verifique se a alíquota de IPI para ela está correta.', 'A','D');
              END IF;
            END IF;

            tb_dcl_adi(adi).aliq_ipi_dev_original := tb_dcl_adi(adi).aliq_ipi_dev;
            tb_dcl_adi(adi).aliq_ipi_dev          := vn_aliq_ipi_rec;

            -- Atualizado esta variavel porque o pis/cofins não lê a pl/sql table
            cr_adi.aliq_ipi_dev := vn_aliq_ipi_rec;

            IF cr_adi.regtrib_ipi NOT IN ('2','4') THEN
              vn_aliq_ipi_rec := 0;
            END IF;
          END IF;
          */

          vc_trace := 'Cálculo do II ';
          ------------------------------------------------------------------------------------
          IF (nvl(cr_adi.regtrib_ii,'*') <> '6') THEN
            tb_dcl_adi(adi).valor_ii_dev := round (tb_dcl_adi(adi).basecalc_ii * (vn_aliq_ii_dev / 100), 2);
            tb_dcl_adi(adi).valor_ii_rec := round (tb_dcl_adi(adi).basecalc_ii * (vn_aliq_ii_rec / 100), 2);
          ELSE
            tb_dcl_adi(adi).valor_ii_dev := 0;
            tb_dcl_adi(adi).valor_ii_rec := 0;
          END IF;

          IF (cr_adi.regtrib_ii = '5') THEN -- SUSPENSÃO
            tb_dcl_adi(adi).basecalc_ipi := round (tb_dcl_adi(adi).basecalc_ii + nvl (tb_dcl_adi(adi).valor_ii_dev, 0) , 2);
          ELSE
            tb_dcl_adi(adi).basecalc_ipi := round (tb_dcl_adi(adi).basecalc_ii + nvl (tb_dcl_adi(adi).valor_ii_rec, 0) , 2);
          END IF;

          IF (cr_adi.regtrib_ipi IS NOT null) THEN
            tb_dcl_adi(adi).valor_ipi_dev := round (tb_dcl_adi(adi).basecalc_ipi * (tb_dcl_adi(adi).aliq_ipi_dev / 100), 2);
            tb_dcl_adi(adi).valor_ipi_rec := round (tb_dcl_adi(adi).basecalc_ipi * (vn_aliq_ipi_rec / 100), 2);
          ELSE
            IF (nvl (pc_dsi, 'N') = 'S') THEN
              --
              -- No Siscomex a DSI nao tem regime de tributacao do IPI, apenas do II. Sendo assim o Siscomex calcula
              -- o valor do IPI com base no mesmo regime do II.
              --
              IF (nvl(cr_adi.regtrib_ii,'*') <> '6') THEN
                tb_dcl_adi(adi).valor_ipi_dev := round (tb_dcl_adi(adi).basecalc_ipi * (tb_dcl_adi(adi).aliq_ipi_dev / 100), 2);
                tb_dcl_adi(adi).valor_ipi_rec := round (tb_dcl_adi(adi).basecalc_ipi * (vn_aliq_ipi_rec / 100), 2);
              ELSE
                tb_dcl_adi(adi).valor_ipi_dev := 0;
                tb_dcl_adi(adi).valor_ipi_rec := 0;
              END IF;
            ELSE
              tb_dcl_adi(adi).valor_ipi_dev := 0;
              tb_dcl_adi(adi).valor_ipi_rec := 0;
            END IF;
          END IF;

          vc_trace :='Abrindo cursor despesas que compoem a base de PIS/Cofins. ';

-- rodrigo: melhoria de performance
-- esses valores nao sao mais necessarios pois nao existem mais despesas que entram na base do pis/cofins
--** codigo excluido
--          OPEN  cur_numer_com_baseicms_adi( tb_dcl_adi(adi).declaracao_adi_id );
--          FETCH cur_numer_com_baseicms_adi INTO vn_vrt_dsp_pis_cofins; --vn_vrt_dsp_icms;
--          CLOSE cur_numer_com_baseicms_adi;
--**fim codigo excluido
--**codigo adicionado
               vn_vrt_dsp_pis_cofins := 0;
--**fim codigo adicionado
          --
          -- Calculando o PIS/COFINS da Adição utilizando a formula da COANA
          --
          imp_pkg_calcula_pis_cofins.imp_prc_pis_cofins_dcl_lin (
              pn_embarque_id
            , pd_data_conversao
            , tb_dcl_adi(adi).basecalc_ii                                    -- valor_aduaneiro
            , nvl (vn_vrt_dsp_pis_cofins, 0) -- nvl (vn_vrt_dsp_icms, 0)     -- vn_despesas
            , cr_adi.regtrib_ii                                              -- regtrib_II
            , cr_adi.aliq_ii_dev                                             -- aliq_ii
            , cr_adi.aliq_ii_acordo                                          -- aliq_ii_aco
            , cr_adi.aliq_ii_red                                             -- aliq_ii_red
            , cr_adi.perc_red_ii                                             -- aliq_ii_perc_red
            , cr_adi.regtrib_ipi                                             -- regtrib_IPI
            , cr_adi.aliq_ipi_dev                                            -- aliq_ipi
            , cr_adi.aliq_ipi_red                                            -- aliq_ipi_red
            , cr_adi.regtrib_icms_id                                         -- regime de tributação do ICMS
            , cr_adi.aliq_icms                                               -- aliq_icms
            , cr_adi.aliq_icms_red                                           -- aliq_icms_red
            , cr_adi.perc_red_icms                                           -- perc_red_icms
            , cmx_pkg_tabelas.codigo(cr_adi.regtrib_pis_cofins_id)           -- pc_piscofins_reg_trib
            , cr_adi.aliq_pis_dev                                            -- pn_pis_aliq
            , cr_adi.aliq_cofins_dev                                         -- pn_cofins_aliq
            , cr_adi.perc_reducao_base_pis_cofins                            -- pn_piscofins_perc_red
            , cr_adi.aliq_icms_fecp
            , cr_adi.aliq_pis_reduzida                                       -- pn_aliq_pis_reduzida            /* 22 */
            , cr_adi.aliq_cofins_reduzida                                    -- pn_aliq_cofins_reduzida         /* 23 */
            , cr_adi.aliq_pis_especifica                                     -- pn_aliq_pis_especifica          /* 24 */
            , cr_adi.qtde_um_aliq_especifica_pc                              -- pn_qtde_um_aliq_especifica_pis  /* 25 */
            , cr_adi.aliq_cofins_especifica                                  -- pn_aliq_cofins_especifica       /* 26 */
            , cr_adi.qtde_um_aliq_especifica_pc                              -- pn_qtde_um_aliq_especifica_cof  /* 27 */
            , tb_dcl_adi(adi).declaracao_adi_id                              -- pn_declaracao_adi_id            /* 28 */
            , vc_global_incide_aliq_icms_pc                                  -- incidir_perc_red_aliq_icms_pc   /* 29 */
            , null                                                           -- pc_tipo_ato_legal_ipi           /* 30 */
            , null                                                           -- pn_nr_ato_legal_ipi             /* 31 */
            , vn_basecalc_pis_cofins_integr                                  -- pn_base_pis_cofins_integral     /* 32 */
            , vn_basecalc_pis_cofins                                         -- pn_base_pis_cofins              /* 33 */
            , vn_valor_pis                                                   -- pn_valor_pis                    /* 34 */
            , vn_valor_cofins                                                -- pn_valor_cofins                 /* 35 */
            , vn_valor_pis_dev                                               -- pn_valor_pis_dev                /* 36 */
            , vn_valor_cofins_dev                                            -- pn_valor_cofins_dev             /* 37 */
            , vn_valor_pis_integral                                          -- pn_valor_pis_integral           /* 38 */
            , vn_valor_cofins_integral                                       -- pn_valor_cofins_integral        /* 39 */
          );

          vc_trace :='Atualizando valores PIS/COFINS adição ';
          tb_dcl_adi(adi).basecalc_pis_cofins_integral := vn_basecalc_pis_cofins_integr;   -- base calculada com as aliquotas integrais
          tb_dcl_adi(adi).basecalc_pis_cofins          := vn_basecalc_pis_cofins;          -- base do imposto para os valores dev e rec
          tb_dcl_adi(adi).valor_pis                    := vn_valor_pis;                    -- valor a recolher
          tb_dcl_adi(adi).valor_cofins                 := vn_valor_cofins;                 -- valor a recolher
          tb_dcl_adi(adi).valor_pis_dev                := vn_valor_pis_dev;                -- valor devido
          tb_dcl_adi(adi).valor_cofins_dev             := vn_valor_cofins_dev;             -- valor devido
          tb_dcl_adi(adi).valor_pis_integral           := vn_valor_pis_integral;           -- valor calculado com aliq integral
          tb_dcl_adi(adi).valor_cofins_integral        := vn_valor_cofins_integral;        -- valor calculado com aliq integral

          vn_aliq_pis_rec    := cr_adi.aliq_pis_dev;
          vn_aliq_cofins_rec := cr_adi.aliq_cofins_dev;

          ----------------------------------------------------------------------
          -- calculando ANTIDUMPING
          ----------------------------------------------------------------------
          IF (cr_adi.vr_aliq_esp_antdump IS NOT null) THEN
            imp_prc_busca_taxa_conversao ( cmx_pkg_tabelas.tabela_id ('906', 'USD')
                                         , pd_data_conversao
                                         , vn_taxa_usd
                                         , vn_paridade_usd
                                         , 'Antidumping. Conversao aliq especifica.'
                                         );

            tb_dcl_adi(adi).vr_aliq_esp_antdump_mn := round (cr_adi.vr_aliq_esp_antdump * vn_taxa_usd, 5);

            --Customização UHK
            OPEN  cur_quantidade_antidumping (tb_dcl_adi(adi).declaracao_adi_id);
            FETCH cur_quantidade_antidumping INTO tb_dcl_adi(adi).qt_um_aliq_esp_antdump, vc_un_med_aliq_especifica_pc;
            CLOSE cur_quantidade_antidumping;

            IF( vc_un_med_aliq_especifica_pc = 'TON' ) THEN
              tb_dcl_adi(adi).qt_um_aliq_esp_antdump := Ceil(tb_dcl_adi(adi).qt_um_aliq_esp_antdump);
            END IF;

            IF (cr_adi.somatoria_quantidade = 'T') THEN
              tb_dcl_adi(adi).qt_um_aliq_esp_antdump := trunc (tb_dcl_adi(adi).qt_um_aliq_esp_antdump);
            ELSE
              --tb_dcl_adi(adi).qt_um_aliq_esp_antdump := round (tb_dcl_adi(adi).qt_um_aliq_esp_antdump);
              tb_dcl_adi(adi).qt_um_aliq_esp_antdump := ceil (tb_dcl_adi(adi).qt_um_aliq_esp_antdump);
            END IF;

            tb_dcl_adi(adi).valor_antdump_aliq_especifica := round (tb_dcl_adi(adi).qt_um_aliq_esp_antdump * tb_dcl_adi(adi).vr_aliq_esp_antdump_mn, 2);
          ELSE
            tb_dcl_adi(adi).qt_um_aliq_esp_antdump        := null;
            tb_dcl_adi(adi).valor_antdump_aliq_especifica := null;
            tb_dcl_adi(adi).vr_aliq_esp_antdump_mn        := null;
          END IF;

          IF (cr_adi.aliq_antdump IS NOT null) THEN
            tb_dcl_adi(adi).basecalc_antdump         := tb_dcl_adi(adi).basecalc_ii;
            tb_dcl_adi(adi).valor_antdump_ad_valorem := round (tb_dcl_adi(adi).basecalc_antdump * (cr_adi.aliq_antdump / 100), 2);
          ELSE
            tb_dcl_adi(adi).basecalc_antdump         := null;
            tb_dcl_adi(adi).valor_antdump_ad_valorem := null;
          END IF;

          IF (tb_dcl_adi(adi).valor_antdump_aliq_especifica IS NOT null) OR (tb_dcl_adi(adi).valor_antdump_ad_valorem IS NOT null) THEN
            tb_dcl_adi(adi).valor_antdump := nvl (tb_dcl_adi(adi).valor_antdump_aliq_especifica, 0) +
                                             nvl (tb_dcl_adi(adi).valor_antdump_ad_valorem     , 0);
          ELSE
            tb_dcl_adi(adi).valor_antdump := null;
          END IF;

          tb_dcl_adi(adi).valor_antdump_dev := tb_dcl_adi(adi).valor_antdump;
          ----------------------------------------------------------------------
          -- fim do calculo do ANTIDUMPING
          ----------------------------------------------------------------------

          ----------------------------------------------------------------------
          -- Calculo dos impostos proporcionais para admissao temporaria
          -- nova forma de calculo legalizada pelo Art. 373, § 2º, Decreto 6.759
          -- de 05/02/2009: Novo Regulamento Aduaneiro
          ----------------------------------------------------------------------
          vc_trace := 'Checando se a adicao eh de consumo e admissao temporaria.';
          IF (cr_adi.admissao_temporaria = 'S') OR (cr_adi.vida_util IS NOT null) THEN
            vb_adicao_consumo_adm_temp := true;
          ELSE
            vb_adicao_consumo_adm_temp := false;
          END IF;

          vc_trace := 'Calculando impostos proporcionais para consumo e admissao temporaria.';
          IF (pn_tp_declaracao = '12') THEN
            IF (vn_global_meses_permanencia = 0) THEN
              tb_dcl_adi(adi).fator_admissao_temporaria := null;
              tb_dcl_adi(adi).valor_ii_proporcional     := null;
              tb_dcl_adi(adi).valor_ipi_proporcional    := null;
              tb_dcl_adi(adi).valor_pis_proporcional    := null;
              tb_dcl_adi(adi).valor_cofins_proporcional := null;
              tb_dcl_adi(adi).valor_antid_proporcional  := null;

              prc_gera_log_erros ('O tempo de permanencia da mercadoria no Brasil nao foi informado na capa da DI.', 'A','A');
            ELSE -- o tempo de permanecia esta preenchido
              IF (cr_adi.regtrib_ii = '5') AND (vb_adicao_consumo_adm_temp) AND (cr_adi.zerar_impostos_proporcionais = 'N') THEN -- SUSPENSÃO
                tb_dcl_adi(adi).valor_ii_proporcional := round (((tb_dcl_adi(adi).valor_ii_dev * (1/100)) * vn_global_meses_permanencia), 2);
              ELSE
                tb_dcl_adi(adi).valor_ii_proporcional := 0;
              END IF;

              IF (cr_adi.regtrib_ipi = '5') AND (vb_adicao_consumo_adm_temp) AND (cr_adi.zerar_impostos_proporcionais = 'N') THEN -- SUSPENSÃO
                tb_dcl_adi(adi).valor_ipi_proporcional := round (((tb_dcl_adi(adi).valor_ipi_dev * (1/100)) * vn_global_meses_permanencia), 2);
              ELSE
                tb_dcl_adi(adi).valor_ipi_proporcional := 0;
              END IF;

              IF (cr_adi.regtrib_pis_cofins = '2') AND (vb_adicao_consumo_adm_temp) AND (cr_adi.zerar_impostos_proporcionais = 'N') THEN -- SUSPENSÃO
                tb_dcl_adi(adi).valor_pis_proporcional    := round (((tb_dcl_adi(adi).valor_pis_dev    * (1/100)) * vn_global_meses_permanencia), 2);
                tb_dcl_adi(adi).valor_cofins_proporcional := round (((tb_dcl_adi(adi).valor_cofins_dev * (1/100)) * vn_global_meses_permanencia), 2);
              ELSE
                tb_dcl_adi(adi).valor_pis_proporcional    := 0;
                tb_dcl_adi(adi).valor_cofins_proporcional := 0;
              END IF;

              IF (tb_dcl_adi(adi).valor_antdump_dev IS NOT null) AND (vb_adicao_consumo_adm_temp) AND (cr_adi.zerar_impostos_proporcionais = 'N') THEN
                tb_dcl_adi(adi).valor_antid_proporcional := round (((tb_dcl_adi(adi).valor_antdump_dev * (1/100)) * vn_global_meses_permanencia), 2);
              ELSE
                tb_dcl_adi(adi).valor_antid_proporcional := null;
              END IF;
            END IF; -- IF (vn_global_meses_permanencia IS null) THEN
          ELSE -- declaracao <> '12'
            tb_dcl_adi(adi).fator_admissao_temporaria := null;
            tb_dcl_adi(adi).valor_ii_proporcional     := null;
            tb_dcl_adi(adi).valor_ipi_proporcional    := null;
            tb_dcl_adi(adi).valor_pis_proporcional    := null;
            tb_dcl_adi(adi).valor_cofins_proporcional := null;
            tb_dcl_adi(adi).valor_antid_proporcional  := null;
          END IF; -- IF (pn_tp_declaracao = '12') THEN
          ----------------------------------------------------------------------
          -- Fim do calculo dos impostos proporcionais para admissao temporaria
          ----------------------------------------------------------------------

          /*
            Calcular, rateando das adicoes para as linhas.
            -- Basecalc II = Baseado no CIF da linha
            -- Valor II = Baseado no CIF da linha
            -- Basecalc IPI = baseado no CIF+II da linha
            -- Valor IPI = baseado no CIF+II da linha
          */
          ------------------------------------------------------------------------------------------
          --- Carregando valores base das linhas da adicao corrente para fazer rateio do II...
          ------------------------------------------------------------------------------------------
          BEGIN
            vc_trace :='Inicializando variaveis para rateio de II e IPI ' || to_char(adi);
            vt_rateio_basecalc_ii_lin.delete;
            vt_rateio_valor_ii_lin_rec.delete;
            vt_rateio_valor_ii_lin_dev.delete;
            vt_rateio_basecalc_ipi_lin.delete;
            vt_rateio_valor_ipi_lin_rec.delete;
            vt_rateio_valor_ipi_lin_dev.delete;
            vt_rateio_valor_base_pc.delete;
            vt_rateio_valor_base_pc_integr.delete;
            vt_rateio_vr_pis_rec.delete;
            vt_rateio_vr_cof_rec.delete;
            vt_rateio_vr_pis_dev.delete;
            vt_rateio_vr_cof_dev.delete;
            vt_rateio_vr_pis_integral.delete;
            vt_rateio_vr_cof_integral.delete;
            vt_rateio_vr_antid_aliq_espec.delete;
            vt_rateio_vr_antid_ad_valorem.delete;
            vt_rateio_vr_ii_proporcional.delete;
            vt_rateio_vr_ipi_proporcional.delete;
            vt_rateio_vr_pis_proporcional.delete;
            vt_rateio_vr_cofins_proporc.delete;
            vt_rateio_vr_antid_proporc.delete;
            vn_counter_linhas_adicao := 0;
            vc_trace :='Carregando variáveis rateio do II. Adição: '||to_char(adi);

            FOR lin IN 1..vn_global_dcl_lin LOOP
              IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) THEN
                vn_counter_linhas_adicao := vn_counter_linhas_adicao + 1;
                --**************************************************************************
                -- Se a declaração não é nacionalização, temos que obter o valor aduaneiro
                -- a partir das linhas de invoice.
                -- Se a declaração é nacionalização, os valores de fob + dspfob + frete +
                -- seguro já são carregados pela rotina que carrega linhas de declaração
                -- de nacionalização. Precisamos também obter os acréscimos e deduções
                -- que são carregados pela rotina de agrupamento de acréscimos e deduções para
                -- somar ao CIF e obtermos o Valor Aduaneiro, que é a Base de Calculo do II.
                --**************************************************************************
                IF ( pn_tp_declaracao <> 16 ) THEN
                  FOR ivc IN 1..vn_global_ivc_lin LOOP
                    IF (tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(lin).invoice_lin_id) THEN
                      vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base :=  tb_ivc_lin(ivc).vmle_mn       *
                                                                                        (tb_dcl_lin(lin).qtde / tb_ivc_lin(ivc).qtde);
                    END IF;
                  END LOOP;
                ELSE
                  -- Obtendo taxas de moeda estrangeira para moeda nacional
                  imp_prc_busca_taxa_conversao ( tb_dcl_lin(lin).moeda_fob_id
                                               , pd_data_conversao
                                               , vn_taxa_fob_mn
                                               , vn_taxa_fob_us
                                               , 'Impostos. Moeda FOB.'
                                               );
                   vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base := (nvl(tb_dcl_lin(lin).vrt_fob_m   ,0) +
                                                                                     nvl(tb_dcl_lin(lin).vrt_dspfob_m,0)) * vn_taxa_fob_mn ;
                END IF;

                -- Habilitando calculo para Admissão temporaria
                IF (pn_tp_declaracao <= 13 OR vc_global_nac_sem_admissao = 'S' ) THEN
                  FOR ivc IN 1..vn_global_ivc_lin LOOP
                    IF (tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(lin).invoice_lin_id) THEN
                      vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base := ( vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base +
                                                                                          ( nvl(tb_ivc_lin(ivc).vrt_fr_mn, 0) +
                                                                                            nvl(tb_ivc_lin(ivc).vrt_sg_mn, 0) ) *
                                                                                            (tb_dcl_lin(lin).qtde / tb_ivc_lin(ivc).qtde) ) ;
                      vt_rateio_valor_ii_lin_rec(vn_counter_linhas_adicao).valor_base := vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base;
                      vt_rateio_valor_ii_lin_dev(vn_counter_linhas_adicao).valor_base := vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base;
                    END IF;
                  END LOOP;
                ELSE
                  -- Obtendo taxas de moeda estrangeira para moeda nacional
                  imp_prc_busca_taxa_conversao ( tb_dcl_lin(lin).moeda_frete_id
                                               , pd_data_conversao
                                               , vn_taxa_frete_mn
                                               , vn_taxa_frete_us
                                               , 'Impostos. Moeda Frete.'
                                               );

                  imp_prc_busca_taxa_conversao ( tb_dcl_lin(lin).moeda_seguro_id
                                               , pd_data_conversao
                                               , vn_taxa_seguro_mn
                                               , vn_taxa_seguro_us
                                               , 'Impostos. Moeda Seguro.'
                                               );

                  vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base := vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base +
                                                                                     nvl(tb_dcl_lin(lin).vrt_fr_m    ,0)  * vn_taxa_frete_mn +
                                                                                     nvl(tb_dcl_lin(lin).vrt_sg_m    ,0)  * vn_taxa_seguro_mn ;

                  --Jogando Acres/Ded no CIF para obter basecalc II.
                  FOR ivc_ad_lin IN 1..vn_global_ivc_ad_lin LOOP
                    IF (tb_ivc_lin_ad(ivc_ad_lin).invoice_lin_id = tb_dcl_lin(lin).invoice_lin_id) THEN
                      IF (tb_ivc_lin_ad(ivc_ad_lin).tp_acres_ded = 'A') THEN
                        vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base :=
                          vt_rateio_basecalc_ii_lin (vn_counter_linhas_adicao).valor_base + --Acrescer!
                          ( tb_ivc_lin_ad(ivc_ad_lin).valor_mn * --VALOR NA MOEDA NACIONAL
                          ( tb_dcl_lin(lin).qtde / tb_ivc_lin_ad(ivc_ad_lin).qtde_invoice) ) ;
                      ELSE
                        vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base :=
                          vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base - --Deduzir!
                          ( tb_ivc_lin_ad(ivc_ad_lin).valor_mn * --VALOR NA MOEDA NACIONAL
                          (tb_dcl_lin(lin).qtde / tb_ivc_lin_ad(ivc_ad_lin).qtde_invoice) ) ;
                      END IF;
                    END IF;
                  END LOOP;

                  vt_rateio_valor_ii_lin_rec(vn_counter_linhas_adicao).valor_base := vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base;
                  vt_rateio_valor_ii_lin_dev(vn_counter_linhas_adicao).valor_base := vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_base;
                END IF;
              END IF;
            END LOOP; -- FOR lin IN 1..vn_global_dcl_lin LOOP (II)

            -- Rateando valores de II para as linhas da adição corrente
            vc_trace :='Rateando basecalcii ('||to_char(tb_dcl_adi(adi).basecalc_ii)||' Adição: '||to_char(adi);

            cmx_pkg_rateio.ratear(vt_rateio_basecalc_ii_lin  , tb_dcl_adi(adi).basecalc_ii , 2);
            vc_trace :='Rateando valor II a recolher. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear(vt_rateio_valor_ii_lin_rec , tb_dcl_adi(adi).valor_ii_rec, 2);
            vc_trace :='Rateando valor II devido. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear(vt_rateio_valor_ii_lin_dev , tb_dcl_adi(adi).valor_ii_dev, 2);

            ------------------------------------------------------------------------------------------
            --- Carregando valores base das linhas da adicao corrente para fazer rateio do IPI...
            ------------------------------------------------------------------------------------------
            vc_trace :='Carregando variáveis para rateio do IPI. Adição: '||to_char(adi);
            vn_counter_linhas_adicao := 0;
            FOR lin IN 1..vn_global_dcl_lin LOOP
              IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) THEN
                vn_counter_linhas_adicao := vn_counter_linhas_adicao + 1;
                vt_rateio_basecalc_ipi_lin(vn_counter_linhas_adicao).valor_base :=  vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_rateado  +
                                                                                    vt_rateio_valor_ii_lin_rec(vn_counter_linhas_adicao).valor_rateado ;
                vt_rateio_valor_ipi_lin_rec(vn_counter_linhas_adicao).valor_base := vt_rateio_basecalc_ipi_lin(vn_counter_linhas_adicao).valor_base;
                vt_rateio_valor_ipi_lin_dev(vn_counter_linhas_adicao).valor_base := vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_rateado  +
                                                                                    vt_rateio_valor_ii_lin_dev(vn_counter_linhas_adicao).valor_rateado ;
              END IF;
            END LOOP; -- FOR lin IN 1..vn_global_dcl_lin LOOP (IPI)

            -- Rateando valores de IPI para as linhas da adição corrente
            vc_trace :='Rateando basecalcipi. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear(vt_rateio_basecalc_ipi_lin  , tb_dcl_adi(adi).basecalc_ipi , 2);
            vc_trace :='Rateando valor IPI a recolher. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear(vt_rateio_valor_ipi_lin_rec , tb_dcl_adi(adi).valor_ipi_rec, 2);
            vc_trace :='Rateando valor IPI devido. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear(vt_rateio_valor_ipi_lin_dev , tb_dcl_adi(adi).valor_ipi_dev, 2);

            --------------------------------------------------------------------------------------------
            --- Carregando valores base das linhas da adicao corrente para fazer rateio do pis/cofins...
            --------------------------------------------------------------------------------------------
            vc_trace :='Carregando variáveis para rateio do PIS/Cofins. Adição: '||to_char(adi);
            vn_counter_linhas_adicao := 0;
            FOR lin IN 1..vn_global_dcl_lin LOOP
              IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) THEN
                vn_counter_linhas_adicao := vn_counter_linhas_adicao + 1;

                imp_pkg_calcula_pis_cofins.imp_prc_pis_cofins_dcl_lin (
                   pn_embarque_id
                 , pd_data_conversao
                 , tb_dcl_lin(lin).basecalc_ii                                    -- valor_aduaneiro
                 , nvl (vn_vrt_dsp_pis_cofins, 0) -- nvl (vn_vrt_dsp_icms, 0)     -- vn_despesas
                 , cr_adi.regtrib_ii                                              -- regtrib_II
                 , cr_adi.aliq_ii_dev                                             -- aliq_ii
                 , cr_adi.aliq_ii_acordo                                          -- aliq_ii_aco
                 , cr_adi.aliq_ii_red                                             -- aliq_ii_red
                 , cr_adi.perc_red_ii                                             -- aliq_ii_perc_red
                 , cr_adi.regtrib_ipi                                             -- regtrib_IPI
                 , cr_adi.aliq_ipi_dev                                            -- aliq_ipi
                 , cr_adi.aliq_ipi_red                                            -- aliq_ipi_red
                 , cr_adi.regtrib_icms_id                                         -- regime de tributação do ICMS
                 , cr_adi.aliq_icms                                               -- aliq_icms
                 , cr_adi.aliq_icms_red                                           -- aliq_icms_red
                 , cr_adi.perc_red_icms                                           -- perc_red_icms
                 , cmx_pkg_tabelas.codigo(cr_adi.regtrib_pis_cofins_id)           -- pc_piscofins_reg_trib
                 , cr_adi.aliq_pis_dev                                            -- pn_pis_aliq
                 , cr_adi.aliq_cofins_dev                                         -- pn_cofins_aliq
                 , cr_adi.perc_reducao_base_pis_cofins                            -- pn_piscofins_perc_red
                 , cr_adi.aliq_icms_fecp
                 , cr_adi.aliq_pis_reduzida                                       -- pn_aliq_pis_reduzida            /* 22 */
                 , cr_adi.aliq_cofins_reduzida                                    -- pn_aliq_cofins_reduzida         /* 23 */
                 , cr_adi.aliq_pis_especifica                                     -- pn_aliq_pis_especifica          /* 24 */
                 , cr_adi.qtde_um_aliq_especifica_pc                              -- pn_qtde_um_aliq_especifica_pis  /* 25 */
                 , cr_adi.aliq_cofins_especifica                                  -- pn_aliq_cofins_especifica       /* 26 */
                 , cr_adi.qtde_um_aliq_especifica_pc                              -- pn_qtde_um_aliq_especifica_cof  /* 27 */
                 , tb_dcl_lin(lin).declaracao_adi_id                              -- pn_declaracao_adi_id            /* 28 */
                 , vc_global_incide_aliq_icms_pc                                  -- incidir_perc_red_aliq_icms_pc   /* 29 */
                 , null                                                           -- pc_tipo_ato_legal_ipi           /* 30 */
                 , null                                                           -- pn_nr_ato_legal_ipi             /* 31 */
                 , vt_rateio_valor_base_pc_integr(vn_counter_linhas_adicao).valor_base
                 , vt_rateio_valor_base_pc(vn_counter_linhas_adicao).valor_base
                 , vn_dummy
                 , vn_dummy
                 , vn_dummy
                 , vn_dummy
                 , vn_dummy
                 , vn_dummy
                );

                vt_rateio_vr_pis_rec(vn_counter_linhas_adicao).valor_base      := vt_rateio_valor_base_pc(vn_counter_linhas_adicao).valor_base;
                vt_rateio_vr_cof_rec(vn_counter_linhas_adicao).valor_base      := vt_rateio_valor_base_pc(vn_counter_linhas_adicao).valor_base;
                vt_rateio_vr_pis_dev(vn_counter_linhas_adicao).valor_base      := vt_rateio_valor_base_pc(vn_counter_linhas_adicao).valor_base;
                vt_rateio_vr_cof_dev(vn_counter_linhas_adicao).valor_base      := vt_rateio_valor_base_pc(vn_counter_linhas_adicao).valor_base;
                vt_rateio_vr_pis_integral(vn_counter_linhas_adicao).valor_base := vt_rateio_valor_base_pc_integr(vn_counter_linhas_adicao).valor_base;
                vt_rateio_vr_cof_integral(vn_counter_linhas_adicao).valor_base := vt_rateio_valor_base_pc_integr(vn_counter_linhas_adicao).valor_base;
              END IF; -- IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) THEN
            END LOOP; -- FOR lin IN 1..vn_global_dcl_lin LOOP (PIS/COFINS)

            -- Rateando valores de PIS/COFINS para as linhas da adição corrente
            vc_trace :='Rateando basecal_pis_cofins_integral. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_valor_base_pc_integr, tb_dcl_adi(adi).basecalc_pis_cofins_integral, 2);
            vc_trace :='Rateando basecal_pis_cofins. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_valor_base_pc       , tb_dcl_adi(adi).basecalc_pis_cofins         , 2);

            vc_trace :='Rateando valor PIS a recolher. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_vr_pis_rec, tb_dcl_adi(adi).valor_pis   , 2);
            vc_trace :='Rateando valor COFINS a recolher. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_vr_cof_rec, tb_dcl_adi(adi).valor_cofins, 2);

            vc_trace :='Rateando valor PIS devido. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_vr_pis_dev, tb_dcl_adi(adi).valor_pis_dev   , 2);
            vc_trace :='Rateando valor COFINS devido. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_vr_cof_dev, tb_dcl_adi(adi).valor_cofins_dev, 2);

            vc_trace :='Rateando valor PIS integral. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_vr_pis_integral, tb_dcl_adi(adi).valor_pis_integral   , 2);
            vc_trace :='Rateando valor COFINS integral. Adição: '||to_char(adi);
            cmx_pkg_rateio.ratear (vt_rateio_vr_cof_integral, tb_dcl_adi(adi).valor_cofins_integral, 2);

            ---------------------------------------------------------------------------------------------
            --- Carregando valores base das linhas da adicao corrente para fazer rateio do antidumping...
            ---------------------------------------------------------------------------------------------
            vc_trace :='Carregando variáveis para rateio do ANTIDUMPING. Adição: '||to_char(adi);
            vn_counter_linhas_adicao := 0;

            FOR lin IN 1..vn_global_dcl_lin LOOP
              IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) AND (tb_dcl_adi(adi).valor_antdump IS NOT null) THEN
                vn_counter_linhas_adicao := vn_counter_linhas_adicao + 1;

                IF (tb_dcl_lin(lin).aliq_antid_especifica IS NOT null) THEN
                  IF (tb_dcl_lin(lin).tipo_unidade_medida_antid = 'P') THEN
                    tb_dcl_lin(lin).qtde_um_aliq_especifica_antid := tb_dcl_lin(lin).pesoliq_tot;
                  ELSE
                    tb_dcl_lin(lin).qtde_um_aliq_especifica_antid := tb_dcl_lin(lin).qtde;
                  END IF;

                  vt_rateio_vr_antid_aliq_espec(vn_counter_linhas_adicao).valor_base := tb_dcl_lin(lin).qtde_um_aliq_especifica_antid;
                ELSE
                  tb_dcl_lin(lin).qtde_um_aliq_especifica_antid := null;
                  vt_rateio_vr_antid_aliq_espec(vn_counter_linhas_adicao).valor_base := 0;
                END IF;

                IF (tb_dcl_lin(lin).aliq_antid IS NOT null) THEN
                  tb_dcl_lin(lin).basecalc_antid := tb_dcl_lin(lin).basecalc_ii;
                  vt_rateio_vr_antid_ad_valorem(vn_counter_linhas_adicao).valor_base := tb_dcl_lin(lin).basecalc_antid;
                ELSE
                  tb_dcl_lin(lin).basecalc_antid := null;
                  vt_rateio_vr_antid_ad_valorem(vn_counter_linhas_adicao).valor_base := 0;
                END IF;
              END IF; -- fim do IF se as linhas pertencem a adicao
            END LOOP; -- fim do loop dos valores bases do antidumping

            -- Rateando valores de ANTIDUMPING para as linhas da adição corrente
            IF Nvl (tb_dcl_adi(adi).valor_antdump_aliq_especifica, 0) > 0 then
              vc_trace :='Rateando valor antidumping de aliquota especifica. Adição: '||to_char(adi);
              cmx_pkg_rateio.ratear (vt_rateio_vr_antid_aliq_espec, tb_dcl_adi(adi).valor_antdump_aliq_especifica, 2);
            END IF;

            IF Nvl (tb_dcl_adi(adi).valor_antdump_ad_valorem, 0) > 0 then
              vc_trace :='Rateando valor antidumping de aliquota ad valorem. Adição: '||to_char(adi);
              cmx_pkg_rateio.ratear (vt_rateio_vr_antid_ad_valorem, tb_dcl_adi(adi).valor_antdump_ad_valorem, 2);
            END IF;

            ------------------------------------------------------------------------------------------------------
            --- Carregando valores base das linhas da adicao corrente para fazer rateio dos impostos proporcionais
            ------------------------------------------------------------------------------------------------------
            IF (pn_tp_declaracao = '12') THEN
              vc_trace :='Carregando variáveis para rateio dos impostos proporcionais (dcl tipo 12). Adição: '||to_char(adi);
              vn_counter_linhas_adicao := 0;

              FOR lin IN 1..vn_global_dcl_lin LOOP
                IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) THEN
                  vn_counter_linhas_adicao := vn_counter_linhas_adicao + 1;

                  vt_rateio_vr_ii_proporcional(vn_counter_linhas_adicao).valor_base  := vt_rateio_valor_ii_lin_dev(vn_counter_linhas_adicao).valor_rateado;
                  vt_rateio_vr_ipi_proporcional(vn_counter_linhas_adicao).valor_base := vt_rateio_valor_ipi_lin_dev(vn_counter_linhas_adicao).valor_rateado;
                  vt_rateio_vr_pis_proporcional(vn_counter_linhas_adicao).valor_base := nvl (vt_rateio_vr_pis_dev(vn_counter_linhas_adicao).valor_rateado, 0);
                  vt_rateio_vr_cofins_proporc(vn_counter_linhas_adicao).valor_base   := nvl (vt_rateio_vr_cof_dev(vn_counter_linhas_adicao).valor_rateado, 0);

                  IF (tb_dcl_adi(adi).valor_antdump IS null) THEN
                    vt_rateio_vr_antid_proporc(vn_counter_linhas_adicao).valor_base := 0;
                  ELSE
                    vt_rateio_vr_antid_proporc(vn_counter_linhas_adicao).valor_base := nvl (vt_rateio_vr_antid_aliq_espec(vn_counter_linhas_adicao).valor_rateado, 0) +
                                                                                       nvl (vt_rateio_vr_antid_ad_valorem(vn_counter_linhas_adicao).valor_rateado, 0);
                  END IF;
                END IF;
              END LOOP; -- FOR lin IN 1..vn_global_dcl_lin LOOP (impostos proporcionais)

              -- Rateando valores de impostos proporcionais para as linhas da adição corrente
              IF (nvl (tb_dcl_adi(adi).valor_ii_proporcional, 0) > 0) THEN
                vc_trace :='Rateando II proporcional. Adição: '||to_char(adi);
                cmx_pkg_rateio.ratear(vt_rateio_vr_ii_proporcional, tb_dcl_adi(adi).valor_ii_proporcional, 2);
              END IF;

              IF (nvl (tb_dcl_adi(adi).valor_ipi_proporcional, 0) > 0) THEN
                vc_trace :='Rateando IPI proporcional. Adição: '||to_char(adi);
                cmx_pkg_rateio.ratear(vt_rateio_vr_ipi_proporcional, tb_dcl_adi(adi).valor_ipi_proporcional, 2);
              END IF;

              IF (nvl (tb_dcl_adi(adi).valor_pis_proporcional, 0) > 0) THEN
                vc_trace :='Rateando PIS proporcional. Adição: '||to_char(adi);
                cmx_pkg_rateio.ratear(vt_rateio_vr_pis_proporcional, tb_dcl_adi(adi).valor_pis_proporcional, 2);
              END IF;

              IF (nvl (tb_dcl_adi(adi).valor_cofins_proporcional, 0) > 0) THEN
                vc_trace :='Rateando COFINS proporcional. Adição: '||to_char(adi);
                cmx_pkg_rateio.ratear(vt_rateio_vr_cofins_proporc, tb_dcl_adi(adi).valor_cofins_proporcional, 2);
              END IF;

              IF (nvl (tb_dcl_adi(adi).valor_antid_proporcional, 0) > 0) THEN
                vc_trace :='Rateando ANTIDUMPING proporcional. Adição: '||to_char(adi);
                cmx_pkg_rateio.ratear(vt_rateio_vr_antid_proporc, tb_dcl_adi(adi).valor_antid_proporcional, 2);
              END IF;
            END IF; -- IF (pn_tp_declaracao = '12') THEN

          EXCEPTION
            WHEN OTHERS THEN
              prc_gera_log_erros ('Erro no rateio dos impostos para as linhas de declaração. '||vc_trace||'. '||sqlerrm, 'E','D');
          END ;

         -------------------------------------------------------------------------------------------------
         -- Descarregando nas linhas de declaracao da adicao corrente os valores de II e IPI rateados
         -- e calculando o ICMS da linha
         -------------------------------------------------------------------------------------------------
          vn_counter_linhas_adicao := 0;
          vc_trace :='Iniciando calculo do PIS/COFINS  ';
          FOR lin IN 1..vn_global_dcl_lin LOOP
            IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) THEN
              vn_counter_linhas_adicao  := vn_counter_linhas_adicao + 1;
              vn_base_ipi_para_icms     := 0;
              vn_valor_ipi_para_icms    := 0;
              vn_valor_pis_para_icms    := 0;
              vn_valor_cofins_para_icms := 0;
              vn_valor_antid_para_icms  := 0;
              vc_urfd_estado            := null;
              vc_urfe_estado            := null;
              vc_transbordo_icms_pr     := null;

              /* Delivery 59876
                 Busca no cadastro de COFINS Majorado se existe aliquota de custo para o NCM
              */
              tb_dcl_lin(lin).aliquota_cofins_custo := imp_fnc_ncm_cofins_majorado(tb_dcl_lin(lin).class_fiscal_id, pd_data_conversao);
              /*Delivery 96345*/
              IF (   ( tb_dcl_lin(lin).aliq_cofins_recuperar + tb_dcl_lin(lin).aliquota_cofins_custo)
                  <>  Nvl(tb_dcl_lin(lin).aliq_cofins_reduzida, tb_dcl_lin(lin).aliq_cofins)
                  AND (Nvl(tb_dcl_lin(lin).aliq_cofins_reduzida, tb_dcl_lin(lin).aliq_cofins) <> 0)
                 ) THEN

                prc_gera_log_erros ('Há majoração de '||tb_dcl_lin(lin).aliquota_cofins_custo||
                                      '% para a NCM '|| cmx_pkg_classificacao.codigo(tb_dcl_lin(lin).class_fiscal_id,1)||
                                      ', e a alíquota considerada na DI '|| Nvl(tb_dcl_lin(lin).aliq_cofins_reduzida, tb_dcl_lin(lin).aliq_cofins)||
                                      '% subtraida da majoração não confere com a alíquota recuperável de '||tb_dcl_lin(lin).aliq_cofins_recuperar||'%.'||
                                      ' Cálculo corrigido.', 'A', 'D');

                UPDATE cmx_log_erros
                    SET solucao  = 'Revisar o setup inserido na tela de COFINS Majorado (Comex > Comum > Cadastros > NCM > COFINS majorada) ou no cadastro da NCM.'
                      , elemento = 'A alíquota de COFINS a recuperar é atualizada na carga de tabelas de NCM com base no setup de COFINS Majorado.'
                WHERE log_erros_id = (SELECT Max(log_erros_id)
                                          FROM cmx_log_erros
                                        WHERE evento_id = vn_global_evento_id);
              END IF;

--              tb_dcl_lin(lin).aliq_cofins_recuperar := Nvl(tb_dcl_lin(lin).aliq_cofins_reduzida, tb_dcl_lin(lin).aliq_cofins) - Nvl(tb_dcl_lin(lin).aliquota_cofins_custo,0);
              tb_dcl_lin(lin).aliq_cofins_recuperar := greatest (
                                                          Nvl(tb_dcl_lin(lin).aliq_cofins_reduzida, tb_dcl_lin(lin).aliq_cofins) - Nvl(tb_dcl_lin(lin).aliquota_cofins_custo,0)
                                                        , 0
                                                       );
               /*Fim delivery 96345*/
              tb_dcl_lin(lin).aliq_ii_rec                  := vn_aliq_ii_rec;
              tb_dcl_lin(lin).aliq_ipi_rec                 := vn_aliq_ipi_rec;
              tb_dcl_lin(lin).basecalc_ii                  := vt_rateio_basecalc_ii_lin(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).valor_ii_dev                 := vt_rateio_valor_ii_lin_dev(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).valor_ii                     := vt_rateio_valor_ii_lin_rec(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).basecalc_ipi                 := vt_rateio_basecalc_ipi_lin(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).valor_ipi_dev                := vt_rateio_valor_ipi_lin_dev(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).valor_ipi                    := vt_rateio_valor_ipi_lin_rec(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).basecalc_pis_cofins_integral := vt_rateio_valor_base_pc_integr(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).basecalc_pis_cofins          := vt_rateio_valor_base_pc(vn_counter_linhas_adicao).valor_rateado;
              tb_dcl_lin(lin).valor_pis                    := nvl (vt_rateio_vr_pis_rec(vn_counter_linhas_adicao).valor_rateado, 0);
              tb_dcl_lin(lin).valor_cofins                 := nvl (vt_rateio_vr_cof_rec(vn_counter_linhas_adicao).valor_rateado, 0);
              tb_dcl_lin(lin).valor_pis_dev                := nvl (vt_rateio_vr_pis_dev(vn_counter_linhas_adicao).valor_rateado, 0);
              tb_dcl_lin(lin).valor_cofins_dev             := nvl (vt_rateio_vr_cof_dev(vn_counter_linhas_adicao).valor_rateado, 0);
              tb_dcl_lin(lin).valor_pis_integral           := nvl (vt_rateio_vr_pis_integral(vn_counter_linhas_adicao).valor_rateado, 0);
              tb_dcl_lin(lin).valor_cofins_integral        := nvl (vt_rateio_vr_cof_integral(vn_counter_linhas_adicao).valor_rateado, 0);

              IF ( tb_dcl_lin(lin).aliq_cofins = tb_dcl_lin(lin).aliq_cofins_recuperar OR Nvl(tb_dcl_lin(lin).aliq_cofins,0) = 0 ) THEN
                tb_dcl_lin(lin).valor_cofins_recuperar := tb_dcl_lin(lin).valor_cofins;
              ELSE
                tb_dcl_lin(lin).valor_cofins_recuperar := nvl (round (tb_dcl_lin(lin).basecalc_pis_cofins * (tb_dcl_lin(lin).aliq_cofins_recuperar / 100), 2), 0);
              END IF;

              IF (tb_dcl_adi(adi).valor_antdump IS null) THEN
                tb_dcl_lin(lin).valor_antid                 := null;
                tb_dcl_lin(lin).valor_antid_ad_valorem      := null;
                tb_dcl_lin(lin).valor_antid_aliq_especifica := null;
              ELSE
                tb_dcl_lin(lin).valor_antid := nvl (vt_rateio_vr_antid_aliq_espec(vn_counter_linhas_adicao).valor_rateado, 0) +
                                               nvl (vt_rateio_vr_antid_ad_valorem(vn_counter_linhas_adicao).valor_rateado, 0);
                tb_dcl_lin(lin).valor_antid_ad_valorem      := nvl (vt_rateio_vr_antid_ad_valorem(vn_counter_linhas_adicao).valor_rateado, 0);
                tb_dcl_lin(lin).valor_antid_aliq_especifica := nvl (vt_rateio_vr_antid_aliq_espec(vn_counter_linhas_adicao).valor_rateado, 0);
              END IF;

              tb_dcl_lin(lin).valor_antid_dev := tb_dcl_lin(lin).valor_antid;

              -- impostos proporcionais ==> somente declaracoes do tipo 12 (consumo e admissao temporaria)
              IF (pn_tp_declaracao = '12') THEN
                tb_dcl_lin(lin).valor_ii_proporcional     := nvl (vt_rateio_vr_ii_proporcional(vn_counter_linhas_adicao).valor_rateado , 0);
                tb_dcl_lin(lin).valor_ipi_proporcional    := nvl (vt_rateio_vr_ipi_proporcional(vn_counter_linhas_adicao).valor_rateado, 0);
                tb_dcl_lin(lin).valor_pis_proporcional    := nvl (vt_rateio_vr_pis_proporcional(vn_counter_linhas_adicao).valor_rateado, 0);
                tb_dcl_lin(lin).valor_cofins_proporcional := nvl (vt_rateio_vr_cofins_proporc(vn_counter_linhas_adicao).valor_rateado  , 0);
                tb_dcl_lin(lin).valor_antid_proporcional  := nvl (vt_rateio_vr_antid_proporc(vn_counter_linhas_adicao).valor_rateado   , 0);
              ELSE
                tb_dcl_lin(lin).valor_ii_proporcional     := null;
                tb_dcl_lin(lin).valor_ipi_proporcional    := null;
                tb_dcl_lin(lin).valor_pis_proporcional    := null;
                tb_dcl_lin(lin).valor_cofins_proporcional := null;
                tb_dcl_lin(lin).valor_antid_proporcional  := null;
              END IF;

              tb_dcl_lin(lin).aliq_pis      := vn_aliq_pis_rec;
              tb_dcl_lin(lin).aliq_cofins   := vn_aliq_cofins_rec;

              tb_dcl_lin(lin).basecalc_icms                  := 0;
              tb_dcl_lin(lin).valor_icms                     := 0;
              tb_dcl_lin(lin).basecalc_icms_pro_emprego      := 0;
              tb_dcl_lin(lin).valor_icms_pro_emprego         := 0;
              tb_dcl_lin(lin).basecalc_icms_st               := 0;
              tb_dcl_lin(lin).valor_icms_st                  := 0;
              tb_dcl_lin(lin).valor_diferido_icms_pr         := 0;
              tb_dcl_lin(lin).valor_cred_presumido_pr        := 0;
              tb_dcl_lin(lin).valor_cred_presumido_pr_devido := 0;
              tb_dcl_lin(lin).valor_devido_icms_pr           := 0;
              tb_dcl_lin(lin).valor_perc_vr_devido_icms_pr   := 0;
              tb_dcl_lin(lin).valor_perc_minimo_base_icms_pr := 0;
              tb_dcl_lin(lin).valor_perc_susp_base_icms_pr   := 0;
              tb_dcl_lin(lin).valor_fecp_st                  := 0;

              vc_trace :='Abrindo cursor despesas que compoem a base de PIS/Cofins. ';
-- rodrigo: melhoria de performance
-- esses valores nao sao mais necessarios pois nao existem mais despesas que entram na base do pis/cofins
--** codigo excluido
--              IF pc_tp_declaracao <> 16 THEN
--                OPEN  cur_numer_com_baseicms (
--                         tb_dcl_lin(lin).qtde
--                       , tb_dcl_lin(lin).invoice_lin_id
--                       , tb_dcl_lin(lin).declaracao_lin_id
--                      );
--                FETCH cur_numer_com_baseicms INTO vn_vrt_dsp_pis_cofins; --vn_vrt_dsp_icms;
--                CLOSE cur_numer_com_baseicms;
--              ELSE
--                OPEN  cur_numer_com_baseicms_recof (tb_dcl_lin(lin).declaracao_lin_id);
--                FETCH cur_numer_com_baseicms_recof INTO vn_vrt_dsp_pis_cofins;
--                CLOSE cur_numer_com_baseicms_recof;
--              END IF;
--**fim codigo excluido
--**codigo adicionado
               vn_vrt_dsp_pis_cofins := 0;
--**fim codigo adicionado
              --
              -- aqui era feito o calculo do pis/cofins para a linha da declaracao
              -- esse calculo agora eh feito na adicao e os valores encontrados la
              -- sao rateados para as linhas da declaracao, assim como ja eh feito
              -- com o ii e ipi.
              --

--              IF pc_tp_declaracao = 16 THEN
--                vn_declaracao_lin_nac_id := tb_dcl_lin(lin).declaracao_lin_id;
--              ELSE
--                vn_declaracao_lin_nac_id := null;
--              END IF;

              -- Não podemos usar o campo basecalc_ipi na chamada da rotina abaixo
              -- pois se o II é suspenso, o campo base de calculo IPI recebe o valor
              -- do II devido, enquanto para o cálculo do icms sempre precisamos dos
              -- valores recolhidos de II e IPI.
              IF    ((pn_tp_declaracao     = 12  ) AND (vc_global_calc_icms_imp_dev    = 'S') AND (vb_adicao_consumo_adm_temp))
                 OR ((pn_tp_declaracao     = 10  ) AND (vc_global_calc_icms_imp_dev_de = 'S'))
                 OR ((cr_adi.fund_legal_ii = '74') AND (vc_global_calc_icms_ip_dev_rcf = 'S'))
                 OR ((tb_dcl_lin(lin).rd_id IS NOT NULL) AND (vc_global_calc_icms_ip_dev_drw = 'S'))
              THEN
                vn_base_ipi_para_icms     := round( tb_dcl_lin(lin).basecalc_ii + tb_dcl_lin(lin).valor_ii_dev, 2 ) + nvl (tb_dcl_lin(lin).valor_ajuste_base_icms_mn, 0);
                vn_valor_ipi_para_icms    := tb_dcl_lin(lin).valor_ipi_dev;
                vn_valor_pis_para_icms    := tb_dcl_lin(lin).valor_pis_dev;
                vn_valor_cofins_para_icms := tb_dcl_lin(lin).valor_cofins_dev;
                vn_valor_antid_para_icms  := nvl (tb_dcl_lin(lin).valor_antid_dev, 0);
              ELSIF ((pn_tp_declaracao = 12) AND (vc_global_bicms_cons_adm_temp = 'R') AND (vb_adicao_consumo_adm_temp)) THEN
                vn_base_ipi_para_icms     := round( tb_dcl_lin(lin).basecalc_ii + tb_dcl_lin(lin).valor_ii_proporcional, 2 )+ nvl (tb_dcl_lin(lin).valor_ajuste_base_icms_mn, 0);
                vn_valor_ipi_para_icms    := tb_dcl_lin(lin).valor_ipi_proporcional;
                vn_valor_pis_para_icms    := tb_dcl_lin(lin).valor_pis_proporcional;
                vn_valor_cofins_para_icms := tb_dcl_lin(lin).valor_cofins_proporcional;
                vn_valor_antid_para_icms  := nvl (tb_dcl_lin(lin).valor_antid_proporcional, 0);
              ELSE
                vn_base_ipi_para_icms     := round( tb_dcl_lin(lin).basecalc_ii + tb_dcl_lin(lin).valor_ii, 2 )+ nvl (tb_dcl_lin(lin).valor_ajuste_base_icms_mn, 0);
                vn_valor_ipi_para_icms    := tb_dcl_lin(lin).valor_ipi;
                vn_valor_pis_para_icms    := tb_dcl_lin(lin).valor_pis;
                vn_valor_cofins_para_icms := tb_dcl_lin(lin).valor_cofins;
                vn_valor_antid_para_icms  := nvl (tb_dcl_lin(lin).valor_antid, 0);
              END IF;

              -- condicao extraida da package de calculo de ICMS (acrescida da condicao que verifica se a adicao eh adm temp)
              IF (pn_tp_declaracao = 12) AND (vc_global_bicms_cons_adm_temp IN ('V', 'P')) AND (vb_adicao_consumo_adm_temp) THEN
                vn_global_meses_permanec_icms := vn_global_meses_permanencia/100;
              ELSE
                vn_global_meses_permanec_icms := null;
              END IF;

              OPEN  cur_estado_urf;
              FETCH cur_estado_urf INTO vc_urfd_estado, vc_urfe_estado;
              CLOSE cur_estado_urf;

              IF (vc_urfd_estado = 'PR') AND (vc_urfd_estado <> vc_urfe_estado) THEN
                vc_transbordo_icms_pr := 'S';
              ELSE
                vc_transbordo_icms_pr := 'N';
              END IF;

              vc_trace :='Calculando ICMS ';
              imp_pkg_calcula_icms.imp_prc_icms_dcl_lin
                                   ( /* 01 */ tb_dcl_lin(lin).invoice_lin_id
                                   , /* 02 */ tb_dcl_lin(lin).qtde
                                   , /* 03 */ tb_dcl_lin(lin).aliq_icms_red
                                   , /* 04 */ tb_dcl_lin(lin).aliq_icms
                                   , /* 05 */ tb_dcl_lin(lin).perc_red_icms
                                   , /* 06 */ vn_base_ipi_para_icms
                                   , /* 07 */ vn_valor_ipi_para_icms
                                   , /* 08 */ tb_dcl_lin(lin).mscob_calcula_icms
                                   , /* 09 */ tb_dcl_lin(lin).tpdcl_calcula_icms
                                   , /* 10 */ tb_dcl_lin(lin).tpato_calcula_icms
                                   , /* 11 */ tb_dcl_lin(lin).sit_tributaria
                                   , /* 12 */ tb_dcl_lin(lin).valor_icms_dev
                                   , /* 13 */ tb_dcl_lin(lin).basecalc_icms
                                   , /* 14 */ tb_dcl_lin(lin).valor_icms
                                   , /* 15 */ tb_dcl_lin(lin).aliq_pis
                                   , /* 16 */ tb_dcl_lin(lin).aliq_cofins
                                   , /* 17 */ vn_valor_pis_para_icms
                                   , /* 18 */ vn_valor_cofins_para_icms
                                   , /* 19 */ tb_dcl_lin(lin).aliq_icms_fecp
                                   , /* 20 */ tb_dcl_lin(lin).valor_icms_fecp
                                   , /* 21 */ vn_global_meses_permanec_icms
                                   , /* 22 */ tb_dcl_lin(lin).basecalc_ii
                                   , /* 23 */ pn_tp_declaracao
                                   , /* 24 */ pn_empresa_id
                                   , /* 25 */ null
                                   , /* 26 */ vn_valor_antid_para_icms
                                   --, /* 27 */ vn_declaracao_lin_nac_id  /************** Somente quando FOR recof ***************/
                                   , /* 27 */ tb_dcl_lin(lin).declaracao_lin_id
                                   , /* 28 */ tb_dcl_lin(lin).valor_icms_da /************** Somente quando FOR recof ***************/
                                   , /* 29 */ tb_dcl_lin(lin).basecalc_icms_pro_emprego
                                   , /* 30 */ tb_dcl_lin(lin).valor_icms_pro_emprego
                                   , /* 31 */ tb_dcl_lin(lin).aliq_mva
                                   , /* 32 */ tb_dcl_lin(lin).basecalc_icms_st
                                   , /* 33 */ tb_dcl_lin(lin).valor_icms_st
                                   , /* 34 */ tb_dcl_lin(lin).pr_aliq_base
                                   , /* 35 */ tb_dcl_lin(lin).pr_perc_diferido
                                   , /* 36 */ tb_dcl_lin(lin).valor_diferido_icms_pr
                                   , /* 37 */ tb_dcl_lin(lin).valor_cred_presumido_pr
                                   , /* 38 */ nvl (vc_transbordo_icms_pr, 'N')
                                   , /* 39 */ tb_dcl_lin(lin).valor_cred_presumido_pr_devido
                                   , /* 40 */ tb_dcl_lin(lin).beneficio_pr_artigo
                                   , /* 41 */ tb_dcl_lin(lin).pr_perc_vr_devido
                                   , /* 42 */ tb_dcl_lin(lin).pr_perc_minimo_base
                                   , /* 43 */ tb_dcl_lin(lin).pr_perc_minimo_suspenso
                                   , /* 44 */ tb_dcl_lin(lin).valor_devido_icms_pr
                                   , /* 45 */ tb_dcl_lin(lin).valor_perc_vr_devido_icms_pr
                                   , /* 46 */ tb_dcl_lin(lin).valor_perc_minimo_base_icms_pr
                                   , /* 47 */ tb_dcl_lin(lin).valor_perc_susp_base_icms_pr
                                   , /* 48 */ tb_dcl_lin(lin).valor_ipi_dev
                                   , /* 49 */ tb_dcl_lin(lin).vlr_base_a_recolher_mn -- afrmm
                                   , /* 50 */ tb_dcl_lin(lin).valor_fecp_st
                                   , /* 51 */ tb_dcl_lin(lin).valor_fecp_dev
                                   , /* 52 */ tb_dcl_lin(lin).beneficio_suspensao
                                   , /* 53 */ tb_dcl_lin(lin).perc_beneficio_suspensao
                                   , /* 54 */ tb_dcl_lin(lin).regtrib_icms_id
                                   );

              vc_trace :='Atualizando valor do ICMS';
              tb_dcl_adi(adi).valor_icms_sem_fecp            := tb_dcl_adi(adi).valor_icms_sem_fecp            + tb_dcl_lin(lin).valor_icms;
              tb_dcl_adi(adi).valor_icms_dev_sem_fecp        := tb_dcl_adi(adi).valor_icms_dev_sem_fecp        + tb_dcl_lin(lin).valor_icms_dev;
              tb_dcl_adi(adi).basecalc_icms                  := tb_dcl_adi(adi).basecalc_icms                  + tb_dcl_lin(lin).basecalc_icms;
              tb_dcl_adi(adi).valor_icms_pro_emprego         := tb_dcl_adi(adi).valor_icms_pro_emprego         + tb_dcl_lin(lin).valor_icms_pro_emprego;
              tb_dcl_adi(adi).basecalc_icms_pro_emprego      := tb_dcl_adi(adi).basecalc_icms_pro_emprego      + tb_dcl_lin(lin).basecalc_icms_pro_emprego;
              tb_dcl_adi(adi).basecalc_icms_st               := tb_dcl_adi(adi).basecalc_icms_st               + tb_dcl_lin(lin).basecalc_icms_st;
              tb_dcl_adi(adi).valor_icms_st_sem_fecp         := tb_dcl_adi(adi).valor_icms_st_sem_fecp         + tb_dcl_lin(lin).valor_icms_st;
              tb_dcl_adi(adi).valor_diferido_icms_pr         := tb_dcl_adi(adi).valor_diferido_icms_pr         + tb_dcl_lin(lin).valor_diferido_icms_pr;
              tb_dcl_adi(adi).valor_cred_presumido_pr        := tb_dcl_adi(adi).valor_cred_presumido_pr        + tb_dcl_lin(lin).valor_cred_presumido_pr;
              tb_dcl_adi(adi).valor_cred_presumido_pr_devido := tb_dcl_adi(adi).valor_cred_presumido_pr_devido + tb_dcl_lin(lin).valor_cred_presumido_pr_devido;
              tb_dcl_adi(adi).valor_devido_icms_pr           := tb_dcl_adi(adi).valor_devido_icms_pr           + tb_dcl_lin(lin).valor_devido_icms_pr;
              tb_dcl_adi(adi).valor_perc_vr_devido_icms_pr   := tb_dcl_adi(adi).valor_perc_vr_devido_icms_pr   + tb_dcl_lin(lin).valor_perc_vr_devido_icms_pr;
              tb_dcl_adi(adi).valor_perc_minimo_base_icms_pr := tb_dcl_adi(adi).valor_perc_minimo_base_icms_pr + tb_dcl_lin(lin).valor_perc_minimo_base_icms_pr;
              tb_dcl_adi(adi).valor_perc_susp_base_icms_pr   := tb_dcl_adi(adi).valor_perc_susp_base_icms_pr   + tb_dcl_lin(lin).valor_perc_susp_base_icms_pr;
              tb_dcl_adi(adi).valor_fecp_dev                 := tb_dcl_adi(adi).valor_fecp_dev                 + tb_dcl_lin(lin).valor_fecp_dev;
              tb_dcl_adi(adi).valor_fecp                     := tb_dcl_adi(adi).valor_fecp                     + tb_dcl_lin(lin).valor_icms_fecp;
              tb_dcl_adi(adi).valor_fecp_st                  := tb_dcl_adi(adi).valor_fecp_st                  + tb_dcl_lin(lin).valor_fecp_st;
              tb_dcl_adi(adi).valor_icms                     := tb_dcl_adi(adi).valor_icms                     + tb_dcl_lin(lin).valor_icms     +  tb_dcl_lin(lin).valor_icms_fecp;
              tb_dcl_adi(adi).valor_icms_dev                 := tb_dcl_adi(adi).valor_icms_dev                 + tb_dcl_lin(lin).valor_icms_dev +  tb_dcl_lin(lin).valor_fecp_dev;
              tb_dcl_adi(adi).valor_icms_st                  := tb_dcl_adi(adi).valor_icms_st                  + tb_dcl_lin(lin).valor_icms_st  +  tb_dcl_lin(lin).valor_fecp_st;
            END IF;
          END LOOP;

          ----------------------------------------------------------------------------------
          vc_trace :='Atualizando valores globais ii';
          vn_global_vrt_ii_mn          := vn_global_vrt_ii_mn            + nvl (tb_dcl_adi(adi).valor_ii_rec , 0);
          vc_trace :='Atualizando valores globais ipi';
          vn_global_vrt_ipi_mn         := vn_global_vrt_ipi_mn           + nvl (tb_dcl_adi(adi).valor_ipi_rec, 0);
          vc_trace :='Atualizando valores globais icms';
          vn_global_vrt_icms_mn        := vn_global_vrt_icms_mn          + nvl (tb_dcl_adi(adi).valor_icms   , 0);
          vc_trace :='Atualizando valores globais icms_unitário (sem FECP)';
          vn_global_vrt_icms_mn_sem_fecp   := vn_global_vrt_icms_mn_sem_fecp     + nvl (tb_dcl_adi(adi).valor_icms_sem_fecp, 0);
          vc_trace :='Atualizando valores globais icms st';
          vn_global_vrt_icms_st_mn     := vn_global_vrt_icms_st_mn       + nvl (tb_dcl_adi(adi).valor_icms_st, 0);
          vc_trace :='Atualizando valores globais icms st unitário (sem FECP)';
          vn_global_vrt_icms_st_mn_sfecp := vn_global_vrt_icms_st_mn_sfecp + nvl (tb_dcl_adi(adi).valor_icms_st_sem_fecp, 0);
          vc_trace :='Atualizando valores globais pis';
          vn_global_vrt_pis_mn         := vn_global_vrt_pis_mn           + nvl (tb_dcl_adi(adi).valor_pis    , 0);
          vc_trace :='Atualizando valores globais cofins';
          vn_global_vrt_cofins_mn      := vn_global_vrt_cofins_mn        + nvl (tb_dcl_adi(adi).valor_cofins , 0);
          vc_trace :='Atualizando valores globais antidumping';
          vn_global_vrt_antidumping_mn := vn_global_vrt_antidumping_mn   + nvl (tb_dcl_adi(adi).valor_antdump, 0);
          vc_trace :='Atualizando valores globais de ii proporcional (cons e adm. temporaria - DCL tipo 12).';
          vn_global_vrt_ii_prop_mn       := vn_global_vrt_ii_prop_mn     + nvl (tb_dcl_adi(adi).valor_ii_proporcional    , 0);
          vc_trace :='Atualizando valores globais de ipi proporcional (cons e adm. temporaria - DCL tipo 12).';
          vn_global_vrt_ipi_prop_mn      := vn_global_vrt_ipi_prop_mn    + nvl (tb_dcl_adi(adi).valor_ipi_proporcional   , 0);
          vc_trace :='Atualizando valores globais de pis proporcional (cons e adm. temporaria - DCL tipo 12).';
          vn_global_vrt_pis_prop_mn      := vn_global_vrt_pis_prop_mn    + nvl (tb_dcl_adi(adi).valor_pis_proporcional   , 0);
          vc_trace :='Atualizando valores globais de cofins proporcional (cons e adm. temporaria - DCL tipo 12).';
          vn_global_vrt_cofins_prop_mn   := vn_global_vrt_cofins_prop_mn + nvl (tb_dcl_adi(adi).valor_cofins_proporcional, 0);
          vc_trace :='Atualizando valores globais de antidumping proporcional (cons e adm. temporaria - DCL tipo 12).';
          vn_global_vrt_antid_prop_mn    := vn_global_vrt_antid_prop_mn  + nvl (tb_dcl_adi(adi).valor_antid_proporcional , 0);
          vc_trace :='Atualizando valores globais fecp';
          vn_global_vrt_fecp_mn        := vn_global_vrt_fecp_mn          + tb_dcl_adi(adi).valor_fecp;
          vc_trace :='Atualizando valores globais fecp st';
          vn_global_vrt_fecp_st_mn     := vn_global_vrt_fecp_st_mn       + nvl (tb_dcl_adi(adi).valor_fecp_st, 0);

          vc_trace :='Fim atualizacao valores globais';
        ELSE
          vc_trace := 'Base de cálculo para o imposto de importação zerado';
          prc_gera_log_erros ('Base de cálculo para o imposto de importação zerado, impostos não calculados... ID Adição: [' || to_char(tb_dcl_adi(adi).declaracao_adi_id) || ']', 'E', 'D');
        END IF;  -- basecalc_ii > 0
      END LOOP;
    EXCEPTION
      WHEN others THEN
        prc_gera_log_erros ('Erro no cálculo de impostos: ' || vc_trace || ' BD: ' || sqlerrm, 'E', 'D');
    END imp_prc_calcula_impostos_adi;

  BEGIN  -- imp_prc_calcula_impostos
    IF pn_tp_declaracao <> 16 THEN
      vn_dcl := 1;
      FOR ivc IN 1..vn_global_ivc_lin LOOP
        vn_ind_fob_mn           := nvl (tb_ivc_lin(ivc).vrt_fob_mn                    / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_dspfob_mn        := nvl (tb_ivc_lin(ivc).vrt_dspfob_mn                 / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_acres_mn         := nvl (tb_ivc_lin(ivc).vrt_acres_mn                  / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_ded_mn           := nvl (tb_ivc_lin(ivc).vrt_ded_mn                    / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_ajuste_base_icms_mn := nvl (tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn    / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_vmle_mn          := nvl (tb_ivc_lin(ivc).vmle_mn                       / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_dsp_ddu_mn       := nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn                / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_fr_mn            := nvl (tb_ivc_lin(ivc).vrt_fr_mn                     / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_fr_total_mn      := nvl (tb_ivc_lin(ivc).vrt_fr_total_mn               / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_fr_prepaid_mn    := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_mn             / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_fr_collect_mn    := nvl (tb_ivc_lin(ivc).vrt_fr_collect_mn             / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_fr_terr_nac_mn   := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn / tb_ivc_lin(ivc).qtde, 0);
        vn_ind_sg_mn            := nvl (tb_ivc_lin(ivc).vrt_sg_mn                     / tb_ivc_lin(ivc).qtde, 0);

        vn_soma_fob_mn            := 0;
        vn_soma_dspfob_mn         := 0;
        vn_soma_acres_mn          := 0;
        vn_soma_ded_mn            := 0;
        vn_soma_ajuste_base_icms_mn := 0;
        vn_soma_vmle_mn           := 0;
        vn_soma_dsp_ddu_mn        := 0;
        vn_soma_fr_mn             := 0;
        vn_soma_fr_total_mn       := 0;
        vn_soma_fr_prepaid_mn     := 0;
        vn_soma_fr_collect_mn     := 0;
        vn_soma_fr_terr_nac_mn    := 0;
        vn_soma_sg_mn             := 0;
        vn_soma_pesoliq_ivc_linha := 0;
        vn_vmlc_m_adi             := 0;
        vn_vmlc_mn_adi            := 0;

        WHILE (    (vn_dcl <= vn_global_dcl_lin)
               AND (tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(vn_dcl).invoice_lin_id)
              )
        LOOP
          vn_peso_liq_da := 0;
          vn_peso_brt_da := 0;
          vn_da_lin_id   := null;
          vn_licenca_id  := null;


          IF pn_tp_declaracao = 17 THEN
            IF (Nvl(cmx_pkg_tabelas.auxiliar(pn_tp_embarque_id,1),'XX') <> 'NAC_DE_TERC') THEN
              OPEN  cur_linha_di_tem_li (tb_dcl_lin(vn_dcl).declaracao_lin_id);
              FETCH cur_linha_di_tem_li INTO vn_da_lin_id, vn_licenca_id;
              CLOSE cur_linha_di_tem_li;

              IF (vn_licenca_id IS null) THEN
                OPEN  cur_peso_liq_linha_da (tb_dcl_lin(vn_dcl).invoice_lin_id, vn_da_lin_id, tb_dcl_lin(vn_dcl).declaracao_lin_id);
                FETCH cur_peso_liq_linha_da INTO vn_peso_liq_da, vn_peso_brt_da;
                CLOSE cur_peso_liq_linha_da;

                tb_dcl_lin(vn_dcl).pesoliq_unit := vn_peso_liq_da / tb_dcl_lin(vn_dcl).qtde;
                tb_dcl_lin(vn_dcl).pesoliq_tot  := round (vn_peso_liq_da, 5);
                tb_dcl_lin(vn_dcl).pesobrt_unit := vn_peso_brt_da / tb_dcl_lin(vn_dcl).qtde;
                tb_dcl_lin(vn_dcl).pesobrt_tot  := vn_peso_brt_da;
              ELSE
                OPEN  cur_peso_brt_linha_da (tb_dcl_lin(vn_dcl).invoice_lin_id, vn_da_lin_id, tb_dcl_lin(vn_dcl).licenca_lin_id);
                FETCH cur_peso_brt_linha_da INTO vn_peso_brt_da;
                CLOSE cur_peso_brt_linha_da;

                tb_dcl_lin(vn_dcl).pesobrt_unit := vn_peso_brt_da / tb_dcl_lin(vn_dcl).qtde;
                tb_dcl_lin(vn_dcl).pesobrt_tot  := vn_peso_brt_da;
              END IF;
            ELSE
              tb_dcl_lin(vn_dcl).pesoliq_unit := tb_ivc_lin(ivc).pesoliq_unit;
              tb_dcl_lin(vn_dcl).pesoliq_tot  := round (tb_ivc_lin(ivc).pesoliq_unit * tb_dcl_lin(vn_dcl).qtde, 5);
              tb_ivc_lin(ivc).pesobrt_tot     := tb_ivc_lin(ivc).peso_bruto_nac;
              tb_dcl_lin(vn_dcl).pesobrt_tot  := (tb_ivc_lin(ivc).pesobrt_tot / tb_ivc_lin(ivc).qtde) * tb_dcl_lin(vn_dcl).qtde;


            END IF;
          ELSE
            tb_dcl_lin(vn_dcl).pesoliq_unit := tb_ivc_lin(ivc).pesoliq_unit;
            tb_dcl_lin(vn_dcl).pesoliq_tot  := round ((tb_ivc_lin(ivc).pesoliq_tot / tb_ivc_lin(ivc).qtde) * tb_dcl_lin(vn_dcl).qtde, 5);

            tb_dcl_lin(vn_dcl).pesobrt_tot  := (tb_ivc_lin(ivc).pesobrt_tot / tb_ivc_lin(ivc).qtde) * tb_dcl_lin(vn_dcl).qtde;
          END IF;
          vn_soma_pesoliq_ivc_linha       := vn_soma_pesoliq_ivc_linha + NVL( tb_dcl_lin(vn_dcl).pesoliq_tot, 0 );

          IF ((vn_dcl = vn_global_dcl_lin) OR (tb_ivc_lin(ivc).invoice_lin_id <> tb_dcl_lin(vn_dcl+1).invoice_lin_id)) Then
            vn_rateio_fob_mn            := nvl (tb_ivc_lin(ivc).vrt_fob_mn                   , 0) - vn_soma_fob_mn;
            vn_rateio_dspfob_mn         := nvl (tb_ivc_lin(ivc).vrt_dspfob_mn                , 0) - vn_soma_dspfob_mn;
            vn_rateio_acres_mn          := nvl (tb_ivc_lin(ivc).vrt_acres_mn                 , 0) - vn_soma_acres_mn;
            vn_rateio_ded_mn            := nvl (tb_ivc_lin(ivc).vrt_ded_mn                   , 0) - vn_soma_ded_mn;
            vn_rateio_ajuste_base_icms_mn := nvl (tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn      , 0) - vn_soma_ajuste_base_icms_mn;
            vn_rateio_vmle_mn           := nvl (tb_ivc_lin(ivc).vmle_mn                      , 0) - vn_soma_vmle_mn;
            vn_rateio_dsp_ddu           := nvl (tb_ivc_lin(ivc).vrt_dsp_ddu_mn               , 0) - vn_soma_dsp_ddu_mn;
            vn_rateio_fr_mn             := nvl (tb_ivc_lin(ivc).vrt_fr_mn                    , 0) - vn_soma_fr_mn;
            vn_rateio_fr_total_mn       := nvl (tb_ivc_lin(ivc).vrt_fr_total_mn              , 0) - vn_soma_fr_total_mn;
            vn_rateio_fr_prepaid_mn     := nvl (tb_ivc_lin(ivc).vrt_fr_prepaid_mn            , 0) - vn_soma_fr_prepaid_mn;
            vn_rateio_fr_collect_mn     := nvl (tb_ivc_lin(ivc).vrt_fr_collect_mn            , 0) - vn_soma_fr_collect_mn;
            vn_rateio_fr_terr_nac_mn    := nvl (tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn, 0) - vn_soma_fr_terr_nac_mn;
            vn_rateio_sg_mn             := nvl (tb_ivc_lin(ivc).vrt_sg_mn                    , 0) - vn_soma_sg_mn;

            IF (Nvl(cmx_pkg_tabelas.auxiliar(pn_tp_embarque_id,1),'XX') <> 'NAC_DE_TERC') THEN

            -- Jogando a diferença no ultimo item da linha da declaracao para aquela linha de invoice
            tb_dcl_lin(vn_dcl).pesoliq_tot  := (tb_dcl_lin(vn_dcl).pesoliq_tot + (  tb_ivc_lin(ivc).pesoliq_tot
                                                                                  - vn_soma_pesoliq_ivc_linha
                                                                                 )
                                               );
            END if;

          ELSE
            vn_rateio_fob_mn            := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_fob_mn, 0);
            vn_rateio_dspfob_mn         := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_dspfob_mn, 0);
            vn_rateio_acres_mn          := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_acres_mn, 0);
            vn_rateio_ded_mn            := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_ded_mn, 0);
            vn_rateio_ajuste_base_icms_mn := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_ajuste_base_icms_mn, 0);
            vn_rateio_vmle_mn           := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_vmle_mn, 0);
            vn_rateio_dsp_ddu           := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_dsp_ddu_mn, 0);
            vn_rateio_fr_mn             := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_fr_mn, 0);
            vn_rateio_fr_total_mn       := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_fr_total_mn, 0);
            vn_rateio_fr_prepaid_mn     := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_fr_prepaid_mn, 0);
            vn_rateio_fr_collect_mn     := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_fr_collect_mn, 0);
            vn_rateio_fr_terr_nac_mn    := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_fr_terr_nac_mn, 0);
            vn_rateio_sg_mn             := nvl (tb_dcl_lin(vn_dcl).qtde * vn_ind_sg_mn, 0);
          END IF;

          IF (tb_ivc_lin(ivc).taxa_mn_fob > 0) THEN
            vn_rateio_fob_m     := vn_rateio_fob_mn    / tb_ivc_lin(ivc).taxa_mn_fob;
            vn_rateio_dspfob_m  := vn_rateio_dspfob_mn / tb_ivc_lin(ivc).taxa_mn_fob;
            vn_rateio_acres_m   := vn_rateio_acres_mn  / tb_ivc_lin(ivc).taxa_mn_fob;
            vn_rateio_ded_m     := vn_rateio_ded_mn    / tb_ivc_lin(ivc).taxa_mn_fob;
            vn_rateio_ajuste_base_icms_m := vn_rateio_ajuste_base_icms_mn    / tb_ivc_lin(ivc).taxa_mn_fob;
          END IF;

          vn_soma_fob_mn         := vn_soma_fob_mn         + vn_rateio_fob_mn;
          vn_soma_dspfob_mn      := vn_soma_dspfob_mn      + vn_rateio_dspfob_mn;
          vn_soma_acres_mn       := vn_soma_acres_mn       + vn_rateio_acres_mn;
          vn_soma_ded_mn         := vn_soma_ded_mn         + vn_rateio_ded_mn;
          vn_soma_ajuste_base_icms_mn := vn_soma_ajuste_base_icms_mn + vn_rateio_ajuste_base_icms_mn;
          vn_soma_vmle_mn        := vn_soma_vmle_mn        + vn_rateio_vmle_mn;
          vn_soma_dsp_ddu_mn     := vn_soma_dsp_ddu_mn     + vn_rateio_dsp_ddu;
          vn_soma_fr_mn          := vn_soma_fr_mn          + vn_rateio_fr_mn;
          vn_soma_fr_total_mn    := vn_soma_fr_total_mn    + vn_rateio_fr_total_mn;
          vn_soma_fr_prepaid_mn  := vn_soma_fr_prepaid_mn  + vn_rateio_fr_prepaid_mn;
          vn_soma_fr_collect_mn  := vn_soma_fr_collect_mn  + vn_rateio_fr_collect_mn;
          vn_soma_fr_terr_nac_mn := vn_soma_fr_terr_nac_mn + vn_rateio_fr_terr_nac_mn;
          vn_soma_sg_mn          := vn_soma_sg_mn          + vn_rateio_sg_mn;

          -- Habilitando também para Admissão temporaria
          IF pn_tp_declaracao <= 13 OR vc_global_nac_sem_admissao = 'S' THEN
            IF (tb_ivc_lin(ivc).taxa_mn_fr > 0) THEN
              vn_rateio_fr_m          := vn_rateio_fr_mn          / tb_ivc_lin(ivc).taxa_mn_fr;
              vn_rateio_fr_total_m    := vn_rateio_fr_total_mn    / tb_ivc_lin(ivc).taxa_mn_fr;
              vn_rateio_fr_prepaid_m  := vn_rateio_fr_prepaid_mn  / tb_ivc_lin(ivc).taxa_mn_fr;
              vn_rateio_fr_collect_m  := vn_rateio_fr_collect_mn  / tb_ivc_lin(ivc).taxa_mn_fr;
              vn_rateio_fr_terr_nac_m := vn_rateio_fr_terr_nac_mn / tb_ivc_lin(ivc).taxa_mn_fr;
            END IF;

            IF (tb_ivc_lin(ivc).taxa_mn_sg > 0) THEN
              vn_rateio_sg_m := vn_rateio_sg_mn / tb_ivc_lin(ivc).taxa_mn_sg;
            END IF;

            tb_dcl_lin(vn_dcl).taxa_fob_mn := tb_ivc_lin(ivc).taxa_mn_fob;
            tb_dcl_lin(vn_dcl).taxa_fr_mn := tb_ivc_lin(ivc).taxa_mn_fr;       /************** incluidas essas taxas para nacionalizações de recof **************/
            tb_dcl_lin(vn_dcl).taxa_sg_mn := tb_ivc_lin(ivc).taxa_mn_sg;

          ELSE  -- NACIONALIZACAO
            IF (Nvl(cmx_pkg_tabelas.auxiliar(pn_tp_embarque_id,1),'XX') = 'NAC_DE_TERC') AND pn_tp_declaracao = 17 THEN

              SELECT iil.moeda_da_nac_id
                   , iil.moeda_sg_da_nac_id
                   , iil.valor_frete  / iil.qtde * tb_dcl_lin(vn_dcl).qtde
                   , iil.valor_frete  / iil.qtde * tb_dcl_lin(vn_dcl).qtde
                   , iil.valor_seguro / iil.qtde * tb_dcl_lin(vn_dcl).qtde
                INTO tb_dcl_lin(vn_dcl).moeda_frete_id
                   , tb_dcl_lin(vn_dcl).moeda_seguro_id
                   , tb_dcl_lin(vn_dcl).vrt_fr_m
                   , tb_dcl_lin(vn_dcl).vrt_fr_total_m
                   , tb_dcl_lin(vn_dcl).vrt_sg_m
                FROM imp_invoices_lin iil
               WHERE iil.invoice_lin_id = tb_ivc_lin(ivc).invoice_lin_id;
            END IF;


            imp_prc_busca_taxa_conversao (
               tb_dcl_lin(vn_dcl).moeda_frete_id
             , pd_data_conversao
             , vn_taxa_mn_fr
             , vn_taxa_us_fr
             , 'Frete'
            );

            imp_prc_busca_taxa_conversao (
               tb_dcl_lin(vn_dcl).moeda_seguro_id
             , pd_data_conversao
             , vn_taxa_mn_sg
             , vn_taxa_us_sg
             , 'Seguro'
            );


            vn_rateio_fr_m           := nvl (tb_dcl_lin(vn_dcl).vrt_fr_m                    , 0);
            vn_rateio_fr_total_m     := nvl (tb_dcl_lin(vn_dcl).vrt_fr_total_m              , 0);
            vn_rateio_fr_prepaid_m   := nvl (tb_dcl_lin(vn_dcl).vrt_fr_prepaid_m            , 0);
            vn_rateio_fr_collect_m   := nvl (tb_dcl_lin(vn_dcl).vrt_fr_collect_m            , 0);
            vn_rateio_fr_terr_nac_m  := nvl (tb_dcl_lin(vn_dcl).vrt_fr_territorio_nacional_m, 0);
            vn_rateio_sg_m           := nvl (tb_dcl_lin(vn_dcl).vrt_sg_m                    , 0);

            vn_rateio_fr_mn          := vn_rateio_fr_m          * nvl (vn_taxa_mn_fr, 0);
            vn_rateio_fr_total_mn    := vn_rateio_fr_total_m    * nvl (vn_taxa_mn_fr, 0);
            vn_rateio_fr_prepaid_mn  := vn_rateio_fr_prepaid_m  * nvl (vn_taxa_mn_fr, 0);
            vn_rateio_fr_collect_mn  := vn_rateio_fr_collect_m  * nvl (vn_taxa_mn_fr, 0);
            vn_rateio_fr_terr_nac_mn := vn_rateio_fr_terr_nac_m * nvl (vn_taxa_mn_fr, 0);
            vn_rateio_sg_mn          := vn_rateio_sg_m          * nvl (vn_taxa_mn_sg ,0);

            vn_rateio_fr_us          := vn_rateio_fr_m          * nvl (vn_taxa_us_fr, 0);
            vn_rateio_fr_total_us    := vn_rateio_fr_total_m    * nvl (vn_taxa_us_fr, 0);
            vn_rateio_fr_prepaid_us  := vn_rateio_fr_prepaid_m  * nvl (vn_taxa_us_fr, 0);
            vn_rateio_fr_collect_us  := vn_rateio_fr_collect_m  * nvl (vn_taxa_us_fr, 0);
            vn_rateio_fr_terr_nac_us := vn_rateio_fr_terr_nac_m * nvl (vn_taxa_us_fr, 0);
            vn_rateio_sg_us          := vn_rateio_sg_m          * nvl (vn_taxa_us_sg ,0);

            tb_dcl_lin(vn_dcl).taxa_fob_mn := tb_ivc_lin(ivc).taxa_mn_fob;
            tb_dcl_lin(vn_dcl).taxa_fr_mn := vn_taxa_mn_fr;       /************** incluidas essas taxas para nacionalizações de recof **************/
            tb_dcl_lin(vn_dcl).taxa_sg_mn := vn_taxa_mn_sg;

          END IF;

          tb_dcl_lin(vn_dcl).basecalc_ii := ROUND( vn_rateio_vmle_mn +
                                                   vn_rateio_fr_mn   +
                                                   vn_rateio_sg_mn, 2 );
          tb_dcl_lin(vn_dcl).valor_ajuste_base_icms_mn := ROUND( vn_rateio_ajuste_base_icms_mn, 2 );

          imp_carrega_adicao_dcl ( tb_dcl_lin(vn_dcl).declaracao_adi_id
                                 , tb_dcl_lin(vn_dcl).pesoliq_tot
                                 , tb_ivc_lin(ivc).taxa_mn_fob
                                 , tb_ivc_lin(ivc).taxa_us_fob
                                 , tb_ivc_lin(ivc).taxa_us_fr
                                 , tb_ivc_lin(ivc).taxa_us_sg
                                 , tb_ivc_lin(ivc).incoterm
                                 , tb_ivc_lin(ivc).tprateio_incoterm
                                 , tb_dcl_lin(vn_dcl).qtde
                                 , tb_dcl_lin(vn_dcl).declaracao_lin_id
                                 , vn_vmlc_m_adi
                                 , vn_vmlc_mn_adi
                                 );

          tb_dcl_lin(vn_dcl).vmlc_unit_m  := round (vn_vmlc_m_adi, 2) / tb_dcl_lin(vn_dcl).qtde;
          tb_dcl_lin(vn_dcl).vmle_unit_m  := round (vn_rateio_vmle_mn / tb_ivc_lin(ivc).taxa_mn_fob, 2) / tb_dcl_lin(vn_dcl).qtde;
          tb_dcl_lin(vn_dcl).vmle_unit_mn := round (vn_rateio_vmle_mn, 2) / tb_dcl_lin(vn_dcl).qtde;

          vn_dcl := vn_dcl + 1;
        END LOOP;  --- declaracao
      END LOOP; --- invoice

    ELSE  -- NACIONALIZACAO RECOF - TIPO 16
      tb_dcl_lin_ad.delete;
      p_prc_carrega_dcl_lin_ad_nac (pn_declaracao_id);

      vn_ant_declaracao_adi_id := 0;
      FOR dcl IN 1..vn_global_dcl_lin LOOP
        IF (vn_ant_declaracao_adi_id <> tb_dcl_lin(dcl).declaracao_adi_id) THEN
          vn_ant_declaracao_adi_id := tb_dcl_lin(dcl).declaracao_adi_id;
          imp_prc_busca_taxa_conversao (tb_dcl_lin(dcl).moeda_fob_id,
                                        pd_data_conversao,
                                        vn_taxa_mn_fob,
                                        vn_taxa_us_fob,
                                        'FOB');
          imp_prc_busca_taxa_conversao (tb_dcl_lin(dcl).moeda_frete_id,
                                        pd_data_conversao,
                                        vn_taxa_mn_fr,
                                        vn_taxa_us_fr,
                                        'Frete');
          imp_prc_busca_taxa_conversao (tb_dcl_lin(dcl).moeda_seguro_id,
                                        pd_data_conversao,
                                        vn_taxa_mn_sg,
                                        vn_taxa_us_sg,
                                        'Seguro');
        END IF;

        tb_dcl_lin(dcl).taxa_fob_mn := vn_taxa_mn_fob;
        tb_dcl_lin(dcl).taxa_fr_mn := vn_taxa_mn_fr;       /************** incluidas essas taxas para nacionalizações de recof **************/
        tb_dcl_lin(dcl).taxa_sg_mn := vn_taxa_mn_sg;

        vn_rateio_acres_mn := 0;
        vn_rateio_ded_mn   := 0;
        vn_rateio_ajuste_base_icms_mn   := 0;

        FOR dcl_ad_nac IN 1..vn_global_dcl_lin_ad_nac LOOP
          IF (tb_dcl_lin(dcl).declaracao_lin_id = tb_dcl_lin_ad(dcl_ad_nac).declaracao_lin_id) THEN
            vn_rateio_acres_mn := vn_rateio_acres_mn + tb_dcl_lin_ad(dcl_ad_nac).valor_acres_mn;
            vn_rateio_ded_mn   := vn_rateio_ded_mn   + tb_dcl_lin_ad(dcl_ad_nac).valor_ded_mn;
            vn_rateio_ajuste_base_icms_mn := vn_rateio_ajuste_base_icms_mn   + tb_dcl_lin_ad(dcl_ad_nac).valor_ajuste_base_icms_mn;
          END IF;
        END LOOP;

        vn_rateio_fob_mn         := nvl (tb_dcl_lin(dcl).vrt_fob_m                   , 0) * nvl (vn_taxa_mn_fob, 0);
        vn_rateio_dspfob_mn      := nvl (tb_dcl_lin(dcl).vrt_dspfob_m                , 0) * nvl (vn_taxa_mn_fob, 0);
        vn_rateio_fr_mn          := nvl (tb_dcl_lin(dcl).vrt_fr_m                    , 0) * nvl (vn_taxa_mn_fr , 0);
        vn_rateio_fr_total_mn    := nvl (tb_dcl_lin(dcl).vrt_fr_total_m              , 0) * nvl (vn_taxa_mn_fr , 0);
        vn_rateio_fr_prepaid_mn  := nvl (tb_dcl_lin(dcl).vrt_fr_prepaid_m            , 0) * nvl (vn_taxa_mn_fr , 0);
        vn_rateio_fr_collect_mn  := nvl (tb_dcl_lin(dcl).vrt_fr_collect_m            , 0) * nvl (vn_taxa_mn_fr , 0);
        vn_rateio_fr_terr_nac_mn := nvl (tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m, 0) * nvl (vn_taxa_mn_fr , 0);
        vn_rateio_sg_mn          := nvl (tb_dcl_lin(dcl).vrt_sg_m                    , 0) * nvl (vn_taxa_mn_sg , 0);
        vn_rateio_dsp_ddu        := nvl (tb_dcl_lin(dcl).vrt_dsp_ddu_m               , 0) * nvl (vn_taxa_mn_fob, 0);
        vn_rateio_vmle_mn        := vn_rateio_fob_mn
                                  + vn_rateio_dspfob_mn
                                  + vn_rateio_acres_mn
                                  - vn_rateio_ded_mn
                                  + vn_rateio_dsp_ddu;

        FOR ad IN 1..vn_global_ivc_ad_lin LOOP
          IF (tb_dcl_lin(dcl).declaracao_lin_id = tb_ivc_lin_ad(ad).declaracao_lin_id) THEN
            IF tb_ivc_lin_ad(ad).tp_acres_ded = 'A' THEN
              vn_rateio_acres_mn := vn_rateio_acres_mn + nvl(tb_ivc_lin_ad(ad).valor_mn ,0);
              vn_rateio_ajuste_base_icms_mn := vn_rateio_ajuste_base_icms_mn + nvl(tb_ivc_lin_ad(ad).valor_ajuste_base_icms_mn ,0) * -1;
            ELSE
              vn_rateio_ded_mn   := vn_rateio_ded_mn   + nvl(tb_ivc_lin_ad(ad).valor_mn ,0);
              vn_rateio_ajuste_base_icms_mn := vn_rateio_ajuste_base_icms_mn + nvl(tb_ivc_lin_ad(ad).valor_ajuste_base_icms_mn ,0);
            END IF;
          END IF;
        END LOOP;

        tb_dcl_lin(dcl).basecalc_ii := ROUND( vn_rateio_vmle_mn  +
                                              vn_rateio_fr_mn    +
                                              vn_rateio_sg_mn    +
                                              vn_rateio_acres_mn -
                                              vn_rateio_ded_mn, 2 );
        tb_dcl_lin(dcl).valor_ajuste_base_icms_mn := ROUND( vn_rateio_ajuste_base_icms_mn, 2 );

        IF (vn_taxa_mn_fob > 0) THEN
          vn_rateio_fob_m     := tb_dcl_lin(dcl).vrt_fob_m;
          vn_rateio_dspfob_m  := tb_dcl_lin(dcl).vrt_dspfob_m;
          vn_rateio_acres_m   := vn_rateio_acres_mn / vn_taxa_mn_fob;
          vn_rateio_ded_m     := vn_rateio_ded_mn   / vn_taxa_mn_fob;
          vn_rateio_ajuste_base_icms_m := vn_rateio_ajuste_base_icms_mn   / vn_taxa_mn_fob;
        END IF;

        vn_rateio_fr_m          := tb_dcl_lin(dcl).vrt_fr_m;
        vn_rateio_fr_total_m    := tb_dcl_lin(dcl).vrt_fr_total_m;
        vn_rateio_fr_prepaid_m  := tb_dcl_lin(dcl).vrt_fr_prepaid_m;
        vn_rateio_fr_collect_m  := tb_dcl_lin(dcl).vrt_fr_collect_m;
        vn_rateio_fr_terr_nac_m := tb_dcl_lin(dcl).vrt_fr_territorio_nacional_m;
        vn_rateio_sg_m          := tb_dcl_lin(dcl).vrt_sg_m;

        imp_carrega_adicao_dcl ( tb_dcl_lin(dcl).declaracao_adi_id
                               , tb_dcl_lin(dcl).pesoliq_tot
                               , vn_taxa_mn_fob
                               , vn_taxa_us_fob
                               , vn_taxa_us_fr
                               , vn_taxa_us_sg
                               , tb_dcl_lin(dcl).incoterm
                               , tb_dcl_lin(dcl).tprateio_incoterm
                               , tb_dcl_lin(dcl).qtde
                               , tb_dcl_lin(dcl).declaracao_lin_id
                               , vn_vmlc_m_adi
                               , vn_vmlc_mn_adi
                               );

        tb_dcl_lin(dcl).vmlc_unit_m  := round (vn_vmlc_m_adi, 2) / tb_dcl_lin(dcl).qtde;
        tb_dcl_lin(dcl).vmle_unit_m  := round (vn_rateio_vmle_mn / vn_taxa_mn_fob, 2) / tb_dcl_lin(dcl).qtde;
        tb_dcl_lin(dcl).vmle_unit_mn := round (vn_rateio_vmle_mn, 2) / tb_dcl_lin(dcl).qtde;

      END LOOP;
    END IF;

    /* Delivery 93140: Calcular o AFRMM nas linhas da declaração antes de calcular o ICMS, considerando que o AFRMM é base. */
    imp_prc_calcula_afrmm ( pn_tp_declaracao  => pn_tp_declaracao
                          , pd_data_conversao => pd_data_conversao
                          , pc_dsi            => pc_dsi
                          , pn_embarque_id    => pn_embarque_id );

    imp_prc_calcula_impostos_adi (pn_embarque_id, pn_tp_declaracao, pn_empresa_id, pc_dsi);
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro no cálculo dos impostos: ' || sqlerrm, 'E', 'D');
  END imp_prc_calcula_impostos;

  -- ***********************************************************************
  -- Rotina para gravar as linhas de invoice
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_linhas_ivc (pn_embarque_id NUMBER, pd_data_conversao DATE) IS

    CURSOR cur_verif_retif_rem(pn_embarque_id NUMBER) IS
      SELECT retificada
        FROM imp_po_remessa
       WHERE po_remessa_id = (SELECT po_remessa_id
                                FROM imp_po_remessa
                               WHERE embarque_id = pn_embarque_id
                                 AND nr_remessa = '1');

   vc_rem_retif                   VARCHAR2(1);

  BEGIN

    OPEN  cur_verif_retif_rem(pn_embarque_id);
    FETCH cur_verif_retif_rem INTO vc_rem_retif;
    CLOSE cur_verif_retif_rem;

    FOR ivc IN 1..vn_global_ivc_lin LOOP
      UPDATE imp_invoices_lin
         SET pesoliq_tot                        = tb_ivc_lin(ivc).pesoliq_tot
           , pesoliq_tot_di_unica_inicial       = Decode(vc_rem_retif,'S',pesoliq_tot_di_unica_inicial,tb_ivc_lin(ivc).pesoliq_tot)
           , pesobrt_tot                        = tb_ivc_lin(ivc).pesobrt_tot
           , vrt_frivc_m                        = tb_ivc_lin(ivc).vrt_frivc_m
           , vrt_sgivc_m                        = tb_ivc_lin(ivc).vrt_sgivc_m
           , vrt_fob_m                          = tb_ivc_lin(ivc).vrt_fob_m
           , vrt_fob_mn                         = tb_ivc_lin(ivc).vrt_fob_mn
           , vrt_fob_us                         = tb_ivc_lin(ivc).vrt_fob_us
           , vrt_dspfob_m                       = tb_ivc_lin(ivc).vrt_dspfob_m
           , vrt_dspfob_mn                      = tb_ivc_lin(ivc).vrt_dspfob_mn
           , vrt_dspfob_us                      = tb_ivc_lin(ivc).vrt_dspfob_us
           , vrt_fr_m                           = tb_ivc_lin(ivc).vrt_fr_m
           , vrt_fr_mn                          = tb_ivc_lin(ivc).vrt_fr_mn
           , vrt_fr_us                          = tb_ivc_lin(ivc).vrt_fr_us
           , vrt_fr_total_m                     = tb_ivc_lin(ivc).vrt_fr_total_m
           , vrt_fr_total_mn                    = tb_ivc_lin(ivc).vrt_fr_total_mn
           , vrt_fr_total_us                    = tb_ivc_lin(ivc).vrt_fr_total_us
           , vrt_fr_prepaid_m                   = tb_ivc_lin(ivc).vrt_fr_prepaid_m
           , vrt_fr_prepaid_mn                  = tb_ivc_lin(ivc).vrt_fr_prepaid_mn
           , vrt_fr_prepaid_us                  = tb_ivc_lin(ivc).vrt_fr_prepaid_us
           , vrt_fr_collect_m                   = tb_ivc_lin(ivc).vrt_fr_collect_m
           , vrt_fr_collect_mn                  = tb_ivc_lin(ivc).vrt_fr_collect_mn
           , vrt_fr_collect_us                  = tb_ivc_lin(ivc).vrt_fr_collect_us
           , vrt_fr_territorio_nacional_m       = tb_ivc_lin(ivc).vrt_fr_territorio_nacional_m
           , vrt_fr_territorio_nacional_mn      = tb_ivc_lin(ivc).vrt_fr_territorio_nacional_mn
           , vrt_fr_territorio_nacional_us      = tb_ivc_lin(ivc).vrt_fr_territorio_nacional_us
           , vrt_sg_m                           = tb_ivc_lin(ivc).vrt_sg_m
           , vrt_sg_mn                          = tb_ivc_lin(ivc).vrt_sg_mn
           , vrt_sg_us                          = tb_ivc_lin(ivc).vrt_sg_us
           , vrt_acres_m                        = tb_ivc_lin(ivc).vrt_acres_m
           , vrt_acres_mn                       = tb_ivc_lin(ivc).vrt_acres_mn
           , vrt_acres_us                       = tb_ivc_lin(ivc).vrt_acres_us
           , vrt_ded_m                          = tb_ivc_lin(ivc).vrt_ded_m
           , vrt_ded_mn                         = tb_ivc_lin(ivc).vrt_ded_mn
           , vrt_ded_us                         = tb_ivc_lin(ivc).vrt_ded_us
           , vmle_li_m                          = tb_ivc_lin(ivc).vmle_li_m
           , vmle_li_mn                         = tb_ivc_lin(ivc).vmle_li_mn
           , vmle_m                             = tb_ivc_lin(ivc).vmle_m
           , vmle_mn                            = tb_ivc_lin(ivc).vmle_mn
           , vmle_us                            = tb_ivc_lin(ivc).vmle_us
           , vmlc_m                             = tb_ivc_lin(ivc).vmlc_m
           , vmlc_mn                            = tb_ivc_lin(ivc).vmlc_mn
           , vmlc_li_m                          = tb_ivc_lin(ivc).vmlc_li_m
           , vrt_desconto_pgto_m                = tb_ivc_lin(ivc).vrt_descivc_m
           , vrt_desconto_pgto_impostos_m       = tb_ivc_lin(ivc).vrt_descsivc_m
           , vrt_dsp_ddu_m                      = tb_ivc_lin(ivc).vrt_dsp_ddu_m
           , vrt_dsp_ddu_mn                     = tb_ivc_lin(ivc).vrt_dsp_ddu_mn
           , vrt_dsp_ddu_us                     = tb_ivc_lin(ivc).vrt_dsp_ddu_us
       WHERE invoice_lin_id = tb_ivc_lin(ivc).invoice_lin_id;
     END LOOP;

    IF (pn_embarque_id IS NOT null) THEN
      IF (Nvl(vc_global_verif_di_unica, '*') <> 'DI_UNICA') THEN
        UPDATE imp_conhecimentos
           SET peso_liquido = vn_global_pesoliq_ebq
         WHERE conhec_id = vn_global_conhec_id;
      END IF;

      UPDATE imp_embarques
         SET vrt_sg_m            = vn_global_vrt_sg_ebq_m
           , vrt_sg_mn           = vn_global_vrt_sg_ebq_mn
           , vrt_sg_us           = vn_global_vrt_sg_ebq_us
           , data_taxa_conversao = pd_data_conversao
       --    , ebq_totalizado      = vc_global_ebq_totalizado Retirado update aqui porque em algumas situações o ebq era totalizado porem desmarcado
       WHERE embarque_id = pn_embarque_id;
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na gravação das linhas da invoice, embarque e conhecimento: ' || sqlerrm, 'E', 'A');
  END imp_prc_grava_linhas_ivc;

  -- ***********************************************************************
  -- Rotina para gravar o desdobramento dos POs das linhas de invoice
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_linhas_ivc_po IS
    vn_soma_fob_mn         NUMBER := 0;
    vn_soma_dspfob_mn      NUMBER := 0;
    vn_soma_fr_mn          NUMBER := 0;
    vn_soma_sg_mn          NUMBER := 0;
    vn_soma_acres_mn       NUMBER := 0;
    vn_soma_ded_mn         NUMBER := 0;
    vn_soma_ajuste_base_icms_mn NUMBER := 0;
    vn_rateio_fob_mn       NUMBER := 0;
    vn_rateio_dspfob_mn    NUMBER := 0;
    vn_rateio_fr_mn        NUMBER := 0;
    vn_rateio_sg_mn        NUMBER := 0;
    vn_rateio_acres_mn     NUMBER := 0;
    vn_rateio_ded_mn       NUMBER := 0;
    vn_rateio_ajuste_base_icms_mn  NUMBER := 0;
    vn_rateio_fob_m        NUMBER := 0;
    vn_rateio_dspfob_m     NUMBER := 0;
    vn_rateio_fr_m         NUMBER := 0;
    vn_rateio_sg_m         NUMBER := 0;
    vn_rateio_acres_m      NUMBER := 0;
    vn_rateio_ded_m        NUMBER := 0;
    vn_rateio_ajuste_base_icms_m  NUMBER := 0;
    vn_rateio_fob_us       NUMBER := 0;
    vn_rateio_dspfob_us    NUMBER := 0;
    vn_rateio_fr_us        NUMBER := 0;
    vn_rateio_sg_us        NUMBER := 0;
    vn_rateio_acres_us     NUMBER := 0;
    vn_rateio_ded_us       NUMBER := 0;
    vn_rateio_ajuste_base_icms_us NUMBER := 0;
    vn_ind_fob_mn          NUMBER := 0;
    vn_ind_dspfob_mn       NUMBER := 0;
    vn_ind_fr_mn           NUMBER := 0;
    vn_ind_sg_mn           NUMBER := 0;
    vn_ind_acres_mn        NUMBER := 0;
    vn_ind_ded_mn          NUMBER := 0;
    vn_ind_ajuste_base_icms_mn NUMBER := 0;
    vn_ultima_lin_po       NUMBER := 0;
    vn_count_lin_po        NUMBER := 0;

    CURSOR cur_count_invoices_lin_po (pn_invoice_lin_id NUMBER) IS
      SELECT COUNT(*)
        FROM imp_invoices_lin_po
       WHERE invoice_lin_id = pn_invoice_lin_id;

    CURSOR cur_invoices_lin_po (pn_invoice_lin_id NUMBER) IS
      SELECT po_qtde
        FROM imp_invoices_lin_po
       WHERE invoice_lin_id = pn_invoice_lin_id
      FOR UPDATE;

  BEGIN
    FOR ivc IN 1..vn_global_ivc_lin LOOP
      vn_ind_fob_mn    := tb_ivc_lin(ivc).vrt_fob_mn    / tb_ivc_lin(ivc).qtde;
      vn_ind_dspfob_mn := tb_ivc_lin(ivc).vrt_dspfob_mn / tb_ivc_lin(ivc).qtde;
      vn_ind_fr_mn     := tb_ivc_lin(ivc).vrt_fr_mn     / tb_ivc_lin(ivc).qtde;
      vn_ind_sg_mn     := tb_ivc_lin(ivc).vrt_sg_mn     / tb_ivc_lin(ivc).qtde;
      vn_ind_acres_mn  := tb_ivc_lin(ivc).vrt_acres_mn  / tb_ivc_lin(ivc).qtde;
      vn_ind_ded_mn    := tb_ivc_lin(ivc).vrt_ded_mn    / tb_ivc_lin(ivc).qtde;
      vn_ind_ajuste_base_icms_mn := tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn / tb_ivc_lin(ivc).qtde;
      vn_ultima_lin_po  := 0;
      vn_count_lin_po   := 0;
      vn_soma_fob_mn    := 0;
      vn_soma_dspfob_mn := 0;
      vn_soma_fr_mn     := 0;
      vn_soma_sg_mn     := 0;
      vn_soma_acres_mn  := 0;
      vn_soma_ded_mn    := 0;
      vn_soma_ajuste_base_icms_mn := 0;

      OPEN  cur_count_invoices_lin_po (tb_ivc_lin(ivc).invoice_lin_id);
      FETCH cur_count_invoices_lin_po INTO vn_ultima_lin_po;
      CLOSE cur_count_invoices_lin_po;

      FOR ivcpo IN cur_invoices_lin_po (tb_ivc_lin(ivc).invoice_lin_id) LOOP
        vn_count_lin_po := vn_count_lin_po + 1;
        IF (vn_count_lin_po = vn_ultima_lin_po) THEN
          vn_rateio_fob_mn    := tb_ivc_lin(ivc).vrt_fob_mn    - vn_soma_fob_mn;
          vn_rateio_dspfob_mn := tb_ivc_lin(ivc).vrt_dspfob_mn - vn_soma_dspfob_mn;
          vn_rateio_fr_mn     := tb_ivc_lin(ivc).vrt_fr_mn     - vn_soma_fr_mn;
          vn_rateio_sg_mn     := tb_ivc_lin(ivc).vrt_sg_mn     - vn_soma_sg_mn;
          vn_rateio_acres_mn  := tb_ivc_lin(ivc).vrt_acres_mn  - vn_soma_acres_mn;
          vn_rateio_ded_mn    := tb_ivc_lin(ivc).vrt_ded_mn    - vn_soma_ded_mn;
          vn_rateio_ajuste_base_icms_mn := tb_ivc_lin(ivc).vrt_ajuste_base_icms_mn - vn_soma_ajuste_base_icms_mn;
        ELSE
          vn_rateio_fob_mn    := ivcpo.po_qtde * vn_ind_fob_mn;
          vn_rateio_dspfob_mn := ivcpo.po_qtde * vn_ind_dspfob_mn;
          vn_rateio_fr_mn     := ivcpo.po_qtde * vn_ind_fr_mn;
          vn_rateio_sg_mn     := ivcpo.po_qtde * vn_ind_sg_mn;
          vn_rateio_acres_mn  := ivcpo.po_qtde * vn_ind_acres_mn;
          vn_rateio_ded_mn    := ivcpo.po_qtde * vn_ind_ded_mn;
          vn_rateio_ajuste_base_icms_mn := ivcpo.po_qtde * vn_ind_ajuste_base_icms_mn;
        END IF;

        vn_soma_fob_mn    := vn_soma_fob_mn    + vn_rateio_fob_mn;
        vn_soma_dspfob_mn := vn_soma_dspfob_mn + vn_rateio_dspfob_mn;
        vn_soma_fr_mn     := vn_soma_fr_mn     + vn_rateio_fr_mn;
        vn_soma_sg_mn     := vn_soma_sg_mn     + vn_rateio_sg_mn;
        vn_soma_acres_mn  := vn_soma_acres_mn  + vn_rateio_acres_mn;
        vn_soma_ded_mn    := vn_soma_ded_mn    + vn_rateio_ded_mn;
        vn_soma_ajuste_base_icms_mn := vn_soma_ajuste_base_icms_mn + vn_rateio_ajuste_base_icms_mn;

        IF (tb_ivc_lin(ivc).taxa_mn_fob > 0) THEN
          vn_rateio_fob_m    := vn_rateio_fob_mn    / tb_ivc_lin(ivc).taxa_mn_fob;
          vn_rateio_dspfob_m := vn_rateio_dspfob_mn / tb_ivc_lin(ivc).taxa_mn_fob;
          vn_rateio_acres_m  := vn_rateio_acres_mn  / tb_ivc_lin(ivc).taxa_mn_fob;
          vn_rateio_ded_m    := vn_rateio_ded_mn    / tb_ivc_lin(ivc).taxa_mn_fob;
          vn_rateio_ajuste_base_icms_m := vn_rateio_ajuste_base_icms_mn / tb_ivc_lin(ivc).taxa_mn_fob;
        ELSE
          vn_rateio_fob_m    := 0;
          vn_rateio_dspfob_m := 0;
          vn_rateio_acres_m  := 0;
          vn_rateio_ded_m    := 0;
          vn_rateio_ajuste_base_icms_m    := 0;
        END IF;

        IF (tb_ivc_lin(ivc).taxa_mn_fr > 0) THEN
          vn_rateio_fr_m     := vn_rateio_fr_mn / tb_ivc_lin(ivc).taxa_mn_fr;
        ELSE
          vn_rateio_fr_m     := 0;
        END IF;

        IF (tb_ivc_lin(ivc).taxa_mn_sg > 0) THEN
          vn_rateio_sg_m     := vn_rateio_sg_mn / tb_ivc_lin(ivc).taxa_mn_sg;
        ELSE
          vn_rateio_sg_m     := 0;
        END IF;

        vn_rateio_fob_us    := vn_rateio_fob_m    * tb_ivc_lin(ivc).taxa_us_fob;
        vn_rateio_dspfob_us := vn_rateio_dspfob_m * tb_ivc_lin(ivc).taxa_us_fob;
        vn_rateio_acres_us  := vn_rateio_acres_m  * tb_ivc_lin(ivc).taxa_us_fob;
        vn_rateio_ded_us    := vn_rateio_ded_m    * tb_ivc_lin(ivc).taxa_us_fob;
        vn_rateio_ajuste_base_icms_us := vn_rateio_ajuste_base_icms_m * tb_ivc_lin(ivc).taxa_us_fob;
        vn_rateio_fr_us     := vn_rateio_fr_m     * tb_ivc_lin(ivc).taxa_us_fr;
        vn_rateio_sg_us     := vn_rateio_sg_m     * tb_ivc_lin(ivc).taxa_us_sg;

        UPDATE imp_invoices_lin_po
           SET vrt_fob_m      = vn_rateio_fob_m
             , vrt_fob_mn     = vn_rateio_fob_mn
             , vrt_fob_us     = vn_rateio_fob_us
             , vrt_dspfob_m   = vn_rateio_dspfob_m
             , vrt_dspfob_mn  = vn_rateio_dspfob_mn
             , vrt_dspfob_us  = vn_rateio_dspfob_us
             , vrt_fr_m       = vn_rateio_fr_m
             , vrt_fr_mn      = vn_rateio_fr_mn
             , vrt_fr_us      = vn_rateio_fr_us
             , vrt_sg_m       = vn_rateio_sg_m
             , vrt_sg_mn      = vn_rateio_sg_mn
             , vrt_sg_us      = vn_rateio_sg_us
             , vrt_acres_m    = vn_rateio_acres_m
             , vrt_acres_mn   = vn_rateio_acres_mn
             , vrt_acres_us   = vn_rateio_acres_us
             , vrt_ded_m      = vn_rateio_ded_m
             , vrt_ajuste_base_icms_m      = vn_rateio_ajuste_base_icms_m
             , vrt_ded_mn     = vn_rateio_ded_mn
             , vrt_ajuste_base_icms_mn = vn_rateio_ajuste_base_icms_mn
             , vrt_ded_us     = vn_rateio_ded_us
             , vrt_ajuste_base_icms_us = vn_rateio_ajuste_base_icms_us
             , vmle_mn        = nvl(vn_rateio_fob_mn   , 0)
                              + nvl(vn_rateio_dspfob_mn, 0)
                              + nvl(vn_rateio_acres_mn , 0)
                              - nvl(vn_rateio_ded_mn   , 0)
         WHERE CURRENT OF cur_invoices_lin_po;
      END LOOP;
    END LOOP;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na gravação do desdobramento de PO das linhas da invoice: ' || sqlerrm, 'E', 'A');
  END imp_prc_grava_linhas_ivc_po;

  -- ***********************************************************************
  -- Rotina para gravar os acrescimos/deducoes rateados por linha de invoice
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_linhas_ivc_ad (pn_embarque_id NUMBER ) IS
    vc_error_text    VARCHAR2(2000) := null;

  BEGIN
    DELETE FROM imp_invoices_ad_lin
     WHERE invoice_lin_id in (SELECT invoice_lin_id
                                FROM imp_invoices_lin
                               WHERE embarque_id = pn_embarque_id);

    FOR ad IN 1..vn_global_ivc_ad_lin LOOP
      BEGIN
        INSERT INTO imp_invoices_ad_lin
                    ( embarque_ad_id
                    , invoice_lin_id
                    , moeda_id
                    , valor_m
                    , valor_mn
                    , valor_us
                    , valor_ajuste_base_icms_m
                    , valor_ajuste_base_icms_mn
                    , valor_ajuste_base_icms_us
                    , creation_date
                    , created_by
                    , last_update_date
                    , last_updated_by
                    , grupo_acesso_id
                    )
              VALUES( tb_ivc_lin_ad(ad).embarque_ad_id
                    , tb_ivc_lin_ad(ad).invoice_lin_id
                    , tb_ivc_lin_ad(ad).moeda_id
                    , tb_ivc_lin_ad(ad).valor_m
                    , tb_ivc_lin_ad(ad).valor_mn
                    , tb_ivc_lin_ad(ad).valor_us
                    , tb_ivc_lin_ad(ad).valor_ajuste_base_icms_m
                    , tb_ivc_lin_ad(ad).valor_ajuste_base_icms_mn
                    , tb_ivc_lin_ad(ad).valor_ajuste_base_icms_us
                    , vd_global_creation_date
                    , vn_global_created_by
                    , vd_global_last_update_date
                    , vn_global_last_updated_by
                    , vn_global_grupo_acesso_id
                    );
      EXCEPTION
        WHEN dup_val_on_index THEN
          -- se inseriu e deu o erro de chave primaria eh pq já existe o acres/ded para a linha de invoice
          -- isso ocorre quando tem uma linha de invoice que quebrou em mais de uma linha de declaracao
          -- por exemplo drawback.
          -- então apenas soma o valor na linha ja existente
          UPDATE imp_invoices_ad_lin
             SET valor_m  = valor_m  + tb_ivc_lin_ad(ad).valor_m
               , valor_mn = valor_mn + tb_ivc_lin_ad(ad).valor_mn
               , valor_us = valor_us + tb_ivc_lin_ad(ad).valor_us
               , valor_ajuste_base_icms_m  = valor_ajuste_base_icms_m  + tb_ivc_lin_ad(ad).valor_ajuste_base_icms_m
               , valor_ajuste_base_icms_mn = valor_ajuste_base_icms_mn + tb_ivc_lin_ad(ad).valor_ajuste_base_icms_mn
               , valor_ajuste_base_icms_us = valor_ajuste_base_icms_us + tb_ivc_lin_ad(ad).valor_ajuste_base_icms_us
           WHERE embarque_ad_id = tb_ivc_lin_ad(ad).embarque_ad_id
             AND invoice_lin_id = tb_ivc_lin_ad(ad).invoice_lin_id;

        WHEN others THEN
          vc_error_text := 'Erro na inclusão do rateio do acréscimo/dedução para linha da invoice...' || Chr(13) || sqlerrm;
          prc_gera_log_erros (vc_error_text, 'E', 'A');
      END;
    END LOOP;
  EXCEPTION
    WHEN others THEN
      vc_error_text := 'Erro na gravação do rateio dos acréscimos/deduções: ' || sqlerrm;
      prc_gera_log_erros (vc_error_text, 'E', 'A');
  END imp_prc_grava_linhas_ivc_ad;

  -- ***********************************************************************
  -- Rotina para gravar os dados da DA por linha de invoice
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_ivc_lin_da (pn_embarque_id NUMBER ) IS
    vc_error_text    VARCHAR2(2000) := null;

  BEGIN
    DELETE FROM imp_invoices_lin_da
     WHERE invoice_lin_id in (SELECT invoice_lin_id
                                FROM imp_invoices_lin
                               WHERE embarque_id = pn_embarque_id);

    FOR da_lin IN 1..vn_global_ivc_lin_da LOOP
      BEGIN
        INSERT INTO imp_invoices_lin_da
                    ( invoice_lin_da_id
                    , invoice_lin_id
                    , da_lin_id
                    , da_peso_liq_proporcional
                    , da_peso_brt_proporcional
                    , licenca_lin_id
                    , declaracao_lin_id
                    , grupo_acesso_id
                    )
              VALUES( /* invoice_lin_da_id        */ imp_invoices_lin_da_sq1.nextval
                    , /* invoice_lin_id           */ tb_ivc_lin_da(da_lin).invoice_lin_id
                    , /* da_lin_id                */ tb_ivc_lin_da(da_lin).da_lin_id
                    , /* da_peso_liq_proporcional */ tb_ivc_lin_da(da_lin).da_peso_liq_proporcional
                    , /* da_peso_brt_proporcional */ tb_ivc_lin_da(da_lin).da_peso_brt_proporcional
                    , /* licenca_lin_id           */ tb_ivc_lin_da(da_lin).licenca_lin_id
                    , /* declaracao_lin_id        */ tb_ivc_lin_da(da_lin).declaracao_lin_id
                    , /* grupo_acesso_id          */ vn_global_grupo_acesso_id
                    );
      EXCEPTION
        WHEN others THEN
          vc_error_text := 'Erro na inclusão do dos dados da linha da DA para a linha da invoice...' || Chr(13) || sqlerrm;
          prc_gera_log_erros (vc_error_text, 'E', 'A');
      END;
    END LOOP;
  EXCEPTION
    WHEN others THEN
      vc_error_text := 'Erro na gravação dos dados da linha da DA: ' || sqlerrm;
      prc_gera_log_erros (vc_error_text, 'E', 'A');
  END imp_prc_grava_ivc_lin_da;

  -- ***********************************************************************
  -- Rotina para gravar declaracao
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_declaracao (
     pn_tp_declaracao  NUMBER
   , pn_declaracao_id  NUMBER
   , pd_data_conversao DATE
   , pc_dsi            VARCHAR2
   , pn_embarque_id    NUMBER
   , pn_tp_embarque_id NUMBER DEFAULT NULL
  )
  IS

    tb_ad_adi_gravar  tb_adi_acresded;
   -- vn_ultima_adi_ad  NUMBER  := 0;
   -- vb_primeira_vez   BOOLEAN := TRUE;
   -- vn_ind_ad_mn      NUMBER  := 0;
   -- vn_soma_ad_mn     NUMBER  := 0;
   -- vn_soma_qtde      NUMBER  := 0;
   -- vn_rateio_ad_mn   NUMBER  := 0;
   -- vn_rateio_ad_m    NUMBER  := 0;
    vn_ind_ajuste_base_icms_mn NUMBER  := 0;
    vn_soma_ajuste_base_icms_mn NUMBER  := 0;
    vn_rateio_ajuste_base_icms_mn   NUMBER  := 0;
    vn_rateio_ajuste_base_icms_m    NUMBER  := 0;
    vn_contador       NUMBER  := 0;
    vn_mercosul_seq   NUMBER  := 0;
    vn_cont_lin       INTEGER := 0;
    ve_precisao       EXCEPTION;
    vn_da_id          NUMBER;
    vn_taxa_mn_nac    NUMBER;
    vn_taxa_us_nac    NUMBER;
    vn_moeda_fr_nac_id NUMBER;

    PRAGMA exception_init (ve_precisao, -1438);

    CURSOR cur_declaracoes_adi IS
      SELECT ida.declaracao_adi_id
           , ctn.codigo
           , decode (id.retif_sequencia
                    , 0
                    , ida.adicao_num
                    , decode ( ida.adicao_num
                             , 0
                             , 999
                             , ida.adicao_num)
                    ) adicao_num
        FROM imp_declaracoes     id
           , imp_declaracoes_adi ida
           , cmx_tab_ncm         ctn
       WHERE id.declaracao_id     = ida.declaracao_id
         AND ida.declaracao_id    = pn_declaracao_id
         AND ida.tp_classificacao = 1
         AND ctn.ncm_id           = ida.class_fiscal_id
       UNION
      SELECT ida.declaracao_adi_id
           , its.codigo
           , decode (id.retif_sequencia
                    , 0
                    , ida.adicao_num
                    , decode ( ida.adicao_num
                             , 0
                             , 999
                             , ida.adicao_num)
                    ) adicao_num
        FROM imp_declaracoes        id
           , imp_declaracoes_adi    ida
           , imp_trib_simplificada  its
       WHERE id.declaracao_id         = ida.declaracao_id
         AND ida.declaracao_id        = pn_declaracao_id
         AND ida.tp_classificacao     = 2
         AND its.trib_simplificada_id = ida.class_fiscal_id
       ORDER BY adicao_num, codigo;

    CURSOR cur_dados_mercosul IS
      SELECT nr_de_mercosul
           , nr_re_inicial
           , nr_re_final
        FROM imp_dcl_informacoes_mercosul
       WHERE declaracao_id = pn_declaracao_id
       ORDER BY nr_de_mercosul
           , nr_re_inicial
           , nr_re_final
         FOR UPDATE OF nr_seq_de;

    CURSOR cur_dados_mercosul_adi (pn_declaracao_adi_id NUMBER) IS
      SELECT nr_de_mercosul
           , nr_re_inicial
           , nr_re_final
        FROM imp_dcl_adi_mercosul
       WHERE declaracao_adi_id = pn_declaracao_adi_id
       ORDER BY nr_de_mercosul
           , nr_re_inicial
           , nr_re_final
         FOR UPDATE OF nr_seq_de;

    CURSOR cur_empresa_id IS
      SELECT empresa_id
        FROM imp_declaracoes
       WHERE declaracao_id = pn_declaracao_id;

    CURSOR cur_aliq_dif_icms_pr (pn_empresa_id NUMBER) IS
      SELECT arredonda_aliq_diferim_icms_pr
        FROM imp_empresas_param
      WHERE empresa_id = pn_empresa_id;

    CURSOR cur_da IS
      SELECT da_id
        FROM imp_declaracoes
       WHERE declaracao_id = pn_declaracao_id;

    vn_empresa_id                  NUMBER;
    vc_arredonda_aliq_dife_icms_pr imp_empresas_param.arredonda_aliq_diferim_icms_pr%TYPE;

    CURSOR cur_verifica_nac_adm (pn_declaracao_id NUMBER) IS
      SELECT 1
        FROM imp_declaracoes dcl_nac
           , imp_invoices    ivc
           , imp_invoices_lin ivc_lin
           , imp_adm_temp_destinacoes dest
           , imp_adm_temp_entradas    entr
           , imp_declaracoes          dcl_adm
           , imp_adm_temp_rat         rat
       WHERE dcl_nac.declaracao_id = pn_declaracao_id
         AND dcl_nac.embarque_id = ivc.embarque_id
         AND ivc.invoice_id = ivc_lin.invoice_id
         AND ivc_lin.invoice_lin_id = dest.invoice_lin_id_nac
         AND dest.entrada_id = entr.entrada_id
         AND entr.declaracao_id = dcl_adm.declaracao_id
         AND dcl_adm.embarque_id = rat.embarque_id
         AND rat.regime <> 'REPETRO'
         AND ROWNUM <= 1;

    vn_verifica_nac_adm NUMBER;
    vb_verifica_nac_adm BOOLEAN;


  BEGIN -- imp_prc_grava_declaracao

    FOR dcl IN 1..vn_global_dcl_lin LOOP

      UPDATE imp_declaracoes_lin
         SET aliq_ii_rec                    = tb_dcl_lin(dcl).aliq_ii_rec
           , aliq_ipi_rec                   = tb_dcl_lin(dcl).aliq_ipi_rec
           , aliq_icms                      = tb_dcl_lin(dcl).aliq_icms
           , aliq_icms_red                  = tb_dcl_lin(dcl).aliq_icms_red
           , perc_red_icms                  = tb_dcl_lin(dcl).perc_red_icms
           , basecalc_ii                    = tb_dcl_lin(dcl).basecalc_ii
           , basecalc_ipi                   = tb_dcl_lin(dcl).basecalc_ipi
           , basecalc_icms                  = tb_dcl_lin(dcl).basecalc_icms
           , valor_ii_dev                   = tb_dcl_lin(dcl).valor_ii_dev
           , valor_ipi_dev                  = tb_dcl_lin(dcl).valor_ipi_dev
           --, valor_icms_dev                 = tb_dcl_lin(dcl).valor_icms_dev
           , valor_icms_dev                 = Nvl(tb_dcl_lin(dcl).valor_icms_dev,0) + Nvl(tb_dcl_lin(dcl).valor_fecp_dev,0)
           , valor_ii                       = tb_dcl_lin(dcl).valor_ii
           , valor_ipi                      = tb_dcl_lin(dcl).valor_ipi
           --, valor_icms                     = tb_dcl_lin(dcl).valor_icms
           , valor_icms                     = Nvl(tb_dcl_lin(dcl).valor_icms,0) + Nvl(tb_dcl_lin(dcl).valor_icms_fecp,0)
           , basecalc_icms_pro_emprego      = tb_dcl_lin(dcl).basecalc_icms_pro_emprego
           , valor_icms_pro_emprego         = tb_dcl_lin(dcl).valor_icms_pro_emprego
           , pesoliq_unit                   = tb_dcl_lin(dcl).pesoliq_unit
           , pesoliq_tot                    = tb_dcl_lin(dcl).pesoliq_tot
           , pesobrt_tot                    = tb_dcl_lin(dcl).pesobrt_tot
           , flag_alterar                   = 'N'
           , basecalc_pis_cofins            = tb_dcl_lin(dcl).basecalc_pis_cofins
           , aliq_pis                       = tb_dcl_lin(dcl).aliq_pis
           , aliq_cofins                    = tb_dcl_lin(dcl).aliq_cofins
           , valor_pis                      = tb_dcl_lin(dcl).valor_pis
           , valor_cofins                   = tb_dcl_lin(dcl).valor_cofins
           , valor_pis_dev                  = tb_dcl_lin(dcl).valor_pis_dev
           , valor_cofins_dev               = tb_dcl_lin(dcl).valor_cofins_dev
           , valor_icms_fecp                = tb_dcl_lin(dcl).valor_icms_fecp
           , basecalc_pis_cofins_integral   = tb_dcl_lin(dcl).basecalc_pis_cofins_integral
           , valor_pis_integral             = tb_dcl_lin(dcl).valor_pis_integral
           , valor_cofins_integral          = tb_dcl_lin(dcl).valor_cofins_integral
           , vmlc_unit_m                    = tb_dcl_lin(dcl).vmlc_unit_m
           , vmle_unit_m                    = tb_dcl_lin(dcl).vmle_unit_m
           , vmle_unit_mn                   = tb_dcl_lin(dcl).vmle_unit_mn
           , basecalc_antid                 = tb_dcl_lin(dcl).basecalc_antid
           , qtde_um_aliq_especifica_antid  = tb_dcl_lin(dcl).qtde_um_aliq_especifica_antid
           , valor_antid                    = tb_dcl_lin(dcl).valor_antid
           , valor_antid_dev                = tb_dcl_lin(dcl).valor_antid_dev
           , valor_antid_aliq_especifica    = tb_dcl_lin(dcl).valor_antid_aliq_especifica
           , valor_antid_ad_valorem         = tb_dcl_lin(dcl).valor_antid_ad_valorem
           , valor_ii_proporcional          = tb_dcl_lin(dcl).valor_ii_proporcional
           , valor_ipi_proporcional         = tb_dcl_lin(dcl).valor_ipi_proporcional
           , valor_pis_proporcional         = tb_dcl_lin(dcl).valor_pis_proporcional
           , valor_cofins_proporcional      = tb_dcl_lin(dcl).valor_cofins_proporcional
           , valor_antid_proporcional       = tb_dcl_lin(dcl).valor_antid_proporcional
           , basecalc_icms_st               = tb_dcl_lin(dcl).basecalc_icms_st
           --, valor_icms_st                  = tb_dcl_lin(dcl).valor_icms_st
           , valor_icms_st                  = Nvl(tb_dcl_lin(dcl).valor_icms_st,0) + Nvl(tb_dcl_lin(dcl).valor_fecp_st,0)
           , valor_diferido_icms_pr         = tb_dcl_lin(dcl).valor_diferido_icms_pr
           , valor_cred_presumido_pr        = tb_dcl_lin(dcl).valor_cred_presumido_pr
           , valor_cred_presumido_pr_devido = tb_dcl_lin(dcl).valor_cred_presumido_pr_devido
           , valor_devido_icms_pr           = tb_dcl_lin(dcl).valor_devido_icms_pr
           , valor_perc_vr_devido_icms_pr   = tb_dcl_lin(dcl).valor_perc_vr_devido_icms_pr
           , valor_perc_minimo_base_icms_pr = tb_dcl_lin(dcl).valor_perc_minimo_base_icms_pr
           , valor_perc_susp_base_icms_pr   = tb_dcl_lin(dcl).valor_perc_susp_base_icms_pr
           , qtde                           = tb_dcl_lin(dcl).qtde
           , last_update_date               = vd_global_last_update_date
           , last_updated_by                = vn_global_last_updated_by
           , aliq_cofins_recuperar          = tb_dcl_lin(dcl).aliq_cofins_recuperar
           , aliquota_cofins_custo          = tb_dcl_lin(dcl).aliquota_cofins_custo
           , valor_cofins_recuperar         = tb_dcl_lin(dcl).valor_cofins_recuperar
           , vlr_frete                      = tb_dcl_lin(dcl).vlr_frete_afrmm
           , vlr_base_dev                   = tb_dcl_lin(dcl).vlr_base_dev
           , vlr_base_dev_mn                = tb_dcl_lin(dcl).vlr_base_dev_mn
           , vlr_base_a_recolher            = tb_dcl_lin(dcl).vlr_base_a_recolher
           , vlr_base_a_recolher_mn         = tb_dcl_lin(dcl).vlr_base_a_recolher_mn
           , valor_fecp_st                  = tb_dcl_lin(dcl).valor_fecp_st
           , valor_fecp_dev                 = tb_dcl_lin(dcl).valor_fecp_dev
           , valor_icms_sem_fecp            = tb_dcl_lin(dcl).valor_icms
           , valor_icms_st_sem_fecp         = tb_dcl_lin(dcl).valor_icms_st
           , valor_icms_dev_sem_fecp        = tb_dcl_lin(dcl).valor_icms_dev
       WHERE declaracao_lin_id = tb_dcl_lin(dcl).declaracao_lin_id;

    END LOOP;


    IF (Nvl(cmx_pkg_tabelas.auxiliar(pn_tp_embarque_id,1),'XX') = 'NAC_DE_TERC') THEN
    FOR adi IN 1..vn_global_dcl_adi LOOP
      tb_dcl_adi(adi).vrt_fr_m  := 0;
      tb_dcl_adi(adi).vrt_fr_mn := 0;
      tb_dcl_adi(adi).vrt_fr_us := 0;
      tb_dcl_adi(adi).vrt_sg_m  := 0;
      tb_dcl_adi(adi).vrt_sg_mn := 0;
      tb_dcl_adi(adi).vrt_sg_us := 0;

      FOR lin IN 1..vn_global_dcl_lin LOOP
        IF (tb_dcl_adi(adi).declaracao_adi_id = tb_dcl_lin(lin).declaracao_adi_id) THEN
          FOR ivcl IN 1..vn_global_ivc_lin LOOP
            IF (tb_dcl_lin(lin).invoice_lin_id = tb_ivc_lin(ivcl).invoice_lin_id) THEN
              vn_moeda_fr_nac_id := NULL;
              vn_taxa_mn_nac     := NULL;
              vn_taxa_us_nac     := NULL;
              BEGIN
                SELECT moeda_da_nac_id
                  INTO vn_moeda_fr_nac_id
                  FROM imp_invoices_lin
                 WHERE invoice_lin_id = tb_ivc_lin(ivcl).invoice_lin_id;
              EXCEPTION
                WHEN OTHERS THEN
                  vn_moeda_fr_nac_id := NULL;
              END;

              imp_prc_busca_taxa_conversao ( vn_moeda_fr_nac_id
                                           , pd_data_conversao
                                           , vn_taxa_mn_nac
                                           , vn_taxa_us_nac
                                           , 'FR_NAC_DE_TERC'
                                           );


              tb_dcl_adi(adi).vrt_fr_m  := tb_dcl_adi(adi).vrt_fr_m  + tb_ivc_lin(ivcl).vrt_fr_m  / tb_ivc_lin(ivcl).qtde * tb_dcl_lin(lin).qtde;
              tb_dcl_adi(adi).vrt_fr_mn := tb_dcl_adi(adi).vrt_fr_mn + tb_ivc_lin(ivcl).vrt_fr_m * vn_taxa_mn_nac / tb_ivc_lin(ivcl).qtde * tb_dcl_lin(lin).qtde;
              tb_dcl_adi(adi).vrt_fr_us := tb_dcl_adi(adi).vrt_fr_us + tb_ivc_lin(ivcl).vrt_fr_m * vn_taxa_us_nac/ tb_ivc_lin(ivcl).qtde * tb_dcl_lin(lin).qtde;

              tb_dcl_adi(adi).vrt_sg_m  := tb_dcl_adi(adi).vrt_sg_m  + tb_ivc_lin(ivcl).vrt_sg_m  / tb_ivc_lin(ivcl).qtde * tb_dcl_lin(lin).qtde;
              tb_dcl_adi(adi).vrt_sg_mn := tb_dcl_adi(adi).vrt_sg_mn + tb_ivc_lin(ivcl).vrt_sg_mn / tb_ivc_lin(ivcl).qtde * tb_dcl_lin(lin).qtde;
              tb_dcl_adi(adi).vrt_sg_us := tb_dcl_adi(adi).vrt_sg_us + tb_ivc_lin(ivcl).vrt_sg_us / tb_ivc_lin(ivcl).qtde * tb_dcl_lin(lin).qtde;


            END IF;
          END LOOP;
        END IF;
      END LOOP;
    END LOOP;
    END IF;

    FOR adi IN 1..vn_global_dcl_adi LOOP
      OPEN  cur_empresa_id;
      FETCH cur_empresa_id INTO vn_empresa_id;
      CLOSE cur_empresa_id;

      OPEN cur_aliq_dif_icms_pr(vn_empresa_id);
      FETCH cur_aliq_dif_icms_pr INTO vc_arredonda_aliq_dife_icms_pr;
      CLOSE cur_aliq_dif_icms_pr;

      UPDATE imp_declaracoes_adi
         SET /*qtde_linhas                        = tb_dcl_adi(adi).qtde_linhas -- não é necessário alterar a quantidade de linhas. Ela é alterada via triggers. Nas DAs de embarcações de REPETRO não processamos as linhas com unidade de medida CONTINUACAO, portanto a quantidade de linhas dentro da totaliza é menor do que a real. Por conta disso não podemos modificar.
           , */peso_liquido                       = tb_dcl_adi(adi).peso_liquido
           , qtde_um_estatistica                = tb_dcl_adi(adi).qt_um_estat
           , vrt_fob_m                          = tb_dcl_adi(adi).vrt_fob_m
           , vrt_fob_mn                         = tb_dcl_adi(adi).vrt_fob_mn
           , vrt_fob_us                         = tb_dcl_adi(adi).vrt_fob_us
           , vrt_dspfob_m                       = tb_dcl_adi(adi).vrt_dspfob_m
           , vrt_dspfob_mn                      = tb_dcl_adi(adi).vrt_dspfob_mn
           , vrt_dspfob_us                      = tb_dcl_adi(adi).vrt_dspfob_us
           , vrt_fr_m                           = tb_dcl_adi(adi).vrt_fr_m
           , vrt_fr_mn                          = tb_dcl_adi(adi).vrt_fr_mn
           , vrt_fr_us                          = tb_dcl_adi(adi).vrt_fr_us
           , vrt_fr_total_m                     = tb_dcl_adi(adi).vrt_fr_total_m
           , vrt_fr_total_mn                    = tb_dcl_adi(adi).vrt_fr_total_mn
           , vrt_fr_total_us                    = tb_dcl_adi(adi).vrt_fr_total_us
           , vrt_fr_prepaid_m                   = tb_dcl_adi(adi).vrt_fr_prepaid_m
           , vrt_fr_prepaid_mn                  = tb_dcl_adi(adi).vrt_fr_prepaid_mn
           , vrt_fr_prepaid_us                  = tb_dcl_adi(adi).vrt_fr_prepaid_us
           , vrt_fr_collect_m                   = tb_dcl_adi(adi).vrt_fr_collect_m
           , vrt_fr_collect_mn                  = tb_dcl_adi(adi).vrt_fr_collect_mn
           , vrt_fr_collect_us                  = tb_dcl_adi(adi).vrt_fr_collect_us
           , vrt_fr_territorio_nacional_m       = tb_dcl_adi(adi).vrt_fr_territorio_nacional_m
           , vrt_fr_territorio_nacional_mn      = tb_dcl_adi(adi).vrt_fr_territorio_nacional_mn
           , vrt_fr_territorio_nacional_us      = tb_dcl_adi(adi).vrt_fr_territorio_nacional_us
           , vrt_sg_m                           = tb_dcl_adi(adi).vrt_sg_m
           , vrt_sg_mn                          = tb_dcl_adi(adi).vrt_sg_mn
           , vrt_sg_us                          = tb_dcl_adi(adi).vrt_sg_us
           , vrt_acres_m                        = tb_dcl_adi(adi).vrt_acres_m
           , vrt_acres_mn                       = tb_dcl_adi(adi).vrt_acres_mn
           , vrt_acres_us                       = tb_dcl_adi(adi).vrt_acres_us
           , vrt_ded_m                          = tb_dcl_adi(adi).vrt_ded_m
           , vrt_ded_mn                         = tb_dcl_adi(adi).vrt_ded_mn
           , vrt_ded_us                         = tb_dcl_adi(adi).vrt_ded_us
           , vrt_ajuste_base_icms_m             = tb_dcl_adi(adi).vrt_ajuste_base_icms_m
           , vrt_ajuste_base_icms_mn            = tb_dcl_adi(adi).vrt_ajuste_base_icms_mn
           , vrt_ajuste_base_icms_us            = tb_dcl_adi(adi).vrt_ajuste_base_icms_us
           , basecalc_ii                        = tb_dcl_adi(adi).basecalc_ii
           , valor_ii_dev                       = tb_dcl_adi(adi).valor_ii_dev
           , valor_ii_rec                       = tb_dcl_adi(adi).valor_ii_rec
           , basecalc_ipi                       = tb_dcl_adi(adi).basecalc_ipi
           , valor_ipi_dev                      = tb_dcl_adi(adi).valor_ipi_dev
           , valor_ipi_rec                      = tb_dcl_adi(adi).valor_ipi_rec
           , valor_icms                         = tb_dcl_adi(adi).valor_icms
           , valor_icms_dev                     = tb_dcl_adi(adi).valor_icms_dev
           , basecalc_icms                      = tb_dcl_adi(adi).basecalc_icms
           , basecalc_icms_pro_emprego          = tb_dcl_adi(adi).basecalc_icms_pro_emprego
           , valor_icms_pro_emprego             = tb_dcl_adi(adi).valor_icms_pro_emprego
           , vmlc_m                             = tb_dcl_adi(adi).vmlc_m
           , vmlc_mn                            = tb_dcl_adi(adi).vmlc_mn
           , vmle_mn                            = tb_dcl_adi(adi).vmle_mn
           , aliq_ii_dev                        = tb_dcl_adi(adi).aliq_ii_dev
           , aliq_ii_dev_original               = tb_dcl_adi(adi).aliq_ii_dev_original
           , aliq_ipi_dev                       = tb_dcl_adi(adi).aliq_ipi_dev
           , aliq_ipi_dev_original              = tb_dcl_adi(adi).aliq_ipi_dev_original
           , valor_pis                          = tb_dcl_adi(adi).valor_pis
           , valor_cofins                       = tb_dcl_adi(adi).valor_cofins
           , valor_pis_dev                      = tb_dcl_adi(adi).valor_pis_dev
           , valor_cofins_dev                   = tb_dcl_adi(adi).valor_cofins_dev
           , basecalc_pis_cofins                = tb_dcl_adi(adi).basecalc_pis_cofins
           , basecalc_pis_cofins_integral       = tb_dcl_adi(adi).basecalc_pis_cofins_integral
           , valor_pis_integral                 = tb_dcl_adi(adi).valor_pis_integral
           , valor_cofins_integral              = tb_dcl_adi(adi).valor_cofins_integral
           , basecalc_antdump                   = tb_dcl_adi(adi).basecalc_antdump
           , qt_um_aliq_esp_antdump             = tb_dcl_adi(adi).qt_um_aliq_esp_antdump
           , valor_antdump_aliq_especifica      = tb_dcl_adi(adi).valor_antdump_aliq_especifica
           , valor_antdump_ad_valorem           = tb_dcl_adi(adi).valor_antdump_ad_valorem
           , valor_antdump                      = tb_dcl_adi(adi).valor_antdump
           , valor_antdump_dev                  = tb_dcl_adi(adi).valor_antdump_dev
           , vr_aliq_esp_antdump_mn             = tb_dcl_adi(adi).vr_aliq_esp_antdump_mn
           , fator_admissao_temporaria          = tb_dcl_adi(adi).fator_admissao_temporaria
           , valor_ii_proporcional              = tb_dcl_adi(adi).valor_ii_proporcional
           , valor_ipi_proporcional             = tb_dcl_adi(adi).valor_ipi_proporcional
           , valor_pis_proporcional             = tb_dcl_adi(adi).valor_pis_proporcional
           , valor_cofins_proporcional          = tb_dcl_adi(adi).valor_cofins_proporcional
           , valor_antid_proporcional           = tb_dcl_adi(adi).valor_antid_proporcional
           , basecalc_icms_st                   = tb_dcl_adi(adi).basecalc_icms_st
           , valor_icms_st                      = tb_dcl_adi(adi).valor_icms_st
           , valor_diferido_icms_pr             = tb_dcl_adi(adi).valor_diferido_icms_pr
           , valor_cred_presumido_pr            = tb_dcl_adi(adi).valor_cred_presumido_pr
           , valor_cred_presumido_pr_devido     = tb_dcl_adi(adi).valor_cred_presumido_pr_devido
           , valor_devido_icms_pr               = tb_dcl_adi(adi).valor_devido_icms_pr
           , valor_perc_vr_devido_icms_pr       = tb_dcl_adi(adi).valor_perc_vr_devido_icms_pr
           , valor_perc_minimo_base_icms_pr     = tb_dcl_adi(adi).valor_perc_minimo_base_icms_pr
           , valor_perc_susp_base_icms_pr       = tb_dcl_adi(adi).valor_perc_susp_base_icms_pr
           , last_update_date                   = vd_global_last_update_date
           , last_updated_by                    = vn_global_last_updated_by
           , vlr_frete                          = tb_dcl_adi(adi).vlr_frete_afrmm
           , vlr_base_dev                       = tb_dcl_adi(adi).vlr_base_dev
           , vlr_base_dev_mn                    = tb_dcl_adi(adi).vlr_base_dev_mn
           , vlr_base_a_recolher                = tb_dcl_adi(adi).vlr_base_a_recolher
           , vlr_base_a_recolher_mn             = tb_dcl_adi(adi).vlr_base_a_recolher_mn
           , valor_fecp_dev                     = tb_dcl_adi(adi).valor_fecp_dev
           , valor_fecp                         = tb_dcl_adi(adi).valor_fecp
           , valor_fecp_st                      = tb_dcl_adi(adi).valor_fecp_st
           , valor_icms_sem_fecp                = tb_dcl_adi(adi).valor_icms_sem_fecp
           , valor_icms_dev_sem_fecp            = tb_dcl_adi(adi).valor_icms_dev_sem_fecp
           , valor_icms_st_sem_fecp             = tb_dcl_adi(adi).valor_icms_st_sem_fecp
           , arredonda_aliq_diferim_icms_pr     = vc_arredonda_aliq_dife_icms_pr
      WHERE declaracao_adi_id = tb_dcl_adi(adi).declaracao_adi_id;

      vn_mercosul_seq := 0;
      FOR adi_merc IN cur_dados_mercosul_adi (tb_dcl_adi(adi).declaracao_adi_id) LOOP
        vn_mercosul_seq := vn_mercosul_seq + 1;

        UPDATE imp_dcl_adi_mercosul
           SET nr_seq_de = vn_mercosul_seq
         WHERE CURRENT OF cur_dados_mercosul_adi;
      END LOOP;
    END LOOP;

    vn_contador := 0;
    FOR i IN cur_declaracoes_adi LOOP
      vn_contador := vn_contador + 1;
      UPDATE imp_declaracoes_adi
         SET adicao_num = vn_contador
       WHERE declaracao_adi_id = i.declaracao_adi_id;

      BEGIN
        vn_cont_lin := 0;
        FOR j IN (SELECT declaracao_lin_id
                    FROM imp_declaracoes_lin
                   WHERE declaracao_adi_id = i.declaracao_adi_id
                   ORDER BY linha_num)
        LOOP
          vn_cont_lin := vn_cont_lin + 1;
          UPDATE imp_declaracoes_lin
             SET linha_num_scx = vn_cont_lin
           WHERE declaracao_lin_id = j.declaracao_lin_id;
        END LOOP;
      EXCEPTION
        WHEN ve_precisao THEN
          prc_gera_log_erros (
             'Erro ao numerar as linhas da adição ' || vn_contador || ': ' ||
             'existem mais de 99 linhas para esta adição (' || sqlerrm || ').'
           , 'E'
           , 'D'
          );
      END;
    END LOOP;

    IF (pn_tp_declaracao <> 16) THEN
      DELETE FROM imp_dcl_adi_acresded
       WHERE declaracao_id = pn_declaracao_id;
    END IF;

    -- Habilitando para Admissão Temporaria
--    IF pn_tp_declaracao < 13  OR (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N') THEN
    IF pn_tp_declaracao < 13  OR (pn_tp_declaracao IN (13, 14) OR vc_global_nac_sem_admissao = 'S') THEN
      imp_carrega_ad_adicao_dcl (tb_ad_adi_gravar);
    ELSE
      imp_carrega_ad_adicao_dcl_nac (tb_ad_adi_gravar);
    END IF;

    imp_grava_acreded_adicao_dcl (pn_declaracao_id, tb_ad_adi_gravar);

    /* Se for uma Nacionalização de Admissão, confirmo se não é repetro e então impesso a substituição dos valores proporcionais na DI
       (Isso é feito com a variavel BOOLEAN "vb_verifica_nac_adm", nos DECODEs do update abaixo).
    */
    IF nvl(to_number(pn_tp_declaracao),0) = 13 THEN
      OPEN cur_verifica_nac_adm(pn_declaracao_id);
      FETCH cur_verifica_nac_adm INTO vn_verifica_nac_adm;
      vb_verifica_nac_adm := cur_verifica_nac_adm%FOUND;
      CLOSE cur_verifica_nac_adm;

      IF vb_verifica_nac_adm THEN
        vn_verifica_nac_adm := 13;
      END IF;
    END IF;

    /* Andre Roger, 05012004 - nao marca declaracao totalizada aqui. Marca no final de todo processo */
    UPDATE imp_declaracoes
       SET vrt_ii                               = vn_global_vrt_ii_mn
         , vrt_ipi                              = vn_global_vrt_ipi_mn
         , vrt_icms                             = vn_global_vrt_icms_mn
         , vrt_pis                              = vn_global_vrt_pis_mn
         , vrt_cofins                           = vn_global_vrt_cofins_mn
         , vrt_antidumping                      = vn_global_vrt_antidumping_mn
         , vrt_sg_m                             = vn_global_vrt_sg_ebq_m
         , vrt_sg_mn                            = vn_global_vrt_sg_ebq_mn
         , vrt_fob_mn                           = vn_global_vrt_fob_ebq_mn
         , vrt_dspfob_mn                        = vn_global_vrt_dspfob_ebq_mn
         , vrt_fr_m                             = vn_global_vrt_fr_m
         , vrt_fr_total_m                       = vn_global_vrt_fr_total_m
         , vrt_fr_collect_m                     = vn_global_vrt_fr_collect_m
         , vrt_fr_prepaid_m                     = vn_global_vrt_fr_prepaid_m
         , vrt_fr_territorio_nacional_m         = vn_global_vrt_fr_terr_nac_m
         , vrt_fr_mn                            = vn_global_vrt_fr_mn
         , vrt_fr_total_mn                      = vn_global_vrt_fr_total_mn
         , vrt_fr_collect_mn                    = vn_global_vrt_fr_collect_mn
         , vrt_fr_prepaid_mn                    = vn_global_vrt_fr_prepaid_mn
         , vrt_fr_territorio_nacional_mn        = vn_global_vrt_fr_terr_nac_mn
         , vmle_mn                              = vn_global_vrt_vmle_ebq_mn
         , data_taxa_conversao                  = pd_data_conversao
--         , dcl_totalizada                       = vc_global_dcl_totalizada
         , peso_liquido_nac                     = vn_global_pesoliq_nac
         , peso_bruto_nac                       = vn_global_pesobrt_nac
         , vrt_ii_proporcional                  = Decode(vn_verifica_nac_adm, 13, vrt_ii_proporcional         , vn_global_vrt_ii_prop_mn    )
         , vrt_ipi_proporcional                 = Decode(vn_verifica_nac_adm, 13, vrt_ipi_proporcional        , vn_global_vrt_ipi_prop_mn   )
         , vrt_pis_proporcional                 = Decode(vn_verifica_nac_adm, 13, vrt_pis_proporcional        , vn_global_vrt_pis_prop_mn   )
         , vrt_cofins_proporcional              = Decode(vn_verifica_nac_adm, 13, vrt_cofins_proporcional     , vn_global_vrt_cofins_prop_mn)
         , vrt_antidumping_proporcional         = vn_global_vrt_antid_prop_mn
         , vrt_icms_st                          = vn_global_vrt_icms_st_mn
         , vrt_fecp                             = vn_global_vrt_fecp_mn
         , vrt_fecp_st                          = vn_global_vrt_fecp_st_mn
         , vrt_icms_sem_fecp                    = vn_global_vrt_icms_mn_sem_fecp
         , vrt_icms_st_sem_fecp                 = vn_global_vrt_icms_st_mn_sfecp
     WHERE declaracao_id = pn_declaracao_id;

     vn_mercosul_seq := 0;
     FOR merc IN cur_dados_mercosul LOOP
       vn_mercosul_seq := vn_mercosul_seq + 1;

       UPDATE imp_dcl_informacoes_mercosul
          SET nr_seq_de = vn_mercosul_seq
        WHERE CURRENT OF cur_dados_mercosul;
     END LOOP;

     /* AFRMM - Aqui é inserido dados na tela de suspensão para quando for Nacionalização de Adm Temporária (13) */
     IF (pc_dsi = 'N') AND (pn_tp_declaracao IN (13, 14) AND vc_global_nac_sem_admissao = 'N') THEN
       IF (cmx_fnc_profile('UTILIZA_AFRMM') = 'S') AND (vc_global_via_transporte IN ('01', '02', '03')) THEN
         OPEN cur_da;
         FETCH cur_da INTO vn_da_id;
         CLOSE cur_da;

         IF (pn_declaracao_id IS NOT NULL) THEN
           imp_prc_nac_insere_dest_afrmm( 'E'                       -- pc_tipo
                                        , vn_da_id                  -- pn_da_id
                                        , vn_global_pesoliq_nac     -- pn_peso_liq
                                        , 'R'                       -- pc_destino
                                        , vn_global_last_updated_by -- pn_usuario_id
                                        , pn_embarque_id            -- pn_embarque_id
                                        , pn_declaracao_id          -- pn_declaracao_id
                                        , vn_global_evento_id       -- pn_evento_id
                                        );
         END IF;
       END IF;
     END IF;

  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro ao gravar a declaração: ' || sqlerrm, 'E', 'D');
  END imp_prc_grava_declaracao;

  -- ***********************************************************************
  -- Rotina para calcular a taxa do siscomex
  -- ***********************************************************************
  FUNCTION fnc_calcula_taxa_siscomex (pn_declaracao_id IN NUMBER) RETURN NUMBER IS
    vn_taxa_siscomex     NUMBER := 0;
    vn_taxa_siscomex_tot NUMBER := 0;
    vn_qtde_adicoes      NUMBER := 0;
    vc_error_text        VARCHAR2(2000) := null;

    CURSOR cur_conta_adicoes IS
      SELECT count(*)
        FROM imp_declaracoes_adi
       WHERE declaracao_id = pn_declaracao_id;

    CURSOR cur_vr_taxa_adicao (pn_nr_adicao NUMBER) IS
      SELECT TO_NUMBER(auxiliar1)
        FROM cmx_tabelas
       WHERE tipo   = '127'
         AND codigo <> '00000000000000000000'
         AND LTRIM(TO_CHAR(pn_nr_adicao,'0000')) BETWEEN codigo AND descricao;

  BEGIN
    OPEN  cur_conta_adicoes;
    FETCH cur_conta_adicoes INTO vn_qtde_adicoes;
    CLOSE cur_conta_adicoes;

    FOR adi IN 1..vn_qtde_adicoes LOOP
      BEGIN
         OPEN  cur_vr_taxa_adicao( adi );
         FETCH cur_vr_taxa_adicao into vn_taxa_siscomex;
         CLOSE cur_vr_taxa_adicao;
      EXCEPTION
         When INVALID_NUMBER Then
            vc_error_text := 'Verifique a parametrização de taxa siscomex (tabela 127), erro na adição ' || adi || '...' || Chr(13) || sqlerrm;
            prc_gera_log_erros (vc_error_text, 'E', 'D');
            vn_taxa_siscomex := 0;
      END;

      vn_taxa_siscomex_tot := vn_taxa_siscomex_tot + NVL(vn_taxa_siscomex,0);
    END LOOP;

    IF (vn_qtde_adicoes = 0) THEN
      prc_gera_log_erros ('Adições da declaração não encontradas, taxa utilização do siscomex não calculada...', 'A', 'D');
    END IF;

    vn_taxa_siscomex_tot := vn_taxa_siscomex_tot + vc_global_tx_util_fixa;

    return (nvl (vn_taxa_siscomex_tot, 0));
  END fnc_calcula_taxa_siscomex;

  -- ***********************************************************************
  -- Rotina para gerar o DARF
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_DARF (pn_declaracao_id NUMBER, pc_dsi VARCHAR2) IS
    vn_cd_receita_id      NUMBER := 0;
    vn_taxa_siscomex_tot  NUMBER := 0;
    vc_error_text         VARCHAR2(2000) := null;

    CURSOR cur_declaracao IS
      SELECT nvl(retif_sequencia,0), retif_nr_declaracao
        FROM imp_declaracoes
       WHERE declaracao_id = pn_declaracao_id;

    CURSOR cur_verifica_darf (pn_declaracao_id NUMBER, pn_cd_receita_id NUMBER, pn_seq_retif NUMBER) IS
      SELECT 0
        FROM dual
       WHERE EXISTS (SELECT 0
                       FROM imp_dcl_darf
                      WHERE declaracao_id   = pn_declaracao_id
                        AND cd_receita_id   = pn_cd_receita_id
                        AND retif_sequencia = nvl(pn_seq_retif,0));

    CURSOR cur_soma_darf_ja_pago (pn_declaracao_id NUMBER, pn_cd_receita_id NUMBER) IS
      SELECT sum(nvl(valor_mn,0))
        FROM imp_dcl_darf
       WHERE declaracao_id = pn_declaracao_id
         AND cd_receita_id = pn_cd_receita_id
         AND dt_pgto IS NOT null;


    vd_dt_pgto          DATE;
    vb_achou_darf       BOOLEAN;
    vn_dummy            NUMBER;
    vn_valor_darf       NUMBER;
    vn_darf_ja_pago     NUMBER;
    vb_tem_retificacao  BOOLEAN;
    vn_seq_retif        NUMBER;
    vc_retif_nr_declaracao  IMP_DECLARACOES.RETIF_NR_DECLARACAO%TYPE;

  BEGIN  -- imp_prc_grava_DARF
    -------------------------------------------------------------------------
    -- Gravando o valor do II na tabela de DARF
    -------------------------------------------------------------------------
    vn_cd_receita_id := nvl(cmx_pkg_tabelas.tabela_id('106', '0086'),0);
    OPEN  cur_declaracao;
    FETCH cur_declaracao INTO vn_seq_retif, vc_retif_nr_declaracao;
    CLOSE cur_declaracao;

    vb_tem_retificacao := (vc_retif_nr_declaracao IS NOT null);
    OPEN cur_verifica_darf(pn_declaracao_id, vn_cd_receita_id, vn_seq_retif);
    FETCH cur_verifica_darf INTO vn_dummy;
    vb_achou_darf := cur_verifica_darf%FOUND;
    CLOSE cur_verifica_darf;

    OPEN  cur_soma_darf_ja_pago (pn_declaracao_id, vn_cd_receita_id);
    FETCH cur_soma_darf_ja_pago INTO vn_darf_ja_pago;
    CLOSE cur_soma_darf_ja_pago;

    vn_valor_darf := nvl(vn_global_vrt_ii_mn,0) - nvl(vn_darf_ja_pago,0);
    IF (vn_cd_receita_id > 0) THEN
      IF (vn_valor_darf > 0) THEN
        IF (NOT vb_achou_darf) THEN
          INSERT INTO imp_dcl_darf(
                                    declaracao_id
                                  , cd_receita_id
                                  , valor_mn
                                  , creation_date
                                  , created_by
                                  , last_update_date
                                  , last_updated_by
                                  , grupo_acesso_id
                                  , retif_sequencia
                                  )
                            VALUES(
                                    pn_declaracao_id
                                  , vn_cd_receita_id
                                  , vn_valor_darf
                                  , vd_global_creation_date
                                  , vn_global_created_by
                                  , vd_global_last_update_date
                                  , vn_global_last_updated_by
                                  , vn_global_grupo_acesso_id
                                  , vn_seq_retif
                                  );
        ELSE
          UPDATE imp_dcl_darf
             SET valor_mn         = vn_valor_darf
               , last_updated_by  = vn_global_created_by
               , last_update_date = sysdate
           WHERE declaracao_id    = pn_declaracao_id
             AND cd_receita_id    = vn_cd_receita_id
             AND retif_sequencia  = vn_seq_retif;
        END IF;

      ELSIF (vb_achou_darf) THEN

        DELETE FROM imp_dcl_darf
         WHERE declaracao_id   = pn_declaracao_id
           AND cd_receita_id   = vn_cd_receita_id
           AND retif_sequencia = vn_seq_retif
           AND dt_pgto IS null;
      END IF;
    ELSIF (vn_valor_darf > 0) THEN
      prc_gera_log_erros ('Código da receita 0086 não parametrizado (tabela 106), II não gerado para o DARF...', 'E', 'D');
    END IF; -- vn_cd_receita_id > 0
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- Gravando o valor do IPI na tabela de DARF
    -------------------------------------------------------------------------
    vn_cd_receita_id := nvl(cmx_pkg_tabelas.tabela_id('106', '1038'),0);
    OPEN cur_verifica_darf(pn_declaracao_id, vn_cd_receita_id, vn_seq_retif);
    FETCH cur_verifica_darf INTO vn_dummy;
    vb_achou_darf := cur_verifica_darf%FOUND;
    CLOSE cur_verifica_darf;

    OPEN  cur_soma_darf_ja_pago (pn_declaracao_id, vn_cd_receita_id);
    FETCH cur_soma_darf_ja_pago INTO vn_darf_ja_pago;
    CLOSE cur_soma_darf_ja_pago;

    vn_valor_darf := nvl(vn_global_vrt_ipi_mn,0) - nvl(vn_darf_ja_pago,0);
    IF (vn_cd_receita_id > 0) THEN
      IF (vn_valor_darf > 0) THEN
        IF (NOT vb_achou_darf) THEN
          INSERT INTO imp_dcl_darf(
                                    declaracao_id
                                  , cd_receita_id
                                  , valor_mn
                                  , creation_date
                                  , created_by
                                  , last_update_date
                                  , last_updated_by
                                  , grupo_acesso_id
                                  , retif_sequencia
                                  )
                            VALUES(
                                    pn_declaracao_id
                                  , vn_cd_receita_id
                                  , vn_valor_darf
                                  , vd_global_creation_date
                                  , vn_global_created_by
                                  , vd_global_last_update_date
                                  , vn_global_last_updated_by
                                  , vn_global_grupo_acesso_id
                                  , vn_seq_retif
                                  );
        ELSE
          UPDATE imp_dcl_darf
             SET valor_mn         = vn_valor_darf
               , last_updated_by  = vn_global_created_by
               , last_update_date = sysdate
           WHERE declaracao_id    = pn_declaracao_id
             AND cd_receita_id    = vn_cd_receita_id
             AND retif_sequencia  = vn_seq_retif;
        END IF;
      ELSIF (vb_achou_darf) THEN
        DELETE FROM imp_dcl_darf
         WHERE declaracao_id   = pn_declaracao_id
           AND cd_receita_id   = vn_cd_receita_id
           AND retif_sequencia = vn_seq_retif
           AND dt_pgto IS null;
      END IF;
    ELSIF (vn_valor_darf > 0) THEN
      prc_gera_log_erros ('Código da receita 1038 não parametrizado (tabela 106), IPI não gerado para o DARF...', 'E', 'D');
    END IF; -- vn_cd_receita_id > 0
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- Gravando o valor do PIS na tabela de DARF
    -------------------------------------------------------------------------
    vn_cd_receita_id := nvl(cmx_pkg_tabelas.tabela_id('106', '5602'),0);
    OPEN cur_verifica_darf(pn_declaracao_id, vn_cd_receita_id, vn_seq_retif);
    FETCH cur_verifica_darf INTO vn_dummy;
    vb_achou_darf := cur_verifica_darf%FOUND;
    CLOSE cur_verifica_darf;

    OPEN  cur_soma_darf_ja_pago (pn_declaracao_id, vn_cd_receita_id);
    FETCH cur_soma_darf_ja_pago INTO vn_darf_ja_pago;
    CLOSE cur_soma_darf_ja_pago;

    vn_valor_darf := nvl(vn_global_vrt_pis_mn,0) - nvl(vn_darf_ja_pago,0);

    IF (vn_cd_receita_id > 0) THEN
      IF (vn_valor_darf > 0) THEN
        IF (NOT vb_achou_darf) THEN
          INSERT INTO imp_dcl_darf(
                                    declaracao_id
                                  , cd_receita_id
                                  , valor_mn
                                  , creation_date
                                  , created_by
                                  , last_update_date
                                  , last_updated_by
                                  , grupo_acesso_id
                                  , retif_sequencia
                                  )
                            VALUES(
                                    pn_declaracao_id
                                  , vn_cd_receita_id
                                  , vn_valor_darf
                                  , vd_global_creation_date
                                  , vn_global_created_by
                                  , vd_global_last_update_date
                                  , vn_global_last_updated_by
                                  , vn_global_grupo_acesso_id
                                  , vn_seq_retif
                                  );
        ELSE
          UPDATE imp_dcl_darf
             SET valor_mn         = vn_valor_darf
               , last_updated_by  = vn_global_created_by
               , last_update_date = sysdate
           WHERE declaracao_id    = pn_declaracao_id
             AND cd_receita_id    = vn_cd_receita_id
             AND retif_sequencia  = vn_seq_retif;
        END IF;
      ELSIF (vb_achou_darf) THEN
        DELETE FROM imp_dcl_darf
         WHERE declaracao_id   = pn_declaracao_id
           AND cd_receita_id   = vn_cd_receita_id
           AND retif_sequencia = vn_seq_retif
           AND dt_pgto IS null;
      END IF;
    ELSIF (vn_valor_darf > 0) THEN
      prc_gera_log_erros ('Código da receita 5602 não parametrizado (tabela 106), PIS não gerado para o DARF...', 'E', 'D');
    END IF; -- vn_cd_receita_id > 0
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- Gravando o valor do COFINS na tabela de DARF
    -------------------------------------------------------------------------
    vn_cd_receita_id := nvl(cmx_pkg_tabelas.tabela_id('106', '5629'),0);
    OPEN cur_verifica_darf(pn_declaracao_id, vn_cd_receita_id, vn_seq_retif);
    FETCH cur_verifica_darf INTO vn_dummy;
    vb_achou_darf := cur_verifica_darf%FOUND;
    CLOSE cur_verifica_darf;

    OPEN  cur_soma_darf_ja_pago (pn_declaracao_id, vn_cd_receita_id);
    FETCH cur_soma_darf_ja_pago INTO vn_darf_ja_pago;
    CLOSE cur_soma_darf_ja_pago;

    vn_valor_darf := nvl(vn_global_vrt_cofins_mn,0) - nvl(vn_darf_ja_pago,0);

    IF (vn_cd_receita_id > 0) THEN
      IF (vn_valor_darf > 0) THEN
        IF (NOT vb_achou_darf) THEN
          INSERT INTO imp_dcl_darf(
                                    declaracao_id
                                  , cd_receita_id
                                  , valor_mn
                                  , creation_date
                                  , created_by
                                  , last_update_date
                                  , last_updated_by
                                  , grupo_acesso_id
                                  , retif_sequencia
                                  )
                            VALUES(
                                    pn_declaracao_id
                                  , vn_cd_receita_id
                                  , vn_valor_darf
                                  , vd_global_creation_date
                                  , vn_global_created_by
                                  , vd_global_last_update_date
                                  , vn_global_last_updated_by
                                  , vn_global_grupo_acesso_id
                                  , vn_seq_retif
                                  );
        ELSE
          UPDATE imp_dcl_darf
             SET valor_mn         = vn_valor_darf
               , last_updated_by  = vn_global_created_by
               , last_update_date = sysdate
           WHERE declaracao_id    = pn_declaracao_id
             AND cd_receita_id    = vn_cd_receita_id
             AND retif_sequencia  = vn_seq_retif;
        END IF;
      ELSIF (vb_achou_darf) THEN
        DELETE FROM imp_dcl_darf
         WHERE declaracao_id   = pn_declaracao_id
           AND cd_receita_id   = vn_cd_receita_id
           AND retif_sequencia = vn_seq_retif
           AND dt_pgto IS null;
      END IF;
    ELSIF (vn_valor_darf > 0) THEN
      prc_gera_log_erros ('Código da receita 5629 não parametrizado (tabela 106), COFINS não gerado para o DARF...', 'E', 'D');
    END IF; -- vn_cd_receita_id > 0
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- Gravando o valor do ANTIDUMPING na tabela de DARF
    -------------------------------------------------------------------------
    vn_cd_receita_id := nvl(cmx_pkg_tabelas.tabela_id ('106', '5529'), 0);
    OPEN cur_verifica_darf(pn_declaracao_id, vn_cd_receita_id, vn_seq_retif);
    FETCH cur_verifica_darf INTO vn_dummy;
    vb_achou_darf := cur_verifica_darf%FOUND;
    CLOSE cur_verifica_darf;

    OPEN  cur_soma_darf_ja_pago (pn_declaracao_id, vn_cd_receita_id);
    FETCH cur_soma_darf_ja_pago INTO vn_darf_ja_pago;
    CLOSE cur_soma_darf_ja_pago;

    vn_valor_darf := nvl(vn_global_vrt_antidumping_mn,0) - nvl(vn_darf_ja_pago,0);

    IF (vn_cd_receita_id > 0) THEN
      IF (vn_valor_darf > 0) THEN
        IF (NOT vb_achou_darf) THEN
          INSERT INTO imp_dcl_darf(
                                    declaracao_id
                                  , cd_receita_id
                                  , valor_mn
                                  , creation_date
                                  , created_by
                                  , last_update_date
                                  , last_updated_by
                                  , grupo_acesso_id
                                  , retif_sequencia
                                  )
                            VALUES(
                                    pn_declaracao_id
                                  , vn_cd_receita_id
                                  , vn_valor_darf
                                  , vd_global_creation_date
                                  , vn_global_created_by
                                  , vd_global_last_update_date
                                  , vn_global_last_updated_by
                                  , vn_global_grupo_acesso_id
                                  , vn_seq_retif
                                  );
        ELSE
          UPDATE imp_dcl_darf
             SET valor_mn         = vn_valor_darf
               , last_updated_by  = vn_global_created_by
               , last_update_date = sysdate
           WHERE declaracao_id    = pn_declaracao_id
             AND cd_receita_id    = vn_cd_receita_id
             AND retif_sequencia  = vn_seq_retif;
        END IF;
      ELSIF (vb_achou_darf) THEN
        DELETE FROM imp_dcl_darf
         WHERE declaracao_id   = pn_declaracao_id
           AND cd_receita_id   = vn_cd_receita_id
           AND retif_sequencia = vn_seq_retif
           AND dt_pgto IS null;
      END IF;
    ELSIF (vn_valor_darf > 0) THEN
      prc_gera_log_erros ('Código da receita 5529 não parametrizado (tabela 106), ANTIDUMPING não gerado para o DARF...', 'E', 'D');
    END IF; -- vn_cd_receita_id > 0
    -------------------------------------------------------------------------



    -------------------------------------------------------------------------
    -- Gravando o valor do MULTA LI na tabela de DARF
    -------------------------------------------------------------------------
    vn_cd_receita_id := nvl(cmx_pkg_tabelas.tabela_id ('106', '5149'), 0);
    OPEN cur_verifica_darf(pn_declaracao_id, vn_cd_receita_id, vn_seq_retif);
    FETCH cur_verifica_darf INTO vn_dummy;
    vb_achou_darf := cur_verifica_darf%FOUND;
    CLOSE cur_verifica_darf;

    OPEN  cur_soma_darf_ja_pago (pn_declaracao_id, vn_cd_receita_id);
    FETCH cur_soma_darf_ja_pago INTO vn_darf_ja_pago;
    CLOSE cur_soma_darf_ja_pago;

    vn_valor_darf := nvl(vn_global_vrt_multa_li_mn,0) - nvl(vn_darf_ja_pago,0);

    IF (vn_cd_receita_id > 0) THEN
      IF (vn_valor_darf > 0) THEN
        IF (NOT vb_achou_darf) THEN
          INSERT INTO imp_dcl_darf(
                                    declaracao_id
                                  , cd_receita_id
                                  , valor_mn
                                  , creation_date
                                  , created_by
                                  , last_update_date
                                  , last_updated_by
                                  , grupo_acesso_id
                                  , retif_sequencia
                                  )
                            VALUES(
                                    pn_declaracao_id
                                  , vn_cd_receita_id
                                  , vn_valor_darf
                                  , vd_global_creation_date
                                  , vn_global_created_by
                                  , vd_global_last_update_date
                                  , vn_global_last_updated_by
                                  , vn_global_grupo_acesso_id
                                  , vn_seq_retif
                                  );
        ELSE
          UPDATE imp_dcl_darf
             SET valor_mn         = vn_valor_darf
               , last_updated_by  = vn_global_created_by
               , last_update_date = sysdate
           WHERE declaracao_id    = pn_declaracao_id
             AND cd_receita_id    = vn_cd_receita_id
             AND retif_sequencia  = vn_seq_retif;
        END IF;
      ELSIF (vb_achou_darf) THEN
        DELETE FROM imp_dcl_darf
         WHERE declaracao_id   = pn_declaracao_id
           AND cd_receita_id   = vn_cd_receita_id
           AND retif_sequencia = vn_seq_retif
           AND dt_pgto IS null;
      END IF;

      vn_global_vrt_multa_li_mn := 0;

    ELSIF (vn_valor_darf > 0) THEN
      prc_gera_log_erros ('Código da receita 5149 não parametrizado (tabela 106), MULTA_LI não gerado para o DARF...', 'E', 'D');
    END IF; -- vn_cd_receita_id > 0
    -------------------------------------------------------------------------


    -------------------------------------------------------------------------
    -- Gravando o valor da taxa de utilização do siscomex na tabela de DARF
    -------------------------------------------------------------------------
    IF NOT vb_tem_retificacao THEN
      vn_cd_receita_id := nvl(cmx_pkg_tabelas.tabela_id('106', '7811'),0);

      IF (vn_cd_receita_id > 0) THEN
        IF (nvl(pc_dsi,'N') = 'N') THEN
          vn_taxa_siscomex_tot := fnc_calcula_taxa_siscomex (pn_declaracao_id);
        END IF;

        OPEN cur_verifica_darf(pn_declaracao_id, vn_cd_receita_id, vn_seq_retif);
        FETCH cur_verifica_darf INTO vn_dummy;
        vb_achou_darf := cur_verifica_darf%FOUND;
        CLOSE cur_verifica_darf;

        IF (nvl(vn_taxa_siscomex_tot,0) > 0) AND (vn_seq_retif = 0) THEN
          IF (NOT vb_achou_darf) THEN
            INSERT INTO imp_dcl_darf(
                                      declaracao_id
                                    , cd_receita_id
                                    , valor_mn
                                    , creation_date
                                    , created_by
                                    , last_update_date
                                    , last_updated_by
                                    , grupo_acesso_id
                                    , retif_sequencia
                                    )
                              VALUES(
                                      pn_declaracao_id
                                    , vn_cd_receita_id
                                    , vn_taxa_siscomex_tot
                                    , vd_global_creation_date
                                    , vn_global_created_by
                                    , vd_global_last_update_date
                                    , vn_global_last_updated_by
                                    , vn_global_grupo_acesso_id
                                    , vn_seq_retif
                                    );
          ELSE
            UPDATE imp_dcl_darf
               SET valor_mn         = vn_taxa_siscomex_tot
                 , last_updated_by  = vn_global_created_by
                 , last_update_date = sysdate
             WHERE declaracao_id    = pn_declaracao_id
               AND cd_receita_id    = vn_cd_receita_id
               AND retif_sequencia  = vn_seq_retif;
          END IF;
        END IF;
      ELSIF (vn_taxa_siscomex_tot > 0) THEN
        prc_gera_log_erros ('Código da receita 7811 não parametrizado (tabela 106), taxa utilização siscomex não gerado para o DARF...', 'E', 'D');
      END IF; -- vn_cd_receita_id > 0
    END IF; -- vb_tem_retificacao
    -------------------------------------------------------------------------
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro da geração do DARF: ' || sqlerrm, 'E', 'D');
  END imp_prc_grava_DARF;

  -- ***********************************************************************
  -- Rotina para deduzir PO das linhas de invoice
  -- ***********************************************************************
  PROCEDURE imp_prc_gera_deducao_po (pn_embarque_id  NUMBER) IS
    TYPE reg_ivc_lin_po IS RECORD
      (
        invoice_lin_id       NUMBER
      , invoice_id           NUMBER
      , po_id                NUMBER
      , po_linha_id          NUMBER
      , po_line_location_id  NUMBER
      , po_qtde              NUMBER
      );

    TYPE typ_ivc_lin_po      IS TABLE OF reg_ivc_lin_po INDEX BY BINARY_INTEGER;
    tb_ivc_lin_po            typ_ivc_lin_po;
    vn_global_ivc_lin_po     NUMBER := 0;
    vn_saldo_po              NUMBER := 0;
    vn_qtde                  NUMBER := 0;

    CURSOR cur_invoices_lin IS
      SELECT iil.invoice_lin_id  , iil.invoice_id    , imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) qtde
           , ii.fornec_id        , ii.fornec_site_id , ii.organizacao_id
           , ce.operating_unit_id, ii.invoice_num    , iil.nr_linha
           , ii.termo_id         , iil.item_id       , iil.data_deducao_po
        FROM imp_invoices_lin     iil
           , imp_invoices         ii
           , cmx_empresas         ce
       WHERE ii.embarque_id  = pn_embarque_id
         AND iil.invoice_id  = ii.invoice_id
         AND iil.deduz_po    = 'S'
         AND ce.empresa_id   = ii.empresa_id
      ORDER BY iil.invoice_id, iil.invoice_lin_id;

    CURSOR cur_po_lin_entr ( pn_operating_unit_id  NUMBER
                           , pn_fornec_id          NUMBER
                           , pn_fornec_site_id     NUMBER
                           , pn_organizacao_id     NUMBER
                           , pn_termo_id           NUMBER
                           , pn_item_id            NUMBER
                           ) IS
      SELECT ipd.po_id
           , iple.po_linha_id
           , iple.po_line_location_id
           , (iple.qtde - nvl(iplee.qtde_consumida,0)) qtde
        FROM imp_po_lin_entr_ext  iplee
           , imp_po_lin_entr      iple
           , imp_po_lin           ipl
           , imp_po_dge           ipd
       WHERE ((ipd.operating_unit_id      = pn_operating_unit_id) OR (pn_operating_unit_id IS null))
         AND ipd.fornec_id                = pn_fornec_id
         AND ipd.fornec_site_id           = pn_fornec_site_id
         AND ipd.status                   IN ('1','2','3')
         AND ipd.dt_aprovacao             IS NOT null
         AND (
              ((vc_global_deduz_po_termo   = 'S') AND (ipd.termo_id = pn_termo_id))
              OR
              (vc_global_deduz_po_termo    = 'N')
             )
         AND ipl.po_id                    = ipd.po_id
         AND ipl.item_id                  = pn_item_id
         AND ipl.status                   IN ('1','2','3')
         AND ipl.dt_aprovacao             IS NOT null
         AND iple.po_linha_id             = ipl.po_linha_id
         AND ((iple.organizacao_id        = pn_organizacao_id) OR (pn_organizacao_id IS null))
         AND ((iple.release_num           = ipd.release_num)   OR (ipd.release_num   IS null))
         AND iple.status                  IN ('1','2','3')
         AND iple.dt_aprovacao            IS NOT null
         AND iplee.po_line_location_id(+) = iple.po_line_location_id
         AND (iple.qtde - nvl(iplee.qtde_consumida,0)) > 0
      ORDER BY iple.dt_necessidade, ipd.po_numero;

  BEGIN -- imp_prc_gera_deducao_po
    FOR ivc IN cur_invoices_lin LOOP
      IF (ivc.data_deducao_po IS NOT null) THEN
        DELETE FROM imp_invoices_lin_po
         WHERE invoice_lin_id = ivc.invoice_lin_id;
      END IF;

      vn_global_ivc_lin_po := 0;
      vn_saldo_po          := ivc.qtde;

      FOR lin IN cur_po_lin_entr ( ivc.operating_unit_id
                                 , ivc.fornec_id
                                 , ivc.fornec_site_id
                                 , ivc.organizacao_id
                                 , ivc.termo_id
                                 , ivc.item_id ) LOOP

        IF (vn_saldo_po < lin.qtde) THEN
          vn_qtde := vn_saldo_po;
        ELSE
          vn_qtde := lin.qtde;
        END IF;

        vn_global_ivc_lin_po := vn_global_ivc_lin_po + 1;
        tb_ivc_lin_po(vn_global_ivc_lin_po).invoice_lin_id      := ivc.invoice_lin_id;
        tb_ivc_lin_po(vn_global_ivc_lin_po).invoice_id          := ivc.invoice_id;
        tb_ivc_lin_po(vn_global_ivc_lin_po).po_id               := lin.po_id;
        tb_ivc_lin_po(vn_global_ivc_lin_po).po_linha_id         := lin.po_linha_id;
        tb_ivc_lin_po(vn_global_ivc_lin_po).po_line_location_id := lin.po_line_location_id;
        tb_ivc_lin_po(vn_global_ivc_lin_po).po_qtde             := vn_qtde;

        vn_saldo_po := vn_saldo_po - vn_qtde;

        IF (vn_saldo_po <= 0) THEN
          EXIT;
        END IF;
      END LOOP;

      IF (vn_saldo_po > 0) THEN
        prc_gera_log_erros('Não foi possível deduzir a PO da linha da invoice, ' ||
                          'quantidade insuficiente de PO''s... ' ||
                          'Invoice: ' || ivc.invoice_num ||
                          '  Linha: ' || to_char(ivc.nr_linha)  , 'E', 'A');
      ELSE
        FOR po IN 1..vn_global_ivc_lin_po LOOP
          INSERT INTO imp_invoices_lin_po
                      (
                        invoice_lin_id
                      , invoice_id
                      , po_id
                      , po_linha_id
                      , po_line_location_id
                      , po_qtde
                      , creation_date
                      , created_by
                      , last_update_date
                      , last_updated_by
                      , grupo_acesso_id
                      )
                VALUES(
                        tb_ivc_lin_po(po).invoice_lin_id
                      , tb_ivc_lin_po(po).invoice_id
                      , tb_ivc_lin_po(po).po_id
                      , tb_ivc_lin_po(po).po_linha_id
                      , tb_ivc_lin_po(po).po_line_location_id
                      , tb_ivc_lin_po(po).po_qtde
                      , vd_global_creation_date
                      , vn_global_created_by
                      , vd_global_last_update_date
                      , vn_global_last_updated_by
                      , vn_global_grupo_acesso_id
                      );

          UPDATE imp_invoices_lin
             SET deduz_po        = 'N'
               , data_deducao_po = sysdate
           WHERE invoice_lin_id = tb_ivc_lin_po(po).invoice_lin_id;
        END LOOP;
      END IF;
    END LOOP;
  END imp_prc_gera_deducao_po;

  -- ***********************************************************************
  -- Rotina para gravar licença de importação
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_licenca (pn_embarque_id NUMBER, pd_data_conversao DATE) IS
    vn_taxa_mn           NUMBER      := null;
    vn_taxa_us           NUMBER      := null;
    vn_ant_licenca_id    NUMBER      := null;
    vn_moeda_id          NUMBER      := null;
    vn_soma_qtde         NUMBER      := 0;
    vn_soma_pesoliq      NUMBER      := 0;
    vn_soma_vmle_m       NUMBER      := 0;
    vb_quebra_licenca    BOOLEAN     := TRUE;
    vb_achou_licenca     BOOLEAN     := TRUE;
    vn_pesoliq_tot       NUMBER      := 0;
    vn_pesoliq_unit      NUMBER      := 0;
    vn_vmle_m            NUMBER      := 0;
    vn_vmle_mn           NUMBER      := 0;
    vn_vmle_us           NUMBER      := 0;
    vn_qt_um_estat       NUMBER      := 0;
    vn_class_fiscal_id   NUMBER      := 0;
    vc_tp_classificacao  VARCHAR2(1) := null;
    vn_dummy             NUMBER      := 0;
    vb_ebq_nac_de_daf    BOOLEAN     := false;
    vn_peso_liq_da       NUMBER      := 0;
    vc_aux               cmx_tabelas.auxiliar1%TYPE;
    vn_calc_di_unica     NUMBER;
    vd_data_taxa         DATE;

    CURSOR cur_licenca_lin IS
      SELECT ill.licenca_lin_id
           , ill.licenca_id
           , ill.qtde
           , ill.item_id
           , ill.invoice_lin_id
           , il.moeda_id
           , ill.class_fiscal_id
           , ill.tp_classificacao
           , ill.da_lin_id
        FROM imp_licencas_lin  ill
           , imp_licencas      il
       WHERE ill.embarque_id = pn_embarque_id
         AND il.licenca_id   = ill.licenca_id
         AND il.nr_registro IS null
    ORDER BY ill.licenca_id;

    CURSOR cur_tp_embarque IS
      SELECT ebq.tp_embarque_id
        FROM imp_embarques ebq
           , cmx_tabelas   tp_ebq
       WHERE ebq.embarque_id     = pn_embarque_id
         AND ebq.tp_embarque_id  = tp_ebq.tabela_id
         AND tp_ebq.auxiliar1    = 'NAC'
         AND tp_ebq.auxiliar9   IN ('DE', 'DAF');

    CURSOR cur_peso_liq_linha_da (pn_ivc_lin_id NUMBER, pn_da_lin_id NUMBER, pn_lic_lin_id NUMBER) IS
      SELECT da_peso_liq_proporcional
        FROM imp_invoices_lin_da
       WHERE invoice_lin_id = pn_ivc_lin_id
         AND da_lin_id      = pn_da_lin_id
         AND licenca_lin_id = pn_lic_lin_id;

   /* CURSOR cur_calc_di_unica_plan_l (pn_data DATE) IS
      SELECT Nvl (prev_vlr_prepaid, 0) +
             Nvl (prev_vlr_collect, 0) +
             Nvl (prev_vlr_ter_nac, 0) +
             Nvl (prev_seg_vlr_seg_m, 0)
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id; */

    CURSOR cur_calc_di_unica_rem (pn_data DATE) IS
      SELECT Nvl (re.vrt_sg_m, 0) +
             Nvl (c.valor_total_m, 0)
        FROM imp_po_remessa re
           , imp_conhecimentos c
       WHERE re.conhec_id = c.conhec_id (+)
         AND re.embarque_id =  pn_embarque_id
         AND re.nr_remessa  = '1';

  CURSOR cur_calc_di_unica_ivc (pd_data DATE) IS
    SELECT Sum (ivc.valor_total)
      FROM imp_embarques emb
         , imp_invoices  ivc
     WHERE emb.embarque_id = ivc.embarque_id
       AND emb.embarque_id = pn_embarque_id;

    CURSOR cur_ultima_data_taxa IS
      SELECT ctx.data
        FROM cmx_taxas_locais   ctx
           , cmx_tabelas        ct
       WHERE ct.tipo     = '919'
         AND ct.codigo   = 'FISCAL'
         AND ctx.tipo_id = ct.tabela_id
    ORDER BY ctx.data DESC;

    FUNCTION fnc_calcula_qtde_um_estat_li ( pn_item_id         NUMBER
                                          , pn_pesoliq         NUMBER
                                          , pn_qtde            NUMBER
                                          ) RETURN NUMBER IS

      CURSOR cur_fator_conversao IS
        SELECT fator_conversao
          FROM cmx_itens_ext
         WHERE item_id          = pn_item_id
           AND fator_conversao IS NOT null;

      CURSOR cur_um_estatistica IS
        SELECT ct.codigo
          FROM cmx_tabelas ct
             , cmx_tab_ncm ncm
         WHERE ncm.ncm_id   = vn_class_fiscal_id
           AND ct.tabela_id = ncm.un_medida_id;

      vc_um_siscomex      cmx_tabelas.codigo%TYPE;
      vn_fator_conversao  cmx_itens_ext.fator_conversao%TYPE;
      vb_achou_fator      BOOLEAN;

    BEGIN -- fnc_calcula_qtde_um_estat_li
      vn_fator_conversao := 0;

      OPEN  cur_fator_conversao;
      FETCH cur_fator_conversao INTO vn_fator_conversao;
      vb_achou_fator := cur_fator_conversao%FOUND;
      CLOSE cur_fator_conversao;

      IF (vc_tp_classificacao <> 1) THEN
        IF (vb_achou_fator) THEN
          return (pn_qtde * vn_fator_conversao);
        ELSE
          return (pn_qtde);
        END IF; -- IF (vb_achou_fator) THEN

      ELSE
        vc_um_siscomex := null;

        OPEN  cur_um_estatistica;
        FETCH cur_um_estatistica INTO vc_um_siscomex;
        CLOSE cur_um_estatistica;

        IF (nvl (vc_um_siscomex,'XX') = '24') THEN
          return (0);
        ELSIF (nvl (vc_um_siscomex,'XX') = '10') THEN
          return (pn_pesoliq);
        ELSE
          IF (vb_achou_fator) THEN
            return (pn_qtde * vn_fator_conversao);
          ELSE
            return (pn_qtde);
          END IF; -- IF (vb_achou_fator) THEN
        END IF;
      END IF; -- IF (pc_tp_class <> 1) THEN
    END fnc_calcula_qtde_um_estat_li;

    PROCEDURE prc_quebra_licenca IS
    BEGIN
      imp_prc_busca_taxa_conversao (vn_moeda_id,
                                    pd_data_conversao,
                                    vn_taxa_mn,
                                    vn_taxa_us,
                                    'Licença');

      UPDATE imp_licencas
         SET vrt_vmle_m          = vn_soma_vmle_m
           , pesoliq_tot         = vn_soma_pesoliq
           , qtde_um_estatistica = vn_qt_um_estat
           , paridade_usd        = vn_taxa_us
           , totalizado          = vc_global_ebq_totalizado
       WHERE licenca_id = vn_ant_licenca_id;

      vb_quebra_licenca := TRUE;
    END prc_quebra_licenca;

  BEGIN
    vb_quebra_licenca := TRUE;
    vb_achou_licenca  := FALSE;

    OPEN  cur_tp_embarque;
    FETCH cur_tp_embarque INTO vn_dummy;
    vb_ebq_nac_de_daf := cur_tp_embarque%FOUND;
    CLOSE cur_tp_embarque;

    FOR lic IN cur_licenca_lin LOOP
      vb_achou_licenca := TRUE;

      IF (vn_ant_licenca_id <> lic.licenca_id)  THEN
        prc_quebra_licenca;
      END IF;

      IF (vb_quebra_licenca) THEN
        vn_ant_licenca_id   := lic.licenca_id;
        vn_moeda_id         := lic.moeda_id;
        vn_class_fiscal_id  := lic.class_fiscal_id;
        vc_tp_classificacao := lic.tp_classificacao;
        vn_soma_qtde        := 0;
        vn_soma_pesoliq     := 0;
        vn_soma_vmle_m      := 0;
        vn_qt_um_estat      := 0;
        vb_quebra_licenca   := FALSE;
      END IF;

      FOR ivc IN 1..vn_global_ivc_lin LOOP
        vn_pesoliq_tot  := 0;
        vn_pesoliq_unit := 0;
        vn_vmle_m       := 0;
        vn_vmle_mn      := 0;
        vn_vmle_us      := 0;

        IF (tb_ivc_lin(ivc).invoice_lin_id = lic.invoice_lin_id) THEN
          IF (vb_ebq_nac_de_daf) THEN
            OPEN  cur_peso_liq_linha_da (lic.invoice_lin_id, lic.da_lin_id, lic.licenca_lin_id);
            FETCH cur_peso_liq_linha_da INTO vn_peso_liq_da;
            CLOSE cur_peso_liq_linha_da;

            vn_pesoliq_tot  := vn_peso_liq_da;
            vn_pesoliq_unit := vn_peso_liq_da / lic.qtde;
          ELSE
            vn_pesoliq_tot  := nvl((tb_ivc_lin(ivc).pesoliq_tot / tb_ivc_lin(ivc).qtde) * lic.qtde,0);
            vn_pesoliq_unit := tb_ivc_lin(ivc).pesoliq_unit;
          END IF;

          vn_vmle_m  := nvl ((tb_ivc_lin(ivc).vmle_li_m   / tb_ivc_lin(ivc).qtde) * lic.qtde,0);
          vn_vmle_mn := nvl ((tb_ivc_lin(ivc).vmle_li_mn  / tb_ivc_lin(ivc).qtde) * lic.qtde,0);
          vn_vmle_us := nvl (((tb_ivc_lin(ivc).vmle_li_m * tb_ivc_lin(ivc).taxa_us_fob) / tb_ivc_lin(ivc).qtde) * lic.qtde,0);

          UPDATE imp_licencas_lin
             SET pesoliq_unit     = vn_pesoliq_unit
               , pesoliq_tot      = Round(vn_pesoliq_tot, 5)
               , preco_unitario_m = Decode( Round(tb_ivc_lin(ivc).qtde*tb_ivc_lin(ivc).preco_unitario_m,2), tb_ivc_lin(ivc).vmlc_li_m, tb_ivc_lin(ivc).preco_unitario_m, tb_ivc_lin(ivc).vmlc_li_m / tb_ivc_lin(ivc).qtde)
               , vrt_vmle_m       = vn_vmle_m    --***
               , vrt_vmle_mn      = vn_vmle_mn   --***
               , vrt_vmle_us      = vn_vmle_us   --***
           WHERE licenca_lin_id   = lic.licenca_lin_id;

          vn_soma_qtde    := vn_soma_qtde    + lic.qtde;
          vn_soma_pesoliq := vn_soma_pesoliq + round(vn_pesoliq_tot,5); -- Mesmo arredondamento do siscomex (total_linha,5)
          vn_soma_vmle_m  := vn_soma_vmle_m  + round(vn_vmle_m     ,2); -- Mesmo arredondamento do siscomex (total_linha,2)
          vn_qt_um_estat  := vn_qt_um_estat  + fnc_calcula_qtde_um_estat_li ( lic.item_id
                                                                            , round(vn_pesoliq_tot,5)
                                                                            , lic.qtde );
          EXIT;
        END IF;
      END LOOP;
    END LOOP;

    IF vb_achou_licenca THEN
      prc_quebra_licenca;
    END IF;

  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na gravação da licença - ' || sqlerrm, 'E', 'A');
  END imp_prc_grava_licenca;

  -- ***********************************************************************
  -- Rotina para gravar licença de nacionalização.
  -- ***********************************************************************
  PROCEDURE imp_prc_grava_licenca_nac (pn_declaracao_id NUMBER, pd_data_conversao DATE) IS
    vn_taxa_mn          NUMBER  := null;
    vn_taxa_us          NUMBER  := null;
    vn_ant_licenca_id   NUMBER  := null;
    vn_moeda_id         NUMBER  := null;
    vn_soma_qtde        NUMBER  := 0;
    vn_soma_pesoliq     NUMBER  := 0;
    vn_soma_vmle_mn     NUMBER  := 0;
    vb_quebra_licenca   BOOLEAN := TRUE;
    vb_achou_licenca    BOOLEAN := TRUE;
    vn_qt_um_estat      NUMBER  := 0;
    vn_class_fiscal_id  NUMBER  := 0;

    CURSOR cur_licenca_lin IS
      SELECT ill.licenca_lin_id
           , ill.licenca_id
           , ill.qtde
           , ill.item_id
           , ill.invoice_lin_id
           , il.moeda_id
           , ill.class_fiscal_id
           , ill.tp_classificacao
           , nvl((iil.pesoliq_tot / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * ill.qtde,0) pesoliq_tot
           , nvl((iil.pesoliq_tot / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)),0) pesoliq_unit
           , nvl((iil.vmle_mn     / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * ill.qtde,0) vmle_mn
           , nvl((iil.vmle_m      / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * ill.qtde,0) vmle_m
           , nvl((iil.vmle_us     / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)) * ill.qtde,0) vmle_us
        FROM imp_licencas_lin    ill
           , imp_licencas        il
           , imp_declaracoes     id
           , imp_declaracoes_lin idl
           , imp_invoices_lin    iil
       WHERE id.declaracao_id           = pn_declaracao_id
         AND ill.nr_lote_nacionalizacao = id.nr_lote_nacionalizacao
         AND idl.declaracao_lin_id      = ill.da_lin_id
         AND iil.invoice_lin_id         = idl.invoice_lin_id
         AND il.licenca_id              = ill.licenca_id
         AND il.nr_registro IS null;

    FUNCTION fnc_calcula_qtde_um_estat_li ( pn_item_id         NUMBER
                                          , pn_pesoliq         NUMBER
                                          , pn_qtde            NUMBER
                                          ) RETURN NUMBER IS

      CURSOR cur_fator_conversao IS
        SELECT fator_conversao
          FROM cmx_itens_ext
         WHERE item_id          = pn_item_id
           AND fator_conversao IS NOT null;

      CURSOR cur_um_estatistica IS
        SELECT ct.codigo
          FROM cmx_tabelas ct
             , cmx_tab_ncm ncm
         WHERE ncm.ncm_id   = vn_class_fiscal_id
           AND ct.tabela_id = ncm.un_medida_id;

      vc_um_siscomex      cmx_tabelas.codigo%TYPE;
      vn_fator_conversao  cmx_itens_ext.fator_conversao%TYPE;
      vb_achou_fator      BOOLEAN;

    BEGIN -- fnc_calcula_qtde_um_estat_li
      vn_fator_conversao := 0;

      OPEN  cur_fator_conversao;
      FETCH cur_fator_conversao INTO vn_fator_conversao;
      vb_achou_fator := cur_fator_conversao%FOUND;
      CLOSE cur_fator_conversao;

      IF (vb_achou_fator) THEN
        return (pn_qtde * vn_fator_conversao);
      ELSE
        vc_um_siscomex := null;

        OPEN  cur_um_estatistica;
        FETCH cur_um_estatistica INTO vc_um_siscomex;
        CLOSE cur_um_estatistica;

        IF (nvl (vc_um_siscomex,'XX') = '24') THEN
          return (0);
        ELSIF (nvl (vc_um_siscomex,'XX') = '10') THEN
          return (pn_pesoliq);
        ELSE
          return (pn_qtde);
        END IF;

      END IF; -- IF (vb_achou_fator) THEN
    END fnc_calcula_qtde_um_estat_li;

    PROCEDURE prc_quebra_licenca IS
    BEGIN
      imp_prc_busca_taxa_conversao (vn_moeda_id,
                                    pd_data_conversao,
                                    vn_taxa_mn,
                                    vn_taxa_us,
                                    'Licença');

      UPDATE imp_licencas
         SET vrt_vmle_m          = vn_soma_vmle_mn / vn_taxa_mn
           , pesoliq_tot         = vn_soma_pesoliq
           , qtde_um_estatistica = vn_qt_um_estat
           , paridade_usd        = vn_taxa_us
           , totalizado          = vc_global_ebq_totalizado
       WHERE licenca_id = vn_ant_licenca_id;

      vb_quebra_licenca := TRUE;
    END prc_quebra_licenca;

  BEGIN
    vb_quebra_licenca := TRUE;
    vb_achou_licenca  := FALSE;

    FOR lic IN cur_licenca_lin LOOP
      vb_achou_licenca := TRUE;

      IF (vb_quebra_licenca) THEN
        vn_ant_licenca_id   := lic.licenca_id;
        vn_moeda_id         := lic.moeda_id;
        vn_class_fiscal_id  := lic.class_fiscal_id;
        vn_qt_um_estat      := 0;
        vn_soma_qtde        := 0;
        vn_soma_pesoliq     := 0;
        vn_soma_vmle_mn     := 0;
        vb_quebra_licenca   := FALSE;
      END IF;

      IF (vn_ant_licenca_id <> lic.licenca_id)  THEN
        prc_quebra_licenca;
      END IF;

      UPDATE imp_licencas_lin
         SET pesoliq_unit   = lic.pesoliq_unit
           , pesoliq_tot    = lic.pesoliq_tot
           , vrt_vmle_m     = lic.vmle_m  --***
           , vrt_vmle_mn    = lic.vmle_mn --***
           , vrt_vmle_us    = lic.vmle_us --***
       WHERE licenca_lin_id = lic.licenca_lin_id;

      vn_soma_qtde    := vn_soma_qtde    + lic.qtde;
      vn_soma_pesoliq := vn_soma_pesoliq + lic.pesoliq_tot;
      vn_soma_vmle_mn := vn_soma_vmle_mn + lic.vmle_mn;
      vn_qt_um_estat  := vn_qt_um_estat  + fnc_calcula_qtde_um_estat_li ( lic.item_id
                                                                        , lic.pesoliq_tot
                                                                        , lic.qtde );
    END LOOP;

    IF vb_achou_licenca THEN
      prc_quebra_licenca;
    END IF;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na gravação da licença - ' || sqlerrm, 'E', 'A');
  END imp_prc_grava_licenca_nac;

  PROCEDURE imp_prc_checa_linhas_ivc_dcl (pn_embarque_id NUMBER, pn_declaracao_id NUMBER) IS
    vn_soma_qtde  NUMBER := 0;
  BEGIN
    FOR ivc IN 1..vn_global_ivc_lin LOOP
      vn_soma_qtde := 0;
      FOR dcl IN 1..vn_global_dcl_lin LOOP
        IF (tb_ivc_lin(ivc).invoice_lin_id = tb_dcl_lin(dcl).invoice_lin_id) THEN
          vn_soma_qtde := vn_soma_qtde + tb_dcl_lin(dcl).qtde;
        END IF;
      END LOOP;

      IF (vn_soma_qtde = 0) THEN
        prc_gera_log_erros ('Existe pendência de linha da invoice na declaração. Invoice: ' || tb_ivc_lin(ivc).invoice_num || ' - Linha: ' || to_char(tb_ivc_lin(ivc).linha_num), 'A', 'D');
      ELSIF ( (nvl(tb_ivc_lin(ivc).qtde,0) - vn_soma_qtde) > 0) THEN
        prc_gera_log_erros ('Quantidade informada na linha da declaração é menor do que a linha da invoice. Invoice: ' || tb_ivc_lin(ivc).invoice_num || ' - Linha: ' || to_char(tb_ivc_lin(ivc).linha_num), 'A', 'D');
      END IF;
    END LOOP;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro na checagem entre linhas de invoice e declaração: ' || sqlerrm, 'E', 'D');
  END imp_prc_checa_linhas_ivc_dcl;

  PROCEDURE imp_prc_libera_flag_dcl_lin  (pn_declaracao_id NUMBER) IS
  BEGIN
    UPDATE imp_declaracoes_lin
       SET flag_alterar = null
     WHERE declaracao_id = pn_declaracao_id ;
  EXCEPTION
    WHEN others THEN
      prc_gera_log_erros ('Erro ao liberar flag linhas de declaração: '|| sqlerrm, 'E', 'D');
  END imp_prc_libera_flag_dcl_lin;

  -- *****************************************************************************************
  -- Rotina para verificar se o valor total das invoices é o mesmo valor gerado na declaração.
  -- *****************************************************************************************
  PROCEDURE imp_prc_compara_vlr_ivc_f_camb (pn_embarque_id imp_embarques.embarque_id%TYPE) IS

    /* Cursor para trazer o valor total das invoices informado no cadastro da invoice*/
    CURSOR cur_vlr_total_invoices (pn_cur_embarque_id imp_embarques.embarque_id%TYPE) IS
      SELECT id.declaracao_id
           , sum ( decode (cmx_pkg_tabelas.auxiliar (iil.tp_linha_id, 1)
                          , 'I' -- Frete internacional
                          , decode (nvl (ii.flag_fr_embutido, 'N')
                                   , 'S'
                                   , 0
                                   , round (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * iil.preco_unitario_m, 2)
                                   )
                          , 'S' -- Seguro internacional
                          , decode (nvl (ii.flag_sg_embutido, 'N')
                                   , 'S'
                                   , 0
                                   , round (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * iil.preco_unitario_m, 2)
                                   )
                          , 'N' -- Despesas delivery dutty
                          , decode (nvl (ii.flag_dsp_ddu_embutida, 'N')
                                   , 'S'
                                   , 0
                                   , round (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * iil.preco_unitario_m, 2)
                                   )
                          , round (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) * iil.preco_unitario_m, 2)
                          )
                 ) vrt_invoice
        FROM imp_declaracoes  id
           , imp_embarques    ie
           , imp_invoices     ii
           , imp_invoices_lin iil
       WHERE 'M'            = cmx_pkg_tabelas.auxiliar (iil.tp_linha_id, 3)
         AND iil.invoice_id = ii.invoice_id
         AND ii.embarque_id = ie.embarque_id
         AND ie.embarque_id = id.embarque_id
         AND ie.embarque_id = pn_cur_embarque_id
       GROUP BY id.declaracao_id;

    /* Cursor para trazer a soma dos valores das parcelas variáveis de uma declaração.
       Este seria o caso das adições que possam ter pagamento antecipado, pagamento
       à vista e parcelas variáveis para o valor restante.  */
    CURSOR cur_soma_parc_var_dec (pn_cur_declaracao_id imp_declaracoes.declaracao_id%TYPE) IS
      SELECT sum (nvl (pgto_p.valor_m, 0)) vrt_parc_var_dec
        FROM imp_declaracoes      dcl
           , imp_dcl_adi_parc_var pgto_p
       WHERE dcl.declaracao_id = pn_cur_declaracao_id
         AND dcl.declaracao_id = pgto_p.declaracao_id
       GROUP BY dcl.declaracao_id;

     /* Cursor para trazer a soma dos valores dos pagamentos antecipados e à vista das
    adições que possuem pagamento com parcelas variáveis. Este seria o caso das
    adições que possam ter pagamento antecipado, pagamento à vista e parcelas
    variáveis para o valor restante.*/
    CURSOR cur_soma_pgto_va_pv_dec (pn_cur_declaracao_id imp_declaracoes.declaracao_id%TYPE) IS
      SELECT sum (nvl (pgto_n.valor_m, 0)) vrt_pgto_va_pv
        FROM imp_declaracoes     dcl
           , imp_declaracoes_adi dcl_ad
           , imp_dcl_adi_pgto    pgto_n
       WHERE dcl.declaracao_id        = pn_cur_declaracao_id
         AND pgto_n.declaracao_adi_id = dcl_ad.declaracao_adi_id
         AND dcl_ad.parcelas_fixas    = 'N'
         AND dcl.declaracao_id        = dcl_ad.declaracao_id
       GROUP BY dcl.declaracao_id;

     /*  Query para trazer a soma dos valores do valor total da adição da declaração,
    que possuem parcelas fixas, pois, neste caso, não ocorre o problema do valor
    da ficha câmbio ser informado errôneamente, pois o valor total é calculado com
    base no campo vmlc_m da imp_declaracoes_adi, que é o valor da adição.*/
    CURSOR cur_soma_pgto_va_pf_dec (pn_cur_declaracao_id imp_declaracoes.declaracao_id%TYPE) IS
      SELECT round (sum (nvl (dcl_ad.vmlc_m, 0)), 2) vrt_pgto_va_pf
        FROM imp_declaracoes     dcl
           , imp_declaracoes_adi dcl_ad
       WHERE dcl.declaracao_id     = pn_cur_declaracao_id
         AND dcl_ad.parcelas_fixas = 'S'
         AND dcl.declaracao_id     = dcl_ad.declaracao_id
       GROUP BY dcl.declaracao_id;

    CURSOR cur_embarque_invoices (pn_cur_embarque_id imp_embarques.embarque_id%TYPE) IS
      SELECT dcl.referencia
           , inv.invoice_num
        FROM imp_declaracoes dcl
           , imp_invoices    inv
           , imp_embarques   ebq
       WHERE ebq.embarque_id = pn_cur_embarque_id
         AND ebq.embarque_id = inv.embarque_id
         AND ebq.embarque_id = dcl.embarque_id;

    vn_declaracao_id        imp_declaracoes.declaracao_id%TYPE := 0;
    vn_vlr_total_invoices   NUMBER                             := 0;
    vn_vlr_total_ficha_cam  NUMBER                             := 0;
    vn_vrt_parc_var_dec     NUMBER                             := 0;
    vn_vrt_pgto_va_pv       NUMBER                             := 0;
    vn_vrt_pgto_va_pf       NUMBER                             := 0;
    vc_dec_referencia       imp_declaracoes.referencia%TYPE    := NULL;
    vc_lista_de_invoices    VARCHAR2(2000)                     := NULL;

  BEGIN

    OPEN  cur_vlr_total_invoices (pn_embarque_id);
    FETCH cur_vlr_total_invoices INTO vn_declaracao_id
                                    , vn_vlr_total_invoices;
    CLOSE cur_vlr_total_invoices;

    OPEN  cur_soma_parc_var_dec (vn_declaracao_id);
    FETCH cur_soma_parc_var_dec INTO vn_vrt_parc_var_dec;
    CLOSE cur_soma_parc_var_dec;

    OPEN  cur_soma_pgto_va_pv_dec (vn_declaracao_id);
    FETCH cur_soma_pgto_va_pv_dec INTO vn_vrt_pgto_va_pv;
    CLOSE cur_soma_pgto_va_pv_dec;

    OPEN  cur_soma_pgto_va_pf_dec (vn_declaracao_id);
    FETCH cur_soma_pgto_va_pf_dec INTO vn_vrt_pgto_va_pf;
    CLOSE cur_soma_pgto_va_pf_dec;

    vn_vlr_total_ficha_cam := vn_vrt_parc_var_dec
                            + vn_vrt_pgto_va_pv
                            + vn_vrt_pgto_va_pf;

    /* Se o valor da invoice for maior que o valor da ficha câmbio, não conseguimos
       pagar o valor correto ao fornecedor, uma vez que o banco central permitirá
       pagamentos até o valor declarado na ficha cambio. Se o valor da invoice for
       menor que o valor da ficha câmbio, conseguiremos pagar o fornecedor porém o
       Banco Central acusará que temos pendências para remeter para o Exterior.     */
    IF (vn_vlr_total_invoices <> vn_vlr_total_ficha_cam) THEN

      /* Criar uma lista os números das invoices pertencentes a este embarque */
      FOR vcur_embarque_invoices IN cur_embarque_invoices (pn_embarque_id) LOOP
        vc_dec_referencia    := vcur_embarque_invoices.referencia;
        vc_lista_de_invoices := vc_lista_de_invoices || vcur_embarque_invoices.invoice_num || ', ';
      END LOOP;

      /* Tira a última vírgula*/
      vc_lista_de_invoices := SubStr (vc_lista_de_invoices, 1, Length (vc_lista_de_invoices) - 2 );

      /* Retorna mensagem de alterta no log de erros */
      prc_gera_log_erros ('O valor total das invoices é ' || vn_vlr_total_invoices
                          || ' e o valor total das fichas câmbio é ' || vn_vlr_total_ficha_cam
                          ||'. Existe divergência dos valores! Verificar a declaração com a referência '
                          || vc_dec_referencia || ' e as invoices de número '|| vc_lista_de_invoices
                          ||'.', 'A', 'D');
    END IF;

  END imp_prc_compara_vlr_ivc_f_camb;

  -- ***************************************************************************************
  -- Rotina para verificar se todos os itens impressos no RCR estao com vida util preenchida
  -- ***************************************************************************************
  PROCEDURE imp_prc_verifica_itens_rcr (pn_embarque_id NUMBER, pn_tp_declaracao NUMBER, pn_declaracao_id NUMBER, pc_dsi VARCHAR2) IS
    CURSOR cur_checa_rcr IS
      SELECT DISTINCT ida.adicao_num
        FROM imp_declaracoes_adi  ida
           , imp_declaracoes_lin  idl
           , imp_adm_temp_rcr_lin rcr_lin
           , imp_adm_temp_rcr     rcr
       WHERE rcr.rcr_id                          = rcr_lin.rcr_id
         AND rcr_lin.invoice_lin_id              = idl.invoice_lin_id
         AND idl.declaracao_adi_id               = ida.declaracao_adi_id
         AND ida.declaracao_id                   = pn_declaracao_id
         AND nvl (ida.admissao_temporaria, 'N')  = 'N'
         AND ida.vida_util                      IS null;

    vc_adicoes_sem_vida_util VARCHAR2(1000);
    vb_tem_rcr               BOOLEAN := false;

  BEGIN
    IF (pn_tp_declaracao = 12) AND (pc_dsi = 'N') THEN
      FOR i IN cur_checa_rcr LOOP
        vb_tem_rcr := true;
        vc_adicoes_sem_vida_util := vc_adicoes_sem_vida_util || i.adicao_num || ', ';
      END LOOP;

      IF (vb_tem_rcr) THEN
        prc_gera_log_erros ( 'A(s) adição(ções) ' || vc_adicoes_sem_vida_util || ' cujos ' ||
                             'itens estão em um RCR, não tem(têm) vida útil preenchida.'
                           , 'A'
                           , 'D');
      END IF;
    END IF;
  END imp_prc_verifica_itens_rcr;

  -- *************************************************************************************
  -- Rotina para verificar o preenchimento dos dados relacionados a anuencia do fabricante
  -- nas adicoes.
  -- *************************************************************************************
  PROCEDURE prc_verifica_anuencia_fabric (pn_declaracao_id NUMBER, pc_dsi VARCHAR2) IS
    CURSOR cur_ausencia_fabric IS
      SELECT ida.ausencia_fabric
           , ida.export_id
           , ida.export_site_id
           , ida.fabric_id
           , ida.fabric_site_id
           , ida.pais_origem_id
           , ida.adicao_num
        FROM imp_declaracoes_adi ida
       WHERE ida.declaracao_id = pn_declaracao_id;

  BEGIN
    IF (pc_dsi = 'N') THEN
      FOR i IN cur_ausencia_fabric LOOP
        IF (i.ausencia_fabric = 1) THEN
          IF (i.export_id IS null) OR (i.export_site_id IS null) THEN
            prc_gera_log_erros ( 'O preenchimento do exportador é obrigatório na adição ' || i.adicao_num || '.'
                               , 'E'
                               , 'D');
          END IF;
        ELSIF (i.ausencia_fabric = 2) THEN
          IF (i.fabric_id IS null) OR (i.fabric_site_id IS null) THEN
            prc_gera_log_erros ( 'O preenchimento do fabricante é obrigatório na adição ' || i.adicao_num || '.'
                               , 'E'
                               , 'D');
          END IF;
        ELSE
          IF (i.pais_origem_id IS null) THEN
            prc_gera_log_erros ( 'O preenchimento do pais de origem da mercadoria é obrigatório na adição ' || i.adicao_num || '.'
                               , 'E'
                               , 'D');
          END IF;
        END IF;
      END LOOP; -- FOR i IN cur_ausencia_fabric LOOP
    END IF; -- IF (pc_dsi = 'N') THEN
  END prc_verifica_anuencia_fabric;

  PROCEDURE imp_prc_atualiza_ficha_cambio (pn_embarque_id NUMBER, pn_declaracao_id NUMBER) IS

    CURSOR cur_verifica_vmlc_calculado IS
      SELECT nvl (cam.vmlc_m_linha, 0) vmlc_m_linha
           , cam.invoice_id
           , ivc.invoice_num
        FROM imp_vw_dcl_lin_ficha_cambio cam
           , imp_invoices                ivc
       WHERE ivc.invoice_id = cam.invoice_id
         AND declaracao_id  = pn_declaracao_id;

    CURSOR cur_docs_cambio IS
      SELECT invoice_importacao_id
           , invoice_num
           , tipo_contrato
           , tipo_ficha_cambio
           , contrato_numero numero_contrato
           , instituicao_praca_id instituicao_id
           , valor_m
           , cd_praca
        FROM imp_vw_cam_invoices_importacao
       WHERE embarque_importacao_id = pn_embarque_id
      ORDER BY invoice_importacao_id;

    CURSOR cur_sum_declaracoes_lin (pn_invoice_id NUMBER) IS
      SELECT SUM(vmlc_m_linha) vmlc_m
           , Count(*) contador
        FROM imp_vw_dcl_lin_ficha_cambio
       WHERE invoice_id    = pn_invoice_id;

    CURSOR cur_declaracoes_lin (pn_invoice_id NUMBER) IS
      SELECT vmlc_m_linha
           , declaracao_adi_id
           , cobertura_cambial
           , licenca_id
           , licenca_lin_id
           , nr_registro_li
           , declaracao_id
        FROM imp_vw_dcl_lin_ficha_cambio
       WHERE invoice_id    = pn_invoice_id;

    CURSOR cur_tmp_ficha IS
      SELECT declaracao_id
           , declaracao_adi_id
           , tipo_ficha_cambio
           , instituicao_id
           , numero_contrato
           , praca
           , cobertura_cambial
           , licenca_id
           , nr_registro_li
           , Sum(valor_m) valor_m
        FROM imp_tmp_dcl_adi_ficha_cambio
      GROUP BY declaracao_id
             , declaracao_adi_id
             , tipo_ficha_cambio
             , instituicao_id
             , numero_contrato
             , praca
             , cobertura_cambial
             , licenca_id
             , nr_registro_li;

    CURSOR cur_checa_li_di IS
      SELECT il.referencia
        FROM imp_licencas        il
           , imp_declaracoes_adi ida
       WHERE ida.licenca_id = il.licenca_id
         AND (   il.cobertura_cambial    <> ida.cobertura_cambial
              OR il.inst_financiadora_id <> ida.inst_financiadora_id
              OR il.mde_pgto_id          <> ida.mde_pgto_id)
         AND il.embarque_id = pn_embarque_id;

    vn_invoice_importacao_id      NUMBER         := 0;
    vn_vmlc_invoice               NUMBER         := 0;
    vn_contador_total             NUMBER         := 0;
    vn_contador                   NUMBER         := 0;
    vn_soma_vmlc_invoice          NUMBER         := 0;
    vn_indice                     NUMBER         := 0;
    vn_valor_rateado              NUMBER         := 0;
    vb_fichas_validas             BOOLEAN        := true;
    vb_primeira_vez               BOOLEAN        := true;
    vn_declaracao_adi_id_anterior NUMBER         := null;
    vc_invoices_sem_vmlc          VARCHAR2(2000) := null;
    vb_executa_processamento      BOOLEAN        := true;
    vb_li_diferente_di            BOOLEAN        := false;

  BEGIN  -- imp_prc_atualiza_ficha_cambio
    -- LOOP para checar se todas as invoices tiveram VMLC calculado para
    -- evitarmos o erro de divisao por zero
    FOR i IN cur_verifica_vmlc_calculado LOOP
      IF (i.vmlc_m_linha = 0) THEN
        vc_invoices_sem_vmlc := i.invoice_num || '/';
      END IF;

      IF (vc_invoices_sem_vmlc IS NOT null) THEN
        vb_executa_processamento := false;
        vc_invoices_sem_vmlc     := substr (vc_invoices_sem_vmlc, 1, length (vc_invoices_sem_vmlc) - 1);
      END IF;
    END LOOP;

    IF (NOT vb_executa_processamento) THEN
      prc_gera_log_erros ( 'A(s) invoice(s) [' || vc_invoices_sem_vmlc || '] nao tiveram o VMLC calculado. O calculo das fichas cambiais nao sera realizado.'
                         , 'E'
                         , 'A');
    ELSE
      vn_invoice_importacao_id := 0;

      FOR x IN cur_docs_cambio LOOP
        IF vn_invoice_importacao_id <> x.invoice_importacao_id THEN
          OPEN  cur_sum_declaracoes_lin (x.invoice_importacao_id);
          FETCH cur_sum_declaracoes_lin INTO vn_vmlc_invoice, vn_contador_total;
          CLOSE cur_sum_declaracoes_lin;

          vn_invoice_importacao_id := x.invoice_importacao_id;
        END IF;
        --Customização UHK
        IF vn_vmlc_invoice = 0 THEN
          vn_vmlc_invoice := 1;
        END IF;

        vn_indice            := x.valor_m / vn_vmlc_invoice;
        vn_contador          := 0;
        vn_soma_vmlc_invoice := 0;

        FOR y IN cur_declaracoes_lin (x.invoice_importacao_id) LOOP
          vn_contador := vn_contador + 1;

          IF vn_contador = vn_contador_total THEN
            vn_valor_rateado := x.valor_m - vn_soma_vmlc_invoice;
          ELSE
            vn_valor_rateado := Round((y.vmlc_m_linha * vn_indice),2);
          END IF;

          vn_soma_vmlc_invoice := vn_soma_vmlc_invoice + vn_valor_rateado;

          IF vn_valor_rateado > 0 THEN
            INSERT INTO imp_tmp_dcl_adi_ficha_cambio (
              tipo_contrato
            , tipo_ficha_cambio
            , numero_contrato
            , instituicao_id
            , praca
            , cobertura_cambial
            , valor_m
            , declaracao_adi_id
            , declaracao_id
            , licenca_id
            , nr_registro_li
            )
            VALUES (
              x.tipo_contrato
            , x.tipo_ficha_cambio
            , x.numero_contrato
            , x.instituicao_id
            , x.cd_praca
            , y.cobertura_cambial
            , vn_valor_rateado
            , y.declaracao_adi_id
            , y.declaracao_id
            , y.licenca_id
            , y.nr_registro_li
            );
          END IF;  -- vn_valor_rateado
        END LOOP;
      END LOOP;

      -----------------------------------------
      -- Valida ficha cambio da DI
      -----------------------------------------
      vb_fichas_validas := true;
      FOR x IN (SELECT adicao_num
                  FROM imp_declaracoes_adi adi
                     , imp_declaracoes     id
                 WHERE (SELECT Count(*)
                              FROM imp_tmp_dcl_adi_ficha_cambio tmp
                             WHERE tmp.tipo_ficha_cambio NOT IN ('A', 'V', 'R')
                               AND tmp.declaracao_adi_id = adi.declaracao_adi_id
                       ) >= 1
                   AND id.declaracao_id      = adi.declaracao_id
                   AND adi.cobertura_cambial = 3
                   AND id.embarque_id        = pn_embarque_id
                )
      LOOP
        vb_fichas_validas := false;
        prc_gera_log_erros ('Erro na gravação da ficha de câmbio da adição ' || x.adicao_num || '. Não pode haver ROF e pagamento a prazo na mesma adição. Exclua a declaração e gere novamente.', 'E', 'A');
      END LOOP;

      -----------------------------------------
      -- Valida ficha cambio da LI
      -----------------------------------------
      FOR x IN (SELECT referencia
                  FROM imp_licencas il
                 WHERE (SELECT Count(*)
                              FROM imp_tmp_dcl_adi_ficha_cambio tmp
                             WHERE tmp.tipo_ficha_cambio NOT IN ('A', 'V', 'R')
                               AND tmp.licenca_id = il.licenca_id
                       ) >= 1
                   AND il.embarque_id   = pn_embarque_id
                   AND il.cobertura_cambial = 3
                   AND il.nr_registro IS null
                )
      LOOP
        vb_fichas_validas := false;
        prc_gera_log_erros ('Erro na gravação da ficha de câmbio da LI ' || x.referencia || '. Não pode haver ROF e pagamento a prazo na mesma adição. Exclua a declaração e gere novamente.', 'E', 'A');
      END LOOP;

      IF vb_fichas_validas THEN
        vb_primeira_vez := true;
        FOR x IN cur_tmp_ficha LOOP
          IF vb_primeira_vez THEN
            DELETE FROM imp_dcl_adi_pgto WHERE declaracao_id = x.declaracao_id;

            vb_primeira_vez := false;
          END IF;

          IF x.tipo_ficha_cambio = 'R' THEN
            IF x.licenca_id IS NOT null AND x.nr_registro_li IS null THEN

              UPDATE imp_licencas
                 SET cobertura_cambial    = 3
                   , inst_financiadora_id = x.instituicao_id
                   , mde_pgto_id          = NULL
                   , qtde_dias            = 0
               WHERE licenca_id = x.licenca_id;

            ELSIF x.licenca_id IS null THEN

              UPDATE imp_declaracoes_adi
                 SET nr_rof                = x.numero_contrato
                   , inst_financiadora_id  = x.instituicao_id
                   , cobertura_cambial     = 3
                   , mde_pgto_id           = NULL
                   , nr_parcelas           = 0
                   , nr_periodos           = 0
               WHERE declaracao_adi_id = x.declaracao_adi_id;

            ELSIF x.licenca_id IS NOT null AND x.nr_registro_li IS NOT null THEN
              vb_li_diferente_di := false;

              FOR lidi IN cur_checa_li_di LOOP
                vb_li_diferente_di := true;
                prc_gera_log_erros ('(1) Erro na gravacao da ficha de cambio. A LI '|| x.nr_registro_li ||' esta registrada com tipo de pagamento diferente do informado na adicao. Efetue a retificacao da LI ou acerte os dados da adicao da DI.', 'E', 'A');
              END LOOP;
            END IF;

          ELSIF x.tipo_ficha_cambio <> 'P' THEN

            IF x.licenca_id IS NOT null AND x.nr_registro_li IS null THEN
              IF x.cobertura_cambial NOT IN (1,2) THEN
                UPDATE imp_licencas
                   SET cobertura_cambial    = 1
                     , inst_financiadora_id = null
                 WHERE licenca_id = x.licenca_id;
              END IF;
            ELSE
              IF (x.cobertura_cambial NOT IN (1,2)) AND (x.licenca_id IS null) THEN
                UPDATE imp_declaracoes_adi
                   SET cobertura_cambial    = 1
                     , inst_financiadora_id = null
                 WHERE declaracao_adi_id = x.declaracao_adi_id;
              END IF;

              -- Numero do contrato na tabela cam_contratos pode ter até 25 caracteres
              -- e na tabela imp_dcl_adi_pgto até 11 caracteres.
              --Customização UHK
              IF (length (x.numero_contrato) > 50) THEN
                prc_gera_log_erros ('Número do contrato (' || x.numero_contrato || ') deve ter até 11 caracteres.', 'E', 'A');
              ELSE
                INSERT INTO imp_dcl_adi_pgto (
                   declaracao_id
                 , declaracao_adi_id
                 , tp_pgto
                 , contrato_num
                 , banco_agencia_id
                 , praca
                 , valor_m
                 , grupo_acesso_id
                 , creation_date
                 , created_by
                 , last_update_date
                 , last_updated_by
                 )
                VALUES (
                   x.declaracao_id
                 , x.declaracao_adi_id
                 , x.tipo_ficha_cambio
                 , x.numero_contrato
                 , x.instituicao_id
                 , x.praca
                 , x.valor_m
                 , vn_global_grupo_acesso_id
                 , sysdate
                 , 0
                 , sysdate
                 , 0
                );
              END IF; -- IF (Length(x.numero_contrato) > 11) THEN
            END IF;
          END IF;  -- x.tipo_ficha_cambio
        END LOOP;
      END IF;  -- vb_fichas_validas
    END IF; -- IF (NOT vb_executa_processamento) THEN
  END imp_prc_atualiza_ficha_cambio;

  PROCEDURE prc_verifica_grupo_incoterms (pn_declaracao_id NUMBER) IS
    CURSOR cur_verifica_grupos IS
      SELECT count (DISTINCT incoterm.auxiliar11)
        FROM imp_declaracoes_adi ida
           , cmx_tabelas         incoterm
       WHERE incoterm.tabela_id = ida.incoterm_id
         AND ida.declaracao_id  = pn_declaracao_id;

    vn_qtde_incoterms  NUMBER := 0;

  BEGIN -- prc_verifica_grupo_incoterms
    OPEN  cur_verifica_grupos;
    FETCH cur_verifica_grupos INTO vn_qtde_incoterms;
    CLOSE cur_verifica_grupos;

    IF (vn_qtde_incoterms > 1) THEN
      prc_gera_log_erros ( 'A declaração está utilizando INCOTERMS pertencentes a mais de um grupo (1 e 2). Verifique o atributo 11 da tabela do sistema no. 907.'
                         , 'E'
                         , 'A');
    END IF;
  END prc_verifica_grupo_incoterms;

  PROCEDURE prc_verifica_peso (pn_embarque_id NUMBER) IS
    CURSOR cur_invoices IS
      SELECT Sum(ivcl.pesoliq_tot) peso_linhas
          ,  ivc.peso_liquido       peso_invoice
          ,  ivc.invoice_num
        FROM imp_invoices     ivc
           , imp_invoices_lin ivcl
       WHERE ivc.embarque_id = pn_embarque_id
         AND ivc.invoice_id  = ivcl.invoice_id
       GROUP BY ivc.peso_liquido, ivc.invoice_num;

    CURSOR cur_peso_embalagem_ret IS
      SELECT Sum(pesoliq_tot) pesoliq_tot
        FROM imp_invoices         ii
           , imp_invoices_lin     iil
           , cmx_tabelas          cti
       WHERE ii.embarque_id    = pn_embarque_id
         AND iil.invoice_id    = ii.invoice_id
         AND cmx_pkg_tabelas.auxiliar(iil.tp_linha_id,1) = 'E'
         AND cti.tabela_id (+) = ii.incoterm_id
    ORDER BY iil.invoice_id, iil.invoice_lin_id;

    vb_apresentar_erro    BOOLEAN := false;
    vn_peso_invoice       NUMBER;
    vn_peso_embalagem_ret NUMBER;

  BEGIN
     FOR i IN cur_invoices LOOP

        OPEN cur_peso_embalagem_ret;
       FETCH cur_peso_embalagem_ret INTO vn_peso_embalagem_ret;
       CLOSE cur_peso_embalagem_ret;

       vn_peso_invoice := i.peso_invoice;

       IF( i.peso_linhas <> vn_peso_invoice AND vn_peso_embalagem_ret IS null)  THEN
         IF( vn_peso_invoice > 0 AND cmx_fnc_profile('IMP_TOTALIZA_RATEIO_PESO_IVC') = 'S' ) THEN
           vb_apresentar_erro := true;
         ELSIF( cmx_fnc_profile('IMP_TOTALIZA_RATEIO_PESO_IVC') = 'N' ) THEN
           vb_apresentar_erro := true;
         END IF;

         IF (vb_apresentar_erro) THEN
           prc_gera_log_erros ( 'Peso da capa da Invoice '|| i.invoice_num  ||' não confere com a somátoria dos pesos das linhas. Peso Capa: ' || vn_peso_invoice || ' Peso Linhas: ' || i.peso_linhas
                              , 'E'
                              , 'A'
                              );
         END IF;

       ELSIF( (i.peso_linhas - Nvl(vn_peso_embalagem_ret,0)) <> vn_peso_invoice AND vn_peso_embalagem_ret IS NOT null)  THEN

          IF( vn_peso_invoice > 0 AND cmx_fnc_profile('IMP_TOTALIZA_RATEIO_PESO_IVC') = 'S' ) THEN
            vb_apresentar_erro := true;
          ELSIF( cmx_fnc_profile('IMP_TOTALIZA_RATEIO_PESO_IVC') = 'N' ) THEN
            vb_apresentar_erro := true;
          END IF;

          IF (vb_apresentar_erro) THEN
            prc_gera_log_erros ( 'Peso da capa da Invoice '|| i.invoice_num  ||' não confere com a somátoria dos pesos das linhas do tipo mercadoria. Peso Capa: ' || vn_peso_invoice || ' Peso Linhas: ' || i.peso_linhas
                                , 'A'
                                , 'A'
                                );
          END IF;

       END IF;
     END LOOP;
  END prc_verifica_peso;

-----------------------------------------------------------------------------------------
-- Procedure utilizada para a totalização da Remessa do Planejamento da DI Única
-----------------------------------------------------------------------------------------
PROCEDURE imp_prc_tot_di_unica (  pn_embarque_id    NUMBER
                                , pd_data_totalizar DATE
                                , pn_empresa_id     NUMBER
                                , pn_declaracao_id  NUMBER
                               )
  IS
  CURSOR cur_remessas IS
    SELECT po_remessa_id
         , vrt_sg_m
         , moeda_seguro_id
         , nvl(aliq_seguro,0) vn_aliq_seg
         , conhec_id
         , nr_remessa
      FROM imp_po_remessa
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_valor_inv (pn_remessa_id NUMBER) IS
    SELECT Sum(valor_fob) valor_fob_m
         , moeda_id
      FROM imp_invoices
     WHERE di_unica = 'S'
       AND remessa_id = pn_remessa_id
  GROUP BY moeda_id;

  CURSOR cur_peso_inv (pn_remessa_id NUMBER) IS
    SELECT Sum(peso_liquido) peso_liquido
      FROM imp_invoices
     WHERE di_unica = 'S'
       AND remessa_id = pn_remessa_id;

  CURSOR cur_conhec_rem(pn_remessa_id NUMBER) IS
    SELECT ic.moeda_id
         , nvl (ic.valor_total_m, 0)
      FROM imp_conhecimentos ic,
           imp_po_remessa    re
     WHERE re.po_remessa_id  = pn_remessa_id
       AND ic.conhec_id      = re.conhec_id;

  CURSOR cur_empresas_param IS
    SELECT nvl(tp_base_seguro,'F')
      FROM imp_empresas_param
     WHERE empresa_id = pn_empresa_id;

  CURSOR cur_calc_di_unica_ivc (pd_data DATE) IS
    SELECT Sum (ivc.valor_total) * cmx_pkg_taxas.fnc_taxa_mn (ivc.moeda_id, pd_data, 'FISCAL')
      FROM imp_embarques emb
         , imp_invoices  ivc
     WHERE emb.embarque_id = ivc.embarque_id
       AND emb.embarque_id = pn_embarque_id
  GROUP BY cmx_pkg_taxas.fnc_taxa_mn (ivc.moeda_id, pd_data, 'FISCAL');

  CURSOR cur_calc_di_unica_plan_r (pd_data DATE) IS
    SELECT  Decode ( emb.prev_conhec_moeda_id
                   , NULL
                   , 0
                   , (Nvl (emb.prev_vlr_prepaid, 0) +
           Nvl (emb.prev_vlr_collect, 0) +
           Nvl (emb.prev_vlr_ter_nac, 0)) * cmx_pkg_taxas.fnc_taxa_mn (emb.prev_conhec_moeda_id, pd_data, 'FISCAL'))+
           Decode ( emb.prev_seg_moeda_id
                   , NULL
                   , 0
                   , Nvl (emb.prev_seg_vlr_seg_m, 0) * cmx_pkg_taxas.fnc_taxa_mn (emb.prev_seg_moeda_id, pd_data, 'FISCAL')
                  )
         , emb.prev_seg_vlr_seg_m valor_seg_m
         ,  Decode ( emb.prev_seg_moeda_id
                    , NULL
                    , 0
                    , emb.prev_seg_vlr_seg_m * cmx_pkg_taxas.fnc_taxa_mn (emb.prev_seg_moeda_id, pd_data, 'FISCAL')
                  )  valor_seg_mn
        -- , emb.prev_aliq_seguro
      FROM imp_embarques emb
         , imp_invoices  ivc
     WHERE emb.embarque_id = ivc.embarque_id
       AND emb.embarque_id = pn_embarque_id;


  CURSOR cur_calc_di_unica_rem (pd_data DATE) IS
    SELECT Nvl (re.vrt_sg_mn, 0) +
          (Nvl (c.valor_total_m, 0) * Decode ( c.moeda_id
                                             , NULL
                                             , 0
                                             , cmx_pkg_taxas.fnc_taxa_mn (c.moeda_id, pd_data, 'FISCAL')))
         , vrt_sg_m   valor_seg_m
         , vrt_sg_mn  valor_seg_mn
      FROM imp_po_remessa re
         , imp_conhecimentos c
     WHERE re.conhec_id = c.conhec_id (+)
       AND re.embarque_id =  pn_embarque_id
       AND re.nr_remessa  = '1';

  CURSOR cur_ultima_data_taxa IS
    SELECT ctx.data
      FROM cmx_taxas_locais   ctx
         , cmx_tabelas        ct
     WHERE ct.tipo     = '919'
       AND ct.codigo   = 'FISCAL'
       AND ctx.tipo_id = ct.tabela_id
  ORDER BY ctx.data DESC;

  pn_remessa_id        imp_po_remessa.po_remessa_id%TYPE;
  vn_moeda_sg_id       imp_po_remessa.moeda_seguro_id%TYPE;
  vn_taxa_mn           NUMBER;
  vn_taxa_us           NUMBER;
  vn_vrt_sg_m          imp_po_remessa.vrt_sg_m%TYPE;
  vn_vrt_base_seguro   NUMBER := 0;
  vn_vrt_fr_mn         NUMBER;
  vn_vrt_fr_m          NUMBER;

  vn_base_seguro       NUMBER := 0;
  vn_vlr_fob_m         imp_invoices.valor_fob%TYPE;
  vn_moeda_inv_id      imp_invoices.moeda_id%TYPE;
  vn_peso_liquido      imp_invoices.peso_liquido%TYPE;
  vn_moeda_fr_id       NUMBER := 0;

  vb_achou_conhec      BOOLEAN := FALSE;
  vn_convertido        NUMBER  := 0;
  vb_achou_param       BOOLEAN := FALSE;

  vn_calc_di_unica_plan NUMBER;
  vn_calc_di_unica_ivc  NUMBER;
  vn_valor_seg_m        NUMBER;
  vn_valor_seg_mn       NUMBER;
  vd_data_taxa          DATE;
  vc_nr_remessa         imp_po_remessa.nr_remessa%TYPE;

BEGIN

 /*
  OPEN  cur_ultima_data_taxa;
	FETCH cur_ultima_data_taxa INTO vd_data_taxa;
	CLOSE cur_ultima_data_taxa;

  OPEN  cur_calc_di_unica_ivc (vd_data_taxa);
  FETCH cur_calc_di_unica_ivc INTO vn_calc_di_unica_ivc;
  CLOSE cur_calc_di_unica_ivc;

  OPEN  cur_calc_di_unica_plan_r (vd_data_taxa);
  FETCH cur_calc_di_unica_plan_r INTO vn_calc_di_unica_plan, vn_valor_seg_m, vn_valor_seg_mn;
  CLOSE cur_calc_di_unica_plan_r;

  IF (vn_calc_di_unica_plan = 0) THEN
    OPEN  cur_calc_di_unica_rem (vd_data_taxa);
    FETCH cur_calc_di_unica_rem INTO vn_calc_di_unica_plan, vn_valor_seg_m, vn_valor_seg_mn;
    CLOSE cur_calc_di_unica_rem;
  END IF;

  UPDATE imp_declaracoes
     SET vmle_mn = vn_calc_di_unica_ivc - vn_calc_di_unica_plan
   WHERE declaracao_id = pn_declaracao_id;

  UPDATE imp_declaracoes_adi
     SET vrt_sg_m  = vn_valor_seg_m
       , vrt_sg_mn = vn_valor_seg_mn
   WHERE declaracao_id = pn_declaracao_id;
*/
  FOR i IN cur_remessas LOOP
    vn_vrt_sg_m        := 0;
    vn_vlr_sg_rem_mn   := 0;
    vn_vrt_base_seguro := 0;
    vn_vlr_fob_m       := 0;
    vc_nr_remessa      := i.nr_remessa;

    imp_prc_busca_taxa_conversao (i.moeda_seguro_id,
                                  pd_data_totalizar,
                                  vn_taxa_mn,
                                  vn_taxa_us,
                                  'Seguro');

    --OPEN cur_valor_inv(i.po_remessa_id);
    --FETCH cur_valor_inv INTO vn_vlr_fob_m;
    --CLOSE cur_valor_inv;

    FOR x IN cur_valor_inv(i.po_remessa_id)
    LOOP
      IF ( i.moeda_seguro_id IS NOT NULL AND x.moeda_id IS NOT null) THEN
        vn_vrt_base_seguro := vn_vrt_base_seguro
                            + cmx_pkg_taxas.fnc_converte (
                                                           x.valor_fob_m
                                                         , x.moeda_id
                                                         , i.moeda_seguro_id
                                                         , SYSDATE
                                                         , 'FISCAL'
                                                         );


      END IF;

    END LOOP;



    OPEN cur_peso_inv(i.po_remessa_id);
    FETCH cur_peso_inv INTO vn_peso_liquido;
    CLOSE cur_peso_inv;

    IF (i.conhec_id IS NOT null) THEN
      UPDATE imp_conhecimentos
         SET peso_liquido = Nvl (vn_peso_liquido, 0)
       WHERE conhec_id    = i.conhec_id;
    END IF;

    OPEN  cur_conhec_rem(i.po_remessa_id);
    FETCH cur_conhec_rem INTO vn_moeda_fr_id
                            , vn_vrt_fr_m;
    vb_achou_conhec := cur_conhec_rem%FOUND;
    CLOSE cur_conhec_rem;

    vn_vrt_fr_mn := round (vn_vrt_fr_m * vn_taxa_mn, 7);

    OPEN  cur_empresas_param;
    FETCH cur_empresas_param INTO vc_global_tp_base_seguro;
    vb_achou_param := cur_empresas_param%FOUND;
    CLOSE cur_empresas_param;

    IF NOT vb_achou_param THEN
      prc_gera_log_erros ('Empresa do embarque não parametrizada...', 'E', 'A');
    END IF;

    IF (vc_global_tp_base_seguro <> 'F') AND (i.moeda_seguro_id IS NOT null )THEN
      IF nvl( vn_vrt_fr_m, 0) > 0 THEN
        vn_convertido := cmx_pkg_taxas.fnc_converte ( vn_vrt_fr_m
                                                     , vn_moeda_fr_id
                                                     , i.moeda_seguro_id
                                                     , pd_data_totalizar
                                                     , 'FISCAL'
                                                     );
      ELSE
        vn_convertido := 0;
      END IF;

      vn_vrt_base_seguro := vn_vrt_base_seguro + vn_convertido;

    END IF; -- IF (vc_global_tp_base_seguro <> 'F') AND (i.moeda_seguro_id IS NOT null )THEN

    vn_base_seguro := vn_vrt_base_seguro;
    vn_vrt_sg_m := i.vrt_sg_m;

    IF (i.vn_aliq_seg > 0) THEN
      -- Se a aliquota é maior que zero, precisamos calcular o seguro
      -- para calcular, precisamos verificar se utilizaremos o Frete ou não, de acordo com a parametrizacao
      -- da tela de  Parametros de Importacao.
--      vn_vrt_sg_m  := round (vn_base_seguro * (i.vn_aliq_seg/100),2);
      vn_vrt_sg_m  := round (vn_base_seguro * (i.vn_aliq_seg/100),2);
    END IF;

    vn_vlr_sg_rem_mn := round (vn_vrt_sg_m * vn_taxa_mn,2);

    UPDATE imp_po_remessa
       SET vrt_sg_m  = vn_vrt_sg_m
         , vrt_sg_mn = vn_vlr_sg_rem_mn
     WHERE po_remessa_id = i.po_remessa_id;

  END LOOP;
EXCEPTION
  WHEN others THEN
    prc_gera_log_erros ('Erro no processamento da(s) remessa(s) ' || vc_nr_remessa || ' do Planejamento de DI Única: ' || sqlerrm, 'E', 'A');

END imp_prc_tot_di_unica;

PROCEDURE imp_prc_multa_li(pn_embarque_id NUMBER)
AS

  CURSOR cur_adi_atr
      IS
  SELECT /*+ INDEX (il imp_ebq_li_idx)
             INDEX (ida imp_decl_adi_licenca_id_idx)
          */
         DISTINCT ida.declaracao_adi_id
       , cmx_pkg_tabelas.auxiliar('617','001', 1) base
       , To_Number(cmx_pkg_tabelas.auxiliar('617','002', 1),'990')/100 aliquota
       , To_Number(cmx_pkg_tabelas.auxiliar('617','003', 1)) minimo
       , To_Number(cmx_pkg_tabelas.auxiliar('617','004', 1)) maximo
       , To_Number(cmx_pkg_tabelas.auxiliar('617','005', 1)) reducao_50
       , To_Number(cmx_pkg_tabelas.auxiliar(ida.tp_red_multa_li_id, 1))/100 reducao
       , ida.tp_red_multa_li_id
       , ida.basecalc_ii   valor_aduan
       , ida.adicao_num
    FROM imp_licencas          il
       , imp_declaracoes_adi   ida
       , imp_licenca_anuencias ila
       , imp_declaracoes       id
   WHERE il.embarque_id = pn_embarque_id
     AND ida.licenca_id = il.licenca_id
     AND il.licenca_id  = ila.licenca_id (+)
     AND Trunc(Nvl(ila.data_anuencia,To_Date('01/01/2190','DD/MM/YYYY'))) > Trunc(imp_fnc_busca_dt_cronog(pn_embarque_id, 'EMBARQUE', 'R'))
     AND Nvl(ila.restricao_embarque,'N') = 'S'
     AND id.declaracao_id = ida.declaracao_id
     AND cmx_pkg_tabelas.codigo(id.tp_declaracao_id) NOT IN ('13','14','17','18','28')
     AND il.rd_id IS NULL;

 vb_found BOOLEAN;
 vn_declaracao_adi_id NUMBER;
 vn_valor_multa_li    NUMBER;
 vn_reducao           NUMBER;
 vn_multa_exclusao    NUMBER := 1;



  --Customização UHK
BEGIN return;
  vn_global_vrt_multa_li_mn := 0;

  FOR x IN cur_adi_atr
  LOOP
    IF (x.base IS NULL OR x.aliquota IS NULL OR x.minimo IS NULL OR x.maximo IS NULL OR (x.reducao IS NULL AND x.tp_red_multa_li_id IS NOT NULL) AND x.reducao_50 <> 50 ) THEN
          raise_application_error (
             -20000
           , 'os parâmetros estão incompletos.'
          );
          END IF;

          IF vn_reducao IS NULL THEN
            vn_reducao := 0.5;
          END IF;

          DECLARE
            vc_bloco VARCHAR2(32760);
          BEGIN
            vn_valor_multa_li    := 0;

            vc_bloco := 'DECLARE                                  '      || chr(10) ||
                        '  vn_declaracao_adi_id NUMBER          := :1; ' || chr(10) ||
                        '  vc_base              VARCHAR2(150)   := :2; ' || chr(10) ||
                        '  vn_aliquota          NUMBER          := :3; ' || chr(10) ||
                        '  vn_minimo            NUMBER          := :4; ' || chr(10) ||
                        '  vn_maximo            NUMBER          := :5; ' || chr(10) ||
                        '  vn_reducao           NUMBER          := :6; ' || chr(10) ||
                        '  vn_valor_aduan       NUMBER          := :7; ' || chr(10) ||
                        '  vn_valor_multa_li    NUMBER          := :8; ' || chr(10) ||
                        'BEGIN                                        '  || chr(10) ||
                            cmx_pkg_tabelas.descricao (
                              cmx_pkg_tabelas.tabela_id('146','MULTA_LI')
                            , cmx_pkg_tabelas.tabela_id ('905', 'GENERICO')
                            )                                            || chr(10) ||
                        ' :8 := vn_valor_multa_li;                 ' || chr(10) ||
                        'END;';

            EXECUTE IMMEDIATE vc_bloco
               USING IN x.declaracao_adi_id
                , IN x.base
                , IN x.aliquota
                , IN x.minimo
                , IN x.maximo
                , IN x.reducao
                , IN x.valor_aduan
                , IN OUT vn_valor_multa_li;

          EXCEPTION
            WHEN others THEN
              raise_application_error (
                  -20000
                , 'problema na conversão do coringa da multa de LI. ' || sqlerrm
              );
          END;

          vn_global_vrt_multa_li_mn := vn_global_vrt_multa_li_mn + vn_valor_multa_li;
          UPDATE imp_declaracoes_adi
            SET valor_multa_li = vn_valor_multa_li
              , tp_red_multa_li_id = Nvl(tp_red_multa_li_id, cmx_pkg_tabelas.tabela_id('617', '005'))
              , last_update_date   = vd_global_last_update_date
              , last_updated_by    = vn_global_last_updated_by
          WHERE declaracao_adi_id = x.declaracao_adi_id;

      --  Caso tenha pendencias anteriores, e agora já tenham sido sanadas, a multa é "excluida"
          vn_multa_exclusao := 0;
          prc_gera_log_erros ('Calculada multa de LI (deferimento após embarque) para a adição "' || x.adicao_num || '".',  'A', 'D');

        END LOOP;

  IF(vn_multa_exclusao = 1) THEN
    UPDATE imp_declaracoes_adi
      SET valor_multa_li = null
        , tp_red_multa_li_id = null
        , last_update_date   = vd_global_last_update_date
        , last_updated_by    = vn_global_last_updated_by
    WHERE declaracao_id IN   ( SELECT declaracao_id
                                  FROM imp_declaracoes
                                WHERE embarque_id = pn_embarque_id
                              ) ;
  END IF;


EXCEPTION
  WHEN others THEN
    vn_global_vrt_multa_li_mn := 0;
    prc_gera_log_erros ('Erro no calculo da Multa de LI, ' || sqlerrm, 'E', 'A');

END;

    -----------------------------------------------------------------------------------------
  PROCEDURE imp_prc_tot_m_usada    ( pn_embarque_id                  NUMBER)
  AS
    CURSOR cur_licencas
        IS
    SELECT il.referencia
         , il.material_usado
         , il.mat_usado_enq_id
         , il.mat_usado_oper_id
         , il.nr_registro
         , il.mat_usado_marca
         , il.mat_usado_modelo
         , il.mat_usado_n_serie
         , il.mat_usado_ano
         , il.bem_encomenda
         , il.regtrib_ii_id
         , il.fundamento_legal_id
      FROM imp_licencas il
     WHERE il.embarque_id = pn_embarque_id
       --AND ( il.mat_usado_enq_id IS NULL OR   il.mat_usado_oper_id IS NULL)
       --AND Upper(Nvl(il.material_usado,'N')) = 'S'
  ORDER BY il.referencia;

    CURSOR cur_licencas_lin
        IS
    SELECT ill.linha_num
         , ill.material_usado
         , ill.mat_usado_enq_id
         , ill.mat_usado_oper_id
         , ill.mat_usado_marca
         , ill.mat_usado_modelo
         , ill.mat_usado_n_serie
         , ill.mat_usado_ano
         , ill.regtrib_ii_id
         , ill.fundamento_legal_id
      FROM imp_licencas_lin ill
         , imp_licencas     il
     WHERE ill.licenca_id = il.licenca_id
       AND il.embarque_id = pn_embarque_id
  ORDER BY ill.linha_num;

    vc_linhas VARCHAR2(4000);

  BEGIN

    FOR x IN cur_licencas
    LOOP
      IF ( x.nr_registro IS NULL ) THEN

        IF Nvl(x.material_usado,'N') = 'S' AND x.mat_usado_enq_id IS NULL THEN
          prc_gera_log_erros ('O tipo do enquadramento do material usado não está preenchido na licença [' || x.referencia || '].' , 'E', 'A');
        END IF;

        IF Nvl(x.material_usado,'N') = 'S' AND x.mat_usado_oper_id IS NULL AND cmx_pkg_tabelas.auxiliar(x.mat_usado_enq_id, 1) = '2'  THEN
          prc_gera_log_erros ('O tipo de operação do material usado não está preenchido na licença [' || x.referencia || '].' , 'E', 'A');
        END IF;

        -- Delivery 95722
        IF(Nvl(x.material_usado,'N') = 'S' AND cmx_pkg_tabelas.auxiliar(x.mat_usado_enq_id, 1) = 2
          AND (x.mat_usado_marca IS NULL OR x.mat_usado_modelo IS NULL  OR x.mat_usado_n_serie IS NULL OR x.mat_usado_ano IS NULL )) THEN

          prc_gera_log_erros( 'Os campos referente a Marca, Modelo, Número de Série e Ano de Fabricação devem ser preenchido na licença [' || x.referencia || '] quando o tipo de enquadramento do material usado for do tipo Nacionalização.'
                            , 'A'
                            , 'A'
                            );

        ELSIF( Nvl(x.material_usado, 'N') = 'N' AND Nvl(x.bem_encomenda, 'N') = 'N'
          AND (
                  (cmx_pkg_tabelas.auxiliar(x.regtrib_ii_id, 1) = 3 AND cmx_pkg_tabelas.codigo(x.fundamento_legal_id) IN ('08', '11', '12', '15', '18', '19', '99'))
               OR (cmx_pkg_tabelas.auxiliar(x.regtrib_ii_id, 1) = 5 AND cmx_pkg_tabelas.codigo(x.fundamento_legal_id) IN ('09', '79', '85', '99'))
              )
          AND (x.mat_usado_marca IS NULL OR x.mat_usado_modelo IS NULL  OR x.mat_usado_n_serie IS NULL OR x.mat_usado_ano IS NULL)
             ) THEN

            prc_gera_log_erros( 'Os campos referente a Marca, Modelo, Número de Série e Ano de Fabricação devem ser preenchido na licença [' || x.referencia || '].'
                              , 'A'
                              , 'A'
                              );

        END IF;

--      ELSE
--        IF x.mat_usado_enq_id IS NULL THEN
--          prc_gera_log_erros ('O tipo do enquadramento do material usado não está preenchido na licença [' || x.referencia || ']. Licença já registrada, registro: [' || x.nr_registro || ']' , 'A', 'A');
--        END IF;
--
--        IF x.mat_usado_oper_id IS NULL THEN
--          prc_gera_log_erros ('O tipo de operação de enquadramento do material usado não está preenchido na licença [' || x.referencia || ']. Licença já registrada, registro: [' || x.nr_registro || ']' , 'A', 'A');
--        END IF;

      END IF;

    END LOOP;

    -- Delivery 95722
    vc_linhas := NULL;

    FOR x IN cur_licencas_lin
    LOOP

      IF( (x.mat_usado_marca IS NOT NULL OR x.mat_usado_modelo IS NOT NULL OR x.mat_usado_n_serie IS NOT NULL OR x.mat_usado_ano IS NOT NULL)
        AND NOT(Nvl(x.material_usado,'N') = 'S' AND cmx_pkg_tabelas.auxiliar(x.mat_usado_enq_id, 1) = 2)
        AND NOT( Nvl(x.material_usado, 'N') = 'N'
              AND ( (cmx_pkg_tabelas.auxiliar(x.regtrib_ii_id, 1) = 3 AND cmx_pkg_tabelas.codigo(x.fundamento_legal_id) IN ('08', '11', '12', '15', '18', '19', '99'))
                 OR (cmx_pkg_tabelas.auxiliar(x.regtrib_ii_id, 1) = 5 AND cmx_pkg_tabelas.codigo(x.fundamento_legal_id) IN ('09', '79', '85', '99'))
                  )
               )
        ) THEN

          IF(vc_linhas IS NULL) THEN
            vc_linhas := x.linha_num;
          ELSE
            vc_linhas := vc_linhas||', '||x.linha_num;
          END IF;

      END IF;

    END LOOP;

    IF(vc_linhas IS NOT NULL) THEN
      prc_gera_log_erros( 'Os campos referente a Marca, Modelo, Número de Série e Ano de Fabricação não deveriam ter sido informados na(s) linha(s) ('||vc_linhas||') da licença. ' ||
                          'Segundo as regras do SISCOMEX, estes campos devem ser preenchido somente nos casos de material usado e exame de similaridade. Ver Notícia Siscomex n°65.'
                        , 'A'
                        , 'A'
                        );
    END IF;

  END;


  -- ***********************************************************************
  -- Ajustes ultima remessa DI UNICA
  -- ***********************************************************************
  PROCEDURE imp_prc_ajusta_di_unica(pn_embarque_id NUMBER, pn_declaracao_id NUMBER, pd_data_conversao DATE)
  IS
    CURSOR cur_ultima_rem IS
    SELECT ice.peso_liquido
         , ice.peso_bruto
         , Nvl(valor_prepaid_m,0) + Nvl(valor_collect_m,0) frete_int
         , Nvl(valor_prepaid_m,0)        fr_prepaid
         , Nvl(valor_collect_m,0)        fr_collect
         , Nvl(valor_terr_nacional_m,0)  fr_terr_nac
      FROM imp_vw_conhec_ebq ice
     WHERE ice.embarque_id = pn_embarque_id
       AND ultima_remessa = 'S';

    CURSOR cur_seguro
    IS
    SELECT Sum(ipr.vrt_sg_mn ) vrt_sg_tot_mn
      FROM imp_po_remessa ipr
     WHERE ipr.embarque_id=pn_embarque_id;


    vb_ultima_rem                  BOOLEAN := FALSE;
    vr_ultima_rem                  cur_ultima_rem%ROWTYPE;
    vn_fat_rateio_brt              NUMBER;
    vn_fat_rateio_liq              NUMBER;
    vn_fat_rateio_adi              NUMBER;
    vn_pestot_di_unica             NUMBER;
    vn_fat_rateio_frete            NUMBER;

    vn_pesoliq_dcl_lin_tot         NUMBER;
    vn_pesobrt_dcl_lin_tot         NUMBER;
    vn_pesoliq_dcl_adi_tot         NUMBER;
    vn_frete_int_dcl_adi           NUMBER;
    vn_seguro_dcl_adi_m            NUMBER;

    --vn_pesobrt_dcl_adi_tot         NUMBER;
    vn_taxa_mn                     NUMBER;
    vn_taxa_us                     NUMBER;
    vn_fat_rateio_sg               NUMBER;
    vn_seg_di_unica                NUMBER;
    vn_seg_di_unica_m              NUMBER;

    vn_fat_rateio_sg_ivc           NUMBER;
    vn_sg_ivc_lin                 NUMBER;
    vn_sg_ivc_lin_m               NUMBER;

    vn_fat_rateio_fr_ivc           NUMBER;
    vn_fr_ivc_lin                 NUMBER;
    vn_fr_ivc_lin_m               NUMBER;

    vn_fat_rateio_frp_ivc          NUMBER;
    vn_frp_ivc_lin                 NUMBER;
    vn_frp_ivc_lin_m               NUMBER;

    vn_fat_rateio_frc_ivc          NUMBER;
    vn_frc_ivc_lin                 NUMBER;
    vn_frc_ivc_lin_m               NUMBER;

    vn_fat_rateio_frn_ivc          NUMBER;
    vn_frn_ivc_lin                 NUMBER;
    vn_frn_ivc_lin_m               NUMBER;

    vn_fat_rateio_fr_tot_ivc       NUMBER;
    vn_fr_tot_ivc_lin              NUMBER;
    vn_fr_tot_ivc_lin_m            NUMBER;


  BEGIN
    OPEN  cur_ultima_rem;
    FETCH cur_ultima_rem INTO vr_ultima_rem;
    vb_ultima_rem  := cur_ultima_rem%FOUND;
    CLOSE cur_ultima_rem;

    IF vb_ultima_rem THEN

      vn_pesoliq_dcl_lin_tot := 0;
      vn_pesobrt_dcl_lin_tot := 0;
      vn_pesoliq_dcl_adi_tot := 0;
      vn_frete_int_dcl_adi   := 0;
      vn_seguro_dcl_adi_m    := 0;
      vn_sg_ivc_lin_m        := 0;
      vn_fr_ivc_lin_m        := 0;
      vn_frp_ivc_lin_m       := 0;
      vn_frc_ivc_lin_m       := 0;
      vn_frn_ivc_lin_m       := 0;
      vn_fr_tot_ivc_lin_m    := 0;

      FOR dcl IN 1..vn_global_dcl_lin LOOP
        vn_pesoliq_dcl_lin_tot := vn_pesoliq_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesoliq_tot,0);
        vn_pesobrt_dcl_lin_tot := vn_pesobrt_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesobrt_tot,0);
      END LOOP;

      FOR ivl IN 1..vn_global_ivc_lin LOOP
         vn_sg_ivc_lin_m       := vn_sg_ivc_lin_m      + Nvl(tb_ivc_lin(ivl).vrt_sg_m,0);
         vn_fr_ivc_lin_m       := vn_fr_ivc_lin_m      + Nvl(tb_ivc_lin(ivl).vrt_fr_m,0);
         vn_frp_ivc_lin_m      := vn_frp_ivc_lin_m     + Nvl(tb_ivc_lin(ivl).vrt_fr_prepaid_m,0);
         vn_frc_ivc_lin_m      := vn_frc_ivc_lin_m     + Nvl(tb_ivc_lin(ivl).vrt_fr_collect_m,0);
         vn_frn_ivc_lin_m      := vn_frn_ivc_lin_m     + Nvl(tb_ivc_lin(ivl).vrt_fr_territorio_nacional_m,0);
         vn_fr_tot_ivc_lin_m   := vn_fr_tot_ivc_lin_m  + Nvl(tb_ivc_lin(ivl).vrt_fr_total_m,0);
      END LOOP;

      FOR dca IN 1..vn_global_dcl_adi LOOP
        vn_pesoliq_dcl_adi_tot := vn_pesoliq_dcl_adi_tot + Nvl(tb_dcl_adi(dca).peso_liquido,0);
        vn_frete_int_dcl_adi   := vn_frete_int_dcl_adi   + Nvl(tb_dcl_adi(dca).vrt_fr_m,0);
--        vn_pesobrt_dcl_adi_tot := tb_dcl_adi(dca).pesobrt_tot; imp_declaracoes_adi
        vn_seguro_dcl_adi_m    := vn_seguro_dcl_adi_m    + Nvl(tb_dcl_adi(dca).vrt_sg_m,0);
      END LOOP;

      imp_prc_busca_taxa_conversao (vn_global_moeda_sg_id,
                                    pd_data_conversao,
                                    vn_taxa_mn,
                                    vn_taxa_us,
                                    'SEGURO DI UNICA');

      OPEN cur_seguro;
      FETCH cur_seguro INTO vn_seg_di_unica;
      CLOSE cur_seguro;

      vn_seg_di_unica_m := vn_seg_di_unica / vn_taxa_mn;

      vn_fat_rateio_liq         :=  vr_ultima_rem.peso_liquido / Nvl(nullif(vn_pesoliq_dcl_lin_tot,0),1);
      vn_fat_rateio_brt         :=  vr_ultima_rem.peso_bruto   / Nvl(nullif(vn_pesobrt_dcl_lin_tot,0),1);
      vn_fat_rateio_adi         :=  vr_ultima_rem.peso_liquido / Nvl(nullif(vn_pesoliq_dcl_adi_tot,0),1);
      vn_fat_rateio_frete       :=  vr_ultima_rem.frete_int    / Nvl(nullif(vn_frete_int_dcl_adi,0),1);
      vn_fat_rateio_sg          :=  vn_seg_di_unica_m          / Nvl(nullif(vn_seguro_dcl_adi_m,0),1);

      vn_fat_rateio_sg_ivc      := vn_seg_di_unica_m           / Nvl(nullif(vn_sg_ivc_lin_m,0),1);
      vn_fat_rateio_fr_ivc      := vr_ultima_rem.frete_int     / Nvl(nullif(vn_fr_ivc_lin_m,0),1);
      vn_fat_rateio_frp_ivc     := vr_ultima_rem.fr_prepaid    / Nvl(nullif(vn_frp_ivc_lin_m,0),1);
      vn_fat_rateio_frc_ivc     := vr_ultima_rem.fr_collect    / Nvl(nullif(vn_frc_ivc_lin_m,0),1);
      vn_fat_rateio_frn_ivc     := vr_ultima_rem.fr_terr_nac   / Nvl(nullif(vn_frn_ivc_lin_m,0),1);
      vn_fat_rateio_fr_tot_ivc  := vr_ultima_rem.frete_int     / Nvl(nullif(vn_fr_tot_ivc_lin_m,0),1);



      FOR dcl IN 1..vn_global_dcl_lin LOOP
        tb_dcl_lin(dcl).pesoliq_tot := Round(tb_dcl_lin(dcl).pesoliq_tot * vn_fat_rateio_liq,5);
        tb_dcl_lin(dcl).pesobrt_tot := Round(tb_dcl_lin(dcl).pesobrt_tot * vn_fat_rateio_brt,5);


      END LOOP;

      FOR ivl IN 1..vn_global_ivc_lin LOOP
         tb_ivc_lin(ivl).vrt_sg_m                      := Round(tb_ivc_lin(ivl).vrt_sg_m                      * vn_fat_rateio_sg_ivc,5);
         tb_ivc_lin(ivl).vrt_sg_mn                     := Round(tb_ivc_lin(ivl).vrt_sg_mn                     * vn_fat_rateio_sg_ivc,5);
         tb_ivc_lin(ivl).vrt_sg_us                     := Round(tb_ivc_lin(ivl).vrt_sg_us                     * vn_fat_rateio_sg_ivc,5);

         tb_ivc_lin(ivl).vrt_fr_m                      := Round(tb_ivc_lin(ivl).vrt_fr_m                      * vn_fat_rateio_fr_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_mn                     := Round(tb_ivc_lin(ivl).vrt_fr_mn                     * vn_fat_rateio_fr_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_us                     := Round(tb_ivc_lin(ivl).vrt_fr_us                     * vn_fat_rateio_fr_ivc,5);

         tb_ivc_lin(ivl).vrt_fr_prepaid_m              := Round(tb_ivc_lin(ivl).vrt_fr_prepaid_m              * vn_fat_rateio_frp_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_prepaid_mn             := Round(tb_ivc_lin(ivl).vrt_fr_prepaid_mn             * vn_fat_rateio_frp_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_prepaid_us             := Round(tb_ivc_lin(ivl).vrt_fr_prepaid_us             * vn_fat_rateio_frp_ivc,5);

         tb_ivc_lin(ivl).vrt_fr_collect_m              := Round(tb_ivc_lin(ivl).vrt_fr_collect_m              * vn_fat_rateio_frc_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_collect_mn             := Round(tb_ivc_lin(ivl).vrt_fr_collect_mn             * vn_fat_rateio_frc_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_collect_us             := Round(tb_ivc_lin(ivl).vrt_fr_collect_us             * vn_fat_rateio_frc_ivc,5);

         tb_ivc_lin(ivl).vrt_fr_territorio_nacional_m  := Round(tb_ivc_lin(ivl).vrt_fr_territorio_nacional_m  * vn_fat_rateio_frn_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_territorio_nacional_mn := Round(tb_ivc_lin(ivl).vrt_fr_territorio_nacional_mn * vn_fat_rateio_frn_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_territorio_nacional_us := Round(tb_ivc_lin(ivl).vrt_fr_territorio_nacional_us * vn_fat_rateio_frn_ivc,5);

         tb_ivc_lin(ivl).vrt_fr_total_m                := Round(tb_ivc_lin(ivl).vrt_fr_total_m                * vn_fat_rateio_fr_tot_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_total_mn               := Round(tb_ivc_lin(ivl).vrt_fr_total_mn               * vn_fat_rateio_fr_tot_ivc,5);
         tb_ivc_lin(ivl).vrt_fr_total_us               := Round(tb_ivc_lin(ivl).vrt_fr_total_us              * vn_fat_rateio_fr_tot_ivc,5);


      END LOOP;



      FOR dca IN 1..vn_global_dcl_adi LOOP
        tb_dcl_adi(dca).peso_liquido := Round(tb_dcl_adi(dca).peso_liquido * vn_fat_rateio_adi,5);
        tb_dcl_adi(dca).vrt_fr_m  := Round(tb_dcl_adi(dca).vrt_fr_m * vn_fat_rateio_frete,5);
        tb_dcl_adi(dca).vrt_fr_us  := Round(tb_dcl_adi(dca).vrt_fr_us * vn_fat_rateio_frete,5);
        tb_dcl_adi(dca).vrt_fr_mn  := Round(tb_dcl_adi(dca).vrt_fr_mn * vn_fat_rateio_frete,5);

        tb_dcl_adi(dca).vrt_sg_m  := Round(tb_dcl_adi(dca).vrt_sg_m * vn_fat_rateio_sg,5);

        tb_dcl_adi(dca).vrt_sg_us  := Round(tb_dcl_adi(dca).vrt_sg_us * vn_fat_rateio_sg,5);
        tb_dcl_adi(dca).vrt_sg_mn  := Round(tb_dcl_adi(dca).vrt_sg_mn * vn_fat_rateio_sg,5);

      END LOOP;

    ELSE

      FOR dcl IN 1..vn_global_dcl_lin LOOP
        vn_pesoliq_dcl_lin_tot := vn_pesoliq_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesoliq_tot,0);
        vn_pesobrt_dcl_lin_tot := vn_pesobrt_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesobrt_tot,0);
      END LOOP;

      FOR dca IN 1..vn_global_dcl_adi LOOP
        vn_pesoliq_dcl_adi_tot := vn_pesoliq_dcl_adi_tot + Nvl(tb_dcl_adi(dca).peso_liquido,0);
--        vn_frete_int_dcl_adi   := vn_frete_int_dcl_adi   + Nvl(tb_dcl_adi(dca).vrt_fr_m,0);
--        vn_pesobrt_dcl_adi_tot := tb_dcl_adi(dca).pesobrt_tot; imp_declaracoes_adi
--        vn_seguro_dcl_adi_m    := vn_seguro_dcl_adi_m    + Nvl(tb_dcl_adi(dca).vrt_sg_m,0);
      END LOOP;




    END IF;

  END;


  -- ***********************************************************************
  -- Ajustes ultima remessa DI UNICA
  -- ***********************************************************************
  PROCEDURE imp_prc_ajusta_peso_di_unica(pn_embarque_id NUMBER, pn_declaracao_id NUMBER, pd_data_conversao DATE)
  IS
    CURSOR cur_ultima_rem IS
    SELECT ice.peso_liquido
         , ice.peso_bruto
      FROM imp_vw_conhec_ebq ice
     WHERE ice.embarque_id = pn_embarque_id
       AND ultima_remessa = 'S';

	CURSOR cur_valor_rem IS
		SELECT sum(valor_fob * cmx_pkg_Taxas.fnc_paridade_usd (moeda_id, pd_data_conversao, 'FISCAL'))   valor_fob_rem_us
		  FROM imp_invoices
		 WHERE remessa_id IN (SELECT po_remessa_id
		                        FROM imp_po_remessa
		                       WHERE embarque_id = pn_embarque_id);



    vb_ultima_rem                  BOOLEAN := FALSE;
    vr_ultima_rem                  cur_ultima_rem%ROWTYPE;
    vn_fat_rateio_brt              NUMBER;
    vn_fat_rateio_liq              NUMBER;
    vn_fat_rateio_adi              NUMBER;
    vn_pestot_di_unica             NUMBER;

    vn_pesoliq_dcl_lin_tot         NUMBER;
    vn_pesobrt_dcl_lin_tot         NUMBER;
    vn_pesoliq_dcl_adi_tot         NUMBER;
    vn_fob_ivc_us                  NUMBER;
    vn_fob_rem_us                  NUMBER;



  BEGIN
    OPEN  cur_ultima_rem;
    FETCH cur_ultima_rem INTO vr_ultima_rem;
    vb_ultima_rem  := cur_ultima_rem%FOUND;
    CLOSE cur_ultima_rem;

    IF vb_ultima_rem THEN

      vn_pesoliq_dcl_lin_tot := 0;
      vn_pesobrt_dcl_lin_tot := 0;
      vn_pesoliq_dcl_adi_tot := 0;

      FOR dcl IN 1..vn_global_dcl_lin LOOP
        vn_pesoliq_dcl_lin_tot := vn_pesoliq_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesoliq_tot,0);
        vn_pesobrt_dcl_lin_tot := vn_pesobrt_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesobrt_tot,0);
      END LOOP;

      FOR dca IN 1..vn_global_dcl_adi LOOP
        vn_pesoliq_dcl_adi_tot := vn_pesoliq_dcl_adi_tot + Nvl(tb_dcl_adi(dca).peso_liquido,0);
      END LOOP;

      vn_fat_rateio_liq         :=  vr_ultima_rem.peso_liquido / Nvl(nullif(vn_pesoliq_dcl_lin_tot,0),1);
      vn_fat_rateio_brt         :=  vr_ultima_rem.peso_bruto   / Nvl(nullif(vn_pesobrt_dcl_lin_tot,0),1);
      vn_fat_rateio_adi         :=  vr_ultima_rem.peso_liquido / Nvl(nullif(vn_pesoliq_dcl_adi_tot,0),1);


      FOR dcl IN 1..vn_global_dcl_lin LOOP
        tb_dcl_lin(dcl).pesoliq_tot := Round(tb_dcl_lin(dcl).pesoliq_tot * vn_fat_rateio_liq,5);
        tb_dcl_lin(dcl).pesobrt_tot := Round(tb_dcl_lin(dcl).pesobrt_tot * vn_fat_rateio_brt,5);


      END LOOP;


      FOR dca IN 1..vn_global_dcl_adi LOOP
        tb_dcl_adi(dca).peso_liquido := Round(tb_dcl_adi(dca).peso_liquido * vn_fat_rateio_adi,5);
      END LOOP;

      vn_fob_ivc_us := 0;
      FOR ivl IN 1..vn_global_ivc_lin LOOP
        vn_fob_ivc_us := vn_fob_ivc_us + tb_ivc_lin(ivl).vrt_fob_us;
      END LOOP;
      OPEN cur_valor_rem;
      FETCH cur_valor_rem INTO vn_fob_rem_us;
      CLOSE cur_valor_rem;

      IF (Nvl(vn_fob_ivc_us,0) <> Nvl(vn_fob_rem_us,0)) THEN
        prc_gera_log_erros ('Valor FOB informado nas invoices das remessas [US$ ' || To_Char(vn_fob_rem_us, 'FM999G999G999G999G999G990D00')|| '] é diferente do valor FOB calculado na totaliza na última remessa de DI única [US$ ' || To_Char(vn_fob_ivc_us, 'FM999G999G999G999G999G990D00')|| '].', 'A', 'D');
      END IF;




    ELSE

      FOR dcl IN 1..vn_global_dcl_lin LOOP
        vn_pesoliq_dcl_lin_tot := vn_pesoliq_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesoliq_tot,0);
        vn_pesobrt_dcl_lin_tot := vn_pesobrt_dcl_lin_tot + Nvl(tb_dcl_lin(dcl).pesobrt_tot,0);
      END LOOP;

      FOR dca IN 1..vn_global_dcl_adi LOOP
        vn_pesoliq_dcl_adi_tot := vn_pesoliq_dcl_adi_tot + Nvl(tb_dcl_adi(dca).peso_liquido,0);
      END LOOP;

    END IF;


  END;


  -- *****************************************************************
  -- Verificando Recintos, Unidades fiscais Tabelas 115 e 917
  -- *****************************************************************
  PROCEDURE prc_valida_unidade_fiscal(pn_embarque_id NUMBER)
  IS
    vd_data_urfe             DATE;    -- auxiliar15 tabela 917
    vd_data_urfd             DATE;    -- auxiliar15 tabela 917
    vd_data_rec              DATE;    -- auxiliar5  tabela 115
    vd_data_setor            DATE;    -- auxiliar5  tabela 116
    vc_nr_declaracao         imp_declaracoes.nr_declaracao%TYPE;
    vn_urfe_id               NUMBER;
    vn_urfd_id               NUMBER;
    vn_rec_alfand_id         NUMBER;
    vn_setor_armazem_id      NUMBER;
    vc_mensagem_alerta       VARCHAR2(400) := NULL;
    vc_mensagem_solucao_rec  VARCHAR2(400) := NULL;
    vc_mensagem_solucao_unid VARCHAR2(400) := NULL;

    CURSOR cur_dados_logisticos IS
      SELECT urfe_id, urfd_id, rec_alfand_id, setor_armazem_id
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_licenca IS
      SELECT urfe_id, urfd_id
        FROM imp_licencas
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_declaracao IS
      SELECT nr_declaracao, urfe_id, urfd_id, rec_alfand_id, setor_armazem_id
        FROM imp_declaracoes
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_vigencia_urf(pn_tabela_id NUMBER) IS
      SELECT Decode(auxiliar15,'-',NULL,To_Date(auxiliar15,'dd/mm/rrrr')) vigencia
        FROM cmx_tabelas
       WHERE tipo = '917'
         AND tabela_id = pn_tabela_id;

    CURSOR cur_vigencia_recinto(pn_tabela_id NUMBER) IS
      SELECT Decode(auxiliar5,'-',NULL,To_Date(auxiliar5,'dd/mm/rrrr')) vigencia
        FROM cmx_tabelas
       WHERE tipo = '115'
        AND tabela_Id = pn_tabela_id;

    CURSOR cur_vigencia_setor(pn_tabela_id NUMBER) IS
      SELECT Decode(auxiliar5,'-',NULL,To_Date(auxiliar5,'dd/mm/rrrr')) vigencia
        FROM cmx_tabelas
       WHERE tipo = '116'
        AND tabela_Id = pn_tabela_id;

  BEGIN

    vc_mensagem_solucao_unid := 'Verificar a unidade de referência fiscal (URFE ou URFD) informada no processo (conhecimento de transporte, na licença de importação, na declaração de importação ou nos dados logísticos) e substituir por uma ativa.';
    vc_mensagem_solucao_rec  := 'Verificar o recinto e o setor informados na declaração de importação ou nos dados logísticos e substituir por um ativo.';

    OPEN cur_declaracao;
    FETCH cur_declaracao INTO vc_nr_declaracao, vn_urfe_id, vn_urfd_id, vn_rec_alfand_id, vn_setor_armazem_id;
    CLOSE cur_declaracao;

    IF (vc_nr_declaracao IS NULL) THEN

      IF (vn_urfe_id IS NOT NULL) THEN
        OPEN cur_vigencia_urf(vn_urfe_id);
        FETCH cur_vigencia_urf INTO vd_data_urfe;
        CLOSE cur_vigencia_urf;
      END IF;

      IF (vn_urfd_id IS NOT NULL) THEN
        OPEN cur_vigencia_urf(vn_urfd_id);
        FETCH cur_vigencia_urf INTO vd_data_urfd;
        CLOSE cur_vigencia_urf;
      END IF;

      IF (vn_rec_alfand_id IS NOT NULL) THEN
        OPEN cur_vigencia_recinto(vn_rec_alfand_id);
        FETCH cur_vigencia_recinto INTO vd_data_rec;
        CLOSE cur_vigencia_recinto;
      END IF;

      IF (vn_setor_armazem_id IS NOT NULL) THEN
        OPEN cur_vigencia_setor(vn_setor_armazem_id);
        FETCH cur_vigencia_setor INTO vd_data_setor;
        CLOSE cur_vigencia_setor;
      END IF;

      IF (Nvl(Trunc(vd_data_urfe), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
        vc_mensagem_alerta  := 'A unidade de referência fiscal ['||cmx_pkg_tabelas.codigo(vn_urfe_id)||'] informada no processo está inativa.';
        vc_global_ebq_totalizado := 'N';
        vc_global_dcl_totalizada := 'N';
        cmx_prc_gera_log_erros (
              vn_global_evento_id
            , vc_mensagem_alerta
            , 'E'
            , vc_mensagem_solucao_unid
            );
      END IF;

      IF (Nvl(Trunc(vd_data_urfd), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
        vc_mensagem_alerta  := 'A unidade de referência fiscal ['||cmx_pkg_tabelas.codigo(vn_urfd_id)||'] informada no processo está inativa.';
        vc_global_ebq_totalizado := 'N';
        vc_global_dcl_totalizada := 'N';
        cmx_prc_gera_log_erros (
              vn_global_evento_id
            , vc_mensagem_alerta
            , 'E'
            , vc_mensagem_solucao_unid
            );
      END IF;

      IF (Nvl(Trunc(vd_data_rec), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
        vc_mensagem_alerta  := 'O recinto ['||cmx_pkg_tabelas.codigo(vn_rec_alfand_id)||'] informado no processo está inativo.';
        vc_global_ebq_totalizado := 'N';
        vc_global_dcl_totalizada := 'N';
        cmx_prc_gera_log_erros (
              vn_global_evento_id
            , vc_mensagem_alerta
            , 'E'
            , vc_mensagem_solucao_rec
            );
      END IF;

      IF (Nvl(Trunc(vd_data_setor), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
        vc_mensagem_alerta  := 'O setor ['||cmx_pkg_tabelas.codigo(vn_setor_armazem_id)||'] informado no processo está inativo.';
        vc_global_ebq_totalizado := 'N';
        vc_global_dcl_totalizada := 'N';
        cmx_prc_gera_log_erros (
              vn_global_evento_id
            , vc_mensagem_alerta
            , 'E'
            , vc_mensagem_solucao_rec
            );
      END IF;

      FOR dados IN cur_dados_logisticos LOOP

        vd_data_urfe  := NULL;
        vd_data_urfd  := NULL;
        vd_data_rec   := NULL;
        vd_data_setor := NULL;

        IF (dados.urfe_id IS NOT NULL) THEN
          OPEN cur_vigencia_urf(dados.urfe_id);
          FETCH cur_vigencia_urf INTO vd_data_urfe;
          CLOSE cur_vigencia_urf;
        END IF;

        IF (dados.urfd_id IS NOT NULL) THEN
          OPEN cur_vigencia_urf(dados.urfd_id);
          FETCH cur_vigencia_urf INTO vd_data_urfd;
          CLOSE cur_vigencia_urf;
        END IF;

        IF (dados.rec_alfand_id IS NOT NULL) THEN
          OPEN cur_vigencia_recinto(dados.rec_alfand_id);
          FETCH cur_vigencia_recinto INTO vd_data_rec;
          CLOSE cur_vigencia_recinto;
        END IF;

        IF (dados.setor_armazem_id IS NOT NULL) THEN
          OPEN cur_vigencia_setor(dados.setor_armazem_id);
          FETCH cur_vigencia_setor INTO vd_data_setor;
          CLOSE cur_vigencia_setor;
        END IF;

        IF (Nvl(Trunc(vd_data_urfe), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
          vc_mensagem_alerta  := 'A unidade de referência fiscal ['||cmx_pkg_tabelas.codigo(dados.urfe_id)||'] informada no processo está inativa.';
          vc_global_ebq_totalizado := 'N';
          vc_global_dcl_totalizada := 'N';
          cmx_prc_gera_log_erros (
                vn_global_evento_id
              , vc_mensagem_alerta
              , 'E'
              , vc_mensagem_solucao_unid
              );
        END IF;

        IF (Nvl(Trunc(vd_data_urfd), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
          vc_mensagem_alerta  := 'A unidade de referência fiscal ['||cmx_pkg_tabelas.codigo(dados.urfd_id)||'] informada no processo está inativa.';
          vc_global_ebq_totalizado := 'N';
          vc_global_dcl_totalizada := 'N';
          cmx_prc_gera_log_erros (
                vn_global_evento_id
              , vc_mensagem_alerta
              , 'E'
              , vc_mensagem_solucao_unid
              );
        END IF;

        IF (Nvl(Trunc(vd_data_rec), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
          vc_mensagem_alerta  := 'O recinto ['||cmx_pkg_tabelas.codigo(dados.rec_alfand_id)||'] informado no processo está inativo.';
          vc_global_ebq_totalizado := 'N';
          vc_global_dcl_totalizada := 'N';
          cmx_prc_gera_log_erros (
                vn_global_evento_id
              , vc_mensagem_alerta
              , 'E'
              , vc_mensagem_solucao_rec
              );
        END IF;

        IF (Nvl(Trunc(vd_data_setor), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
          vc_mensagem_alerta  := 'O setor ['||cmx_pkg_tabelas.codigo(dados.setor_armazem_id)||'] informado no processo está inativo.';
          vc_global_ebq_totalizado := 'N';
          vc_global_dcl_totalizada := 'N';
          cmx_prc_gera_log_erros (
                vn_global_evento_id
              , vc_mensagem_alerta
              , 'E'
              , vc_mensagem_solucao_rec
              );
        END IF;

      END LOOP;

      FOR licenca IN cur_licenca LOOP
        IF (licenca.urfe_id IS NOT NULL) THEN
          OPEN cur_vigencia_urf(licenca.urfe_id);
          FETCH cur_vigencia_urf INTO vd_data_urfe;
          CLOSE cur_vigencia_urf;
        END IF;

        IF (licenca.urfd_id IS NOT NULL) THEN
          OPEN cur_vigencia_urf(licenca.urfd_id);
          FETCH cur_vigencia_urf INTO vd_data_urfd;
          CLOSE cur_vigencia_urf;
        END IF;

        IF (Nvl(Trunc(vd_data_urfe), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
          vc_mensagem_alerta  := 'A unidade de referência fiscal ['||cmx_pkg_tabelas.codigo(licenca.urfe_id)||'] informada no processo está inativa.';
          vc_global_ebq_totalizado := 'N';
          vc_global_dcl_totalizada := 'N';
          cmx_prc_gera_log_erros (
                vn_global_evento_id
              , vc_mensagem_alerta
              , 'E'
              , vc_mensagem_solucao_unid
              );
        END IF;

        IF (Nvl(Trunc(vd_data_urfd), Trunc(SYSDATE)) < Trunc(SYSDATE)) THEN
          vc_mensagem_alerta  := 'A unidade de referência fiscal ['||cmx_pkg_tabelas.codigo(licenca.urfd_id)||'] informada no processo está inativa.';
          vc_global_ebq_totalizado := 'N';
          vc_global_dcl_totalizada := 'N';
          cmx_prc_gera_log_erros (
                vn_global_evento_id
              , vc_mensagem_alerta
              , 'E'
              , vc_mensagem_solucao_unid
              );
        END IF;
      END LOOP;

    END IF; -- IF (vc_nr_declaracao IS NULL) THEN

  END; -- prc_valida_unidade_fiscal


  PROCEDURE imp_prc_ajusta_peso_cap_nac
  AS
  BEGIN
    vn_global_pesobrt_nac := 0;
    vn_global_pesoliq_nac := 0;

    FOR lin IN 1..vn_global_dcl_lin LOOP



      vn_global_pesobrt_nac := vn_global_pesobrt_nac + tb_dcl_lin(lin).pesobrt_tot;
      vn_global_pesoliq_nac := vn_global_pesoliq_nac + tb_dcl_lin(lin).pesoliq_tot;



    END LOOP;

  END; --imp_prc_ajusta_peso_cap_nac;


  -- ***********************************************************************
  -- Função principal
  -- ***********************************************************************
  PROCEDURE imp_prc_totaliza_ebq (pn_empresa_id        NUMBER,
                                  pn_embarque_id       NUMBER,
                                  pc_embarque_ano      VARCHAR2,
                                  pn_declaracao_id     NUMBER,
                                  pd_data_totalizar    DATE,
                                  pc_tp_declaracao     VARCHAR2,
                                  pc_dsi               VARCHAR2,
                                  pd_creation_date     DATE,
                                  pn_created_by        NUMBER,
                                  pd_last_update_date  DATE,
                                  pn_last_updated_by   NUMBER,
                                  pn_evento_id         IN OUT NUMBER
                                 )
  IS
    CURSOR cur_ultima_data_taxa IS
      SELECT ctx.data
        FROM cmx_taxas_locais   ctx
           , cmx_tabelas        ct
       WHERE ct.tipo     = '919'
         AND ct.codigo   = 'FISCAL'
         AND ctx.tipo_id = ct.tabela_id
    ORDER BY ctx.data DESC;

    CURSOR cur_data_taxa_dia(pd_data DATE) IS
      SELECT ctx.data
        FROM cmx_taxas_locais   ctx
           , cmx_tabelas        ct
       WHERE ct.tipo     = '919'
         AND ct.codigo   = 'FISCAL'
         AND ctx.tipo_id = ct.tabela_id
         AND Trunc(ctx.data) = Trunc(pd_data)
    ORDER BY ctx.data DESC;

    CURSOR cur_nac_sem_admissao (pn_declaracao_id NUMBER) IS
      SELECT nvl (nac_sem_vinc_admissao, 'N')
        FROM imp_declaracoes
       WHERE declaracao_id = pn_declaracao_id;

    CURSOR cur_tp_embarque IS
      SELECT tp_embarque_id
        FROM imp_embarques
       WHERE embarque_id = pn_embarque_id;

    vd_data_conversao    DATE := pd_data_totalizar;
    vn_aliq_seguro       NUMBER;
    vn_via_transp_id     NUMBER;
    vn_error_prc         NUMBER;
    vn_tp_embarque_id    NUMBER;

  BEGIN
    OPEN cur_tp_embarque;
    FETCH cur_tp_embarque INTO vn_tp_embarque_id;
    CLOSE cur_tp_embarque;

    vd_global_creation_date    := pd_creation_date;
    vn_global_created_by       := pn_created_by;
    vd_global_last_update_date := pd_last_update_date;
    vn_global_last_updated_by  := pn_last_updated_by;

    -- Alteração recomendada pelo Rodrigo, desenvolvida por Cintia, 17.12.2004

    -- SELECT grupo_acesso_id
    --   INTO vn_global_grupo_acesso_id
    --   FROM sen_usuarios
    --  WHERE id = pn_created_by;

    SELECT grupo_acesso_id
      INTO vn_global_grupo_acesso_id
      FROM imp_embarques
     WHERE embarque_id = pn_embarque_id;

    IF vn_global_grupo_acesso_id IS null THEN
      SELECT grupo_acesso_id
        INTO vn_global_grupo_acesso_id
        FROM sen_usuarios
       WHERE id = pn_created_by;
    END IF;
    -- Fim da alteração recomendada pelo Rodrigo

    IF pn_evento_id IS NOT null THEN
      vn_global_evento_id := pn_evento_id;
    ELSE
      pn_evento_id := cmx_fnc_gera_evento (
                         'Totalização - Embarque: ' || pc_embarque_ano
                       , sysdate
                       , vn_global_created_by
                      );
      vn_global_evento_id := pn_evento_id;
    END IF;

-- Delivery 103957: melhoria de performance INICIO
   imp_prc_rateio_direcionado_ebq( pn_embarque_id  => pn_embarque_id
                                 , pn_numerario_id => NULL
                                 , pn_usuario_id   => pn_created_by );
-- Delivery 103957: melhoria de performance FIM

    ----------------------------------------------------------------------------
    -- Atualiza o peso líquido das linhas da invoice com o peso unitário
    -- calculado da tabela customizada para a Schaeffler.
    -- Essa procedure é usada apenas na empresa Schaeffler, la foi criado
    -- um sinônimo para essa procedure. No sistema core ela é criada como null.
    ----------------------------------------------------------------------------
    imp_prc_totaliza_hook2 (pn_empresa_id, pn_embarque_id, vn_global_evento_id, vc_global_dcl_totalizada);

    imp_prc_zera_globais;

    imp_prc_tot_m_usada(pn_embarque_id);


    ----------------------------------------------------------------------------
    -- Quando a data do registro da declaração estiver preenchida, esta será a
    -- data base para a busca das taxas de conversão. Caso contrário, devemos
    -- achar a data mais recente cadastrada entre as taxas.
    ----------------------------------------------------------------------------
    IF (vd_data_conversao IS null) THEN

      OPEN  cur_data_taxa_dia(SYSDATE);
      FETCH cur_data_taxa_dia INTO vd_data_conversao;
      CLOSE cur_data_taxa_dia;

      IF(vd_data_conversao IS NULL) THEN
        OPEN  cur_ultima_data_taxa;
        FETCH cur_ultima_data_taxa INTO vd_data_conversao;
        CLOSE cur_ultima_data_taxa;
      END IF;

      IF (vd_data_conversao IS null) THEN
        prc_gera_log_erros ('Data para as taxas de conversão não encontrada, verifique cadastro de taxas fiscais...', 'E', 'A');
      END IF;
    END IF;
    ----------------------------------------------------------------------------
    imp_prc_carrega_parametros     (pn_empresa_id);

    /* Verificar se é uma nacionalização sem admissão de entreposto aduaneiro */
    OPEN cur_nac_sem_admissao (pn_declaracao_id);
    FETCH cur_nac_sem_admissao INTO vc_global_nac_sem_admissao;
    CLOSE cur_nac_sem_Admissao;

    /* Obtem a moeda do seguro internacional */
    OPEN  cur_moeda_seguro (pn_embarque_id);
    FETCH cur_moeda_seguro INTO vn_global_moeda_sg_id, vn_aliq_seguro, vn_via_transp_id;
    CLOSE cur_moeda_seguro;

    /* Verificação se o embarque é DI única */
    prc_verif_di_unica (pn_embarque_id);

-- Início Correção do calculo de aliquota de seguro (Sapatin)
--    IF (nvl(vn_aliq_seguro,0) <> 0) AND (vn_via_transp_id IS NOT null) AND (nvl(to_number(pc_tp_declaracao),0) < 13 OR (nvl(to_number(pc_tp_declaracao),0) IN (13, 14) AND vc_global_nac_sem_admissao = 'S')) AND (Nvl(vc_global_verif_di_unica, '*') <> 'DI_UNICA') THEN
--      BEGIN
--        SELECT aliquota
--          INTO vn_aliq_seguro
--          FROM imp_empresas_param_seguro
--         WHERE empresa_id        = pn_empresa_id
--           AND via_transporte_id = vn_via_transp_id
--           AND trunc(sysdate) between dt_ini_vigencia AND dt_fim_vigencia;

--        IF (nvl(vn_aliq_seguro,0) <> 0) THEN
--          UPDATE imp_embarques
--             SET aliq_seguro = vn_aliq_seguro
--           WHERE embarque_id = pn_embarque_id;
--        END IF;
--      EXCEPTION
--        WHEN others THEN
--          NULL;
--      END;
--    END IF;
-- Fim Correção do calculo de aliquota de seguro (Sapatin)

    IF (nvl(pc_tp_declaracao,'00') <> '16') THEN
      imp_prc_carrega_linhas_ivc (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0));
    END IF;

    IF (nvl(to_number(pc_tp_declaracao),0) >= 13
        AND vc_global_nac_sem_admissao = 'N'
        AND Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id,1),'XX') <> 'NAC_DE_TERC'
       ) THEN  -- NACIONALIZACAO, retirada nacionalização de Admissão temporaria
      imp_prc_carrega_linhas_dcl_nac (pn_declaracao_id, vd_data_conversao);
    END IF;

    imp_prc_acerta_pesos_liq_e_brt (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0),vn_tp_embarque_id);
    IF (pn_declaracao_id > 0) THEN
      IF(   (   nvl (to_number (pc_tp_declaracao), 0) < 13
             OR vc_global_nac_sem_admissao = 'S'
            )
         OR (Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id,1),'XX') = 'NAC_DE_TERC' )
        )  THEN -- Habilitado Admissão Temporária
        imp_prc_carrega_linhas_dcl (pn_embarque_id, pn_declaracao_id, vd_data_conversao);
      END IF;
    END IF;

    IF (nvl(pc_tp_declaracao,'00') <> '16') THEN
      -- imp_prc_acerta_pesos_liq_e_brt (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0));
      imp_prc_processa_fr_internac   (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0), vd_data_conversao, pn_declaracao_id);
      --- ajustar os valores da DI UNICA AQUI
      IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
        imp_prc_ajusta_di_unica        (pn_embarque_id, pn_declaracao_id,vd_data_conversao);
      END IF;




      imp_prc_rateia_valores_invoice (pn_embarque_id, vd_data_conversao);

      IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
        imp_prc_tot_di_unica(pn_embarque_id, vd_data_conversao, pn_empresa_id, pn_declaracao_id);
      END IF;

      imp_prc_processa_sg_embutido   (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0), vd_data_conversao, vn_tp_embarque_id);
      imp_prc_processa_acresded      (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0), pn_declaracao_id, vd_data_conversao);
      imp_prc_calcula_vmle           (pn_embarque_id);
      imp_prc_processa_sg_internac   (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0), vd_data_conversao);
      imp_prc_checa_frete_ivc_vs_bl  (pn_embarque_id, vd_data_conversao);
      imp_prc_checa_seguro_ivc_vs_eb (pn_embarque_id, vd_data_conversao, vn_global_moeda_sg_id);
--      imp_prc_recalcula_vmlc;

      IF (nvl (pc_tp_declaracao, '00') IN ('13', '14', '15') AND vc_global_nac_sem_admissao = 'N') THEN
        imp_prc_checa_frete_ivc_vs_da (pn_embarque_id, vd_data_conversao);
      END IF;
    END IF;

    IF (pn_declaracao_id > 0) THEN
--      IF( (nvl (to_number (pc_tp_declaracao), 0) < 13 OR vc_global_nac_sem_admissao = 'S')
--           OR (Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id,1),'XX') = 'NAC_DE_TERC' )
--        )  THEN -- Habilitado Admissão Temporária
--        imp_prc_carrega_linhas_dcl (pn_embarque_id, pn_declaracao_id, vd_data_conversao);
--      END IF;

      imp_prc_checa_linhas_ivc_dcl (pn_embarque_id, pn_declaracao_id);
    END IF;


    --------------------------------------------
    -- Rateando todos os numerários
    --------------------------------------------
    IF (nvl (to_number (pc_tp_declaracao), 0) <> 16) THEN
      imp_prc_rateia_numerarios (pn_embarque_id);
    ELSE -- nacionalizacoes de recof
      imp_prc_rateia_numerarios_nac (pn_embarque_id);
    END IF;
    --------------------------------------------

    imp_prc_grava_ivc_lin_da       (pn_embarque_id);

    IF (pn_embarque_id IS NOT null) THEN
      imp_prc_grava_rateio_numerario (pn_embarque_id);
    END IF;

    IF (pn_declaracao_id > 0) THEN
      imp_prc_calcula_impostos (pn_embarque_id, nvl(to_number(pc_tp_declaracao),0), vd_data_conversao, pn_empresa_id, pc_tp_declaracao, pc_dsi, pn_declaracao_id, vn_tp_embarque_id/* NAC_DE_TERC*/);
      IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
        imp_prc_ajusta_peso_di_unica        (pn_embarque_id, pn_declaracao_id,vd_data_conversao);
      END IF;

      IF (nvl(to_number(pc_tp_declaracao),0) = 17 AND Nvl(cmx_pkg_tabelas.auxiliar(vn_tp_embarque_id,1),'XX') = 'NAC_DE_TERC' ) THEN
        imp_prc_ajusta_peso_cap_nac;
      END IF;

      imp_prc_grava_declaracao (nvl(to_number(pc_tp_declaracao),0), pn_declaracao_id, vd_data_conversao, pc_dsi, pn_embarque_id, vn_tp_embarque_id/* NAC_DE_TERC*/);
      imp_prc_multa_li(pn_embarque_id);
      imp_prc_grava_DARF       (pn_declaracao_id, nvl(pc_dsi,'N'));
    END IF;

    IF (pn_embarque_id IS NOT null) THEN
      imp_prc_grava_linhas_ivc       (pn_embarque_id, vd_data_conversao) ;
      imp_prc_gera_deducao_po        (pn_embarque_id);
      imp_prc_grava_linhas_ivc_po;
      imp_prc_grava_linhas_ivc_ad    (pn_embarque_id);
      --imp_prc_grava_rateio_numerario (pn_embarque_id);
      imp_prc_grava_licenca          (pn_embarque_id, vd_data_conversao) ;
    ELSE
      imp_prc_grava_licenca_nac      (pn_declaracao_id, vd_data_conversao) ;
    END IF;

    /* Liberando linhas de declaracao */
    imp_prc_libera_flag_dcl_lin (pn_declaracao_id);

    /* Atualiza valores da ficha de câmbio */
    IF cmx_fnc_profile ('CAMBIO_NSI') <> 'N' THEN
      imp_prc_atualiza_ficha_cambio (pn_embarque_id, pn_declaracao_id);
    END IF;

    IF (Nvl(vc_global_verif_di_unica, '*') <> 'DI_UNICA') THEN
      /* Verifica o valor das invoices com as fichas câmbio*/
      imp_prc_compara_vlr_ivc_f_camb (pn_embarque_id);
    END IF;

    /* Consiste itens do RCR */
    imp_prc_verifica_itens_rcr (pn_embarque_id, nvl (to_number (pc_tp_declaracao), 0), pn_declaracao_id, nvl (pc_dsi, 'N'));

    /* Consiste dados relacionados a anuencia do fabricante */
    prc_verifica_anuencia_fabric (pn_declaracao_id, nvl (pc_dsi, 'N'));

    /* Consiste se a DI esta utilizando incoterms de mais um grupo */
    prc_verifica_grupo_incoterms (pn_declaracao_id);

    /* Com a possibilidade de fixar peso nas linhas temos que checar se o valor
       fixo das linhas + os valores rateados das linhas sem peso fixo sao iguais
       ao peso total da invoice
    */
    prc_verifica_peso(pn_embarque_id);

    /* Atualiza a moeda do frete e seguro na DI de nacionalização quando a moeda estiver inativa */
    FOR dcll IN 1..vn_global_dcl_lin LOOP
      IF tb_dcl_lin(dcll).moeda_inativa THEN
        UPDATE imp_declaracoes_adi
           SET da_moeda_frete_id  = tb_dcl_lin(dcll).moeda_frete_id
             , da_moeda_seguro_id = tb_dcl_lin(dcll).moeda_seguro_id
         WHERE declaracao_adi_id = tb_dcl_lin(dcll).declaracao_adi_id;
      END IF;
    END LOOP;

    -----------------------------------------------------------------
    -- Gerando numerários automáticos - DARF
    -----------------------------------------------------------------
    imp_pkg_gera_numerarios.prc_geracao ( pn_empresa_id
                                        , pn_embarque_id
                                        , pn_declaracao_id
                                        , vn_global_grupo_acesso_id
                                        , 'T'
                                        , vc_global_dcl_totalizada
                                        , pn_evento_id
                                        );
    -----------------------------------------------------------------

    ----------------------------------------------------------------------------------
    -- Extensao para a totaliza. Utilizado para customizacoes em clientes, se necessário.
    ----------------------------------------------------------------------------------
    imp_prc_totaliza_hook1      (  /* 01 */ pn_empresa_id
                                 , /* 02 */ pn_embarque_id
                                 , /* 03 */ pc_embarque_ano
                                 , /* 04 */ pn_declaracao_id
                                 , /* 05 */ pc_tp_declaracao
                                 , /* 06 */ pc_dsi
                                 , /* 07 */ vn_global_vrt_fob_ebq_mn
                                 , /* 08 */ vn_global_vrt_dspfob_ebq_mn
                                 , /* 09 */ vn_global_vrt_fr_mn
                                 , /* 10 */ vn_global_vrt_sg_ebq_mn
                                 , /* 11 */ pn_evento_id
                                 , /* 12 */ vn_global_grupo_acesso_id
                                 , /* 13 */ pd_creation_date
                                 , /* 14 */ pn_created_by
                                 , /* 15 */ pd_last_update_date
                                 , /* 16 */ pn_last_updated_by
                                 , /* 17 */ vn_global_moeda_fr_id
                                 , /* 18 */ vn_global_moeda_sg_id
                                 , /* 19 */ nvl(to_number(pc_tp_declaracao),0)
                                 , /* 20 */ vd_data_conversao
                                 , /* 21 */ vc_global_incide_aliq_icms_pc
                                 , /* 22 */ vc_global_calc_icms_imp_dev
                                 , /* 23 */ vc_global_dcl_totalizada
                                );
    ----------------------------------------------------------------------------------

    IF Nvl(cmx_fnc_profile ('IMP_OBRIGA_TOTALIZAR_EBQ_APROV_NUM'),'N') ='N' THEN
      -----------------------------------------------------------------
      -- Aprovando numerários automáticos - DARF
      -----------------------------------------------------------------
      IF vc_global_aprov_num_auto = 'S' THEN
        imp_pkg_gera_numerarios.prc_aprovacao ( pn_embarque_id
                                              , pn_declaracao_id
                                              , 'T'
                                              , pn_evento_id
                                              , vc_global_dcl_totalizada
                                              );
      END IF;
    END IF;
      -----------------------------------------------------------------

    -------------------------------------------------------------------
    -- Verificando o saldo, por valor, para as LI´s de Ato tipo Isenção
    -------------------------------------------------------------------

    imp_prc_checa_li_saldo_vlr_drw (
       pn_embarque_id
     , pc_embarque_ano
     , pn_evento_id
     , vc_global_dcl_totalizada
    );

    -------------------------------------------------------------------
    -- Verificando o saldo, por quantidade estatística, para as LI´s de
    -- Ato tipo Isenção
    -------------------------------------------------------------------

    imp_prc_checa_li_saldo_est_drw (
       pn_embarque_id
     , pc_embarque_ano
     , pn_evento_id
     , vc_global_dcl_totalizada
    );

    -------------------------------------------------------------------
    -- Verificando a NCM da LI com a NCM do plano de Drawback
    -------------------------------------------------------------------
    drw_prc_valida_ncm_li (pn_embarque_id, vn_global_evento_id, pn_created_by, vc_global_ebq_totalizado);

    -------------------------------------------------------------------

    prc_verifica_ex_recof(pn_embarque_id,pn_declaracao_id);
    prc_validar_ncm (pn_declaracao_id, pc_dsi, pn_embarque_id);

	  -----------------------------------------------------------------------------
	  -- Delivery 99181: Verificando Recintos, Unidades fiscais Tabelas 115 e 917
	  -----------------------------------------------------------------------------
	  prc_valida_unidade_fiscal(pn_embarque_id);
	  -------------------------------------------------------------------

    IF (vc_global_ebq_totalizado = 'N') THEN
      rollback;
    END IF;

    /* Atualiza flag de embarque totalizado aqui. Deve ser a ultima coisa da totaliza! */
    UPDATE imp_embarques
       SET ebq_totalizado = vc_global_ebq_totalizado
     WHERE embarque_id    = pn_embarque_id;

    IF Nvl(cmx_fnc_profile ('IMP_OBRIGA_TOTALIZAR_EBQ_APROV_NUM'),'N') ='S' THEN
      -- Quando a profile estiver habilitada a aprovacao deve ser depois so embarque totalizado.
      -----------------------------------------------------------------
      -- Aprovando numerários automáticos - DARF
      -----------------------------------------------------------------
      IF vc_global_aprov_num_auto = 'S' THEN
        imp_pkg_gera_numerarios.prc_aprovacao ( pn_embarque_id
                                              , pn_declaracao_id
                                              , 'T'
                                              , pn_evento_id
                                              , vc_global_dcl_totalizada
                                              );

      END IF;
    END IF;
      -----------------------------------------------------------------



    /* Atualiza flag de declaracao totalizada aqui. Deve ser a ultima coisa da totaliza! */
    UPDATE imp_declaracoes
       SET dcl_totalizada = vc_global_dcl_totalizada
     WHERE declaracao_id  = pn_declaracao_id;

    -------------------------------------------------------------------
    -- Validar tamanho da descrição do item para o siscomex (LI/DI) (limite de 3900 caracteres alfanuméricos)
    -------------------------------------------------------------------
    imp_prc_valida_desc_siscomex (pn_embarque_id, vn_global_evento_id, pn_created_by, NULL, NULL, 'A', vn_error_prc);
    -------------------------------------------------------------------

    --IF (Nvl(vc_global_verif_di_unica, '*') = 'DI_UNICA') THEN
    --  imp_prc_tot_di_unica(pn_embarque_id, vd_data_conversao, pn_empresa_id, pn_declaracao_id);
    --END IF;

  END imp_prc_totaliza_ebq;

END imp_pkg_totaliza_ebq_link;
/

