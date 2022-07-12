CREATE OR REPLACE TRIGGER imp_trg_altera_adi_dcl
BEFORE UPDATE
OF tp_classificacao
 , class_fiscal_id
 , invoice_lin_id
 , regtrib_ii_id
 , regtrib_ipi_id
 , rd_id
 , licenca_id
 , ausencia_fabric
 , fabric_id
 , fabric_site_id
 , pais_origem_id
 , item_id
 , naladi_sh_id
 , naladi_ncca_id
 , ex_ncm_id
 , ex_nbm_id
 , ex_naladi_id
 , ex_ipi_id
 , ex_prac_id
 , ex_antd_id
 , da_lin_id
 , vida_util
 , fundamento_legal_id
 , ato_legal_id
 , orgao_emissor_id
 , nr_ato_legal
 , ano_ato_legal
 , regtrib_icms_id
 , aliq_icms
 , aliq_icms_red
 , perc_red_icms
 , aliq_icms_fecp
 , fundamento_legal_icms_id
 , regtrib_pis_cofins_id
 , flag_reducao_base_pis_cofins
 , flegal_reducao_pis_cofins_id
 , perc_reducao_base_pis_cofins
 , aliq_pis
 , aliq_pis_reduzida
 , aliq_cofins
 , aliq_cofins_reduzida
 , fundamento_legal_pis_cofins_id
 , regime_especial_icms
 , aliq_pis_especifica
 , aliq_cofins_especifica
 , un_medida_aliq_especifica_pc
 , acordo_aladi_id
 , aliq_antid
 , aliq_antid_especifica
 , um_aliq_especifica_antid_id
 , somatoria_quantidade
 , cert_origem_mercosul_id
 , ato_legal_ncm_id
 , orgao_emissor_ncm_id
 , nr_ato_legal_ncm
 , ano_ato_legal_ncm
 , ato_legal_nbm_id
 , orgao_emissor_nbm_id
 , nr_ato_legal_nbm
 , ano_ato_legal_nbm
 , ato_legal_naladi_id
 , orgao_emissor_naladi_id
 , nr_ato_legal_naladi
 , ano_ato_legal_naladi
 , ato_legal_acordo_id
 , orgao_emissor_acordo_id
 , nr_ato_legal_acordo
 , ano_ato_legal_acordo
 , pro_emprego
 , pro_empr_aliq_base
 , pro_empr_aliq_antecip
 , beneficio_pr
 , pr_aliq_base
 , pr_perc_diferido
 , pr_perc_vr_devido
 , pr_perc_minimo_base
 , pr_perc_minimo_suspenso
 , beneficio_sp
 , beneficio_mercante_id
 , beneficio_suspensao
 , perc_beneficio_suspensao
ON imp_declaracoes_lin
FOR EACH ROW
DECLARE
-- Quando alteramos campos da imp_declaracoes_lin, esta trigger (IMP_TRG_ALTERA_ADI_DCL) é disparada gerando novas adicoes.
-- No entanto, isso NAO pode acontecer quando a alteração parte da própria trigger de adição (imp_trg_atualiza_dcl_lin_adi).
-- A geração de uma adicao, só pode ocorrer quando o usuário alterar dados nas linhas da declaracao manualmente.
-- Portanto, criamos o campo flag_alterar na tabela de linhas de declaração para controlar o disparo desta trigger
-- IMP_TRG_ALTERA_ADI_DCL. Esta trigger so vai ser disparada quando o flag_alterar for nulo, significando que o usuário
-- é que esta alterando o registro, pois, quando o flag_alterar for igual a "N", significa que esta alteração partiu
-- da trigger imp_trg_atualiza_dcl_lin_adi.
-- Andre 31.01.2003

  vn_tp_declaracao_id  NUMBER      := null;
  vc_dsi               VARCHAR2(1) := null;

  CURSOR cur_declaracao IS
    SELECT tp_declaracao_id, nvl(dsi,'N')
      FROM imp_declaracoes
     WHERE declaracao_id = :new.declaracao_id;

  -- $Date: segunda-feira, 8 de setembro de 2014 15:55:18           $
  -- $Revision: 1.21       $

  vn_retificacao_ivc  NUMBER;

BEGIN
  IF (:new.flag_alterar is NULL) THEN /* vide observação no header da trigger */

    /* Não executar quando a alteração da classificação ou unidade de medida estiver ocorrendo via retificação de invoice */
    SELECT Count(1)
      INTO vn_retificacao_ivc
      FROM imp_ivc_retificacao_campo_def  ircd
         , imp_ivc_retificacao_campo_hist irch
     WHERE irch.campo_id      = ircd.campo_id
       AND irch.acao          = 'UPDATE'
       AND ircd.tabela_ecomex = 'imp_invoices_lin'
       AND ircd.campo_ecomex  IN('class_fiscal_id', 'tp_classificacao', 'un_medida_id')
       AND irch.pk_id         = :new.invoice_lin_id
       AND irch.processado    = 'N';

    IF(vn_retificacao_ivc = 0)THEN

      OPEN  cur_declaracao;
      FETCH cur_declaracao INTO vn_tp_declaracao_id, vc_dsi;
      CLOSE cur_declaracao;

      IF (vc_dsi = 'N') THEN
        :new.declaracao_adi_id := imp_fnc_gera_adicao_dcl
                                  (
                                   :new.declaracao_id
                                 , vn_tp_declaracao_id
                                 , :new.declaracao_adi_id
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
                                 , :new.pro_emprego           -- pc_pro_emprego
                                 , :new.pro_empr_aliq_base    -- pn_aliq_base_pro_emprego
                                 , :new.pro_empr_aliq_antecip -- pn_aliq_antecip_pro_emprego
                                 , :new.beneficio_pr
                                 , :new.pr_aliq_base
                                 , :new.pr_perc_diferido
                                 , :new.ins_estadual_id
                                 , :new.pr_perc_vr_devido
                                 , :new.pr_perc_minimo_base
                                 , :new.pr_perc_minimo_suspenso
                                 , :new.beneficio_sp
                                 , :new.beneficio_mercante_id
                                 , :new.vlr_base_a_recolher
                                 , :new.beneficio_suspensao
                                 , :new.perc_beneficio_suspensao
                                 );

        DELETE FROM imp_declaracoes_adi
        WHERE nvl (qtde_linhas,0) <= 0
          AND declaracao_adi_id = :old.declaracao_adi_id;
      END IF;

    END IF;

  ELSE
    :new.flag_alterar := null; /* vide observação no header da trigger */
  END IF;
END;
/

