PROMPT CREATE OR REPLACE TRIGGER imp_trg_inclui_adi_dcl
CREATE OR REPLACE TRIGGER imp_trg_inclui_adi_dcl
BEFORE INSERT
ON imp_declaracoes_lin
FOR EACH ROW
DECLARE
  vn_tp_declaracao_id     NUMBER      := null;
  vc_dsi                  VARCHAR2(1) := null;
  vc_retif_flag_exclusao  VARCHAR2(1) := null;
  vn_empresa_id           imp_declaracoes.empresa_id%TYPE;
  vn_benef_id             NUMBER;

  CURSOR cur_declaracao IS
    SELECT tp_declaracao_id
         , nvl (dsi, 'N')
         , nvl (retif_flag_exclusao, 'N')
         , empresa_id
      FROM imp_declaracoes
     WHERE declaracao_id = :new.declaracao_id;

  CURSOR cur_declaracao_adi IS --chl
    SELECT declaracao_adi_id
      FROM imp_licencas_lin
     WHERE licenca_id = :new.licenca_id
       AND declaracao_adi_id IS NOT NULL;

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


  vb_achou BOOLEAN := FALSE;
  vn_temp  NUMBER;
BEGIN
  OPEN  cur_declaracao;
  FETCH cur_declaracao INTO vn_tp_declaracao_id, vc_dsi, vc_retif_flag_exclusao, vn_empresa_id;
  CLOSE cur_declaracao;

  IF (vc_dsi = 'N') AND (vc_retif_flag_exclusao = 'N') THEN
    /* Se o campo declaracao_adi_id estiver preenchido em uma das linhas da licenca, devemos considera-lo para inserção na DI;
    Trata-se de um caso especifico de LI Sub e DI com retificação. */
    OPEN cur_declaracao_adi;
    FETCH cur_declaracao_adi INTO vn_temp;
    vb_achou := cur_declaracao_adi%FOUND;
    CLOSE cur_declaracao_adi;

    IF vb_achou THEN
      :new.declaracao_adi_id := vn_temp;
    ELSE

      -- Quando aplicada excecao fiscal de II, carregar o Tipo de acordo de forma automática para a Adicao
      OPEN cur_exfiscal_ii(:new.excecao_ii_id);
      FETCH cur_exfiscal_ii INTO vc_aliq_adval_igual_red;
      CLOSE cur_exfiscal_ii;

      vr_exfiscal_antd := NULL;
      IF :new.excecao_antid_id IS NOT NULL THEN
        OPEN cur_exfiscal_antd(:new.excecao_antid_id);
        FETCH cur_exfiscal_antd INTO vr_exfiscal_antd;
        CLOSE cur_exfiscal_antd;
      END IF;
    
      :new.declaracao_adi_id := imp_fnc_gera_adicao_dcl
                                (
                                :new.declaracao_id
                              , vn_tp_declaracao_id
                              , null
                              , :new.tp_classificacao
                              , :new.class_fiscal_id
                              , :new.invoice_lin_id
                              , :new.regtrib_ii_id
                              , :new.regtrib_ipi_id
                              , :new.aliq_ipi_red
                              , :new.perc_red_ii
                              , :new.aliq_ii_red
                              , :new.rd_id
                              , :new.licenca_id
                              , :new.ausencia_fabric
                              , :new.fabric_id
                              , :new.fabric_site_id
                              , :new.pais_origem_id
                              , :new.item_id
                              , :new.naladi_sh_id
                              , :new.naladi_ncca_id
                              , :new.ex_ncm_id
                              , :new.ex_nbm_id
                              , :new.ex_naladi_id
                              , :new.ex_ipi_id
                              , :new.ex_prac_id
                              , :new.ex_antd_id
                              , :new.da_lin_id
                              , :new.vida_util
                              , 'N'
                              , :new.creation_date
                              , :new.created_by
                              , :new.last_update_date
                              , :new.last_updated_by
                              , :new.fundamento_legal_id
                              , :new.ato_legal_id
                              , :new.orgao_emissor_id
                              , :new.nr_ato_legal
                              , :new.ano_ato_legal
                              , :new.regtrib_icms_id
                              , :new.aliq_icms
                              , :new.aliq_icms_red
                              , :new.perc_red_icms
                              , :new.aliq_icms_fecp
                              , :new.fundamento_legal_icms_id
                              , :new.regtrib_pis_cofins_id
                              , :new.aliq_pis
                              , :new.aliq_cofins
                              , :new.perc_reducao_base_pis_cofins
                              , :new.fundamento_legal_pis_cofins_id
                              , :new.flag_reducao_base_pis_cofins
                              , :new.flegal_reducao_pis_cofins_id
                              , :new.aliq_pis_reduzida
                              , :new.aliq_cofins_reduzida
                              , :new.regime_especial_icms
                              , :new.aliq_pis_especifica
                              , :new.aliq_cofins_especifica
                              , :new.qtde_um_aliq_especifica_pc
                              , :new.un_medida_aliq_especifica_pc
                              , :new.acordo_aladi_id
                              , :new.cert_origem_mercosul_id
                              , :new.aliq_antid
                              , :new.aliq_antid_especifica
                              , :new.um_aliq_especifica_antid_id
                              , :new.somatoria_quantidade
                              , :new.ato_legal_ncm_id
                              , :new.orgao_emissor_ncm_id
                              , :new.nr_ato_legal_ncm
                              , :new.ano_ato_legal_ncm
                              , :new.ato_legal_nbm_id
                              , :new.orgao_emissor_nbm_id
                              , :new.nr_ato_legal_nbm
                              , :new.ano_ato_legal_nbm
                              , :new.ato_legal_naladi_id
                              , :new.orgao_emissor_naladi_id
                              , :new.nr_ato_legal_naladi
                              , :new.ano_ato_legal_naladi
                              , :new.ato_legal_acordo_id
                              , :new.orgao_emissor_acordo_id
                              , :new.nr_ato_legal_acordo
                              , :new.ano_ato_legal_acordo
                              , :new.aliq_mva
                              , :new.pro_emprego
                              , :new.pro_empr_aliq_base
                              , :new.pro_empr_aliq_antecip
                              , :new.beneficio_pr
                              , :new.pr_aliq_base
                              , :new.pr_perc_diferido
                              , :new.ins_estadual_id
                              , :new.pr_perc_vr_devido
                              , :new.pr_perc_minimo_base
                              , :new.pr_perc_minimo_suspenso
                              , :new.beneficio_sp
                              , :new.beneficio_mercante_id
                              , :new.vlr_frete
                              , :new.beneficio_suspensao
                              , :new.perc_beneficio_suspensao
                              , vc_aliq_adval_igual_red
                              , vr_exfiscal_antd.ato_legal_id    
                              , vr_exfiscal_antd.orgao_emissor_id
                              , vr_exfiscal_antd.nr_ato_legal    
                              , vr_exfiscal_antd.ano_ato_legal    
                              );
    END IF;

    imp_prc_busca_licenca(:new.fundamento_legal_id,:new.licenca_id);
  END IF;
END;
/