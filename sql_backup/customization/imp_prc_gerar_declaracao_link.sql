CREATE OR REPLACE PROCEDURE imp_prc_gerar_declaracao_link (
                     pn_empresa_id              IN     NUMBER
                   , pn_embarque_id             IN     NUMBER
                   , pc_flag_dsi                IN     VARCHAR2
                   , pn_tp_declaracao_id        IN     NUMBER
                   , pc_referencia              IN     VARCHAR2
                   , pn_user_id                 IN     NUMBER
                   , pn_declaracao_id           IN OUT NUMBER
                   , pn_invoice_id              IN     NUMBER
                   , pc_gera_li_drawback        IN     VARCHAR2
                   , pc_quebra_qtde_drawback    IN     VARCHAR2
                   , pn_evento_id                  OUT cmx_eventos.evento_id%TYPE
                   , pb_li_gerada                  OUT BOOLEAN
                   , pn_da_id                   IN     NUMBER  --- somente preenchido quando tipo di=14 (Nac.entreposto aduaneiro) ou 13 (nac adm temp)
                   , pc_fins_de_exportacao      IN     VARCHAR2 DEFAULT 'N'
                   , pc_fins_cambiais           IN     VARCHAR2 DEFAULT 'N'
                   , pc_nac_sem_vinc_admissao   IN     VARCHAR2 DEFAULT 'N'
                  ) AS

  -- $Date:                                                         $
  -- $Revision:            $

  CURSOR cur_dcl_doc_desp(pn_tp_documento_id NUMBER) IS
    SELECT   ivc.invoice_num              invoice_num
           , Nvl (ivc.tp_documento_id, cmx_pkg_tabelas.tabela_id('110','01'))          tp_documento_id
           , ivc.invoice_id               invoice_id
           , ebq.conhec_id                conhec_id
           , conhec.house                 house
           , conhec.master                master
      FROM   imp_invoices         ivc
           , imp_embarques        ebq
           , imp_conhecimentos    conhec
     WHERE ivc.embarque_id = ebq.embarque_id
       AND ebq.conhec_id   = conhec.conhec_id   (+)
       AND ebq.embarque_id = pn_embarque_id
       AND (Nvl (ivc.tp_documento_id, cmx_pkg_tabelas.tabela_id('110','01')) = pn_tp_documento_id OR pn_tp_documento_id IS NULL)
    UNION ALL
    SELECT inv.invoice_num
         , Nvl(inv.tp_documento_id, cmx_pkg_tabelas.tabela_id('110','01'))          tp_documento_id
         , inv.invoice_id
         , NULL conhec_id
         , NULL house
         , NULL master
      FROM imp_po_remessa re
         , imp_invoices inv
     WHERE re.embarque_id   = pn_embarque_id
       AND re.po_remessa_id = inv.remessa_id
       AND re.nr_remessa    = '1'
       AND (Nvl (inv.tp_documento_id, cmx_pkg_tabelas.tabela_id('110','01')) = pn_tp_documento_id OR pn_tp_documento_id IS NULL)
     ORDER BY invoice_num;

  CURSOR cur_verif_tp_via(pn_conhec_id imp_conhecimentos.conhec_id%TYPE) IS
    SELECT via_transporte_id
      FROM imp_conhecimentos
     WHERE conhec_id = pn_conhec_id;

  CURSOR cur_dados_embarque IS
    SELECT Nvl(cmx_pkg_tabelas.auxiliar (ebq.tp_embarque_id, 18),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')    tp_embarque
         , Nvl(cmx_pkg_tabelas.auxiliar (ebq.tp_embarque_id, 1),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')     tp_fixo
         , cmx_pkg_tabelas.codigo(ebq.tp_embarque_id)                                                    codigo_tp_embarque
      FROM imp_embarques     ebq
     WHERE ebq.embarque_id = pn_embarque_id;

  vn_via_transporte_id  imp_conhecimentos.via_transporte_id%TYPE;

  CURSOR cur_inv_rem IS
    SELECT inv.tp_documento_id
         , inv.invoice_num
         , inv.invoice_id
      FROM imp_po_remessa re
         , imp_invoices inv
     WHERE re.embarque_id   = pn_embarque_id
       AND re.po_remessa_id = inv.remessa_id
       AND re.nr_remessa    = '1';

  CURSOR cur_urfe_di_unica IS
    SELECT con.urfe_id
      FROM imp_po_remessa re
         , imp_conhecimentos con
     WHERE re.embarque_id   = pn_embarque_id
       AND con.conhec_id    = re.conhec_id
       AND re.nr_remessa    = '1';

  CURSOR cur_con_rem IS
    SELECT con.house
         , con.master
         , re.conhec_id
      FROM imp_po_remessa re
         , imp_conhecimentos con
     WHERE re.embarque_id = pn_embarque_id
       AND re.conhec_id   = con.conhec_id(+)
       AND re.nr_remessa = 1;

  CURSOR cur_doc_cert_orig IS
    SELECT DISTINCT cert_origem_numero
      FROM imp_licencas_lin         lic
         , imp_cert_origem_mercosul cert
         , imp_invoices             ivc
     WHERE lic.cert_origem_mercosul_id = cert.cert_origem_mercosul_id
       AND lic.invoice_id              = ivc.invoice_id
       AND ivc.embarque_id             = pn_embarque_id
       AND Trunc (cert.data_expiracao) >= Trunc (SYSDATE);

  CURSOR cur_doc_cert_orig_sem_li (pn_declaracao_id       NUMBER) IS
    SELECT DISTINCT c.cert_origem_numero
      FROM imp_cert_origem_mercosul     c
         , imp_cert_origem_mercosul_lin clin
         , imp_invoices_lin             iil
         , imp_invoices                 ii
     WHERE c.cert_origem_mercosul_id = clin.cert_origem_mercosul_id
       AND clin.invoice_lin_id       = iil.invoice_lin_id
       AND iil.invoice_id            = ii.invoice_id
       AND ii.embarque_id            = pn_embarque_id
       AND Trunc (c.data_expiracao)  >= Trunc (SYSDATE)
       AND NOT EXISTS (SELECT 1
                         FROM imp_dcl_dcto_instr
                        WHERE declaracao_id    = pn_declaracao_id
                          AND tp_documento_id  = cmx_pkg_tabelas.tabela_id ('110','02')
                          AND nr_documento     = c.cert_origem_numero);


  CURSOR cur_declaracoes_header_licenca IS
    SELECT urfe_id
         , urfd_id
      FROM imp_licencas
     WHERE embarque_id =  pn_embarque_id
       AND nr_registro IS NOT NULL
  ORDER BY urfd_id;

  CURSOR cur_add_info_nacionalizacao (pn_decl_adm imp_declaracoes.declaracao_id%TYPE) IS
    SELECT id.urfd_id
         , id.urfe_id
         , id.rec_alfand_id
         , id.setor_armazem_id
         , idar.cd_armazem
         , id.tp_manifesto
         , id.nr_manifesto
      FROM imp_declaracoes id
         , imp_dcl_armazem idar
     WHERE idar.declaracao_id = id.declaracao_id
       AND id.declaracao_id = pn_decl_adm;

  CURSOR cur_declaracoes_header IS
    SELECT ic.urfe_id
         , iep.banco_agencia_id
         , iep.nr_conta_id
         , ic.moeda_id
         , ic.valor_total_m
         , ie.moeda_seguro_id
         , ie.vrt_sg_m
         , ic.via_transporte_id
         , ic.nr_manifesto
         , ic.tp_manifesto_id
      FROM imp_embarques       ie
         , imp_conhecimentos   ic
         , imp_empresas_param  iep
     WHERE ie.embarque_id = pn_embarque_id
       AND ie.conhec_id   = ic.conhec_id(+)
       AND iep.empresa_id = ie.empresa_id;

  CURSOR cur_perc_seguro (pn_via_transp_id imp_conhecimentos.via_transporte_id%TYPE) IS
    SELECT decode (cta.codigo, '04', iep.perc_seguro_aereo      ,
                               '01', iep.perc_seguro_maritimo   ,
                               '06', iep.perc_seguro_ferroviario,
                               '07', iep.perc_seguro_rodoviario )
      FROM imp_empresas_param  iep
         , cmx_tabelas         cta
     WHERE iep.empresa_id = pn_empresa_id
       AND cta.tabela_id  = pn_via_transp_id;

  /* Quando o parametro pn_embarque_id esta preenchido e o parametro pn_invoice_id esta nulo,
     iremos cadastrar uma nova Declaracao, portanto, utilizaremos um novo ID
  */
  CURSOR cur_declaracao_id IS
    SELECT imp_declaracoes_sq1.nextval
      FROM dual;

  /* Devo trazer todas as invoices de um embarque ou apenas uma invoice especificamente */
  CURSOR cur_invoices IS
    SELECT invoice_id
         , invoice_num
         , export_id
         , export_site_id
         , moeda_id
         , incoterm_id
         , local_cvenda_id
         , termo_id
      FROM imp_invoices
     WHERE embarque_id = pn_embarque_id
       AND (invoice_id = pn_invoice_id OR pn_invoice_id IS null)
 UNION ALL
    SELECT to_number (null) invoice_id
         , to_char   (null) invoice_num
         , to_number (null) export_id
         , to_number (null) export_site_id
         , to_number (null) moeda_id
         , to_number (null) incoterm_id
         , to_number (null) local_cvenda_id
         , To_Number (NULL) termo_id
      FROM imp_embarques emb
         , cmx_tabelas   tp_emb
      WHERE emb.embarque_id    = pn_embarque_id
        AND emb.tp_embarque_id = tp_emb.tabela_id
        AND tp_emb.tipo        = '901'
        AND tp_emb.auxiliar1   = 'NAC_RCF';

  CURSOR cur_item_nac (pn_invoice_lin_id NUMBER) IS
    SELECT nac.declaracao_lin_id
      FROM imp_inv_lin_da_nac nac
     WHERE nac.invoice_lin_id = pn_invoice_lin_id;

  CURSOR cur_declaracao_lin (pn_inv_id imp_invoices.invoice_id%TYPE) IS
    SELECT iil.invoice_id
         , iil.invoice_lin_id
         , iil.item_id
         , iil.un_medida_id
         , (nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada), 0) - nvl (iil.qtde_utilizada, 0)) saldo
         , iil.preco_unitario_m
         , iil.vmlc_li_m / imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)   vmlc_li_m_unitario
         , iil.class_fiscal_id
         , iil.ausencia_fabric
         , iil.fabric_id
         , iil.fabric_site_id
         , iil.fabric_part_number
         , iil.pais_origem_id
         , iil.pesoliq_tot
         , iil.pesoliq_unit
         , iil.utilizacao_id
         , iil.material_usado
         , iil.po_linha_id
         , cutl.cfop_id
         , imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) qtde
         , ii.empresa_id
         , ii.organizacao_id
         , to_number (null) da_id
         , to_number (null) da_lin_id
         , iil.nr_linha
         , null             situacao_estoque
         , to_number (null) decl_nr_registro
         , to_number (null) decl_adicao_num
         , to_number (null) decl_nr_linha
         , to_number (null) decl_utilizacao_id
         , null             ipi_integral
         , ii.termo_id      termo_id
         , iil.da           da
         , iil.adicao       adicao
         , iil.nr_lin_item  nr_lin_item
         , iil.peso_bruto_nac peso_bruto_nac --110918
      FROM imp_invoices_lin iil
         , imp_invoices     ii
         , cmx_tabelas      cta
         , cmx_utilizacoes  cutl
         , imp_embarques            ie
     WHERE pn_inv_id             IS NOT null
       AND iil.invoice_id         = pn_inv_id
       AND ii.embarque_id         = ie.embarque_id
       AND (pn_tp_declaracao_id   <> cmx_pkg_tabelas.tabela_id ('101', '13')
           OR (pn_tp_declaracao_id  = cmx_pkg_tabelas.tabela_id ('101', '13') AND Nvl(pc_nac_sem_vinc_admissao,'N') = 'S'
               AND Nvl(cmx_pkg_tabelas.auxiliar (ie.tp_embarque_id, 9),'*') <> 'REPETRO' )
           )
       AND (nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada),0) - nvl (iil.qtde_utilizada,0)) > 0
       AND iil.tp_linha_id        = cta.tabela_id
       AND ii.invoice_id          = iil.invoice_id
       AND cta.auxiliar1          = 'M'
       AND cutl.utilizacao_id (+) = iil.utilizacao_id
    UNION ALL
    SELECT iil.invoice_id
         , iil.invoice_lin_id
         , iil.item_id
         , iil.un_medida_id
         , destino.qtde                saldo
         , iil.preco_unitario_m
         , to_number (null)           vmlc_li_m_unitario
         , iil.class_fiscal_id
         , iil.ausencia_fabric
         , iil.fabric_id
         , iil.fabric_site_id
         , iil.fabric_part_number
         , iil.pais_origem_id
         , iil.pesoliq_tot
         , iil.pesoliq_unit
         , iil.utilizacao_id
         , iil.material_usado
         , iil.po_linha_id
         , cutl.cfop_id
         , destino.qtde
         , ii.empresa_id
         , ii.organizacao_id
         , to_number (null) da_id
         , to_number (null) da_lin_id
         , iil.nr_linha
         , null             situacao_estoque
         , to_number (null) decl_nr_registro
         , to_number (null) decl_adicao_num
         , to_number (null) decl_nr_linha
         , to_number (null) decl_utilizacao_id
         , null             ipi_integral
         , ii.termo_id      termo_id
         , iil.da           da
         , iil.adicao       adicao
         , iil.nr_lin_item  nr_lin_item
         , iil.peso_bruto_nac peso_bruto_nac --110918
      FROM imp_invoices_lin         iil
         , imp_invoices             ii
         , cmx_tabelas              cta
         , cmx_utilizacoes          cutl
         , imp_adm_temp_destinacoes destino
     WHERE pn_inv_id             IS NOT null
       AND iil.invoice_id         = pn_inv_id
       AND (pn_tp_declaracao_id    = cmx_pkg_tabelas.tabela_id ('101', '13') AND Nvl(pc_nac_sem_vinc_admissao,'N') = 'N')
       AND (nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada),0) - nvl (iil.qtde_utilizada,0)) > 0
       AND iil.tp_linha_id        = cta.tabela_id
       AND cta.auxiliar1          = 'M'
       AND ii.invoice_id          = iil.invoice_id
       AND cutl.utilizacao_id (+) = iil.utilizacao_id
       AND iil.invoice_lin_id     = destino.invoice_lin_id_nac
    UNION ALL
    SELECT iil.invoice_id
         , iil.invoice_lin_id
         , iil.item_id
         , iil.un_medida_id
         , (nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada), 0) - nvl (iil.qtde_utilizada, 0)) saldo
         , iil.preco_unitario_m
         , to_number (null)           vmlc_li_m_unitario
         , iil.class_fiscal_id
         , iil.ausencia_fabric
         , iil.fabric_id
         , iil.fabric_site_id
         , iil.fabric_part_number
         , iil.pais_origem_id
         , iil.pesoliq_tot
         , iil.pesoliq_unit
         , iil.utilizacao_id
         , iil.material_usado
         , iil.po_linha_id
         , cutl.cfop_id
         , imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) qtde
         , ii.empresa_id
         , ii.organizacao_id
         , to_number (null) da_id
         , to_number (null) da_lin_id
         , iil.nr_linha
         , null             situacao_estoque
         , to_number (null) decl_nr_registro
         , to_number (null) decl_adicao_num
         , to_number (null) decl_nr_linha
         , to_number (null) decl_utilizacao_id
         , null             ipi_integral
         , ii.termo_id      termo_id
         , iil.da           da
         , iil.adicao       adicao
         , iil.nr_lin_item  nr_lin_item
         , iil.peso_bruto_nac peso_bruto_nac --110918
      FROM imp_invoices_lin         iil
         , imp_invoices             ii
         , cmx_tabelas              cta
         , cmx_utilizacoes          cutl
         , imp_embarques            ie
     WHERE pn_inv_id             IS NOT null
       AND iil.invoice_id         = pn_inv_id
       AND pn_tp_declaracao_id    = cmx_pkg_tabelas.tabela_id ('101', '13')
       AND (nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada),0) - nvl (iil.qtde_utilizada,0)) > 0
       AND iil.tp_linha_id        = cta.tabela_id
       AND cta.auxiliar1          = 'M'
       AND ii.invoice_id          = iil.invoice_id
       AND cutl.utilizacao_id (+) = iil.utilizacao_id
       AND ie.embarque_id         = ii.embarque_id
       AND cmx_pkg_tabelas.auxiliar (ie.tp_embarque_id, 9) = 'REPETRO'
    UNION ALL
    SELECT /*+ LEADING (rcons saida) USE_NL (rcons entr nfl util_nac util imposto tp_mov) */
           to_number (null)                                         invoice_id
         , to_number (null)                                         invoice_lin_id
         , decl_lin.item_id
         , decl_lin.un_medida_id
         , sum (rcons.quantidade)                                   saldo
         , decl_lin.preco_unitario_m
         , to_number (null)                                         vmlc_li_m_unitario
         , cmx_pkg_itens.ncm (decl_lin.item_id)                     class_fiscal_id
         , decl_lin.ausencia_fabric
         , decl_lin.fabric_id
         , decl_lin.fabric_site_id
         , decl_lin.fabric_part_number
         , decl_lin.pais_origem_id
         , decl_lin.pesoliq_tot
         , decl_lin.pesoliq_unit
         , util_nac.utilizacao_id                                   utilizacao_id
         , null                                                     material_usado -- vem da linha da invoice e agora deve vir da ADICAO da DA
         , to_number (null)                                         po_linha_id
         , decode (
              rcons.situacao_estoque
            , 'E'
            , nvl (util.cfop_id, cutl.cfop_id)
            , cutl.cfop_id
           )                                                         cfop_id
         , to_number (null)                                         qtde -- verificar como é utilizado esse campo
         , decl.empresa_id
         , ebq.organizacao_id
         , decl_lin.declaracao_id                                   da_id
         , decl_lin.declaracao_lin_id                               da_lin_id
         , to_number (null)                                         nr_linha
         , rcons.situacao_estoque
         , nfl.decl_nr_registro
         , nfl.decl_adicao_num
         , nfl.decl_nr_linha
         , decl_lin.utilizacao_id                                   decl_utilizacao_id
         , nvl (imposto.ipi, 'N')                                   ipi_integral
         , NULL termo_id
         , NULL            da
         , NULL        adicao
         , NULL   nr_lin_item
         , NULL   peso_bruto_nac
      FROM rcf_movimentos             saida
         , rcf_movimentos             entr
         , rcf_consumos               rcons
         , rcf_nota_fiscal_linhas     nfl
         , imp_declaracoes_lin        decl_lin
         , imp_declaracoes_adi        decl_adi
         , imp_declaracoes            decl
         , imp_embarques              ebq
         , cmx_utilizacoes            cutl
         , cmx_utilizacoes            util
         , rcf_setup_nacionalizacao   util_nac
         , rcf_ncms_imposto_integral  imposto
         , rcf_notas_fiscais          nfs
         , rcf_clientes_nacionais     cli
         , cmx_tabelas                tp_mov
         , cmx_empresas               empr_entrada
         , cmx_empresas               empr_saida
     WHERE pn_inv_id                          IS NULL
       AND entr.empresa_id                    =  empr_entrada.empresa_id
       AND saida.empresa_id                   =  empr_saida.empresa_id
       AND saida.tipo_movimento_id            =  util_nac.tipo_movimento_saida_def_id
       AND rcons.situacao_estoque             =  util_nac.situacao_estoque
       AND util.utilizacao_id                 =  util_nac.utilizacao_id
       AND (   util_nac.organizacao_inventario_id IS null
            OR entr.organizacao_id                =  util_nac.organizacao_inventario_id
           )
       AND (   (    util_nac.dest_agricola_rodoviaria = 'S'
                AND NOT EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_entrada.codigo = t.codigo AND t.tipo = '458')
                AND EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_saida.codigo = t.codigo AND t.tipo = '458')
               )
            OR (    util_nac.dest_agricola_rodoviaria  = 'N'
                AND EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_saida.codigo = t.codigo AND t.tipo = '458')
                AND EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_entrada.codigo = t.codigo AND t.tipo = '458')
               )
            OR (    util_nac.dest_agricola_rodoviaria  = 'N'
                AND NOT EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_saida.codigo = t.codigo AND t.tipo = '458')
                AND NOT EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_entrada.codigo = t.codigo AND t.tipo = '458')
               )
            OR (    util_nac.dest_agricola_rodoviaria  = 'N'
                AND EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_entrada.codigo = t.codigo AND t.tipo = '458')
                AND NOT EXISTS (SELECT null FROM cmx_tabelas t WHERE empr_saida.codigo = t.codigo AND t.tipo = '458')
              )
           )
-- Alterado por Ramon - 18/05/2018 --------------
       AND util_nac.empresa_id = entr.empresa_id
-------------------------------------------------
       AND cutl.utilizacao_id (+)          =  decl_lin.utilizacao_id
       AND ebq.embarque_id                 =  decl.embarque_id
       AND decl.nr_registro_scx            =  nfl.decl_nr_registro
       AND decl.declaracao_id              =  decl_adi.declaracao_id
       AND decl_adi.adicao_num             =  nfl.decl_adicao_num
       AND decl_adi.declaracao_adi_id      =  decl_lin.declaracao_adi_id
       AND decl_lin.linha_num_scx          =  nfl.decl_nr_linha
       AND nfl.nota_fiscal_id              =  entr.nota_fiscal_id
       AND nfl.nota_fiscal_nr_linha        =  entr.nota_fiscal_nr_linha
       AND rcons.estoque_movimento_id      =  entr.movimento_id
       AND rcons.embarque_id               =  pn_embarque_id
       AND saida.movimento_id              =  rcons.saida_definitiva_movimento_id
       AND saida.tipo_movimento_id         =  tp_mov.tabela_id
       AND tp_mov.tipo                     = '411'
       AND saida.nota_fiscal_id            =  nfs.nota_fiscal_id  (+)
      AND nfs.destinatario_cliente_site_id =  cli.cliente_site_id (+)
       AND (    tp_mov.codigo             <> 'SVN'
            OR (     tp_mov.codigo         = 'SVN'
                AND (
                        (    nvl (cli.com_exportadora_instituida, '*')   = 'N'
                         AND util_nac.com_exportadora_nao_instituida     = 'S'
                        )
                     OR (    nvl (cli.com_exportadora_instituida, '*')  <> 'N'
                         AND util_nac.com_exportadora_nao_instituida     = 'N'
                        )
                    )
               )
           )
       AND saida.ncm_codigo                = imposto.ncm_codigo (+)
       AND rcons.nr_referencia            IS null
     GROUP BY decl_lin.item_id
            , decl_lin.un_medida_id
            , decl_lin.preco_unitario_m
            , decl_lin.class_fiscal_id
            , decl_lin.ausencia_fabric
            , decl_lin.fabric_id
            , decl_lin.fabric_site_id
            , decl_lin.fabric_part_number
            , decl_lin.pais_origem_id
            , decl_lin.pesoliq_tot
            , decl_lin.pesoliq_unit
            , util_nac.utilizacao_id
            , decode (
                 rcons.situacao_estoque
               , 'E'
               , nvl (util.cfop_id, cutl.cfop_id)
               , cutl.cfop_id
              )
           , cmx_pkg_itens.ncm (decl_lin.item_id)
           , decl.empresa_id
           , ebq.organizacao_id
           , decl_lin.declaracao_id
           , decl_lin.declaracao_lin_id
           , rcons.situacao_estoque
           , nfl.decl_nr_registro
           , nfl.decl_adicao_num
           , nfl.decl_nr_linha
           , decl_lin.utilizacao_id
           , nvl (imposto.ipi, 'N')
     ORDER BY nr_linha, item_id;

  -- Cursor que pegará a data da DA para passar como parâmetro pra função imp_fnc_busca_excecao_fiscal
  CURSOR cur_busca_data_da (pn_decl_id imp_declaracoes.declaracao_id%TYPE) IS
    SELECT Trunc (dt_declaracao)
      FROM imp_declaracoes   decl
     WHERE decl.declaracao_id = pn_decl_id;

  /*
    Como só é póssivel gerar a declaracao a partir de invoices, e,
    para que uam licenca antecipada dê origem a uma declaracao deve haver
    uma invoice referenciando esta licenca, entao não precisamos nos preocupar
    em buscar o organizacao_id da imp_proformas. Pegamos ele direto na imp_invoices
  */
  CURSOR cur_declaracao_lin_com_li (pn_inv_id imp_invoices.invoice_id%TYPE) IS
    SELECT il.embarque_id
         , ill.invoice_id
         , ill.invoice_lin_id
         , il.licenca_id
         , ill.item_id
         , ill.descricao
         , ill.un_medida_id
         , ill.qtde
         , iil.preco_unitario_m
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
         , ill.licenca_lin_id
         , ill.rd_id
         , ill.da_id
         , ill.da_lin_id
         , ill.excecao_ii_id
         , ill.fundamento_legal_id
         , ill.aliq_ii_red
         , ill.perc_red_ii
         , ill.regtrib_ipi_id
         , ill.ato_legal_id
         , ill.nr_ato_legal
         , ill.orgao_emissor_id
         , ill.ano_ato_legal
         , ill.aliq_ipi_red
         , ill.excecao_ipi_id
         , ill.excecao_icms_id
         , ill.regtrib_icms_id
         , ill.aliq_icms
         , ill.aliq_icms_red
         , ill.perc_red_icms
         , ill.aliq_icms_fecp
         , ill.fundamento_legal_icms_id
         , ill.excecao_pis_cofins_id
         , ill.regtrib_pis_cofins_id
         , ill.flag_reducao_base_pis_cofins
         , ill.flegal_reducao_pis_cofins_id
         , ill.perc_reducao_base_pis_cofins
         , ill.aliq_pis
         , ill.aliq_pis_reduzida
         , ill.aliq_cofins
         , ill.aliq_cofins_reduzida
         , ill.fundamento_legal_pis_cofins_id
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
         , ill.acordo_aladi_id
         , ill.cert_origem_mercosul_id
         , cutl.cfop_id
         , il.empresa_id
         , ii.organizacao_id
         , rd.cfop_nf_importacao_id
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
         , ill.beneficio_pr_artigo
         , ill.pr_perc_vr_devido
         , ill.pr_perc_minimo_base
         , ill.pr_perc_minimo_suspenso
         , ii.termo_id
         , ill.beneficio_sp
         , ill.enquadramento_legal_ipi_id
         --, ill.aliq_cofins_recuperar
         , iil.da           da
         , iil.adicao       adicao
         , iil.nr_lin_item  nr_lin_item
         , iil.peso_bruto_nac peso_bruto_nac --110918
         , ill.beneficio_suspensao
         , ill.perc_beneficio_suspensao
         , ill.icms_motivo_desoneracao_id
      FROM imp_licencas_lin ill
         , imp_licencas     il
         , imp_invoices_lin iil
         , imp_invoices     ii
         , cmx_utilizacoes  cutl
         , drw_registro_drawback rd
     WHERE ill.invoice_id     = pn_inv_id
       AND ii.invoice_id      = pn_inv_id
       AND iil.invoice_lin_id = ill.invoice_lin_id
       AND iil.invoice_id     = ii.invoice_id
       AND ill.licenca_id     = il.licenca_id
       AND ill.rd_id          = rd.rd_id (+)
       AND il.nr_registro is not null
       AND cutl.utilizacao_id (+) = ill.utilizacao_id;

  CURSOR cur_lock_declaracoes_lin IS
    SELECT null
      FROM imp_declaracoes_lin
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_max_lin_num_di IS
    SELECT nvl(max (linha_num), 0)
      FROM imp_declaracoes_lin
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_pais_export (pn_inv_id         imp_invoices.invoice_id%TYPE
                        , pn_export_id      imp_invoices.export_id%TYPE
                        , pn_export_site_id imp_invoices.export_site_id%TYPE) IS
    SELECT pais_id
      FROM imp_entidades_sites
     WHERE entidade_id      = pn_export_id
       AND entidade_site_id = pn_export_site_id;

  CURSOR cur_icms IS
    SELECT perc_icms
         , icms_diferido
         , aliquota_fecp
         , suspende_icms_recof
         , Nvl(tratar_icms_deso_emiss_nfe, 'N') AS tratar_icms_deso_emiss_nfe
      FROM imp_empresas_param
     WHERE empresa_id = pn_empresa_id;

  CURSOR cur_aliquotas_ncm (pn_ncm_id NUMBER) IS
    SELECT aliq_pis
         , aliq_cofins
         , Nvl(aliq_nt_ipi,'N') aliq_nt_ipi
      FROM cmx_tab_ncm
     WHERE ncm_id = pn_ncm_id;

  CURSOR cur_tabelas (pn_urfe_id  NUMBER) IS
    SELECT ctr.tabela_id, cts.tabela_id, ctu.auxiliar3
      FROM cmx_tabelas ctu
         , cmx_tabelas ctr
         , cmx_tabelas cts
     WHERE ctu.tabela_id = pn_urfe_id
       AND ctr.tipo  (+) = '115'
       AND ctr.codigo(+) = ctu.auxiliar1
       AND cts.tipo  (+) = '116'
       AND cts.codigo(+) = ctu.auxiliar2;

  CURSOR cur_urfd_rec_setor_ebq IS
    SELECT urfd_id
         , rec_alfand_id
         , setor_armazem_id
      FROM imp_embarques
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_dados_logistico_ebq IS
    SELECT fundap
         , trading_site_id
         , trading_id
      FROM imp_embarques
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_armaz_ebq IS
    SELECT cd_armazem
      FROM imp_ebq_armazem
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_cfop_id_padrao IS
    SELECT cfo.tabela_id
      FROM cmx_tabelas cfo
         , cmx_tabelas tp_decl
     WHERE tp_decl.tabela_id = pn_tp_declaracao_id
       AND tp_decl.auxiliar2 = cfo.codigo
       AND cfo.tipo = '923';

  CURSOR cur_despachante IS
    SELECT despachante_id
         , despachante_site_id
      FROM imp_empresas_param
     WHERE pn_empresa_id = empresa_id;

  CURSOR cur_despachante_ebq IS
    SELECT despachante_id
         , despachante_site_id
      FROM imp_embarques
     WHERE pn_empresa_id    = empresa_id
       AND pn_embarque_id   = embarque_id;

  CURSOR cur_pais IS
    SELECT /*+ leading ( ii )
               use_nl( ii, ie )
           */
           distinct (ie.pais_id)
      FROM imp_invoices         ii
         , imp_entidades_sites  ie
     WHERE ii.export_site_id = ie.entidade_site_id
       AND ii.embarque_id = pn_embarque_id;

  CURSOR cur_itens_ext (pn_item_id NUMBER) IS
    SELECT aliq_pis_especifica
         , aliq_cofins_especifica
         , un_medida_aliq_especifica_pc
         , nvl (fator_conversao_aliq_espec_pc, 1)
      FROM cmx_itens_ext
     WHERE item_id = pn_item_id;

  CURSOR cur_verifica_itens (pn_embarque_id NUMBER, pn_invoice_id NUMBER) IS
    SELECT DISTINCT cmx_pkg_itens.codigo (ivl.item_id) item_codigo
         , cmx_pkg_itens.descricao (ivl.item_id) item_descricao
         , rie.flag_gera_da
      FROM imp_invoices_lin ivl
         , rcf_itens_ext    rie
         , imp_invoices     ii
     WHERE ivl.item_id      = rie.item_id
       AND ivl.invoice_id   = ii.invoice_id
       AND rie.flag_gera_da = 'N'
       AND ii.embarque_id   = pn_embarque_id
       AND (ii.invoice_id   = pn_invoice_id OR pn_invoice_id IS null);

  CURSOR cur_transferencia IS
    SELECT dtr_numero
         , cmx_pkg_tabelas.codigo (novo_regime_id) novo_regmie
      FROM imp_dtr
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_busca_da_invoice_lin_id (pn_da_lin_id NUMBER) IS
    SELECT invoice_lin_id
         , invoice_id
      FROM imp_declaracoes_lin
     WHERE declaracao_lin_id = pn_da_lin_id;

  CURSOR cur_busca_certificado_origem (pn_invoice_lin_id NUMBER) IS
    SELECT icom.cert_origem_mercosul_id
         , icom.acordo_aladi_id
         , icom.ex_naladi_id
         , icom.ato_legal_ex_naladi_id
         , icom.orgao_emissor_ex_naladi_id
         , icom.nr_ato_legal_ex_naladi
         , icom.ano_ato_legal_ex_naladi
      FROM imp_cert_origem_mercosul     icom
         , imp_cert_origem_mercosul_lin icoml
     WHERE pn_invoice_lin_id              = icoml.invoice_lin_id
       AND icoml.cert_origem_mercosul_id  = icom.cert_origem_mercosul_id
       AND trunc (icom.data_expiracao)   >= trunc (sysdate);

  CURSOR cur_busca_cert_origem_da (pn_invoice_lin_id NUMBER) IS
    SELECT idl.cert_origem_mercosul_id
         , idl.acordo_aladi_id
         , idl.ex_naladi_id
         , idl.ato_legal_naladi_id     ato_legal_ex_naladi_id
         , idl.orgao_emissor_naladi_id orgao_emissor_ex_naladi_id
         , idl.nr_ato_legal_naladi     nr_ato_legal_ex_naladi
         , idl.ano_ato_legal_naladi    ano_ato_legal_ex_naladi
      FROM imp_cert_origem_mercosul     icom
         , imp_cert_origem_mercosul_lin icoml
         , imp_declaracoes_lin          idl
     WHERE pn_invoice_lin_id              = icoml.invoice_lin_id
       AND idl.cert_origem_mercosul_id(+) = icoml.cert_origem_mercosul_id
       AND idl.invoice_lin_id(+)          = icoml.invoice_lin_id
       AND icom.cert_origem_mercosul_id   = icoml.cert_origem_mercosul_id;
--       AND trunc (icom.data_expiracao)   >= trunc (sysdate);

  CURSOR cur_excecao_por_tp_ebq IS
    SELECT fundamento_legal_ii_id
         , fundamento_legal_pis_cofins_id
         , busca_excecao_para_icms
      FROM imp_empresas_param_adm
     WHERE empresa_id     = pn_empresa_id
       AND tp_embarque_id = (SELECT ie.tp_embarque_id
                               FROM imp_embarques ie
                              WHERE ie.embarque_id = pn_embarque_id);

  CURSOR cur_pais_fabricante (pn_fabricante_id NUMBER, pn_fabricante_site_id NUMBER) IS
    SELECT pais_id
      FROM imp_fabricantes_sites
     WHERE fabric_id      = pn_fabricante_id
       AND fabric_site_id = pn_fabricante_site_id;

  CURSOR cur_rcr IS
      SELECT processo_numero
        FROM imp_adm_temp_rcr
      WHERE embarque_id      = pn_embarque_id
        AND processo_numero IS NOT null
  UNION ALL
  SELECT processo_numero
        FROM imp_adm_temp_rat
      WHERE embarque_id      = pn_embarque_id
        AND processo_numero IS NOT null;

  CURSOR cur_item_com_rcr (pn_invoice_lin_id NUMBER) IS
    SELECT rcr_lin.invoice_lin_id
      FROM imp_adm_temp_rcr_lin rcr_lin
         , imp_adm_temp_rcr     rcr
     WHERE rcr_lin.invoice_lin_id  = pn_invoice_lin_id
       AND rcr_lin.rcr_id          = rcr.rcr_id
       AND rcr.embarque_id         = pn_embarque_id
--       AND rcr.processo_numero    IS NOT NULL
  UNION ALL
    SELECT rat_lin.invoice_lin_id
      FROM imp_adm_temp_rat_lin rat_lin
         , imp_adm_temp_rat     rat
     WHERE rat_lin.invoice_lin_id  = pn_invoice_lin_id
       AND rat_lin.rat_id          = rat.rat_id;
--       AND rat.embarque_id         = pn_embarque_id;

  CURSOR cur_nr_declaracao_da IS
    SELECT nr_declaracao
      FROM imp_declaracoes
     WHERE declaracao_id = pn_da_id;

  CURSOR cur_adm_temp_checa_destinacoes (pn_invoice_lin_id NUMBER) IS
    SELECT destino.qtde
      FROM imp_adm_temp_destinacoes destino
         , imp_adm_temp_entradas    entrada
     WHERE entrada.declaracao_id                            = pn_da_id
       AND entrada.entrada_id                               = destino.entrada_id
       AND destino.invoice_lin_id_nac                       = pn_invoice_lin_id
       AND destino.qtde                                    <> 0
       AND cmx_pkg_tabelas.auxiliar (destino.status_id, 1)  = 'N';

  CURSOR cur_busca_dados_da_adm_temp (pn_invoice_lin_id NUMBER, pn_qtde NUMBER) IS
    SELECT entrada.declaracao_id
         , entrada.declaracao_lin_id
         , entrada.declaracao_adi_id
      FROM imp_adm_temp_entradas    entrada
         , imp_adm_temp_destinacoes destino
     WHERE destino.invoice_lin_id_nac = pn_invoice_lin_id
       AND destino.entrada_id         = entrada.entrada_id
       AND (destino.qtde = pn_qtde OR pn_qtde IS NULL);

  CURSOR cur_valida_qtde_ivc_adm_temp (pn_invoice_id NUMBER) IS
    SELECT sum (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada))
      FROM imp_invoices_lin iil
     WHERE iil.invoice_id = pn_invoice_id
       AND iil.tp_linha_id IN (SELECT tabela_id FROM cmx_tabelas WHERE tipo = '128' AND auxiliar1 = 'M');

  CURSOR cur_valida_qtde_destino_admtmp (pn_invoice_id NUMBER) IS
    SELECT sum (qtde)
      FROM imp_adm_temp_destinacoes
     WHERE status_id           = cmx_pkg_tabelas.auxiliar_tabela_id ('166', 'N', 1)
       AND invoice_lin_id_nac IN (SELECT invoice_lin_id
                                    FROM imp_invoices_lin
                                   WHERE invoice_id = pn_invoice_id);

  /* Não está verificando a condição de comercial exportadora instituída, pois do jeito que se encontra o setup de nacionalização não precisaria.*/
  CURSOR cur_consumos_nacionalizados ( pn_decl_nr_registro     rcf_nota_fiscal_linhas.decl_nr_registro%TYPE
                                     , pn_decl_adicao_num      rcf_nota_fiscal_linhas.decl_adicao_num%TYPE
                                     , pn_decl_nr_linha        rcf_nota_fiscal_linhas.decl_nr_linha%TYPE
                                     , pc_situacao_estoque     rcf_consumos.situacao_estoque%TYPE
                                     , pn_utilizacao_id        imp_declaracoes_lin.utilizacao_id%TYPE) IS
    SELECT consumo_id
      FROM rcf_consumos                   cons
         , rcf_movimentos                 saida
         , rcf_movimentos                 entrada
         , rcf_nota_fiscal_linhas         nf_lin
         , rcf_setup_nacionalizacao       nac
     WHERE cons.situacao_estoque        = nac.situacao_estoque
       AND saida.tipo_movimento_id      = nac.tipo_movimento_saida_def_id
       AND nf_lin.nota_fiscal_id        = entrada.nota_fiscal_id
       AND nf_lin.nota_fiscal_nr_linha  = entrada.nota_fiscal_nr_linha
       AND entrada.movimento_id         = cons.estoque_movimento_id
       AND saida.movimento_id           = cons.saida_definitiva_movimento_id
       AND cons.embarque_id             = pn_embarque_id
       AND cons.situacao_estoque        = pc_situacao_estoque
       AND nf_lin.decl_nr_registro      = pn_decl_nr_registro
       AND nf_lin.decl_adicao_num       = pn_decl_adicao_num
       AND nf_lin.decl_nr_linha         = pn_decl_nr_linha
       AND nac.utilizacao_id            = pn_utilizacao_id
       AND cons.nr_referencia          IS null;

  -- Só me interessa as ivc lin que têm po_lin_ext, pois essas são as únicas li-
  -- nhas de invoice que me obrigarão a desvincular tudo o que fora vinculado
  -- caso não haja saldo para elas.
  CURSOR cur_resumo_das_dis (pn_inv_id imp_invoices.invoice_id%TYPE) IS
    SELECT iil.item_id
         , iil.un_medida_id
         , Sum (Nvl (imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada), 0)) qtde
         , iil.po_linha_id
      FROM imp_invoices_lin iil
         , imp_invoices     ii
     WHERE pn_inv_id             IS NOT null
       AND iil.invoice_id         = pn_inv_id
       AND ii.invoice_id          = iil.invoice_id
     GROUP BY iil.item_id, iil.un_medida_id, iil.po_linha_id;

  CURSOR cur_po_rd_id (pn_po_linha_id  NUMBER) IS
    SELECT rd_id
      FROM imp_po_lin_ext
     WHERE po_linha_id = pn_po_linha_id;

  CURSOR cur_dados_param IS
    SELECT trunca_saldo_drw
         , trunca_saldo_drw_qtde_casas
      FROM imp_empresas_param
     WHERE empresa_id = pn_empresa_id;

  CURSOR cur_saldo_drw_item (pn_rd_id NUMBER, pn_item_id NUMBER, pc_trunca_saldo_drw VARCHAR2, pn_qtde_casas NUMBER) IS
    SELECT decode ( nvl (pc_trunca_saldo_drw, 'N')
                  , 'N'
                  , sum (  nvl (res.quantidade_prevista , 0)
                         - nvl (res.quantidade_li       , 0)
                         - (  nvl (res.quantidade_exportada , 0)
                            - nvl (res.quantidade_comprovada, 0)
                           )
                        )
                  , trunc (sum (  nvl (res.quantidade_prevista, 0)
                                - nvl (res.quantidade_li      , 0)
                                - (  nvl (res.quantidade_exportada , 0)
                                   - nvl (res.quantidade_comprovada, 0)
                                  )
                               )
                            , nvl (pn_qtde_casas, 0)
                          )
                  ) saldo_li
      FROM drw_resumo_importado_filho  res
         , drw_resumo_imp_grupo_itens  res_gp
     WHERE rd_id = pn_rd_id
       AND res.resumo_importados_id = res_gp.resumo_importados_id (+)
       AND (   (res.item_importado_id = pn_item_id)
            OR (res_gp.item_id        = pn_item_id)
           );

  CURSOR cur_verifc_nac_repetro IS
    SELECT cmx_pkg_tabelas.codigo (tipo_ebq.tabela_id)
      FROM cmx_tabelas   tipo_ebq
         , imp_embarques emb
     WHERE tipo_ebq.tabela_id = emb.tp_embarque_id
       AND tipo_ebq.auxiliar1 = 'NAC'
       AND tipo_ebq.auxiliar9 = 'REPETRO'
       AND emb.embarque_id = pn_embarque_id;

  CURSOR cur_verif_nac_adm_tmp IS
    SELECT auxiliar1
      FROM cmx_tabelas
     WHERE tabela_id = (SELECT tp_embarque_id
                          FROM imp_embarques
                         WHERE embarque_id = pn_embarque_id);

  /* Cursor para verificar se a invoice está vinculada em uma fatura de exportação troca em garantia e se está marcado como Port. 150 */
  CURSOR cur_vinculo_exp (pn_invoice_id NUMBER)IS
    SELECT NULL
      FROM exp_fatura_item_troca_garantia
     WHERE fatura_substituicao_id = pn_invoice_id
       AND portaria_150           = 'S';

  CURSOR cur_dados_ie (pn_excecao_icms_id     NUMBER) IS
    SELECT ief.ins_estadual_id
      FROM imp_excecoes_fiscais ief
         , cmx_ins_estaduais    cie
     WHERE cie.ins_estadual_id = ief.ins_estadual_id
       AND cie.empresa_id      = pn_empresa_id
       AND ief.excecao_id      = pn_excecao_icms_id;

  -- verificacao di única
    CURSOR cur_di_unica IS
      SELECT auxiliar1
        FROM cmx_tabelas
       WHERE tabela_id = (SELECT tp_embarque_id
                            FROM imp_embarques
                           WHERE embarque_id = pn_embarque_id);

    CURSOR cur_doc_chegada IS
      SELECT ic.nr_manifesto
           , ic.tp_manifesto_id
        FROM imp_conhecimentos ic,
             imp_po_remessa    re
       WHERE re.embarque_id = pn_embarque_id
         AND ic.conhec_id   = re.conhec_id
         AND re.nr_remessa  = 1;

  CURSOR cur_vlr_aliq_ii_rec ( pn_cert_origem_mercosul_id     NUMBER
                             , pn_invoice_lin_id              NUMBER) IS
    SELECT Decode ( icom.certificado
                  , 1
                  , ctn.aliq_ii_mercosul
                  , 2
                  , icom.perc_acordo)
      FROM imp_cert_origem_mercosul        icom
         , imp_cert_origem_mercosul_lin    icoml
         , imp_invoices_lin                iil
         , cmx_itens                       ci
         , cmx_tab_ncm                     ctn
     WHERE icom.cert_origem_mercosul_id  = pn_cert_origem_mercosul_id
       AND icoml.cert_origem_mercosul_id = icom.cert_origem_mercosul_id
       AND icoml.invoice_lin_id          = pn_invoice_lin_id
       AND iil.invoice_lin_id            = icoml.invoice_lin_id
       AND ci.item_id                    = iil.item_id
       AND ctn.ncm_id                    = ci.ncm_id;

  CURSOR cur_conhec_di_unica IS
    SELECT re.conhec_id
         , con.house
         , con.master
      FROM imp_po_remessa re
         , imp_conhecimentos con
     WHERE re.embarque_id   = pn_embarque_id
       AND con.conhec_id    = re.conhec_id
       AND re.nr_remessa    = '1';

  -- verificacao nacionalização
  CURSOR cur_nac IS
    SELECT cmx_pkg_tabelas.auxiliar (ie.tp_embarque_id, '1')
      FROM imp_embarques     ie
     WHERE ie.embarque_id = pn_embarque_id;

  CURSOR cur_add_info_nac IS
    SELECT id.urfd_id
         , id.urfe_id
         , id.rec_alfand_id
         , id.setor_armazem_id
         , idar.cd_armazem
         , id.tp_manifesto
         , id.nr_manifesto
      FROM imp_declaracoes id
         , imp_dcl_armazem idar
     WHERE idar.declaracao_id (+) = id.declaracao_id
       AND id.declaracao_id       = pn_da_id;

  CURSOR cur_conhec_nac IS
    SELECT   ebq.conhec_id                conhec_id
         , conhec.house                 house
         , conhec.master                master
      FROM   imp_invoices         ivc
           , imp_embarques        ebq
           , imp_conhecimentos    conhec
           , imp_declaracoes      decl
     WHERE ivc.embarque_id = ebq.embarque_id
       AND ebq.conhec_id   = conhec.conhec_id   (+)
       AND ebq.embarque_id = decl.embarque_id
       AND decl.declaracao_id = pn_da_id;

  CURSOR cur_despachante_ebq_nac IS
    SELECT ebq.despachante_id
         , ebq.despachante_site_id
      FROM imp_embarques   ebq
         , imp_declaracoes decl
     WHERE ebq.embarque_id  = decl.embarque_id
       AND pn_empresa_id    = ebq.empresa_id
       AND pn_da_id         = decl.declaracao_id;

  CURSOR cur_ex_fiscais_recof(pn_excecao_id          imp_excecoes_fiscais.excecao_id%TYPE) IS
    SELECT Nvl(recof,'N')        recof
      FROM imp_excecoes_fiscais  ief
     WHERE ief.excecao_id = pn_excecao_id;

  CURSOR cur_termo_pgto (pn_termo_id NUMBER) IS
    SELECT motivo_sem_cobertura_id
      FROM imp_termos_pgto
     WHERE termo_id = pn_termo_id;

  CURSOR cur_vlr_frete_afrmm IS
     SELECT Nvl(con.valor_prepaid_m,0)+Nvl(con.valor_collect_m,0)
                     FROM imp_conhecimentos con
                        , imp_embarques emb
                    WHERE con.conhec_id(+) = emb.conhec_id
                      AND emb.embarque_id = pn_embarque_id;


   CURSOR cur_calc_base_dev_afrmm IS
    SELECT (
            (
              ((SELECT Nvl(con.valor_prepaid_m,0)+Nvl(con.valor_collect_m,0)
                  FROM imp_conhecimentos con
                     , imp_embarques emb
                 WHERE con.conhec_id(+) = emb.conhec_id
                   AND emb.embarque_id = pn_embarque_id))+
               (SELECT Nvl(Sum(afrmm.valor_m),0)
                  FROM imp_embarques_ad_afrmm afrmm
                     , imp_embarques_ad acres
                 WHERE afrmm.embarque_ad_id = acres.embarque_ad_id
                   AND acres.embarque_id = pn_embarque_id
                   AND afrmm.tabela_id IN (SELECT tabela_id
                                                  FROM cmx_tabelas
                                                 WHERE tipo = '119'
                                                   AND codigo <> '00000000000000000000'
                                                   AND tabela_id = afrmm.tabela_id
                                               )
                 )-
                 (SELECT Nvl(Sum(afrmm.valor_m),0)
                    FROM imp_embarques_ad_afrmm afrmm
                       , imp_embarques_ad ded
                   WHERE afrmm.embarque_ad_id = ded.embarque_ad_id
                     AND ded.embarque_id = pn_embarque_id
                     AND afrmm.tabela_id IN (SELECT tabela_id
                                                    FROM cmx_tabelas
                                                   WHERE tipo = '120'
                                                     AND codigo <> '00000000000000000000'
                                                     AND tabela_id = afrmm.tabela_id
                                                 )
                 )
            )*
            (SELECT Nvl((perc_afrmm_imp/100),1)
               FROM imp_param_ce_mercante
            )
          ) frete_basico_afrmm
  FROM dual;

  CURSOR cur_calc_base_dev_usd_afrmm IS
    SELECT (
            (
              ((SELECT Nvl(con.valor_prepaid_m,0)+Nvl(con.valor_collect_m,0)
                  FROM imp_conhecimentos con
                     , imp_embarques emb
                 WHERE con.conhec_id(+) = emb.conhec_id
                   AND emb.embarque_id = pn_embarque_id))+
               (SELECT Nvl(Sum(cmx_pkg_taxas.fnc_converte(afrmm.valor_m
                                                        , afrmm.moeda_id
                                                        , con.moeda_id
                                                        , SYSDATE
                                                        , 'FISCAL'
                                                        )),0)
                  FROM imp_embarques_ad_afrmm afrmm
                     , imp_embarques_ad acres
                     , imp_embarques emb
                     , imp_conhecimentos con
                 WHERE afrmm.embarque_ad_id = acres.embarque_ad_id
                   AND acres.embarque_id = pn_embarque_id
                   AND acres.embarque_id = emb.embarque_id
                   AND emb.conhec_id     = con.conhec_id
                   AND afrmm.tabela_id IN (SELECT tabela_id
                                                  FROM cmx_tabelas
                                                 WHERE tipo = '119'
                                                   AND codigo <> '00000000000000000000'
                                                   AND tabela_id = afrmm.tabela_id
                                               )
                 )-
                 (SELECT Nvl(Sum(cmx_pkg_taxas.fnc_converte(afrmm.valor_m
                                                          , afrmm.moeda_id
                                                          , con.moeda_id
                                                          , SYSDATE
                                                          , 'FISCAL'
                                                          )),0)
                    FROM imp_embarques_ad_afrmm afrmm
                       , imp_embarques_ad ded
                       , imp_embarques emb
                       , imp_conhecimentos con
                   WHERE afrmm.embarque_ad_id = ded.embarque_ad_id
                     AND ded.embarque_id = pn_embarque_id
                     AND ded.embarque_id = emb.embarque_id
                     AND emb.conhec_id   = con.conhec_id
                     AND afrmm.tabela_id IN (SELECT tabela_id
                                                    FROM cmx_tabelas
                                                   WHERE tipo = '120'
                                                     AND codigo <> '00000000000000000000'
                                                     AND tabela_id = afrmm.tabela_id
                                                 )
                 )
            )*
            (SELECT Nvl((perc_afrmm_imp/100),1)
               FROM imp_param_ce_mercante
            )
          )  frete_basico_convertido_afrmm
      FROM dual;

  CURSOR cur_tipos_doc IS
    SELECT tabela_id
      FROM cmx_tabelas
     WHERE tipo = '110'
       AND codigo <> '00000000000000000000';

  CURSOR cur_trading IS                  --carlosh
    SELECT Nvl(trading,'N')
      FROM cmx_empresas
     WHERE empresa_id = pn_empresa_id;

  /*CarlosH 26/12/2017*/
  CURSOR cur_pais_proc IS
    SELECT pais_proc_id
      FROM imp_licencas
     WHERE embarque_id = pn_embarque_id;
  /*CarlosH 26/12/2017*/

  /*96653 - Cursor para buscar FECP na excecao fiscal*/
  CURSOR cur_fecp_excecao_fiscal(pn_excecao_fecp_id NUMBER) IS
    SELECT aliq_icms_fecp
      FROM imp_excecoes_fiscais
     WHERE excecao_id = pn_excecao_fecp_id;

  CURSOR cur_contr_rpt IS
    SELECT prazo_requerido prazo_requerido
      FROM imp_vw_adm_temp_rat
     WHERE embarque_id      = pn_embarque_id;
     --AND contrato_numero IS NOT null;

  CURSOR cur_peso_nac IS                 --110918
    SELECT Sum(Trunc(lin.peso_bruto_nac,2))
         , Sum(Trunc(lin.pesoliq_unit * lin.qtde,2))
      FROM imp_invoices_lin lin
         , imp_invoices     inv
     WHERE lin.invoice_id = inv.invoice_id
       AND inv.embarque_id = pn_embarque_id
       AND (inv.invoice_id = pn_invoice_id OR pn_invoice_id IS null);

  CURSOR cur_nac_de_terc IS             --110918
    SELECT Nvl(cmx_pkg_tabelas.auxiliar(tp_embarque_id,1),'XX') tp_embarque
      FROM imp_embarques
     WHERE embarque_id = pn_embarque_id;

  CURSOR cur_tp_conta(pn_banco_id NUMBER, pn_conta_id NUMBER) IS
    SELECT tp_conta
      FROM cmx_bancos_agencias_cta
     WHERE banco_agencia_id = pn_banco_id
       AND conta_id = pn_conta_id;

  CURSOR cur_excecao_motivo_desoneracao (pn_excecao_id NUMBER) IS
    SELECT icms_motivo_desoneracao_id
      FROM imp_excecoes_fiscais
     WHERE excecao_id = pn_excecao_id;

  CURSOR cur_ex_fiscais_ii(pn_excecao_ii_id NUMBER) IS
    SELECT ex_ipi_recof_id
         , ato_legal_recof_id
         , orgao_emissor_recof_id
         , nr_ato_legal_recof
         , ano_ato_legal_recof
      FROM imp_excecoes_fiscais
     WHERE excecao_id = pn_excecao_ii_id
       AND Nvl(recof, 'N') = 'S';

  vr_cur_ex_fiscais_ii           cur_ex_fiscais_ii%ROWTYPE;
  vn_peso_bruto_nac              NUMBER; --110918
  vn_peso_liq_nac                NUMBER; --110918
  vc_tp_embarque_nac             VARCHAR2(150);--110918
  vn_frete_afrmm                 NUMBER;
  vn_frete_convertido_afrmm      NUMBER;

  vn_motivo_sem_cobertura_id     NUMBER;
  vn_benef_id                    NUMBER;

  vb_achou_vinc_exp              BOOLEAN;
  vc_re_vinc_exp                 VARCHAR2(100);
  vb_achou_docs                  BOOLEAN := FALSE;
  vn_documento_id                imp_dcl_dcto_instr.tp_documento_id%TYPE;
  vc_nr_documento                VARCHAR2(25) := NULL;
  vc_house_conhec                VARCHAR2(50);
  vc_master_conhec               imp_conhecimentos.master%TYPE;
  vc_cert_origem_numero          imp_cert_origem_mercosul.cert_origem_numero%TYPE;
  vn_conhec_id                   imp_conhecimentos.conhec_id%TYPE;
  vn_invoice_id                  imp_invoices.invoice_id%TYPE;
  vr_cert_origem_mercosul        cur_busca_certificado_origem%ROWTYPE;
  vr_excecao_por_tp_ebq          cur_excecao_por_tp_ebq%ROWTYPE;
  vn_da_invoice_lin_id           imp_invoices_lin.invoice_lin_id%TYPE;
  vn_da_invoice_id               imp_invoices.invoice_id%TYPE;
  vc_dtr_numero                  imp_dtr.dtr_numero%TYPE;
  vc_novo_regime                 cmx_tabelas.auxiliar4%TYPE;
  vt_cdh                         cur_declaracoes_header%ROWTYPE;
  vt_cdhl                        cur_declaracoes_header_licenca%ROWTYPE;
  vb_achou_licenca               BOOLEAN := false;
  vb_achou                       BOOLEAN := false;
  vb_achou_excecao_por_ebq       BOOLEAN := false;
  vb_linha_ivc_tem_rcr           BOOLEAN := false;
  vb_li_drw_po_sem_saldo         BOOLEAN := false;
  vc_nada                        VARCHAR2(1) := null;
  vc_trunca_saldo_drw            VARCHAR2(1);
  vn_trunca_saldo_drw_qtde_casas NUMBER;
  vn_fator_conversao_drw         NUMBER;
  vn_qtde_saldo_drw              NUMBER;
  vn_urfe_id                     NUMBER;
  vn_urfd_id                     NUMBER;
  vn_rec_alfand_id               NUMBER;
  vn_setor_armazem_id            NUMBER;
  vn_rec_alfand_tab_id           NUMBER;
  vn_setor_armazem_tab_id        NUMBER;
  vn_cont_fat_comercial          NUMBER;
  vn_cont_fat_remessa            NUMBER;
  vn_cont_total_docs             NUMBER := 0;
  vn_cont_comp                   NUMBER := 0;
  vc_armazem                     IMP_DCL_ARMAZEM.CD_ARMAZEM%type;
  vn_perc_seguro                 NUMBER := 0;
  vn_declaracao_id               imp_declaracoes.declaracao_id%TYPE := 0;
  vn_tp_manifesto                imp_declaracoes.tp_manifesto%TYPE;
  vn_tp_manifesto_conhec         imp_conhecimentos.tp_manifesto_id%TYPE;
  vc_nr_manifesto                imp_declaracoes.nr_manifesto%TYPE;
  vc_nr_manifesto_conhec         imp_conhecimentos.nr_manifesto%TYPE;
  vn_linha_num                   NUMBER := 0;
  vn_id_regtrib_ii               imp_declaracoes_lin.regtrib_ii_id%TYPE;
  vn_id_regtrib_ipi              imp_declaracoes_lin.regtrib_ipi_id%TYPE;
  vn_id_regtrib_icms             imp_declaracoes_lin.regtrib_icms_id%TYPE;
  vn_id_regtrib_pis_cofins       imp_declaracoes_lin.regtrib_pis_cofins_id%TYPE;
  vn_id_regtrib_ii_def           imp_declaracoes_lin.regtrib_ii_id%TYPE;
  vn_id_regtrib_ipi_def          imp_declaracoes_lin.regtrib_ipi_id%TYPE;
  vn_id_regtrib_icms_def         imp_declaracoes_lin.regtrib_icms_id%TYPE;
  vn_id_regtrib_pis_cofins_def   imp_declaracoes_lin.regtrib_pis_cofins_id%TYPE;
  vn_pais_export_id_invoice      imp_invoices.export_id%TYPE;
  vn_pais_origem_id              imp_declaracoes_lin.pais_origem_id%TYPE;
  vn_pais_origem_id_antid        imp_declaracoes_lin.pais_origem_id%TYPE;
  vn_pais_origem_id_fabricante   imp_declaracoes_lin.pais_origem_id%TYPE;
  vn_ausencia_fabric_gravar      imp_declaracoes_lin.ausencia_fabric%TYPE;
  vn_adi_id                      imp_declaracoes_adi.declaracao_adi_id%TYPE;
  vn_icms_empresas_param         NUMBER := null;
  vn_dcl_dcto_instr_id           NUMBER;
  vc_step_error                  VARCHAR2(1000);
  vn_cfop_id_padrao              NUMBER := null;
  vn_evento_id_drw               cmx_eventos.evento_id%TYPE;
  vn_excecao_icms_id             imp_declaracoes_lin.excecao_icms_id%TYPE;
  vn_excecao_ipi_id              imp_declaracoes_lin.excecao_ipi_id%TYPE;
  vn_excecao_ii_id               imp_declaracoes_lin.excecao_ii_id%TYPE;
  vn_excecao_pis_cofins_id       imp_declaracoes_lin.excecao_pis_cofins_id%TYPE;
  vn_excecao_antid_id            imp_declaracoes_lin.excecao_antid_id%TYPE;
  vb_dummy                       BOOLEAN;
  vc_tem_excecao_recof           imp_excecoes_fiscais.recof%TYPE := 'N';
  vc_recof_dcl                   imp_declaracoes_lin.recof%TYPE  := 'N';
  vc_tp_embarque                 cmx_tabelas.auxiliar1%TYPE;
  vc_tp_fixo                     cmx_tabelas.auxiliar1%TYPE;
  vn_fund_legal_pis_cof_ii_id    imp_excecoes_fiscais.fund_legal_pis_cofins_id%TYPE;
  vc_regtrib_ii                  VARCHAR2(20) := null;
  vc_regtrib_ipi                 VARCHAR2(20) := null;
  vc_regtrib_icms                VARCHAR2(20) := null;
  vc_regtrib_pis_cofins          VARCHAR2(20) := null;

  vc_tp_declaracao               VARCHAR2(20) := cmx_pkg_tabelas.codigo(pn_tp_declaracao_id);

  vn_dummy                       NUMBER;
  vc_dummy                       VARCHAR2(100);
  vc_inv_concat                  VARCHAR2(25);
  vn_ex_ncm_id                   NUMBER;
  vn_ex_nbm_id                   NUMBER;
  vn_ex_naladi_id                NUMBER;
  vn_ex_prac_id                  NUMBER;
  vn_ex_antd_id                  NUMBER;
  vn_ex_ipi_id                   NUMBER;

  vn_aliq_ii_dev                 NUMBER;
  vn_aliq_ii_red                 NUMBER;
  vn_perc_red_ii                 NUMBER;
  vn_aliq_ipi_dev                NUMBER;
  vn_aliq_ipi_red                NUMBER;
  vn_aliq_icms                   NUMBER;
  vn_aliq_icms_red               NUMBER;
  vn_aliquota_mva                NUMBER;
  vn_perc_red_icms               NUMBER;
  vc_regime_especial             VARCHAR2(1);
  vn_aliq_pis                    NUMBER;
  vc_aliq_nt_ipi                 cmx_tab_ncm.aliq_nt_ipi%TYPE;
  vn_aliq_cofins                 NUMBER;
  vn_perc_red_pis_cofins         NUMBER;
  vn_aliq_pis_ncm                NUMBER;
  vn_aliq_cofins_ncm             NUMBER;
  vn_aliq_cofins_recuperar_ncm   NUMBER;
  vn_flegal_red_pis_cofins_id    NUMBER;
  vn_aliq_pis_reduzida           NUMBER;
  vn_aliq_cofins_reduzida        NUMBER;
  vc_flag_red_base_pis_cofins    VARCHAR2(1);
  vn_aliq_pis_especifica         NUMBER;
  vn_aliq_cofins_especifica      NUMBER;
  vn_qtde_um_aliq_especifica_pc  NUMBER;
  vn_fator_conversao_aliq_espec  NUMBER;
  vc_um_aliq_especifica_pc       VARCHAR2(15);
  vn_aliq_antid_ad_valorem       NUMBER;
  vn_aliq_especifica_antid       NUMBER;
  vc_tipo_unidade_medida_antid   imp_declaracoes_lin.tipo_unidade_medida_antid%TYPE;
  vc_somatoria_quantidade        imp_declaracoes_lin.somatoria_quantidade%TYPE;
  vn_um_aliq_especifica_antid_id imp_declaracoes_lin.um_aliq_especifica_antid_id%TYPE;
  vn_ivc_id                      imp_invoices.invoice_id%TYPE;

  vn_evento_id                   cmx_eventos.evento_id%TYPE;
  vb_erro_nacionalizacao         BOOLEAN := false;
  vb_inserir                     BOOLEAN;
  ve_nacionalizacao              EXCEPTION;
  ve_recof                       EXCEPTION;
  ve_nac_adm_temp                EXCEPTION;
  ve_li_drw_po_sem_saldo         EXCEPTION;

  vn_despachante_id              NUMBER;
  vn_despachante_site_id         NUMBER;
  vn_pais_id                     NUMBER;

  vn_fundamento_legal_id         NUMBER;
  vn_fund_legal_icms_id          NUMBER;
  vn_fund_legal_pis_cofins_id    NUMBER;

  vn_ato_legal_id                NUMBER;
  vn_orgao_emissor_id            NUMBER;
  vn_nr_ato_legal                NUMBER(6);
  vn_ano_ato_legal               NUMBER(4);

  vc_destino_ex_ato_legal_ii     VARCHAR2 (6);
  vn_ato_legal_ii_id             NUMBER;
  vn_orgao_emissor_ii_id         NUMBER;
  vn_nr_ato_legal_ii             NUMBER(6);
  vn_ano_ato_legal_ii            NUMBER(4);
  gn_ato_legal_ncm_id            NUMBER;
  gn_orgao_emissor_ncm_id        NUMBER;
  gn_nr_ato_legal_ncm            NUMBER(6);
  gn_ano_ato_legal_ncm           NUMBER(4);
  gn_ato_legal_nbm_id            NUMBER;
  gn_orgao_emissor_nbm_id        NUMBER;
  gn_nr_ato_legal_nbm            NUMBER(6);
  gn_ano_ato_legal_nbm           NUMBER(4);
  gn_ato_legal_naladi_id         NUMBER;
  gn_orgao_emissor_naladi_id     NUMBER;
  gn_nr_ato_legal_naladi         NUMBER(6);
  gn_ano_ato_legal_naladi        NUMBER(4);
  gn_ato_legal_acordo_id         NUMBER;
  gn_orgao_emissor_acordo_id     NUMBER;
  gn_nr_ato_legal_acordo         NUMBER(6);
  gn_ano_ato_legal_acordo        NUMBER(4);

  vc_descricao_long              LONG;

  vn_naladi_sh_id                NUMBER;
  vn_naladi_ncca_id              NUMBER;

  vn_urfd_ebq_id                 NUMBER;
  vn_enquad_legal_ipi_id         NUMBER;

  vc_quebra_qtde_drawback        VARCHAR2 (1);

  -- Este registro é usado para passar as informações necessárias para a criação de uma LI(se precisar)
  -- ele será passado para procedure que gera a LI automaticamente(IMP_PRC_GERA_LI_DRAWBACK).
  vt_licencas_lin                imp_licencas_lin%ROWTYPE;
  vn_quantidade_gerar_linha_dcl  imp_declaracoes_lin.qtde%TYPE;
  vc_tipo_log                    cmx_log_erros.tipo%TYPE;
  vb_li_gerada                   BOOLEAN := false;
  vc_icms_diferido               imp_empresas_param.icms_diferido%TYPE;
  vc_suspende_icms_recof         imp_empresas_param.suspende_icms_recof%TYPE;

  vn_aliq_icms_fecp_param        imp_declaracoes_lin.aliq_icms_fecp%TYPE;
  vn_declaracao_lin_id           NUMBER;
  vr_valida_itens                cur_verifica_itens%ROWTYPE;

  vb_achou_ivc_lin_nac           BOOLEAN        := false;
  vb_tem_erros                   BOOLEAN        := false;
  vb_nao_gerar_nacionalizacao    BOOLEAN        := false;
  vc_linhas_ivc                  VARCHAR2(1000) := null;
  vn_qtde_invoice                NUMBER         := null;
  vn_qtde_destinada              NUMBER         := null;
  vn_nr_declaracao_da            imp_declaracoes.nr_declaracao%TYPE;
  vc_ivc_atual                   imp_invoices.invoice_num%TYPE;
  vn_dcl_lin_da_id               imp_declaracoes.declaracao_id%TYPE;
  vn_dcl_lin_da_lin_id           imp_declaracoes_lin.declaracao_lin_id%TYPE;

  reg_da_adm_temp                cur_busca_dados_da_adm_temp%ROWTYPE;
  vc_cod_doc_aduaneiro           cmx_tabelas.codigo%TYPE;

  TYPE tt_consumos_nac           IS TABLE OF rcf_consumos.consumo_id%TYPE INDEX BY BINARY_INTEGER;
  vt_consumos_nac                tt_consumos_nac;

  vd_data_busca_excecao          imp_declaracoes.dt_declaracao%TYPE := Trunc (SYSDATE);
  vn_rd_id                       NUMBER;

  --vc_da_outro_importador VARCHAR2(1) := 'N';

  vn_item_id                     imp_declaracoes_lin.item_id%TYPE;
  vn_da_lin_id                   imp_declaracoes_lin.declaracao_id%TYPE;

  -- PRO-EMPREGO
  vc_pro_emprego                 VARCHAR2(1);
  vn_aliq_base_pro_emprego       NUMBER;
  vn_aliq_antecip_pro_emprego    NUMBER;

  -- BENEFICIO PR
  vc_beneficio_pr                VARCHAR2(1);
  vn_aliq_base_pr                NUMBER;
  vn_perc_diferido_pr            NUMBER;
  vc_beneficio_pr_artigo         VARCHAR2(5);
  vn_pr_perc_vr_devido           NUMBER;
  vn_pr_perc_minimo_base         NUMBER;
  vn_pr_perc_minimo_suspenso     NUMBER;
  vc_beneficio_sp                VARCHAR2(1);
  vn_da_id_tp_decl_14_15         NUMBER := null;

  -- Dados Logisticos do Embarque
  vc_operacao_fundap             imp_declaracoes.operacao_fundap%TYPE;
  vn_trading_site_id             imp_declaracoes.importador_site_id%TYPE;
  vn_trading_id                  imp_declaracoes.importador_id%TYPE;

  -- verificacao REPETRO
  vb_achou_repetro               BOOLEAN;
  vc_emb_repetro                 cmx_tabelas.auxiliar1%TYPE;
  vc_verif_nac_adm_tmp           cmx_tabelas.auxiliar1%TYPE;

  vn_ins_estadual_id             imp_declaracoes_adi.ins_estadual_id%TYPE;

  -- verificacao di única
  vc_aux                         cmx_tabelas.auxiliar1%TYPE;

  -- verificacao nacionalização
  vc_nac                         cmx_tabelas.auxiliar1%TYPE;

  vn_aliq_ii_rec                 NUMBER;

  -- adicionando dados da remessa documento de instrução de despacho

  vc_util_recof_sem_param        VARCHAR2(2000);

  -- busca da sub familia dentro da invoice linha
  vn_sub_familia_id              imp_invoices_lin.sub_familia_id%TYPE;

  vb_ncm_evento                  BOOLEAN := FALSE;
  vb_ncm_erro                    BOOLEAN := FALSE;
  vn_ncm_id                      NUMBER;
  vc_log_tipo                    VARCHAR2(1000);
  vc_log_desc                    VARCHAR2(32767);
  vc_log_solu                    VARCHAR2(32767);
  ve_ncm                         EXCEPTION;
  vn_aliquota_cofins_custo       NUMBER;
  vc_trading                     VARCHAR2(1) := 'N'; --carlosh
  vc_cod_fundamento_legal        VARCHAR2(150);
  vc_codigo_tp_embarque          VARCHAR2(150);
  vn_aliq_icms_fecp_fiscal       NUMBER := NULL; --Aliquota de FECP obtida pela excecao fiscal
  vc_admissao_temporaria         VARCHAR2(1) := NULL;
  vn_prazo_requerido             NUMBER := NULL;
  vc_beneficio_suspensao         imp_excecoes_fiscais.beneficio_suspensao%TYPE;
  vn_perc_beneficio_suspensao    imp_excecoes_fiscais.perc_beneficio_suspensao%TYPE;
  vc_tp_conta                    VARCHAR2(10);

  vn_icms_motivo_desoneracao_id  NUMBER;
  vc_tratar_icms_deso_emiss_nfe  VARCHAR2(1);

  PROCEDURE prc_preenche_globais_ato_legal IS
  BEGIN
    gn_ato_legal_ncm_id        := null;
    gn_orgao_emissor_ncm_id    := null;
    gn_nr_ato_legal_ncm        := null;
    gn_ano_ato_legal_ncm       := null;
    gn_ato_legal_nbm_id        := null;
    gn_orgao_emissor_nbm_id    := null;
    gn_nr_ato_legal_nbm        := null;
    gn_ano_ato_legal_nbm       := null;
    gn_ato_legal_naladi_id     := null;
    gn_orgao_emissor_naladi_id := null;
    gn_nr_ato_legal_naladi     := null;
    gn_ano_ato_legal_naladi    := null;
    gn_ato_legal_acordo_id     := null;
    gn_orgao_emissor_acordo_id := null;
    gn_nr_ato_legal_acordo     := null;
    gn_ano_ato_legal_acordo    := null;

    IF (vc_destino_ex_ato_legal_ii = 'NCM'   ) THEN
      gn_ato_legal_ncm_id        := vn_ato_legal_ii_id    ;
      gn_orgao_emissor_ncm_id    := vn_orgao_emissor_ii_id;
      gn_nr_ato_legal_ncm        := vn_nr_ato_legal_ii    ;
      gn_ano_ato_legal_ncm       := vn_ano_ato_legal_ii   ;
    END IF;

    IF (vc_destino_ex_ato_legal_ii = 'NBM'   ) THEN
      gn_ato_legal_nbm_id        := vn_ato_legal_ii_id    ;
      gn_orgao_emissor_nbm_id    := vn_orgao_emissor_ii_id;
      gn_nr_ato_legal_nbm        := vn_nr_ato_legal_ii    ;
      gn_ano_ato_legal_nbm       := vn_ano_ato_legal_ii   ;
    END IF;

    IF (vc_destino_ex_ato_legal_ii = 'NALADI') THEN
      gn_ato_legal_naladi_id     := vn_ato_legal_ii_id    ;
      gn_orgao_emissor_naladi_id := vn_orgao_emissor_ii_id;
      gn_nr_ato_legal_naladi     := vn_nr_ato_legal_ii    ;
      gn_ano_ato_legal_naladi    := vn_ano_ato_legal_ii   ;
    END IF;

    IF (vc_destino_ex_ato_legal_ii = 'ACORDO') THEN
      gn_ato_legal_acordo_id     := vn_ato_legal_ii_id    ;
      gn_orgao_emissor_acordo_id := vn_orgao_emissor_ii_id;
      gn_nr_ato_legal_acordo     := vn_nr_ato_legal_ii    ;
      gn_ano_ato_legal_acordo    := vn_ano_ato_legal_ii   ;
    END IF;
  END;

  /* Se for DSI, exige-se o pais de origem, por isso iremos deduzi-lo aqui por precaucao,
     no caso de nao ter sido informado na linha da invoice/li.
     Se "fabricante é o exportador" o pais de origem é o pais de origem do exportador
     da invoice.
     Se o "fabricante nao é o exportador", o pais de origem é o pais do fabricante
     indicado na linha da invoice.
     Se o fabricante for "desconhecido", o pais foi indicado na linha de invoice.
     Quando NAO for DSI, o pais de origem so deve ser informado se o "fabricante for
     desconhecido" - o que ja é exigido na linha da invoice.
  */
  FUNCTION fnc_deduz_ausencia ( pn_pais_origem_id         imp_declaracoes_lin.pais_origem_id%TYPE
                              , pn_ausencia_fabric_linha  imp_declaracoes_lin.ausencia_fabric%TYPE
                              , pn_pais_export_id_invoice imp_invoices.export_id%TYPE
                              , pn_fabric_id              imp_declaracoes_lin.fabric_id%TYPE
                              , pn_fabric_site_id         imp_declaracoes_lin.fabric_site_id%TYPE
                              , vn_ausencia_fabric_gravar IN OUT imp_declaracoes_lin.ausencia_fabric%TYPE
                              ) RETURN NUMBER IS
    CURSOR cur_pais_fabric IS
      SELECT pais_id
        FROM imp_fabricantes_sites
       WHERE fabric_id      = pn_fabric_id
         AND fabric_site_id = pn_fabric_site_id;

    vn_return_pais_id imp_declaracoes_lin.pais_origem_id%TYPE;

  BEGIN
    IF (pc_flag_dsi = 'S') THEN
       IF (pn_pais_origem_id IS null) THEN /* Se ausencia_fabric = 3, nunca vai ser nulo: garantido na propria invoice */
         IF (pn_ausencia_fabric_linha = 1) THEN
          /* Fabricante e o exportador */
           vn_return_pais_id := pn_pais_export_id_invoice;

         ELSIF (pn_ausencia_fabric_linha = 2) THEN
           /* Fabricante nao e o exportador: foi mencionado um fabricante na linha da invoice */
           OPEN  cur_pais_fabric;
           FETCH cur_pais_fabric INTO vn_return_pais_id;
           CLOSE cur_pais_fabric;
         END IF;
       ELSE
         vn_return_pais_id := pn_pais_origem_id;
       END IF;
       /* Se DSI, ausencia_fabric sempre = 3 */
       vn_ausencia_fabric_gravar := 3;
    ELSE
      /* Se nao for DSI, a ausencia_fabric deve retornar com a ausencia_fabric escolhida na
         propria linha da invoice, o mesmo se aplica ao pais de origem, que pode ou nao ser
         nulo, dependendo da ausencia do fabricante
      */
      vn_return_pais_id         := pn_pais_origem_id;
      vn_ausencia_fabric_gravar := pn_ausencia_fabric_linha;
    END IF;
    return (vn_return_pais_id);
  END fnc_deduz_ausencia;

  /* Se estivermos tratanto uma DSI, temos que levar em conta algumas regras para
     deducao do Regime de Tributacao do II, pois, para cada Natureza de Operacao, temos
     um conjunto de Regimes de Tributacao que podem ser utilizados. Devemos saber,
     para a DSI em evidencia, qual vai ser o Regime de Tributacao do II que sera
     utilizado. Quando for DSI, o parametro pn_tp_declaracao_id é igual ao ID da Natureza da
     Operacao (nat_operacao_id).
  */
  FUNCTION fnc_deduz_regtrib_ii_dsi RETURN NUMBER IS
    CURSOR cur_regtrib_ii IS
      SELECT ct_regii.tabela_id
        FROM cmx_tabelas ct_natope
           , cmx_tabelas ct_regras
           , cmx_tabelas ct_regii
       WHERE ct_natope.tabela_id = pn_tp_declaracao_id  /* tab. 102 */
         AND ct_regras.tipo      = '107'
         AND ct_regras.auxiliar1 = ct_natope.codigo
         AND ct_regii.tipo       = '104'
         AND ct_regras.auxiliar2 = ct_regii.codigo
    ORDER BY ct_regii.tabela_id;

    vn_regtrib_ii imp_declaracoes_lin.regtrib_ii_id%TYPE;

  BEGIN
    OPEN  cur_regtrib_ii;
    FETCH cur_regtrib_ii INTO vn_regtrib_ii;
    CLOSE cur_regtrib_ii;

    return (vn_regtrib_ii);
  END fnc_deduz_regtrib_ii_dsi;

  /* Se houver transferência de regime para o embarque que está gerando a
     declaração, devemos primeiro gerar o conhecimento de transporte para
     este embarque.
  */
  PROCEDURE prc_gerar_conhec_dtr IS
    CURSOR cur_dtr IS
      SELECT da_id
           , dtr_numero
        FROM imp_dtr
       WHERE embarque_id = pn_embarque_id;

    CURSOR cur_da_lin (pn_da_lin_id imp_declaracoes_lin.declaracao_lin_id%TYPE) IS
      SELECT invoice_lin_id
        FROM imp_declaracoes_lin
       WHERE declaracao_lin_id = pn_da_lin_id;

    CURSOR cur_invoice_lin (pn_invoice_lin_id imp_invoices_lin.invoice_lin_id%TYPE) IS
      SELECT imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada)
           , iil.vrt_fr_total_m
           , iil.vrt_fr_prepaid_m
           , iil.vrt_fr_collect_m
           , iil.vrt_fr_territorio_nacional_m
           , iil.pesobrt_tot
        FROM imp_invoices_lin iil
       WHERE iil.invoice_lin_id = pn_invoice_lin_id;

    CURSOR cur_acresded_ivc_lin (pn_invoice_lin_id imp_invoices_lin.invoice_lin_id%TYPE) IS
      SELECT imp_fnc_qtde_laudo(iil.invoice_lin_id, iil.laudo_id, iil.qtde, iil.qtde_descarregada) qtde_ivc_lin_da
           , iial.embarque_ad_id
           , iial.valor_m
           , iial.valor_mn
        FROM imp_invoices_lin    iil
           , imp_invoices_ad_lin iial
       WHERE iial.invoice_lin_id = iil.invoice_lin_id
         AND iil.invoice_lin_id  = pn_invoice_lin_id;

    CURSOR cur_agrupa_valor_por_da_ad_id IS
      SELECT sum (valor_m)  valor_m
           , sum (valor_mn) valor_mn
           , da_embarque_ad_id
        FROM imp_tmp_gera_dcl_ivc_lin_ad
       GROUP BY da_embarque_ad_id;

    CURSOR cur_valores_ad_por_ivc_lin IS
      SELECT dtr_embarque_ad_id
           , dtr_invoice_lin_id
        FROM imp_tmp_gera_dcl_ivc_lin_ad;

    CURSOR cur_da (pn_da_id imp_declaracoes.declaracao_id%TYPE) IS
      SELECT conhec.house
           , conhec.master
           , conhec.conhec_id
        FROM imp_declaracoes   decl
           , imp_embarques     emb
           , imp_conhecimentos conhec
       WHERE conhec.conhec_id   = emb.conhec_id
         AND emb.embarque_id    = decl.embarque_id
         AND decl.declaracao_id = pn_da_id;

    CURSOR cur_conhecimento (pn_conhec_id imp_conhecimentos.conhec_id%TYPE) IS
      SELECT *
        FROM imp_conhecimentos
       WHERE conhec_id = pn_conhec_id;

    CURSOR cur_desdobramento (
       pc_house  imp_conhecimentos.house%TYPE
     , pc_master imp_conhecimentos.master%TYPE
    ) IS
      SELECT desdobramento
        FROM imp_conhecimentos
       WHERE house             = pc_house
         AND nvl (master, '*') = nvl (pc_master, '*')
       ORDER BY desdobramento DESC;

    vn_da_id               imp_dtr.da_id%TYPE;
    vn_dtr_numero          imp_dtr.dtr_numero%TYPE;
    vn_invoice_lin_id      imp_declaracoes_lin.invoice_lin_id%TYPE;
    vc_house               imp_conhecimentos.house%TYPE;
    vc_master              imp_conhecimentos.master%TYPE;
    vn_conhec_id           imp_conhecimentos.conhec_id%TYPE;
    vn_novo_conhec_id      imp_conhecimentos.conhec_id%TYPE;
    vn_desdobramento       imp_conhecimentos.desdobramento%TYPE;
    vr_conhecimento        imp_conhecimentos%ROWTYPE;
    vn_qtde_item_da        imp_invoices_lin.qtde%TYPE;
    vn_fr_total_item_da    imp_invoices_lin.vrt_fr_total_m%TYPE;
    vn_fr_prepaid_item_da  imp_invoices_lin.vrt_fr_prepaid_m%TYPE;
    vn_fr_collect_item_da  imp_invoices_lin.vrt_fr_collect_m%TYPE;
    vn_fr_ter_nac_item_da  imp_invoices_lin.vrt_fr_territorio_nacional_m%TYPE;
    vn_peso_bruto_item_da  imp_invoices_lin.pesobrt_tot%TYPE;
    vn_frete_total_m       NUMBER := 0;
    vn_frete_prepaid_m     NUMBER := 0;
    vn_frete_collect_m     NUMBER := 0;
    vn_frete_ter_nac_m     NUMBER := 0;
    vn_peso_bruto_total    NUMBER := 0;
    vn_dtr_embarque_ad_id  NUMBER := 0;

  BEGIN

    /* Busca o DTR do embarque */
    OPEN  cur_dtr;
    FETCH cur_dtr INTO vn_da_id, vn_dtr_numero;
    CLOSE cur_dtr;

    /* Se existir DTR para o embarque */
    IF (vn_da_id IS NOT null) THEN
      /* Percorre os consumos do DTR para calcular o frete proporcional */
      FOR vr_consumos IN (SELECT qtde
                               , da_lin_id
                               , invoice_lin_id --linha da invoice do emb de transferencia (invoice nova)
                            FROM imp_dtr_consumos
                           WHERE dtr_numero = vn_dtr_numero
                         )
      LOOP
        /* Busca o invoice_lin_id da invoice da DA do consumo */
        OPEN  cur_da_lin (vr_consumos.da_lin_id);
        FETCH cur_da_lin INTO vn_invoice_lin_id;
        CLOSE cur_da_lin;

        /* Busca as informações da linha da invoice */
        OPEN  cur_invoice_lin (vn_invoice_lin_id);
        FETCH cur_invoice_lin INTO vn_qtde_item_da
                                 , vn_fr_total_item_da
                                 , vn_fr_prepaid_item_da
                                 , vn_fr_collect_item_da
                                 , vn_fr_ter_nac_item_da
                                 , vn_peso_bruto_item_da;
        CLOSE cur_invoice_lin;

        /* Calcula as proporções de frete e peso bruto */
        vn_frete_total_m    := vn_frete_total_m    + (vn_fr_total_item_da   * vr_consumos.qtde / vn_qtde_item_da);
        vn_frete_prepaid_m  := vn_frete_prepaid_m  + (vn_fr_prepaid_item_da * vr_consumos.qtde / vn_qtde_item_da);
        vn_frete_collect_m  := vn_frete_collect_m  + (vn_fr_collect_item_da * vr_consumos.qtde / vn_qtde_item_da);
        vn_frete_ter_nac_m  := vn_frete_ter_nac_m  + (vn_fr_ter_nac_item_da * vr_consumos.qtde / vn_qtde_item_da);
        vn_peso_bruto_total := vn_peso_bruto_total + (vn_peso_bruto_item_da * vr_consumos.qtde / vn_qtde_item_da);

        /* popula a tabela temporaria com os valores de acrescimos/deducoes
           gravados na DA só que proporcionais a quantidade consumida no DTR
        */
        FOR i IN cur_acresded_ivc_lin (vn_invoice_lin_id) LOOP
          INSERT INTO imp_tmp_gera_dcl_ivc_lin_ad (
             da_embarque_ad_id
           , da_invoice_lin_id
           , dtr_invoice_lin_id
           , valor_m
           , valor_mn
           )
          VALUES (
             i.embarque_ad_id
           , vn_invoice_lin_id
           , vr_consumos.invoice_lin_id
           , i.valor_m  * (vr_consumos.qtde / i.qtde_ivc_lin_da)
           , i.valor_mn * (vr_consumos.qtde / i.qtde_ivc_lin_da)
          );
        END LOOP; -- FOR i IN cur_acresded_ivc_lin (vn_invoice_lin_id) LOOP
      END LOOP; -- FOR vr_consumos IN (SELECT qtde

      /* Busca o conhecimento da DA */
      OPEN  cur_da (vn_da_id);
      FETCH cur_da INTO vc_house, vc_master, vn_conhec_id;
      CLOSE cur_da;

      /* Busca as informações do conhecimento da DA */
      OPEN  cur_conhecimento (vn_conhec_id);
      FETCH cur_conhecimento INTO vr_conhecimento;
      CLOSE cur_conhecimento;

      /* Busca o desdobramento mais recente */
      OPEN  cur_desdobramento (vc_house, vc_master);
      FETCH cur_desdobramento INTO vn_desdobramento;
      CLOSE cur_desdobramento;

      /* Insere o conhecimento de transporte */
      vn_novo_conhec_id := cmx_fnc_proxima_sequencia ('imp_conhecimentos_sq1');
      INSERT INTO imp_conhecimentos (
         /* 01 */ conhec_id
       , /* 02 */ empresa_id
       , /* 03 */ tp_conhecimento_id
       , /* 04 */ via_transporte_id
       , /* 05 */ origem_id
       , /* 06 */ house
       , /* 07 */ master
       , /* 08 */ termo_id
       , /* 09 */ dt_emissao
       , /* 10 */ dt_vencto
       , /* 11 */ moeda_id
       , /* 12 */ valor_total_m
       , /* 13 */ valor_prepaid_m
       , /* 14 */ valor_collect_m
       , /* 15 */ valor_terr_nacional_m
       , /* 16 */ agente_carga_id
       , /* 17 */ agente_carga_site_id
       , /* 18 */ transportador_id
       , /* 19 */ transportador_site_id
       , /* 20 */ identificacao_veiculo
       , /* 21 */ local_embarque_id
       , /* 22 */ urfe_id
       , /* 23 */ peso_bruto
       , /* 24 */ multimodal
       , /* 25 */ bandeira_id
       , /* 26 */ atributo1
       , /* 27 */ atributo2
       , /* 28 */ atributo3
       , /* 29 */ atributo4
       , /* 30 */ atributo5
       , /* 31 */ atributo6
       , /* 32 */ atributo7
       , /* 33 */ atributo8
       , /* 34 */ atributo9
       , /* 35 */ atributo10
       , /* 36 */ atributo11
       , /* 37 */ atributo12
       , /* 38 */ atributo13
       , /* 39 */ atributo14
       , /* 40 */ atributo15
       , /* 41 */ atributo16
       , /* 42 */ atributo17
       , /* 43 */ atributo18
       , /* 44 */ atributo19
       , /* 45 */ atributo20
       , /* 46 */ creation_date
       , /* 47 */ created_by
       , /* 48 */ last_update_date
       , /* 49 */ last_updated_by
       , /* 50 */ desdobramento
       , /* 51 */ ce_mercante
       , /* 52 */ presenca_carga
       , /* 53 */ grupo_acesso_id
      )
      VALUES (
         /* 01 */ vn_novo_conhec_id
       , /* 02 */ vr_conhecimento.empresa_id
       , /* 03 */ vr_conhecimento.tp_conhecimento_id
       , /* 04 */ vr_conhecimento.via_transporte_id
       , /* 05 */ vr_conhecimento.origem_id
       , /* 06 */ vr_conhecimento.house
       , /* 07 */ vr_conhecimento.master
       , /* 08 */ vr_conhecimento.termo_id
       , /* 09 */ vr_conhecimento.dt_emissao
       , /* 10 */ vr_conhecimento.dt_vencto
       , /* 11 */ vr_conhecimento.moeda_id
       , /* 12 */ round (vn_frete_total_m, 2)
       , /* 13 */ round (vn_frete_prepaid_m, 2)
       , /* 14 */ round (vn_frete_collect_m, 2)
       , /* 15 */ round (vn_frete_ter_nac_m, 2)
       , /* 16 */ vr_conhecimento.agente_carga_id
       , /* 17 */ vr_conhecimento.agente_carga_site_id
       , /* 18 */ vr_conhecimento.transportador_id
       , /* 19 */ vr_conhecimento.transportador_site_id
       , /* 20 */ vr_conhecimento.identificacao_veiculo
       , /* 21 */ vr_conhecimento.local_embarque_id
       , /* 22 */ vr_conhecimento.urfe_id
       , /* 23 */ round (vn_peso_bruto_total, 2)
       , /* 24 */ vr_conhecimento.multimodal
       , /* 25 */ vr_conhecimento.bandeira_id
       , /* 26 */ vr_conhecimento.atributo1
       , /* 27 */ vr_conhecimento.atributo2
       , /* 28 */ vr_conhecimento.atributo3
       , /* 29 */ vr_conhecimento.atributo4
       , /* 30 */ vr_conhecimento.atributo5
       , /* 31 */ vr_conhecimento.atributo6
       , /* 32 */ vr_conhecimento.atributo7
       , /* 33 */ vr_conhecimento.atributo8
       , /* 34 */ vr_conhecimento.atributo9
       , /* 35 */ vr_conhecimento.atributo10
       , /* 36 */ vr_conhecimento.atributo11
       , /* 37 */ vr_conhecimento.atributo12
       , /* 38 */ vr_conhecimento.atributo13
       , /* 39 */ vr_conhecimento.atributo14
       , /* 40 */ vr_conhecimento.atributo15
       , /* 41 */ vr_conhecimento.atributo16
       , /* 42 */ vr_conhecimento.atributo17
       , /* 43 */ vr_conhecimento.atributo18
       , /* 44 */ vr_conhecimento.atributo19
       , /* 45 */ vr_conhecimento.atributo20
       , /* 46 */ sysdate
       , /* 47 */ pn_user_id
       , /* 48 */ sysdate
       , /* 49 */ pn_user_id
       , /* 50 */ vn_desdobramento + 1
       , /* 51 */ vr_conhecimento.ce_mercante
       , /* 52 */ vr_conhecimento.presenca_carga
       , /* 53 */ sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
      );

      /* Vincula o conhecimento gerado ao embarque */
      UPDATE imp_embarques
         SET conhec_id = vn_novo_conhec_id
       WHERE embarque_id = pn_embarque_id;

      /* popula as tabelas de acrescimos e deducoes do embarque */
      FOR ad IN cur_agrupa_valor_por_da_ad_id LOOP
        vn_dtr_embarque_ad_id := cmx_fnc_proxima_sequencia ('imp_embarques_ad_sq1');

        INSERT INTO imp_embarques_ad (
           /* 01 */ embarque_ad_id
         , /* 02 */ embarque_id
         , /* 03 */ acres_ded_id
         , /* 04 */ moeda_id
         , /* 05 */ abrangencia
         , /* 06 */ valor_m
         , /* 07 */ valor_mn
         , /* 08 */ creation_date
         , /* 09 */ created_by
         , /* 10 */ last_update_date
         , /* 11 */ last_updated_by
         , /* 12 */ grupo_acesso_id
         )
         (SELECT /* 01 */ vn_dtr_embarque_ad_id
               , /* 02 */ pn_embarque_id
               , /* 03 */ acres_ded_id
               , /* 04 */ moeda_id
               , /* 05 */ 'L'
               , /* 06 */ ad.valor_m
               , /* 07 */ ad.valor_mn
               , /* 08 */ sysdate
               , /* 09 */ pn_user_id
               , /* 10 */ sysdate
               , /* 11 */ pn_user_id
               , /* 12 */ sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
            FROM imp_embarques_ad
           WHERE embarque_ad_id = ad.da_embarque_ad_id
        );

        UPDATE imp_tmp_gera_dcl_ivc_lin_ad
           SET dtr_embarque_ad_id = vn_dtr_embarque_ad_id
         WHERE da_embarque_ad_id = ad.da_embarque_ad_id;
      END LOOP; -- FOR cur_agrupa_valor_por_ad_id LOOP

      FOR ad_lin IN cur_valores_ad_por_ivc_lin LOOP
        INSERT INTO imp_embarques_ad_lin (
           embarque_ad_id
         , invoice_lin_id
         , creation_date
         , created_by
         , last_update_date
         , last_updated_by
         , grupo_acesso_id
         )
        VALUES (
           ad_lin.dtr_embarque_ad_id
         , ad_lin.dtr_invoice_lin_id
         , sysdate
         , pn_user_id
         , sysdate
         , pn_user_id
         , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
        );
      END LOOP; -- FOR ad_lin IN cur_valores_ad_por_ivc_lin LOOP
    END IF; -- vn_da_id IS NOT null
  END prc_gerar_conhec_dtr;

/********************/
/* Rotina principal */
/********************/
BEGIN

  /* Verifica se os itens em questão permitem a geração de Decl, para o Recof. */
  IF (cmx_pkg_tabelas.codigo (pn_tp_declaracao_id) = '04') THEN
    OPEN  cur_verifica_itens (pn_embarque_id, pn_invoice_id);
    FETCH cur_verifica_itens INTO vr_valida_itens;
    vb_achou := cur_verifica_itens%FOUND;
    CLOSE cur_verifica_itens;

    IF vb_achou THEN
      pn_evento_id := cmx_fnc_gera_evento(
                        'Inclusão de declaração de RECOF.'
                       , sysdate
                       , pn_user_id
                      );
      FOR vr_validacao IN (SELECT cmx_pkg_itens.codigo (ivl.item_id) item_codigo
                                , cmx_pkg_itens.descricao (ivl.item_id) item_descricao
                                , rie.flag_gera_da
                             FROM imp_invoices_lin ivl
                                , rcf_itens_ext rie
                                , imp_invoices ii
                            WHERE ivl.item_id = rie.item_id
                              AND ivl.invoice_id = ii.invoice_id
                              AND rie.flag_gera_da = 'N'
                              AND ii.embarque_id = pn_embarque_id
                          )
      LOOP
        cmx_prc_gera_log_erros (
           pn_evento_id
         , 'Não pode ser gerada declaração para o regime de Recof: '|| chr(10) ||
           'Item não habilitado para gerar declaração.'|| chr(10) ||
           'Item : ' || vr_validacao.item_codigo || ' - ' || vr_validacao.item_descricao
         , 'E'
         , 'Para que possa ser gerada declaração de Recof com este item, '||
           'marque a opção "Gera declaração" no cadastro de Itens / Recof!'
        );
      END LOOP;

      vc_step_error := 'Ocorreram erros durante a geração de declaração. verifique o log de erros!';
      RAISE ve_recof;
    END IF;
  END IF;

  /* Verificará se todas as saídas definitivas estão parametrizadas no setup de nacionalização
     com uma utilização preenchida.
  */

  IF (cmx_pkg_tabelas.codigo (pn_tp_declaracao_id) = '16') THEN
    FOR vr_util IN (SELECT decode (
                              cons.situacao_estoque
                            , 'E', 'Mesmo estado'
                            , 'I', 'Industrializado'
                           )                                                  situacao_estoque
                         , cmx_pkg_tabelas.codigo (saida.tipo_movimento_id)   tp_mov
                      FROM rcf_consumos         cons
                         , rcf_movimentos       saida
                     WHERE saida.movimento_id = cons.saida_definitiva_movimento_id
                       AND cons.embarque_id   = pn_embarque_id
                       AND NOT exists (SELECT /*+ INDEX (nac rcf_setup_nac_sit_tp_decl_idx) */
                                              null
                                         FROM rcf_setup_nacionalizacao          nac
                                        WHERE nac.situacao_estoque            = cons.situacao_estoque
                                          AND nac.tipo_movimento_saida_def_id = saida.tipo_movimento_id
                                      )
                     GROUP BY cons.situacao_estoque, saida.tipo_movimento_id
                   )
    LOOP
      IF (vc_util_recof_sem_param IS null) THEN
        vc_util_recof_sem_param := 'Não existe setup de nacionalização para o movimento ' || vr_util.tp_mov || ' (' || vr_util.situacao_estoque ||')';
      ELSE
        vc_util_recof_sem_param := vc_util_recof_sem_param || ', ' || vr_util.tp_mov || ' (' || vr_util.situacao_estoque ||')';
      END IF;

    END LOOP;

    IF (vc_util_recof_sem_param IS NOT null) THEN

      vc_util_recof_sem_param   := vc_util_recof_sem_param || '.';

      pn_evento_id := cmx_fnc_gera_evento(
                        'Inclusão de declaração de RECOF.'
                       , sysdate
                       , pn_user_id
                      );

      cmx_prc_gera_log_erros (
         pn_evento_id
       , 'Não pode ser gerada declaração para o regime de Recof: '|| chr(10) || vc_util_recof_sem_param
       , 'E'
       , 'Para que possa ser gerada a declaração efetue a parametrização na opção "COMEX / Recof / Cadastros / Setup das nacionalizações".'
      );

      vc_step_error := 'Ocorreram erros durante a geração de declaração. ' || vc_util_recof_sem_param;
      RAISE ve_recof;

    END IF;
  END IF;

  -- Essa verificação somente deve ser feita se não se tratar de nacionalização de REPETRO (tipo DI 13, mas com tipo de Embarque de REPETRO e NAcionalização)
  -- isso porque é o módulo de REPETRO quem vai criar a destinação da ADM. TEMP. no importacao.
  OPEN cur_verifc_nac_repetro;
  FETCH cur_verifc_nac_repetro INTO vc_emb_repetro;
  vb_achou_repetro := cur_verifc_nac_repetro%FOUND;
  CLOSE cur_verifc_nac_repetro;

  --Verificação do tipo fixo do tipo de embarque para processo nacionalização de admissão temporária sem processo de admissão
  OPEN  cur_verif_nac_adm_tmp;
  FETCH cur_verif_nac_adm_tmp INTO vc_verif_nac_adm_tmp;
  CLOSE cur_verif_nac_adm_tmp;

  IF (cmx_pkg_tabelas.codigo (pn_tp_declaracao_id) = '13') AND (NOT vb_achou_repetro) AND (vc_verif_nac_adm_tmp = 'NAC') THEN
    OPEN  cur_nr_declaracao_da;
    FETCH cur_nr_declaracao_da INTO vn_nr_declaracao_da;
    CLOSE cur_nr_declaracao_da;

    --vc_da_outro_importador := 'S';

    vc_ivc_atual := null;
    FOR vr_inv IN cur_invoices LOOP
      -- primeira checagem: verificar se todas as linhas da invoice de nacionalizacao
      -- estao vinculadas nas destinacoes da DA
      FOR vr_inv_lin IN cur_declaracao_lin (vr_inv.invoice_id) LOOP
        OPEN  cur_adm_temp_checa_destinacoes (vr_inv_lin.invoice_lin_id);
        FETCH cur_adm_temp_checa_destinacoes INTO vn_dummy;
        vb_achou_ivc_lin_nac := cur_adm_temp_checa_destinacoes%FOUND;
        CLOSE cur_adm_temp_checa_destinacoes;

        IF (NOT vb_achou_ivc_lin_nac) THEN
          vb_tem_erros  := true;
          vc_linhas_ivc := vc_linhas_ivc || vr_inv_lin.nr_linha || ', ';
        END IF;
      END LOOP;

      IF (vc_ivc_atual IS null) OR (vc_ivc_atual <> vr_inv.invoice_num) THEN
        IF (vb_tem_erros) THEN
          IF (pn_evento_id IS null) THEN
            pn_evento_id := cmx_fnc_gera_evento (
                              'Inclusão de declaração de nacionalização de admissão temporária.'
                             , sysdate
                             , pn_user_id
                            );
          END IF;

          cmx_prc_gera_log_erros ( pn_evento_id
                                 , 'A declaração de nacionalização de adm. temporária não pode ser gerada, ' ||
                                   'pois as linhas ' || vc_linhas_ivc || ' da invoice ' || vr_inv.invoice_num || ' não foram ' ||
                                   'vinculadas na DA: ' || vn_nr_declaracao_da
                                 , 'E'
                                 , 'Vincule as linhas da invoice de nacionalização nas invoices da DA na tela de destinações.'
                               );

          vb_nao_gerar_nacionalizacao := true;
        END IF;

        vc_ivc_atual  := vr_inv.invoice_num;
        vc_linhas_ivc := null;
        vb_tem_erros  := false;
      END IF;

      -- segunda checagem: verificar se as quantidades inseridas nas invoices de
      -- nacionalizacao são as mesmas vinculadas nas destinacoes da DA.
      vn_qtde_invoice := null;
      OPEN  cur_valida_qtde_ivc_adm_temp (vr_inv.invoice_id);
      FETCH cur_valida_qtde_ivc_adm_temp INTO vn_qtde_invoice;
      CLOSE cur_valida_qtde_ivc_adm_temp;

      vn_qtde_destinada := null;
      OPEN  cur_valida_qtde_destino_admtmp (vr_inv.invoice_id);
      FETCH cur_valida_qtde_destino_admtmp INTO vn_qtde_destinada;
      CLOSE cur_valida_qtde_destino_admtmp;

      IF (nvl (vn_qtde_invoice, 0) <> nvl (vn_qtde_destinada, 0)) THEN
        IF (pn_evento_id IS null) THEN
          pn_evento_id := cmx_fnc_gera_evento (
                            'Inclusão de declaração de nacionalização de admissão temporária.'
                          , sysdate
                          , pn_user_id
                          );
        END IF;

        cmx_prc_gera_log_erros ( pn_evento_id
                              , 'A declaração de nacionalização de adm. temporária não pode ser gerada, ' ||
                                'pois a quantidade declarada na invoice ' || vr_inv.invoice_num || ' diverge da quantidade vinculada à DA.'
                              , 'E'
                              , 'Verifique a vinculação das quantidades das invoices de nacionalização na tela de destinações da DA.'
                            );

        vb_nao_gerar_nacionalizacao := true;
      END IF;
    END LOOP; -- FOR vr_inv IN cur_invoices LOOP

    IF (vb_nao_gerar_nacionalizacao) THEN
      vc_step_error := 'Ocorreram erros durante a geração de declaração, verifique o log de erros no. ' || pn_evento_id;
      RAISE ve_nac_adm_temp;
    END IF;
  END IF; -- IF (cmx_pkg_tabelas.codigo (pn_tp_declaracao_id) = '13') THEN

  /* A cmx_tabela 101, é a tabela que mantem os tipos de declaracao. Nela, também informamos um CFOP padrão para
     substituir os CFOPs deduzidos aqui a partir da linha da invoice. Ex: quando a importacao é "05 - Admissao
     temporaria", o CFOP das linhas deve ser "3930 - Lancamento efetuado a titulo de entrada de bem sob amparo de
     regime especial aduaneiro de admissao temporaria", portanto, quando incluirmos uma declaracao aqui e ela tiver
     um CFOP padrão, iremos utiliza-lo, sobrescrevendo o que deduzirmos da invoice.
  */
  OPEN  cur_cfop_id_padrao;
  FETCH cur_cfop_id_padrao INTO vn_cfop_id_padrao;
  CLOSE cur_cfop_id_padrao;

  /*
    Verificando se é um embarque de transferencia para chamar a rotina responsavel por gerar as linhs de declaracao
    baseadas nas vinculações (consumos) gerados com a transferenica
  */
  OPEN  cur_transferencia;
  FETCH cur_transferencia INTO vc_dtr_numero, vc_novo_regime;
  CLOSE cur_transferencia;

  IF( vc_dtr_numero IS NOT null ) AND ( nvl (cmx_pkg_tabelas.auxiliar (pn_tp_declaracao_id,4), 'XX') <> nvl (vc_novo_regime,'XX' ) ) THEN
    raise_application_error (-20000, 'Embarque de transferencia para ' || vc_novo_regime || ' não pode gerar declaração com tipo ' || cmx_pkg_tabelas.descricao( pn_tp_declaracao_id ) ||'.' );
  END IF;

  vc_step_error := 'cur_declaracoes_header';
  OPEN  cur_declaracoes_header;
  FETCH cur_declaracoes_header INTO vt_cdh;
  CLOSE cur_declaracoes_header;
  vc_step_error := null;

  vc_step_error := 'cur_declaracoes_header_licenca';
  OPEN  cur_declaracoes_header_licenca;
  FETCH cur_declaracoes_header_licenca INTO vt_cdhl;
  vb_achou_licenca := cur_declaracoes_header_licenca%FOUND;
  CLOSE cur_declaracoes_header_licenca;
  vc_step_error := null;

  IF (vt_cdh.urfe_id IS NOT NULL) THEN
    vn_urfe_id := vt_cdh.urfe_id;
  ELSIF (vb_achou_licenca) THEN
    vn_urfe_id := vt_cdhl.urfe_id;
  END IF;

  /* Iniciaremos aqui, a geracao da Declaracao, comecando com a criacao de seu cabecalho
     gravando as informacoes basicas necessarias, no entanto, criaremos seu cabecalho apenas
     se estivermos criando uma nova Declaracao, pois se o usuario estiver utilizando a opcao
     de "Adiconar Invoice" estamos apenas inserindo as linhas da invoice em uma declaracao
     ja existente. Neste caso o parametro pn_invoice_id esta preenchido.
  */
  IF (pn_invoice_id IS NOT null) OR (pn_declaracao_id IS NOT NULL)  THEN
     /* Devo, quando temos parametro de invoice, obter o id da Declaracao que ja existe e nao
        criar novo cabecalho de Declaracao
     */
     vn_declaracao_id := pn_declaracao_id;
  ELSE
    /* Se o parametro de invoice estiver nulo, significa que estamos criando uma nova
       declaracao para o embarque
    */
    vc_step_error := 'cur_declaracao_id';
    OPEN  cur_declaracao_id;
    FETCH cur_declaracao_id INTO vn_declaracao_id;
    CLOSE cur_declaracao_id;
    vc_step_error := null;

    /* pn_declaracao_id é um parametro IN OUT, para retornar ao form chamador, o ID da
      declaracao
    */
    pn_declaracao_id := vn_declaracao_id;

    /* Verifica a existência de transferência de regime para o embarque que está
       gerando a declaração e gera o conhecimento de transporte se for o caso.
    */
    vc_step_error := 'Gerando o conhecimento de DTR';
    prc_gerar_conhec_dtr;
    vc_step_error := null;

    --URFD/RECINTO/SETOR informados no embarque.
    OPEN  cur_urfd_rec_setor_ebq;
    FETCH cur_urfd_rec_setor_ebq INTO vn_urfd_ebq_id
                                    , vn_rec_alfand_id
                                    , vn_setor_armazem_id;
    CLOSE cur_urfd_rec_setor_ebq;

    /*
    --A URFD vem da licença.
    vn_urfd_id := vt_cdhl.urfd_id;
    --Se a URFD for nula virá do embarque.
    IF (vn_urfd_id IS null) THEN
      vn_urfd_id := vn_urfd_ebq_id;
      --Se não estiver preenchido no embarque será o mesmo que a URFE.
      IF (vn_urfd_id IS null) THEN
        vn_urfd_id := vn_urfe_id;
      END IF;
    END IF;
    Não é mais assim. Agora, a URFD vem do embarque.
    */
    vn_urfd_id := vn_urfd_ebq_id;

    -- Se os dados logistico de [FUNDAP] e [TRANDING] forem preenchidos no embarque,
    -- esses dados serão carregados na geração da DI.
    OPEN  cur_dados_logistico_ebq;
    FETCH cur_dados_logistico_ebq INTO vc_operacao_fundap
                                     , vn_trading_site_id
                                     , vn_trading_id;
    CLOSE cur_dados_logistico_ebq;

    --- Se vier do parametro o urfd/recinto/setor será utilizado caso contrario segue a logica
    --- abaixo. Atentar para carregar os armazens da DA qdo recof
    vc_step_error := 'recinto/setor/armazem';
    OPEN  cur_tabelas (vn_urfe_id);
    FETCH cur_tabelas INTO vn_rec_alfand_tab_id, vn_setor_armazem_tab_id, vc_armazem;
    CLOSE cur_tabelas;

    --Se o RECINTO não estiver informado no embarque receberá o valor da tabela do sistema nº115 (relativo a URFE).
    --Removido por UHK
    /*IF (vn_rec_alfand_id IS null) THEN
      vn_rec_alfand_id := vn_rec_alfand_tab_id;
      UPDATE imp_embarques
         SET rec_alfand_id = vn_rec_alfand_id
       WHERE embarque_id   = pn_embarque_id;

    END IF;*/

    --Se o SETOR não estiver informado no embarque receberá o valor da tabela do sistema nº116 (relativo a URFE).
    --Removido por UHK
    /*IF (vn_setor_armazem_id IS null) THEN
      vn_setor_armazem_id := vn_setor_armazem_tab_id;
      UPDATE imp_embarques
         SET setor_armazem_id = vn_setor_armazem_id
       WHERE embarque_id      = pn_embarque_id;

    END IF;*/
    vc_step_error := null;

    vc_step_error := 'cur_perc_seguro';
    OPEN  cur_perc_seguro (vt_cdh.via_transporte_id);
    FETCH cur_perc_seguro INTO vn_perc_seguro;
    CLOSE cur_perc_seguro;
    vc_step_error := null;

    OPEN  cur_nac;
    FETCH cur_nac INTO vc_nac;
    CLOSE cur_nac;

    --se o despachante foi informado no embarque ele deve ser populado na geração da declaracao
    /*IF (Nvl (vc_nac, '*') = 'NAC') THEN
      OPEN  cur_despachante_ebq_nac;
      FETCH cur_despachante_ebq_nac INTO vn_despachante_id, vn_despachante_site_id;
      CLOSE cur_despachante_ebq_nac;
      vc_step_error := null;
    ELSE*/ -- Comentado (delivery 97994) para carregar despachante dos dados logisticos mesmo nos casos de nacionalização em que o campo "DA_ID" nao esta preenchido.
      OPEN  cur_despachante_ebq;
      FETCH cur_despachante_ebq INTO vn_despachante_id, vn_despachante_site_id;
      CLOSE cur_despachante_ebq;
      vc_step_error := null;
    --END IF;

    --se o despachante não foi informado no embarque ele deve ser populado pelos parametros da importacao
    IF (vn_despachante_id IS NULL AND vn_despachante_site_id IS NULL) THEN
      OPEN  cur_despachante;
      FETCH cur_despachante INTO vn_despachante_id, vn_despachante_site_id;
      CLOSE cur_despachante;
      vc_step_error := null;
    END IF;

    vc_step_error := 'Loop no cursor do pais de procedencia da mercadoria.';

    OPEN cur_pais_proc;
    FETCH cur_pais_proc INTO vn_pais_id;
    CLOSE cur_pais_proc;

    IF vn_pais_id IS NULL THEN
      OPEN  cur_pais;
      LOOP
        FETCH cur_pais INTO vn_pais_id;
        IF (cur_pais%rowcount > 1) THEN
          vn_pais_id := null;
        END IF;
        EXIT WHEN cur_pais%notfound;
      END LOOP;
      CLOSE cur_pais;
    END IF;

    vc_step_error := null;

    IF (Nvl (vc_nac, '*') = 'NAC') THEN
      vc_step_error := 'cur_add_info_nac';
      OPEN  cur_add_info_nac;
      FETCH cur_add_info_nac INTO vn_urfd_id
                                , vn_urfe_id
                                , vn_rec_alfand_id
                                , vn_setor_armazem_id
                                , vc_armazem
                                , vn_tp_manifesto
                                , vc_nr_manifesto;
      CLOSE cur_add_info_nac;
      vc_step_error := null;
    ELSE
      /* se for uma nacionalizacao em entreposto aduaneiro, serão preenchidos os campos
         urfd, urfe, armazem setor e recinto.
      */
      IF (pn_da_id IS NOT null)
         AND (cmx_pkg_tabelas.codigo (pn_tp_declaracao_id) = '15' OR (cmx_pkg_tabelas.codigo (pn_tp_declaracao_id) = '14' AND Nvl(pc_nac_sem_vinc_admissao,'N') = 'N'))
      THEN
        vc_step_error := 'cur_add_info_nacionalizacao';

        OPEN  cur_add_info_nacionalizacao (pn_da_id);
        FETCH cur_add_info_nacionalizacao INTO vn_urfd_id
                                             , vn_urfe_id
                                             , vn_rec_alfand_id
                                             , vn_setor_armazem_id
                                             , vc_armazem
                                             , vn_tp_manifesto
                                             , vc_nr_manifesto;
        CLOSE cur_add_info_nacionalizacao;
        vc_step_error := null;
      END IF;
    END IF;

    OPEN  cur_di_unica;
    FETCH cur_di_unica INTO vc_aux;
    CLOSE cur_di_unica;

    IF (Nvl(vc_aux, '*') = 'DI_UNICA') THEN
      OPEN  cur_doc_chegada;
      FETCH cur_doc_chegada INTO vc_nr_manifesto_conhec, vn_tp_manifesto_conhec;
      CLOSE cur_doc_chegada;

      IF (vn_tp_manifesto_conhec IS NOT null) THEN
        vc_cod_doc_aduaneiro := cmx_pkg_tabelas.codigo(vn_tp_manifesto_conhec);

        IF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) = 'MANIFESTO') THEN
           vn_tp_manifesto_conhec := 1;
        ELSIF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) = 'TERMO') THEN
           vn_tp_manifesto_conhec := 2;
        ELSIF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) = 'DTA') THEN
           vn_tp_manifesto_conhec := 3;
        ELSIF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) IN ('MIC','MIC/DTA')) THEN
           vn_tp_manifesto_conhec := 4;
        ELSE
           vn_tp_manifesto_conhec := NULL;
        END IF;
      END IF;

      OPEN  cur_urfe_di_unica;
      FETCH cur_urfe_di_unica INTO vn_urfe_id;
      CLOSE cur_urfe_di_unica;

    ELSE
      vc_nr_manifesto_conhec := vt_cdh.nr_manifesto;


      IF (vt_cdh.tp_manifesto_id IS NOT null) THEN

        vc_cod_doc_aduaneiro := cmx_pkg_tabelas.codigo(vt_cdh.tp_manifesto_id);

        IF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) = 'MANIFESTO') THEN
           vn_tp_manifesto_conhec := 1;
        ELSIF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) = 'TERMO') THEN
           vn_tp_manifesto_conhec := 2;
        ELSIF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) = 'DTA') THEN
           vn_tp_manifesto_conhec := 3;
        ELSIF (cmx_pkg_tabelas.auxiliar  ('197', vc_cod_doc_aduaneiro, 1) IN ('MIC','MIC/DTA')) THEN
           vn_tp_manifesto_conhec := 4;
        ELSE
           vn_tp_manifesto_conhec := NULL;
        END IF;

      ELSE
        vn_tp_manifesto_conhec := NULL;
      END IF;
    END IF;

    OPEN cur_contr_rpt;
    FETCH cur_contr_rpt INTO vn_prazo_requerido;
    CLOSE cur_contr_rpt;

    /*Verifica se a empresa é do tipo trading*/
    OPEN cur_trading;
    FETCH cur_trading INTO vc_trading;
    CLOSE cur_trading;

    OPEN cur_nac_de_terc;                      --110918
    FETCH cur_nac_de_terc INTO vc_tp_embarque_nac;
    CLOSE cur_nac_de_terc;

    OPEN cur_peso_nac;                          --110918
    FETCH cur_peso_nac INTO vn_peso_bruto_nac, vn_peso_liq_nac;
    CLOSE cur_peso_nac;

    /* Verificar o tipo da conta */
    vc_tp_conta := NULL;
    IF(vt_cdh.banco_agencia_id IS NOT NULL AND vt_cdh.nr_conta_id IS NOT NULL) THEN
      OPEN  cur_tp_conta(vt_cdh.banco_agencia_id, vt_cdh.nr_conta_id);
      FETCH cur_tp_conta INTO vc_tp_conta;
      CLOSE cur_tp_conta;
    END IF;

    vc_step_error := 'Insert into imp_declaracoes';
    INSERT INTO imp_declaracoes (
       declaracao_id        /* 01 */
     , empresa_id           /* 02 */
     , embarque_id          /* 03 */
     , dsi                  /* 04 */
     , tp_declaracao_id     /* 05 */
     , urfe_id              /* 06 */
     , urfd_id              /* 07 */
     , rec_alfand_id        /* 08 */
     , setor_armazem_id     /* 09 */
     , operacao_fundap      /* 10 */
     , banco_agencia_id     /* 11 */
     , conta_id             /* 12 */
     , moeda_frete_id       /* 13 */
     , vrt_fr_m             /* 14 */
     , moeda_seguro_id      /* 15 */
     , vrt_sg_m             /* 16 */
     , util_conhec          /* 17 */
     , referencia           /* 18 */
     , creation_date        /* 19 */
     , created_by           /* 20 */
     , last_update_date     /* 21 */
     , last_updated_by      /* 22 */
     , grupo_acesso_id      /* 23 */
     , despachante_id       /* 24 */
     , despachante_site_id  /* 25 */
     , pais_proc_id         /* 26 */
     , da_id                /* 27 */
     , fins_de_exportacao   /* 28 */
     , fins_cambiais        /* 29 */
     , tp_manifesto         /* 30 */
     , nr_manifesto         /* 31 */
     --, da_outro_importador  /* 32 */
     , tp_consignatario     /* 33 */
     , consignatario_site_id   /* 34 */
     , consignatario_id       /* 35 */
     , nac_sem_vinc_admissao /* 36 */
     , trading               /* 37 */
     , tempo_permanencia      /* 38 */
     , peso_bruto_nac         /* 39 */ --110918
     , peso_liquido_nac       /* 40 */ --110918
     , tp_conta               /* 41 */
    )
    VALUES (
       vn_declaracao_id                                         /* 01 */
     , pn_empresa_id                                            /* 02 */
     , pn_embarque_id                                           /* 03 */
     , pc_flag_dsi                                              /* 04 */
     , pn_tp_declaracao_id                                      /* 05 */
     , vn_urfe_id                                               /* 06 */
     , vn_urfd_id                                               /* 07 */
     , vn_rec_alfand_id                                         /* 08 */
     , vn_setor_armazem_id                                      /* 09 */
     , nvl(vc_operacao_fundap, 'N')                             /* 10 */
     , vt_cdh.banco_agencia_id                                  /* 11 */
     , vt_cdh.nr_conta_id                                       /* 12 */
     , vt_cdh.moeda_id                                          /* 13 */
     , vt_cdh.valor_total_m                                     /* 14 */
     , vt_cdh.moeda_seguro_id                                   /* 15 */
     , vt_cdh.vrt_sg_m                                          /* 16 */
     , 1                                                        /* 17 */
     , pc_referencia                                            /* 18 */
     , sysdate                                                  /* 19 */
     , pn_user_id                                               /* 20 */
     , sysdate                                                  /* 21 */
     , pn_user_id                                               /* 22 */
     , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')  /* 23 */
     , vn_despachante_id                                        /* 24 */
     , vn_despachante_site_id                                   /* 25 */
     , vn_pais_id                                               /* 26 */
     , pn_da_id                                                 /* 27 */
     , nvl (pc_fins_de_exportacao, 'N')                         /* 28 */
     , nvl (pc_fins_cambiais, 'N')                              /* 29 */
     , nvl (vn_tp_manifesto, vn_tp_manifesto_conhec)            /* 30 */
     , nvl (vc_nr_manifesto, vc_nr_manifesto_conhec)            /* 31 */
     --, vc_da_outro_importador                                   /* 32 */
     , decode(vn_trading_id, NULL, 1, 2)                   /* 33 */
     , vn_trading_site_id                                       /* 34 */
     , Decode(Nvl(vc_trading,'N'),'N',vn_trading_id,NULL)       /* 35 */
     , Nvl(pc_nac_sem_vinc_admissao,'N')                        /* 36 */
     , vc_trading                                               /* 37 */
     , vn_prazo_requerido                                       /* 38 */
     , Decode(vc_tp_embarque_nac,'NAC_DE_TERC',vn_peso_bruto_nac,NULL) /* 39 */ --110918
     , Decode(vc_tp_embarque_nac,'NAC_DE_TERC',vn_peso_liq_nac,NULL) /* 40 */ --110918
     , vc_tp_conta                                                   /* 41 */
    );
    vc_step_error := 'Trecho documentos despacho';
    -- Trecho da inserção dos dados do documento do despacho.
    OPEN cur_dcl_doc_desp(NULL);
    FETCH cur_dcl_doc_desp INTO vc_nr_documento
                              , vn_documento_id
                              , vn_invoice_id
                              , vn_conhec_id
                              , vc_house_conhec
                              , vc_master_conhec;
    vb_achou_docs := cur_dcl_doc_desp%FOUND;
    CLOSE cur_dcl_doc_desp;

    IF (vb_achou_docs) THEN

      IF (Nvl (vc_nac, '*') = 'NAC') THEN
        OPEN  cur_conhec_nac;
        FETCH cur_conhec_nac INTO vn_conhec_id
                                , vc_house_conhec
                                , vc_master_conhec;
        CLOSE cur_conhec_nac;
      END IF;

      IF (Nvl(vc_aux, '*') = 'DI_UNICA') THEN
        OPEN  cur_conhec_di_unica;
        FETCH cur_conhec_di_unica INTO vn_conhec_id
                                     , vc_house_conhec
                                     , vc_master_conhec;
        CLOSE cur_conhec_di_unica;
      END IF;

      OPEN cur_verif_tp_via(vn_conhec_id);
     FETCH cur_verif_tp_via INTO vn_via_transporte_id;
     CLOSE cur_verif_tp_via;

      -- Verifica se tem conhecimento de transporte no embarque.
      IF (vn_conhec_id IS NOT NULL) THEN

        IF (Nvl(cmx_fnc_profile('IMP_ENVIA_HOUSE_E_MASTER_ESTR_PROPRIA'), 'N') = 'N') THEN

          INSERT INTO imp_dcl_dcto_instr (
            declaracao_id
          , tp_documento_id
          , nr_documento
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          , dcl_dcto_instr_id
          , conhec_id
          , grupo_acesso_id
          )VALUES(
            vn_declaracao_id
          , cmx_pkg_tabelas.tabela_id('110','28')
          , vc_house_conhec
          , SYSDATE
          , 0
          , SYSDATE
          , 0
          , cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
          , vn_conhec_id
          , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
          );

          vn_cont_total_docs := vn_cont_total_docs+1;

        ELSIF (cmx_fnc_profile ('IMP_ENVIA_HOUSE_E_MASTER_ESTR_PROPRIA') = 'S') THEN

          IF (length (vc_house_conhec || '/' || vc_master_conhec) <= 25) THEN
            vc_house_conhec := vc_house_conhec|| '/' || vc_master_conhec;
          ELSE
            raise_application_error(-20000, 'A concatenação de HOUSE + MASTER é maior que 25 caracteres.'
                                        || ' A profile IMP_ENVIA_HOUSE_E_MASTER_ESTR_PROPRIA está parametrizada para realizar essa concatenação.'
                                        || ' Modifique a profile para separar house e master ou corrija a sua numeração de HOUSE / MASTER.'
                                        || ' Não foram inseridos automaticamente os documentos de instrução de despacho.'
                                  );
          END IF;

          INSERT INTO imp_dcl_dcto_instr (
            declaracao_id
          , tp_documento_id
          , nr_documento
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          , dcl_dcto_instr_id
          , conhec_id
          , grupo_acesso_id
          )VALUES(
            vn_declaracao_id
          , cmx_pkg_tabelas.tabela_id('110','28')
          , vc_house_conhec
          , SYSDATE
          , 0
          , SYSDATE
          , 0
          , cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
          , vn_conhec_id
          , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
          );

          vn_cont_total_docs := vn_cont_total_docs+1;

        ELSIF(cmx_fnc_profile ('IMP_ENVIA_HOUSE_E_MASTER_ESTR_PROPRIA') = 'L') THEN

          INSERT INTO imp_dcl_dcto_instr (
            declaracao_id
          , tp_documento_id
          , nr_documento
          , creation_date
          , created_by
          , last_update_date
          , last_updated_by
          , dcl_dcto_instr_id
          , conhec_id
          , grupo_acesso_id
          )VALUES(
            vn_declaracao_id
          , cmx_pkg_tabelas.tabela_id('110','28')
          , vc_house_conhec
          , SYSDATE
          , 0
          , SYSDATE
          , 0
          , cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
          , vn_conhec_id
          , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
          );

          vn_cont_total_docs := vn_cont_total_docs+1;

          IF (vc_master_conhec IS NOT NULL AND vc_master_conhec <> vc_house_conhec) THEN
            INSERT INTO imp_dcl_dcto_instr (
              declaracao_id
            , tp_documento_id
            , nr_documento
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            , dcl_dcto_instr_id
            , conhec_id
            , grupo_acesso_id
            )VALUES(
              vn_declaracao_id
            , cmx_pkg_tabelas.tabela_id('110','28')
            , vc_master_conhec
            , SYSDATE
            , 0
            , SYSDATE
            , 0
            , cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
            , vn_conhec_id
            , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
            );

            vn_cont_total_docs := vn_cont_total_docs+1;

          END IF;

        END IF; -- if profile

      END IF;

      FOR c1 IN cur_doc_cert_orig
      LOOP
        INSERT INTO imp_dcl_dcto_instr (
                declaracao_id
              , tp_documento_id
              , nr_documento
              , creation_date
              , created_by
              , last_update_date
              , last_updated_by
              , dcl_dcto_instr_id
              , conhec_id
              , grupo_acesso_id
              )VALUES(
                vn_declaracao_id
              , cmx_pkg_tabelas.tabela_id('110','02')
              , c1.cert_origem_numero
              , SYSDATE
              , 0
              , SYSDATE
              , 0
              , cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
              , vn_conhec_id
              , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
              );

              vn_cont_total_docs := vn_cont_total_docs+1;

      END LOOP;

      FOR c1 IN cur_doc_cert_orig_sem_li (vn_declaracao_id)
      LOOP
        INSERT INTO imp_dcl_dcto_instr (
                declaracao_id
              , tp_documento_id
              , nr_documento
              , creation_date
              , created_by
              , last_update_date
              , last_updated_by
              , dcl_dcto_instr_id
              , conhec_id
              , grupo_acesso_id
              )VALUES(
                vn_declaracao_id
              , cmx_pkg_tabelas.tabela_id('110','02')
              , c1.cert_origem_numero
              , SYSDATE
              , 0
              , SYSDATE
              , 0
              , cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
              , vn_conhec_id
              , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
              );

              vn_cont_total_docs := vn_cont_total_docs+1;

      END LOOP;

      vn_cont_fat_comercial := 0;
      vn_cont_fat_remessa   := 0;

      SELECT COUNT(1)
        INTO vn_cont_fat_comercial
        FROM imp_invoices ivc
       WHERE ivc.embarque_id = pn_embarque_id;

      SELECT COUNT(1)
        INTO vn_cont_fat_remessa
        FROM imp_po_remessa re
           , imp_invoices   inv
       WHERE re.embarque_id   = pn_embarque_id
         AND re.po_remessa_id = inv.remessa_id
         AND re.nr_remessa    = '1';

      IF (vn_cont_fat_comercial + vn_cont_total_docs + vn_cont_fat_remessa > 30) THEN
        FOR c_tp IN cur_tipos_doc LOOP
          vc_inv_concat        := NULL;
          vn_ivc_id            := NULL;
          vn_dcl_dcto_instr_id := NULL;
          vb_inserir           := TRUE;
          FOR v_cur IN cur_dcl_doc_desp (c_tp.tabela_id) LOOP
            vn_cont_comp := vn_cont_comp+1;
            IF (vb_inserir) THEN
              vn_dcl_dcto_instr_id := cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1');
              INSERT INTO imp_dcl_dcto_instr(
                  dcl_dcto_instr_id
                , declaracao_id
                , tp_documento_id
                , nr_documento
                , creation_date
                , created_by
                , last_update_date
                , last_updated_by
                , grupo_acesso_id
              ) VALUES (
                  vn_dcl_dcto_instr_id
                , vn_declaracao_id
                , cmx_pkg_tabelas.tabela_id('110','01')
                , Nvl (vc_inv_concat, v_cur.invoice_num)
                , sysdate
                , 0
                , sysdate
                , 0
                , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
              );
              IF (vn_ivc_id IS NOT NULL) THEN
                INSERT INTO imp_invoices_dcl_dcto_instr(
                    invoices_dcl_dcto_instr_id
                  , dcl_dcto_instr_id
                  , invoice_id
                  , invoice_num
                ) VALUES (
                    cmx_fnc_proxima_sequencia('imp_inv_dcl_dcto_instr_sq1')
                  , vn_dcl_dcto_instr_id
                  , vn_ivc_id
                  , vc_inv_concat
                );
                vn_ivc_id := NULL;
              END IF;
              vb_inserir := FALSE;
            END IF;
            IF (Length (vc_inv_concat ||','|| v_cur.invoice_num) <= 25) THEN
              IF(vc_inv_concat IS NOT NULL) THEN
                vc_inv_concat := vc_inv_concat||','||v_cur.invoice_num;
              ELSE
                vc_inv_concat := v_cur.invoice_num;
              END IF;

              INSERT INTO imp_invoices_dcl_dcto_instr(
                  invoices_dcl_dcto_instr_id
                , dcl_dcto_instr_id
                , invoice_id
                , invoice_num
              ) VALUES (
                  cmx_fnc_proxima_sequencia('imp_inv_dcl_dcto_instr_sq1')
                , vn_dcl_dcto_instr_id
                , v_cur.invoice_id
                , v_cur.invoice_num
              );

              UPDATE imp_dcl_dcto_instr
                 SET nr_documento = vc_inv_concat
               WHERE dcl_dcto_instr_id = vn_dcl_dcto_instr_id;

            ELSE
              vc_inv_concat := v_cur.invoice_num;
              vn_ivc_id     := v_cur.invoice_id;
              vb_inserir    := TRUE;

            END IF;

            --Verifica se é o último registro
            IF(vn_cont_fat_comercial + vn_cont_fat_remessa = vn_cont_comp AND vn_ivc_id IS NOT NULL) THEN
              INSERT INTO imp_dcl_dcto_instr(
                    dcl_dcto_instr_id
                  , declaracao_id
                  , tp_documento_id
                  , nr_documento
                  , invoice_id
                  , creation_date
                  , created_by
                  , last_update_date
                  , last_updated_by
                  , grupo_acesso_id
                ) VALUES (
                    cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
                  , vn_declaracao_id
                  , cmx_pkg_tabelas.tabela_id('110','01')
                  , v_cur.invoice_num
                  , v_cur.invoice_id
                  , sysdate
                  , 0
                  , sysdate
                  , 0
                  , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
                );
            END IF;

          END LOOP;
        END LOOP;
      ELSE
        FOR v_cur IN cur_dcl_doc_desp (NULL) LOOP
          -- Se caso tiver nulo o tp_documento da invoice, por padrão é fatura comercial.
          INSERT INTO imp_dcl_dcto_instr
            ( dcl_dcto_instr_id
            , declaracao_id
            , tp_documento_id
            , nr_documento
            , creation_date
            , created_by
            , last_update_date
            , last_updated_by
            , invoice_id
            , grupo_acesso_id)
          VALUES
            ( cmx_fnc_proxima_sequencia('imp_dcl_dcto_instr_sq1')
            , vn_declaracao_id
            , v_cur.tp_documento_id
            , v_cur.invoice_num
            , sysdate
            , 0
            , sysdate
            , 0
            , v_cur.invoice_id
            , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id'));

        END LOOP;
      END IF;
    END IF;

    FOR vr_rcr IN cur_rcr LOOP
      INSERT INTO imp_dcl_processo (
         declaracao_id
       , tp_processo
       , nr_processo
       , creation_date
       , created_by
       , last_update_date
       , last_updated_by
       , grupo_acesso_id
       )
      VALUES (
         vn_declaracao_id
       , '1' -- Processo Administrativo
       , vr_rcr.processo_numero
       , sysdate
       , pn_user_id
       , sysdate
       , pn_user_id
       , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')
      );
    END LOOP;

    vc_step_error := null;
  END IF;/* (pn_invoice_id IS NOT null) */

  --Irá criar o armazém na declaração referente ao informado no embarque.
  -- SO SE FOR DI

  IF (Nvl(pc_flag_dsi, 'N') = 'N') THEN
    FOR vr_armaz IN cur_armaz_ebq
    LOOP
      BEGIN
        INSERT INTO imp_dcl_armazem (
          declaracao_id                /* 01 */
        , cd_armazem                   /* 02 */
        , creation_date                /* 03 */
        , created_by                   /* 04 */
        , last_update_date             /* 05 */
        , last_updated_by              /* 06 */
        , grupo_acesso_id              /* 07 */
        )
        VALUES (
          vn_declaracao_id                                        /* 01 */
        , vr_armaz.cd_armazem                                     /* 02 */
        , sysdate                                                 /* 03 */
        , pn_user_id                                              /* 04 */
        , sysdate                                                 /* 05 */
        , pn_user_id                                              /* 06 */
        , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id') /* 07 */
        );
      EXCEPTION
        WHEN dup_val_on_index THEN
          null;
      END;

      vc_armazem := null;
    END LOOP;

    --Caso não tenha sido informado nada no embarque para o armazém o mesmo virá do auxiliar3 da tabela de URFE.
    IF (vc_armazem IS NOT null) THEN
      INSERT INTO imp_dcl_armazem (
        declaracao_id                /* 01 */
      , cd_armazem                   /* 02 */
      , creation_date                /* 03 */
      , created_by                   /* 04 */
      , last_update_date             /* 05 */
      , last_updated_by              /* 06 */
      , grupo_acesso_id              /* 07 */
      )
      VALUES (
        vn_declaracao_id                                        /* 01 */
      , vc_armazem                                              /* 02 */
      , sysdate                                                 /* 03 */
      , pn_user_id                                              /* 04 */
      , sysdate                                                 /* 05 */
      , pn_user_id                                              /* 06 */
      , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id') /* 07 */
      );
    END IF;
  END IF;

  /* Iremos gravar as linhas da declaracao em duas fases.
     Na primeira fase: iremos gravar como linhas de declaracao, as linhas das invoices
     que tem saldo e cujo tipo seja igual a "Mercadoria".
     Na segunda fase: iremos gravar, se houver, as linhas de licenca que ja tem seu numero de
     registro. Nesta fase iremos utilizar um cursor que ja traz as
     licencas (das linhas das invoices do embarque em evidencia) que tem registro.
     As licencas que ainda nao tem registro serao inseridas como linhas de declaracao atraves
     de triggers de controle no momento da atualizacao do nr. de registro na imp_licencas.
  */

  /* verificamos se o embarque permitira a busca de excecoes fiscais para dcl de admissao */
  vc_step_error := 'cur_excecao_por_tp_ebq';
  OPEN  cur_excecao_por_tp_ebq;
  FETCH cur_excecao_por_tp_ebq INTO vr_excecao_por_tp_ebq;
  vb_achou_excecao_por_ebq := cur_excecao_por_tp_ebq%FOUND;
  CLOSE cur_excecao_por_tp_ebq;

  /* Obtemos a alíquota de icms do cadastro de parâmetros de empresa. */
  vc_step_error := 'cur_icms';
  OPEN  cur_icms;
  FETCH cur_icms INTO vn_icms_empresas_param
                    , vc_icms_diferido
                    , vn_aliq_icms_fecp_param
                    , vc_suspende_icms_recof
                    , vc_tratar_icms_deso_emiss_nfe;
  CLOSE cur_icms;
  vc_step_error := null;

  /* Para os inserts abaixo, devo buscar na cmx_tabelas os IDs de regime de tributacao de II,
     IPI e ICMS para os codigo 1 (Integral II), 4 (Integral IPI) e 1 (Integral ICMS) e nos
     casos de admissão todos os regimes de suspensão.

     Para DI os tipos de declaracao de admissão são 02, 03, 04, 05, 06, 07, 08, 09 e 10
     e para DSI somente o tipo 09 é admissão...
  */

  OPEN cur_dados_embarque;
  FETCH cur_dados_embarque INTO vc_tp_embarque, vc_tp_fixo, vc_codigo_tp_embarque;
  CLOSE cur_dados_embarque;

  IF ( nvl(pc_flag_dsi, 'N') = 'S' AND vc_tp_declaracao  = '09' ) OR
     ( nvl(pc_flag_dsi, 'N') = 'N' AND vc_tp_declaracao IN ('02','03','04','05','06','07','08','09','10','11')
                           AND Nvl(vc_tp_embarque,'null') NOT IN ('MISTO','RECOF'))
  THEN
    vc_regtrib_ii         := '5'; -- suspensao
    vc_regtrib_ipi        := '5'; -- suspensao
    vc_regtrib_icms       := '5'; -- suspensao
    vc_regtrib_pis_cofins := '2'; -- suspensao
  ELSE
    vc_regtrib_ii         := '1'; -- integral
    vc_regtrib_ipi        := '4'; -- integral
    vc_regtrib_icms       := '1'; -- integral
    vc_regtrib_pis_cofins := '3'; -- integral

    IF (nvl(vc_icms_diferido,'N') = 'S') THEN
      vc_regtrib_icms := '6'; -- diferimento
    END IF;
  END IF;

  vc_step_error := 'cur_reg_trib - II';
  vn_id_regtrib_ii_def := cmx_pkg_tabelas.tabela_id ('104', vc_regtrib_ii); -- II
  vc_step_error := null;

  vc_step_error := 'cur_reg_trib - IPI';
  vn_id_regtrib_ipi_def := cmx_pkg_tabelas.tabela_id ('105', vc_regtrib_ipi); -- IPI
  vc_step_error := null;


  vc_step_error := 'cur_reg_trib - ICMS';
  vn_id_regtrib_icms_def := cmx_pkg_tabelas.tabela_id ('132', vc_regtrib_icms); -- ICMS
  vc_step_error := null;

  vc_step_error := 'cur_reg_trib - PIS/COFINS';
  vn_id_regtrib_pis_cofins_def := cmx_pkg_tabelas.tabela_id ('141', vc_regtrib_pis_cofins); -- PIS/COFINS
  vc_step_error := null;


  /* Devo dar um lock nas linhas da DI para eu poder sequenciar a sua numeracao de forma a
     manter a unicidade da informacao (linha_num). O lock so sera liberado no COMMIT ou
     ROLLBACK no final da rotina
  */
  OPEN  cur_lock_declaracoes_lin;
  CLOSE cur_lock_declaracoes_lin;
  OPEN  cur_max_lin_num_di;
  FETCH cur_max_lin_num_di into vn_linha_num;
  CLOSE cur_max_lin_num_di;

  /* Varre todas as invoices do embarque, ou, seleciona uma invoice em especifico
  */
  FOR ci IN cur_invoices LOOP
    /* Obtem o pais do exportador da invoice se precisar utiliza-lo nas linhas
    */
    vc_step_error := 'cur_pais_export';
    OPEN  cur_pais_export (ci.invoice_id, ci.export_id, ci.export_site_id);
    FETCH cur_pais_export into vn_pais_export_id_invoice;
    CLOSE cur_pais_export;
    vc_step_error := null;

    -- Validando se haverá estouro de saldo das previsões de Drawback para invoices
    -- que já possuem o número do ato preenchido
    -- Pois se o número do ato estiver preenchido não permite inserção da DI
    -- e loga todos os componentes que não possuem saldo suficiente

    IF NOT (vb_li_drw_po_sem_saldo) AND (nvl (pc_gera_li_drawback, 'N') = 'S') THEN
      FOR c IN cur_resumo_das_dis (ci.invoice_id) LOOP
        -- Sai assim que descobre qqr linha sem saldo suficiente, pois as mensagens
        -- já foram logadas para todas as linhas, e se tiver pelo menos uma é
        -- necessário dar o RAISE
        EXIT WHEN vb_li_drw_po_sem_saldo = TRUE;

        vc_step_error := 'Buscando ato concessório da linha do pedido.';

        vn_rd_id := NULL;
        OPEN  cur_po_rd_id (c.po_linha_id);
        FETCH cur_po_rd_id INTO vn_rd_id;
        CLOSE cur_po_rd_id;

        IF (vn_rd_id IS NOT NULL) THEN
          OPEN  cur_saldo_drw_item (vn_rd_id, c.item_id, vc_trunca_saldo_drw, vn_trunca_saldo_drw_qtde_casas);
          FETCH cur_saldo_drw_item INTO vn_qtde_saldo_drw;
          CLOSE cur_saldo_drw_item;

          BEGIN
            vb_achou := true;
            vn_fator_conversao_drw := drw_fnc_calc_fator_conversao (
                                         c.item_id
                                       , c.un_medida_id
                                       , vn_rd_id
                                       , 'I'
                                      );
          EXCEPTION
            WHEN others THEN

            IF pn_evento_id IS null THEN
              pn_evento_id := cmx_fnc_gera_evento(
                                'Criação automática de LI de drawback.'
                               , sysdate
                               , pn_user_id
                              );
              END IF;

            cmx_prc_gera_log_erros (
               pn_evento_id
             , 'Fator de conversão não cadastrado.'
             , 'E'
             , 'Cadastre o fator de conversão (por unidade de medida ou por produto).'
             , 'Item ' || cmx_pkg_itens.codigo (c.item_id) || ' - ' || cmx_pkg_itens.descricao (c.item_id) ||
               ' unidade de medida ' || cmx_pkg_tabelas.codigo (c.un_medida_id) ||
               ' registro drawback ' || drw_pkg_informacoes.numero_rd (vn_rd_id) ||
               '. (' || sqlerrm  || ')'
             );

          END;

          IF (Nvl (vn_qtde_saldo_drw, 0) < (Nvl (c.qtde, 0) * vn_fator_conversao_drw)) THEN
            vb_li_drw_po_sem_saldo := TRUE;
            vn_evento_id_drw := cmx_fnc_gera_evento(
                                'Criação automática de LI de drawback.'
                               , sysdate
                               , pn_user_id
                              );
            cmx_prc_gera_log_erros (
               vn_evento_id_drw
             , 'Não há saldo suficiente nas previsões de Drawback.'
             , 'E'
             , 'Aumente a previsão de Drawback ou diminua a quantidade da linha da invoice, ' ||
               'referente ao item ' || cmx_pkg_itens.codigo (c.item_id) || ' - ' || cmx_pkg_itens.descricao (c.item_id) ||
               ' para o ato ' || drw_pkg_informacoes.numero_rd (vn_rd_id)
             );
          END IF;
        END IF;
      END LOOP;
    END IF;
    /* Fase 1: linhas da invoice em evidencia, que tem saldo e cujo tipo seja igual
       a "Mercadoria"
    */
    FOR dcl IN cur_declaracao_lin (ci.invoice_id) LOOP
      vn_aliq_ii_dev                := null;
      vn_aliq_ii_red                := null;
      vn_perc_red_ii                := null;
      vn_fundamento_legal_id        := null;
      vn_aliq_ipi_dev               := null;
      vn_aliq_ipi_red               := null;
      vn_aliq_icms                  := null;
      vn_aliq_icms_red              := null;
      vn_perc_red_icms              := null;
      vc_regime_especial            := null;
      vn_fund_legal_icms_id         := null;
      vc_flag_red_base_pis_cofins   := null;
      vn_flegal_red_pis_cofins_id   := null;
      vn_perc_red_pis_cofins        := null;
      vn_aliq_pis                   := null;
      vn_aliq_pis_reduzida          := null;
      vn_aliq_cofins                := null;
      vn_aliq_cofins_reduzida       := null;
      vn_fund_legal_pis_cofins_id   := null;
      vn_aliq_pis_ncm               := null;
      vn_aliq_cofins_ncm            := null;
      vn_aliq_cofins_recuperar_ncm  := null;
      vn_ato_legal_id               := null;
      vn_orgao_emissor_id           := null;
      vn_nr_ato_legal               := null;
      vn_ano_ato_legal              := null;
      vn_aliq_pis_especifica        := null;
      vn_aliq_cofins_especifica     := null;
      vn_qtde_um_aliq_especifica_pc := null;
      vn_fator_conversao_aliq_espec := null;
      vc_um_aliq_especifica_pc      := null;
      vn_ex_naladi_id               := null;
      vn_excecao_antid_id           := null;
      vn_ex_antd_id                 := null;
      vn_aliq_antid_ad_valorem      := null;
      vn_aliq_especifica_antid      := null;
      vc_tipo_unidade_medida_antid  := null;
      vc_somatoria_quantidade       := null;
      vc_destino_ex_ato_legal_ii    := null;
      vn_ato_legal_ii_id            := null;
      vn_orgao_emissor_ii_id        := null;
      vn_nr_ato_legal_ii            := null;
      vn_ano_ato_legal_ii           := null;
      vb_linha_ivc_tem_rcr          := false;
      vd_data_busca_excecao         := trunc (sysdate);
      vn_aliquota_mva               := null;
      vc_beneficio_pr               := null;
      vn_aliq_base_pr               := null;
      vn_perc_diferido_pr           := null;
      vc_beneficio_pr_artigo        := null;
      vn_pr_perc_vr_devido          := null;
      vn_pr_perc_minimo_base        := null;
      vn_pr_perc_minimo_suspenso    := null;
      vc_beneficio_sp               := null;

      vn_excecao_ipi_id            := NULL;
      vn_excecao_pis_cofins_id     := NULL;
      vn_id_regtrib_ii             := null;
      vn_id_regtrib_ipi            := null;
      vn_id_regtrib_pis_cofins     := null;

      vc_tem_excecao_recof          := 'N';

      vc_beneficio_suspensao        := 'N';
      vn_perc_beneficio_suspensao   := null;

      IF (dcl.class_fiscal_id IS NOT null) THEN
        OPEN  cur_aliquotas_ncm (dcl.class_fiscal_id);
        FETCH cur_aliquotas_ncm INTO vn_aliq_pis_ncm, vn_aliq_cofins_ncm, vc_aliq_nt_ipi;
        CLOSE cur_aliquotas_ncm;

        vn_aliquota_cofins_custo := imp_fnc_ncm_cofins_majorado(dcl.class_fiscal_id, vd_data_busca_excecao);

        IF (vc_aliq_nt_ipi = 'S') THEN
          vn_id_regtrib_ipi_def := cmx_pkg_tabelas.tabela_id ('105', '3'); -- NAO TRIBUTAVEL
        ELSE
          vn_id_regtrib_ipi_def := cmx_pkg_tabelas.tabela_id ('105', vc_regtrib_ipi); -- IPI
        END IF;
      END IF;

      vr_cert_origem_mercosul    := null;
      vn_da_invoice_lin_id       := null;
      vn_da_invoice_id           := null;

      IF (vc_tp_declaracao <> '16') THEN
        OPEN  cur_busca_certificado_origem (dcl.invoice_lin_id);
        FETCH cur_busca_certificado_origem INTO vr_cert_origem_mercosul;
        CLOSE cur_busca_certificado_origem;
      ElSE

      /* Buscamos o certificado de origem mercosul para os itens das invoices
         para declaracoes do tipo 16 ==> saida de entreposto industrial, ou
         seja, nacionalizacao de recof
      */

        OPEN  cur_busca_da_invoice_lin_id (dcl.da_lin_id);
        FETCH cur_busca_da_invoice_lin_id INTO vn_da_invoice_lin_id, vn_da_invoice_id;
        CLOSE cur_busca_da_invoice_lin_id;

        OPEN  cur_busca_cert_origem_da (vn_da_invoice_lin_id);
        FETCH cur_busca_cert_origem_da INTO vr_cert_origem_mercosul;
        CLOSE cur_busca_cert_origem_da;
      END IF;


      IF (dcl.item_id IS NOT null) THEN
        IF (vc_tp_declaracao = '16') THEN -- nacionalizacao de recof (saida de entreposto industrial)
          vn_naladi_sh_id   := imp_fnc_busca_naladi_id (dcl.item_id, vn_da_invoice_id, 'SH');
          vn_naladi_ncca_id := imp_fnc_busca_naladi_id (dcl.item_id, vn_da_invoice_id, 'NCCA');
        ELSE
          vn_naladi_sh_id   := imp_fnc_busca_naladi_id (dcl.item_id, ci.invoice_id, 'SH');
          vn_naladi_ncca_id := imp_fnc_busca_naladi_id (dcl.item_id, ci.invoice_id, 'NCCA');
        END IF;
      END IF;

      vc_step_error := 'fnc_deduz_ausencia - 1';
      vn_pais_origem_id := fnc_deduz_ausencia (
                               dcl.pais_origem_id
                             , dcl.ausencia_fabric
                             , vn_pais_export_id_invoice
                             , dcl.fabric_id
                             , dcl.fabric_site_id
                             , vn_ausencia_fabric_gravar
                             );

      IF (vc_tp_declaracao <> '16') THEN
        SELECT sub_familia_id
          INTO vn_sub_familia_id
          FROM imp_invoices_lin
         WHERE invoice_lin_id = dcl.invoice_lin_id;
      END IF;

      /*
        A variavel vn_pais_origem_id somente eh preenchida quando o fabricante
        eh desconhecido. Para o antidumping precisamos sempre saber o pais de
        origem da mercadoria, por isso, se ele for nulo (significa que na ivc
        o fabricante NAO eh desconhecido) iremos busca-lo do exportador ou do
        fabricante da linha da invoice.
      */
      IF (vn_pais_origem_id IS null) THEN
        IF (dcl.ausencia_fabric = 1) THEN
          vn_pais_origem_id_antid := vn_pais_export_id_invoice;
        ELSIF (dcl.ausencia_fabric = 2) THEN
          OPEN  cur_pais_fabricante (dcl.fabric_id, dcl.fabric_site_id);
          FETCH cur_pais_fabricante INTO vn_pais_origem_id_antid;
          CLOSE cur_pais_fabricante;
        END IF;
      ELSE
        vn_pais_origem_id_antid := vn_pais_origem_id;
      END IF; -- fim busca pais_origem_id para antidumping

      -- checar o tipo do embarque (se ele é MISTO ou RECOF).
      -- Adicionar um IF nesse ponto do programa assim:
      vn_excecao_ii_id := NULL;
          IF (nvl (vc_tp_embarque,'*') IN ('MISTO', 'RECOF')) AND (nvl (vc_tp_fixo, '*') = 'RCF') AND
             ((dcl.item_id IS NOT null) OR (dcl.class_fiscal_id IS NOT null))
          THEN
        --    chama a imp_fnc_busca_excecao_recof para o 'II' passando para o parâmetro PC_BUSCA_EXCECAO_RECOF o valor 'S':
          vb_dummy := imp_fnc_busca_excecao_fiscal (
                        'II'                       -- pc_tp_imposto
                      , dcl.empresa_id             -- pn_empresa_id
                      , null                       -- pn_cfop_id
                      , dcl.utilizacao_id          -- pn_utilizacao_id
                      , dcl.item_id                -- pn_item_id
                      , dcl.organizacao_id         -- pn_organizacao_id
                      , dcl.class_fiscal_id        -- pn_class_fiscal_id
                      , vn_urfe_id                 -- pn_urfe_id
                      , vn_pais_origem_id_antid    -- pn_pais_origem_id
                      , vn_id_regtrib_ii           -- pn_regtrib_id
                      , vn_aliq_ii_dev             -- pn_aliquota_dev
                      , vn_aliq_ii_red             -- pn_aliquota_red
                      , vn_perc_red_ii             -- pn_perc_reducao_aliq
                      , vn_dummy                   -- pn_perc_reducao_base
                      , vn_ex_ncm_id               -- pn_ex_ncm_id
                      , vn_dummy                   -- pn_ex_nbm_id
                      , vn_ex_naladi_id            -- pn_ex_naladi_id
                      , vn_dummy                   -- pn_ex_ipi_id
                      , vn_ex_prac_id              -- pn_ex_prac_id
                      , vn_ex_antd_id              -- pn_ex_antd_id
                      , vn_excecao_ii_id           -- pn_excecao_id
                      , vn_dummy                   -- pn_aliquota2
                      , vn_fundamento_legal_id     -- pn_fundamento_legal_id
                      , vc_destino_ex_ato_legal_ii -- pc_destino_ex_ato_legal_ii
                      , vn_ato_legal_ii_id         -- pn_ato_legal_id
                      , vn_nr_ato_legal_ii         -- pn_nr_ato_legal
                      , vn_orgao_emissor_ii_id     -- pn_orgao_emissor_id
                      , vn_ano_ato_legal_ii        -- pn_ano_ato_legal
                      , vn_dummy                   -- pn_fund_legal_reducao_base_id
                      , vc_dummy                   -- pc_regime_especial_icms
                      , vc_dummy                   -- pc_tipo_unidade_medida
                      , vc_dummy                   -- pc_somatoria_quantidade
                      , vn_dummy                   -- pn_unidade_medida_id
                      , vn_urfd_id                 -- pn_urfd_id
                      , vn_dummy                   -- pn_aliq_base_pro_emprego
                      , vn_dummy                   -- pn_aliq_antecip_pro_emprego
                      , vc_dummy                   -- pc_pro_emprego
                      , vc_dummy                   -- pc_beneficio_pr
                      , vn_dummy                   -- pn_aliq_base_pr
                      , vn_dummy                   -- pn_perc_diferido_pr
                      , vd_data_busca_excecao      -- pn_data_busca
                      , vc_dummy                   -- pc_beneficio_pr_artigo
                      , vn_dummy                   -- pn_pr_perc_vr_devido
                      , vn_dummy                   -- pn_pr_perc_minimo_base
                      , vn_dummy                   -- pn_pr_perc_minimo_suspenso
                      , vc_dummy                   -- pc_beneficio_sp
                      , 'S'                        -- pc_busca_excecao_recof
                      , vc_tem_excecao_recof       -- pc_excecao_de_recof
                      , vn_fund_legal_pis_cof_ii_id -- pn_fund_legal_pis_cofins_id
                      , vn_sub_familia_id          -- pn_sub_familia_id
                      , vn_enquad_legal_ipi_id     --pn_enquad_legal_ipi_id
                      , vc_dummy                   -- pc_beneficio_suspensao
                      , vn_dummy                   -- pn_perc_beneficio_suspensao
                      , vn_dummy                   -- pn_icms_motivo_desoneracao_id
                      );
          END IF; -- IF (vc_tp_embarque IN ('MISTO', 'RECOF')) THEN
      -- Para as exceções de IPI, PIS/COFINS, ICMS e ANTIDUMPING sempre passar para o parâmetro PC_BUSCA_EXCECAO_RECOF o valor 'N' (conforme pedaço do prg abaixo já alterado)
      -- Para as exceções de II o parâmetro PC_BUSCA_EXCECAO_RECOF com 'N' somente dentro do IF abaixo (conforme pedaço do prg abaixo já alterado)

      OPEN  cur_item_com_rcr (dcl.invoice_lin_id);
      FETCH cur_item_com_rcr INTO vn_dummy;
      vb_linha_ivc_tem_rcr := cur_item_com_rcr%FOUND;
      CLOSE cur_item_com_rcr;


      IF (   ( nvl(pc_flag_dsi, 'N') = 'S' AND vc_tp_declaracao <> '09' )
           OR
             ( (nvl(pc_flag_dsi, 'N') = 'N') AND (vc_tp_declaracao = '01' OR  to_number (vc_tp_declaracao) > 12 OR (To_Number (vc_tp_declaracao) = 12 AND NOT vb_linha_ivc_tem_rcr)) )
           OR
             ( vb_achou_excecao_por_ebq )
           OR (vc_tp_declaracao = '04' AND nvl (vc_tp_embarque, '*') IN ('MISTO', 'RECOF'))
         )
         AND
         (
           (dcl.item_id IS NOT null) OR (dcl.class_fiscal_id IS NOT null)
         )
         AND (Nvl(vc_tem_excecao_recof,'N') = 'N')
      THEN

        vc_step_error := 'imp_fnc_busca_excecao_fiscal (II)';

        /* busca a exceção somente se não tiver certificado de origem */
        /* acrescentado pais de origem (vn_pais_origem_id_antid) II para filtrar por origem do material*/
        IF (vr_cert_origem_mercosul.cert_origem_mercosul_id IS null) THEN
          IF (NOT imp_fnc_busca_excecao_fiscal (
                    'II'                       -- pc_tp_imposto
                  , dcl.empresa_id             -- pn_empresa_id
                  , null                       -- pn_cfop_id
                  , dcl.utilizacao_id          -- pn_utilizacao_id
                  , dcl.item_id                -- pn_item_id
                  , dcl.organizacao_id         -- pn_organizacao_id
                  , dcl.class_fiscal_id        -- pn_class_fiscal_id
                  , vn_urfe_id                 -- pn_urfe_id
                  , vn_pais_origem_id_antid    -- pn_pais_origem_id
                  , vn_id_regtrib_ii           -- pn_regtrib_id
                  , vn_aliq_ii_dev             -- pn_aliquota_dev
                  , vn_aliq_ii_red             -- pn_aliquota_red
                  , vn_perc_red_ii             -- pn_perc_reducao_aliq
                  , vn_dummy                   -- pn_perc_reducao_base
                  , vn_ex_ncm_id               -- pn_ex_ncm_id
                  , vn_dummy                   -- pn_ex_nbm_id
                  , vn_ex_naladi_id            -- pn_ex_naladi_id
                  , vn_dummy                   -- pn_ex_ipi_id
                  , vn_ex_prac_id              -- pn_ex_prac_id
                  , vn_ex_antd_id              -- pn_ex_antd_id
                  , vn_excecao_ii_id           -- pn_excecao_id
                  , vn_dummy                   -- pn_aliquota2
                  , vn_fundamento_legal_id     -- pn_fundamento_legal_id
                  , vc_destino_ex_ato_legal_ii -- pc_destino_ex_ato_legal_ii
                  , vn_ato_legal_ii_id         -- pn_ato_legal_id
                  , vn_nr_ato_legal_ii         -- pn_nr_ato_legal
                  , vn_orgao_emissor_ii_id     -- pn_orgao_emissor_id
                  , vn_ano_ato_legal_ii        -- pn_ano_ato_legal
                  , vn_dummy                   -- pn_fund_legal_reducao_base_id
                  , vc_dummy                   -- pc_regime_especial_icms
                  , vc_dummy                   -- pc_tipo_unidade_medida
                  , vc_dummy                   -- pc_somatoria_quantidade
                  , vn_dummy                   -- pn_unidade_medida_id
                  , vn_urfd_id                 -- pn_urfd_id
                  , vn_dummy                   -- pn_aliq_base_pro_emprego
                  , vn_dummy                   -- pn_aliq_antecip_pro_emprego
                  , vc_dummy                   -- pc_pro_emprego
                  , vc_dummy                   -- pc_beneficio_pr
                  , vn_dummy                   -- pn_aliq_base_pr
                  , vn_dummy                   -- pn_perc_diferido_pr
                  , vd_data_busca_excecao      -- pn_data_busca
                  , vc_dummy                   -- pc_beneficio_pr_artigo
                  , vn_dummy                   -- pn_pr_perc_vr_devido
                  , vn_dummy                   -- pn_pr_perc_minimo_base
                  , vn_dummy                   -- pn_pr_perc_minimo_suspenso
                  , vc_dummy                   -- pc_beneficio_sp
                  , 'N'                        -- pc_busca_excecao_recof
                  , vc_dummy                   -- pc_excecao_de_recof
                  , vn_dummy                   -- pn_fund_legal_pis_cofins_id
                  , vn_sub_familia_id          -- pn_sub_familia_id
                  , vn_dummy                   -- pn_enquad_legal_ipi_id
                  , vc_dummy                   -- pc_beneficio_suspensao
                  , vn_dummy                   -- pn_perc_beneficio_suspensao
                  , vn_dummy                   -- pn_icms_motivo_desoneracao_id
                  )
            )
          THEN
            vn_id_regtrib_ii := vn_id_regtrib_ii_def;
          ELSE
            IF (vb_achou_excecao_por_ebq) THEN
              IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ii) = '1') THEN -- II integral
                vn_id_regtrib_ii := cmx_pkg_tabelas.tabela_id ('104', '5'); -- suspensao de II
                vn_fundamento_legal_id := vr_excecao_por_tp_ebq.fundamento_legal_ii_id;
              ELSIF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ii) = '4') THEN -- II redução
                vn_id_regtrib_ii := cmx_pkg_tabelas.tabela_id ('104', '4');
              ELSE -- II é diferente de integral
                vn_id_regtrib_ii           := vn_id_regtrib_ii_def;
                vn_aliq_ii_dev             := null;
                vn_aliq_ii_red             := null;
                vn_perc_red_ii             := null;
                vn_ex_ncm_id               := null;
                vn_ex_nbm_id               := null;
                vn_ex_naladi_id            := null;
                vn_ex_prac_id              := null;
                vn_ex_antd_id              := null;
                vn_excecao_ii_id           := null;
                vn_fundamento_legal_id     := null;
                vc_destino_ex_ato_legal_ii := null;
                vn_ato_legal_ii_id         := null;
                vn_nr_ato_legal_ii         := null;
                vn_orgao_emissor_ii_id     := null;
                vn_ano_ato_legal_ii        := null;
              END IF; -- IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ii) = '1') THEN
            ELSIF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ii) = '4') THEN -- II redução
              vn_id_regtrib_ii := cmx_pkg_tabelas.tabela_id ('104', '4');
            END IF; -- IF (vb_achou_excecao_por_ebq) THEN
          END IF; -- IF (NOT imp_fnc_busca_excecao_fiscal...
        ELSE
          vn_id_regtrib_ii := vn_id_regtrib_ii_def;

          vc_destino_ex_ato_legal_ii := 'NALADI';
          vn_ato_legal_ii_id         := vr_cert_origem_mercosul.ato_legal_ex_naladi_id;
          vn_nr_ato_legal_ii         := vr_cert_origem_mercosul.nr_ato_legal_ex_naladi;
          vn_orgao_emissor_ii_id     := vr_cert_origem_mercosul.orgao_emissor_ex_naladi_id;
          vn_ano_ato_legal_ii        := vr_cert_origem_mercosul.ano_ato_legal_ex_naladi;


        END IF; -- IF (vr_cert_origem_mercosul.ex_naladi IS null) THEN

        IF (nvl (dcl.ipi_integral, 'N') = 'N') THEN
          vc_step_error := 'imp_fnc_busca_excecao_fiscal (IPI)';
          IF (NOT imp_fnc_busca_excecao_fiscal (
                    'IPI'                  -- pc_tp_imposto
                  , dcl.empresa_id         -- pn_empresa_id
                  , null                   -- pn_cfop_id
                  , dcl.utilizacao_id      -- pn_utilizacao_id
                  , dcl.item_id            -- pn_item_id
                  , dcl.organizacao_id     -- pn_organizacao_id
                  , dcl.class_fiscal_id    -- pn_class_fiscal_id
                  , vn_urfe_id             -- pn_urfe_id
                  , null                   -- pn_pais_origem_id
                  , vn_id_regtrib_ipi      -- pn_regtrib_id
                  , vn_aliq_ipi_dev        -- pn_aliquota_dev
                  , vn_aliq_ipi_red        -- pn_aliquota_red
                  , vn_dummy               -- pn_perc_reducao_aliq
                  , vn_dummy               -- pn_perc_reducao_base
                  , vn_dummy               -- pn_ex_ncm_id
                  , vn_ex_nbm_id           -- pn_ex_nbm_id
                  , vn_dummy               -- pn_ex_naladi_id
                  , vn_ex_ipi_id           -- pn_ex_ipi_id
                  , vn_dummy               -- pn_ex_prac_id
                  , vn_dummy               -- pn_ex_antd_id
                  , vn_excecao_ipi_id      -- pn_excecao_id
                  , vn_dummy               -- pn_aliquota2
                  , vn_dummy               -- pn_fundamento_legal_id
                  , vc_dummy               -- pc_destino_ex_ato_legal_ii
                  , vn_ato_legal_id        -- pn_ato_legal_id
                  , vn_nr_ato_legal        -- pn_nr_ato_legal
                  , vn_orgao_emissor_id    -- pn_orgao_emissor_id
                  , vn_ano_ato_legal       -- pn_ano_ato_legal
                  , vn_dummy               -- pn_fund_legal_reducao_base_id
                  , vc_dummy               -- pc_regime_especial_icms
                  , vc_dummy               -- pc_tipo_unidade_medida
                  , vc_dummy               -- pc_somatoria_quantidade
                  , vn_dummy               -- pn_unidade_medida_id
                  , vn_urfd_id             -- pn_urfd_id
                  , vn_dummy               -- pn_aliq_base_pro_emprego
                  , vn_dummy               -- pn_aliq_antecip_pro_emprego
                  , vc_dummy               -- pc_pro_emprego
                  , vc_dummy               -- pc_beneficio_pr
                  , vn_dummy               -- pn_aliq_base_pr
                  , vn_dummy               -- pn_perc_diferido_pr
                  , vd_data_busca_excecao  -- pn_data_busca
                  , vc_dummy               -- pc_beneficio_pr_artigo
                  , vn_dummy               -- pn_pr_perc_vr_devido
                  , vn_dummy               -- pn_pr_perc_minimo_base
                  , vn_dummy               -- pn_pr_perc_minimo_suspenso
                  , vc_dummy               -- pc_beneficio_sp
                  , 'N'                    -- pc_busca_excecao_recof
                  , vc_dummy               -- pc_excecao_de_recof
                  , vn_dummy               -- pn_fund_legal_pis_cofins_id
                  , vn_sub_familia_id      -- pn_sub_familia_id
                  , vn_enquad_legal_ipi_id -- pn_enquad_legal_ipi_id
                  , vc_dummy               -- pc_beneficio_suspensao
                  , vn_dummy               -- pn_perc_beneficio_suspensao
                  , vn_dummy               -- pn_icms_motivo_desoneracao_id
                  )
            )
          THEN
            vn_id_regtrib_ipi := vn_id_regtrib_ipi_def;
          ELSE
            IF (vb_achou_excecao_por_ebq) THEN
              IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ipi) = '4') THEN -- IPI integral
                vn_id_regtrib_ipi := cmx_pkg_tabelas.tabela_id ('105', '5'); -- suspensao de IPI
              ELSE -- IPI é diferente de integral
                vn_id_regtrib_ipi          := vn_id_regtrib_ipi_def;
                vn_aliq_ipi_dev            := null;
                vn_aliq_ipi_red            := null;
                vn_ex_ipi_id               := null;
                vn_excecao_ipi_id          := null;
                vc_destino_ex_ato_legal_ii := null;
                vn_ato_legal_id            := null;
                vn_nr_ato_legal            := null;
                vn_orgao_emissor_id        := null;
                vn_ano_ato_legal           := null;
              END IF; -- IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ipi) = '4') THEN
            END IF; -- IF (vb_achou_excecao_por_ebq) THEN
          END IF; -- IF (NOT imp_fnc_busca_excecao_fiscal
        END IF; -- IF (nvl (dcl.ipi_integral, 'N') = 'N') THEN

        vc_step_error := 'imp_fnc_busca_excecao_fiscal (PIS/COFINS)';
        IF (NOT imp_fnc_busca_excecao_fiscal (
                  'PIS/COFINS'                 -- pc_tp_imposto
                , dcl.empresa_id               -- pn_empresa_id
                , null                         -- pn_cfop_id
                , dcl.utilizacao_id            -- pn_utilizacao_id
                , dcl.item_id                  -- pn_item_id
                , dcl.organizacao_id           -- pn_organizacao_id
                , dcl.class_fiscal_id          -- pn_class_fiscal_id
                , vn_urfe_id                   -- pn_urfe_id
                , null                         -- pn_pais_origem_id
                , vn_id_regtrib_pis_cofins     -- pn_regtrib_id
                , vn_aliq_pis                  -- pn_aliquota_dev
                , vn_dummy                     -- pn_aliquota_red
                , vn_dummy                     -- pn_perc_reducao_aliq
                , vn_perc_red_pis_cofins       -- pn_perc_reducao_base
                , vn_dummy                     -- pn_ex_ncm_id
                , vn_dummy                     -- pn_ex_nbm_id
                , vn_dummy                     -- pn_ex_naladi_id
                , vn_dummy                     -- pn_ex_ipi_id
                , vn_dummy                     -- pn_ex_prac_id
                , vn_dummy                     -- pn_ex_antd_id
                , vn_excecao_pis_cofins_id     -- pn_excecao_id
                , vn_aliq_cofins               -- pn_aliquota2
                , vn_fund_legal_pis_cofins_id  -- pn_fundamento_legal_id
                , vc_dummy                     -- pc_destino_ex_ato_legal_ii
                , vn_dummy                     -- pn_ato_legal_id
                , vn_dummy                     -- pn_nr_ato_legal
                , vn_dummy                     -- pn_orgao_emissor_id
                , vn_dummy                     -- pn_ano_ato_legal
                , vn_flegal_red_pis_cofins_id  -- pn_fund_legal_reducao_base_id
                , vc_dummy                     -- pc_regime_especial_icms
                , vc_dummy                     -- pc_tipo_unidade_medida
                , vc_dummy                     -- pc_somatoria_quantidade
                , vn_dummy                     -- pn_unidade_medida_id
                , vn_urfd_id                   -- pn_urfd_id
                , vn_dummy                     -- pn_aliq_base_pro_emprego
                , vn_dummy                     -- pn_aliq_antecip_pro_emprego
                , vc_dummy                     -- pc_pro_emprego
                , vc_dummy                     -- pc_beneficio_pr
                , vn_dummy                     -- pn_aliq_base_pr
                , vn_dummy                     -- pn_perc_diferido_pr
                , vd_data_busca_excecao        -- pn_data_busca
                , vc_dummy                     -- pc_beneficio_pr_artigo
                , vn_dummy                     -- pn_pr_perc_vr_devido
                , vn_dummy                     -- pn_pr_perc_minimo_base
                , vn_dummy                     -- pn_pr_perc_minimo_suspenso
                , vc_dummy                     -- pc_beneficio_sp
                , 'N'                          -- pc_busca_excecao_recof
                , vc_dummy                     -- pc_excecao_de_recof
                , vn_dummy                     -- pn_fund_legal_pis_cofins_id
                , vn_sub_familia_id            -- pn_sub_familia_id
                , vn_dummy                     -- pn_enquad_legal_ipi_id
                , vc_dummy                     -- pc_beneficio_suspensao
                , vn_dummy                     -- pn_perc_beneficio_suspensao
                , vn_dummy                     -- pn_icms_motivo_desoneracao_id
                )
          )
        THEN
          vn_id_regtrib_pis_cofins := vn_id_regtrib_pis_cofins_def;
        ELSE
          IF (vb_achou_excecao_por_ebq) THEN
            IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_pis_cofins) = '3') THEN -- PIS/Cofins integral
              vn_id_regtrib_pis_cofins := cmx_pkg_tabelas.tabela_id ('141', '2'); -- suspensao de PIS/Cofins
              vn_fund_legal_pis_cofins_id := vr_excecao_por_tp_ebq.fundamento_legal_pis_cofins_id;
            ELSE -- PIS/Cofins é diferente de integral
              vn_id_regtrib_pis_cofins    := vn_id_regtrib_pis_cofins_def;
              vn_aliq_pis                 := null;
              vn_perc_red_pis_cofins      := null;
              vn_excecao_pis_cofins_id    := null;
              vn_aliq_cofins              := null;
              vn_fund_legal_pis_cofins_id := null;
              vn_flegal_red_pis_cofins_id := null;
            END IF; -- IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_pis_cofins) = '3') THEN
          END IF; -- IF (vb_achou_excecao_por_ebq) THEN
        END IF; -- IF (NOT imp_fnc_busca_excecao_fiscal

      ELSE -- nao entrou no IF de busca de excecao para II, IPI e PIS/Cofins
        IF (vc_tem_excecao_recof = 'S') THEN
          vn_id_regtrib_ii            := cmx_pkg_tabelas.tabela_id ('104', '5');
          vn_id_regtrib_ipi           := cmx_pkg_tabelas.tabela_id ('105', '5');
          vn_id_regtrib_pis_cofins    := cmx_pkg_tabelas.tabela_id ('141', '2');
          vn_excecao_ipi_id           :=  vn_excecao_ii_id;
          vn_excecao_pis_cofins_id    :=  vn_excecao_ii_id;
          vn_fund_legal_pis_cofins_id :=  vn_fund_legal_pis_cof_ii_id;

          /* Se tivemos CO e o item for de RECOF, temos que atribuir os dados */
          /* do acordo ALADI para serem gravados na adicao da DI              */
          IF (vr_cert_origem_mercosul.cert_origem_mercosul_id IS NOT null) THEN
            vc_destino_ex_ato_legal_ii := 'NALADI';
            vn_ato_legal_ii_id         := vr_cert_origem_mercosul.ato_legal_ex_naladi_id;
            vn_nr_ato_legal_ii         := vr_cert_origem_mercosul.nr_ato_legal_ex_naladi;
            vn_orgao_emissor_ii_id     := vr_cert_origem_mercosul.orgao_emissor_ex_naladi_id;
            vn_ano_ato_legal_ii        := vr_cert_origem_mercosul.ano_ato_legal_ex_naladi;
          END IF;
        ELSE
            vn_id_regtrib_ii             := vn_id_regtrib_ii_def;
            vn_id_regtrib_ipi            := vn_id_regtrib_ipi_def;
            vn_id_regtrib_pis_cofins     := vn_id_regtrib_pis_cofins_def;
        END IF;

      END IF;

      IF (   ( nvl(pc_flag_dsi, 'N') = 'S'  AND vc_tp_declaracao <> '09' )
           OR
             ( (nvl(pc_flag_dsi, 'N') = 'N' AND (vc_tp_declaracao = '01' OR  to_number(vc_tp_declaracao) >= 12) )
           OR
             (vc_tp_declaracao = '04' AND nvl (vc_suspende_icms_recof, 'N') = 'N')) -- para Recof
           OR
             ( vb_achou_excecao_por_ebq )
         )
         AND
         (
           (dcl.item_id IS NOT null) OR (dcl.class_fiscal_id IS NOT null)
         )
      THEN

        -- Se for saida de entreposto industrial
        IF (vc_tp_declaracao = '16') THEN
          OPEN  cur_busca_data_da (dcl.da_id);
          FETCH cur_busca_data_da INTO vd_data_busca_excecao;
          CLOSE cur_busca_data_da;
        END IF;

        vc_step_error := 'imp_fnc_busca_excecao_fiscal (ICMS)';
        IF (NOT imp_fnc_busca_excecao_fiscal (
                  'ICMS'                      -- pc_tp_imposto
                , dcl.empresa_id              -- pn_empresa_id
                , dcl.cfop_id                 -- pn_cfop_id
                , dcl.utilizacao_id           -- pn_utilizacao_id
                , dcl.item_id                 -- pn_item_id
                , dcl.organizacao_id          -- pn_organizacao_id
                , dcl.class_fiscal_id         -- pn_class_fiscal_id
                , vn_urfe_id                  -- pn_urfe_id
                , null                        -- pn_pais_origem_id
                , vn_id_regtrib_icms          -- pn_regtrib_id
                , vn_aliq_icms                -- pn_aliquota_dev
                , vn_aliq_icms_red            -- pn_aliquota_red
                , vn_dummy                    -- pn_perc_reducao_aliq
                , vn_perc_red_icms            -- pn_perc_reducao_base
                , vn_dummy                    -- pn_ex_ncm_id
                , vn_dummy                    -- pn_ex_nbm_id
                , vn_dummy                    -- pn_ex_naladi_id
                , vn_dummy                    -- pn_ex_ipi_id
                , vn_dummy                    -- pn_ex_prac_id
                , vn_dummy                    -- pn_ex_antd_id
                , vn_excecao_icms_id          -- pn_excecao_id
                , vn_aliquota_mva             -- pn_aliquota2                -- *** ICMS ST
                , vn_fund_legal_icms_id       -- pn_fundamento_legal_id
                , vc_dummy                    -- pc_destino_ex_ato_legal_ii
                , vn_dummy                    -- pn_ato_legal_id
                , vn_dummy                    -- pn_nr_ato_legal
                , vn_dummy                    -- pn_orgao_emissor_id
                , vn_dummy                    -- pn_ano_ato_legal
                , vn_dummy                    -- pn_fund_legal_reducao_base_id
                , vc_regime_especial          -- pc_regime_especial_icms
                , vc_dummy                    -- pc_tipo_unidade_medida
                , vc_dummy                    -- pc_somatoria_quantidade
                , vn_dummy                    -- pn_unidade_medida_id
                , vn_urfd_id                  -- pn_urfd_id
                , vn_aliq_base_pro_emprego    -- pn_aliq_base_pro_emprego
                , vn_aliq_antecip_pro_emprego -- pn_aliq_antecip_pro_emprego
                , vc_pro_emprego              -- pc_pro_emprego
                , vc_beneficio_pr             -- pc_beneficio_pr
                , vn_aliq_base_pr             -- pn_aliq_base_pr
                , vn_perc_diferido_pr         -- pn_perc_diferido_pr
                , vd_data_busca_excecao       -- pn_data_busca
                , vc_beneficio_pr_artigo      -- pc_beneficio_pr_artigo
                , vn_pr_perc_vr_devido        -- pn_pr_perc_vr_devido
                , vn_pr_perc_minimo_base      -- pn_pr_perc_minimo_base
                , vn_pr_perc_minimo_suspenso  -- pn_pr_perc_minimo_suspenso
                , vc_beneficio_sp             -- pc_beneficio_sp
                , 'N'                         -- pc_busca_excecao_recof
                , vc_dummy                    -- pc_excecao_de_recof
                , vn_dummy                    -- pn_fund_legal_pis_cofins_id
                , vn_sub_familia_id           -- pn_sub_familia_id
                , vn_dummy                    -- pn_enquad_legal_ipi_id
                , vc_beneficio_suspensao      -- pc_beneficio_suspensao
                , vn_perc_beneficio_suspensao -- pn_perc_beneficio_suspensao
                , vn_dummy                    -- pn_icms_motivo_desoneracao_id -- este parâmetro já está sendo tratado no cursor cur_excecao_motivo_desoneracao
                )
          )
        THEN
          vn_id_regtrib_icms := vn_id_regtrib_icms_def;
        ELSE
          IF (vb_achou_excecao_por_ebq) THEN
            IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_icms) = '1') THEN -- ICMS integral
              IF vr_excecao_por_tp_ebq.busca_excecao_para_icms = 'N' THEN
                vn_id_regtrib_icms := cmx_pkg_tabelas.tabela_id ('132', '5'); -- suspensao de ICMS
              END IF;
            ELSE -- ICMS é diferente de integral
              vn_id_regtrib_icms    := vn_id_regtrib_icms_def;
              vn_aliq_icms          := null;
              vn_aliq_icms_red      := null;
              vn_perc_red_icms      := null;
              vn_excecao_icms_id    := null;
              vn_fund_legal_icms_id := null;
              vc_regime_especial    := null;
              vn_aliquota_mva       := null;
            END IF; -- IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_icms) = '1') THEN
          END IF; -- IF (vb_achou_excecao_por_ebq) THEN
        END IF; -- IF (NOT imp_fnc_busca_excecao_fiscal

        IF (NOT imp_fnc_busca_excecao_fiscal (
                  'ANTI'                         -- pc_tp_imposto                      VARCHAR2
                , dcl.empresa_id                 -- pn_empresa_id                      NUMBER
                , null                           -- pn_cfop_id                         NUMBER
                , dcl.utilizacao_id              -- pn_utilizacao_id                   NUMBER
                , dcl.item_id                    -- pn_item_id                         NUMBER
                , dcl.organizacao_id             -- pn_organizacao_id                  NUMBER
                , dcl.class_fiscal_id            -- pn_class_fiscal_id                 NUMBER
                , null                           -- pn_urfe_id                         NUMBER
                , vn_pais_origem_id_antid        -- pn_pais_origem_id                  NUMBER
                , vn_dummy                       -- pn_regtrib_id                 OUT  NUMBER
                , vn_aliq_antid_ad_valorem       -- pn_aliquota_dev               OUT  NUMBER
                , vn_dummy                       -- pn_aliquota_red               OUT  NUMBER
                , vn_dummy                       -- pn_perc_reducao_aliq          OUT  NUMBER
                , vn_dummy                       -- pn_perc_reducao_base          OUT  NUMBER
                , vn_dummy                       -- pn_ex_ncm_id                  OUT  NUMBER
                , vn_dummy                       -- pn_ex_nbm_id                  OUT  NUMBER
                , vn_dummy                       -- pn_ex_naladi_id               OUT  NUMBER
                , vn_dummy                       -- pn_ex_ipi_id                  OUT  NUMBER
                , vn_dummy                       -- pn_ex_prac_id                 OUT  NUMBER
                , vn_ex_antd_id                  -- pn_ex_antd_id                 OUT  NUMBER
                , vn_excecao_antid_id            -- pn_excecao_id                 OUT  NUMBER
                , vn_aliq_especifica_antid       -- pn_aliquota2                  OUT  NUMBER
                , vn_dummy                       -- pn_fundamento_legal_id        OUT  NUMBER
                , vc_dummy                       -- pc_destino_ex_ato_legal_ii    OUT  VARCHAR2
                , vn_dummy                       -- pn_ato_legal_id               OUT  NUMBER
                , vn_dummy                       -- pn_nr_ato_legal               OUT  NUMBER
                , vn_dummy                       -- pn_orgao_emissor_id           OUT  NUMBER
                , vn_dummy                       -- pn_ano_ato_legal              OUT  NUMBER
                , vn_dummy                       -- pn_fund_legal_reducao_base_id OUT  NUMBER
                , vc_dummy                       -- pc_regime_especial_icms       OUT  VARCHAR2
                , vc_tipo_unidade_medida_antid   -- pc_tipo_unidade_medida        OUT  VARCHAR2
                , vc_somatoria_quantidade        -- pc_somatoria_quantidade       OUT  VARCHAR2
                , vn_um_aliq_especifica_antid_id -- pn_unidade_medida_id          OUT  NUMBER
                , vn_urfd_id                     -- pn_urfd_id
                , vn_dummy                       -- pn_aliq_base_pro_emprego
                , vn_dummy                       -- pn_aliq_antecip_pro_emprego
                , vc_dummy                       -- pc_pro_emprego
                , vc_dummy                       -- pc_beneficio_pr
                , vn_dummy                       -- pn_aliq_base_pr
                , vn_dummy                       -- pn_perc_diferido_pr
                , vd_data_busca_excecao          -- pn_data_busca                 IN   DATE
                , vc_dummy                       -- pc_beneficio_pr_artigo
                , vn_dummy                       -- pn_pr_perc_vr_devido
                , vn_dummy                       -- pn_pr_perc_minimo_base
                , vn_dummy                       -- pn_pr_perc_minimo_suspenso
                , vc_dummy                       -- pc_beneficio_sp
                , 'N'                            -- pc_busca_excecao_recof
                , vc_dummy                       -- pc_excecao_de_recof
                , vn_dummy                       -- pn_fund_legal_pis_cofins_id
                , vn_sub_familia_id              -- pn_sub_familia_id
                , vn_dummy                       -- pn_enquad_legal_ipi_id
                , vc_dummy                       -- pc_beneficio_suspensao
                , vn_dummy                       -- pn_perc_beneficio_suspensao
                , vn_dummy                       -- pn_icms_motivo_desoneracao_id
                )
          )
        THEN
          vn_aliq_antid_ad_valorem := null;
          vn_aliq_especifica_antid := null;
        END IF; -- IF (NOT imp_fnc_busca_excecao_fiscal...

      ELSE -- nao entrou no IF de busca de excecao para ICMS
        vn_id_regtrib_icms := vn_id_regtrib_icms_def;
      END IF;

      vc_step_error := null;

      IF (nvl(vn_aliq_icms,0) = 0) THEN
        vn_aliq_icms := vn_icms_empresas_param;
      END IF;

      IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_pis_cofins) = '4') THEN -- se for reducao de pis/cofins
        vn_aliq_pis_reduzida    := vn_aliq_pis;
        vn_aliq_cofins_reduzida := vn_aliq_cofins;
        vn_aliq_pis             := vn_aliq_pis_ncm;
        vn_aliq_cofins          := vn_aliq_cofins_ncm;
        vn_aliq_cofins_recuperar_ncm := vn_aliq_cofins_reduzida - vn_aliquota_cofins_custo;
      ELSE
        vn_aliq_pis_reduzida    := null;
        vn_aliq_cofins_reduzida := null;

        IF (nvl (vn_aliq_pis, 0) = 0) THEN
          vn_aliq_pis := vn_aliq_pis_ncm;
        END IF;

        IF (nvl (vn_aliq_cofins, 0) = 0) THEN
          vn_aliq_cofins := vn_aliq_cofins_ncm;
        END IF;

        IF (Nvl(vn_aliq_cofins_recuperar_ncm,0) = 0) THEN
          vn_aliq_cofins_recuperar_ncm := vn_aliq_cofins - vn_aliquota_cofins_custo;
        END IF;

      END IF; -- IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_pis_cofins) = '4') THEN

      IF (vn_flegal_red_pis_cofins_id IS NOT null) AND (vn_perc_red_pis_cofins IS NOT null) THEN
        vc_flag_red_base_pis_cofins := 'S';
      ELSE
        vc_flag_red_base_pis_cofins := 'N';
        vn_flegal_red_pis_cofins_id := null;
        vn_perc_red_pis_cofins      := null;
      END IF; -- IF (vn_flegal_red_pis_cofins_id IS NOT null) AND (vn_perc_red_pis_cofins IS NOT null) THEN

      -- Quando a declaracao eh ADMISSAO EM ENTREPOSTO INDUSTRIAL (admissao de recof),
      -- jogamos o fundamento legal 42 para pis/cofins fixamente por enquanto ate que
      -- isso seja parametrizavel no recof.
      -- Conforme solicitação do Angelo da Lider além de jogar este fundamento para
      -- Recof o mesmo será inserido no DE.

      IF (  (vc_tp_declaracao IN ('10','04')) AND (vn_fund_legal_pis_cofins_id IS null) AND (vc_tp_embarque NOT IN ('MISTO', 'RECOF'))  )THEN
           vn_fund_legal_pis_cofins_id := cmx_pkg_tabelas.tabela_id ('148', '42');
      END IF;

      IF ( (vc_tp_declaracao = '10') AND (vn_fundamento_legal_id IS null) ) THEN   -- Admissao em DE/DAF

          IF(InStr(cmx_pkg_tabelas.auxiliar('901',vc_codigo_tp_embarque,1), 'NAC') = 0) THEN

            vc_cod_fundamento_legal := cmx_pkg_tabelas.auxiliar( '409'
                                                               , cmx_pkg_tabelas.auxiliar( '901', vc_codigo_tp_embarque, 9)
                                                               , 1
                                                               );

            IF(vc_cod_fundamento_legal IS NOT NULL) THEN
              vn_fundamento_legal_id := cmx_pkg_tabelas.tabela_id ( '111', vc_cod_fundamento_legal);
            END IF;

          END IF;

      END IF;

      /* Quando o regime de tributação do II for IMUNIDADE (2) ou
         NAO INCIDENCIA (6), o regime de tributação do IPI deverá
         ser nulo.
      */
      IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ii) IN ('2', '6')) THEN
        vn_id_regtrib_ipi := null;
      END IF;

      --
      -- Necessidade do recof
      --
      IF (nvl (dcl.ipi_integral, 'N') = 'S') THEN
        vn_id_regtrib_ipi := cmx_pkg_tabelas.tabela_id ('105', '4'); -- integral
      END IF;

      vn_quantidade_gerar_linha_dcl := dcl.saldo;

      IF (dcl.item_id IS NOT null) THEN
        OPEN  cur_itens_ext (dcl.item_id);
        FETCH cur_itens_ext INTO vn_aliq_pis_especifica
                               , vn_aliq_cofins_especifica
                               , vc_um_aliq_especifica_pc
                               , vn_fator_conversao_aliq_espec;
        CLOSE cur_itens_ext;

        IF (vn_aliq_pis_especifica IS NOT null) AND (vn_aliq_cofins_especifica IS NOT null) THEN
          vn_qtde_um_aliq_especifica_pc := ceil (vn_quantidade_gerar_linha_dcl * vn_fator_conversao_aliq_espec);
          vn_aliq_pis                   := 0;
          vn_aliq_cofins                := 0;
          vn_perc_red_pis_cofins        := null;

          vc_recof_dcl := 'N';
          OPEN cur_ex_fiscais_recof(vn_excecao_pis_cofins_id);
          FETCH cur_ex_fiscais_recof INTO vc_recof_dcl;
          CLOSE cur_ex_fiscais_recof;


          /* Retirar excecao e fundamento legal somente qdo a excecao
             não possui flag de recof marcado */
          IF(vc_recof_dcl = 'N')THEN
          vn_excecao_pis_cofins_id      := null;
          vn_fund_legal_pis_cofins_id   := null;
          END IF;

          vn_flegal_red_pis_cofins_id   := null;
          vc_flag_red_base_pis_cofins   := 'N';
          vn_aliq_pis_reduzida          := null;
          vn_aliq_cofins_reduzida       := null;
        ELSE
          vn_aliq_pis_especifica        := null;
          vn_aliq_cofins_especifica     := null;
          vc_um_aliq_especifica_pc      := null;
          vn_fator_conversao_aliq_espec := null;
          vn_qtde_um_aliq_especifica_pc := null;
        END IF;
      END IF; -- IF (dcl.item_id IS NOT null) THEN

      /* Neste ponto, também não preciso saber se é DI ou DSI, pois a DSI vem
         com o flag pc_gera_li_drawback igual a N
      */

      /* TH - 01/08/2019
         Jira - NSI-241
         TIPO DE EMBARQUE IGUAL A RECOF OU RECOF_MISTO (Código tipo de embarque RCF_MISTO e RCF - tipo fixo: RCF da tabela 901)
         Verifica se o flag RECOF da exceção fiscal de II está marcado.
         Se o flag estiver marcado, recupera as informações do Número do EX, Ato, Órgão, Nº e ano do IPI se houver.
      */
      IF(     vn_excecao_ii_id IS NOT NULL AND Nvl(vc_tp_embarque,'*') IN ('MISTO', 'RECOF')
          AND Nvl(vc_tp_fixo, '*') = 'RCF') THEN

          OPEN  cur_ex_fiscais_ii(vn_excecao_ii_id);
          FETCH cur_ex_fiscais_ii INTO vr_cur_ex_fiscais_ii;
          CLOSE cur_ex_fiscais_ii;

          IF(vr_cur_ex_fiscais_ii.ex_ipi_recof_id IS NOT NULL OR
             vr_cur_ex_fiscais_ii.ato_legal_recof_id IS NOT NULL OR
             vr_cur_ex_fiscais_ii.orgao_emissor_recof_id IS NOT NULL OR
             vr_cur_ex_fiscais_ii.nr_ato_legal_recof IS NOT NULL OR
             vr_cur_ex_fiscais_ii.ano_ato_legal_recof IS NOT NULL) THEN

            vn_ex_ipi_id          := vr_cur_ex_fiscais_ii.ex_ipi_recof_id;
            vn_ato_legal_id       := vr_cur_ex_fiscais_ii.ato_legal_recof_id;
            vn_nr_ato_legal       := vr_cur_ex_fiscais_ii.nr_ato_legal_recof;
            vn_orgao_emissor_id   := vr_cur_ex_fiscais_ii.orgao_emissor_recof_id;
            vn_ano_ato_legal      := vr_cur_ex_fiscais_ii.ano_ato_legal_recof;
            vn_excecao_ipi_id     := NULL;
          END IF;

      END IF;
      /*TH - Fim*/

      IF (to_number(vc_tp_declaracao) IN (1, 6, 15)) AND (pc_gera_li_drawback = 'S') AND (dcl.item_id IS NOT null) THEN

        vc_descricao_long:= imp_fnc_busca_descricao_item (
                                                             pn_empresa_id
                                                           , dcl.item_id
                                                           , dcl.invoice_lin_id
                                                           , null
                                                           , vn_ex_ncm_id
                                                           , vn_ex_nbm_id
                                                           , vn_ex_naladi_id
                                                           , vn_ex_ipi_id
                                                           , vn_ex_prac_id
                                                           , vn_ex_antd_id
                                                           , 'LICENCA'
                                                           , dcl.po_linha_id
                                                          );

        vt_licencas_lin.lsi                            := 'N';
        vt_licencas_lin.invoice_id                     := dcl.invoice_id;
        vt_licencas_lin.invoice_lin_id                 := dcl.invoice_lin_id;
        vt_licencas_lin.embarque_id                    := pn_embarque_id;
        vt_licencas_lin.item_id                        := dcl.item_id;
        vt_licencas_lin.un_medida_id                   := dcl.un_medida_id;
        vt_licencas_lin.qtde                           := dcl.saldo;
        vt_licencas_lin.preco_unitario_m               := dcl.vmlc_li_m_unitario;
        vt_licencas_lin.tp_classificacao               := 1;
        vt_licencas_lin.class_fiscal_id                := dcl.class_fiscal_id;
        vt_licencas_lin.ausencia_fabric                := dcl.ausencia_fabric;
        vt_licencas_lin.fabric_id                      := dcl.fabric_id;
        vt_licencas_lin.fabric_site_id                 := dcl.fabric_site_id;
        vt_licencas_lin.pais_origem_id                 := vn_pais_origem_id;
        vt_licencas_lin.fabric_part_number             := dcl.fabric_part_number;
        vt_licencas_lin.pesoliq_unit                   := dcl.pesoliq_unit;
        vt_licencas_lin.regtrib_ii_id                  := vn_id_regtrib_ii;
        vt_licencas_lin.ex_ncm_id                      := vn_ex_ncm_id;
        vt_licencas_lin.ex_nbm_id                      := vn_ex_nbm_id;
        vt_licencas_lin.ex_naladi_id                   := vn_ex_naladi_id;
        vt_licencas_lin.ex_ipi_id                      := vn_ex_ipi_id;
        vt_licencas_lin.ex_prac_id                     := vn_ex_prac_id;
        vt_licencas_lin.ex_antd_id                     := vn_ex_antd_id;
        vt_licencas_lin.utilizacao_id                  := dcl.utilizacao_id;
        vt_licencas_lin.pesoliq_tot                    := dcl.pesoliq_tot;
        vt_licencas_lin.creation_date                  := sysdate;
        vt_licencas_lin.created_by                     := pn_user_id;
        vt_licencas_lin.last_update_date               := sysdate;
        vt_licencas_lin.last_updated_by                := pn_user_id;
        vc_descricao_long := imp_fnc_busca_descricao_item (
                                                            pn_empresa_id
                                                          , dcl.item_id
                                                          , dcl.invoice_lin_id
                                                          , null
                                                          , vn_ex_ncm_id
                                                          , vn_ex_nbm_id
                                                          , vn_ex_naladi_id
                                                          , vn_ex_ipi_id
                                                          , vn_ex_prac_id
                                                          , vn_ex_antd_id
                                                          , 'LICENCA'
                                                          , dcl.po_linha_id
                                                          );
        vt_licencas_lin.descricao                      := vc_descricao_long;
        vt_licencas_lin.excecao_ipi_id                 := vn_excecao_ipi_id;
        vt_licencas_lin.regtrib_ipi_id                 := vn_id_regtrib_ipi;
        vt_licencas_lin.ato_legal_id                   := vn_ato_legal_id;
        vt_licencas_lin.nr_ato_legal                   := vn_nr_ato_legal;
        vt_licencas_lin.orgao_emissor_id               := vn_orgao_emissor_id;
        vt_licencas_lin.ano_ato_legal                  := vn_ano_ato_legal;
        vt_licencas_lin.aliq_ipi_red                   := vn_aliq_ipi_red;
        vt_licencas_lin.excecao_icms_id                := vn_excecao_icms_id;
        vt_licencas_lin.regtrib_icms_id                := vn_id_regtrib_icms;
        vt_licencas_lin.aliq_icms                      := vn_aliq_icms;
        vt_licencas_lin.aliq_icms_red                  := vn_aliq_icms_red;
        vt_licencas_lin.aliq_icms_fecp                 := vn_aliq_icms_fecp_param;
        vt_licencas_lin.perc_red_icms                  := vn_perc_red_icms;
        vt_licencas_lin.regime_especial_icms           := nvl (vc_regime_especial, 'N');
        vt_licencas_lin.fundamento_legal_icms_id       := vn_fund_legal_icms_id;
        vt_licencas_lin.excecao_pis_cofins_id          := vn_excecao_pis_cofins_id;
        vt_licencas_lin.regtrib_pis_cofins_id          := vn_id_regtrib_pis_cofins;
        vt_licencas_lin.flag_reducao_base_pis_cofins   := vc_flag_red_base_pis_cofins;
        vt_licencas_lin.flegal_reducao_pis_cofins_id   := vn_flegal_red_pis_cofins_id;
        vt_licencas_lin.perc_reducao_base_pis_cofins   := vn_perc_red_pis_cofins;
        vt_licencas_lin.aliq_pis                       := vn_aliq_pis;
        vt_licencas_lin.aliq_pis_reduzida              := vn_aliq_pis_reduzida;
        vt_licencas_lin.aliq_cofins                    := vn_aliq_cofins;
        vt_licencas_lin.aliq_cofins_reduzida           := vn_aliq_cofins_reduzida;
        vt_licencas_lin.fundamento_legal_pis_cofins_id := vn_fund_legal_pis_cofins_id;
        vt_licencas_lin.aliq_pis_especifica            := vn_aliq_pis_especifica;
        vt_licencas_lin.aliq_cofins_especifica         := vn_aliq_cofins_especifica;
        vt_licencas_lin.un_medida_aliq_especifica_pc   := vc_um_aliq_especifica_pc;
        vt_licencas_lin.excecao_antid_id               := vn_excecao_antid_id;
        vt_licencas_lin.aliq_antid                     := vn_aliq_antid_ad_valorem;
        vt_licencas_lin.basecalc_antid                 := null;
        vt_licencas_lin.aliq_antid_especifica          := vn_aliq_especifica_antid;
        vt_licencas_lin.qtde_um_aliq_especifica_antid  := null;
        vt_licencas_lin.um_aliq_especifica_antid_id    := vn_um_aliq_especifica_antid_id;
        vt_licencas_lin.tipo_unidade_medida_antid      := vc_tipo_unidade_medida_antid;
        vt_licencas_lin.somatoria_quantidade           := vc_somatoria_quantidade;
        vt_licencas_lin.ato_legal_ncm_id               := null;
        vt_licencas_lin.orgao_emissor_ncm_id           := null;
        vt_licencas_lin.nr_ato_legal_ncm               := null;
        vt_licencas_lin.ano_ato_legal_ncm              := null;
        vt_licencas_lin.ato_legal_nbm_id               := null;
        vt_licencas_lin.orgao_emissor_nbm_id           := null;
        vt_licencas_lin.nr_ato_legal_nbm               := null;
        vt_licencas_lin.ano_ato_legal_nbm              := null;
        vt_licencas_lin.ato_legal_naladi_id            := null;
        vt_licencas_lin.orgao_emissor_naladi_id        := null;
        vt_licencas_lin.nr_ato_legal_naladi            := null;
        vt_licencas_lin.ano_ato_legal_naladi           := null;
        vt_licencas_lin.ato_legal_acordo_id            := null;
        vt_licencas_lin.orgao_emissor_acordo_id        := null;
        vt_licencas_lin.nr_ato_legal_acordo            := null;
        vt_licencas_lin.ano_ato_legal_acordo           := null;
        vt_licencas_lin.aliq_mva                       := vn_aliquota_mva;
        vt_licencas_lin.aliq_cofins_recuperar          := vn_aliq_cofins_recuperar_ncm;

        vt_licencas_lin.beneficio_suspensao            := vc_beneficio_suspensao;
        vt_licencas_lin.perc_beneficio_suspensao       := vn_perc_beneficio_suspensao;

        vc_step_error := 'Procedure IMP_PRC_GERA_LI_DRAWBACK.';
        vb_li_gerada  := false;

        --IF( vc_tp_declaracao <> '16' ) THEN
        IF (vc_tp_declaracao <> '16') AND (nvl (vc_tp_embarque, '*') <> 'RECOF') THEN

          vc_step_error := 'Buscando ato da linha do pedido.';

          vn_rd_id := NULL;
          OPEN  cur_po_rd_id (dcl.po_linha_id);
          FETCH cur_po_rd_id INTO vn_rd_id;
          CLOSE cur_po_rd_id;

          IF (vn_rd_id IS NOT null) THEN
            vc_quebra_qtde_drawback := 'N';
          ELSE
            vc_quebra_qtde_drawback := pc_quebra_qtde_drawback;
          END IF;

          imp_prc_gera_li_drawback (
             pn_empresa_id
           , vt_licencas_lin
           , ci.moeda_id
           , vc_quebra_qtde_drawback
           , null
           , vn_quantidade_gerar_linha_dcl
           , pn_user_id
           , vn_evento_id_drw
           , vc_tipo_log
           , vb_li_gerada
          );
        END IF;

        IF pn_evento_id IS null THEN
          pn_evento_id := vn_evento_id_drw;
        END IF;

        IF (vb_li_gerada) THEN
          pb_li_gerada := true;
        END IF;

        vc_step_error := null;

      END IF   ;


      /* Devemos adicionar a Adicao, nos casos de DSI
      */
      vn_adi_id := Null;
      IF (pc_flag_dsi = 'S') THEN
        vn_id_regtrib_ii := fnc_deduz_regtrib_ii_dsi;

        /* Quando o regime de tributação do II for IMUNIDADE (2) ou
           NAO INCIDENCIA (6), o regime de tributação do IPI deverá
           ser nulo.
        */
        IF (cmx_pkg_tabelas.codigo (vn_id_regtrib_ii) IN ('2', '6')) THEN
          vn_id_regtrib_ipi := null;
        END IF;

        vn_ins_estadual_id := NULL;

        OPEN cur_dados_ie (vn_id_regtrib_icms);
        FETCH cur_dados_ie INTO vn_ins_estadual_id;
        CLOSE cur_dados_ie;

        /* A origem destes parametros sao as linhas da invoice, portanto, alguns campos podem
           nao existir, por isso sao passados como NULL ou como constantes e poderao ser
           alterados na adicao da DSI, que sera gerada. Alguns tambem nao sao passados pois
           trata-se de uma DSI, onde nos nao levamos em conta todos os campos para quebra de
           adicao.
        */

        IF (cmx_fnc_profile('UTILIZA_AFRMM') = 'S') THEN
          IF (cmx_pkg_tabelas.codigo(vn_via_transporte_id) = '01' AND cmx_pkg_tabelas.codigo(pn_tp_declaracao_id) NOT IN ('04', '16')) THEN

            OPEN  cur_termo_pgto(dcl.termo_id);
            FETCH cur_termo_pgto INTO vn_motivo_sem_cobertura_id;
            CLOSE cur_termo_pgto;

            vn_benef_id := NULL;

            IF (vr_cert_origem_mercosul.cert_origem_mercosul_id IS NOT NULL) THEN
              imp_prc_benef_imp_linha_afrmm(vr_cert_origem_mercosul.cert_origem_mercosul_id, pn_empresa_id, pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, dcl.class_fiscal_id, dcl.item_id, dcl.utilizacao_id, pc_flag_dsi, vn_benef_id);
            END IF;
            IF (Nvl(vn_benef_id,0) = 0) THEN
              imp_prc_benef_lin_linha_afrmm(pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, dcl.class_fiscal_id, dcl.item_id, dcl.utilizacao_id, pn_empresa_id, pc_flag_dsi, vn_benef_id);
            END IF;

            IF (Nvl(vn_benef_id,0) = 0) THEN
              vn_benef_id := NULL;
            END IF;

          ELSE
            vn_benef_id := NULL;
          END IF;
        END IF;

        vn_aliq_icms_fecp_fiscal := NULL;
        OPEN cur_fecp_excecao_fiscal(vn_excecao_icms_id);
        FETCH cur_fecp_excecao_fiscal INTO vn_aliq_icms_fecp_fiscal;
        CLOSE cur_fecp_excecao_fiscal;

        vc_step_error := 'imp_fnc_gera_adicao_dcl - 1';
        vn_adi_id := imp_fnc_gera_adicao_dcl (
                         pn_declaracao_id
                       , pn_tp_declaracao_id
                       , null                          /* pn_declaracao_adi_id */
                       , '1'                           /* pc_tp_classificacao  */
                       , dcl.class_fiscal_id
                       , dcl.invoice_lin_id
                       , vn_id_regtrib_ii
                       , vn_id_regtrib_ipi
                       , null                          /* pn_aliq_ipi_red */
                       , null                          /* pn_perc_red_ii  */
                       , null                          /* pn_aliq_ii_red  */
                       , null                          /* pn_rd_id        */
                       , null                          /* pn_licenca_id   */
                       , vn_ausencia_fabric_gravar
                       , null                          /* pn_fabric_id      */
                       , null                          /* pn_fabric_site_id */
                       , vn_pais_origem_id
                       , dcl.item_id
                       , vn_naladi_sh_id
                       , vn_naladi_ncca_id
                       , null                          /* pn_ex_ncm_id    */
                       , null                          /* pn_ex_nbm_id    */
                       , null                          /* pn_ex_naladi_id */
                       , null                          /* pn_ex_ipi_id    */
                       , null                          /* pn_ex_prac_id   */
                       , null                          /* pn_ex_antd_id   */
                       , null                          /* pn_da_lin_id    */
                       , null                          /* pn_vida_util    */
                       , 'S'                           /* dsi             */
                       , sysdate
                       , pn_user_id
                       , sysdate
                       , pn_user_id
                       , null                          /* pn_fudamento_legal_id          */
                       , null                          /* pn_ato_legal_id                */
                       , null                          /* pn_orgao_emissor_id            */
                       , null                          /* pn_nr_ato_legal                */
                       , null                          /* pn_ano_ato_legal               */
                       , vn_id_regtrib_icms            /* pn_regtrib_icms_id             */
                       , vn_aliq_icms                  /* pn_aliq_icms                   */
                       , vn_aliq_icms_red              /* pn_aliq_icms_red               */
                       , vn_perc_red_icms              /* pn_perc_red_icms               */
                       , Nvl(vn_aliq_icms_fecp_fiscal,vn_aliq_icms_fecp_param)       /* pn_aliq_icms_fecp              */
                       , vn_fund_legal_icms_id         /* pn_fund_legal_icms_id          */
                       , vn_id_regtrib_pis_cofins      /* pn_regtrib_pis_cofins_id       */
                       , vn_aliq_pis                   /* pn_aliq_pis                    */
                       , vn_aliq_cofins                /* pn_aliq_cofins                 */
                       , vn_perc_red_pis_cofins        /* pn_perc_red_base_pis_cofins    */
                       , vn_fund_legal_pis_cofins_id   /* pn_fund_legal_pis_cofins_id    */
                       , vc_flag_red_base_pis_cofins   /* pn_flag_red_base_pis_cofins    */
                       , vn_flegal_red_pis_cofins_id   /* pn_flegal_red_pis_cofins_id    */
                       , vn_aliq_pis_reduzida          /* pn_aliq_pis_reduzida           */
                       , vn_aliq_cofins_reduzida       /* pn_aliq_cofins_reduzida        */
                       , vc_regime_especial            /* pc_regime_especial_icms        */
                       , vn_aliq_pis_especifica        /* pn_aliq_pis_especifica         */
                       , vn_aliq_cofins_especifica     /* pn_aliq_cofins_especifica      */
                       , vn_qtde_um_aliq_especifica_pc /* pn_qtde_um_aliq_especifica_pc  */
                       , vc_um_aliq_especifica_pc      /* pc_um_aliq_especifica_pc       */
                       , null                          /* pn_acordo_aladi_id             */
                       , null                          /* pn_cert_origem_mercosul_id     */
                       , null                          /* pn_aliq_antid_ad_valorem       */
                       , null                          /* pn_aliq_antid_especifica       */
                       , null                          /* pn_um_aliq_especifica_antid_id */
                       , null                          /* pc_somatoria_quantidade        */ -- relacionado ao antidumping
                       , null                          /* pn_ato_legal_ii_id             */
                       , null                          /* pn_orgao_emissor_ii_id         */
                       , null                          /* pn_nr_ato_legal_ii             */
                       , null                          /* pn_ano_ato_legal_ii            */
                       , null                          /* pn_ato_legal_ii_id             */
                       , null                          /* pn_orgao_emissor_ii_id         */
                       , null                          /* pn_nr_ato_legal_ii             */
                       , null                          /* pn_ano_ato_legal_ii            */
                       , null                          /* pn_ato_legal_ii_id             */
                       , null                          /* pn_orgao_emissor_ii_id         */
                       , null                          /* pn_nr_ato_legal_ii             */
                       , null                          /* pn_ano_ato_legal_ii            */
                       , null                          /* pn_ato_legal_ii_id             */
                       , null                          /* pn_orgao_emissor_ii_id         */
                       , null                          /* pn_nr_ato_legal_ii             */
                       , null                          /* pn_ano_ato_legal_ii            */
                       , vn_aliquota_mva               /* pn_aliquota_mva                */
                       , vc_pro_emprego                /* pc_pro_emprego                 */
                       , vn_aliq_base_pro_emprego      /* pn_aliq_base_pro_emprego       */
                       , vn_aliq_antecip_pro_emprego   /* pn_aliq_antecip_pro_emprego    */
                       , vc_beneficio_pr               /* pc_beneficio_pr                */
                       , vn_aliq_base_pr               /* pn_aliq_base_pr                */
                       , vn_perc_diferido_pr           /* pn_perc_diferido_pr            */
                       , vn_ins_estadual_id            /* pn_ins_estadual_id             */
                       , vn_pr_perc_vr_devido          /* pn_pr_perc_vr_devido           */
                       , vn_pr_perc_minimo_base        /* pn_pr_perc_minimo_base         */
                       , vn_pr_perc_minimo_suspenso    /* pn_pr_perc_minimo_suspenso     */
                       , vc_beneficio_sp               /* pc_beneficio_sp                */
                       , vn_benef_id                   /* pn_benef_id                    */
                       , NULL                          /* pn_vlr_frete_afrmm             */
                       , vc_beneficio_suspensao        /* pc_beneficio_suspensao         */
                       , vn_perc_beneficio_suspensao   /* pn_perc_beneficio_suspensao    */
                      );

        vc_step_error := null;

      END IF; /* (pc_flag_dsi = 'S') */

      -- Se esta variável for igual a 0 significa que a quantidade do item foi totalmente
      -- consumida em LI, então não é necessário criar a linha de declaração
      -- Se ela for maior que 0, então terá que criar a linha de declaração com o restante
      -- ou tota a quantidade que não foi consumida em LI

      IF vn_quantidade_gerar_linha_dcl <> 0 THEN
        vc_step_error := 'Insert into imp_declaracoes_lin fase 1';
        OPEN  cur_max_lin_num_di;
        FETCH cur_max_lin_num_di into vn_linha_num;
        CLOSE cur_max_lin_num_di;
        vn_linha_num  := vn_linha_num + 1;

        IF (vt_cdh.via_transporte_id = cmx_pkg_tabelas.tabela_id ('912', '5')) THEN
          vn_id_regtrib_pis_cofins := cmx_pkg_tabelas.tabela_id ('141', '1');
        END IF;


         -- Retirada a validação para Nacionalização de Admissão temporaria (13), porque
         -- a maioria das vezes temos admissões sem codigo de produto e não se
         -- consegue fazer o controle de saldos sem codigo de produto.
         IF (pc_flag_dsi = 'N') AND (vc_tp_declaracao = '15' OR (vc_tp_declaracao = '14' AND Nvl(pc_nac_sem_vinc_admissao,'N') = 'N')) THEN
           prc_preenche_globais_ato_legal;

           vc_descricao_long:= imp_fnc_busca_descricao_item(
                                                              pn_empresa_id
                                                            , dcl.item_id
                                                            , dcl.invoice_lin_id
                                                            , null
                                                            , vn_ex_ncm_id
                                                            , vn_ex_nbm_id
                                                            , vn_ex_naladi_id
                                                            , vn_ex_ipi_id
                                                            , vn_ex_prac_id
                                                            , vn_ex_antd_id
                                                            , 'DECLARACAO'
                                                            , dcl.po_linha_id
                                                            );

           IF (dcl.item_id IS null) THEN
             OPEN  cur_item_nac (dcl.invoice_lin_id);
             FETCH cur_item_nac INTO vn_da_lin_id;
             CLOSE cur_item_nac;

             IF (vn_da_lin_id IS NOT null) THEN

               imp_pkg_nacionalizacao.gerar (
                  vn_declaracao_id                                /* 01 */
                , vc_tp_declaracao                                /* 02 */
                , pn_empresa_id                                   /* 03 */
                , pn_embarque_id                                  /* 04 */
                , dcl.invoice_id                                  /* 05 */
                , dcl.invoice_lin_id                              /* 06 */
                , dcl.item_id                                     /* 07 */
                , vc_descricao_long                               /* 08 */
                , dcl.un_medida_id                                /* 09 */
                , dcl.qtde                                        /* 10 */
                , dcl.preco_unitario_m                            /* 11 */
                , dcl.class_fiscal_id                             /* 12 */
                , dcl.utilizacao_id                               /* 13 */
                , nvl (vn_cfop_id_padrao, dcl.cfop_id)            /* 14 */
                , dcl.pesoliq_tot                                 /* 15 */
                , dcl.pesoliq_unit                                /* 16 */
                , vn_id_regtrib_ii                                /* 17 */
                , vn_id_regtrib_ipi                               /* 18 */
                , vn_id_regtrib_icms                              /* 19 */
                , vn_ex_ncm_id                                    /* 20 */
                , vn_ex_nbm_id                                    /* 21 */
                , vn_ex_naladi_id                                 /* 22 */
                , vn_ex_prac_id                                   /* 23 */
                , vn_ex_antd_id                                   /* 24 */
                , vn_ex_ipi_id                                    /* 25 */
                , vn_aliq_ii_red                                  /* 26 */
                , vn_perc_red_ii                                  /* 27 */
                , vn_aliq_ipi_red                                 /* 28 */
                , vn_aliq_icms_red                                /* 29 */
                , vn_perc_red_icms                                /* 30 */
                , vn_aliq_icms                                    /* 31 */
                , pn_user_id                                      /* 32 */
                , vn_excecao_icms_id                              /* 33 */
                , vn_excecao_ipi_id                               /* 34 */
                , vn_excecao_ii_id                                /* 35 */
                , vn_aliq_pis                                     /* 36 */
                , vn_aliq_cofins                                  /* 37 */
                , vn_perc_red_pis_cofins                          /* 38 */
                , vn_excecao_pis_cofins_id                        /* 39 */
                , vn_id_regtrib_pis_cofins                        /* 40 */
                , vn_fundamento_legal_id                          /* 41 */
                , vn_ato_legal_id                                 /* 42 */
                , vn_orgao_emissor_id                             /* 43 */
                , vn_nr_ato_legal                                 /* 44 */
                , vn_ano_ato_legal                                /* 45 */
                , pn_da_id                                        /* 46 */
                , vn_da_lin_id  -- pn_da_lin_id                   /* 47 */
                , null          -- licenca_id                     /* 48 */
                , null          -- licenca_lin_id                 /* 49 */
                , null          -- ausencia_fabric                /* 50 */
                , null          -- fabric_id                      /* 51 */
                , null          -- fabric_site_id                 /* 52 */
                , null          -- fabric_part_number             /* 53 */
                , null          -- pais_origem_id
                , vn_naladi_sh_id
                , vn_naladi_ncca_id
                , null  -- rd_id
                , ci.moeda_id  /* Para gerar a LI de Drawback precisamos da moeda id */
                , vn_linha_num
                , vn_evento_id
                , vb_erro_nacionalizacao
                , pc_gera_li_drawback
                , pc_quebra_qtde_drawback
                , pb_li_gerada
                , vn_aliq_icms_fecp_param
                , vn_fund_legal_icms_id
                , vn_fund_legal_pis_cofins_id
                , vn_flegal_red_pis_cofins_id
                , vn_aliq_pis_reduzida
                , vn_aliq_cofins_reduzida
                , vc_flag_red_base_pis_cofins
                , vc_regime_especial                -- pc_regime_especial_icms
                , vn_aliq_pis_especifica            -- pn_aliq_pis_especifica
                , vn_aliq_cofins_especifica         -- pn_aliq_cofins_especifica
                , vn_qtde_um_aliq_especifica_pc     -- pn_qtde_um_aliq_especifica_pc
                , vc_um_aliq_especifica_pc          -- pc_um_aliq_especifica_pc
                , vn_excecao_antid_id               -- pn_excecao_antid_id
                , vn_aliq_antid_ad_valorem          -- pn_aliq_antid
                , null                              -- pn_basecalc_antid
                , vn_aliq_especifica_antid          -- pn_aliq_antid_especifica
                , null                              -- pn_qtde_um_aliq_especif_antid
                , vn_um_aliq_especifica_antid_id    -- pn_um_aliq_especifica_antid_id
                , vc_tipo_unidade_medida_antid      -- pc_tipo_unidade_medida_antid
                , vc_somatoria_quantidade           -- pc_somatoria_quantidade
                , gn_ato_legal_ncm_id               -- pn_ato_legal_ncm_id
                , gn_orgao_emissor_ncm_id           -- pn_orgao_emissor_ncm_id
                , gn_nr_ato_legal_ncm               -- pn_nr_ato_legal_ncm
                , gn_ano_ato_legal_ncm              -- pn_ano_ato_legal_ncm
                , gn_ato_legal_nbm_id               -- pn_ato_legal_nbm_id
                , gn_orgao_emissor_nbm_id           -- pn_orgao_emissor_nbm_id
                , gn_nr_ato_legal_nbm               -- pn_nr_ato_legal_nbm
                , gn_ano_ato_legal_nbm              -- pn_ano_ato_legal_nbm
                , gn_ato_legal_naladi_id            -- pn_ato_legal_naladi_id
                , gn_orgao_emissor_naladi_id        -- pn_orgao_emissor_naladi_id
                , gn_nr_ato_legal_naladi            -- pn_nr_ato_legal_naladi
                , gn_ano_ato_legal_naladi           -- pn_ano_ato_legal_naladi
                , gn_ato_legal_acordo_id            -- pn_ato_legal_acordo_id
                , gn_orgao_emissor_acordo_id        -- pn_orgao_emissor_acordo_id
                , gn_nr_ato_legal_acordo            -- pn_nr_ato_legal_acordo
                , gn_ano_ato_legal_acordo           -- pn_ano_ato_legal_acordo
                , vn_aliquota_mva
                , vn_aliq_cofins_recuperar_ncm
              );

             vn_da_lin_id := null;

             END IF;

           ELSE

             vn_da_lin_id := null;

             imp_pkg_nacionalizacao.gerar (
                vn_declaracao_id
              , vc_tp_declaracao
              , pn_empresa_id
              , pn_embarque_id
              , dcl.invoice_id
              , dcl.invoice_lin_id
              , dcl.item_id
              , vc_descricao_long
              , dcl.un_medida_id
              , dcl.qtde
              , dcl.preco_unitario_m
              , dcl.class_fiscal_id
              , dcl.utilizacao_id
              , nvl (vn_cfop_id_padrao, dcl.cfop_id)
              , dcl.pesoliq_tot
              , dcl.pesoliq_unit
              , vn_id_regtrib_ii
              , vn_id_regtrib_ipi
              , vn_id_regtrib_icms
              , vn_ex_ncm_id
              , vn_ex_nbm_id
              , vn_ex_naladi_id
              , vn_ex_prac_id
              , vn_ex_antd_id
              , vn_ex_ipi_id
              , vn_aliq_ii_red
              , vn_perc_red_ii
              , vn_aliq_ipi_red
              , vn_aliq_icms_red
              , vn_perc_red_icms
              , vn_aliq_icms
              , pn_user_id
              , vn_excecao_icms_id
              , vn_excecao_ipi_id
              , vn_excecao_ii_id
              , vn_aliq_pis
              , vn_aliq_cofins
              , vn_perc_red_pis_cofins
              , vn_excecao_pis_cofins_id
              , vn_id_regtrib_pis_cofins
              , vn_fundamento_legal_id
              , vn_ato_legal_id
              , vn_orgao_emissor_id
              , vn_nr_ato_legal
              , vn_ano_ato_legal
              , pn_da_id
              , vn_da_lin_id  -- pn_da_lin_id
              , null          -- licenca_id
              , null          -- licenca_lin_id
              , null          -- ausencia_fabric
              , null          -- fabric_id
              , null          -- fabric_site_id
              , null          -- fabric_part_number
              , null          -- pais_origem_id
              , vn_naladi_sh_id
              , vn_naladi_ncca_id
              , null  -- rd_id
              , ci.moeda_id  /* Para gerar a LI de Drawback precisamos da moeda id */
              , vn_linha_num
              , vn_evento_id
              , vb_erro_nacionalizacao
              , pc_gera_li_drawback
              , pc_quebra_qtde_drawback
              , pb_li_gerada
              , vn_aliq_icms_fecp_param
              , vn_fund_legal_icms_id
              , vn_fund_legal_pis_cofins_id
              , vn_flegal_red_pis_cofins_id
              , vn_aliq_pis_reduzida
              , vn_aliq_cofins_reduzida
              , vc_flag_red_base_pis_cofins
              , vc_regime_especial                -- pc_regime_especial_icms
              , vn_aliq_pis_especifica            -- pn_aliq_pis_especifica
              , vn_aliq_cofins_especifica         -- pn_aliq_cofins_especifica
              , vn_qtde_um_aliq_especifica_pc     -- pn_qtde_um_aliq_especifica_pc
              , vc_um_aliq_especifica_pc          -- pc_um_aliq_especifica_pc
              , vn_excecao_antid_id               -- pn_excecao_antid_id
              , vn_aliq_antid_ad_valorem          -- pn_aliq_antid
              , null                              -- pn_basecalc_antid
              , vn_aliq_especifica_antid          -- pn_aliq_antid_especifica
              , null                              -- pn_qtde_um_aliq_especif_antid
              , vn_um_aliq_especifica_antid_id    -- pn_um_aliq_especifica_antid_id
              , vc_tipo_unidade_medida_antid      -- pc_tipo_unidade_medida_antid
              , vc_somatoria_quantidade           -- pc_somatoria_quantidade
              , gn_ato_legal_ncm_id               -- pn_ato_legal_ncm_id
              , gn_orgao_emissor_ncm_id           -- pn_orgao_emissor_ncm_id
              , gn_nr_ato_legal_ncm               -- pn_nr_ato_legal_ncm
              , gn_ano_ato_legal_ncm              -- pn_ano_ato_legal_ncm
              , gn_ato_legal_nbm_id               -- pn_ato_legal_nbm_id
              , gn_orgao_emissor_nbm_id           -- pn_orgao_emissor_nbm_id
              , gn_nr_ato_legal_nbm               -- pn_nr_ato_legal_nbm
              , gn_ano_ato_legal_nbm              -- pn_ano_ato_legal_nbm
              , gn_ato_legal_naladi_id            -- pn_ato_legal_naladi_id
              , gn_orgao_emissor_naladi_id        -- pn_orgao_emissor_naladi_id
              , gn_nr_ato_legal_naladi            -- pn_nr_ato_legal_naladi
              , gn_ano_ato_legal_naladi           -- pn_ano_ato_legal_naladi
              , gn_ato_legal_acordo_id            -- pn_ato_legal_acordo_id
              , gn_orgao_emissor_acordo_id        -- pn_orgao_emissor_acordo_id
              , gn_nr_ato_legal_acordo            -- pn_nr_ato_legal_acordo
              , gn_ano_ato_legal_acordo           -- pn_ano_ato_legal_acordo
              , vn_aliquota_mva
              , vn_aliq_cofins_recuperar_ncm
             );
           END IF;

        ELSIF (pc_flag_dsi = 'N') AND (vc_dtr_numero IS NOT NULL ) THEN
           prc_preenche_globais_ato_legal;

           vc_descricao_long:= imp_fnc_busca_descricao_item(
                                                             pn_empresa_id
                                                           , dcl.item_id
                                                           , dcl.invoice_lin_id
                                                           , null
                                                           , vn_ex_ncm_id
                                                           , vn_ex_nbm_id
                                                           , vn_ex_naladi_id
                                                           , vn_ex_ipi_id
                                                           , vn_ex_prac_id
                                                           , vn_ex_antd_id
                                                           , 'DECLARACAO'
                                                           , dcl.po_linha_id
                                                           );
           imp_pkg_dtr_di.gerar (
             vn_declaracao_id
           , vc_tp_declaracao
           , pn_empresa_id
           , pn_embarque_id
           , dcl.invoice_id
           , dcl.invoice_lin_id
           , dcl.item_id
           , vc_descricao_long
           , dcl.un_medida_id
           , dcl.qtde
           , dcl.preco_unitario_m
           , dcl.class_fiscal_id
           , dcl.utilizacao_id
           , nvl (vn_cfop_id_padrao, dcl.cfop_id)
           , dcl.pesoliq_tot
           , dcl.pesoliq_unit
           , vn_id_regtrib_ii
           , vn_id_regtrib_ipi
           , vn_id_regtrib_icms
           , vn_ex_ncm_id
           , vn_ex_nbm_id
           , vn_ex_naladi_id
           , vn_ex_prac_id
           , vn_ex_antd_id
           , vn_ex_ipi_id
           , vn_aliq_ii_red
           , vn_perc_red_ii
           , vn_aliq_ipi_red
           , vn_aliq_icms_red
           , vn_perc_red_icms
           , vn_aliq_icms
           , pn_user_id
           , vn_excecao_icms_id
           , vn_excecao_ipi_id
           , vn_excecao_ii_id
           , vn_aliq_pis
           , vn_aliq_cofins
           , vn_perc_red_pis_cofins
           , vn_excecao_pis_cofins_id
           , vn_id_regtrib_pis_cofins
           , vn_fundamento_legal_id
           , vn_ato_legal_id
           , vn_orgao_emissor_id
           , vn_nr_ato_legal
           , vn_ano_ato_legal
           , pn_da_id
           , null  -- pn_da_lin_id
           , null  -- licenca_id
           , null  -- licenca_lin_id
           , vn_ausencia_fabric_gravar                                  -- ausencia_fabric
           , dcl.fabric_id-- fabric_id
           , dcl.fabric_site_id        -- fabric_site_id
           , dcl.fabric_part_number                                     -- fabric_part_number
           , vn_pais_origem_id                                          -- pais_origem_id
           , vn_naladi_sh_id
           , vn_naladi_ncca_id
           , null  -- rd_id
           , ci.moeda_id  /* Para gerar a LI de Drawback precisamos da moeda id */
           , vn_linha_num
           , vn_evento_id
           , vb_erro_nacionalizacao
           , pc_gera_li_drawback
           , pc_quebra_qtde_drawback
           , pb_li_gerada
           , vn_aliq_icms_fecp_param
           , vn_fund_legal_icms_id
           , vn_fund_legal_pis_cofins_id
           , vn_flegal_red_pis_cofins_id
           , vn_aliq_pis_reduzida
           , vn_aliq_cofins_reduzida
           , vc_flag_red_base_pis_cofins
           , vc_regime_especial            /* pc_regime_especial_icms       */
           , vn_aliq_pis_especifica        /* pn_aliq_pis_especifica        */
           , vn_aliq_cofins_especifica     /* pn_aliq_cofins_especifica     */
           , vn_qtde_um_aliq_especifica_pc /* pn_qtde_um_aliq_especifica_pc */
           , vc_um_aliq_especifica_pc      /* pc_um_aliq_especifica_pc      */
           , gn_ato_legal_ncm_id
           , gn_orgao_emissor_ncm_id
           , gn_nr_ato_legal_ncm
           , gn_ano_ato_legal_ncm
           , gn_ato_legal_nbm_id
           , gn_orgao_emissor_nbm_id
           , gn_nr_ato_legal_nbm
           , gn_ano_ato_legal_nbm
           , gn_ato_legal_naladi_id
           , gn_orgao_emissor_naladi_id
           , gn_nr_ato_legal_naladi
           , gn_ano_ato_legal_naladi
           , gn_ato_legal_acordo_id
           , gn_orgao_emissor_acordo_id
           , gn_nr_ato_legal_acordo
           , gn_ano_ato_legal_acordo
          );

        ELSIF (pc_flag_dsi = 'S') OR ((pc_flag_dsi = 'N') AND (vc_tp_declaracao NOT IN ('14', '15') OR (vc_tp_declaracao = '14' AND Nvl(pc_nac_sem_vinc_admissao,'N') = 'S'))) THEN

          vn_declaracao_lin_id := cmx_fnc_proxima_sequencia ('imp_declaracoes_lin_sq1');

          IF (vr_cert_origem_mercosul.ex_naladi_id IS NOT null) THEN
            vn_ex_naladi_id := vr_cert_origem_mercosul.ex_naladi_id;
          END IF;
          IF (vc_tp_declaracao = '13') THEN
            OPEN  cur_busca_dados_da_adm_temp (dcl.invoice_lin_id, vn_quantidade_gerar_linha_dcl);
            FETCH cur_busca_dados_da_adm_temp INTO reg_da_adm_temp;
            CLOSE cur_busca_dados_da_adm_temp;

            IF(reg_da_adm_temp.declaracao_lin_id IS NULL) THEN
              OPEN  cur_busca_dados_da_adm_temp (dcl.invoice_lin_id, NULL);
              FETCH cur_busca_dados_da_adm_temp INTO reg_da_adm_temp;
              CLOSE cur_busca_dados_da_adm_temp;
            END IF;

            vn_dcl_lin_da_id     := reg_da_adm_temp.declaracao_id;
            vn_dcl_lin_da_lin_id := reg_da_adm_temp.declaracao_lin_id;
          ELSE
            vn_dcl_lin_da_id     := dcl.da_id;
            vn_dcl_lin_da_lin_id := dcl.da_lin_id;
          END IF;

         IF (pc_flag_dsi = 'N') AND (vc_tp_declaracao = '12') THEN
           OPEN  cur_item_com_rcr (dcl.invoice_lin_id);
           FETCH cur_item_com_rcr INTO vn_dummy;
           vb_linha_ivc_tem_rcr := cur_item_com_rcr%FOUND;
           CLOSE cur_item_com_rcr;

           IF (vb_linha_ivc_tem_rcr) THEN
             IF (vn_excecao_ii_id IS null) THEN
               vn_id_regtrib_ii := cmx_pkg_tabelas.tabela_id ('104', '5'); -- suspensao
             END IF;

             IF (vn_excecao_ipi_id IS null) THEN
               vn_id_regtrib_ipi := cmx_pkg_tabelas.tabela_id ('105', '5'); -- suspensao
             END IF;

             IF (vn_excecao_pis_cofins_id IS null) THEN
               vn_id_regtrib_pis_cofins := cmx_pkg_tabelas.tabela_id ('141', '2'); -- suspensao
             END IF;
           END IF;
         END IF;

          prc_preenche_globais_ato_legal;

          vc_descricao_long:= imp_fnc_busca_descricao_item (
                                                             pn_empresa_id
                                                           , dcl.item_id
                                                           , dcl.invoice_lin_id
                                                           , null
                                                           , vn_ex_ncm_id
                                                           , vn_ex_nbm_id
                                                           , vn_ex_naladi_id
                                                           , vn_ex_ipi_id
                                                           , vn_ex_prac_id
                                                           , vn_ex_antd_id
                                                           , 'DECLARACAO'
                                                           , dcl.po_linha_id
                                                          );

        vc_step_error := 'Atribuindo regime de tributação de II, IPI e PIS/COFINS troca em garantia';
          OPEN cur_vinculo_exp(pn_invoice_id);
          FETCH cur_vinculo_exp INTO vc_re_vinc_exp;
          vb_achou_vinc_exp := cur_vinculo_exp%FOUND;
          CLOSE cur_vinculo_exp;
          IF vb_achou_vinc_exp THEN
            vn_id_regtrib_ii          := cmx_pkg_tabelas.tabela_id ('104', 6);  -- 'nao incidencia'
            vn_id_regtrib_ipi         := cmx_pkg_tabelas.tabela_id ('105', 3); -- 'nao tributavel'
            vn_id_regtrib_pis_cofins  := cmx_pkg_tabelas.tabela_id ('141', 5);  -- 'nao incidencia'
          END IF;

          vn_ins_estadual_id := NULL;

          OPEN cur_dados_ie (vn_id_regtrib_icms);
          FETCH cur_dados_ie INTO vn_ins_estadual_id;
          CLOSE cur_dados_ie;

          vn_aliq_ii_rec := NULL;
          OPEN cur_vlr_aliq_ii_rec ( vr_cert_origem_mercosul.cert_origem_mercosul_id
                                   , dcl.invoice_lin_id);
          FETCH cur_vlr_aliq_ii_rec INTO vn_aliq_ii_rec;
          CLOSE cur_vlr_aliq_ii_rec;
          vn_aliq_ii_rec := Nvl (vn_aliq_ii_rec, 0);

          -- Zerando
          vc_recof_dcl := 'N';
          OPEN cur_ex_fiscais_recof(vn_excecao_ii_id);
          FETCH cur_ex_fiscais_recof INTO vc_recof_dcl;
          CLOSE cur_ex_fiscais_recof;

          /* Aqui é verificado o benefício. Se existir certificado mercosul/aladi, verifica na tela
             de benefício afrmm o primeiro benefício que encontrar cujo radio button esteja
             setado como Mercosul/Aladi.
             Se não encontrar nenhum benefício ou também não existir certificado mercosul/aladi,
             então, busca o benefício conforme a regra:
             Tipo/Natureza
             Motivo sem cobertura cambial
             NCM
             Utilização
             Segundo a Izabela, não existirá retorno de mais de um benefício, ou seja, utilizando
             essa regra acima, só existirá apenas 1 benefício.
             Também é validado se o conhecimento de transporte é MARÍTIMO.
           */

          IF (cmx_fnc_profile('UTILIZA_AFRMM') = 'S') THEN
            IF (cmx_pkg_tabelas.codigo(vn_via_transporte_id) = '01' AND cmx_pkg_tabelas.codigo(pn_tp_declaracao_id) NOT IN ('04', '16')) THEN

              OPEN  cur_termo_pgto(dcl.termo_id);
              FETCH cur_termo_pgto INTO vn_motivo_sem_cobertura_id;
              CLOSE cur_termo_pgto;

              vn_benef_id := NULL;

              IF (vr_cert_origem_mercosul.cert_origem_mercosul_id IS NOT NULL) THEN
                imp_prc_benef_imp_linha_afrmm(vr_cert_origem_mercosul.cert_origem_mercosul_id, pn_empresa_id, pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, dcl.class_fiscal_id, dcl.item_id, dcl.utilizacao_id, pc_flag_dsi, vn_benef_id);
              END IF;
              IF (Nvl(vn_benef_id,0) = 0) THEN
                imp_prc_benef_lin_linha_afrmm(pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, dcl.class_fiscal_id, dcl.item_id, dcl.utilizacao_id, pn_empresa_id, pc_flag_dsi, vn_benef_id);
              END IF;

              IF (Nvl(vn_benef_id,0) = 0) THEN
                vn_benef_id := NULL;
              END IF;

            ELSE
              vn_benef_id := NULL;
            END IF;
          END IF;

          vc_step_error := 'Validar NCM inativa 1';
          vn_ncm_id := dcl.class_fiscal_id;

          cmx_prc_validar_ncm ( pn_declaracao_id => pn_declaracao_id
                              , pc_flag_dsi      => pc_flag_dsi
                              , pn_item_id       => dcl.item_id
                              , pc_substitui_ncm => 'S'
                              , pn_ncm_id        => vn_ncm_id
                              , pc_log_tipo      => vc_log_tipo
                              , pc_log_desc      => vc_log_desc
                              , pc_log_solu      => vc_log_solu );

          IF(vc_log_desc IS NOT NULL)THEN

            IF(NOT(vb_ncm_evento))THEN

              IF (pn_evento_id IS NULL) THEN
                pn_evento_id := cmx_fnc_gera_evento( 'Validação de utilização de NCMs inativas'
                                                   , SYSDATE
                                                   , pn_user_id
                                                   );
                vb_ncm_evento := TRUE;
              END IF;

            END IF;

            cmx_prc_gera_log_erros ( pn_evento_id
                                   , vc_log_desc
                                   , vc_log_tipo
                                   , vc_log_solu
                                   );

            IF(vc_log_tipo = 'E')THEN
              vb_ncm_erro := TRUE;
            END IF;

          END IF;

          OPEN  cur_item_com_rcr(dcl.invoice_lin_id);
          FETCH cur_item_com_rcr INTO vn_dummy;
          vb_linha_ivc_tem_rcr := cur_item_com_rcr%FOUND;
          CLOSE cur_item_com_rcr;

          IF (vb_linha_ivc_tem_rcr) THEN
            vc_admissao_temporaria := 'S';
          ELSE
            vc_admissao_temporaria := 'N';
          END IF;

          vn_aliq_icms_fecp_fiscal := NULL;
          OPEN cur_fecp_excecao_fiscal(vn_excecao_icms_id);
          FETCH cur_fecp_excecao_fiscal INTO vn_aliq_icms_fecp_fiscal;
          CLOSE cur_fecp_excecao_fiscal;

          IF(vc_tratar_icms_deso_emiss_nfe = 'S')THEN
            vn_icms_motivo_desoneracao_id := NULL;
            OPEN cur_excecao_motivo_desoneracao(vn_excecao_icms_id);
            FETCH cur_excecao_motivo_desoneracao INTO vn_icms_motivo_desoneracao_id;
            CLOSE cur_excecao_motivo_desoneracao;
          END IF;

          vc_step_error := 'Insert INTO imp_declaracoes_lin 1';
          INSERT INTO imp_declaracoes_lin (
             declaracao_adi_id              /* 000 */
           , declaracao_lin_id              /* 001 */
           , declaracao_id                  /* 002 */
           , linha_num                      /* 003 */
           , invoice_id                     /* 004 */
           , invoice_lin_id                 /* 005 */
           , item_id                        /* 006 */
           , descricao                      /* 007 */
           , un_medida_id                   /* 008 */
           , qtde                           /* 009 */
           , preco_unitario_m               /* 010 */
           , tp_classificacao               /* 011 */
           , class_fiscal_id                /* 012 */
           , naladi_sh_id                   /* 013 */
           , naladi_ncca_id                 /* 014 */
           , ausencia_fabric                /* 015 */
           , fabric_id                      /* 016 */
           , fabric_site_id                 /* 017 */
           , fabric_part_number             /* 018 */
           , pais_origem_id                 /* 019 */
           , pesoliq_tot                    /* 020 */
           , pesoliq_unit                   /* 021 */
           , regtrib_ii_id                  /* 022 */
           , regtrib_ipi_id                 /* 023 */
           , regtrib_icms_id                /* 024 */
           , utilizacao_id                  /* 025 */
           , ex_ncm_id                      /* 026 */
           , ex_nbm_id                      /* 027 */
           , ex_naladi_id                   /* 028 */
           , ex_ipi_id                      /* 029 */
           , ex_prac_id                     /* 030 */
           , ex_antd_id                     /* 031 */
           , nfe_a_imprimir                 /* 032 */
           , aliq_ii_red                    /* 033 */
           , perc_red_ii                    /* 034 */
           , aliq_ipi_red                   /* 035 */
           , aliq_icms_red                  /* 036 */
           , perc_red_icms                  /* 037 */
           , aliq_icms                      /* 038 */
           , cfop_id                        /* 039 */
           , creation_date                  /* 040 */
           , created_by                     /* 041 */
           , last_update_date               /* 042 */
           , last_updated_by                /* 043 */
           , excecao_icms_id                /* 044 */
           , excecao_ipi_id                 /* 045 */
           , excecao_ii_id                  /* 046 */
           , grupo_acesso_id                /* 047 */
           , aliq_pis                       /* 048 */
           , aliq_cofins                    /* 049 */
           , perc_reducao_base_pis_cofins   /* 050 */
           , excecao_pis_cofins_id          /* 051 */
           , regtrib_pis_cofins_id          /* 052 */
           , fundamento_legal_id            /* 053 */
           , ato_legal_id                   /* 054 */
           , orgao_emissor_id               /* 055 */
           , nr_ato_legal                   /* 056 */
           , ano_ato_legal                  /* 057 */
           , aliq_icms_fecp                 /* 058 */
           , fundamento_legal_icms_id       /* 059 */
           , fundamento_legal_pis_cofins_id /* 060 */
           , da_id                          /* 061 */ -- Somente para Recof
           , da_lin_id                      /* 062 */ -- Somente para Recof
           , flag_reducao_base_pis_cofins   /* 063 */
           , flegal_reducao_pis_cofins_id   /* 064 */
           , aliq_pis_reduzida              /* 065 */
           , aliq_cofins_reduzida           /* 066 */
           , regime_especial_icms           /* 067 */
           , aliq_pis_especifica            /* 068 */
           , aliq_cofins_especifica         /* 069 */
           , qtde_um_aliq_especifica_pc     /* 070 */
           , un_medida_aliq_especifica_pc   /* 071 */
           , acordo_aladi_id                /* 072 */
           , cert_origem_mercosul_id        /* 073 */
           , da_invoice_lin_id              /* 074 */
           , excecao_antid_id               /* 075 */
           , aliq_antid                     /* 076 */
           , aliq_antid_especifica          /* 077 */
           , tipo_unidade_medida_antid      /* 078 */
           , somatoria_quantidade           /* 079 */
           , um_aliq_especifica_antid_id    /* 080 */
           , ato_legal_ncm_id               /* 081 */
           , orgao_emissor_ncm_id           /* 082 */
           , nr_ato_legal_ncm               /* 083 */
           , ano_ato_legal_ncm              /* 084 */
           , ato_legal_nbm_id               /* 085 */
           , orgao_emissor_nbm_id           /* 086 */
           , nr_ato_legal_nbm               /* 087 */
           , ano_ato_legal_nbm              /* 088 */
           , ato_legal_naladi_id            /* 089 */
           , orgao_emissor_naladi_id        /* 090 */
           , nr_ato_legal_naladi            /* 091 */
           , ano_ato_legal_naladi           /* 092 */
           , ato_legal_acordo_id            /* 093 */
           , orgao_emissor_acordo_id        /* 094 */
           , nr_ato_legal_acordo            /* 095 */
           , ano_ato_legal_acordo           /* 096 */
           , aliq_mva                       /* 097 */
           , pro_emprego                    /* 098 */
           , pro_empr_aliq_base             /* 099 */
           , pro_empr_aliq_antecip          /* 100 */
           , beneficio_pr                   /* 101 */
           , pr_aliq_base                   /* 102 */
           , pr_perc_diferido               /* 103 */
           , ins_estadual_id                /* 104 */
           , beneficio_pr_artigo            /* 105 */
           , pr_perc_vr_devido              /* 106 */
           , pr_perc_minimo_base            /* 107 */
           , pr_perc_minimo_suspenso        /* 108 */
           , aliq_ii_rec                    /* 109 */
           , beneficio_mercante_id          /* 110 */
           , vlr_frete                      /* 111 */
           , vlr_base_dev                   /* 112 */
           , vlr_base_a_recolher            /* 113 */
           , recof                          /* 114 */
           , beneficio_sp                   /* 115 */
           , enquadramento_legal_ipi_id     /* 116 */
           , aliq_cofins_recuperar          /* 117 */
           , vida_util                      /* 118 */
           , da_nr_registro                 /* 119 */
           , da_adicao_num                  /* 120 */
           , da_nr_linha                    /* 121 */
           , pesobrt_tot                    /* 122 */ --110918
           , beneficio_suspensao            /* 123 */
           , perc_beneficio_suspensao       /* 124 */
           , icms_motivo_desoneracao_id     /* 125 */
          )
          VALUES (
             decode (pc_flag_dsi, 'S', vn_adi_id, null)                 /* 000 */
           , vn_declaracao_lin_id                                       /* 001 */
           , vn_declaracao_id                                           /* 002 */
           , vn_linha_num                                               /* 003 */
           , dcl.invoice_id                                             /* 004 */
           , dcl.invoice_lin_id                                         /* 005 */
           , dcl.item_id                                                /* 006 */
           , vc_descricao_long                                          /* 007 */
           , dcl.un_medida_id                                           /* 008 */
           , vn_quantidade_gerar_linha_dcl                              /* 009 */
           , dcl.preco_unitario_m                                       /* 010 */
           , '1'                                                        /* 011 */
           , vn_ncm_id                                                  /* 012 */
           , vn_naladi_sh_id                                            /* 013 */
           , vn_naladi_ncca_id                                          /* 014 */
           , vn_ausencia_fabric_gravar                                  /* 015 */
           , decode (pc_flag_dsi, 'N', dcl.fabric_id, null)             /* 016 */
           , decode (pc_flag_dsi, 'N', dcl.fabric_site_id, null)        /* 017 */
           , dcl.fabric_part_number                                     /* 018 */
           , vn_pais_origem_id                                          /* 019 */
           , dcl.pesoliq_tot                                            /* 020 */
           , dcl.pesoliq_unit                                           /* 021 */
           , vn_id_regtrib_ii                                           /* 022 */
           , vn_id_regtrib_ipi                                          /* 023 */
           , vn_id_regtrib_icms                                         /* 024 */
           , dcl.utilizacao_id                                          /* 025 */
           , vn_ex_ncm_id                                               /* 026 */
           , vn_ex_nbm_id                                               /* 027 */
           , vn_ex_naladi_id                                            /* 028 */
           , vn_ex_ipi_id                                               /* 029 */
           , vn_ex_prac_id                                              /* 030 */
           , vn_ex_antd_id                                              /* 031 */
           , 'N'                                                        /* 032 */
           , vn_aliq_ii_red                                             /* 033 */
           , vn_perc_red_ii                                             /* 034 */
           , vn_aliq_ipi_red                                            /* 035 */
           , vn_aliq_icms_red                                           /* 036 */
           , vn_perc_red_icms                                           /* 037 */
           , vn_aliq_icms                                               /* 038 */
           , nvl (vn_cfop_id_padrao, dcl.cfop_id)                       /* 039 */
           , sysdate                                                    /* 040 */
           , pn_user_id                                                 /* 041 */
           , sysdate                                                    /* 042 */
           , pn_user_id                                                 /* 043 */
           , vn_excecao_icms_id                                         /* 044 */
           , vn_excecao_ipi_id                                          /* 045 */
           , vn_excecao_ii_id                                           /* 046 */
           , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')    /* 047 */
           , vn_aliq_pis                                                /* 048 */
           , vn_aliq_cofins                                             /* 049 */
           , vn_perc_red_pis_cofins                                     /* 050 */
           , vn_excecao_pis_cofins_id                                   /* 051 */
           , vn_id_regtrib_pis_cofins                                   /* 052 */
           , vn_fundamento_legal_id                                     /* 053 */
           , vn_ato_legal_id                                            /* 054 */
           , vn_orgao_emissor_id                                        /* 055 */
           , vn_nr_ato_legal                                            /* 056 */
           , vn_ano_ato_legal                                           /* 057 */
           , Nvl(vn_aliq_icms_fecp_fiscal,vn_aliq_icms_fecp_param)      /* 058 */
           , vn_fund_legal_icms_id                                      /* 059 */
           , vn_fund_legal_pis_cofins_id                                /* 060 */
           , decode (
                vc_tp_declaracao
              , '17'
              , null
              , decode (vc_emb_repetro
                        , 'REPETRO'
                        , null
                        , vn_dcl_lin_da_id
                       )
             )                                                          /* 061 */
           , decode (
                vc_tp_declaracao
              , '17'
              , null
              , decode (vc_emb_repetro
                        , 'REPETRO'
                        , null
                        , vn_dcl_lin_da_lin_id
                       )
             )                                                          /* 062 */
           , vc_flag_red_base_pis_cofins                                /* 063 */
           , vn_flegal_red_pis_cofins_id                                /* 064 */
           , vn_aliq_pis_reduzida                                       /* 065 */
           , vn_aliq_cofins_reduzida                                    /* 066 */
           , nvl (vc_regime_especial, 'N')                              /* 067 */
           , vn_aliq_pis_especifica                                     /* 068 */
           , vn_aliq_cofins_especifica                                  /* 069 */
           , vn_qtde_um_aliq_especifica_pc                              /* 070 */
           , vc_um_aliq_especifica_pc                                   /* 071 */
           , vr_cert_origem_mercosul.acordo_aladi_id                    /* 072 */ -- somente para nacionalizacao de recof
           , vr_cert_origem_mercosul.cert_origem_mercosul_id            /* 073 */ -- somente para nacionalizacao de recof
           , vn_da_invoice_lin_id                                       /* 074 */ -- somente para nacionalizacao de recof
           , vn_excecao_antid_id                                        /* 075 */
           , vn_aliq_antid_ad_valorem                                   /* 076 */
           , vn_aliq_especifica_antid                                   /* 077 */
           , vc_tipo_unidade_medida_antid                               /* 078 */
           , vc_somatoria_quantidade                                    /* 079 */
           , vn_um_aliq_especifica_antid_id                             /* 080 */
           , gn_ato_legal_ncm_id                                        /* 081 */
           , gn_orgao_emissor_ncm_id                                    /* 082 */
           , gn_nr_ato_legal_ncm                                        /* 083 */
           , gn_ano_ato_legal_ncm                                       /* 084 */
           , gn_ato_legal_nbm_id                                        /* 085 */
           , gn_orgao_emissor_nbm_id                                    /* 086 */
           , gn_nr_ato_legal_nbm                                        /* 087 */
           , gn_ano_ato_legal_nbm                                       /* 088 */
           , gn_ato_legal_naladi_id                                     /* 089 */
           , gn_orgao_emissor_naladi_id                                 /* 090 */
           , gn_nr_ato_legal_naladi                                     /* 091 */
           , gn_ano_ato_legal_naladi                                    /* 092 */
           , gn_ato_legal_acordo_id                                     /* 093 */
           , gn_orgao_emissor_acordo_id                                 /* 094 */
           , gn_nr_ato_legal_acordo                                     /* 095 */
           , gn_ano_ato_legal_acordo                                    /* 096 */
           , vn_aliquota_mva                                            /* 097 */  -- *** ICMS ST
           , vc_pro_emprego                                             /* 098 */
           , vn_aliq_base_pro_emprego                                   /* 099 */
           , vn_aliq_antecip_pro_emprego                                /* 100 */
           , vc_beneficio_pr                                            /* 101 */
           , vn_aliq_base_pr                                            /* 102 */
           , vn_perc_diferido_pr                                        /* 103 */
           , vn_ins_estadual_id                                         /* 104 */
           , vc_beneficio_pr_artigo                                     /* 105 */
           , vn_pr_perc_vr_devido                                       /* 106 */
           , vn_pr_perc_minimo_base                                     /* 107 */
           , vn_pr_perc_minimo_suspenso                                 /* 108 */
           , vn_aliq_ii_rec                                             /* 109 */
           , vn_benef_id                                                /* 110 */
           --, (vn_frete_afrmm/dcl.pesoliq_tot)                         /* 111 */
           , NULL                                                       /* 111 */
           , NULL                                                       /* 112 */
           , NULL                                                       /* 113 */
           , Nvl(vc_recof_dcl,'N')                                      /* 114 */
           , vc_beneficio_sp                                            /* 115 */
           , vn_enquad_legal_ipi_id                                     /* 116 */
           , Decode( Nvl(vn_aliq_cofins_recuperar_ncm,0)
                   , 0, vn_aliq_cofins, vn_aliq_cofins_recuperar_ncm)   /* 117 */
           , Decode(vc_admissao_temporaria, 'S', 1, null)               /* 118 */
           , dcl.da                                                     /* 119 */
           , dcl.adicao                                                 /* 120 */
           , dcl.nr_lin_item                                            /* 121 */
           , Decode(vc_tp_embarque_nac,'NAC_DE_TERC',dcl.peso_bruto_nac,NULL)/* 122 */ --110918
           , vc_beneficio_suspensao                                     /* 123 */
           , vn_perc_beneficio_suspensao                                /* 124 */
           , vn_icms_motivo_desoneracao_id                              /* 125 */
           );

          vc_descricao_long:= imp_fnc_busca_descricao_item (
                                                             pn_empresa_id
                                                           , dcl.item_id
                                                           , dcl.invoice_lin_id
                                                           , null
                                                           , vn_ex_ncm_id
                                                           , vn_ex_nbm_id
                                                           , vn_ex_naladi_id
                                                           , vn_ex_ipi_id
                                                           , vn_ex_prac_id
                                                           , vn_ex_antd_id
                                                           , 'DECLARACAO'
                                                           , dcl.po_linha_id
                                                           );
          -- Gravando a auditoria
         vc_descricao_long := imp_fnc_busca_descricao_item (
                pn_empresa_id
              , dcl.item_id
              , dcl.invoice_lin_id
              , null
              , vn_ex_ncm_id
              , vn_ex_nbm_id
              , vn_ex_naladi_id
              , vn_ex_ipi_id
              , vn_ex_prac_id
              , vn_ex_antd_id
              , 'DECLARACAO'
              , dcl.po_linha_id
/*
              pn_empresa_id
            , dcl.item_id
            , dcl.invoice_lin_id
            , null
            , null
            , null
            , null
            , null
            , null
            , null
            , 'DECLARACAO'
            , dcl.po_linha_id*/
            );

          imp_prc_dcllin_auditoria (
            vn_declaracao_id
          , vn_declaracao_lin_id
          , vc_descricao_long
          , vn_quantidade_gerar_linha_dcl
          , dcl.preco_unitario_m
          , pn_user_id
          , 'A'
          , 'N'
          );

          -- Embarques de RECOF devemos atualizar o STATUS nos consumos
          IF (vc_tp_declaracao = '16') THEN
            OPEN  cur_consumos_nacionalizados (
               dcl.decl_nr_registro
             , dcl.decl_adicao_num
             , dcl.decl_nr_linha
             , dcl.situacao_estoque
             , dcl.utilizacao_id
            );
            FETCH cur_consumos_nacionalizados BULK COLLECT INTO vt_consumos_nac;
            CLOSE cur_consumos_nacionalizados;

            IF (vt_consumos_nac.first IS NOT null) THEN
              /* O comando FORALL foi utilizado para aumentar a performance.
                 A performance do comando FORALL é melhor do que fazer um FOR LOOP. Com o
                 FORALL haverá apenas uma troca de contexto entre SQL e PL/SQL para executar
                 o comando UPDATE. Com o FOR LOOP haveria troca de contexto para cada registro
                 que fosse atualizado pelo comando UPDATE.
              */

              FORALL i IN vt_consumos_nac.first .. vt_consumos_nac.last
                UPDATE rcf_consumos
                   SET reservado     = 'S'
                     , nr_referencia = vn_declaracao_lin_id
                 WHERE consumo_id    = vt_consumos_nac(i);

              vt_consumos_nac.delete;
            END IF;
          END IF;  -- vc_tp_declaracao = '16'
        END IF;

      END IF;
    END LOOP;  -- cur_declaracao_lin


    /* Fase 2: linhas de invoices, que tem licenca registrada.
       So entraremos neste fase se o usuario estiver criando uma NOVA Declaracao (opcao NOVO do
       browser de declaracoes), pois, se o usuario estiver apenas incluindo uma nova invoice ou
       incluindo uma linha de uma invoice numa declaracao ja existente, nao precisaremos incluir
       suas LIs, pois este controle fica para a trigger "imp_trg_cria_decl_lin_li" que cria as
       linhas de declaracao para as LIs quando o numero de registro de licenca for atualizado.
       Por exemplo,  o usuario incluiu uma invoice ou uma linha de invoice e criou uma LI
       para ela. Se o usuario utilizar a funcao "Adicao de Invoice" na declaracao, so
       teremos que incluir as linhas da invoice que tem saldo, pois, quanto às linhas de
       LI criadas elas serao inseridas na declaracao apenas quando o usuario incluir o
       numero de registro de LI. Por isso NAO precisamos, aqui na funcao de "Adicao de Invoice"
       da declaracao tratarmos as LIs.
    */

    IF (pn_invoice_id IS null) THEN
       FOR cdll IN cur_declaracao_lin_com_li (ci.invoice_id) LOOP
         vn_aliq_ipi_dev               := null;
         vn_aliq_ipi_red               := null;
         vn_aliq_icms                  := null;
         vn_aliq_icms_red              := null;
         vn_perc_red_icms              := null;
         vc_regime_especial            := null;
         vn_fund_legal_icms_id         := null;
         vn_aliq_pis                   := null;
         vn_aliq_cofins                := null;
         vn_perc_red_pis_cofins        := null;
         vn_fund_legal_pis_cofins_id   := null;
         vn_ato_legal_id               := null;
         vn_orgao_emissor_id           := null;
         vn_nr_ato_legal               := null;
         vn_ano_ato_legal              := null;
         vn_excecao_icms_id            := null;
         vn_excecao_ipi_id             := null;
         vn_excecao_ii_id              := null;
         vn_excecao_antid_id           := null;
         vn_ex_antd_id                 := null;
         vn_aliq_antid_ad_valorem      := null;
         vn_aliq_especifica_antid      := null;
         vc_tipo_unidade_medida_antid  := null;
         vc_somatoria_quantidade       := null;
         vc_destino_ex_ato_legal_ii    := null;
         vn_ato_legal_ii_id            := null;
         vn_nr_ato_legal_ii            := null;
         vn_orgao_emissor_ii_id        := null;
         vn_ano_ato_legal_ii           := null;
         vn_aliquota_mva               := null;

         IF (cdll.item_id IS NOT null) THEN
           vn_naladi_ncca_id := imp_fnc_busca_naladi_id (cdll.item_id, pn_invoice_id, 'NCCA');
         END IF;

         vc_step_error := 'fnc_deduz_ausencia - 2';
         vn_pais_origem_id := fnc_deduz_ausencia (
                                  cdll.pais_origem_id
                                , cdll.ausencia_fabric
                                , vn_pais_export_id_invoice
                                , cdll.fabric_id
                                , cdll.fabric_site_id
                                , vn_ausencia_fabric_gravar
                               );
         vc_step_error := null;

         OPEN  cur_max_lin_num_di;
         FETCH cur_max_lin_num_di into vn_linha_num;
         CLOSE cur_max_lin_num_di;
         vn_linha_num  := vn_linha_num + 1;

         /* Devemos gerar a Adicao nos casos de DSI */
         vn_adi_id := Null;
         IF (pc_flag_dsi = 'S') THEN

           vn_ins_estadual_id := NULL;

           OPEN cur_dados_ie (vn_id_regtrib_icms);
           FETCH cur_dados_ie INTO vn_ins_estadual_id;
           CLOSE cur_dados_ie;

          IF (cmx_fnc_profile('UTILIZA_AFRMM') = 'S') THEN
            IF (cmx_pkg_tabelas.codigo(vn_via_transporte_id) = '01' AND cmx_pkg_tabelas.codigo(pn_tp_declaracao_id) NOT IN ('04', '16')) THEN

              OPEN  cur_termo_pgto(cdll.termo_id);
              FETCH cur_termo_pgto INTO vn_motivo_sem_cobertura_id;
              CLOSE cur_termo_pgto;

              vn_benef_id := NULL;

              IF (vr_cert_origem_mercosul.cert_origem_mercosul_id IS NOT NULL) THEN
                imp_prc_benef_imp_linha_afrmm(vr_cert_origem_mercosul.cert_origem_mercosul_id, pn_empresa_id, pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, cdll.class_fiscal_id, cdll.item_id, cdll.utilizacao_id, pc_flag_dsi, vn_benef_id);
              END IF;
              IF (Nvl(vn_benef_id,0) = 0) THEN
                imp_prc_benef_lin_linha_afrmm(pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, cdll.class_fiscal_id, cdll.item_id, cdll.utilizacao_id, pn_empresa_id, pc_flag_dsi, vn_benef_id);
              END IF;

              IF (Nvl(vn_benef_id,0) = 0) THEN
                vn_benef_id := NULL;
              END IF;

            ELSE
              vn_benef_id := NULL;
            END IF;
          END IF;

           vc_step_error := 'imp_fnc_gera_adicao_dcl - 2';
           vn_adi_id := imp_fnc_gera_adicao_dcl (
                            pn_declaracao_id
                          , pn_tp_declaracao_id
                          , null                        /* pn_declaracao_adi_id */
                          , cdll.tp_classificacao
                          , cdll.class_fiscal_id
                          , cdll.invoice_lin_id
                          , cdll.regtrib_ii_id
                          , vn_id_regtrib_ipi
                          , null                        /* pn_aliq_ipi_red */
                          , cdll.perc_red_ii            /* pn_perc_red_ii */
                          , cdll.aliq_ii_red            /* pn_aliq_ii_red */
                          , cdll.rd_id
                          , cdll.licenca_id
                          , vn_ausencia_fabric_gravar
                          , null                        /* pn_fabric_id */
                          , null                        /* pn_fabric_site_id */
                          , vn_pais_origem_id
                          , cdll.item_id
                          , cdll.naladi_sh_id
                          , vn_naladi_ncca_id
                          , cdll.ex_ncm_id
                          , cdll.ex_nbm_id
                          , cdll.ex_naladi_id
                          , cdll.ex_ipi_id
                          , cdll.ex_prac_id
                          , cdll.ex_antd_id
                          , cdll.da_lin_id
                          , null                        /* pn_vida_util */
                          , 'S'                         /* dsi */
                          , sysdate
                          , pn_user_id
                          , sysdate
                          , pn_user_id
                          , cdll.fundamento_legal_id             /* pn_fundamento_legal_id         */
                          , null                                 /* pn_ato_legal_id                */
                          , null                                 /* pn_orgao_emissor_id            */
                          , null                                 /* pn_nr_ato_legal                */
                          , null                                 /* pn_ano_ato_legal               */
                          , cdll.regtrib_icms_id                 /* pn_regtrib_icms_id             */
                          , cdll.aliq_icms                       /* pn_aliq_icms                   */
                          , cdll.aliq_icms_red                   /* pn_aliq_icms_red               */
                          , cdll.perc_red_icms                   /* pn_perc_red_icms               */
                          , cdll.aliq_icms_fecp                  /* pn_aliq_icms_fecp              */
                          , cdll.fundamento_legal_icms_id        /* pn_fund_legal_icms_id          */
                          , cdll.regtrib_pis_cofins_id           /* pn_regtrib_pis_cofins_id       */
                          , cdll.aliq_pis                        /* pn_aliq_pis                    */
                          , cdll.aliq_cofins                     /* pn_aliq_cofins                 */
                          , cdll.perc_reducao_base_pis_cofins    /* pn_perc_red_base_pis_cofins    */
                          , cdll.fundamento_legal_pis_cofins_id  /* pn_fund_legal_pis_cofins_id    */
                          , cdll.flag_reducao_base_pis_cofins    /* pn_flag_red_base_pis_cofins    */
                          , cdll.flegal_reducao_pis_cofins_id    /* pn_flegal_red_pis_cofins_id    */
                          , cdll.aliq_pis_reduzida               /* pn_aliq_pis_reduzida           */
                          , cdll.aliq_cofins_reduzida            /* pn_aliq_cofins_reduzida        */
                          , cdll.regime_especial_icms            /* pc_regime_especial_icms        */
                          , cdll.aliq_pis_especifica             /* pn_aliq_pis_especifica         */
                          , cdll.aliq_cofins_especifica          /* pn_aliq_cofins_especifica      */
                          , cdll.qtde_um_aliq_especifica_pc      /* pn_qtde_um_aliq_especifica_pc  */
                          , cdll.un_medida_aliq_especifica_pc    /* pc_um_aliq_especifica_pc       */
                          , null                                 /* pn_acordo_aladi_id             */
                          , null                                 /* pn_cert_origem_mercosul_id     */
                          , null                                 /* pn_aliq_antid_ad_valorem       */
                          , null                                 /* pn_aliq_antid_especifica       */
                          , null                                 /* pn_um_aliq_especifica_antid_id */
                          , null                                 /* pc_somatoria_antidumping       */
                          , null                                 /* pn_ato_legal_ii_id             */
                          , null                                 /* pn_orgao_emissor_ii_id         */
                          , null                                 /* pn_nr_ato_legal_ii             */
                          , null                                 /* pn_ano_ato_legal_ii            */
                          , null                                 /* pn_ato_legal_ii_id             */
                          , null                                 /* pn_orgao_emissor_ii_id         */
                          , null                                 /* pn_nr_ato_legal_ii             */
                          , null                                 /* pn_ano_ato_legal_ii            */
                          , null                                 /* pn_ato_legal_ii_id             */
                          , null                                 /* pn_orgao_emissor_ii_id         */
                          , null                                 /* pn_nr_ato_legal_ii             */
                          , null                                 /* pn_ano_ato_legal_ii            */
                          , null                                 /* pn_ato_legal_ii_id             */
                          , null                                 /* pn_orgao_emissor_ii_id         */
                          , null                                 /* pn_nr_ato_legal_ii             */
                          , null                                 /* pn_ano_ato_legal_ii            */
                          , cdll.aliq_mva                        /* pn_aliquota_mva                */
                          , cdll.pro_emprego                     /* pc_pro_emprego                 */
                          , cdll.pro_empr_aliq_base              /* pn_aliq_base_pro_emprego       */
                          , cdll.pro_empr_aliq_antecip           /* pn_aliq_antecip_pro_emprego    */
                          , cdll.beneficio_pr
                          , cdll.pr_aliq_base
                          , cdll.pr_perc_diferido
                          , vn_ins_estadual_id                   /* pn_ins_estadual_id             */
                          , cdll.pr_perc_vr_devido               /* pn_pr_perc_vr_devido           */
                          , cdll.pr_perc_minimo_base             /* pn_pr_perc_minimo_base         */
                          , cdll.pr_perc_minimo_suspenso         /* pn_pr_perc_minimo_suspenso     */
                          , vc_beneficio_sp                      /* pc_beneficio_sp                */
                          , vn_benef_id                          /* pn_benef_id                    */
                          , NULL                                 /* pn_vlr_frete_afrmm             */
                          , vc_beneficio_suspensao               /* pc_beneficio_suspensao         */
                          , vn_perc_beneficio_suspensao          /* pn_perc_beneficio_suspensao    */
                         );
           vc_step_error := null;
         END IF; /* (pc_flag_dsi = 'S') */

         IF (vt_cdh.via_transporte_id = cmx_pkg_tabelas.tabela_id ('912', '5')) THEN
           vn_id_regtrib_pis_cofins := cmx_pkg_tabelas.tabela_id ('141', '1');
         END IF;

         -- Retirada a validação para Nacionalização de Admissão temporaria (13), porque
         -- a maioria das vezes temos admissões sem codigo de produto e não se
         -- consegue fazer o controle de saldos sem codigo de produto.
         IF (pc_flag_dsi = 'N') AND (vc_tp_declaracao = '15' OR (vc_tp_declaracao = '14' AND Nvl(pc_nac_sem_vinc_admissao,'N') = 'N')) THEN

           vn_da_id_tp_decl_14_15 := Nvl(cdll.da_id, pn_da_id);

           /*Tratamento aliquota_cofins_recuperar*/
           vn_aliquota_cofins_custo := imp_fnc_ncm_cofins_majorado(cdll.class_fiscal_id, vd_data_busca_excecao);

           prc_preenche_globais_ato_legal;
           imp_pkg_nacionalizacao.gerar (
              vn_declaracao_id
            , vc_tp_declaracao
            , pn_empresa_id
            , pn_embarque_id
            , cdll.invoice_id
            , cdll.invoice_lin_id
            , cdll.item_id
            , cdll.descricao
            , cdll.un_medida_id
            , cdll.qtde
            , cdll.preco_unitario_m
            , cdll.class_fiscal_id
            , cdll.utilizacao_id
            , nvl (cdll.cfop_nf_importacao_id, nvl (vn_cfop_id_padrao, cdll.cfop_id) )
            , cdll.pesoliq_tot
            , cdll.pesoliq_unit
            , cdll.regtrib_ii_id
            , cdll.regtrib_ipi_id  -- vn_id_regtrib_ipi
            , cdll.regtrib_icms_id -- vn_id_regtrib_icms
            , cdll.ex_ncm_id
            , cdll.ex_nbm_id
            , cdll.ex_naladi_id
            , cdll.ex_prac_id
            , cdll.ex_antd_id
            , cdll.ex_ipi_id
            , cdll.aliq_ii_red           /* vn_aliq_ii_red */
            , cdll.perc_red_ii           /* vn_perc_red_ii */
            , cdll.aliq_ipi_red
            , cdll.aliq_icms_red                -- vn_aliq_icms_red
            , cdll.perc_red_icms                -- vn_perc_red_icms
            , cdll.aliq_icms                    -- vn_aliq_icms
            , pn_user_id
            , cdll.excecao_icms_id              -- vn_excecao_icms_id
            , cdll.excecao_ipi_id               -- vn_excecao_ipi_id
            , cdll.excecao_ii_id
            , cdll.aliq_pis                     -- vn_aliq_pis
            , cdll.aliq_cofins                  -- vn_aliq_cofins
            , cdll.perc_reducao_base_pis_cofins -- vn_perc_red_pis_cofins
            , cdll.excecao_pis_cofins_id        -- vn_excecao_pis_cofins_id
            , cdll.regtrib_pis_cofins_id        -- vn_id_regtrib_pis_cofins
            , cdll.fundamento_legal_id          -- vn_fundamento_legal_id TND
            , cdll.ato_legal_id
            , cdll.orgao_emissor_id
            , cdll.nr_ato_legal
            , cdll.ano_ato_legal
            , vn_da_id_tp_decl_14_15
            , cdll.da_lin_id
            , cdll.licenca_id
            , cdll.licenca_lin_id
            , vn_ausencia_fabric_gravar
            , cdll.fabric_id
            , cdll.fabric_site_id
            , cdll.fabric_part_number
            , vn_pais_origem_id
            , cdll.naladi_sh_id
            , vn_naladi_ncca_id
            , cdll.rd_id
            , ci.moeda_id  /* Para gerar a LI de Drawback precisamos da moeda id */
            , vn_linha_num
            , vn_evento_id
            , vb_erro_nacionalizacao
            , pc_gera_li_drawback
            , pc_quebra_qtde_drawback
            , pb_li_gerada
            , cdll.aliq_icms_fecp                 -- vn_aliq_icms_fecp_param
            , cdll.fundamento_legal_icms_id       -- vn_fund_legal_icms_id
            , cdll.fundamento_legal_pis_cofins_id -- vn_fund_legal_pis_cofins_id
            , cdll.flegal_reducao_pis_cofins_id
            , cdll.aliq_pis_reduzida
            , cdll.aliq_cofins_reduzida
            , cdll.flag_reducao_base_pis_cofins
            , cdll.regime_especial_icms           -- pc_regime_especial_icms
            , cdll.aliq_pis_especifica            -- pn_aliq_pis_especifica
            , cdll.aliq_cofins_especifica         -- pn_aliq_cofins_especifica
            , cdll.qtde_um_aliq_especifica_pc     -- pn_qtde_um_aliq_especifica_pc
            , cdll.un_medida_aliq_especifica_pc   -- pc_um_aliq_especifica_pc
            , cdll.excecao_antid_id               -- pn_excecao_antid_id
            , cdll.aliq_antid                     -- pn_aliq_antid
            , null                                -- pn_basecalc_antid
            , cdll.aliq_antid_especifica          -- pn_aliq_antid_especifica
            , null                                -- pn_qtde_um_aliq_especif_antid
            , cdll.um_aliq_especifica_antid_id    -- pn_um_aliq_especifica_antid_id
            , cdll.tipo_unidade_medida_antid      -- pc_tipo_unidade_medida_antid
            , cdll.somatoria_quantidade           -- pc_somatoria_quantidade
            , cdll.ato_legal_ncm_id
            , cdll.orgao_emissor_ncm_id
            , cdll.nr_ato_legal_ncm
            , cdll.ano_ato_legal_ncm
            , cdll.ato_legal_nbm_id
            , cdll.orgao_emissor_nbm_id
            , cdll.nr_ato_legal_nbm
            , cdll.ano_ato_legal_nbm
            , cdll.ato_legal_naladi_id
            , cdll.orgao_emissor_naladi_id
            , cdll.nr_ato_legal_naladi
            , cdll.ano_ato_legal_naladi
            , cdll.ato_legal_acordo_id
            , cdll.orgao_emissor_acordo_id
            , cdll.nr_ato_legal_acordo
            , cdll.ano_ato_legal_acordo
            , cdll.aliq_mva
            , nvl(cdll.aliq_cofins_reduzida, cdll.aliq_cofins) - Nvl(vn_aliquota_cofins_custo,0)
           );
         ELSIF (pc_flag_dsi = 'S') OR ((pc_flag_dsi = 'N') AND (vc_tp_declaracao NOT IN ('14', '15') OR (vc_tp_declaracao = '14' AND Nvl(pc_nac_sem_vinc_admissao,'N') = 'S'))) THEN
           vc_step_error := 'Insert into imp_declaracoes_lin fase 2';
           vn_declaracao_lin_id:= cmx_fnc_proxima_sequencia('imp_declaracoes_lin_sq1');

           vn_ins_estadual_id := NULL;

           OPEN cur_dados_ie (vn_id_regtrib_icms);
           FETCH cur_dados_ie INTO vn_ins_estadual_id;
           CLOSE cur_dados_ie;

          IF (Nvl (vc_nac, '*') = 'NAC') THEN
            OPEN  cur_busca_dados_da_adm_temp (cdll.invoice_lin_id, cdll.qtde);
            FETCH cur_busca_dados_da_adm_temp INTO reg_da_adm_temp;
            CLOSE cur_busca_dados_da_adm_temp;

            IF(reg_da_adm_temp.declaracao_lin_id IS NULL) THEN
              OPEN  cur_busca_dados_da_adm_temp (cdll.invoice_lin_id, NULL);
              FETCH cur_busca_dados_da_adm_temp INTO reg_da_adm_temp;
              CLOSE cur_busca_dados_da_adm_temp;
            END IF;

            vn_dcl_lin_da_id     := reg_da_adm_temp.declaracao_id;
            vn_dcl_lin_da_lin_id := reg_da_adm_temp.declaracao_lin_id;
          ELSE
            vn_dcl_lin_da_id     := cdll.da_id;
            vn_dcl_lin_da_lin_id := cdll.da_lin_id;
          END IF;

          -- Zerando
          vc_recof_dcl := 'N';
          OPEN cur_ex_fiscais_recof(cdll.excecao_ii_id);
          FETCH cur_ex_fiscais_recof INTO vc_recof_dcl;
          CLOSE cur_ex_fiscais_recof;

          /* Aqui é verificado o benefício. Se existir ato concessório para o item(tanto
             suspenso quanto isento), verifica na tela de benefício afrmm o primeiro
             benefício que encontrar cujo radio button seja Drawback Suspenso/Drawback
             Isento conforme o Ato Concessório.
             Se não encontrar nenhum ou se não existir ato concessório, é verificado se
             existe certificado mercosul/aladi para o item. Se existir, verifica na tela
             de benefício afrmm o primeiro benefício que encontrar cujo radio button esteja
             setado como Mercosul/Aladi.
             Se não encontrar nenhum benefício ou também não existir certificado mercosul/aladi,
             então, busca o benefício conforme a regra:
             Tipo/Natureza
             Motivo sem cobertura cambial
             NCM
             Utilização
             Segundo a Izabela, não existirá retorno de mais de um benefício, ou seja, utilizando
             essa regra acima, só existirá apenas 1 benefício.
             Também é validado se o conhecimento de transporte é MARÍTIMO.
             */

           IF (cmx_fnc_profile('UTILIZA_AFRMM') = 'S') THEN
             IF (cmx_pkg_tabelas.codigo(vn_via_transporte_id) = '01' AND cmx_pkg_tabelas.codigo(pn_tp_declaracao_id) NOT IN ('04', '16')) THEN

               OPEN  cur_termo_pgto(cdll.termo_id);
               FETCH cur_termo_pgto INTO vn_motivo_sem_cobertura_id;
               CLOSE cur_termo_pgto;

               vn_benef_id := NULL;

               IF (cdll.rd_id IS NOT NULL) THEN
                 imp_prc_benef_drw_linha_afrmm(cdll.rd_id, pn_empresa_id, vn_benef_id);
               END IF;
               IF (Nvl(vn_benef_id,0) = 0) THEN
                 IF (cdll.cert_origem_mercosul_id IS NOT NULL) THEN
                   imp_prc_benef_imp_linha_afrmm(cdll.cert_origem_mercosul_id, pn_empresa_id, pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, cdll.class_fiscal_id, cdll.item_id, cdll.utilizacao_id, pc_flag_dsi, vn_benef_id);
                 END IF;
               END IF;
               IF (Nvl(vn_benef_id,0) = 0) THEN
                 imp_prc_benef_lin_linha_afrmm(pn_tp_declaracao_id, vn_motivo_sem_cobertura_id, cdll.class_fiscal_id, cdll.item_id, cdll.utilizacao_id, pn_empresa_id, pc_flag_dsi, vn_benef_id);
               END IF;

               IF (Nvl(vn_benef_id,0) = 0) THEN
                 vn_benef_id := NULL;
               END IF;
             ELSE
               vn_benef_id := NULL;
             END IF;
           END IF;

           vc_step_error := 'Validar NCM inativa 2';
           vn_ncm_id := cdll.class_fiscal_id;

           cmx_prc_validar_ncm ( pn_declaracao_id => pn_declaracao_id
                               , pc_flag_dsi      => pc_flag_dsi
                               , pn_item_id       => cdll.item_id
                               , pc_substitui_ncm => 'S'
                               , pn_ncm_id        => vn_ncm_id
                               , pc_log_tipo      => vc_log_tipo
                               , pc_log_desc      => vc_log_desc
                               , pc_log_solu      => vc_log_solu );

           IF(vc_log_desc IS NOT NULL)THEN

             IF(NOT(vb_ncm_evento))THEN

               IF (pn_evento_id IS NULL) THEN
                 pn_evento_id := cmx_fnc_gera_evento( 'Validação de utilização de NCMs inativas'
                                                    , SYSDATE
                                                    , pn_user_id
                                                    );
                 vb_ncm_evento := TRUE;
               END IF;

             END IF;

             cmx_prc_gera_log_erros ( pn_evento_id
                                    , vc_log_desc
                                    , vc_log_tipo
                                    , vc_log_solu
                                    );

             IF(vc_log_tipo = 'E')THEN
               vb_ncm_erro := TRUE;
             END IF;

           END IF;

           /*Tratamento aliquota_cofins_recuperar*/
           vn_aliquota_cofins_custo := imp_fnc_ncm_cofins_majorado(vn_ncm_id, vd_data_busca_excecao);

           OPEN  cur_item_com_rcr(cdll.invoice_lin_id);
           FETCH cur_item_com_rcr INTO vn_dummy;
           vb_linha_ivc_tem_rcr := cur_item_com_rcr%FOUND;
           CLOSE cur_item_com_rcr;

           IF (vb_linha_ivc_tem_rcr) THEN
             vc_admissao_temporaria := 'S';
           ELSE
             vc_admissao_temporaria := 'N';
           END IF;

           IF(vc_tratar_icms_deso_emiss_nfe = 'S')THEN
             vn_icms_motivo_desoneracao_id := NULL;
             OPEN cur_excecao_motivo_desoneracao(cdll.excecao_icms_id);
             FETCH cur_excecao_motivo_desoneracao INTO vn_icms_motivo_desoneracao_id;
             CLOSE cur_excecao_motivo_desoneracao;
           END IF;

           /* TH - Adicionado mesma trativa da função imp_fnc_gera_adicao_dcl. */
           IF (cdll.aliq_pis IS null) THEN
             vn_aliq_pis := vn_aliq_pis_ncm;
           ELSE
             vn_aliq_pis := cdll.aliq_pis;
           END IF;

           IF (cdll.aliq_cofins IS null) THEN
             vn_aliq_cofins := vn_aliq_cofins_ncm;
           ELSE
             vn_aliq_cofins := cdll.aliq_cofins;
           END IF;
           --

           vc_step_error := 'Insert INTO imp_declaracoes_lin 2';
           INSERT INTO imp_declaracoes_lin (
              declaracao_adi_id                   /* 000 */
            , declaracao_lin_id                   /* 001 */
            , declaracao_id                       /* 002 */
            , linha_num                           /* 003 */
            , invoice_id                          /* 004 */
            , invoice_lin_id                      /* 005 */
            , licenca_id                          /* 006 */
            , item_id                             /* 007 */
            , descricao                           /* 008 */
            , un_medida_id                        /* 009 */
            , qtde                                /* 010 */
            , preco_unitario_m                    /* 011 */
            , tp_classificacao                    /* 012 */
            , class_fiscal_id                     /* 013 */
            , naladi_sh_id                        /* 014 */
            , naladi_ncca_id                      /* 015 */
            , ausencia_fabric                     /* 016 */
            , fabric_id                           /* 017 */
            , fabric_site_id                      /* 018 */
            , fabric_part_number                  /* 019 */
            , pais_origem_id                      /* 020 */
            , pesoliq_tot                         /* 021 */
            , pesoliq_unit                        /* 022 */
            , regtrib_ii_id                       /* 023 */
            , regtrib_ipi_id                      /* 024 */
            , regtrib_icms_id                     /* 025 */
            , utilizacao_id                       /* 026 */
            , ex_ncm_id                           /* 027 */
            , ex_nbm_id                           /* 028 */
            , ex_naladi_id                        /* 029 */
            , ex_ipi_id                           /* 030 */
            , ex_prac_id                          /* 031 */
            , ex_antd_id                          /* 032 */
            , creation_date                       /* 033 */
            , created_by                          /* 034 */
            , last_update_date                    /* 035 */
            , last_updated_by                     /* 036 */
            , nfe_a_imprimir                      /* 037 */
            , licenca_lin_id                      /* 038 */
            , da_id                               /* 039 */
            , da_lin_id                           /* 040 */
            , aliq_icms                           /* 041 */
            , aliq_icms_red                       /* 042 */
            , perc_red_icms                       /* 043 */
            , cfop_id                             /* 044 */
            , rd_id                               /* 045 */
            , excecao_icms_id                     /* 046 */
            , excecao_ipi_id                      /* 047 */
            , excecao_ii_id                       /* 048 */
            , grupo_acesso_id                     /* 049 */
            , aliq_pis                            /* 050 */
            , aliq_cofins                         /* 051 */
            , perc_reducao_base_pis_cofins        /* 052 */
            , excecao_pis_cofins_id               /* 053 */
            , regtrib_pis_cofins_id               /* 054 */
            , fundamento_legal_id                 /* 055 */
            , ato_legal_id                        /* 056 */
            , orgao_emissor_id                    /* 057 */
            , nr_ato_legal                        /* 058 */
            , ano_ato_legal                       /* 059 */
            , aliq_ii_red                         /* 060 */
            , perc_red_ii                         /* 061 */
            , aliq_icms_fecp                      /* 062 */
            , fundamento_legal_icms_id            /* 063 */
            , fundamento_legal_pis_cofins_id      /* 064 */
            , flag_reducao_base_pis_cofins        /* 065 */
            , flegal_reducao_pis_cofins_id        /* 066 */
            , aliq_pis_reduzida                   /* 067 */
            , aliq_cofins_reduzida                /* 068 */
            , regime_especial_icms                /* 069 */
            , aliq_pis_especifica                 /* 070 */
            , aliq_cofins_especifica              /* 071 */
            , un_medida_aliq_especifica_pc        /* 072 */
            , qtde_um_aliq_especifica_pc          /* 073 */
            , excecao_antid_id                    /* 074 */
            , aliq_antid                          /* 075 */
            , aliq_antid_especifica               /* 076 */
            , tipo_unidade_medida_antid           /* 077 */
            , somatoria_quantidade                /* 078 */
            , um_aliq_especifica_antid_id         /* 079 */
            , acordo_aladi_id                     /* 080 */
            , cert_origem_mercosul_id             /* 081 */
            , ato_legal_ncm_id                    /* 082 */
            , orgao_emissor_ncm_id                /* 083 */
            , nr_ato_legal_ncm                    /* 084 */
            , ano_ato_legal_ncm                   /* 085 */
            , ato_legal_nbm_id                    /* 086 */
            , orgao_emissor_nbm_id                /* 087 */
            , nr_ato_legal_nbm                    /* 088 */
            , ano_ato_legal_nbm                   /* 089 */
            , ato_legal_naladi_id                 /* 090 */
            , orgao_emissor_naladi_id             /* 091 */
            , nr_ato_legal_naladi                 /* 092 */
            , ano_ato_legal_naladi                /* 093 */
            , ato_legal_acordo_id                 /* 094 */
            , orgao_emissor_acordo_id             /* 095 */
            , nr_ato_legal_acordo                 /* 096 */
            , ano_ato_legal_acordo                /* 097 */
            , aliq_mva                            /* 098 */
            , pro_emprego                         /* 099 */
            , pro_empr_aliq_base                  /* 100 */
            , pro_empr_aliq_antecip               /* 101 */
            , beneficio_pr                        /* 102 */
            , pr_aliq_base                        /* 103 */
            , pr_perc_diferido                    /* 104 */
            , ins_estadual_id                     /* 105 */
            , beneficio_pr_artigo                 /* 106 */
            , pr_perc_vr_devido                   /* 107 */
            , pr_perc_minimo_base                 /* 108 */
            , pr_perc_minimo_suspenso             /* 109 */
            , beneficio_mercante_id               /* 110 */
            , vlr_frete                           /* 111 */
            , vlr_base_dev                        /* 112 */
            , vlr_base_a_recolher                 /* 113 */
            , recof                               /* 114 */
            , beneficio_sp                        /* 115 */
            , enquadramento_legal_ipi_id          /* 116 */
            , aliq_cofins_recuperar               /* 117 */
            , aliq_ipi_red                        /* 119 */
            , vida_util                           /* 120 */
            , da_nr_registro                      /* 121 */
            , da_adicao_num                       /* 122 */
            , da_nr_linha                         /* 123 */
            , pesobrt_tot                         /* 124 */ --110918
            , beneficio_suspensao                 /* 125 */
            , perc_beneficio_suspensao            /* 126 */
            , icms_motivo_desoneracao_id          /* 127 */
           )
         VALUES (
              decode (pc_flag_dsi, 'S', vn_adi_id, null)                               /* 000 */
            , vn_declaracao_lin_id                                                     /* 001 */
            , vn_declaracao_id                                                         /* 002 */
            , vn_linha_num                                                             /* 003 */
            , cdll.invoice_id                                                          /* 004 */
            , cdll.invoice_lin_id                                                      /* 005 */
            , cdll.licenca_id                                                          /* 006 */
            , cdll.item_id                                                             /* 007 */
            , cdll.descricao                                                           /* 008 */
            , cdll.un_medida_id                                                        /* 009 */
            , cdll.qtde                                                                /* 010 */
            , cdll.preco_unitario_m                                                    /* 011 */
            , cdll.tp_classificacao                                                    /* 012 */
            , vn_ncm_id                                                                /* 013 */
            , cdll.naladi_sh_id                                                        /* 014 */
            , vn_naladi_ncca_id                                                        /* 015 */
            , vn_ausencia_fabric_gravar                                                /* 016 */
            , decode (pc_flag_dsi, 'N', cdll.fabric_id, null)                          /* 017 */
            , decode (pc_flag_dsi, 'N', cdll.fabric_site_id, null)                     /* 018 */
            , cdll.fabric_part_number                                                  /* 019 */
            , vn_pais_origem_id                                                        /* 020 */
            , cdll.pesoliq_tot                                                         /* 021 */
            , cdll.pesoliq_unit                                                        /* 022 */
            , cdll.regtrib_ii_id                                                       /* 023 */
            , cdll.regtrib_ipi_id                                                      /* 024 */ -- vn_id_regtrib_ipi
            , cdll.regtrib_icms_id                                                     /* 025 */ -- vn_id_regtrib_icms
            , cdll.utilizacao_id                                                       /* 026 */
            , cdll.ex_ncm_id                                                           /* 027 */
            , cdll.ex_nbm_id                                                           /* 028 */
            , cdll.ex_naladi_id                                                        /* 029 */
            , cdll.ex_ipi_id                                                           /* 030 */
            , cdll.ex_prac_id                                                          /* 031 */
            , cdll.ex_antd_id                                                          /* 032 */
            , sysdate                                                                  /* 033 */
            , pn_user_id                                                               /* 034 */
            , sysdate                                                                  /* 035 */
            , pn_user_id                                                               /* 036 */
            , 'N'                                                                      /* 037 */
            , cdll.licenca_lin_id                                                      /* 038 */
            , decode (
                 vc_tp_declaracao
               , '17'
               , NULL
               , decode (vc_emb_repetro
                         , 'REPETRO'
                         , null
                         , Nvl (cdll.da_id, vn_dcl_lin_da_id)
                        )
              )                                                                         /* 039 */
            , decode (
                 vc_tp_declaracao
               , '17'
               , null
               , decode (vc_emb_repetro
                         , 'REPETRO'
                         , null
                         , Nvl (cdll.da_lin_id, vn_dcl_lin_da_lin_id)
                        )
              )                                                                        /* 040 */
            , cdll.aliq_icms                                                           /* 041 */ -- vn_aliq_icms
            , cdll.aliq_icms_red                                                       /* 042 */ -- vn_aliq_icms_red
            , cdll.perc_red_icms                                                       /* 043 */ -- vn_perc_red_icms
            , nvl (cdll.cfop_nf_importacao_id, nvl (vn_cfop_id_padrao, cdll.cfop_id) ) /* 044 */
            , cdll.rd_id                                                               /* 045 */
            , cdll.excecao_icms_id                                                     /* 046 */ -- vn_excecao_icms_id
            , cdll.excecao_ipi_id                                                      /* 047 */ -- vn_excecao_ipi_id
            , cdll.excecao_ii_id                                                       /* 048 */
            , sys_context ('cmx_ctx_grupo_acesso', 'grupo_acesso_id')                  /* 049 */
            , vn_aliq_pis                                                              /* 050 */ -- vn_aliq_pis
            , vn_aliq_cofins                                                           /* 051 */ -- vn_aliq_cofins
            , cdll.perc_reducao_base_pis_cofins                                        /* 052 */ -- vn_perc_red_pis_cofins
            , cdll.excecao_pis_cofins_id                                               /* 053 */ -- vn_excecao_pis_cofins_id
            , cdll.regtrib_pis_cofins_id                                               /* 054 */ -- vn_id_regtrib_pis_cofins
            , cdll.fundamento_legal_id                                                 /* 055 */ -- vn_fundamento_legal_id
            , cdll.ato_legal_id                                                        /* 056 */
            , cdll.orgao_emissor_id                                                    /* 057 */
            , cdll.nr_ato_legal                                                        /* 058 */
            , cdll.ano_ato_legal                                                       /* 059 */
            , cdll.aliq_ii_red                                                         /* 060 */
            , cdll.perc_red_ii                                                         /* 061 */
            , cdll.aliq_icms_fecp                                                      /* 062 */ -- vn_aliq_icms_fecp_param
            , cdll.fundamento_legal_icms_id                                            /* 063 */ -- vn_fund_legal_icms_id
            , cdll.fundamento_legal_pis_cofins_id                                      /* 064 */ -- vn_fund_legal_pis_cofins_id
            , cdll.flag_reducao_base_pis_cofins                                        /* 065 */
            , cdll.flegal_reducao_pis_cofins_id                                        /* 066 */
            , cdll.aliq_pis_reduzida                                                   /* 067 */
            , cdll.aliq_cofins_reduzida                                                /* 068 */
            , cdll.regime_especial_icms                                                /* 069 */
            , cdll.aliq_pis_especifica                                                 /* 070 */
            , cdll.aliq_cofins_especifica                                              /* 071 */
            , cdll.un_medida_aliq_especifica_pc                                        /* 072 */
            , cdll.qtde_um_aliq_especifica_pc                                          /* 073 */
            , cdll.excecao_antid_id                                                    /* 074 */
            , cdll.aliq_antid                                                          /* 075 */
            , cdll.aliq_antid_especifica                                               /* 076 */
            , cdll.tipo_unidade_medida_antid                                           /* 077 */
            , cdll.somatoria_quantidade                                                /* 078 */
            , cdll.um_aliq_especifica_antid_id                                         /* 079 */
            , cdll.acordo_aladi_id                                                     /* 080 */
            , cdll.cert_origem_mercosul_id                                             /* 081 */
            , cdll.ato_legal_ncm_id                                                    /* 082 */
            , cdll.orgao_emissor_ncm_id                                                /* 083 */
            , cdll.nr_ato_legal_ncm                                                    /* 084 */
            , cdll.ano_ato_legal_ncm                                                   /* 085 */
            , cdll.ato_legal_nbm_id                                                    /* 086 */
            , cdll.orgao_emissor_nbm_id                                                /* 087 */
            , cdll.nr_ato_legal_nbm                                                    /* 088 */
            , cdll.ano_ato_legal_nbm                                                   /* 089 */
            , cdll.ato_legal_naladi_id                                                 /* 090 */
            , cdll.orgao_emissor_naladi_id                                             /* 091 */
            , cdll.nr_ato_legal_naladi                                                 /* 092 */
            , cdll.ano_ato_legal_naladi                                                /* 093 */
            , cdll.ato_legal_acordo_id                                                 /* 094 */
            , cdll.orgao_emissor_acordo_id                                             /* 095 */
            , cdll.nr_ato_legal_acordo                                                 /* 096 */
            , cdll.ano_ato_legal_acordo                                                /* 097 */
            , cdll.aliq_mva                                                            /* 098 */
            , cdll.pro_emprego                                                         /* 099 */
            , cdll.pro_empr_aliq_base                                                  /* 100 */
            , cdll.pro_empr_aliq_antecip                                               /* 101 */
            , cdll.beneficio_pr                                                        /* 102 */
            , cdll.pr_aliq_base                                                        /* 103 */
            , cdll.pr_perc_diferido                                                    /* 104 */
            , vn_ins_estadual_id                                                       /* 105 */
            , cdll.beneficio_pr_artigo                                                 /* 106 */
            , cdll.pr_perc_vr_devido                                                   /* 107 */
            , cdll.pr_perc_minimo_base                                                 /* 108 */
            , cdll.pr_perc_minimo_suspenso                                             /* 109 */
            , vn_benef_id                                                              /* 110 */
            --, (vn_frete_afrmm/cdll.pesoliq_tot)                                      /* 111 */
            , NULL                                                                     /* 112 */
            , null                                                                     /* 113 */
            , null                                                                     /* 114 */
            , Nvl(vc_recof_dcl,'N')                                                    /* 115 */
            , cdll.beneficio_sp                                                        /* 116 */
            , cdll.enquadramento_legal_ipi_id                                          /* 117 */
            , Nvl(cdll.aliq_cofins_reduzida, cdll.aliq_cofins) - Nvl(vn_aliquota_cofins_custo,0) /* 118 */
            , cdll.aliq_ipi_red                                                        /* 119 */
            , Decode(vc_admissao_temporaria, 'S', 1, null)                             /* 120 */
            , cdll.da                                                                  /* 121 */
            , cdll.adicao                                                              /* 122 */
            , cdll.nr_lin_item                                                         /* 123 */
            , Decode(vc_tp_embarque_nac,'NAC_DE_TERC',cdll.peso_bruto_nac,NULL)        /* 124 */ --110918
            , cdll.beneficio_suspensao                                                 /* 125 */
            , cdll.perc_beneficio_suspensao                                            /* 126 */
            , vn_icms_motivo_desoneracao_id                                            /* 127 */
           );

         END IF;

        /*Gravando a auditoria*/
        imp_prc_dcllin_auditoria   ( vn_declaracao_id
                                   , vn_declaracao_lin_id
                                   , cdll.descricao
                                   , cdll.qtde
                                   , cdll.preco_unitario_m
                                   , pn_user_id
                                   , 'A'
                                   , 'N'
                                   );

         vc_step_error := null;

       END LOOP; /* cur_declaracao_lin_com_li */
    END IF; /* (pn_invoice_id IS NOT null) */
  END LOOP; /* cur_invoices */

  IF (vb_erro_nacionalizacao) THEN
    vc_step_error := 'Não há saldo suficiente de DA para realizar a ' ||
                     'nacionalização. Consulte o evento do sistema n. ' ||
                     to_char (vn_evento_id);
    RAISE ve_nacionalizacao;
  END IF;

  IF (vb_li_drw_po_sem_saldo = TRUE) THEN
    vc_step_error := 'Não há saldo suficiente nas previsões de Drawback.'
                      || ' Consulte o evento do sistema nº'
                      || To_Char (vn_evento_id_drw) || '.';
    RAISE ve_li_drw_po_sem_saldo;
  END IF;
  /*
   Verificar o resultado da validação de NCMs inativas
  */
  IF(vb_ncm_erro)THEN
    vc_step_error := 'Ocorreram erros na validação de NCMs inativas. verifique o log de erros ['||pn_evento_id||']!';
    RAISE ve_ncm;
  END IF;
  /* Deve ser dado o commit nesta procedure, pois as telas que irao utiliza-la deverao fazer
     query nos dados aqui gerados - pelo codigo declaracao_id, retornado como parametro IN OUT.
     Isso é valido quando estamos incluindo uma nova declaracao, no entanto, quando estamos
     inserindo uma invoice (total ou parcial) numa declaracao que ja existe, nao vamos dar
     commit aqui, deixamos isso a criterio do usuario - ou seja, depois que ele inseriu a
     invoice, ele decide gravar ou nao as alteracoes.

     Quando tipo de declaracao igual a 16 - Saida de Entreposto Industrial não comitaremos
     pois a tela que gera embarques no RECOF é que deverá comitar.

  */

  IF (pn_invoice_id IS NULL) AND ( vc_tp_declaracao <> '16' ) THEN
    ----------------------------------------------------------
    imp_prc_grava_doc_vinculado(vn_declaracao_id, pn_user_id);
    ------------------------------------------------------
    imp_prc_declaracao_hook(vn_declaracao_id, pn_user_id);
    ------------------------------------------------------
    vc_step_error := 'commit';
    COMMIT;
    vc_step_error := null;

  END IF;


EXCEPTION
  WHEN ve_nacionalizacao THEN
    raise_application_error (-20000, vc_step_error || chr (10) || 'IMP_PRC_GERAR_DECLARACAO');
  WHEN ve_recof THEN
    raise_application_error (-20000, vc_step_error || chr (10) || 'IMP_PRC_GERAR_DECLARACAO');
  WHEN ve_ncm THEN
    raise_application_error (-20000, vc_step_error || chr (10) || 'IMP_PRC_GERAR_DECLARACAO');
  WHEN ve_nac_adm_temp THEN
    raise_application_error (-20000, vc_step_error || chr (10) || 'IMP_PRC_GERAR_DECLARACAO');
  WHEN ve_li_drw_po_sem_saldo THEN
    raise_application_error (-20000, vc_step_error || chr (10) || 'IMP_PRC_GERAR_DECLARACAO');
  WHEN others THEN
    raise_application_error (-20000, 'IMP_PRC_GERAR_DECLARACAO [' || sqlerrm || ']. Erro na criação da Declaração. [' || vc_step_error || ']');
END imp_prc_gerar_declaracao_link;

/

