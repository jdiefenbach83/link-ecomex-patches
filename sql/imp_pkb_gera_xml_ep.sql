CREATE OR REPLACE PACKAGE BODY imp_pkg_gera_xml_ep AS

PROCEDURE logar (pc_adi varchar2,pc_campo varchar2, x CLOB) IS
PRAGMA autonomous_transaction;
vn_id_nsi NUMBER;
BEGIN
  IF Nvl(cmx_fnc_profile('DEBUG_INTERNO'),'N') <> 'N' THEN
    vn_id_nsi := cmx_fnc_proxima_sequencia('cmx_xml_ep_tmp_sq1');
    INSERT INTO cmx_xml_ep_tmp2 (id, mensagem,adi,campo) VALUES (vn_id_nsi,  x,pc_adi,pc_campo);
    COMMIT;
  END IF;
END;

FUNCTION MyXMLElement  (
   n varchar2
  , x xmltype
) RETURN xmltype deterministic IS
ret CLOB := '';
BEGIN
  SELECT x.getclobval()
    INTO ret
    FROM dual;
  ret := '<'||n||'>'||ret||'</'||n||'>';
  RETURN xmltype.createxml(xmlData=>ret,schema=>'',validated=>0,wellformed=>1);
END;

FUNCTION MyXMLConcat (
   x1 xmltype
 , x2 xmltype DEFAULT null
 , X3 xmltype DEFAULT null
 , X4 xmltype DEFAULT null
 , X5 xmltype DEFAULT null
 , X6 xmltype DEFAULT null
 , X7 xmltype DEFAULT null
 , X8 xmltype DEFAULT null
 , X9 xmltype DEFAULT null
 , X10 xmltype DEFAULT null
 , X11 xmltype DEFAULT null
 , X12 xmltype DEFAULT null
 , X13 xmltype DEFAULT null
 , X14 xmltype DEFAULT null
 , X15 xmltype DEFAULT null
 , X16 xmltype DEFAULT null
 , X17 xmltype DEFAULT null
 , X18 xmltype DEFAULT null
 , X19 xmltype DEFAULT null
 , X20 xmltype DEFAULT null
 , X21 xmltype DEFAULT null
 , X22 xmltype DEFAULT null
 , X23 xmltype DEFAULT null
 , X24 xmltype DEFAULT null
 , X25 xmltype DEFAULT null
 , X26 xmltype DEFAULT null
 , X27 xmltype DEFAULT null
 , X28 xmltype DEFAULT null
 , X29 xmltype DEFAULT null
 , X30 xmltype DEFAULT null
 , X31 xmltype DEFAULT null
 , X32 xmltype DEFAULT null
 , X33 xmltype DEFAULT null
 , X34 xmltype DEFAULT null
 , X35 xmltype DEFAULT null
 , X36 xmltype DEFAULT null
 , X37 xmltype DEFAULT null
 , X38 xmltype DEFAULT null
 , X39 xmltype DEFAULT null
 , X40 xmltype DEFAULT null
 , X41 xmltype DEFAULT null
 , X42 xmltype DEFAULT null
 , X43 xmltype DEFAULT null
 , X44 xmltype DEFAULT null
 , X45 xmltype DEFAULT null
 , X46 xmltype DEFAULT null
 , X47 xmltype DEFAULT null
 , X48 xmltype DEFAULT null
 , X49 xmltype DEFAULT null
 , X50 xmltype DEFAULT null
 , X51 xmltype DEFAULT null
 , X52 xmltype DEFAULT null
 , X53 xmltype DEFAULT null
 , X54 xmltype DEFAULT null
 , X55 xmltype DEFAULT null
 , X56 xmltype DEFAULT null
 , X57 xmltype DEFAULT null
 , X58 xmltype DEFAULT null
 , X59 xmltype DEFAULT null
 , X60 xmltype DEFAULT null
 , X61 xmltype DEFAULT null
 , X62 xmltype DEFAULT null
 , X63 xmltype DEFAULT null
 , X64 xmltype DEFAULT null
 , X65 xmltype DEFAULT null
 , X66 xmltype DEFAULT null
 , X67 xmltype DEFAULT null
 , X68 xmltype DEFAULT null
 , X69 xmltype DEFAULT null
 , X70 xmltype DEFAULT null
 , X71 xmltype DEFAULT null
 , X72 xmltype DEFAULT null
 , X73 xmltype DEFAULT null
 , X74 xmltype DEFAULT null
 , X75 xmltype DEFAULT null
 , X76 xmltype DEFAULT null
 , X77 xmltype DEFAULT null
 , X78 xmltype DEFAULT null
 , X79 xmltype DEFAULT null
 , X80 xmltype DEFAULT null
 , X81 xmltype DEFAULT null
 , X82 xmltype DEFAULT null
 , X83 xmltype DEFAULT null
 , X84 xmltype DEFAULT null
 , X85 xmltype DEFAULT null
 , X86 xmltype DEFAULT null
 , X87 xmltype DEFAULT null
 , X88 xmltype DEFAULT null
 , X89 xmltype DEFAULT null
 , X90 xmltype DEFAULT null
 , X91 xmltype DEFAULT null
 , X92 xmltype DEFAULT null
 , X93 xmltype DEFAULT null
 , X94 xmltype DEFAULT null
 , X95 xmltype DEFAULT null
 , X96 xmltype DEFAULT null
 , X97 xmltype DEFAULT null
 , X98 xmltype DEFAULT null
 , X99 xmltype DEFAULT null
 , X100 xmltype DEFAULT null
) RETURN xmltype deterministic IS
ret CLOB := '';
BEGIN
  IF x1   IS NOT NULL THEN SELECT x1.getclobval() INTO ret FROM dual;                                     END IF;
  IF x2   IS NOT NULL THEN SELECT ret||x2.getclobval()   INTO ret FROM dual;      END IF;
  IF X3   IS NOT NULL THEN SELECT ret||X3.getclobval()   INTO ret FROM dual;         END IF;
  IF X4   IS NOT NULL THEN SELECT ret||X4.getclobval()   INTO ret FROM dual;         END IF;
  IF X5   IS NOT NULL THEN SELECT ret||X5.getclobval()   INTO ret FROM dual;         END IF;
  IF X6   IS NOT NULL THEN SELECT ret||X6.getclobval()   INTO ret FROM dual;         END IF;
  IF X7   IS NOT NULL THEN SELECT ret||X7.getclobval()   INTO ret FROM dual;         END IF;
  IF X8   IS NOT NULL THEN SELECT ret||X8.getclobval()   INTO ret FROM dual;                                          END IF;
  IF X9   IS NOT NULL THEN SELECT ret||X9.getclobval()   INTO ret FROM dual;                                          END IF;
  IF X10  IS NOT NULL THEN SELECT ret||X10.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X11  IS NOT NULL THEN SELECT ret||X11.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X12  IS NOT NULL THEN SELECT ret||X12.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X13  IS NOT NULL THEN SELECT ret||X13.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X14  IS NOT NULL THEN SELECT ret||X14.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X15  IS NOT NULL THEN SELECT ret||X15.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X16  IS NOT NULL THEN SELECT ret||X16.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X17  IS NOT NULL THEN SELECT ret||X17.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X18  IS NOT NULL THEN SELECT ret||X18.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X19  IS NOT NULL THEN SELECT ret||X19.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X20  IS NOT NULL THEN SELECT ret||X20.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X21  IS NOT NULL THEN SELECT ret||X21.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X22  IS NOT NULL THEN SELECT ret||X22.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X23  IS NOT NULL THEN SELECT ret||X23.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X24  IS NOT NULL THEN SELECT ret||X24.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X25  IS NOT NULL THEN SELECT ret||X25.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X26  IS NOT NULL THEN SELECT ret||X26.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X27  IS NOT NULL THEN SELECT ret||X27.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X28  IS NOT NULL THEN SELECT ret||X28.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X29  IS NOT NULL THEN SELECT ret||X29.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X30  IS NOT NULL THEN SELECT ret||X30.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X31  IS NOT NULL THEN SELECT ret||X31.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X32  IS NOT NULL THEN SELECT ret||X32.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X33  IS NOT NULL THEN SELECT ret||X33.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X34  IS NOT NULL THEN SELECT ret||X34.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X35  IS NOT NULL THEN SELECT ret||X35.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X36  IS NOT NULL THEN SELECT ret||X36.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X37  IS NOT NULL THEN SELECT ret||X37.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X38  IS NOT NULL THEN SELECT ret||X38.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X39  IS NOT NULL THEN SELECT ret||X39.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X40  IS NOT NULL THEN SELECT ret||X40.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X41  IS NOT NULL THEN SELECT ret||X41.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X42  IS NOT NULL THEN SELECT ret||X42.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X43  IS NOT NULL THEN SELECT ret||X43.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X44  IS NOT NULL THEN SELECT ret||X44.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X45  IS NOT NULL THEN SELECT ret||X45.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X46  IS NOT NULL THEN SELECT ret||X46.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X47  IS NOT NULL THEN SELECT ret||X47.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X48  IS NOT NULL THEN SELECT ret||X48.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X49  IS NOT NULL THEN SELECT ret||X49.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X50  IS NOT NULL THEN SELECT ret||X50.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X51  IS NOT NULL THEN SELECT ret||X51.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X52  IS NOT NULL THEN SELECT ret||X52.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X53  IS NOT NULL THEN SELECT ret||X53.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X54  IS NOT NULL THEN SELECT ret||X54.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X55  IS NOT NULL THEN SELECT ret||X55.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X56  IS NOT NULL THEN SELECT ret||X56.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X57  IS NOT NULL THEN SELECT ret||X57.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X58  IS NOT NULL THEN SELECT ret||X58.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X59  IS NOT NULL THEN SELECT ret||X59.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X60  IS NOT NULL THEN SELECT ret||X60.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X61  IS NOT NULL THEN SELECT ret||X61.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X62  IS NOT NULL THEN SELECT ret||X62.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X63  IS NOT NULL THEN SELECT ret||X63.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X64  IS NOT NULL THEN SELECT ret||X64.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X65  IS NOT NULL THEN SELECT ret||X65.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X66  IS NOT NULL THEN SELECT ret||X66.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X67  IS NOT NULL THEN SELECT ret||X67.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X68  IS NOT NULL THEN SELECT ret||X68.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X69  IS NOT NULL THEN SELECT ret||X69.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X70  IS NOT NULL THEN SELECT ret||X70.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X71  IS NOT NULL THEN SELECT ret||X71.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X72  IS NOT NULL THEN SELECT ret||X72.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X73  IS NOT NULL THEN SELECT ret||X73.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X74  IS NOT NULL THEN SELECT ret||X74.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X75  IS NOT NULL THEN SELECT ret||X75.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X76  IS NOT NULL THEN SELECT ret||X76.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X77  IS NOT NULL THEN SELECT ret||X77.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X78  IS NOT NULL THEN SELECT ret||X78.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X79  IS NOT NULL THEN SELECT ret||X79.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X80  IS NOT NULL THEN SELECT ret||X80.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X81  IS NOT NULL THEN SELECT ret||X81.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X82  IS NOT NULL THEN SELECT ret||X82.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X83  IS NOT NULL THEN SELECT ret||X83.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X84  IS NOT NULL THEN SELECT ret||X84.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X85  IS NOT NULL THEN SELECT ret||X85.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X86  IS NOT NULL THEN SELECT ret||X86.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X87  IS NOT NULL THEN SELECT ret||X87.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X88  IS NOT NULL THEN SELECT ret||X88.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X89  IS NOT NULL THEN SELECT ret||X89.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X90  IS NOT NULL THEN SELECT ret||X90.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X91  IS NOT NULL THEN SELECT ret||X91.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X92  IS NOT NULL THEN SELECT ret||X92.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X93  IS NOT NULL THEN SELECT ret||X93.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X94  IS NOT NULL THEN SELECT ret||X94.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X95  IS NOT NULL THEN SELECT ret||X95.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X96  IS NOT NULL THEN SELECT ret||X96.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X97  IS NOT NULL THEN SELECT ret||X97.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X98  IS NOT NULL THEN SELECT ret||X98.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X99  IS NOT NULL THEN SELECT ret||X99.getclobval()  INTO ret FROM dual;                                         END IF;
  IF X100 IS NOT NULL THEN SELECT ret||X100.getclobval() INTO ret FROM dual;                                         END IF;

  RETURN xmltype.createxml(xmlData=>ret,schema=>'',validated=>0,wellformed=>1);
END;

  PROCEDURE imp_prc_gera_header_di (pn_evento_id              NUMBER
                                   , pn_declaracao_id         NUMBER
                                   , pn_empresa_id            NUMBER
                                   , pn_embarque_id           NUMBER
                                   , pc_embarque_num          VARCHAR2
                                   , pn_embarque_ano          NUMBER
                                   , pc_cnpj                  VARCHAR2
                                   , pc_nome                  VARCHAR2
                                   , pc_fone                  VARCHAR2
                                   , pc_endereco              VARCHAR2
                                   , pc_complemento_end       VARCHAR2
                                   , pc_bairro                VARCHAR2
                                   , pc_cidade                VARCHAR2
                                   , pn_uf_id                 NUMBER
                                   , pc_cep                   VARCHAR2
                                   , pc_cpf_repres_legal      VARCHAR2
                                   , pc_trading               VARCHAR2
                                   , pn_da_id                 NUMBER
                                   , pc_rg_tipo_transmissao   VARCHAR2
                                   , pc_nome_arquivo          VARCHAR2
                                   , pn_xml_id                NUMBER
                                   , pc_remover_memo_calc     VARCHAR2 DEFAULT 'N' )
  IS

    CURSOR cur_declaracoes( pn_da_conhec_id        NUMBER
                          , pn_da_vrt_sg_m         NUMBER
                          , pn_da_vrt_sg_mn        NUMBER
                          , pn_da_moeda_seguro_id  NUMBER ) IS
    SELECT id.tp_declaracao_id
         , cmx_pkg_tabelas.codigo(id.tp_declaracao_id) tp_declaracao_cod
         , id.mde_despacho
         , id.urfe_id
         , id.urfd_id
         , nvl (id.tp_consignatario, 1) tp_consignatario
         , id.importador_id
         , id.importador_site_id
         , id.consignatario_site_id --carlosh
         , id.pais_proc_id
         , ic.via_transporte_id
         , ic.multimodal
         , ic.transportador_id
         , ic.transportador_site_id
         , ic.identificacao_veiculo
         , ic.bandeira_id
         , ic.agente_carga_id
         , ic.agente_carga_site_id
         , ic.tp_conhecimento_id
         , ic.house
         , ic.master
         , ic.presenca_carga
         , ic.local_embarque_id
         , ic.peso_bruto
         , id.peso_bruto_nac
         , ic.peso_liquido
         , id.peso_liquido_nac
         , id.tp_manifesto
         , id.nr_manifesto
         , id.rec_alfand_id
         , id.vrt_fr_prepaid_m             valor_prepaid_m
         , id.vrt_fr_collect_m             valor_collect_m
         , id.vrt_fr_territorio_nacional_m valor_terr_nacional_m
         , decode ( cmx_pkg_tabelas.codigo(ic.via_transporte_id)
                  , '04' -- AEREO
                  , decode( cmx_pkg_tabelas.codigo(ic.tp_conhecimento_id)
                          , '14' -- DSIC
                          , null
                          , ic.moeda_id
                          )
                  , ic.moeda_id
                  )                        moeda_frete_id
         , decode ( cmx_pkg_tabelas.codigo (id.tp_declaracao_id)
                  , '13', ie.vrt_sg_m
                  , '14', ie.vrt_sg_m
                  , '15', ie.vrt_sg_m
                  , nvl (pn_da_vrt_sg_m , ie.vrt_sg_m)
                  ) vrt_sg_m
         , decode ( cmx_pkg_tabelas.codigo (id.tp_declaracao_id)
                  , '13', ie.vrt_sg_mn
                  , '14', ie.vrt_sg_mn
                  , '15', ie.vrt_sg_mn
                  , nvl (pn_da_vrt_sg_mn , ie.vrt_sg_mn)
                  ) vrt_sg_mn
         , nvl(pn_da_moeda_seguro_id, ie.moeda_seguro_id) moeda_seguro_id
         , id.vmle_mn
         , ic.conhec_id
         , id.util_conhec
         , id.setor_armazem_id
         , id.conta_id
         , id.banco_agencia_id
         , id.tp_conta
         , id.vrt_ii
         , id.vrt_ipi
         , id.vrt_icms
         , id.vrt_fr_mn
         , id.txt_inf_complementar
         , Trunc(id.data_taxa_conversao)  data_taxa_conversao
         , imp_fnc_busca_dt_cronog(id.embarque_id, 'EMBARQUE', 'R') data_embarque
         , imp_fnc_busca_dt_cronog(id.embarque_id, 'CHEGADA' , 'R') data_chegada
         , id.retif_nr_declaracao
         , id.retif_sequencia
         , cmx_pkg_tabelas.auxiliar (id.retif_motivo_id, 1)         retif_motivo
         , id.retif_dt_declaracao
         , id.despachante_id
         , id.despachante_site_id
      FROM imp_declaracoes   id
         , imp_conhecimentos ic
         , imp_embarques     ie
     WHERE id.declaracao_id = pn_declaracao_id
       AND ie.embarque_id   = id.embarque_id
       AND ic.conhec_id(+)  = nvl(pn_da_conhec_id, ie.conhec_id);

  CURSOR cur_conhec_nac IS
    SELECT a.conhec_id
         , a.vrt_sg_m
         , a.vrt_sg_mn
         , a.moeda_seguro_id
      FROM imp_embarques     a
         , imp_declaracoes   b
     WHERE b.declaracao_id = pn_da_id
       AND a.embarque_id   = b.embarque_id;

  CURSOR cur_nr_adicoes IS
    SELECT count(*) nr_adicoes
      FROM imp_declaracoes_adi
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_dcl_dcto_instr IS
    SELECT to_number (ct.auxiliar1) ordem
         , ct.codigo                tp_documento
         , iddi.nr_documento        nr_documento
         , null                     nr_documento2
      FROM imp_dcl_dcto_instr iddi
         , cmx_tabelas        ct
     WHERE iddi.declaracao_id = pn_declaracao_id
       AND ct.tabela_id       = iddi.tp_documento_id
     ORDER BY to_number (ct.auxiliar1);

  CURSOR cur_dcl_darf IS
    SELECT darf.cd_receita_id
         , darf.valor_mn
         , darf.dt_pgto
         , darf.vrmulta_mn
         , darf.vrjuros_mn
         , darf.banco_agencia_id
         , darf.conta_id
         , darf.tp_conta
         , Decode(darf.retif_sequencia, 0, 0, Decode(darf.dt_pgto, NULL, 99, darf.retif_sequencia)) retif_sequencia
--         , Nvl( (SELECT DISTINCT cta.numero
--                   FROM cmx_bancos_agencias_cta cta
--                  WHERE cta.banco_agencia_id = darf.banco_agencia_id
--                    AND cta.conta_id = darf.conta_id
--                    AND ( (cta.tp_conta = darf.tp_conta) OR
--                          (darf.tp_conta IS NULL AND cta.tp_conta = 'INTERNO')
--                        )
--                )
--              , (SELECT DISTINCT cta.numero
--                   FROM cmx_bancos_agencias_cta cta
--                  WHERE cta.banco_agencia_id = decl.banco_agencia_id
--                    AND cta.conta_id = decl.conta_id
--                    AND ( (cta.tp_conta = decl.tp_conta) OR
--                          (decl.tp_conta IS NULL AND cta.tp_conta = 'INTERNO')
--                        )
--                )
--              )                                                      conta
      FROM imp_dcl_darf  darf
         , imp_declaracoes decl
     WHERE darf.declaracao_id = pn_declaracao_id
       AND darf.declaracao_id = decl.declaracao_id(+)
     ORDER BY darf.retif_sequencia, darf.cd_receita_id;

  CURSOR cur_dcl_processo IS
    SELECT tp_processo
         , nr_processo
      FROM imp_dcl_processo
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_entidade (pn_entidade_id NUMBER, pn_entidade_site_id NUMBER) IS
    SELECT ces.nr_documento cnpj
         , ce.nome
         , ces.fone
         , ces.endereco
         , ces.complemento complemento_end
         , ces.bairro
         , ces.cidade
         , ces.uf_id
         , ces.cep
         , ces.endereco_sem_numero
         , ces.endereco_numero
         , cmx_pkg_tabelas.codigo(ces.pais_id) AS cod_pais
      FROM imp_entidades       ce
         , imp_entidades_sites ces
     WHERE ce.entidade_id       = pn_entidade_id
       AND ces.entidade_id      = ce.entidade_id
       AND ces.entidade_site_id = pn_entidade_site_id;

  CURSOR cur_volumes_dcl IS
    SELECT tp_embalagem_id
         , Sum(qtde) qtde
      FROM imp_vw_conhec_volumes_dcl
     WHERE declaracao_id = pn_declaracao_id
     GROUP BY tp_embalagem_id;

  CURSOR cur_dcl_armazem IS
    SELECT cd_armazem
      FROM imp_dcl_armazem
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_conta_deb_aut (pn_conta_id NUMBER) IS
    SELECT numero
      FROM cmx_bancos_agencias_cta
     WHERE conta_id = pn_conta_id;

  CURSOR cur_banco_deb_aut (pn_bco_agc_id NUMBER) IS
    SELECT substr(LPad(RTrim(LTrim( NVL(cd_banco_bacen, '0'))),5,'0'),3,3)
         , LPad( RTrim(LTrim(NVL(cd_agencia_bacen, '0'))), 4,'0' )
      FROM cmx_bancos_agencias
     WHERE banco_agencia_id = pn_bco_agc_id;

  CURSOR cur_moeda_unica IS
    SELECT DISTINCT moeda_id
      FROM imp_declaracoes_adi
     WHERE declaracao_id = pn_declaracao_id;

  CURSOR cur_informacoes_mercosul IS
    SELECT nr_de_mercosul
         , nr_re_inicial
         , nr_re_final
      FROM imp_dcl_informacoes_mercosul
     WHERE declaracao_id = pn_declaracao_id
     ORDER BY nr_seq_de;

  CURSOR cur_di_unica IS
    SELECT dcl.declaracao_id
         , ie.embarque_id
         , ic.via_transporte_id
         , ic.multimodal
         , ic.transportador_id
         , ic.transportador_site_id
         , ic.identificacao_veiculo
         , ic.bandeira_id
         , ic.agente_carga_id
         , ic.agente_carga_site_id
         , ic.tp_conhecimento_id
         , ic.house
         , ic.master
         , ic.presenca_carga
         , ic.local_embarque_id
         , Nvl(Nvl(ie.prev_peso_bruto,ic.peso_bruto), dcll.peso_bruto) peso_bruto
         , Nvl(dcll.peso_liquido, ic.peso_liquido) peso_liquido
         , dcl.vrt_sg_mn
         , dcl.vrt_sg_m
         , dcl.vrt_fr_mn
         , dcl.vrt_fr_m
         , decode ( cmx_pkg_tabelas.codigo(ic.via_transporte_id)
                  , '04' -- AEREO
                  , decode( cmx_pkg_tabelas.codigo(ic.tp_conhecimento_id)
                          , '14' -- DSIC
                          , null
                          , ic.moeda_id
                          )
                  , ic.moeda_id
                  )                        moeda_frete_id
         , nvl(ie.prev_seg_moeda_id,ipr.moeda_seguro_id) moeda_seguro_id
      FROM imp_po_remessa    ipr
         , imp_conhecimentos ic
         , (SELECT Sum(idl.pesoliq_tot) peso_liquido
                 , Sum(idl.pesobrt_tot) peso_bruto
                 , idl.declaracao_id
              FROM imp_declaracoes_lin idl
             WHERE idl.declaracao_id = pn_declaracao_id
          GROUP BY idl.declaracao_id) dcll
         , imp_embarques     ie
         , imp_declaracoes    dcl
     WHERE ipr.conhec_id = ic.conhec_id
       AND ie.embarque_id = ipr.embarque_id
       AND dcl.embarque_id  = ie.embarque_id
       AND dcll.declaracao_id = dcl.declaracao_id
       AND dcl.declaracao_id  = pn_declaracao_id
       AND cmx_pkg_tabelas.codigo(tp_embarque_id) = 'DI_UN'
       AND ipr.nr_remessa = 1;

  CURSOR cur_declaracao_site_imp(pn_importador_site_id NUMBER ) IS --Para tratar trading e campo cnpj_conta_ordem  [carlosh]
		SELECT REPLACE(REPLACE(REPLACE(nr_documento, '.',''),'/',''),'-','') importador
		  FROM imp_entidades_sites
		 WHERE entidade_site_id = pn_importador_site_id;

  CURSOR cur_declaracao_site_consig(pn_consignatario_site_id NUMBER ) IS --Para tratar trading e campo cnpj_proprio [carlosh]
	  SELECT REPLACE(REPLACE(REPLACE(nr_documento, '.',''),'/',''),'-','') importador
		  FROM imp_entidades_sites
		 WHERE entidade_site_id = pn_consignatario_site_id;

  CURSOR cur_dados_retificacao IS
    SELECT cmx_pkg_tabelas.auxiliar(retif_motivo_id,1)      codigoMotivoRetificacao
         , retif_nr_declaracao                              numeroDeclaracaoRetificacao
--         , retif_sequencia                                  numeroSequencialRetificacao
         , Decode(retif_nr_declaracao,NULL,NULL,retif_sequencia-1) numeroSequencialRetificacao
      FROM imp_declaracoes
     WHERE declaracao_id = pn_declaracao_id; --chl

  CURSOR cur_conta_int( pn_banco_agencia_id NUMBER
                      , pn_conta_id         NUMBER
                      ) IS
    SELECT cta.numero
      FROM cmx_bancos_agencias_cta cta
     WHERE cta.banco_agencia_id = pn_banco_agencia_id
       AND cta.conta_id         = pn_conta_id
       AND cta.tp_conta         = 'INTERNO';

  CURSOR cur_conta_forn( pn_banco_agencia_id NUMBER
                       , pn_conta_id         NUMBER
                       , pn_entidade_id      NUMBER
                       , pn_entidade_site_id NUMBER
                       ) IS
    SELECT cta.numero
      FROM cmx_bancos_agencias_cta cta
     WHERE cta.banco_agencia_id = pn_banco_agencia_id
       AND cta.conta_id         = pn_conta_id
       AND cta.tp_conta         = 'FORNECEDOR'
       AND entidade_id          = pn_entidade_id
       AND entidade_site_id     = pn_entidade_site_id;

  ----------------------------------------------------------
  -- Informacoes Gerais da Declaracao - (01)
  ----------------------------------------------------------
  vc_ref_declaracao      VARCHAR2(15)    := null;  vc_nr_adicoes         VARCHAR2(03) := null;
  vc_tp_declaracao       VARCHAR2(02)    := null;
  vc_imp_cnpj            VARCHAR2(14)    := null;  vc_imp_nome           VARCHAR2(60) := null;
  vc_imp_fone            VARCHAR2(15)    := null;  vc_imp_endereco       VARCHAR2(40) := null;
  vc_imp_nrendereco      VARCHAR2(06)    := null;  vc_imp_complemento    VARCHAR2(21) := null;
  vc_imp_bairro          VARCHAR2(25)    := null;  vc_imp_cidade         VARCHAR2(25) := null;
  vc_imp_uf              VARCHAR2(02)    := null;  vc_imp_cep            VARCHAR2(08) := null;
  cImpCPFImp             VARCHAR2(11)    := null;  vc_mde_despacho       VARCHAR2(01) := null;
  vc_urfe                VARCHAR2(07)    := null;  vc_urfd               VARCHAR2(07) := null;
  vc_consig_cnpj         VARCHAR2(14)    := null;  vc_consig_nome        VARCHAR2(60) := null;
  cTpConsig              VARCHAR2(01)    := null;  vc_pais_proc          VARCHAR2(03) := null;
  vc_via_transp          VARCHAR2(02)    := null;  vc_multimodal         VARCHAR2(01) := null;
  vc_ident_veiculo       VARCHAR2(15)    := null;  vc_nome_veiculo       VARCHAR2(30) := null;
  vc_transp_cnpj         VARCHAR2(14)    := null;  vc_transp_nome        VARCHAR2(60) := null;
  vc_bandeira            VARCHAR2(03)    := null;  vc_agente_carga_cnpj  VARCHAR2(14) := null;
  vc_tp_agente_carga     VARCHAR2(01)    := null;  vc_tp_conhecimento    VARCHAR2(02) := null;
  vc_house               VARCHAR2(18)    := null;  vc_master             VARCHAR2(18) := null;
  vc_local_embarque      VARCHAR2(50)    := null;  vc_data_embarque      VARCHAR2(08) := null;
  vc_peso_bruto          VARCHAR2(20)    := null;  vc_peso_liquido       VARCHAR2(20) := null;
  vc_data_chegada        VARCHAR2(08)    := null;  vc_tp_manifesto       VARCHAR2(01) := null;
  vc_nr_manifesto        VARCHAR2(15)    := null;  vc_rec_alfand         VARCHAR2(07) := null;
  vc_vrt_fr_prepaid      VARCHAR2(15)    := null;  vc_vrt_fr_collect     VARCHAR2(15) := null;
  vc_vrt_fr_tnac         VARCHAR2(15)    := null;  vc_moeda_frete        VARCHAR2(03) := null;
  vc_vrt_fr_mn           VARCHAR2(15)    := null;  vc_vrt_sg_m           VARCHAR2(15) := null;
  vc_moeda_seguro        VARCHAR2(03)    := null;  vc_vrt_sg_mn          VARCHAR2(15) := null;
  vc_vrt_vmle_mn         VARCHAR2(15)    := null;  vc_util_conhec        VARCHAR2(01) := null;
  vc_setor_armazem       VARCHAR2(03)    := null;  vc_cta_deb_aut        VARCHAR2(19) := null;
  vc_tpcta_deb_aut       VARCHAR2(01)    := null;  vc_conhec_transp      VARCHAR2(40) := null;
  vc_inf_complementar    VARCHAR2(32700) := null;
  vc_inf_complementar_clob   CLOB;

  vc_docInstDesp         VARCHAR2(32700) := NULL;
  vx_docInstDesp         XMLType;
  vc_embalagem           VARCHAR2(32700) := NULL;
  vx_embalagem           XMLType;
  vc_infMercosul         VARCHAR2(32700) := NULL;
  vx_infMercosul         XMLType;
  vc_pagamento           VARCHAR2(32700) := null;
  vx_pagamento           XMLType;
  vc_processo            VARCHAR2(32700) := null;
  vc_armazem             VARCHAR2(10);
  vx_processo            XMLType;
  xml_adicao             xmltype;
  xml_di                 xmltype;

  vc_nr_decl_retif       VARCHAR2(15)    := null;
  vc_seq_retif           VARCHAR2(02)    := null;
  vc_motivo_retif        VARCHAR2(02)    := null;
  vc_dt_decl_retif       VARCHAR2(08)    := null;
  vc_trib_retif          VARCHAR2(01)    := null;

  vr_di_unica            cur_di_unica%rowtype;
  vb_found_di_unica      BOOLEAN;

  -----------------------------------------------------------
  -- Ocorrencias de Embalagem da Carga - (04)
  -----------------------------------------------------------
  vc_tp_embalagem        VARCHAR2(02)    := null;
  vc_qt_embalagem        VARCHAR2(05)    := null;

  -----------------------------------------------------------
  -- Ocorrencias de Pagamentos de Tributos - (07)
  -----------------------------------------------------------
  vc_cd_receita          VARCHAR2(04)    := null;
  vc_cd_banco            VARCHAR2(03)    := null;
  vc_cd_agencia          VARCHAR2(05)    := null;
  vc_vrt_tributo         VARCHAR2(15)    := null;
  vc_dt_pgto             VARCHAR2(08)    := null;
  vc_vr_multa            VARCHAR2(10)    := null;
  vc_vr_juros            VARCHAR2(10)    := null;
  vc_seq_retif_darf      VARCHAR2(02)    := null;

  cr_cons                cur_entidade%ROWTYPE;
  cr_tran                cur_entidade%ROWTYPE;
  cr_agcg                cur_entidade%ROWTYPE;

  vc_string              VARCHAR2(10000) := null;

  vn_nr_tributos         NUMBER;
  vb_existe_proc_j_d     BOOLEAN         := false;
  vn_contador_did        NUMBER          := 0;
  vc_aux_erro            VARCHAR2(1000)  := null;
	vb_sem_erros           BOOLEAN         := TRUE;
  vn_nr_adicoes          NUMBER          := null;

  vn_da_conhec_id        NUMBER          := null;
  vn_da_vrt_sg_m         NUMBER          := null;
  vn_da_vrt_sg_mn        NUMBER          := null;
  vn_da_moeda_seguro_id  NUMBER          := null;

  vn_count_moeda_adi     NUMBER          := 0;
  vn_moeda_id            NUMBER          := null;
  vc_moeda_unica         VARCHAR2(01)    := null;
  vc_vrt_vmle_m          VARCHAR2(15)    := null;
  vc_moeda_vmle          VARCHAR2(03)    := null;

  vc_nr_documento        VARCHAR2(25)    := null;

  vn_char_fim            NUMBER          := 0;
	vb_quebrou_linha       BOOLEAN         := false;
  vb_utlima_linha        BOOLEAN         := false;
  vc_texto               VARCHAR2(32700) := null;

  vc_envelope            CLOB            := NULL;
  vc_blob                BLOB            := NULL;
  vc_nome_arquivo        VARCHAR2(256);
  vn_offset              NUMBER;
  vn_evento_id           NUMBER;
  vn_blob_id             NUMBER;

  ----------------------------------------------------------
  -- Informacoes Gerais da Declaracao - (08)
  ----------------------------------------------------------
  vc_codigo_retif    VARCHAR2(20);
  vc_retif_nr_decl   VARCHAR2(15);
  vn_retif_sequencia NUMBER;      --chl

  vc_nr_conta        VARCHAR2(30);
  vc_nr_conta_temp   VARCHAR2(30);

  vn_banco_temp_id   NUMBER;
  vn_conta_temp_id   NUMBER;
BEGIN
IF pn_empresa_id IS NULL THEN Raise_Application_Error(-20000,'Falta preencher Empresa'); END IF;
	vn_da_conhec_id       := null;
  vn_da_vrt_sg_m        := null;
  vn_da_vrt_sg_mn       := null;
  vn_da_moeda_seguro_id := null;

	IF pn_da_id IS NOT null THEN
    OPEN  cur_conhec_nac;
    FETCH cur_conhec_nac INTO vn_da_conhec_id
                            , vn_da_vrt_sg_m
                            , vn_da_vrt_sg_mn
                            , vn_da_moeda_seguro_id;
    CLOSE cur_conhec_nac;
  END IF;


  vc_aux_erro := 'Erro nos dados gerais de embarque...';
  FOR i In cur_declaracoes ( vn_da_conhec_id
                           , vn_da_vrt_sg_m
                           , vn_da_vrt_sg_mn
                           , vn_da_moeda_seguro_id
                           )
  LOOP
--    pc_PROCESSO := '(01) processando informações gerais...';
--    SYNCHRONIZE;

    vb_sem_erros := FALSE;

    vc_aux_erro           := 'Erro na conversão do tipo da declaração...';
    vc_tp_declaracao      := SubStr(cmx_pkg_tabelas.codigo (i.tp_declaracao_id),1,2);

    IF ( (nvl(cmx_fnc_profile('IMP_CONTROLA_NUMER_IMPOSTOS'),'N') = 'S') AND
    	   (vc_tp_declaracao <> '16')
    	 )
    THEN
      vb_sem_erros := imp_fnc_controla_numerarios( i.vrt_icms, pn_evento_id,pn_embarque_id, pn_declaracao_id, pn_empresa_id );

    ELSE
    	vb_sem_erros := TRUE;
    END IF;

    ----------------------------------------------------------
    -- Informações Gerais da Declaração - (01)
    ----------------------------------------------------------
    vc_aux_erro        := 'Erro na composição do número da declaração...';
    vc_ref_declaracao  := LPad(LTrim(pc_embarque_num),10,'0') ||
                          '/' ||
                          RPad(LTrim(To_Char(pn_embarque_ano)),04);

    vc_aux_erro        := 'Erro na conversão do número de adições...';

    OPEN  cur_nr_adicoes;
    FETCH cur_nr_adicoes INTO vn_nr_adicoes;
    CLOSE cur_nr_adicoes;

    vc_nr_adicoes      := to_char(vn_nr_adicoes);

    -------------------------------------------------------
    -- Dados do importador e consignatário
    --
    -- Quando a importação é própria(1):
    --   IMPORTADOR    = dados da CMX_EMPRESAS (pc_cnpj)
    --   CONSIGNATARIO = não tem
    --
    -- Quando a importação é por conta e ordem(2):
    --   Se a empresa for trading:
    --     IMPORTADOR    = dados da CMX_EMPRESAS (pc_cnpj)
    --     CONSIGNATARIO = dados da IMP_ENTIDADES_SITES
    --   Se a empresa não for trading:
    --     IMPORTADOR    = dados da IMP_ENTIDADES_SITES
    --     CONSIGNATARIO = dados da CMX_EMPRESAS (pc_cnpj)
    -------------------------------------------------------
    vc_aux_erro        := 'Erro na conversão do tipo de consignatário...';
    cTpConsig          := to_char (i.tp_consignatario);

    IF (i.tp_consignatario = 1) THEN /*importacao propria*/
      vc_consig_cnpj   := null;

      vc_aux_erro        := 'Erro na conversão do número de CGC do importador...';
      vc_imp_cnpj        := SubStr(pc_cnpj,1,14);
      vc_aux_erro        := 'Erro na conversão do nome do importador...';
      vc_imp_nome        := SubStr(pc_nome,1,60) ;
      vc_aux_erro        := 'Erro na conversão do telefone do importador...';
      vc_imp_fone        := SubStr(pc_fone,1,15);
      vc_aux_erro        := 'Erro na conversão do endereço do importador...';
      vc_imp_endereco    := SubStr(pc_endereco,1,40);
      vc_aux_erro        := 'Erro na conversão do número do endereço do importador...';
      vc_imp_nrendereco  := '      ';
      vc_aux_erro        := 'Erro na conversão do complemento do importador...';
      vc_imp_complemento := SubStr(pc_complemento_end,1,21);
      vc_aux_erro        := 'Erro na conversão do bairro do importador...';
      vc_imp_bairro      := SubStr(pc_bairro,1,25);
      vc_aux_erro        := 'Erro na conversão da cidade do importador...';
      vc_imp_cidade      := SubStr(pc_cidade,1,25);
      vc_aux_erro        := 'Erro na conversão da UF do importador...';
      vc_imp_uf          := SubStr(cmx_pkg_tabelas.codigo (pn_uf_id),1,02);
      vc_aux_erro        := 'Erro na conversão do CEP do importador...';
      vc_imp_cep         := SubStr(pc_cep,1,08);
      vc_aux_erro        := 'Erro na conversão do CPF do importador...';
      cImpCPFImp         := SubStr(pc_cpf_repres_legal,1,11);

    ELSE /*importacao por conta e ordem*/
      vc_aux_erro := 'Erro na cursor de consignatário...';
      OPEN  cur_entidade (i.importador_id, i.importador_site_id);
      FETCH cur_entidade Into cr_cons;
      CLOSE cur_entidade;

      IF pc_trading = 'S' THEN

        vc_aux_erro      := 'Erro na conversão do CNPJ do consignatário...';
        OPEN cur_declaracao_site_consig(i.importador_site_id);
        FETCH cur_declaracao_site_consig INTO vc_consig_cnpj;-- dados da IMP_ENTIDADES_SITES   [carlosh]
        CLOSE cur_declaracao_site_consig;

        --vc_consig_cnpj   := SubStr(cr_cons.cnpj,1,14);
        vc_aux_erro        := 'Erro na conversão do número de CNPJ do importador...';
	      vc_imp_cnpj        := SubStr(pc_cnpj,1,14); --Dados da CMX_EMPRESAS                    [carlosh]


	      vc_aux_erro        := 'Erro na conversão do nome do importador...';
	      vc_imp_nome        := SubStr(pc_nome,1,60) ;
	      vc_aux_erro        := 'Erro na conversão do telefone do importador...';
	      vc_imp_fone        := SubStr(pc_fone,1,15);
	      vc_aux_erro        := 'Erro na conversão do endereço do importador...';
	      vc_imp_endereco    := SubStr(pc_endereco,1,40);
	      vc_aux_erro        := 'Erro na conversão do número do endereço do importador...';
	      vc_imp_nrendereco  := '      ';
	      vc_aux_erro        := 'Erro na conversão do complemento do importador...';
	      vc_imp_complemento := SubStr(pc_complemento_end,1,21);
	      vc_aux_erro        := 'Erro na conversão do bairro do importador...';
	      vc_imp_bairro      := SubStr(pc_bairro,1,25);
	      vc_aux_erro        := 'Erro na conversão da cidade do importador...';
	      vc_imp_cidade      := SubStr(pc_cidade,1,25);
	      vc_aux_erro        := 'Erro na conversão da UF do importador...';
	      vc_imp_uf          := SubStr(cmx_pkg_tabelas.codigo (pn_uf_id),1,02);
	      vc_aux_erro        := 'Erro na conversão do CEP do importador...';
	      vc_imp_cep         := SubStr(pc_cep,1,08);

      ELSE

	      vc_aux_erro      := 'Erro na conversão do CGC do consignatário...';
	      vc_consig_cnpj   := SubStr(pc_cnpj,1,14); -- dados da CMX_EMPRESAS                [carlosh]

        vc_aux_erro        := 'Erro na conversão do número de CGC do importador...';
	      OPEN cur_declaracao_site_imp(i.consignatario_site_id);
        FETCH cur_declaracao_site_imp INTO vc_imp_cnpj;-- dados da IMP_ENTIDADES_SITES   [carlosh]
        CLOSE cur_declaracao_site_imp;

        --vc_imp_cnpj        := SubStr(cr_cons.cnpj,1,14);


        vc_aux_erro        := 'Erro na conversão do nome do importador...';
	      vc_imp_nome        := SubStr(cr_cons.nome,1,60) ;
	      vc_aux_erro        := 'Erro na conversão do telefone do importador...';
	      vc_imp_fone        := SubStr(cr_cons.fone,1,15);

        IF (cmx_fnc_profile ('IMP_SEPARA_NUMERO_ENDERECO_EST_PROPRIA') = 'N') THEN
	         vc_aux_erro        := 'Erro na conversão do endereço do importador(1)...';
	         vc_imp_endereco    := SubStr(cr_cons.endereco,1,40);
	         vc_aux_erro        := 'Erro na conversão do número do endereço do importador(1)...';
	         vc_imp_nrendereco  := '      ';
        ELSE
	         vc_aux_erro        := 'Erro na conversão do endereço do importador(2)...';
	         vc_imp_endereco    := SubStr(cr_cons.endereco_sem_numero,1,40);
	         vc_aux_erro        := 'Erro na conversão do número do endereço do importador(2)...';
	         vc_imp_nrendereco  := SubStr(cr_cons.endereco_numero,1,6);
        END IF;

	      vc_aux_erro        := 'Erro na conversão do complemento do importador...';
	      vc_imp_complemento := SubStr(cr_cons.complemento_end,1,21);
	      vc_aux_erro        := 'Erro na conversão do bairro do importador...';
	      vc_imp_bairro      := SubStr(cr_cons.bairro,1,25);
	      vc_aux_erro        := 'Erro na conversão da cidade do importador...';
	      vc_imp_cidade      := SubStr(cr_cons.cidade,1,25);
	      vc_aux_erro        := 'Erro na conversão da UF do importador...';
	      vc_imp_uf          := SubStr(cmx_pkg_tabelas.codigo (cr_cons.uf_id),1,02);
	      vc_aux_erro        := 'Erro na conversão do CEP do importador...';
	      vc_imp_cep         := SubStr(cr_cons.cep,1,08);

      END IF;

    END IF; -- IF (i.tp_consignatario = 1) THEN

    /* INFORMACOES EXTRAIDAS DO DOCUMENTO: InforGeraisDeclImportacao.doc
    1.9.3 Nome ou razão social
          Nome completo da razão social da pessoa jurídica. Informação gerada pelo Sistema.
          Na transmissão de dados, quando não for usado o Orientador, preencher com "brancos".
          Formato: alfanumérico  Tamanho: 60 Nome Interno: NM-CONSIGNATARIO
    */
    vc_aux_erro        := 'Erro na conversão do nome do consignatário...';
    vc_consig_nome     := null;

    vc_aux_erro        := 'Erro na conversão do CPF do importador...';
    cImpCPFImp         := SubStr(pc_cpf_repres_legal,1,11);

    vc_aux_erro        := 'Erro na conversão da modalidade de despacho...';
    vc_mde_despacho    := NVL(SubStr(i.mde_despacho,1,1),1);

    IF ( (vc_tp_declaracao in ('02','03','04')) and (i.mde_despacho NOT IN ('1','2')) ) THEN
      cmx_prc_gera_log_erros (pn_evento_id,'Modalidade de Despacho incompativel com tipo de declaração...' || Chr(10) || Chr(13) ||
                      'Corrija a modalidade e gere a estrutura novamente... '||sqlerrm, 'E');
      vb_sem_erros := false;
    END IF;

    vc_aux_erro        := 'Erro na conversão da URFE...';
    vc_urfe            := SubStr(cmx_pkg_tabelas.codigo (i.urfe_id),1,7);
    vc_aux_erro        := 'Erro na conversão da URFD...';
    vc_urfd            := SubStr(cmx_pkg_tabelas.codigo (i.urfd_id),1,7);

    vc_aux_erro        := 'Erro na conversão do país de procedência...';
    vc_pais_proc       := SubStr(cmx_pkg_tabelas.codigo (i.pais_proc_id),1,3);

    -- tratamento dos campos para DI UNICA
    OPEN  cur_di_unica;
    FETCH cur_di_unica INTO vr_di_unica;
    vb_found_di_unica := cur_di_unica%FOUND;
    CLOSE cur_di_unica;

    IF NOT (vb_found_di_unica) THEN
      vc_aux_erro        := 'Erro na conversão da via de transporte...';
      vc_via_transp      := nvl(cmx_pkg_tabelas.codigo (i.via_transporte_id),'00');

      vc_aux_erro        := 'Erro na conversão do multimodal...';
      vc_multimodal      := i.multimodal;

      vc_aux_erro := 'Erro na conversão do número e nome do veículo transportador...';
      IF ( vc_via_transp = '07' ) THEN  -- Rodoviario
        vc_ident_veiculo := SubStr(i.identificacao_veiculo,1,15);
        vc_nome_veiculo  := null;
      ELSE
        vc_ident_veiculo := null;
        vc_nome_veiculo  := SubStr(i.identificacao_veiculo,1,30);
      END IF;

      -------------------------------------------------------
      -- Nome e CGC do Transportador
      -------------------------------------------------------
      vc_aux_erro := 'Erro na consulta do transportador...';
      OPEN  cur_entidade (i.transportador_id, i.transportador_site_id);
      FETCH cur_entidade INTO cr_tran;
      CLOSE cur_entidade;

      vc_aux_erro           := 'Erro na conversão do nome do transportador...';
      vc_transp_nome        := SubStr(cr_tran.nome,1,60);
      vc_aux_erro           := 'Erro na conversão da bandeira do veículo transportador...';
      vc_bandeira           := SubStr(cmx_pkg_tabelas.codigo (i.bandeira_id),1,3);

      -------------------------------------------------------
      -- Nome e CGC do Agente de Carga
      -------------------------------------------------------
      vc_aux_erro := 'Erro na consulta do agente de carga...';
      OPEN  cur_entidade (i.agente_carga_id, i.agente_carga_site_id);
      FETCH cur_entidade INTO cr_agcg;
      CLOSE cur_entidade;

      vc_agente_carga_cnpj := NULL;

      -- Se a via for Postal, o código do tipo de agente de carga nao deve ser preenchido.
      IF (vc_via_transp = '05') Then
        vc_tp_agente_carga := '0';
      ELSE
        IF (  rtrim (ltrim (substr (cr_agcg.cnpj, 1, 14))) IS NOT NULL
          AND cr_agcg.cod_pais  = '105'  /* Agentes de carga do Brasil */ ) THEN
          vc_tp_agente_carga := '1';
          vc_agente_carga_cnpj := SubStr(cr_agcg.cnpj,1,14);
        ELSE
          vc_tp_agente_carga := '0';
        END IF;
      END IF;

      vc_aux_erro        := 'Erro na conversão da presença de carga...';
      vc_conhec_transp   := SubStr(i.presenca_carga,1,40);

      IF (vc_via_transp IN ('08', '09', '10')) THEN -- TUBO CONDUTOR / MEIOS PROPRIOS / ENTRADA FICTA
       	vc_aux_erro          := 'Erro na conversão do nr. doc. transporte filhote...';
        vc_tp_conhecimento   := '00';

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte filhote...';
        vc_house             := rpad (' ', 18, ' ');

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte master...';
        vc_master            := rpad (' ', 18, ' ');
      ELSE
        vc_aux_erro          := 'Erro na conversão do tipo do documento de transporte...';
        vc_tp_conhecimento   := SubStr(cmx_pkg_tabelas.codigo (i.tp_conhecimento_id),1,2);

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte filhote...';
        vc_house             := rpad (substr (i.house, 1, 18), 18, ' ');

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte master...';
        vc_master            := rpad (substr (i.master, 1, 18), 18, ' ');
      END IF; -- IF (vc_via_transp IN ('08', '09', '10')) THEN

      vc_aux_erro          := 'Erro na concatenação do house e master no conhecimento de transporte...';
      IF (vc_via_transp NOT IN ('01', '04', '06', '07')) OR (i.presenca_carga IS null) THEN -- maritimo (01), aereo (04), ferroviario (06) e rodoviario (07)
        vc_conhec_transp   := vc_house || vc_master;
      END IF;

      IF (vc_via_transp IN ('10')) THEN -- ENTRADA FICTA
        vc_aux_erro          := 'Erro na conversão do local de embarque...';
        vc_local_embarque    := rpad (' ', 50, ' ');

        vc_aux_erro          := 'Erro na conversão da data de embarque...';
        vc_data_embarque     := '00000000';
      ELSE
        vc_aux_erro          := 'Erro na conversão do local de embarque...';
        vc_local_embarque    := SubStr(cmx_pkg_tabelas.descricao (i.local_embarque_id),1,50);

        vc_aux_erro          := 'Erro na conversão da data de embarque...';
        vc_data_embarque     := To_Char(i.data_embarque, 'yyyymmdd');
      END IF; -- IF (vc_via_transp IN ('10')) THEN

      IF ( vc_tp_declaracao IN ('13','14','17','18','28') ) THEN
        vc_data_embarque     := null;
      END IF;

      vc_aux_erro          := 'Erro na conversão do peso bruto...';
      IF to_number(i.tp_declaracao_cod) < 13 THEN
        vc_peso_bruto      := LPad( LTrim(NVL(To_Char(i.peso_bruto    ,'9999999990.00000'),'0')), 16,'0' );
      ELSE
        vc_peso_bruto      := LPad( LTrim(NVL(To_Char(i.peso_bruto_nac,'9999999990.00000'),'0')), 16,'0' );
      END IF;
      vc_peso_bruto        := SubStr(vc_peso_bruto,1,10) || SubStr(vc_peso_bruto,12,5);

      vc_aux_erro          := 'Erro na conversão do peso líquido...';
      IF to_number(i.tp_declaracao_cod) < 13 THEN
        vc_peso_liquido    := LPad( LTrim(NVL(To_Char(i.peso_liquido    ,'9999999990.00000'),'0')), 16,'0' );
      ELSE
        vc_peso_liquido    := LPad( LTrim(NVL(To_Char(i.peso_liquido_nac,'9999999990.00000'),'0')), 16,'0' );
      END IF;
      vc_peso_liquido      := SubStr(vc_peso_liquido,1,10) || SubStr(vc_peso_liquido,12,5);

      IF ( vc_tp_declaracao IN ('13','14','17','18','28') ) THEN
        vc_data_chegada      := null;
      ELSE
        vc_aux_erro          := 'Erro na conversão da data de chegada...';
        vc_data_chegada      := To_Char(i.data_chegada, 'yyyymmdd');
      END IF;

      vc_aux_erro := 'Erro na conversão do manifesto de carga...';
      IF (vc_via_transp IN ('08', '09', '10')) THEN -- TUBO CONDUTOR / MEIOS PROPRIOS / ENTRADA FICTA
        vc_tp_manifesto := '0';
      ELSE
        vc_tp_manifesto := nvl (i.tp_manifesto, '0');
      END IF;

      vc_aux_erro          := 'Erro na conversão do nr. do manifesto de carga...';
      vc_nr_manifesto      := replace(SubStr(i.nr_manifesto,1,15),'-',null);

      vc_aux_erro          := 'Erro na conversão do recinto alfandegário...';
      vc_rec_alfand        := SubStr(cmx_pkg_tabelas.codigo (i.rec_alfand_id),1,7);

      vc_aux_erro          := 'Erro na conversão do frete prepaid...';
      vc_vrt_fr_prepaid    := LPad( LTrim(NVL(To_Char(i.valor_prepaid_m,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_prepaid    := '0' || SubStr(vc_vrt_fr_prepaid,1,12) || SubStr(vc_vrt_fr_prepaid,14,2);

      vc_aux_erro          := 'Erro na conversão do frete collect...';
      vc_vrt_fr_collect    := LPad( LTrim(NVL(To_Char((NVL(i.valor_collect_m,0)),'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_collect    := '0' || SubStr(vc_vrt_fr_collect,1,12) || SubStr(vc_vrt_fr_collect,14,2);

      vc_aux_erro          := 'Erro na conversão do frete em território nacional...';
      vc_vrt_fr_tnac       := LPad( LTrim(NVL(To_Char(i.valor_terr_nacional_m,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_tnac       := '0' || SubStr(vc_vrt_fr_tnac,1,12) || SubStr(vc_vrt_fr_tnac,14,2);

      vc_aux_erro          := 'Erro na conversão da moeda do frete...';
      vc_moeda_frete       := SubStr(cmx_pkg_tabelas.auxiliar (i.moeda_frete_id,1),1,3);

      vc_aux_erro          := 'Erro na conversão do frete total...';
      vc_vrt_fr_mn         := LPad( LTrim(NVL(To_Char(i.vrt_fr_mn,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_mn         := '0' || SubStr(vc_vrt_fr_mn,1,12) || SubStr(vc_vrt_fr_mn,14,2);

      vc_aux_erro          := 'Erro na conversão do seguro...';
      vc_vrt_sg_m          := LPad( LTrim(NVL(To_Char(i.vrt_sg_m,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_sg_m          := '0' || SubStr(vc_vrt_sg_m,1,12) || SubStr(vc_vrt_sg_m,14,2);

      vc_aux_erro          := 'Erro na conversão da moeda do seguro...';
      vc_moeda_seguro      := SubStr(cmx_pkg_tabelas.auxiliar (i.moeda_seguro_id,1),1,3);

      vc_aux_erro          := 'Erro na conversão do seguro total...';
      vc_vrt_sg_mn         := LPad( LTrim(NVL(To_Char(i.vrt_sg_mn,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_sg_mn         := '0' || SubStr(vc_vrt_sg_mn,1,12) || SubStr(vc_vrt_sg_mn,14,2);
    ELSE -- IF NOT (vb_found_di_unica) THEN
      vc_aux_erro        := 'Erro na conversão da via de transporte...';
      vc_via_transp      := nvl(cmx_pkg_tabelas.codigo (vr_di_unica.via_transporte_id),'00');

      vc_aux_erro        := 'Erro na conversão do multimodal...';
      vc_multimodal      := vr_di_unica.multimodal;

      vc_aux_erro := 'Erro na conversão do número e nome do veículo transportador...';
      IF ( vc_via_transp = '07' ) THEN  -- Rodoviario
        vc_ident_veiculo := SubStr(vr_di_unica.identificacao_veiculo,1,15);
        vc_nome_veiculo  := null;
      ELSE
        vc_ident_veiculo := null;
        vc_nome_veiculo  := SubStr(vr_di_unica.identificacao_veiculo,1,30);
      END IF;

      -------------------------------------------------------
      -- Nome e CGC do Transportador
      -------------------------------------------------------
      vc_aux_erro := 'Erro na consulta do transportador...';
      OPEN  cur_entidade (vr_di_unica.transportador_id, vr_di_unica.transportador_site_id);
      FETCH cur_entidade INTO cr_tran;
      CLOSE cur_entidade;

      vc_aux_erro           := 'Erro na conversão do nome do transportador...';
      vc_transp_nome        := SubStr(cr_tran.nome,1,60);
      vc_aux_erro           := 'Erro na conversão da bandeira do veículo transportador...';
      vc_bandeira           := SubStr(cmx_pkg_tabelas.codigo (vr_di_unica.bandeira_id),1,3);

      -------------------------------------------------------
      -- Nome e CGC do Agente de Carga
      -------------------------------------------------------
      vc_aux_erro := 'Erro na consulta do agente de carga...';
      OPEN  cur_entidade (vr_di_unica.agente_carga_id, vr_di_unica.agente_carga_site_id);
      FETCH cur_entidade INTO cr_agcg;
      CLOSE cur_entidade;

      vc_agente_carga_cnpj := NULL;

      -- Se a via for Postal, o código do tipo de agente de carga nao deve ser preenchido.
      IF (vc_via_transp = '05') Then
        vc_tp_agente_carga := '0';
      ELSE
        IF (  rtrim (ltrim (substr (cr_agcg.cnpj, 1, 14))) IS NOT NULL
          AND cr_agcg.cod_pais  = '105'  /* Agentes de carga do Brasil */ ) THEN
          vc_tp_agente_carga := '1';
          vc_agente_carga_cnpj := SubStr(cr_agcg.cnpj,1,14);
        ELSE
          vc_tp_agente_carga := '0';
        END IF;
      END IF;

      vc_aux_erro        := 'Erro na conversão da presença de carga...';
      vc_conhec_transp   := SubStr(vr_di_unica.presenca_carga,1,40);

      IF (vc_via_transp IN ('08', '09', '10')) THEN -- TUBO CONDUTOR / MEIOS PROPRIOS / ENTRADA FICTA
     	  vc_aux_erro          := 'Erro na conversão do nr. doc. transporte filhote...';
        vc_tp_conhecimento   := '00';

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte filhote...';
        vc_house             := rpad (' ', 18, ' ');

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte master...';
        vc_master            := rpad (' ', 18, ' ');
      ELSE
        vc_aux_erro          := 'Erro na conversão do tipo do documento de transporte...';
        vc_tp_conhecimento   := SubStr(cmx_pkg_tabelas.codigo (vr_di_unica.tp_conhecimento_id),1,2);

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte filhote...';
        vc_house             := rpad (substr (vr_di_unica.house, 1, 18), 18, ' ');

        vc_aux_erro          := 'Erro na conversão do nr. doc. transporte master...';
        vc_master            := rpad (substr (vr_di_unica.master, 1, 18), 18, ' ');
      END IF; -- IF (vc_via_transp IN ('08', '09', '10')) THEN

      vc_aux_erro          := 'Erro na concatenação do house e master no conhecimento de transporte...';
      IF (vc_via_transp NOT IN ('01', '04', '06', '07')) OR (vr_di_unica.presenca_carga IS null) THEN -- maritimo (01), aereo (04), ferroviario (06) e rodoviario (07)
        vc_conhec_transp   := vc_house || vc_master;
      END IF;

      IF (vc_via_transp IN ('10')) THEN -- ENTRADA FICTA
        vc_aux_erro          := 'Erro na conversão do local de embarque...';
        vc_local_embarque    := rpad (' ', 50, ' ');

        vc_aux_erro          := 'Erro na conversão da data de embarque...';
        vc_data_embarque     := '00000000';
      ELSE
        vc_aux_erro          := 'Erro na conversão do local de embarque...';
        vc_local_embarque    := SubStr(cmx_pkg_tabelas.descricao (vr_di_unica.local_embarque_id),1,50);

        vc_aux_erro          := 'Erro na conversão da data de embarque...';
        vc_data_embarque     := To_Char(i.data_embarque, 'yyyymmdd');
      END IF; -- IF (vc_via_transp IN ('10')) THEN

      vc_aux_erro          := 'Erro na conversão do peso bruto...';
      IF to_number(i.tp_declaracao_cod) < 13 THEN
        vc_peso_bruto      := LPad( LTrim(NVL(To_Char(vr_di_unica.peso_bruto    ,'9999999990.00000'),'0')), 16,'0' );
      ELSE
        vc_peso_bruto      := LPad( LTrim(NVL(To_Char(i.peso_bruto_nac,'9999999990.00000'),'0')), 16,'0' );
      END IF;
      vc_peso_bruto        := SubStr(vc_peso_bruto,1,10) || SubStr(vc_peso_bruto,12,5);

      vc_aux_erro          := 'Erro na conversão do peso líquido...';
      IF to_number(i.tp_declaracao_cod) < 13 THEN
        vc_peso_liquido    := LPad( LTrim(NVL(To_Char(vr_di_unica.peso_liquido    ,'9999999990.00000'),'0')), 16,'0' );
      ELSE
        vc_peso_liquido    := LPad( LTrim(NVL(To_Char(i.peso_liquido_nac,'9999999990.00000'),'0')), 16,'0' );
      END IF;
      vc_peso_liquido      := SubStr(vc_peso_liquido,1,10) || SubStr(vc_peso_liquido,12,5);

      IF ( vc_tp_declaracao IN ('13','14','17','18','28') ) THEN
        vc_data_chegada      := null;
      ELSE
        vc_aux_erro          := 'Erro na conversão da data de chegada...';
        vc_data_chegada      := To_Char(i.data_chegada, 'yyyymmdd');
      END IF;

      vc_aux_erro := 'Erro na conversão do manifesto de carga...';
      IF (vc_via_transp IN ('08', '09', '10')) THEN -- TUBO CONDUTOR / MEIOS PROPRIOS / ENTRADA FICTA
        vc_tp_manifesto := '0';
      ELSE
        vc_tp_manifesto := nvl (i.tp_manifesto, '0');
      END IF;

      vc_aux_erro          := 'Erro na conversão do nr. do manifesto de carga...';
      vc_nr_manifesto      := replace(SubStr(i.nr_manifesto,1,15),'-',null);

      vc_aux_erro          := 'Erro na conversão do recinto alfandegário...';
      vc_rec_alfand        := SubStr(cmx_pkg_tabelas.codigo (i.rec_alfand_id),1,7);

      vc_aux_erro          := 'Erro na conversão do frete prepaid...';
      vc_vrt_fr_prepaid    := LPad( LTrim(NVL(To_Char(i.valor_prepaid_m,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_prepaid    := '0' || SubStr(vc_vrt_fr_prepaid,1,12) || SubStr(vc_vrt_fr_prepaid,14,2);

      vc_aux_erro          := 'Erro na conversão do frete collect...';
      vc_vrt_fr_collect    := LPad( LTrim(NVL(To_Char((NVL(i.valor_collect_m,0)),'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_collect    := '0' || SubStr(vc_vrt_fr_collect,1,12) || SubStr(vc_vrt_fr_collect,14,2);

      vc_aux_erro          := 'Erro na conversão do frete em território nacional...';
      vc_vrt_fr_tnac       := LPad( LTrim(NVL(To_Char(i.valor_terr_nacional_m,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_tnac       := '0' || SubStr(vc_vrt_fr_tnac,1,12) || SubStr(vc_vrt_fr_tnac,14,2);

      vc_aux_erro          := 'Erro na conversão da moeda do frete...';
      vc_moeda_frete       := SubStr(cmx_pkg_tabelas.auxiliar (vr_di_unica.moeda_frete_id,1),1,3);

      vc_aux_erro          := 'Erro na conversão do frete total...';
      vc_vrt_fr_mn         := LPad( LTrim(NVL(To_Char(vr_di_unica.vrt_fr_mn,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_fr_mn         := '0' || SubStr(vc_vrt_fr_mn,1,12) || SubStr(vc_vrt_fr_mn,14,2);

      vc_aux_erro          := 'Erro na conversão do seguro...';
      vc_vrt_sg_m          := LPad( LTrim(NVL(To_Char(vr_di_unica.vrt_sg_m,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_sg_m          := '0' || SubStr(vc_vrt_sg_m,1,12) || SubStr(vc_vrt_sg_m,14,2);

      vc_aux_erro          := 'Erro na conversão da moeda do seguro...';
      vc_moeda_seguro      := SubStr(cmx_pkg_tabelas.auxiliar (vr_di_unica.moeda_seguro_id,1),1,3);

      vc_aux_erro          := 'Erro na conversão do seguro total...';
      vc_vrt_sg_mn         := LPad( LTrim(NVL(To_Char(vr_di_unica.vrt_sg_mn,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_sg_mn         := '0' || SubStr(vc_vrt_sg_mn,1,12) || SubStr(vc_vrt_sg_mn,14,2);
    END IF; -- IF NOT (vb_found_di_unica) THEN

    IF (vc_tp_declaracao IN ('16', '17')) THEN
      vc_moeda_frete     := null;
      vc_vrt_fr_prepaid  := '000000000000000';
      vc_vrt_fr_collect  := '000000000000000';
      vc_vrt_fr_tnac     := '000000000000000';
      vc_moeda_seguro    := null;
      vc_vrt_sg_m        := '000000000000000';
      vc_vrt_sg_mn       := '000000000000000';
    END IF;

    vc_aux_erro        := 'Erro na conversão do valor da mercadoria no local de embarque (VMLE)...';
    vc_vrt_vmle_mn     := LPad( LTrim(To_Char(NVL(i.vmle_mn,0),'999999999990.00')), 15,'0' );
    vc_vrt_vmle_mn     := '0' || SubStr(vc_vrt_vmle_mn,1,12) || SubStr(vc_vrt_vmle_mn,14,2);

    vc_aux_erro        := 'Erro na conversão do tipo de utilização do doc.transporte...';
    vc_util_conhec     := NVL( i.util_conhec, '0' );
    vc_aux_erro        := 'Erro na conversão do setor alfandegário...';
    vc_setor_armazem   := SubStr(cmx_pkg_tabelas.auxiliar (i.setor_armazem_id,1),1,3);

    vc_aux_erro := 'Erro no contador dos tributos...';
    SELECT count(*) into vn_nr_tributos
      FROM imp_dcl_darf
     WHERE declaracao_id = pn_declaracao_id;

    vc_aux_erro := 'Erro na conversão da conta bancário p/ débito dos tributos...';
    IF ( NVL(vn_nr_tributos,0) > 0 ) THEN
      vb_existe_proc_j_d := FALSE;
      FOR proc IN cur_dcl_processo LOOP
        IF (proc.tp_processo in ('3','4')) THEN
          vb_existe_proc_j_d := TRUE;
        END IF;
      END LOOP;

      IF (vb_existe_proc_j_d) THEN   -- processo judicial p/ pgto DARF
        vc_tpcta_deb_aut := '2';
        vc_cta_deb_aut   := null;
      ELSE
        vc_tpcta_deb_aut := '1';
        OPEN  cur_conta_deb_aut (i.conta_id);
        FETCH cur_conta_deb_aut INTO vc_cta_deb_aut;
        CLOSE cur_conta_deb_aut;
        vc_cta_deb_aut := LPad( NVL(vc_cta_deb_aut,'0'), 19,'0' );
      END IF;
    ELSE
      vc_tpcta_deb_aut := '3';
      vc_cta_deb_aut := null;

      --
      -- Quando Banco/Agencia e N. conta para debito automatico nao informado, significa
      -- que o embarque e de drawback, portanto nao ha o recolhimento de tributos.
      -- Para que o Siscomex registre a DI necessita enviar o numero da conta com espacos
      -- inves de zeros e mudar o tipo de pagamento de tributo ( vc_tpcta_deb_aut ) para 1.
      --
      IF (i.conta_id IS null) THEN
        vc_tpcta_deb_aut := '1';
        vc_cta_deb_aut   := null;
      END IF;
    END IF;

    IF ( vc_tp_declaracao IN ('13','14','15','17','18','28') ) THEN
      vc_mde_despacho := '0';
      vc_data_chegada := null;
    END IF;

    vc_nr_decl_retif := Substr(replace(replace(i.retif_nr_declaracao,'-',null),'/',null),1,10);
    vc_seq_retif     := LPad(NVL(Substr(to_char(i.retif_sequencia),1,02),'0'),02,'0');
    vc_motivo_retif  := Substr(i.retif_motivo,1,02);

    vc_aux_erro := 'Erro na criação do tipo 01...';

    vc_aux_erro := null;

    imp_prc_gera_reg_10( vc_ref_declaracao
                    , vc_tp_declaracao -- i.tp_declaracao_id
                    , i.data_taxa_conversao
                    , pn_evento_id
                    , vc_aux_erro
                    , vb_sem_erros
                    , i.retif_nr_declaracao
                    , pn_declaracao_id
                    , pn_empresa_id
                    , xml_adicao
                    );
    --<armazem>
    OPEN cur_dcl_armazem;
    FETCH cur_dcl_armazem INTO vc_armazem;
    CLOSE cur_dcl_armazem;


    --<documentoInstrucaoDespacho>
    vn_contador_did := 0;
    vx_docInstDesp := NULL;
    FOR dc IN cur_dcl_dcto_instr LOOP
      vc_nr_documento := null;

      IF ( vn_contador_did >= 30 ) THEN
        cmx_prc_gera_log_erros (pn_evento_id, 'Doc.Instrução Despacho limitado a 30 linhas.' ||
                        ' Certifique-se de que o documento ' || dc.nr_documento ||
                        ' está informado nas informações complementares...'||sqlerrm, 'A');
      ELSE
        vc_aux_erro := 'Erro na atribuição do no. do doc. instr. despacho (registro 03)...';
        vc_nr_documento := dc.nr_documento;

        vc_aux_erro := 'Erro na criação do tipo 03...';
        SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( vx_docInstDesp
                         , XMLElement ("documentoInstrucaoDespacho"
                                      , XMLForest (RPad( SubStr(dc.tp_documento,1,2), 02 ) AS "codigoTipoDocumentoInstrucaoDespacho"
                                      , RPad( vc_nr_documento, 25 ) AS "numeroDocumentoInstrucaoDespacho")))--.EXTRACT('*')
         INTO vx_docInstDesp
         FROM dual;

      END IF;

      vn_contador_did := vn_contador_did + 1;
    END LOOP;

    /*IF vx_docInstDesp IS NULL THEN

      SELECT XMLType('<documentoInstrucaoDespacho>'||
                        '<codigoTipoDocumentoInstrucaoDespacho />'||
                        '<numeroDocumentoInstrucaoDespacho />'||
                     '</documentoInstrucaoDespacho>').EXTRACT('*')
        INTO vx_docInstDesp
        FROM dual;
    END IF;*/

    --<embalagem>
    vx_embalagem := NULL;
    FOR vol IN cur_volumes_dcl LOOP

      vc_aux_erro     := 'Erro na conversão do tipo de embalagem...';
      vc_tp_embalagem := LPad( NVL(cmx_pkg_tabelas.codigo (vol.tp_embalagem_id), '0'),  02,'0' );
      vc_aux_erro     := 'Erro na conversão da quantidade de embalagem...';
      vc_qt_embalagem := LPad( NVL(To_Char(vol.qtde), '0'),  05,'0' );

      vc_aux_erro    := 'Erro na criação do tipo 04...';

      SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( vx_embalagem
                         , XMLElement ("embalagem"
                                      , XMLForest (vc_tp_embalagem AS "codigoTipoEmbalagemCarga"
                                      , vc_qt_embalagem AS "quantidadeVolumeCarga")))--.EXTRACT('*')
         INTO vx_embalagem
         FROM dual;

    END LOOP;

    /*IF vx_embalagem IS NULL THEN
      SELECT XMLType('<embalagem>'||
                          '<codigoTipoEmbalagemCarga />'||
                          '<quantidadeVolumeCarga />'||
                        '</embalagem>').EXTRACT('*')
        INTO vx_embalagem
        FROM dual;
    END IF;*/

    -----------------------------------------------------------
    -- Ocorrencias de informacoes Complementares - (08)
    -----------------------------------------------------------
    --:block1.PROCESSO := '(08) processando informações complementares...';
    --SYNCHRONIZE;

    vc_aux_erro := 'Erro na composição do texto complementar';
    vc_inf_complementar :=         'N/REF.: ' || pn_embarque_ano || '/' || pc_embarque_num
                                  || Chr(10) ||
                                  imp_fnc_converte_inf_compl (
                                      i.txt_inf_complementar       -- pc_texto
                                    , pn_declaracao_id             -- pn_declaracao_id
                                    , pn_embarque_id               -- pn_embarque_id
                                    , null                         -- pn_licenca_id
                                    , null                         -- pn_nota_fiscal
                                    , 'N'                          -- pc_traduzir_apenas_curingas
                                    , pc_remover_memo_calc         -- pc_remover_memo_calc
                                  );

    vc_inf_complementar := dbms_xmlgen.convert (vc_inf_complementar,1);

    --<informacaoMercosul>
    IF ( nvl (cmx_fnc_profile ('IMP_NOVO_LAYOUT_ESTR' ), 'N') = 'S') THEN
      -----------------------------------------------------------
      -- Ocorrencias dos certificados de origem mercosul - (09)
      -----------------------------------------------------------

      vx_infMercosul := null;

      FOR certificado IN cur_informacoes_mercosul LOOP
        vc_aux_erro := 'Erro na criação do tipo 09...';


--        SELECT MyXMLConcat ( vx_infMercosul
--                         , XMLType ('<informacaoMercosul>'||
--                                        '<numeroDEMercosul>'||rpad (certificado.nr_de_mercosul, 16)||'</numeroDEMercosul>'||
--                                        '<numeroREFinal>'||rpad (certificado.nr_re_final   , 4 )||'</numeroREFinal>'||
--                                        '<numeroREInicial>'||rpad (certificado.nr_re_inicial , 4 )||'</numeroREInicial>'||
--                                    '</informacaoMercosul>')).EXTRACT('*')
--         INTO vx_infMercosul
--         FROM dual;


        SELECT imp_pkg_gera_xml_ep.MyXMLConcat (
                  vx_infMercosul
                , XMLElement (
                     "informacaoMercosul"
                   , XMLForest (
                        rpad (certificado.nr_de_mercosul, 16) AS "numeroDEMercosul"
                      , rpad (certificado.nr_re_final   , 4 ) AS "numeroREFinal"
                      , rpad (certificado.nr_re_inicial , 4 ) AS "numeroREInicial"
                     )
                  )
               )
         INTO vx_infMercosul
         FROM dual;

      END LOOP;
    END IF;

--    IF vx_infMercosul IS NULL THEN
--      SELECT XMLType('<informacaoMercosul>'||
--                        '<numeroDEMercosul />'||
--                        '<numeroREFinal />'||
--                        '<numeroREInicial />'||
--                     '</informacaoMercosul>').EXTRACT('*')
--        INTO vx_infMercosul
--        FROM dual;
--    END IF;

    OPEN cur_dados_retificacao;
    FETCH cur_dados_retificacao INTO vc_codigo_retif
                                   , vc_retif_nr_decl
                                   , vn_retif_sequencia;
    CLOSE cur_dados_retificacao; --chl

    --<pagamento>
    vc_aux_erro := 'Erro no cursor dos tributos (DARF)...';
    FOR pg In cur_dcl_darf LOOP
      vc_cd_banco    := null;
      vc_cd_agencia  := null;
      IF nvl(pg.banco_agencia_id,i.banco_agencia_id) IS NOT null THEN
        vc_aux_erro    := 'Erro na conversão do código do banco (DARF)...';
        OPEN  cur_banco_deb_aut (nvl(pg.banco_agencia_id,i.banco_agencia_id));
        FETCH cur_banco_deb_aut INTO vc_cd_banco, vc_cd_agencia;
        CLOSE cur_banco_deb_aut;
      END IF;

      vc_seq_retif_darf := LPad( NVL(pg.retif_sequencia,'0'), 02,'0' );

      IF ((vc_seq_retif = vc_seq_retif_darf) AND (vc_seq_retif <> '00')) THEN
        vc_seq_retif_darf := '99';  --- Ramon 19/12/2005 CVRD - Tem que colocar fixo para fazer o débito em banco
        vc_trib_retif     := 'S';

        vc_cta_deb_aut := null;
        IF (NOT vb_existe_proc_j_d) THEN   -- processo judicial p/ pgto DARF
          vc_aux_erro    := 'Erro na conversão da conta bancária (DARF)...';
          OPEN  cur_conta_deb_aut (nvl(pg.conta_id,i.conta_id));
          FETCH cur_conta_deb_aut INTO vc_cta_deb_aut;
          CLOSE cur_conta_deb_aut;
        END IF;
      ELSE
        vc_trib_retif := 'N';
      END IF;

      vc_aux_erro    := 'Erro na conversão do código da conta bancária...';
      vc_cta_deb_aut := LPad( NVL(vc_cta_deb_aut    ,'0'), 19,'0' );

      vc_aux_erro    := 'Erro na conversão do código de tributo...';
      vc_cd_receita  := LPad( substr(LTrim(NVL(cmx_pkg_tabelas.codigo (pg.cd_receita_id), '0')),1,4), 4,'0' );

      vc_aux_erro    := 'Erro na conversão do valor do tributo...';
      vc_vrt_tributo := LPad( LTrim(NVL(To_Char(pg.valor_mn,'999999999990.00'),'0')), 15,'0' );
      vc_vrt_tributo := '0' || SubStr(vc_vrt_tributo,1,12) || SubStr(vc_vrt_tributo,14,2);

      IF ( (vc_tpcta_deb_aut in ('1','3')) AND (vc_trib_retif = 'S') ) THEN
        vc_dt_pgto  := '00000000';
        vc_vr_multa := '000000000';
        vc_vr_juros := '000000000';
      ELSE
        vc_aux_erro := 'Erro na conversão da data de pagamento do tributo...';
        vc_dt_pgto  := LPad( NVL(to_char(pg.dt_pgto,'yyyymmdd'),'0'), 8,'0' );

        vc_aux_erro := 'Erro na conversão do valor da multa do tributo...';
        vc_vr_multa := LPad( LTrim(NVL(To_Char(pg.vrmulta_mn,'9999990.00'),'0')), 10,'0' );
        vc_vr_multa := SubStr (vc_vr_multa, 1, 7) || SubStr (vc_vr_multa, 9, 2);

        vc_aux_erro := 'Erro na conversão do valor de juros do tributo...';
        vc_vr_juros := LPad( LTrim(NVL(To_Char(pg.vrjuros_mn,'9999990.00'),'0')), 10,'0' );
        vc_vr_juros := SubStr(vc_vr_juros, 1, 7) || SubStr (vc_vr_juros, 9, 2);
      END IF;

      vc_aux_erro := 'Erro no número da conta...';
      vc_nr_conta :=  NULL;
      IF(vc_codigo_retif IS NOT NULL) THEN

        IF(Nvl(vn_banco_temp_id,-999) = Nvl(pg.banco_agencia_id,i.banco_agencia_id) AND Nvl(vn_conta_temp_id,-999) = Nvl(pg.conta_id,i.conta_id)) THEN
          vc_nr_conta := vc_nr_conta_temp;
        END IF;

        IF(vc_nr_conta IS NULL) THEN
          IF(pg.banco_agencia_id IS NOT NULL AND pg.conta_id IS NOT NULL ) THEN

            IF(Nvl(pg.tp_conta, 'INTERNO') = 'INTERNO') THEN
              OPEN  cur_conta_int(pg.banco_agencia_id, pg.conta_id);
              FETCH cur_conta_int INTO vc_nr_conta;
              CLOSE cur_conta_int;
            ELSE
              OPEN  cur_conta_forn(pg.banco_agencia_id, pg.conta_id, i.despachante_id, i.despachante_site_id);
              FETCH cur_conta_forn INTO vc_nr_conta;
              CLOSE cur_conta_forn;
            END IF;

          END IF;

          IF(i.banco_agencia_id IS NOT NULL AND i.conta_id IS NOT NULL AND vc_nr_conta IS NULL) THEN

            IF(Nvl(i.tp_conta, 'INTERNO') = 'INTERNO') THEN
              OPEN  cur_conta_int(i.banco_agencia_id, i.conta_id);
              FETCH cur_conta_int INTO vc_nr_conta;
              CLOSE cur_conta_int;
            ELSE
              OPEN  cur_conta_forn(i.banco_agencia_id, i.conta_id, i.despachante_id, i.despachante_site_id);
              FETCH cur_conta_forn INTO vc_nr_conta;
              CLOSE cur_conta_forn;
            END IF;

          END IF;
        END IF;
      END IF;

      vc_aux_erro := 'Erro na criação do tipo 07...';

      SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( vx_pagamento
                         , XMLElement ("pagamento"
                                      , XMLForest ( vc_cd_banco AS "codigoBancoPagamentoTributo"
                                                  , vc_cd_receita AS "codigoReceitaPagamento"
                                                  --, '1' AS "codigoTipoPagamentoTributo"
                                                  , Decode(vc_codigo_retif, NULL, NULL, '1') AS "codigoTipoPagamentoTributo"
                                                  , vc_dt_pgto AS "dataPagamentoTributo"
                                                  , vc_cd_agencia AS "numeroAgenciaPagamentoTributo"
                                                  , Decode(vc_codigo_retif, NULL, NULL, vc_nr_conta) AS "numeroContaPagamentoTributo"
                                                  , Decode(vc_codigo_retif, NULL, NULL, lPad(pg.retif_sequencia, 2, 0)) AS "numeroSequencialRetificacaoTributo"
                                                  , vc_vr_juros AS "valorJurosPagamentoTributo"
                                                  , vc_vr_multa AS "valorMultaPagamentoTributo"
                                                  , vc_vrt_tributo AS "valorTributoPago")))--.EXTRACT('*')
         INTO vx_pagamento
         FROM dual;

    END LOOP;

    /*IF vx_pagamento IS NULL THEN
      SELECT XMLType( '<pagamento>'||
                        '<codigoBancoPagamentoTributo />'||
                        '<codigoReceitaPagamento />'||
                        '<dataPagamentoTributo />'||
                        '<numeroAgenciaPagamentoTributo />'||
                        '<valorJurosPagamentoTributo />'||
                        '<valorMultaPagamentoTributo />'||
                        '<valorTributoPago />'||
                      '</pagamento>').EXTRACT('*')
        INTO vx_pagamento
        FROM dual;
    END IF;*/

    --<processo>
    FOR proc in cur_dcl_processo LOOP
      vc_aux_erro := 'Erro na criação do tipo 02...';

      SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( vx_processo
                         , XMLElement ("processo"
                                      , XMLForest ( proc.tp_processo AS "codigoTipoProcesso"
                                                  , RPad( SubStr(proc.nr_processo,1,20), 20 ) AS "numeroProcesso")))--.EXTRACT('*')
         INTO vx_processo
         FROM dual;

    END LOOP;
    /*IF vx_processo IS NULL THEN
      SELECT XMLType ('<processo>'||
                        '<codigoTipoProcesso />'||
                        '<numeroProcesso />'||
                     '</processo>').EXTRACT('*')
        INTO vx_processo
        FROM dual;
    END IF;*/
    vc_inf_complementar_clob := vc_inf_complementar;

--    OPEN cur_dados_retificacao;
--    FETCH cur_dados_retificacao INTO vc_codigo_retif
--                                   , vc_retif_nr_decl
--                                   , vn_retif_sequencia;
--    CLOSE cur_dados_retificacao; --chl

    vc_aux_erro := 'Erro na criação do XML final...';

    SELECT imp_pkg_gera_xml_ep.MyXMLElement (
              'declaracao'
            , imp_pkg_gera_xml_ep.MyXMLConcat (
                 xml_adicao
               , XMLElement (
                    "armazem"
                  , XMLElement ("nomeArmazemCarga", RPad( SubStr(vc_armazem,1,10),10))
                 )
               , XMLForest ( vc_peso_bruto AS "cargaPesoBruto"
                           , vc_peso_liquido AS "cargaPesoLiquido"
                           , LPad( NVL(vc_bandeira,'0'), 03,'0' ) AS "codigoBandeiraTranspote"
                           , RPad( vc_mde_despacho, 01 ) AS "codigoModalidadeDespacho"
                           , LPad( NVL(vc_moeda_frete,'0'), 03,'0' ) AS "codigoMoedaFrete"
                           , RPad( NVL(vc_moeda_seguro,'0'), 03,'0' ) AS "codigoMoedaSeguro"
                           , Decode(vc_codigo_retif, NULL, NULL, LPad(vc_codigo_retif, 2, 0) ) AS "codigoMotivoRetificacao"
                           , Nvl(pc_rg_tipo_transmissao, '1') AS "codigoMotivoTransmissao"
                           , '2' AS "codigoOrigemDI"
                           , '105' AS "codigoPaisImportador"
                           , LPad( NVL(vc_pais_proc,'0'), 03,'0' ) AS "codigoPaisProcedenciaCarga"
                           , RPad( NVL(vc_rec_alfand ,'0'), 07,'0' ) AS "codigoRecintoAlfandegado"
                           , LPad( NVL(vc_setor_armazem ,'0'), 03,'0' ) AS "codigoSetorArmazenamento"
                           , vc_tp_agente_carga AS "codigoTipoAgenteCarga"
                           , cTpConsig AS "codigoTipoConsignatario"
                           , RPad( NVL(vc_tp_declaracao ,'0'), 02,'0' ) AS "codigoTipoDeclaracao"
                           , LPad( NVL(vc_tp_conhecimento,'0'), 02,'0' ) AS "codigoTipoDocumentoCarga"
                           , '1' AS "codigoTipoImportador"
                           , vc_tp_manifesto AS "codigoTipoManifesto"
                           , vc_tpcta_deb_aut AS "codigoTipoPagamentoTributario"
                           , LPad( NVL(vc_urfe ,'0'), 07,'0' ) AS "codigoUrfCargaEntrada"
                           , LPad( NVL(vc_urfd ,'0'), 07,'0' ) AS "codigoUrfDespacho"
                           , vc_util_conhec AS "codigoUtilizacaoDocumentoCarga"
                           , RPad( NVL(vc_via_transp ,'0'), 02 ) AS "codigoViaTransporte"
                 )
--RODRIGO               , XMLElement (
--RODRIGO                    "compensacaoCredito"
--RODRIGO                  , imp_pkg_gera_xml_ep.MyXMLConcat(
--RODRIGO                       XMLElement("codigoReceitaCredito")
--RODRIGO                       , XMLElement("numeroDocumentoGeradorCredito")
--RODRIGO                       , XMLElement("valorCompensarCredito")
--RODRIGO                     )
--RODRIGO                 )
               , XMLForest (  vc_data_chegada                           AS "dataChegadaCarga"
                            , vc_data_embarque                          AS "dataEmbarque" )
               , vx_docInstDesp
               , vx_embalagem
               , XMLForest ( RPad( vc_imp_bairro , 25 ) AS "enderecoBairroImportador"
                           , LPad( NVL(vc_imp_cep ,'0'), 08,'0' ) AS "enderecoCepImportador"
                           , RPad( vc_imp_complemento , 21 ) AS "enderecoComplementoImportador"
                           , RPad( vc_imp_endereco , 40 ) AS "enderecoLogradouroImportador"
                           , RPad( vc_imp_cidade , 25 ) AS "enderecoMunicipioImportador"
                           , RPad( vc_imp_nrendereco , 06 ) AS "enderecoNumeroImportador"
                           , RPad( vc_imp_uf , 02 )AS "enderecoUfImportador"
                           , RPad( vc_ref_declaracao, 15 ) AS "identificacaoDeclaracaoImportacao"
                           , RPad( vc_multimodal , 01 ) AS "indicadorMultimodalViaTransporte"
                           , 'N' AS "indicadorOperacaoFundap")
               , vx_infMercosul
               , XMLForest ( vc_inf_complementar_clob AS "informacoesComplementares"
                           , RPad( vc_consig_nome , 60 ) AS "nomeConsignatario"
                           , RPad( vc_imp_nome , 60 ) AS "nomeImportador"
                           , RPad( vc_local_embarque , 50 ) AS "nomeLocalEmbarque"
                           , RPad( vc_transp_nome , 60 ) AS "nomeTransportadorViaTransporte"
                           , RPad( vc_nome_veiculo , 30 ) AS "nomeVeiculoViaTransporte"
                           , RPad( vc_agente_carga_cnpj, 14 ) AS "numeroAgenteCarga"
                           , Decode(vc_retif_nr_decl, NULL, NULL, vc_retif_nr_decl) AS "numeroDeclaracaoRetificacao"
                           , RPad( vc_consig_cnpj , 14 ) AS "numeroConsignatario"
                           , RPad( vc_cta_deb_aut , 19 ) AS "numeroContaPagamentoTributario"
                           , LPad( NVL(cImpCPFImp ,'0'), 11,'0' ) AS "numeroCpfRepresentanteLegal"
                           , SubStr(RPad( vc_conhec_transp , 36 ),1,18) AS "numeroDocumentoCarga"
                           , SubStr(RPad( vc_conhec_transp , 36 ),19,18)AS "numeroDocumentoCargaMaster"
                           , LPad( NVL(vc_imp_cnpj ,'0'), 14,'0' ) AS "numeroImportador"
                           , RPad( vc_nr_manifesto , 15 ) AS "numeroManifesto"
                           , Decode(vn_retif_sequencia, NULL, NULL, lPad(vn_retif_sequencia, 2, 0)) AS "numeroSequencialRetificacao"
                           , RPad( vc_imp_fone , 15 ) AS "numeroTelefoneImportador"
                           , RPad( vc_ident_veiculo , 15 ) AS "numeroVeiculoViaTransporte")
               , vx_pagamento
               , vx_processo
               , XMLForest ( LPad( NVL(vc_nr_adicoes ,'0'), 03,'0' ) AS "totalAdicoes"
                           , vc_vrt_fr_tnac AS "valorFreteTerritorioNacionalMoedaNegociada"
                           , vc_vrt_fr_collect AS "valorTotalFreteCollect"
                           , vc_vrt_fr_mn AS "valorTotalFreteMoedaNacional"
                           , vc_vrt_fr_prepaid AS "valorTotalFretePrepaid"
                           , vc_vrt_vmle_mn AS "valorTotalMLEMoedaNacional"
                           , vc_vrt_sg_mn AS "valorTotalSeguroMoedaNacional"
                           , vc_vrt_sg_m AS "valorTotalSeguroMoedaNegociada" )))--.EXTRACT('*')
      INTO xml_di
      FROM dual;

      vn_offset := 1;
      vc_envelope := ' ';
      WHILE ( vn_offset <= dbms_lob.getlength(xml_di.getclobval()) ) LOOP

        dbms_lob.append(vc_envelope, DBMS_LOB.SUBSTR( xml_di.getclobval(), 2048, vn_offset));

        vn_offset    := vn_offset    + 2048;

      END LOOP;

   END LOOP;

   --BEGIN
     --vn_blob_id := cmx_fnc_clob_to_blob_base64(vc_envelope,pn_nome_arquivo,vn_evento_id);
     /*DELETE cmx_blob;
     INSERT INTO cmx_blob VALUES (vc_envelope);
     COMMIT;*/

     INSERT INTO cmx_xml_ep_tmp VALUES ( pn_xml_id
                                       , vc_envelope);
     COMMIT;

     /* vc_blob := cmx_fnc_clob_to_blob(vc_envelope)
      vc_nome_arquivo := pn_nome_arquivo;
      INSERT INTO cmx_tmp_blob (tmp_blob_id, imagem, nome_arquivo, tamanho_arquivo_orig)
      VALUES (cmx_tmp_blob_sq1.NEXTVAL, vc_blob, vc_nome_arquivo,Length(vc_blob));
      --INSERT INTO cmx_xml_ep_tmp VALUES (vc_envelope);
      COMMIT; */
   --END;

  EXCEPTION
    When OTHERS Then
      cmx_prc_gera_log_erros (pn_evento_id, vc_aux_erro || sqlerrm, 'E');
      vb_sem_erros := FALSE;
      --pc_PROCESSO := null;
      --SYNCHRONIZE;
END imp_prc_gera_header_di;

PROCEDURE imp_prc_gera_reg_10 ( pc_ref_declaracao          VARCHAR2
                              , pc_tp_declaracao           VARCHAR2
                              , pd_data_taxa_conversao     DATE
                              , pn_evento_id               NUMBER
                              , pc_aux_erro        IN OUT  VARCHAR2
                              , pb_sem_erro        IN OUT  BOOLEAN
                              , pc_dcl_retif               VARCHAR2
                              , pn_declaracao_id           NUMBER
                              , pn_empresa_id              NUMBER
                              , xml_adicao         IN OUT  xmltype
                            ) IS

  CURSOR cur_declaracoes_adi IS
    SELECT ida.adicao_num
         , ida.class_fiscal_id
         , ida.peso_liquido
         , ida.incoterm_id
         , ida.vrt_fob_m
         , ida.vrt_dspfob_m
         , ida.vrt_fr_m
         , ida.vrt_sg_m
         , ida.mde_pgto_id
         , ida.motivo_sem_cobertura_id
         , ida.nr_rof
         , ida.inst_financiadora_id
         , ida.cobertura_cambial
         , ida.bem_encomenda
         , ida.material_usado
         , ida.aplicacao
         , ida.vinc_imp_exp
         , il.nr_registro
         , ida.ex_ncm_id
         , ida.ato_legal_exncm_id
         , ida.orgao_emissor_exncm_id
         , ida.ano_ato_legal_exncm
         , ida.nr_ato_legal_exncm
         , ida.ex_nbm_id
         , ida.ato_legal_exnbm_id
         , ida.orgao_emissor_exnbm_id
         , ida.ano_ato_legal_exnbm
         , ida.nr_ato_legal_exnbm
         , ida.ex_ipi_id
         , ida.ato_legal_exipi_id
         , ida.orgao_emissor_exipi_id
         , ida.ano_ato_legal_exipi
         , ida.nr_ato_legal_exipi
         , ida.ex_naladi_id
         , ida.ato_legal_exnaladi_id
         , ida.orgao_emissor_exnaladi_id
         , ida.ano_ato_legal_exnaladi
         , ida.nr_ato_legal_exnaladi
         , ida.basecalc_ii
         , ida.metodo_vr_aduaneiro_id
         , ida.tp_acordo
         , ida.acordo_aladi_id
         , ida.regtrib_ii_id
         , ida.fundamento_legal_id
         , ida.aliq_ii_dev
         , ida.aliq_ii_red
         , ida.perc_red_ii
         , ida.aliq_ii_acordo
         , ida.valor_ii_dev
         , ida.valor_ii_rec
         , ida.aliq_ipi_red
         , ida.regtrib_ipi_id
         , ida.aliq_ipi_dev
         , ida.valor_ipi_dev
         , ida.valor_ipi_rec
         , ida.tipo_recipiente_id
         , ida.nc_tipi
         , ida.vr_aliq_esp_ipi
         , ida.qt_um_aliq_esp_ipi
         , ida.um_aliq_esp_ipi_id
         , ida.qt_ml_recipiente
         , ida.basecalc_antdump
         , ida.aliq_antdump
         , ida.ex_antd_id
         , ida.ato_legal_exantd_id
         , ida.orgao_emissor_exantd_id
         , ida.ano_ato_legal_exantd
         , ida.nr_ato_legal_exantd
         , ida.qt_um_aliq_esp_antdump
         , ida.um_aliq_esp_antdump_id
         , ida.vr_aliq_esp_antdump
         , ida.vr_aliq_esp_antdump_mn
         , ida.valor_antdump_aliq_especifica
         , ida.valor_antdump_ad_valorem
         , ida.ausencia_fabric
         , ida.fabric_id
         , ida.fabric_site_id
         , ida.tp_periodos
         , ida.nr_periodos
         , ida.nr_parcelas
         , decode(ida.parcelas_fixas,'S','N','S') parcelas_variaveis
         , ida.cd_txjuros
         , ida.txjuros
         , ida.vmlc_m
         , ida.repres_banco_agencia_id
         , ida.repres_id
         , ida.repres_site_id
         , ida.repres_pc_comissao
         , (ida.vmlc_m * (ida.repres_pc_comissao/100)) repres_vr_comissao
         , ida.naladi_sh_id
         , ida.naladi_ncca_id
         , ida.pais_origem_id
         , ida.motivo_adm_temp_id
         , ida.export_id
         , ida.export_site_id
         , decode(pc_tp_declaracao, '13', null, '14', null, '15', null, ida.da_urfe_id)           da_urfe_id
         , decode(pc_tp_declaracao, '14', null, '15', null, ida.da_via_transporte_id) da_via_transporte_id
         , decode(pc_tp_declaracao, '13', null, '14', null, '15', null, ida.da_pais_proc_id)      da_pais_proc_id
         , decode(pc_tp_declaracao, '14', null, '15', null, ida.da_multimodal)        da_multimodal
         , ida.local_cvenda_id
         , ida.vmlc_mn
         , nvl( id.moeda_frete_id, ida.da_moeda_frete_id  ) moeda_frete_id
         , nvl(id.moeda_seguro_id, ida.da_moeda_seguro_id ) moeda_seguro_id
         , ida.declaracao_adi_id
         , ida.qtde_um_estatistica
         , ida.vrt_fr_mn
         , ida.vrt_sg_mn
         , ida.vmle_mn
         , ida.ex_prac_id
         , ida.ato_legal_exprac_id
         , ida.orgao_emissor_exprac_id
         , ida.ano_ato_legal_exprac
         , ida.nr_ato_legal_exprac
         , ida.basecalc_ipi
         , ida.valor_antdump_dev
         , ida.moeda_id
        -- , cmx_pkg_tabelas.auxiliar(ida.moeda_id,1) moeda_id
         , decode(cmx_pkg_tabelas.codigo(ida.regtrib_ipi_id),'2','N','4','N','S') flag_ipi_n_trib
         , cmx_pkg_tabelas.codigo(ida.regtrib_ii_id) regtrib_ii
         , cmx_pkg_tabelas.codigo(ida.regtrib_ipi_id) regtrib_ipi
         , ida.regtrib_icms_id
         , ida.aliq_icms
         , ida.aliq_icms_red
         , ida.perc_red_icms
         , ida.aliq_icms_fecp
         , cmx_pkg_tabelas.codigo(ida.fundamento_legal_icms_id) fundamento_legal_icms
         , ida.valor_icms_dev
         , cmx_pkg_tabelas.auxiliar(ida.regtrib_pis_cofins_id,1) regtrib_pis_cofins
         , ida.aliq_pis
         , ida.aliq_cofins
         , ida.perc_reducao_base_pis_cofins
         , cmx_pkg_tabelas.codigo (ida.fundamento_legal_pis_cofins_id)    fundamento_legal_pis_cofins
         , cmx_pkg_tabelas.auxiliar (ida.flegal_reducao_pis_cofins_id, 1) flegal_reducao_pis_cofins
         , ida.aliq_pis_Dev
         , ida.aliq_cofins_dev
         , ida.valor_pis_dev
         , ida.valor_cofins_dev
         , ida.valor_pis
         , ida.valor_cofins
         , ida.basecalc_pis_cofins
         , ida.basecalc_pis_cofins_integral
         , ida.valor_pis_integral
         , ida.valor_cofins_integral
         , ida.aliq_pis_especifica
         , ida.aliq_cofins_especifica
         , ida.un_medida_aliq_especifica_pc
         , ida.qtde_um_aliq_especifica_pc
         , ida.aliq_pis_reduzida
         , ida.aliq_cofins_reduzida
         , ida.cert_origem_mercosul_id
         , id.tp_declaracao_id
         , Nvl((SELECT Max(ex.flag_nao_enviar_ex_estr_di)
              FROM imp_excecoes_fiscais ex
                 , imp_declaracoes_lin idl
            WHERE idl.declaracao_adi_id = ida.declaracao_adi_id
              AND ex.excecao_id = idl.excecao_ipi_id),'N')  flag_nao_enviar_ex_estr_di_ipi
         , Nvl((SELECT Max(ex.flag_nao_enviar_ex_estr_di)
              FROM imp_excecoes_fiscais ex
                 , imp_declaracoes_lin idl
            WHERE idl.declaracao_adi_id = ida.declaracao_adi_id
              AND ex.excecao_id = idl.excecao_ii_id),'N')  flag_nao_enviar_ex_estr_di_ii
      FROM imp_declaracoes_adi ida
         , imp_declaracoes     id
         , imp_licencas        il
     WHERE ida.declaracao_id = pn_declaracao_id
       AND id.declaracao_id  = ida.declaracao_id
       AND il.licenca_id(+)  = ida.licenca_id
  ORDER BY adicao_num;

  CURSOR cur_dcl_adi_pgto (pn_declaracao_adi_id NUMBER, pc_tp_pgto VARCHAR2) IS
    SELECT nvl(sum(valor_m),0)
      FROM imp_dcl_adi_pgto
     WHERE declaracao_adi_id = pn_declaracao_adi_id
       AND tp_pgto           = pc_tp_pgto;

  CURSOR cur_banco (pn_bco_agc_id NUMBER) IS
    SELECT SubStr(cd_banco_bacen,1,5)
         , SubStr(cd_agencia_bacen,1,4)
      FROM cmx_bancos_agencias
     WHERE banco_agencia_id = pn_bco_agc_id;

  --------------------------------------------------------------------------
  -- Informacoes Especificas da Adicao - (10)
  --------------------------------------------------------------------------
  vc_adicao_num            VARCHAR2(03)  := null;   vc_urfe                VARCHAR2(07)  := null;
  vc_export_nome           VARCHAR2(60)  := null;   vc_export_endereco     VARCHAR2(40)  := null;
  vc_export_nrendereco     VARCHAR2(06)  := null;   vc_export_complemento  VARCHAR2(21)  := null;
  vc_export_cidade         VARCHAR2(25)  := null;   vc_export_estado       VARCHAR2(25)  := null;
  vc_export_cdpais         VARCHAR2(03)  := null;   vc_ncm                 VARCHAR2(08)  := null;
  vc_pais_proc             VARCHAR2(03)  := null;   vc_ausencia_fabric     VARCHAR2(01)  := null;
  vc_fabric_nome           VARCHAR2(60)  := null;   vc_fabric_endereco     VARCHAR2(40)  := null;
  vc_fabric_nrendereco     VARCHAR2(06)  := null;   vc_fabric_complemento  VARCHAR2(21)  := null;
  vc_fabric_cidade         VARCHAR2(25)  := null;   vc_fabric_estado       VARCHAR2(25)  := null;
  vc_fabric_cdpais         VARCHAR2(03)  := null;   vc_nbm                 VARCHAR2(10)  := null;
  vc_naladi_ncca	   VARCHAR2(07)  := null;   vc_naladi_sh           VARCHAR2(08)  := null;
  vc_peso_liquido          VARCHAR2(20)  := null;   vc_qt_um_est           VARCHAR2(15)  := null;
  vc_aplicacao             VARCHAR2(01)  := null;   vc_moeda               VARCHAR2(03)  := null;
  vc_incoterm              VARCHAR2(03)  := null;   vc_local_cvenda        VARCHAR2(60)  := null;
  vc_vrt_cvenda_m          VARCHAR2(15)  := null;   vc_vrt_cvenda_mn       VARCHAR2(15)  := null;
  vc_vrt_fr_m              VARCHAR2(15)  := null;   vc_moeda_frete         VARCHAR2(03)  := null;
  vc_vrt_fr_mn             VARCHAR2(15)  := null;   vc_vrt_sg_m            VARCHAR2(15)  := null;
  vc_moeda_seguro          VARCHAR2(03)  := null;   vc_vrt_sg_mn           VARCHAR2(15)  := null;
  vc_metodo_vr_adu         VARCHAR2(02)  := null;   vc_vinc_imp_exp        VARCHAR2(01)  := null;
  vc_tp_acordo             VARCHAR2(01)  := null;   vc_acordo_aladi        VARCHAR2(03)  := null;
  vc_regtrib_ii            VARCHAR2(01)  := null;   vc_fundamento_legal    VARCHAR2(02)  := null;
  vc_vmle_mn               VARCHAR2(15)  := null;
  vc_perc_red_ii           VARCHAR2(05)  := null;   vc_valor_ii_dev_DCR    VARCHAR2(15)  := null;
  vc_valor_ii_rec_ZFM      VARCHAR2(15)  := null;   vc_cobertura_cambial   VARCHAR2(01)  := null;
  vc_mde_pgto              VARCHAR2(02)  := null;   vc_inst_financiadora   VARCHAR2(02)  := null;
  vc_motivo_s_cobertura    VARCHAR2(02)  := null;   vc_nr_parcelas         VARCHAR2(03)  := null;
  vc_tp_periodos           VARCHAR2(01)  := null;   vc_nr_periodos         VARCHAR2(03)  := null;
  vc_vrt_pgto_p            VARCHAR2(15)  := null;   vc_txjuros             VARCHAR2(13)  := null;
  vc_cd_txjuros            VARCHAR2(04)  := null;   vc_vrt_pgto_acima_360d VARCHAR2(15)  := null;
  vc_nr_rof                VARCHAR2(08)  := null;   vc_parcelas_variaveis  VARCHAR2(01)  := null;
  cTemJuros                VARCHAR2(01)  := null;   vc_repres_pc_comissao  VARCHAR2(06)  := null;
  vc_repres_vr_comissao    VARCHAR2(15)  := null;   vc_repres_cnpj         VARCHAR2(14)  := null;
  vc_repres_banco          VARCHAR2(05)  := null;   vc_repres_agencia      VARCHAR2(04)  := null;
  vc_repres_tipo           VARCHAR2(01)  := null;   vc_via_transp          VARCHAR2(02)  := null;
  vc_inf_complementar      VARCHAR2(250) := null;   vc_multimodal          VARCHAR2(01)  := null;
  vc_motivo_adm_temp       VARCHAR2(02)  := null;   vc_valor_ii_dev_DCR_us VARCHAR2(15)  := null;
  vc_valor_ii_dev_ZFM      VARCHAR2(15)  := null;   vc_licenca             VARCHAR2(10)  := null;
  vc_un_medida_scx         VARCHAR2(2)   := null;
  vn_vrt_pgto_p            NUMBER        := 0;
  vn_vrt_pgto_antecipado   NUMBER        := 0;
  vn_vrt_pgto_vista        NUMBER        := 0;
  vc_basecalc_ii           VARCHAR2(15)  := null;
  vc_aliq_icms_pis_cofins  VARCHAR2(05)  := null;
  vc_fund_legal_red_icms   VARCHAR2(02)  := null;
  vc_flegal_reducao_pc     VARCHAR2(02)  := null;
  vc_reg_trib_pis_cofins   VARCHAR2(01)  := null;
  vc_fund_legal_pis_cofins VARCHAR2(02)  := null;
  vn_aliq_icms             NUMBER        := null;

  CURSOR cur_representante (pn_entidade_id NUMBER, pn_entidade_site_id NUMBER) IS
    SELECT ces.nr_documento
      FROM imp_entidades        ce
         , imp_entidades_sites  ces
     WHERE ce.entidade_id       = pn_entidade_id
       AND ces.entidade_id      = ce.entidade_id
       AND ces.entidade_site_id = pn_entidade_site_id;

  CURSOR cur_entidade (pn_entidade_site_id NUMBER) IS
    SELECT ces.endereco
         , ces.cidade
         , ces.estado
         , ces.pais_id
         , ces.endereco_sem_numero
         , ces.endereco_numero
         , ces.complemento
      FROM imp_entidades_sites  ces
     WHERE ces.entidade_site_id = pn_entidade_site_id;

  CURSOR cur_fabricante (pn_fabric_site_id NUMBER) IS
    SELECT ces.endereco
         , ces.cidade
         , ces.estado
         , ces.pais_id
         , ces.numero
         , ces.complemento
      FROM imp_fabricantes_sites  ces
     WHERE ces.fabric_site_id = pn_fabric_site_id;

  CURSOR cur_tab_ncm (pn_ncm_id  NUMBER) IS
    SELECT codigo
         , cmx_pkg_tabelas.codigo (un_medida_id)
         , aliq_ii
         , aliq_ipi
         , aliq_pis
         , aliq_cofins
      FROM cmx_tab_ncm
     WHERE ncm_id = pn_ncm_id;

	CURSOR cur_flag_incide_icms_pc IS
	  SELECT incidir_perc_red_aliq_icms_pc
	    FROM imp_empresas_param
	   WHERE empresa_id = pn_empresa_id;

  CURSOR cur_cert_origem (pn_cert_origem_mercosul_id NUMBER) IS
    SELECT to_char (tipo_certificado)
      FROM imp_cert_origem_mercosul
     WHERE cert_origem_mercosul_id = pn_cert_origem_mercosul_id;

   vc_incide_icms_pc          imp_empresas_param.incidir_perc_red_aliq_icms_pc%TYPE;
   cr_exp                     cur_entidade%ROWTYPE;
   cr_fab                     cur_fabricante%ROWTYPE;
   cr_rep                     cur_representante%ROWTYPE;

   vc_string                  VARCHAR2(2000) := null;
   vn_taxa_us_mn              NUMBER         := 0;
   vn_aliq_ii_tec             NUMBER         := 0;
   vn_aliq_ipi_tec            NUMBER         := 0;
   vn_aliq_pis_tec            NUMBER         := 0;
   vn_aliq_cofins_tec         NUMBER         := 0;
   vn_valor_ii_tec            NUMBER         := 0;
   vn_valor_ipi_tec           NUMBER         := 0;
   vn_valor_pis_integral      NUMBER         := 0;
   vn_valor_cofins_integral   NUMBER         := 0;
   vn_valor_antdump_dev       NUMBER         := 0;
   vn_dummy                   NUMBER         := null;
   vc_tipo_certificado        VARCHAR2(1)    := null;
   vc_novo_layout             VARCHAR2(10)   := null;

   vx_acrescimo               XMLType;
   vx_deducao                 XMLType;
   vx_destaque                XMLType;
   vx_documento               XMLType;
   vx_docMercosul             XMLType;
   vx_mercadoria              XMLType;
   vx_tarifa                  XMLType;
   vx_valAduaneira            XMLType;
   vx_tributo                 XMLType;

BEGIN
  pc_aux_erro := 'Registro 10: erro na consulta das adições...';
  FOR i IN cur_declaracoes_adi LOOP

    vc_repres_banco       := null;    vc_repres_agencia     := null;
    vc_repres_pc_comissao := null;    vc_repres_vr_comissao := null;
    vc_export_nome        := null;    vc_export_endereco    := null;
    vc_export_nrendereco  := null;    vc_export_complemento := null;
    vc_export_cidade      := null;    vc_export_estado      := null;
    vc_export_cdpais      := null;    vx_tarifa             := null;

    ---------------------------------------------------------
    -- Informacoes Especificas da Adicao - (10)
    ---------------------------------------------------------
    pc_aux_erro      := 'Registro 10: erro na conversão do nr. da adição... (ad. ' || vc_adicao_num || ')';
    vc_adicao_num    := LPad( NVL(To_Char(i.adicao_num),'0'), 03,'0' );

    pc_aux_erro := 'Registro 10: erro na consulta do exportador... (ad. ' || vc_adicao_num || ')';
    OPEN  cur_entidade (i.export_site_id);
    FETCH cur_entidade INTO cr_exp;
    CLOSE cur_entidade;

    pc_aux_erro           := 'Registro 10: erro na conversão da urfe... (ad. ' || vc_adicao_num || ')';
    vc_urfe               := SubStr(cmx_pkg_tabelas.codigo (i.da_urfe_id),1,7);

    pc_aux_erro           := 'Registro 10: erro na conversão da via de transporte... (ad. ' || vc_adicao_num || ')';
    vc_via_transp         := SubStr(cmx_pkg_tabelas.codigo (i.da_via_transporte_id),1,2);
    pc_aux_erro           := 'Registro 10: erro na conversão do flag de multimodal... (ad. ' || vc_adicao_num || ')';
    vc_multimodal         := nvl (i.da_multimodal, 'N');
    pc_aux_erro           := 'Registro 10: erro na conversão da país de procedência... (ad. ' || vc_adicao_num || ')';
    vc_pais_proc          := SubStr(cmx_pkg_tabelas.codigo (i.da_pais_proc_id),1,3);

    pc_aux_erro           := 'Registro 10: erro na conversão do nome do exportador... (ad. ' || vc_adicao_num || ')';
    vc_export_nome        := SubStr(imp_pkg_entidades.entidade_nome (i.export_id)    ,1,60);

    IF (cmx_fnc_profile ('IMP_SEPARA_NUMERO_ENDERECO_EST_PROPRIA') = 'N') THEN
      pc_aux_erro           := 'Registro 10: erro na conversão do endereço do exportador(1)... (ad. ' || vc_adicao_num || ')';
      vc_export_endereco    := SubStr(cr_exp.endereco,1,40);
      pc_aux_erro           := 'Registro 10: erro na conversão do nr. do endereço do exportador(1)... (ad. ' || vc_adicao_num || ')';
      vc_export_nrendereco  := null;
    ELSE
      pc_aux_erro           := 'Registro 10: erro na conversão do endereço do exportador(2)... (ad. ' || vc_adicao_num || ')';
      vc_export_endereco    := SubStr(cr_exp.endereco_sem_numero,1,40);
      pc_aux_erro           := 'Registro 10: erro na conversão do nr. do endereço do exportador(2)... (ad. ' || vc_adicao_num || ')';
      vc_export_nrendereco  := SubStr(cr_exp.endereco_numero,1,6);
    END IF;

    pc_aux_erro           := 'Registro 10: erro na conversão do complemento do endereço do exportador... (ad. ' || vc_adicao_num || ')';
    vc_export_complemento := SubStr(cr_exp.complemento,1,21);
    pc_aux_erro           := 'Registro 10: erro na conversão da cidade do exportador... (ad. ' || vc_adicao_num || ')';
    vc_export_cidade      := SubStr(cr_exp.cidade,1,25);
    pc_aux_erro           := 'Registro 10: erro na conversão do estado do exportador... (ad. ' || vc_adicao_num || ')';
    vc_export_estado      := SubStr(cr_exp.estado,1,25);
    pc_aux_erro           := 'Registro 10: erro na conversão do país do exportador... (ad. ' || vc_adicao_num || ')';
    vc_export_cdpais      := SubStr(cmx_pkg_tabelas.codigo (cr_exp.pais_id),1,03);

    pc_aux_erro := 'Registro 10: erro na consulta da un.medida do siscomex... (ad. ' || vc_adicao_num || ')';
    OPEN  cur_tab_ncm (i.class_fiscal_id);
    FETCH cur_tab_ncm INTO vc_ncm, vc_un_medida_scx, vn_aliq_ii_tec, vn_aliq_ipi_tec, vn_aliq_pis_tec, vn_aliq_cofins_tec;
    CLOSE cur_tab_ncm;

    pc_aux_erro           := 'Registro 10: erro na conversão do ncm... (ad. ' || vc_adicao_num || ')';
    vc_ncm	              := SubStr(vc_ncm,1,8);

    IF ( i.ausencia_fabric = 1 ) THEN

      vc_fabric_nome        := vc_export_nome;
      vc_fabric_endereco    := vc_export_endereco;
      vc_fabric_nrendereco  := vc_export_nrendereco;
      vc_fabric_complemento := vc_export_complemento;
      vc_fabric_cidade      := vc_export_cidade;
      vc_fabric_estado      := vc_export_estado;
      vc_fabric_cdpais      := vc_export_cdpais;

    ELSIF ( i.ausencia_fabric = 2 ) THEN

      pc_aux_erro := 'Registro 10: erro na consulta de fabricante (fabricante não é o exportador)... (ad. ' || vc_adicao_num || ')';
      OPEN  cur_fabricante (i.fabric_site_id);
      FETCH cur_fabricante INTO cr_fab;
      CLOSE cur_fabricante;

      pc_aux_erro           := 'Registro 10: erro na conversão do nome do fabricante... (ad. ' || vc_adicao_num || ')';
      vc_fabric_nome        := SubStr(imp_pkg_fabricantes.fabric_nome (i.fabric_id) ,1,60);
      pc_aux_erro           := 'Registro 10: erro na conversão do endereço do fabricante... (ad. ' || vc_adicao_num || ')';
      vc_fabric_endereco    := SubStr(cr_fab.endereco,1,40);

      IF (cmx_fnc_profile ('IMP_SEPARA_NUMERO_ENDERECO_EST_PROPRIA') = 'N') THEN
        pc_aux_erro           := 'Registro 10: erro na conversão do nr. do endereço do fabricante(1)... (ad. ' || vc_adicao_num || ')';
        vc_fabric_nrendereco  := null;
      ELSE
        pc_aux_erro           := 'Registro 10: erro na conversão do nr. do endereço do fabricante(2)... (ad. ' || vc_adicao_num || ')';
        vc_fabric_nrendereco  := SubStr(cr_fab.numero,1,6);
      END IF;

      pc_aux_erro           := 'Registro 10: erro na conversão do complemento do endereço do fabricante... (ad. ' || vc_adicao_num || ')';
      vc_fabric_complemento := SubStr(cr_fab.complemento,1,21);
      pc_aux_erro           := 'Registro 10: erro na conversão da cidade do fabricante... (ad. ' || vc_adicao_num || ')';
      vc_fabric_cidade      := SubStr(cr_fab.cidade  ,1,25);
      pc_aux_erro           := 'Registro 10: erro na conversão do estado do fabricante... (ad. ' || vc_adicao_num || ')';
      vc_fabric_estado      := SubStr(cr_fab.estado  ,1,25);
      pc_aux_erro           := 'Registro 10: erro na conversão do país do fabricante... (ad. ' || vc_adicao_num || ')';
      vc_fabric_cdpais      := SubStr(cmx_pkg_tabelas.codigo (cr_fab.pais_id),1,03);

    ELSE -- anuencia = 3

      vc_fabric_nome        := null;
      vc_fabric_endereco    := null;
      vc_fabric_nrendereco  := null;
      vc_fabric_complemento := null;
      vc_fabric_cidade      := null;
      vc_fabric_estado      := null;
      pc_aux_erro           := 'Registro 10: erro na conversão do país de origem do fabricante (fabricante desconhecido)... (ad. ' || vc_adicao_num || ')';
      vc_fabric_cdpais      := cmx_pkg_tabelas.codigo (i.pais_origem_id);

    END IF;

    pc_aux_erro         := 'Registro 10: erro na conversão da anuência do fabricante... (ad. ' || vc_adicao_num || ')';
    vc_ausencia_fabric  := NVL(i.ausencia_fabric,'0');

    pc_aux_erro         := 'Registro 10: erro na conversão do NBM... (ad. ' || vc_adicao_num || ')';
    vc_nbm	            := vc_ncm;
    pc_aux_erro         := 'Registro 10: erro na conversão do Naladi NCCA... (ad. ' || vc_adicao_num || ')';
    vc_naladi_ncca	    := SubStr(cmx_pkg_tabelas.codigo (i.naladi_ncca_id),1,7);
    pc_aux_erro         := 'Registro 10: erro na conversão do Naladi SH... (ad. ' || vc_adicao_num || ')';
    vc_naladi_sh	      := SubStr(cmx_pkg_tabelas.codigo (i.naladi_sh_id),1,8);

    pc_aux_erro         := 'Registro 10: erro na conversão do peso líquido... (ad. ' || vc_adicao_num || ')';
    vc_peso_liquido     := ltrim(rtrim(To_Char(NVL(i.peso_liquido,0),'0000000000.00000')));
    vc_peso_liquido     := SubStr(vc_peso_liquido,1,10) || SubStr(vc_peso_liquido,12,5);

    pc_aux_erro         := 'Registro 10: erro na conversão da qtde.un.medida estatística... (ad. ' || vc_adicao_num || ')';
    vc_qt_um_est        := RTRIM(LTRIM(To_Char(i.qtde_um_estatistica,'000000000D00000')));
    vc_qt_um_est        := substr(vc_qt_um_est,1,9) || substr(vc_qt_um_est,11,5);

    pc_aux_erro := 'Registro 10: erro na conversão do tipo de aplicação da mercadoria... (ad. ' || vc_adicao_num || ')';
    IF ( nvl(pc_tp_declaracao,'x') NOT IN ('02','04','05','06','09','10','03') ) THEN
      vc_aplicacao := NVL(i.aplicacao,'1');
    ELSE
      vc_aplicacao := '0';
    END IF;

    pc_aux_erro := 'Registro 10: erro na conversão da moeda da adição... (ad. ' || vc_adicao_num || ')';
    vc_moeda    := SubStr(cmx_pkg_tabelas.auxiliar (i.moeda_id,1),1,3);

    pc_aux_erro := 'Registro 10: erro na conversão do incoterm... (ad. ' || vc_adicao_num || ')';
    IF ( NVL(cmx_pkg_tabelas.codigo (i.metodo_vr_aduaneiro_id),'01') <> '06' ) THEN
      vc_incoterm := SubStr(cmx_pkg_tabelas.codigo (i.incoterm_id),1,3);
    ELSE
      vc_incoterm := null;
    END IF;

    pc_aux_erro      := 'Registro 10: erro no local da condição de venda... (ad. ' || vc_adicao_num || ')';
    vc_local_cvenda  := SubStr(cmx_pkg_tabelas.descricao (i.local_cvenda_id),1,60);

    pc_aux_erro      := 'Registro 10: erro na conversão do valor na condição de venda... (ad. ' || vc_adicao_num || ')';
    vc_vrt_cvenda_m  := LPad( LTrim(NVL(To_Char(i.vmlc_m,'999999999990.00'),'0')), 15,'0' );
    vc_vrt_cvenda_m  := '0' || SubStr(vc_vrt_cvenda_m,1,12) || SubStr(vc_vrt_cvenda_m,14,2);

    pc_aux_erro      := 'Registro 10: erro na conversão do valor na condição de venda em real... (ad. ' || vc_adicao_num || ')';
    vc_vrt_cvenda_mn := LPad( LTrim(NVL(To_Char(i.vmlc_mn,'999999999999.99'),'0')), 15,'0' );
    vc_vrt_cvenda_mn := '0' || SubStr(vc_vrt_cvenda_mn,1,12) || SubStr(vc_vrt_cvenda_mn,14,2);

    pc_aux_erro        := 'Registro 10: erro na conversão do frete total... (ad. ' || vc_adicao_num || ')';
    vc_vrt_fr_m        := LPad( LTrim(NVL(To_Char(i.vrt_fr_m,'999999999999.99'),'0')), 15,'0' );
    vc_vrt_fr_m        := '0' || SubStr(vc_vrt_fr_m,1,12) || SubStr(vc_vrt_fr_m,14,2);

    pc_aux_erro        := 'Registro 10: erro na conversão do frete em real... (ad. ' || vc_adicao_num || ')';
    vc_vrt_fr_mn       := LPad( LTrim(NVL(To_Char(i.vrt_fr_mn,'999999999999.99'),'0')), 15,'0' );
    vc_vrt_fr_mn       := '0' || SubStr(vc_vrt_fr_mn,1,12) || SubStr(vc_vrt_fr_mn,14,2);



    pc_aux_erro := 'Registro 10: erro na conversão da moeda do frete... (ad. ' || vc_adicao_num || ')';
    IF (vc_vrt_fr_m = '000000000000000' OR vc_vrt_fr_mn = '000000000000000') THEN --IF ( nvl(i.vrt_fr_m,0) = 0 ) THEN
      vc_moeda_frete := null;
      vc_vrt_fr_m    := '000000000000000';
      vc_vrt_fr_mn   := '000000000000000';
    ELSE
      -- vc_moeda_frete   := SubStr(cmx_pkg_tabelas.auxiliar (i.moeda_frete_id, 1),1,3);
      -- alteração desenvolvida por Cintia B. solicitada pelo Igor (e-mail do dia 21/08/2009)
      IF (to_number (pc_tp_declaracao) >= 13) THEN
        vc_moeda_frete   := SubStr(cmx_pkg_tabelas.auxiliar (i.moeda_frete_id, 1),1,3);
      ELSE
        vc_moeda_frete := null;
      END IF;
    END IF;




    pc_aux_erro        := 'Registro 10: erro na conversão do seguro total... (ad. ' || vc_adicao_num || ')';
    vc_vrt_sg_m        := LPad( LTrim(NVL(To_Char(i.vrt_sg_m,'999999999999.99'),'0')), 15,'0' );
    vc_vrt_sg_m        := '0' || SubStr(vc_vrt_sg_m,1,12) || SubStr(vc_vrt_sg_m,14,2);

    pc_aux_erro        := 'Registro 10: erro na conversão do seguro em real... (ad. ' || vc_adicao_num || ')';
    vc_vrt_sg_mn       := LPad( LTrim(NVL(To_Char(i.vrt_sg_mn,'999999999999.99'),'0')), 15,'0' );
    vc_vrt_sg_mn       := '0' || SubStr(vc_vrt_sg_mn,1,12) || SubStr(vc_vrt_sg_mn,14,2);

    pc_aux_erro := 'Registro 10: erro na conversão da moeda do seguro... (ad. ' || vc_adicao_num || ')';
    IF (vc_vrt_sg_m = '000000000000000' OR vc_vrt_sg_mn = '000000000000000') THEN --IF ( nvl(i.vrt_sg_m,0) = 0 ) THEN
      vc_moeda_seguro := null;
      vc_vrt_sg_m     := '000000000000000';
      vc_vrt_sg_mn    := '000000000000000';
    ELSE
      IF (to_number (pc_tp_declaracao) >= 13) THEN
        vc_moeda_seguro := SubStr(cmx_pkg_tabelas.auxiliar (i.moeda_seguro_id, 1),1,3);
      ELSE
        vc_moeda_seguro := null;
      END IF;
    END IF;

    pc_aux_erro         := 'Registro 10: erro na conversão do método de valoração aduaneiro... (ad. ' || vc_adicao_num || ')';
    vc_metodo_vr_adu    := SubStr(cmx_pkg_tabelas.codigo (i.metodo_vr_aduaneiro_id),1,2);
    pc_aux_erro         := 'Registro 10: erro na conversão da vinculação entre importador e exportador... (ad. ' || vc_adicao_num || ')';
    vc_vinc_imp_exp     := NVL(i.vinc_imp_exp    , '0');
    pc_aux_erro         := 'Registro 10: erro na conversão do acordo tarifário... (ad. ' || vc_adicao_num || ')';
    vc_tp_acordo        := NVL(To_Char(i.tp_acordo), '0');
    pc_aux_erro         := 'Registro 10: erro na conversão do acordo aladi... (ad. ' || vc_adicao_num || ')';
    vc_acordo_aladi     := SubStr(cmx_pkg_tabelas.codigo (i.acordo_aladi_id),1,3);
    pc_aux_erro         := 'Registro 10: erro na conversão do regime tributação do I.I... (ad. ' || vc_adicao_num || ')';
    vc_regtrib_ii       := SubStr(NVL(cmx_pkg_tabelas.codigo (i.regtrib_ii_id),'0'),1,1);
    pc_aux_erro         := 'Registro 10: erro na conversão do fundamento legal... (ad. ' || vc_adicao_num || ')';
    vc_fundamento_legal := SubStr(cmx_pkg_tabelas.codigo (i.fundamento_legal_id),1,2);

    pc_aux_erro         := 'Registro 10: erro na conversão do vmle em reais... (ad. ' || vc_adicao_num || ')';
    vc_vmle_mn          := LPad( LTrim(NVL(To_Char(i.vmle_mn,'999999999999.99'),'0')), 15,'0' );
    vc_vmle_mn          := '0' || SubStr(vc_vmle_mn,1,12) || SubStr(vc_vmle_mn,14,2);

    IF (pc_tp_declaracao IN ('19','20')) THEN
      pc_aux_erro         := 'Registro 10: erro na conversão do percentual de redução do I.I... (ad. ' || vc_adicao_num || ')';
      vc_perc_red_ii      := LPad( LTrim(NVL(To_Char(i.perc_red_ii,'99.99'),'0')), 05,'0' );
      vc_perc_red_ii      := '0' || SubStr(vc_perc_red_ii,1,2) || SubStr(vc_perc_red_ii,4,2);

      pc_aux_erro         := 'Registro 10: erro na conversão do I.I. DCR em real... (ad. ' || vc_adicao_num || ')';
      vc_valor_ii_dev_DCR := LPad( LTrim(NVL(To_Char(i.valor_ii_dev,'999999999999.99'),'0')), 15,'0' );
      vc_valor_ii_dev_DCR := '0' || SubStr(vc_valor_ii_dev_DCR,1,12) || SubStr(vc_valor_ii_dev_DCR,14,2);

      pc_aux_erro         := 'Registro 10: erro na conversão do I.I. a recolher... (ad. ' || vc_adicao_num || ')';
      vc_valor_ii_rec_ZFM := LPad( LTrim(NVL(To_Char(i.valor_ii_rec,'999999999999.99'),'0')), 15,'0' );
      vc_valor_ii_rec_ZFM := '0' || SubStr(vc_valor_ii_rec_ZFM,1,12) || SubStr(vc_valor_ii_rec_ZFM,14,2);
    ELSE
      vc_perc_red_ii      := '00000';
      vc_valor_ii_dev_DCR := '000000000000000';
      vc_valor_ii_rec_ZFM := '000000000000000';
    END IF;

    pc_aux_erro           := 'Registro 10: erro na conversão da cobertura cambial... (ad. ' || vc_adicao_num || ')';
    vc_cobertura_cambial  := NVL( i.cobertura_cambial, '0' );
    pc_aux_erro           := 'Registro 10: erro na conversão da modalidade de pagamento... (ad. ' || vc_adicao_num || ')';
    vc_mde_pgto           := SubStr(cmx_pkg_tabelas.codigo (i.mde_pgto_id),1,2);
    pc_aux_erro           := 'Registro 10: erro na conversão da instituição financiadora... (ad. ' || vc_adicao_num || ')';
    vc_inst_financiadora  := SubStr(cmx_pkg_tabelas.codigo (i.inst_financiadora_id),1,2);
    pc_aux_erro           := 'Registro 10: erro na conversão do motivo para s/ cob.cambial... (ad. ' || vc_adicao_num || ')';
    vc_motivo_s_cobertura := SubStr(cmx_pkg_tabelas.codigo (i.motivo_sem_cobertura_id),1,2);

    pc_aux_erro := 'Registro 10: erro na consulta de pagamentos antecipados... (ad. ' || vc_adicao_num || ')';
    OPEN  cur_dcl_adi_pgto (i.declaracao_adi_id, 'A');
    FETCH cur_dcl_adi_pgto INTO vn_vrt_pgto_antecipado;
    CLOSE cur_dcl_adi_pgto;

    pc_aux_erro := 'Registro 10: erro na consulta de pagamentos a vista... (ad. ' || vc_adicao_num || ')';
    OPEN  cur_dcl_adi_pgto (i.declaracao_adi_id, 'V');
    FETCH cur_dcl_adi_pgto INTO vn_vrt_pgto_vista;
    CLOSE cur_dcl_adi_pgto;

    vn_vrt_pgto_p := round (nvl (i.vmlc_m              , 0), 2) -
                     round (nvl (vn_vrt_pgto_antecipado, 0), 2) -
                     round (nvl (vn_vrt_pgto_vista     , 0), 2);

    pc_aux_erro             := 'Registro 10: erro na conversão do valor do pagamento... (ad. ' || vc_adicao_num || ')';
    vc_vrt_pgto_p           := LTrim(To_Char( NVL(vn_vrt_pgto_p,0), '999999999990D00' ));

    IF ( (i.parcelas_variaveis = 'N') AND (vc_cobertura_cambial in ('1','2')) AND (vn_vrt_pgto_p > 0) ) THEN
      pc_aux_erro           := 'Registro 10: erro na conversão do tipo de parcela... (ad. ' || vc_adicao_num || ')';
      vc_parcelas_variaveis := NVL(i.parcelas_variaveis, 'N');
      pc_aux_erro           := 'Registro 10: erro na conversão da qtde. de parcelas... (ad. ' || vc_adicao_num || ')';
      vc_nr_parcelas        := LPad( NVL(LTrim(To_Char(i.nr_parcelas))  , '0'), 03,'0' );
      pc_aux_erro           := 'Registro 10: erro na conversão do tipo de periodicidade... (ad. ' || vc_adicao_num || ')';
      vc_tp_periodos        := NVL(i.tp_periodos, '1');
      pc_aux_erro           := 'Registro 10: erro na conversão da periodicidade... (ad. ' || vc_adicao_num || ')';
      vc_nr_periodos        := LPad( NVL(LTrim(To_Char(i.nr_periodos)), '0'), 03,'0' );

      pc_aux_erro           := 'Registro 10: erro na conversão do valor total financiado (2)... (ad. ' || vc_adicao_num || ')';
      vc_vrt_pgto_p         := LPad( LTrim(NVL(vc_vrt_pgto_p , '0')), 15,'0' );
      vc_vrt_pgto_p         := '0' || SubStr(vc_vrt_pgto_p,1,12) || SubStr(vc_vrt_pgto_p,14,2);

      pc_aux_erro           := 'Registro 10: erro na conversão da taxa de juros... (ad. ' || vc_adicao_num || ')';
      vc_txjuros            := LPad( Rtrim(LTrim(To_Char(i.txjuros,'99990D0000000'))), 13,'0' );
      vc_txjuros            := '0' || SubStr(vc_txjuros,1,5) || SubStr(vc_txjuros,7,7);

      pc_aux_erro           := 'Registro 10: erro na conversão do código de juros... (ad. ' || vc_adicao_num || ')';
      vc_cd_txjuros         := LPad( NVL(LTrim(To_Char(i.cd_txjuros)), '0'), 04,'0' );

      If ( NVL(i.txjuros,0) > 0 ) Then
        cTemJuros := 'S';
      Else
        cTemJuros := 'N';
      End If;
    ELSE
      vc_parcelas_variaveis := 'N';
      vc_nr_parcelas        := '000';
      vc_tp_periodos        := '0';
      vc_nr_periodos        := '000';
      vc_vrt_pgto_p         := '000000000000000';
      cTemJuros             := 'N';
      vc_txjuros            := '0000000000000';
      vc_cd_txjuros         := '0000';
    END IF;

    pc_aux_erro := 'Registro 10: erro na conversão do tipo de taxa de juros... (ad. ' || vc_adicao_num || ')';
    vc_txjuros     := LPad( NVL(LTrim(vc_txjuros), '0'), 13,'0' );
    --vc_txjuros     := '0' || SubStr(vc_txjuros,1,5) || SubStr(vc_txjuros,7,7);

    pc_aux_erro := 'Registro 10: erro na conversão do código da taxa de juros... (ad. ' || vc_adicao_num || ')';
    vc_cd_txjuros   := LPad( NVL(LTrim(vc_cd_txjuros), '0'), 04,'0' );

    IF (vc_cobertura_cambial = '3') OR (vc_motivo_s_cobertura IN ('30', '57', '66')) THEN
      pc_aux_erro            := 'Registro 10: erro na conversão do pagamento acima de 360 dias... (ad. ' || vc_adicao_num || ')';
      vc_vrt_pgto_acima_360d := LPad( LTrim(To_Char(NVL(vn_vrt_pgto_p,0),'999999999999D99')), 15,'0' );
      vc_vrt_pgto_acima_360d := '0' || SubStr(vc_vrt_pgto_acima_360d,1,12) || SubStr(vc_vrt_pgto_acima_360d,14,2);

      pc_aux_erro            := 'Registro 10: erro na conversão do número do ROF... (ad. ' || vc_adicao_num || ')';
      vc_nr_rof              := SubStr(i.nr_rof,1,8);
    ELSIF (vc_cobertura_cambial = '4') AND (vc_motivo_s_cobertura = '70') THEN
      pc_aux_erro            := 'Registro 10: erro na conversão do pagamento acima de 360 dias sem cob... (ad. ' || vc_adicao_num || ')';
      vc_vrt_pgto_acima_360d := '000000000000000';
      pc_aux_erro            := 'Registro 10: erro na conversão do número do ROF sem cob... (ad. ' || vc_adicao_num || ')';
      vc_nr_rof              := SubStr(i.nr_rof,1,8);
    ELSE
      vc_vrt_pgto_acima_360d := '000000000000000';
      vc_nr_rof              := null;
    END IF;

    pc_aux_erro := 'Registro 10: erro na consulta de representante... (ad. ' || vc_adicao_num || ')';
    OPEN  cur_representante (i.repres_id, i.repres_site_id);
    FETCH cur_representante INTO cr_rep;
    CLOSE cur_representante;

    pc_aux_erro := 'Registro 10: erro na conversão da % comissão do representante... (ad. ' || vc_adicao_num || ')';
    vc_repres_pc_comissao := LPad( LTrim(NVL(to_char(i.repres_pc_comissao, '90D00'), '0')), 05,'0' ) || '0';
    vc_repres_pc_comissao := '0' || SubStr(vc_repres_pc_comissao,1,2) || SubStr(vc_repres_pc_comissao,4,3);

    pc_aux_erro := 'Registro 10: erro na conversão do valor da comissão do representante... (ad. ' || vc_adicao_num || ')';
    vc_repres_vr_comissao := LPad( RTrim(LTrim(NVL(To_Char(i.repres_vr_comissao,'99999999990D00'), '0'))), 15,'0' );
    vc_repres_vr_comissao := '0' || SubStr(vc_repres_vr_comissao,1,12) || SubStr(vc_repres_vr_comissao,14,2);

    pc_aux_erro := 'Registro 10: erro no cursor do banco do representante... (ad. ' || vc_adicao_num || ')';
    OPEN  cur_banco (i.repres_banco_agencia_id);
    FETCH cur_banco INTO vc_repres_banco, vc_repres_agencia;
    CLOSE cur_banco;

    pc_aux_erro           := 'Registro 10: erro na conversão do CNPJ do representante... (ad. ' || vc_adicao_num || ')';
    vc_repres_cnpj        := SubStr(cr_rep.nr_documento,1,14);

    IF ( RTrim(LTrim(vc_repres_cnpj)) IS NOT null ) THEN
      vc_repres_tipo := '1';
    ELSE
      vc_repres_tipo := '0';
    END IF;

    pc_aux_erro           := 'Registro 10: erro na conversão do texto complementar... (ad. ' || vc_adicao_num || ')';
    vc_inf_complementar   := RPad( vc_inf_complementar, 250 );
    pc_aux_erro           := 'Registro 10: erro na conversão do código do motivo de admissão temporária... (ad. ' || vc_adicao_num || ')';
    vc_motivo_adm_temp    := SubStr(cmx_pkg_tabelas.codigo (i.motivo_adm_temp_id),1,2);

    IF (pc_tp_declaracao in ('19','20')) THEN
      pc_aux_erro         := 'Registro 10: erro no cursor de taxas para o DCR I.I.... (ad. ' || vc_adicao_num || ')';
    	vn_taxa_us_mn       := cmx_pkg_taxas.fnc_taxa_mn_opcional (cmx_pkg_tabelas.auxiliar_tabela_id ('906', '220', 1), pd_data_taxa_conversao, 'FISCAL')	;

    	IF nvl(vn_taxa_us_mn,0) > 0 THEN
        pc_aux_erro            := 'Registro 10: erro na conversão do valor DCR I.I. em dolar... (ad. ' || vc_adicao_num || ')';
        vc_valor_ii_dev_DCR_us := LPad( LTrim(NVL(To_Char((i.valor_ii_dev/vn_taxa_us_mn),'999999999999.99'),'0')), 15,'0' );
        vc_valor_ii_dev_DCR_us := '0' || SubStr(vc_valor_ii_dev_DCR_us,1,12) || SubStr(vc_valor_ii_dev_DCR_us,14,2);
    	ELSE
    		vc_valor_ii_dev_DCR_us := '000000000000000';
      END IF;

      pc_aux_erro            := 'Registro 10: erro na conversão do valor recolher do I.I... (ad. ' || vc_adicao_num || ')';
      vc_valor_ii_dev_ZFM    := LPad( LTrim(NVL(To_Char(i.valor_ii_dev,'999999999999.99'),'0')), 15,'0' );
      vc_valor_ii_dev_ZFM    := '0' || SubStr(vc_valor_ii_dev_ZFM,1,12) || SubStr(vc_valor_ii_dev_ZFM,14,2);
    ELSE
      vc_valor_ii_dev_DCR_us := '000000000000000';
      vc_valor_ii_dev_ZFM    := '000000000000000';
    END IF;

    pc_aux_erro := 'Registro 10: erro na conversão do número de Licença... (ad. ' || vc_adicao_num || ')';
    vc_licenca  := SubStr(i.nr_registro,1,10);

    pc_aux_erro := 'Registro 10: erro na conversão da base de cálculo do II... (ad. ' || vc_adicao_num || ')';
    vc_basecalc_ii    := LPad( LTrim(NVL(To_Char(i.basecalc_ii,'999999999999.99'),'0')), 15,'0' );
    vc_basecalc_ii    := '0' || SubStr(vc_basecalc_ii,1,12) || SubStr(vc_basecalc_ii,14,2);

    pc_aux_erro := 'Registro 10: erro na seleção dos parâmetros de pis/cofins... (ad. ' || vc_adicao_num || ')';
	  OPEN  cur_flag_incide_icms_pc;
	  FETCH cur_flag_incide_icms_pc INTO vc_incide_icms_pc;
  	CLOSE cur_flag_incide_icms_pc;

    -- Alteração PIS/COFINS calculo no SISCOMEX
    pc_aux_erro := 'Registro 10: erro na seleção da alíquota de ICMS para PIS/Cofins... (ad. ' || vc_adicao_num || ')';
    imp_pkg_calcula_pis_cofins.calcula_aliquota_icms ( i.aliq_icms
                                  , i.aliq_icms_red
                                  , i.perc_red_icms
                                  , i.aliq_icms_fecp
                                  , i.regtrib_icms_id
                                  , vc_incide_icms_pc
                                  , vn_aliq_icms
                                  , vn_dummy
                                  );

    pc_aux_erro := 'Registro 10: erro na conversão da alíquota de ICMS para PIS/Cofins... (ad. ' || vc_adicao_num || ')';
    --vc_aliq_icms_pis_cofins  := replace(ltrim(rtrim(to_char( vn_aliq_icms,'000D00','NLS_NUMERIC_CHARACTERS=,.') )),',',null );
    vc_aliq_icms_pis_cofins := '00000';

    pc_aux_erro := 'Registro 10: erro na conversão do fund. legal de ICMS para PIS/Cofins... (ad. ' || vc_adicao_num || ')';
    vc_fund_legal_red_icms   := i.fundamento_legal_icms;

    pc_aux_erro := 'Registro 10: erro na conversão do fund. legal de redução de PIS/Cofins... (ad. ' || vc_adicao_num || ')';
    vc_flegal_reducao_pc     := i.flegal_reducao_pis_cofins;

    pc_aux_erro := 'Registro 10: erro na conversão do regime de tributação de PIS/Cofins... (ad. ' || vc_adicao_num || ')';
    vc_reg_trib_pis_cofins   := i.regtrib_pis_cofins;

    pc_aux_erro := 'Registro 10: erro na conversão do fund. legal de PIS/Cofins... (ad. ' || vc_adicao_num || ')';
    vc_fund_legal_pis_cofins := i.fundamento_legal_pis_cofins;

    vc_tipo_certificado := ' ';
    pc_aux_erro := 'Registro 10: erro na seleção do tipo do certificado de origem mercosul... (ad. ' || vc_adicao_num || ')';

    IF (i.cert_origem_mercosul_id IS NOT null) THEN
      OPEN  cur_cert_origem (i.cert_origem_mercosul_id);
      FETCH cur_cert_origem INTO vc_tipo_certificado;
      CLOSE cur_cert_origem;
    ELSE
      vc_tipo_certificado := '1';
    END IF;

    IF ( nvl (cmx_fnc_profile ('IMP_NOVO_LAYOUT_ESTR' ), 'N') = 'S') THEN
       pc_aux_erro := 'Registro 10: erro na composição da variável do novo layout... (ad. ' || vc_adicao_num || ')';
       vc_novo_layout := vc_tipo_certificado;
    ELSE
    	 vc_novo_layout := null;
    END IF;

    pc_aux_erro := 'Registro 10: erro na composição do registro 10... (ad. ' || vc_adicao_num || ')';
    --NSI-1199 IF pc_dcl_retif IS null THEN

      --<acrecimo>  18
      pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 18...(ad. ' || vc_adicao_num || ')';
      imp_prc_gera_reg_18( pc_ref_declaracao, i.declaracao_adi_id, vc_adicao_num, pc_aux_erro, pb_sem_erro, pn_evento_id, vx_acrescimo );

      --<deducao> 17
      pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 17...(ad. ' || vc_adicao_num || ')';
      imp_prc_gera_reg_17( pc_ref_declaracao, i.declaracao_adi_id, vc_adicao_num, pc_aux_erro, pb_sem_erro, pn_evento_id, vx_deducao );

      --<destaque> 20
      pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 20...(ad. ' || vc_adicao_num || ')';
      imp_prc_gera_reg_20( pc_ref_declaracao, i.declaracao_adi_id, vc_adicao_num, pc_aux_erro, pb_sem_erro, pn_evento_id, vx_destaque );

      --<documento> 21
      IF ( nvl(pc_tp_declaracao,'00') not in ('05') ) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 21...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_21( pc_ref_declaracao, i.declaracao_adi_id, vc_adicao_num, pc_aux_erro, pb_sem_erro, pn_evento_id, vx_documento );
      END IF;

      --<documentoMercosul> 23
      IF ( nvl (cmx_fnc_profile ('IMP_NOVO_LAYOUT_ESTR' ), 'N') = 'S') THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 23...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_23 (pc_ref_declaracao, i.declaracao_adi_id, vc_adicao_num, pc_aux_erro, pb_sem_erro, pn_evento_id, vx_docMercosul );
      END IF;

      --<mercadoria> 16 e 19
      pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 16...(ad. ' || vc_adicao_num || ')';
      imp_prc_gera_reg_16( pc_ref_declaracao, i.declaracao_adi_id, i.tp_declaracao_id, vc_adicao_num, i.incoterm_id, i.moeda_id, pd_data_taxa_conversao, pc_aux_erro, pb_sem_erro, pn_evento_id, pn_empresa_id, vx_mercadoria );

      --<tarifa> 14
      IF (i.ex_ncm_id IS NOT null) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 14 - EX NCM...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_14 ( pc_ref_declaracao, vc_adicao_num, i.ex_ncm_id   , i.ato_legal_exncm_id   , i.orgao_emissor_exncm_id   , i.ano_ato_legal_exncm   , i.nr_ato_legal_exncm   , '1', pc_aux_erro, pb_sem_erro, pn_evento_id, vx_tarifa );
      END IF;

      IF (i.ex_nbm_id IS NOT null) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 14 - EX NBM...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_14 ( pc_ref_declaracao, vc_adicao_num, i.ex_nbm_id   , i.ato_legal_exnbm_id   , i.orgao_emissor_exnbm_id   , i.ano_ato_legal_exnbm   , i.nr_ato_legal_exnbm   , '2', pc_aux_erro, pb_sem_erro, pn_evento_id, vx_tarifa );
      END IF;

      IF (i.ato_legal_exnaladi_id IS NOT null) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 14 - EX NALADI...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_14 ( pc_ref_declaracao, vc_adicao_num, i.ex_naladi_id, i.ato_legal_exnaladi_id, i.orgao_emissor_exnaladi_id, i.ano_ato_legal_exnaladi, i.nr_ato_legal_exnaladi, '3', pc_aux_erro, pb_sem_erro, pn_evento_id, vx_tarifa );
      END IF;

      IF (((i.ex_ipi_id IS NOT null) OR ( i.ato_legal_exipi_id IS NOT null )) AND i.flag_nao_enviar_ex_estr_di_ipi = 'N') THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 14 - EX IPI...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_14 ( pc_ref_declaracao, vc_adicao_num, i.ex_ipi_id   , i.ato_legal_exipi_id   , i.orgao_emissor_exipi_id   , i.ano_ato_legal_exipi   , i.nr_ato_legal_exipi   , '4', pc_aux_erro, pb_sem_erro, pn_evento_id, vx_tarifa );
      END IF;

      IF ((i.ato_legal_exprac_id IS NOT null) AND i.flag_nao_enviar_ex_estr_di_ii = 'N') THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 14 - EX PRAC...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_14 ( pc_ref_declaracao, vc_adicao_num, i.ex_prac_id  , i.ato_legal_exprac_id  , i.orgao_emissor_exprac_id  , i.ano_ato_legal_exprac  , i.nr_ato_legal_exprac  , '5', pc_aux_erro, pb_sem_erro, pn_evento_id, vx_tarifa );
      END IF;

      IF (i.ex_antd_id IS NOT null) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 14 - EX ANTD...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_14 ( pc_ref_declaracao, vc_adicao_num, i.ex_antd_id  , i.ato_legal_exantd_id  , i.orgao_emissor_exantd_id  , i.ano_ato_legal_exantd  , i.nr_ato_legal_exantd  , '6', pc_aux_erro, pb_sem_erro, pn_evento_id, vx_tarifa );
      END IF;

      /*IF vx_tarifa IS NULL THEN
        SELECT XMLElement ( "tarifa"
                          , XMLForest (
                        '<codigoAssuntoVinculado />'||
                        '<dataAnoAtoVinculado />'||
                        '<numeroAtoVinculado />'||
                        '<numeroEXAtoVinculado />'||
                        '<siglaOrgaoAtoVinculado />'||
                        '<siglaTipoAtoVinculado />'||
                      '</tarifa>').EXTRACT('*')
          INTO vx_tarifa
          FROM dual;
      END IF;*/

      --<tributo> 15
      vx_tributo := NULL;
      IF ( ((i.basecalc_ii > 0) OR (i.aliq_ii_dev > 0)) AND (i.regtrib_ii <> '6')) THEN
    	  vn_valor_ii_tec := i.basecalc_ii * (vn_aliq_ii_tec / 100);


        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 15 - II...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_15 ( pc_ref_declaracao  /* 01 */
                          , vc_adicao_num      /* 02 */
                          , '0001'             /* 03 */
                          , i.basecalc_ii      /* 04 */
                          , vn_aliq_ii_tec     /* 05 */
                          , vn_valor_ii_tec    /* 06 */
                          , i.aliq_ii_dev      /* 07 */
                          , i.valor_ii_dev     /* 08 */
                          , i.aliq_ii_red      /* 09 */
                          , i.perc_red_ii      /* 10 */
                          , i.aliq_ii_acordo   /* 11 */
                          , i.valor_ii_rec     /* 12 */
                          , null               /* 13 */
                          , null               /* 14 */
                          , null               /* 15 */
                          , null               /* 16 */
                          , null               /* 17 */
                          , null               /* 18 */
                          , null               /* 19 */
                          , '0'                /* 20 */
                          , null               /* 21 */
                          , null               /* 22 */
                          , pc_aux_erro        /* 23 */
                          , pb_sem_erro        /* 24 */
                          , pn_evento_id       /* 25 */
                          , vx_tributo         /* 26 */
                          );
      END IF;

      IF ( ((i.basecalc_ipi > 0) OR (i.aliq_ipi_dev > 0)) AND (i.regtrib_ipi IS NOT null)) THEN
    	  vn_valor_ipi_tec := i.basecalc_ipi * (vn_aliq_ipi_tec / 100);


        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 15 - IPI...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_15 ( pc_ref_declaracao     /* 01 */
                          , vc_adicao_num         /* 02 */
                          , '0002'                /* 03 */
                          , i.basecalc_ipi        /* 04 */
                          , vn_aliq_ipi_tec       /* 05 */
                          , vn_valor_ipi_tec      /* 06 */
                          , i.aliq_ipi_dev        /* 07 */
                          , i.valor_ipi_dev       /* 08 */
                          , i.aliq_ipi_red        /* 09 */
                          , 0                     /* 10 */
                          , 0                     /* 11 */
                          , i.valor_ipi_rec       /* 12 */
                          , i.um_aliq_esp_ipi_id  /* 13 */
                          , i.qt_um_aliq_esp_ipi  /* 14 */
                          , i.vr_aliq_esp_ipi     /* 15 */
                          , i.tipo_recipiente_id  /* 16 */
                          , i.qt_ml_recipiente    /* 17 */
                          , i.nc_tipi             /* 18 */
                          , i.regtrib_ipi_id      /* 19 */
                          , '0'                   /* 20 */
                          , null                  /* 21 */
                          , null                  /* 22 */
                          , pc_aux_erro           /* 23 */
                          , pb_sem_erro           /* 24 */
                          , pn_evento_id          /* 25 */
                          , vx_tributo              /* 26 */
                          );
      END IF;

      IF (nvl (i.valor_antdump_dev, 0) > 0) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 15 - Antidumping...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_15 ( pc_ref_declaracao                /* 01 */  -- pc_ref_declaracao
                          , vc_adicao_num                    /* 02 */  -- pc_adicao_num
                          , '0003'                           /* 03 */  -- pc_tp_tributo
                          , i.basecalc_antdump               /* 04 */  -- pn_base_calculo
                          , i.aliq_antdump                   /* 05 */  -- pn_aliq_tec
                          , i.valor_antdump_ad_valorem       /* 06 */  -- pn_valor_tec
                          , i.aliq_antdump                   /* 07 */  -- pn_aliq_dev
                          , i.valor_antdump_dev              /* 08 */  -- pn_valor_dev
                          , 0                                /* 09 */  -- pn_aliq_red
                          , 0                                /* 10 */  -- pn_perc_red
                          , 0                                /* 11 */  -- pn_aliq_acordo
                          , i.valor_antdump_dev              /* 12 */  -- pn_valor_rec
                          , i.um_aliq_esp_antdump_id         /* 13 */  -- pn_um_aliq_esp_id
                          , i.qt_um_aliq_esp_antdump         /* 14 */  -- pn_qt_um_aliq_esp
                          , i.vr_aliq_esp_antdump_mn         /* 15 */  -- pn_vr_aliq_esp
                          , null                             /* 16 */  -- pn_tipo_recipiente_id
                          , null                             /* 17 */  -- pn_qt_ml_recipiente
                          , null                             /* 18 */  -- pn_nc_tipi
                          , null                             /* 19 */  -- pn_regtrib_ipi_id
                          , '1'                              /* 20 */  -- pc_tp_direito
                          , null                             /* 21 */  -- pc_um_aliq_especifica
                          , i.valor_antdump_aliq_especifica  /* 22 */  -- pn_valor_na_aliq_especifica
                          , pc_aux_erro                      /* 23 */  -- pc_aux_erro
                          , pb_sem_erro                      /* 24 */  -- pb_sem_erro
                          , pn_evento_id                     /* 25 */  -- pn_evento_id
                          , vx_tributo                         /* 26 */  -- vc_tributo
                          );
      END IF;

      IF (i.basecalc_pis_cofins > 0) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 15 - PIS...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_15 ( pc_ref_declaracao               /* 01 */
                          , vc_adicao_num                   /* 02 */
                          , '0005'                          /* 03 */
                          , i.basecalc_pis_cofins           /* 04 */
                          , i.aliq_pis_dev                  /* 05 */
                          , i.valor_pis_integral            /* 06 */
                          , i.aliq_pis_dev                  /* 07 */
                          , i.valor_pis_dev                 /* 08 */
                          , i.aliq_pis_reduzida             /* 09 */
                          , i.perc_reducao_base_pis_cofins  /* 10 */
                          , null                            /* 11 */
                          , i.valor_pis                     /* 12 */
                          , null                            /* 13 */
                          , i.qtde_um_aliq_especifica_pc    /* 14 */
                          , i.aliq_pis_especifica           /* 15 */
                          , null                            /* 16 */
                          , null                            /* 17 */
                          , null                            /* 18 */
                          , null                            /* 19 */
                          , '0'                             /* 20 */
                          , i.un_medida_aliq_especifica_pc  /* 21 */
                          , i.valor_pis                     /* 22 */
                          , pc_aux_erro                     /* 23 */
                          , pb_sem_erro                     /* 24 */
                          , pn_evento_id                    /* 25 */
                          , vx_tributo );                     /* 26 */
      END IF;

      IF (i.basecalc_pis_cofins > 0) THEN
        pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 15 - COFINS...(ad. ' || vc_adicao_num || ')';
        imp_prc_gera_reg_15 ( pc_ref_declaracao              /* 01 */
                          , vc_adicao_num                  /* 02 */
                          , '0006'                         /* 03 */
                          , i.basecalc_pis_cofins          /* 04 */
                          , i.aliq_cofins_dev              /* 05 */
                          , i.valor_cofins_integral        /* 06 */
                          , i.aliq_cofins_dev              /* 07 */
                          , i.valor_cofins_dev             /* 08 */
                          , i.aliq_cofins_reduzida         /* 09 */
                          , i.perc_reducao_base_pis_cofins /* 10 */
                          , null                           /* 11 */
                          , i.valor_cofins                 /* 12 */
                          , null                           /* 13 */
                          , i.qtde_um_aliq_especifica_pc   /* 14 */
                          , i.aliq_cofins_especifica       /* 15 */
                          , null                           /* 16 */
                          , null                           /* 17 */
                          , null                           /* 18 */
                          , null                           /* 19 */
                          , '0'                            /* 20 */
                          , i.un_medida_aliq_especifica_pc /* 21 */
                          , i.valor_cofins                 /* 22 */
                          , pc_aux_erro                    /* 23 */
                          , pb_sem_erro                    /* 24 */
                          , pn_evento_id                   /* 25 */
                          , vx_tributo );                    /* 26 */
      END IF;

      /*IF vx_tributo IS NULL THEN
        SELECT XMLType ('<tributo>'||
                          '<codigoReceitaImposto />'||
                          '<codigoTipoAliquotaIPT />'||
                          '<codigoTipoBeneficioIPI />'||
                          '<codigoTipoDireito />'||
                          '<codigoTipoRecipiente />'||
                          '<nomeUnidadeEspecificaAliquotaIPT />'||
                          '<numeroNotaComplementarTIPI />'||
                          '<percentualAliquotaAcordoTarifario />'||
                          '<percentualAliquotaNormalAdval />'||
                          '<percentualAliquotaReduzida />'||
                          '<percentualReducaoIPT />'||
                          '<quantidadeMLRecipiente />'||
                          '<quantidadeMercadoriaUnidadeAliquotaEspecifica />'||
                          '<valorAliquotaEspecificaIPT />'||
                          '<valorBaseCalculoAdval />'||
                          '<valorCalculadoIIACTarifario />'||
                          '<valorCalculoIPTEspecifica />'||
                          '<valorCalculoIptAdval />'||
                          '<valorIPTaRecolher />'||
                          '<valorImpostoDevido />'||
                        '</tributo>').EXTRACT('*')
          INTO vx_tributo
          FROM dual;
      END IF;*/

      --<valoracaoAduaneira> 22
      pc_aux_erro := 'Registro 10: erro nos parâmetros do registro 22...(ad. ' || vc_adicao_num || ')';
      imp_prc_gera_reg_22 (pc_ref_declaracao, i.declaracao_adi_id, vc_adicao_num, pc_aux_erro, pb_sem_erro, pn_evento_id, vx_valAduaneira);

      DECLARE
        vx_aux xmltype;
        vx_aux1 xmltype;
        vx_aux2 xmltype;
        vx_aux3 xmltype;
        vx_aux4 xmltype;
        vx_aux5 xmltype;
        vx_aux_final xmltype;
      BEGIN
	    pc_aux_erro := 'Montando XML <adicao>.aux1';
      SELECT XMLForest (
                          RPad( vc_acordo_aladi , 03 )               AS "codigoAcordoAladi"
                        , vc_aplicacao                                        AS "codigoAplicacaoMercadoria"
                        , vc_ausencia_fabric                                  AS "codigoAusenciaFabricante"
                        , vc_cobertura_cambial                                AS "codigoCoberturaCambial"
                        , LPad( NVL(vc_flegal_reducao_pc, '0'), 02, '0')     AS "codigoFundamentoLegalReduzido"
                        , LPad( NVL(vc_fundamento_legal ,'0'), 02,'0' )       AS "codigoFundamentoLegalRegime"
                        , LPad( NVL(vc_fund_legal_pis_cofins, '0'), 02, '0') AS "codigoFundamentoLegalRegimePisCofins"
                        , LPad( vc_incoterm , 03 )                   AS "codigoIncotermsVenda"
                        , LPad( NVL(vc_nbm ,'0'), 10,'0' )                    AS "codigoMercadoriaNBMSH"
                        , LPad( NVL(vc_ncm ,'0'), 08,'0' )                    AS "codigoMercadoriaNCM"
                        , LPad( NVL(vc_naladi_ncca ,'0'), 07,'0' )            AS "codigoMercadoriaNaladiNCC"
                        , LPad( NVL(vc_naladi_sh ,'0'), 08,'0' )              AS "codigoMercadoriaNaladiSH"
                        , LPad( NVL(vc_metodo_vr_adu ,'0'), 02,'0' )          AS "codigoMetodoValoracao"
                        , LPad( NVL(vc_moeda_frete ,'0'), 03,'0' )            AS "codigoMoedaFreteMercadoria"
                        , LPad( NVL(vc_moeda ,'0'), 03,'0' )                  AS "codigoMoedaNegociada"
                        , LPad( NVL(vc_moeda_seguro ,'0'), 03,'0' )           AS "codigoMoedaSeguroMercadoria"
                        , LPad( nvl(vc_motivo_adm_temp ,'0'), 02,'0' )        AS "codigoMotivoAdmissaoTemporaria"
                        , LPad( NVL(vc_motivo_s_cobertura,'0'), 02,'0' )      AS "codigoMotivoSemCobertura"
                        , LPad( NVL(vc_inst_financiadora,'0'), 02,'0' )       AS "codigoOrgaoFinanciamentoInternacional"
                        , LPad( NVL(vc_export_cdpais ,'0'), 03,'0' )          AS "codigoPaisAquisicaoMercadoria"
                        , LPad( NVL(vc_fabric_cdpais ,'0'), 03,'0' )          AS "codigoPaisOrigemMercadoria"
                        , LPad( NVL(vc_pais_proc ,'0'), 03,'0' )              AS "codigoPaisProcedenciaMercadoria"
                        , vc_reg_trib_pis_cofins                              AS "codigoRegimeTriburarioPisCofins"
                        , vc_regtrib_ii                                       AS "codigoRegimeTributacao"
                        , vc_tp_acordo                                        AS "codigoTipoAcordoTarifario"
                        , LPad( NVL(vc_urfe ,'0'), 07,'0' )                   AS "codigoURFEntradaMercadoria"
                        , LPad( NVL(vc_via_transp ,'0'), 02,'0' )             AS "codigoViaTransporte"
                        , vc_vinc_imp_exp                                     AS "codigoVinculoImportadorExportador"
                        )
        INTO vx_aux1
        FROM dual;

	    pc_aux_erro := 'Montando XML <adicao>.aux2';
      SELECT XMLFOREST(
                          RPad( vc_fabric_cidade , 25 )     AS "enderecoCidadeFabricante"
                        , RPad( vc_export_cidade , 25 )     AS "enderecoCidadeFornecedorEstrangeiro"
                        , RPad( vc_fabric_complemento, 21 ) AS "enderecoComplementoFabricante"
                        , RPad( vc_export_complemento, 21 ) AS "enderecoComplementoFornecedorEstrangeiro"
                        , RPad( vc_fabric_estado , 25 )     AS "enderecoEstadoFabricante"
                        , RPad( vc_export_estado , 25 )     AS "enderecoEstadoFornecedorEstrangeiro"
                        , RPad( vc_export_endereco , 40 )   AS "enderecoLogradouroFornecedorEstrangeiro"
                        , RPad( vc_fabric_endereco , 40 )   AS "enderecoLogradouroFabricante"
                        , RPad( vc_fabric_nrendereco, 06 )  AS "enderecoNumeroFabricante"
                        , RPad( vc_export_nrendereco, 06 )  AS "enderecoNumeroFornecedorEstrangeiro"
                        , i.bem_encomenda                            AS "indicadorBemEncomenda"
                        , i.material_usado                           AS "indicadorMaterialUsado"
                        , vc_multimodal                     AS "indicadorMultimodal"
                        , vc_novo_layout                             AS "indicadorTipoCertificado"
                        )
        INTO vx_aux2
        FROM dual;

	    pc_aux_erro := 'Montando XML <adicao>.aux3';
      SELECT XMLFOREST(
                          RPad( vc_fabric_nome , 60 )      AS "nomeFabricanteMercadoria"
                        , RPad( vc_export_nome , 60 )      AS "nomeFornecedorEstrangeiro"
                        , RPad( vc_local_cvenda , 60,' ') AS "nomeLocalCondicaoVenda"
                        , vc_adicao_num                             AS "numeroAdicao"
                        , '00000000'                                AS "numeroDocumentoReducao"
                        , LPad( NVL (vc_licenca,'0'), 10, '0')      AS "numeroIdentificacaoLI"
                        , RPad(vc_nr_rof , 08 )            AS "numeroROF"
                        , vc_perc_red_ii                            AS "percentualCoeficienteReducaoII"
                        , vc_peso_liquido                           AS "pesoLiquidoMercadoria"
                        , vc_qt_um_est                              AS "quantidadeUnidadeEstatistica"
                        )
        INTO vx_aux3
        FROM dual;

	    pc_aux_erro := 'Montando XML <adicao>.aux4';
      SELECT XMLFOREST(
                          vc_aliq_icms_pis_cofins AS "valorAliquotaIcms"
                        , vc_valor_ii_dev_DCR_us  AS "valorCalculoDCRDolar"
                        , vc_vrt_pgto_acima_360d  AS "valorFinanciadoSuperior360"
                        , vc_vrt_fr_mn            AS "valorFreteMercadoriaMoedaNacional"
                        , vc_vrt_fr_m             AS "valorFreteMercadoriaMoedaNegociada"
                        , vc_valor_ii_dev_DCR     AS "valorIICalculadoDCRMoedaNacional"
                        , vc_valor_ii_dev_ZFM     AS "valorIIDevidoZFM"
                        , vc_valor_ii_rec_ZFM     AS "valorIIaReceberZFM"
                        , vc_vrt_cvenda_m         AS "valorMercadoriaCondicaoVenda"
                        , vc_vmle_mn              AS "valorMercadoriaEmbarqueMoedaNacional"
                        , vc_vrt_cvenda_mn        AS "valorMercadoriaVendaMoedaNacional"
                        , vc_vrt_sg_mn            AS "valorSeguroMercadoriaMoedaNacional"
                        , vc_vrt_sg_m             AS "valorSeguroMercadoriaMoedaNegociada"
                        )
        INTO vx_aux4
        FROM dual;

	    pc_aux_erro := 'Montando XML <adicao>.aux5';
        SELECT XMLElement ("textoComplementoValorAduaneiro", vc_inf_complementar)
          INTO vx_aux5
          FROM dual;


	    pc_aux_erro := 'Montando XML <adicao>.aux';
        SELECT imp_pkg_gera_xml_ep.MyXMLConcat(
                      vx_acrescimo
                    , vx_aux1
                    , vx_deducao
                    , vx_destaque
                    , vx_documento
                    , vx_docMercosul
                    , vx_aux2
                    , vx_mercadoria
                    , vx_aux3
                    , vx_tarifa
                    , vx_aux5
                    , vx_tributo
                    , vx_aux4
                    , vx_valAduaneira
                  )
          INTO vx_aux
          FROM dual;

	    pc_aux_erro := 'Montando XML <adicao>.auxfinal';

      logar ('000','vx_aux', vx_aux.getclobval());
        SELECT imp_pkg_gera_xml_ep.MyXMLElement ('adicao', vx_aux)
          INTO vx_aux_final
          FROM dual;

      logar ('000','vx_aux_final', vx_aux_final.getclobval());
      IF xml_adicao IS NOT null THEN
        logar ('000','xml_adicao', xml_adicao.getclobval());
      END IF;

	    pc_aux_erro := 'Montando XML <adicao>.';
        SELECT imp_pkg_gera_xml_ep.MyXMLConcat(
                  xml_adicao
                , vx_aux_final
              )
              --.EXTRACT('*')
          INTO xml_adicao
          FROM dual;
        END;
	    pc_aux_erro := 'depois: Montando XML <adicao>';
        --cmx_prc_log_clob(xml_adicao, 100214);
    --NSI-1199 END IF;


  END LOOP;

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, pc_aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_10;

PROCEDURE imp_prc_gera_reg_14 ( pc_ref_declaracao            VARCHAR2
                            , pc_adicao_num                VARCHAR2
                            , pn_ex_id                     NUMBER
                            , pn_ato_legal_id              NUMBER
                            , pn_orgao_emissor_id          NUMBER
                            , pn_ano_ato_legal             NUMBER
                            , pn_nr_ato_legal              NUMBER
                            , pc_cd_assunto                VARCHAR2
                            , pc_aux_erro          IN OUT  VARCHAR2
                            , pb_sem_erro          IN OUT  BOOLEAN
                            , pn_evento_id                 NUMBER
                            , px_tarifa            IN OUT  XMLType
                            ) IS

  vc_ato_legal       VARCHAR2(05)   := null;
  vc_orgao_emissor   VARCHAR2(06)   := null;
  vc_ano_ato_legal   VARCHAR2(04)   := null;
  vc_nr_ato_legal    VARCHAR2(06)   := null;
  vc_ex              VARCHAR2(03)   := null;
  vc_string          VARCHAR2(2000) := null;

  CURSOR cur_ex_tarifario IS
    SELECT substr(to_char(numero),1,3)
      FROM imp_ex_tarifario
     WHERE ex_tarifario_id = pn_ex_id;

BEGIN
  --:block1.PROCESSO := '(14) processando destaque tarifario - Acordos...';
  --SYNCHRONIZE;

  IF ( pn_ato_legal_id IS NOT null ) THEN
    pc_aux_erro      := 'Registro 14: erro na conversão do tipo do ato legal...(ad. ' || pc_adicao_num || ')';
    vc_ato_legal     := SubStr(cmx_pkg_tabelas.codigo (pn_ato_legal_id),1,5);
    pc_aux_erro      := 'Registro 14: erro na conversão do órgão emissor do ato legal...(ad. ' || pc_adicao_num || ')';
    vc_orgao_emissor := SubStr(cmx_pkg_tabelas.codigo (pn_orgao_emissor_id),1,6);
    pc_aux_erro      := 'Registro 14: erro na conversão do ano do ato legal...(ad. ' || pc_adicao_num || ')';
    vc_ano_ato_legal := SubStr(To_Char(pn_ano_ato_legal),1,4);
    pc_aux_erro      := 'Registro 14: erro na conversão do número do ato legal...(ad. ' || pc_adicao_num || ')';
    vc_nr_ato_legal  := SubStr(To_Char(pn_nr_ato_legal),1,6);

    pc_aux_erro      := 'Registro 14: erro na conversão do número do ex-tarifário...(ad. ' || pc_adicao_num || ')';
    OPEN  cur_ex_tarifario;
    FETCH cur_ex_tarifario INTO vc_ex;
    CLOSE cur_ex_tarifario;

    pc_aux_erro := 'Registro 14: erro na composição do registro 14...(ad. ' || pc_adicao_num || ')';
    SELECT imp_pkg_gera_xml_ep.MyXMLConcat(px_tarifa, XMLElement ( "tarifa"
                      , XMLForest ( pc_cd_assunto AS "codigoAssuntoVinculado"
                                  , LPad( NVL(vc_ano_ato_legal,'0'), 04,'0' ) AS "dataAnoAtoVinculado"
                                  , LPad( NVL(vc_nr_ato_legal ,'0'), 06,'0' ) AS "numeroAtoVinculado"
                                  , LPad( NVL(vc_ex,'0'), 03,'0' )            AS "numeroEXAtoVinculado"
                                  , RPad( vc_orgao_emissor, 06 )     AS "siglaOrgaoAtoVinculado"
                                  , RPad( vc_ato_legal, 05 )         AS "siglaTipoAtoVinculado"
                                  )
                      ))--.EXTRACT('*')



    /*MyXMLConcat ( XMLType ('<tarifa>'||
                                    '<codigoAssuntoVinculado>'||pc_cd_assunto||'</codigoAssuntoVinculado>'||
                                    '<dataAnoAtoVinculado>'||||'</dataAnoAtoVinculado>'||
                                    '<numeroAtoVinculado>'||LPad( NVL(vc_nr_ato_legal ,'0'), 06,'0' )||'</numeroAtoVinculado>'||
                                    '<numeroEXAtoVinculado>'||LPad( NVL(vc_ex,'0'), 03,'0' )||'</numeroEXAtoVinculado>'||
                                    '<siglaOrgaoAtoVinculado>'||RPad( NVL(vc_orgao_emissor,' '), 06 ) ||'</siglaOrgaoAtoVinculado>'||
                                    '<siglaTipoAtoVinculado>'||RPad( NVL(vc_ato_legal,' '), 05 )||'</siglaTipoAtoVinculado>'||
                                '</tarifa>'))*/
      INTO px_tarifa
      FROM dual;

  END IF;

  /*IF px_tarifa IS NULL THEN
    SELECT XMLType ('<tarifa>'||
                      '<codigoAssuntoVinculado />'||
                      '<dataAnoAtoVinculado />'||
                      '<numeroAtoVinculado />'||
                      '<numeroEXAtoVinculado />'||
                      '<siglaOrgaoAtoVinculado />'||
                      '<siglaTipoAtoVinculado />'||
                    '</tarifa>').EXTRACT('*')
      INTO px_tarifa
      FROM dual;
  END IF;*/

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, pc_aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_14;

PROCEDURE imp_prc_gera_reg_15 ( /* 01 */ pc_ref_declaracao                   VARCHAR2
                            , /* 02 */ pc_adicao_num                       VARCHAR2
                            , /* 03 */ pc_tp_tributo                       VARCHAR2
                            , /* 04 */ pn_base_calculo                     NUMBER
                            , /* 05 */ pn_aliq_tec                         NUMBER
                            , /* 06 */ pn_valor_tec                        NUMBER
                            , /* 07 */ pn_aliq_dev                         NUMBER
                            , /* 08 */ pn_valor_dev                        NUMBER
                            , /* 09 */ pn_aliq_red                         NUMBER
                            , /* 10 */ pn_perc_red                         NUMBER
                            , /* 11 */ pn_aliq_acordo                      NUMBER
                            , /* 12 */ pn_valor_rec                        NUMBER
                            , /* 13 */ pn_um_aliq_esp_id                   NUMBER
                            , /* 14 */ pn_qt_um_aliq_esp                   NUMBER
                            , /* 15 */ pn_vr_aliq_esp                      NUMBER   -- aliquota especifica
                            , /* 16 */ pn_tipo_recipiente_id               NUMBER
                            , /* 17 */ pn_qt_ml_recipiente                 NUMBER
                            , /* 18 */ pn_nc_tipi                          NUMBER
                            , /* 19 */ pn_regtrib_ipi_id                   NUMBER
                            , /* 20 */ pc_tp_direito                       VARCHAR2 -- 1=antidumping, 2=compensatorio
                            , /* 21 */ pc_um_aliq_especifica               VARCHAR2
                            , /* 22 */ pn_valor_na_aliq_especifica         NUMBER
                            , /* 23 */ pc_aux_erro                 IN OUT  VARCHAR2
                            , /* 24 */ pb_sem_erro                 IN OUT  BOOLEAN
                            , /* 25 */ pn_evento_id                        NUMBER
                            , /* 26 */ px_tributo                  IN OUT  XMLType
                            ) IS

  vc_tipo_aliquota     VARCHAR2(01)   := null;
  vc_base_calculo      VARCHAR2(15)   := null;
  vc_aliq_tec          VARCHAR2(06)   := null;
  vc_valor_tec         VARCHAR2(15)   := null;
  vc_um_esp            VARCHAR2(15)   := null;
  vc_ql_ml_recipiente  VARCHAR2(05)   := null;
  vc_qt_um_aliq_esp    VARCHAR2(09)   := null;
  vc_vr_aliq_esp       VARCHAR2(11)   := null;
  vc_vrtotal_aliq_esp  VARCHAR2(16)   := null;
  vc_regtrib_ipi       VARCHAR2(01)   := null;
  vc_aliq_red          VARCHAR2(06)   := null;
  vc_perc_red          VARCHAR2(06)   := null;
  vc_aliq_acordo       VARCHAR2(06)   := null;
  vc_valor_acordo      VARCHAR2(15)   := null;
  vc_aliq_dev          VARCHAR2(06)   := null;
  vc_valor_dev         VARCHAR2(15)   := null;
  vc_valor_rec         VARCHAR2(15)   := null;
  vc_nc_tipi           VARCHAR2(02)   := null;
  vc_tp_recipiente     VARCHAR2(02)   := null;
  vc_string            VARCHAR2(5000) := null;

BEGIN

  vc_tipo_aliquota := '1';

  IF (pc_tp_tributo = '0002') AND (pn_nc_tipi IS NOT null) THEN
    vc_tipo_aliquota := '4';
  END IF;

  IF (pc_tp_tributo IN ('0005', '0006')) AND (pn_vr_aliq_esp IS NOT null) THEN
    vc_tipo_aliquota := '2';
  END IF;

  IF (pc_tp_tributo = '0003') THEN
    IF (pn_vr_aliq_esp IS NOT null) AND (pn_aliq_tec IS NOT null) THEN
      vc_tipo_aliquota := '3';
    ELSIF (pn_vr_aliq_esp IS NOT null) AND (pn_aliq_tec IS null) THEN
      vc_tipo_aliquota := '2';
    ELSIF (pn_vr_aliq_esp IS null) AND (pn_aliq_tec IS NOT null) THEN
      vc_tipo_aliquota := '1';
    END IF;
  END IF;

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do base de cálculo do imposto...(ad. ' || pc_adicao_num || ')';
  vc_base_calculo     := LPad( LTrim(NVL(To_Char(pn_base_calculo,'999999999999.99'), '0')), 15,'0' );
  vc_base_calculo     := '0' || SubStr(vc_base_calculo,1,12) || SubStr(vc_base_calculo,14,2);

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do alíquota do imposto, baseado na TEC...(ad. ' || pc_adicao_num || ')';
  vc_aliq_tec         := LPad( LTrim(NVL(To_Char(pn_aliq_tec,'999.99'),'0')), 06,'0' );
  vc_aliq_tec         := SubStr(vc_aliq_tec,1,3) || SubStr(vc_aliq_tec,5,2);

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do valor do imposto, baseado na TEC...(ad. ' || pc_adicao_num || ')';
  vc_valor_tec        := LPad( LTrim(NVL(To_Char(pn_valor_tec,'999999999999.99'),'0')), 15,'0' );
  vc_valor_tec        := '0' || SubStr(vc_valor_tec,1,12) || SubStr(vc_valor_tec,14,2);

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão da descrição da un.medida...(ad. ' || pc_adicao_num || ')';
  vc_um_esp           := SubStr(cmx_pkg_tabelas.descricao (pn_um_aliq_esp_id),1,15);

  IF (pc_tp_tributo IN ('0005', '0006')) AND (pc_um_aliq_especifica IS NOT null) THEN
    pc_aux_erro := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão da descrição da un.medida de PIS/Cofins...(ad. ' || pc_adicao_num || ')';
    vc_um_esp   := pc_um_aliq_especifica;
  END IF;

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão da capacidade do recipiente...(ad. ' || pc_adicao_num || ')';
  vc_ql_ml_recipiente := LPad( NVL(SubStr(To_Char(pn_qt_ml_recipiente),1,5),'0'), 5,'0' );

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão da qtde. un.medida específica...(ad. ' || pc_adicao_num || ')';
  vc_qt_um_aliq_esp   := LPad( NVL(To_Char(pn_qt_um_aliq_esp),'0'), 09,'0' );

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do valor da alíquota específica...(ad. ' || pc_adicao_num || ')';
  vc_vr_aliq_esp      := LPad( LTrim(NVL(To_Char(pn_vr_aliq_esp,'99999.99999'),'0')), 11,'0' );
  vc_vr_aliq_esp      := SubStr(vc_vr_aliq_esp, 1, 5) || SubStr(vc_vr_aliq_esp, 7, 5);

  IF (pc_tp_tributo IN ('0005', '0006') AND (pn_vr_aliq_esp IS NOT null)) THEN
    pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do valor total (PIS/Cofins)...(ad. ' || pc_adicao_num || ')';
    vc_vrtotal_aliq_esp := '000000000000000';
  ELSE
    pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do valor total...(ad. ' || pc_adicao_num || ')';
    vc_vrtotal_aliq_esp := LPad( LTrim(NVL(To_Char(pn_vr_aliq_esp,'9999999999999.99'),'0')), 16,'0' );
    vc_vrtotal_aliq_esp := SubStr(vc_vrtotal_aliq_esp,1,13) || SubStr(vc_vrtotal_aliq_esp, 15, 2);
  END IF;

  IF ((pc_tp_tributo = '0003') AND (pn_vr_aliq_esp IS NOT null)) THEN
    pc_aux_erro         := 'Registro (15) - tributo ' || pc_tp_tributo || '... Erro na conversão do valor total (PIS/Cofins) (ad. ' || pc_adicao_num || ')';
    vc_vrtotal_aliq_esp := LPad( LTrim(NVL(To_Char(pn_valor_na_aliq_especifica,'9999999999999.99'),'0')), 16,'0' );
    vc_vrtotal_aliq_esp := SubStr(vc_vrtotal_aliq_esp,1,13) || SubStr(vc_vrtotal_aliq_esp, 15, 2);
  END IF;

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do regime tributação do IPI...(ad. ' || pc_adicao_num || ')';
  vc_regtrib_ipi      := NVL(cmx_pkg_tabelas.codigo (pn_regtrib_ipi_id),'0');

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão da aliquota reduzida...(ad. ' || pc_adicao_num || ')';
  vc_aliq_red         := replace (to_char( pn_aliq_red,'FM000D00', 'NLS_NUMERIC_CHARACTERS=.,' ),'.',NULL);
  /*vc_aliq_red         := LPad( LTrim(NVL(To_Char(pn_aliq_red,'999.99'),'0')), 06,'0' );
  vc_aliq_red         := SubStr(vc_aliq_red,1,3) || SubStr(vc_aliq_red,5,2);   */

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do percentual de redução...(ad. ' || pc_adicao_num || ')';
  vc_perc_red         := replace (to_char( pn_perc_red,'FM000D00', 'NLS_NUMERIC_CHARACTERS=.,' ),'.',NULL);
  /*vc_perc_red         := LPad( LTrim(NVL(To_Char(pn_perc_red,'999.99'),'0')), 06,'0' );
  vc_perc_red         := SubStr(vc_perc_red,1,3) || SubStr(vc_perc_red,5,2); */

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão da alíquota de acordo...(ad. ' || pc_adicao_num || ')';
  vc_aliq_acordo      := replace (to_char( pn_aliq_acordo,'FM000D00', 'NLS_NUMERIC_CHARACTERS=.,' ),'.',NULL);
  /*vc_aliq_acordo      := LPad( LTrim(NVL(To_Char(pn_aliq_acordo,'999.99'),'0')), 06,'0' );
  vc_aliq_acordo      := SubStr(vc_aliq_acordo,1,3) || SubStr(vc_aliq_acordo,5,2); */

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do valor do acordo...(ad. ' || pc_adicao_num || ')';
  vc_valor_acordo     := replace (to_char( (pn_base_calculo*(pn_aliq_acordo/100)),'FM0000000000000D00', 'NLS_NUMERIC_CHARACTERS=.,' ),'.',NULL);
  /*vc_valor_acordo     := LPad( LTrim(NVL(To_Char((pn_base_calculo*(pn_aliq_acordo/100)),'999999999999.99'),'0')), 15,'0' );
  vc_valor_acordo     := '0' || SubStr(vc_valor_acordo,1,12) || SubStr(vc_valor_acordo,14,2); */

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do alíquota do imposto, baseado na TEC...(ad. ' || pc_adicao_num || ')';
  vc_aliq_dev         := replace (to_char( pn_aliq_dev,'FM000D00', 'NLS_NUMERIC_CHARACTERS=.,' ),'.',NULL);
  /*vc_aliq_dev         := LPad( LTrim(NVL(To_Char(pn_aliq_dev,'999.99'),'0')), 06,'0' );
  vc_aliq_dev         := SubStr(vc_aliq_dev,1,3) || SubStr(vc_aliq_dev,5,2);     */

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do valor devido do imposto...(ad. ' || pc_adicao_num || ')';
  vc_valor_dev        := replace (to_char( pn_valor_dev,'FM0000000000000D00', 'NLS_NUMERIC_CHARACTERS=.,' ),'.',NULL);
  /*vc_valor_dev        := LPad( LTrim(NVL(To_Char(pn_valor_dev,'999999999999.99'),'0')), 15,'0' );
  vc_valor_dev        := '0' || SubStr(vc_valor_dev,1,12) || SubStr(vc_valor_dev,14,2); */

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do valor a recolher do imposto...(ad. ' || pc_adicao_num || ')';
  vc_valor_rec        := replace (to_char( pn_valor_rec,'FM0000000000000D00', 'NLS_NUMERIC_CHARACTERS=.,' ),'.',NULL);
  /*vc_valor_rec        := LPad( LTrim(NVL(To_Char(pn_valor_rec,'999999999999.99'),'0')), 15,'0' );
  vc_valor_rec        := '0' || SubStr(vc_valor_rec,1,12) || SubStr(vc_valor_rec,14,2);   */

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão da nota complementar TIPI...(ad. ' || pc_adicao_num || ')';
  vc_nc_tipi          := LTrim(NVL(To_Char(pn_nc_tipi),'0'));

  pc_aux_erro         := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na conversão do tipo de recipiente...(ad. ' || pc_adicao_num || ')';
  vc_tp_recipiente    := cmx_pkg_tabelas.codigo (pn_tipo_recipiente_id);

  -- o valor TEC para II, IPI é o valor devido
  -- para PIS e Cofins é o valor calculado com a alíquota da NCM
  IF (pc_tp_tributo NOT IN ('0003', '0005', '0006')) THEN
    vc_valor_tec := vc_valor_dev;
  END IF;

  IF (pc_tp_tributo IN ('0003') AND (nvl (pn_base_calculo, 0) = 0)) THEN
    vc_valor_tec := '000000000000000';
  END IF;

  -- Para PIS e Cofins o valor_acordo é o valor calculado com
  -- a aliquota reduzida, portanto o valor a recolher.
  IF (pc_tp_tributo IN ('0005', '0006')) AND (pn_aliq_red IS NOT null) THEN
    vc_valor_acordo := vc_valor_rec;
  END IF;

  pc_aux_erro := 'Registro 15 - tributo ' || pc_tp_tributo || ': erro na composição do registro 15...(ad. ' || pc_adicao_num || ')';
  SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_tributo
                   , XMLElement ("tributo"
                                , XMLForest (
                                     pc_tp_tributo                          AS "codigoReceitaImposto"
                                   , vc_tipo_aliquota                       AS "codigoTipoAliquotaIPT"
                                   , vc_regtrib_ipi                         AS "codigoTipoBeneficioIPI"
                                   , pc_tp_direito               AS "codigoTipoDireito"
                                   , LPad(NVL(vc_tp_recipiente,'0'),02,'0') AS "codigoTipoRecipiente"
                                   , RPad (vc_um_esp, 15)        AS "nomeUnidadeEspecificaAliquotaIPT"
                                   , LPad (vc_nc_tipi, 02, '0')             AS "numeroNotaComplementarTIPI"
                                   , Nvl(vc_aliq_acordo,00000)              AS "percentualAliquotaAcordoTarifario"
                                   , Nvl(vc_aliq_dev,00000)                 AS "percentualAliquotaNormalAdval"
                                   , Nvl(vc_aliq_red,00000)                 AS "percentualAliquotaReduzida"
                                   , Nvl(vc_perc_red,00000)                 AS "percentualReducaoIPT"
                                   , vc_ql_ml_recipiente                    AS "quantidadeMLRecipiente"
                                   , vc_qt_um_aliq_esp                      AS "quantidadeMercadoriaUnidadeAliquotaEspecifica"
                                   , vc_vr_aliq_esp                         AS "valorAliquotaEspecificaIPT"
                                   , vc_base_calculo                        AS "valorBaseCalculoAdval"
                                   , Nvl(vc_valor_acordo,000000000000000)   AS "valorCalculadoIIACTarifario"
                                   , vc_vrtotal_aliq_esp                    AS "valorCalculoIPTEspecifica"
                                   , vc_valor_tec                           AS "valorCalculoIptAdval"
                                   , vc_valor_rec                           AS "valorIPTaRecolher"
                                   , vc_valor_dev                           AS "valorImpostoDevido")))--.EXTRACT('*')
    INTO px_tributo
    FROM dual;

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, pc_aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_15;

PROCEDURE imp_prc_gera_reg_16 ( pc_ref_declaracao              VARCHAR2
                            , pn_declaracao_adi_id           NUMBER
                            , pn_tp_declaracao_id            NUMBER
                            , pc_adicao_num                  VARCHAR2
                            , pn_incoterm_id                 NUMBER
                            , pn_moeda_id                    NUMBER
                            , pd_data_taxa_conversao         DATE
                            , pc_aux_erro            IN OUT  VARCHAR2
                            , pb_sem_erro            IN OUT  BOOLEAN
                            , pn_evento_id                   NUMBER
                            , pn_empresa_id                  NUMBER
                            , px_mercadoria          IN OUT  XMLType
                            ) IS

  CURSOR cur_declaracoes_lin IS
    SELECT idl.linha_num_scx
         , idl.item_id
         , idl.qtde
         , idl.un_medida_id
         , idl.descricao
         , idl.preco_unitario_m
         , idl.fabric_part_number
         , nvl (ii.flag_fr_embutido, 'N') flag_fr_embutido
         , nvl (ii.flag_sg_embutido, 'N') flag_sg_embutido
         , ((iil.vrt_frivc_m  / iil.qtde) * idl.qtde) vrt_frivc_m
         , ((iil.vrt_dspfob_m / iil.qtde) * idl.qtde) vrt_dspfob_m
         , ((iil.vrt_fr_mn    / iil.qtde) * idl.qtde) vrt_fr_mn
         , ((iil.vrt_sg_mn    / iil.qtde) * idl.qtde) vrt_sg_mn
         , ((nvl(iil.vrt_desconto_pgto_impostos_m,0) / iil.qtde ) * idl.qtde) vr_desconto_m
         , (iil.vmle_mn       / iil.qtde) vmle_unit_mn
         , 0                              vmlc_unit_m_nac
         , 0                              vmle_unit_m_nac
         , idl.declaracao_lin_id
         , (SELECT nvl (cmx_pkg_tabelas.codigo (metodo_vr_aduaneiro_id), '01')
              FROM imp_declaracoes_adi ida
             WHERE ida.declaracao_adi_id = idl.declaracao_adi_id)              metodo_val_aduan
         , round (idl.vmlc_unit_m, 2)                                          vmlc_unit_m
      FROM imp_declaracoes_lin  idl
         , imp_invoices_lin     iil
         , imp_invoices         ii
     WHERE idl.declaracao_adi_id = pn_declaracao_adi_id
       AND iil.invoice_lin_id    = idl.invoice_lin_id
       AND ii.invoice_id         = iil.invoice_id
 UNION ALL
    SELECT idl.linha_num_scx
         , idl.item_id
         , idl.qtde
         , idl.un_medida_id
         , idl.descricao
         , idl.preco_unitario_m
         , idl.fabric_part_number
         , 'N' flag_fr_embutido
         , 'N' flag_sg_embutido
         , 0 vrt_frivc_m
         , 0 vrt_dspfob_m
         , 0 vrt_fr_mn
         , 0 vrt_sg_mn
         , 0 vr_desconto_m
         , idl.vmle_unit_mn vmle_unit_mn
         , idl.vmlc_unit_m  vmlc_unit_m_nac
         , idl.vmle_unit_m  vmle_unit_m_nac
         , idl.declaracao_lin_id
         , (SELECT nvl (cmx_pkg_tabelas.codigo (metodo_vr_aduaneiro_id), '01')
              FROM imp_declaracoes_adi ida
             WHERE ida.declaracao_adi_id = idl.declaracao_adi_id)              metodo_val_aduan
         , round (idl.vmlc_unit_m, 2)                                          vmlc_unit_m
      FROM imp_declaracoes_lin idl
     WHERE idl.declaracao_adi_id = pn_declaracao_adi_id
       AND idl.invoice_lin_id IS null -- Declarações de Nacionalização Recof não possuem invoice.
     ORDER BY 1;

  CURSOR cur_taxas IS
    SELECT ctx.taxa_mn
      FROM cmx_taxas   ctx
         , cmx_tabelas ctt
     WHERE Trunc (ctx.data)      = Trunc (pd_data_taxa_conversao)
       AND ctx.moeda_id  = pn_moeda_id
       AND ctt.tabela_id = ctx.tipo_id
       AND ctt.codigo    = 'FISCAL';

  vc_cd_item        cmx_itens.codigo%TYPE := null;

  vc_qtde           VARCHAR2(15)   := Null;
  vc_incoterm_aux1  VARCHAR2(120)  := null;
  vc_un_medida      VARCHAR2(20)   := Null;
  vc_vmlc_unit      VARCHAR2(20)   := Null;
  vc_vmle_unit      VARCHAR2(13)   := Null;

  vc_mercadoria19   VARCHAR2(4000);


  vn_taxa_mn         NUMBER := 0;
  vn_vmlc_unit       NUMBER := 0;
  vn_dif_frete       NUMBER := 0;

  vc_string         VARCHAR2(2000) := Null;
  vc_detMercadoria  VARCHAR2(32700) := NULL;

BEGIN

  pc_aux_erro := 'Registro 16: erro no cursor de taxas, detalhamento mercadoria... (ad. ' || pc_adicao_num || ')';
  OPEN  cur_taxas;
  FETCH cur_taxas INTO vn_taxa_mn;
  CLOSE cur_taxas;

  pc_aux_erro := 'Registro 16: erro na cursor das linhas da declaração... (ad. ' || pc_adicao_num || ')';
  px_mercadoria := NULL;
  FOR m In cur_declaracoes_lin LOOP
  	vc_cd_item   := cmx_pkg_itens.codigo (m.item_id);

    pc_aux_erro  := 'Registro 16: erro na conversão da quantidade do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';
    vc_qtde      := LPad( LTrim(NVL(To_Char(m.qtde,'999999999.99999'),'0')), 15,'0' );
    vc_qtde      := SubStr(vc_qtde,1,09) || SubStr(vc_qtde,11,5);

    pc_aux_erro  := 'Registro 16: erro na consulta da un.medida do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';
    vc_un_medida := substr(cmx_pkg_tabelas.descricao (m.un_medida_id),1,20);

    IF (m.metodo_val_aduan = '06') THEN
      pc_aux_erro  := 'Registro 16: erro na conversão do valor unitário na condição de venda (06) do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';
      vn_vmlc_unit  := NVL(m.vmlc_unit_m,0);
    ELSE
      /* O desconto estará com valor negativo, por isso iremos somalo */
      pc_aux_erro  := 'Registro 16: erro na conversão do valor unitário na condição de venda do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';
      vn_vmlc_unit  := ((NVL(m.preco_unitario_m,0) * m.qtde) + NVL(m.vr_desconto_m,0) + NVL(m.vrt_dspfob_m,0)) / m.qtde;

      pc_aux_erro  := 'Registro 16: erro no cálculo do vmlc unitário do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';
  	   IF nvl(vn_taxa_mn,0) > 0 THEN
        vc_incoterm_aux1 := cmx_pkg_tabelas.auxiliar (pn_incoterm_id,1);

        IF ( (INSTR(vc_incoterm_aux1,'F') <> 0) AND (m.flag_fr_embutido = 'N') ) THEN
         	vn_dif_frete := nvl(m.vrt_frivc_m,0) - nvl(  (m.vrt_fr_mn / vn_taxa_mn),0) ;
          vn_vmlc_unit := vn_vmlc_unit + ( (m.vrt_fr_mn / vn_taxa_mn) / m.qtde)  + (vn_dif_frete / m.qtde );
        END IF;

        IF ( (INSTR(vc_incoterm_aux1,'S') <> 0) AND (m.flag_sg_embutido = 'N') ) THEN
          vn_vmlc_unit := vn_vmlc_unit + ((m.vrt_sg_mn / vn_taxa_mn) / m.qtde);
        END IF;
      ELSE
        vn_vmlc_unit := 0;
      END IF;
    END IF; -- IF (m.metodo_val_aduan = '06') THEN

    pc_aux_erro  := 'Registro 16: erro na conversão do vmlc unitário do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';
    IF (cmx_pkg_tabelas.codigo(pn_tp_declaracao_id) <> '16') then
      vc_vmlc_unit   := LPad( LTrim(NVL(To_Char(vn_vmlc_unit,'999999999990.0000000'),'0')), 20,'0' );
      vc_vmlc_unit   := '0' || SubStr(vc_vmlc_unit,1,12) || SubStr(vc_vmlc_unit,14,7);
    ELSE
      vc_vmlc_unit   := LPad( LTrim(NVL(To_Char(m.vmlc_unit_m_nac,'999999999990.0000000'),'0')), 20,'0' );
      vc_vmlc_unit   := '0' || SubStr(vc_vmlc_unit,1,12) || SubStr(vc_vmlc_unit,14,7);
    END IF;

  	IF nvl(vn_taxa_mn,0) > 0 THEN
      pc_aux_erro  := 'Registro 16: erro na conversão do VMLE do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';
      vc_vmle_unit := LPad( LTrim(NVL(To_Char((m.vmle_unit_mn/vn_taxa_mn),'9999999990.00'),'0')), 13,'0' );
      vc_vmle_unit := '0' || SubStr(vc_vmle_unit,1,10) || SubStr(vc_vmle_unit,12,2);
    ELSE
      vc_vmle_unit := '0000000000000';
    END IF;

    pc_aux_erro := 'Registro 16: erro na composição do registro 16 do part number ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';

    imp_prc_gera_reg_19 ( pc_ref_declaracao
                        , pc_adicao_num
                        , vc_cd_item
                        , m.descricao
                        , m.fabric_part_number
                        , null
                        , pc_aux_erro
                        , pb_sem_erro
                        , pn_evento_id
                        , pn_empresa_id
                        , vc_mercadoria19
                        , m.declaracao_lin_id
                        );

    SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_mercadoria
                     , XMLElement ( "mercadoria"
                                  , XMLForest ( RPad( vc_un_medida, 20 ) AS "nomeUnidadeMedidaComercializada"
                                              , vc_qtde                           AS "quantidadeMercadoriaUnidadeComercializada"
                                              , vc_mercadoria19                   AS "textoDetalhamentoMercadoria"
                                              , vc_vmle_unit                      AS "valorUnidadeLocalEmbarque"
                                              , vc_vmlc_unit                      AS "valorUnidadeMedidaCondicaoVenda"
                                              )
                                  )
                     )--.EXTRACT('*')
      INTO px_mercadoria
      FROM dual;

    pc_aux_erro := 'Registro 16: erro nos parâmetros do registro 19 - p/n ' || vc_cd_item || '... (ad. ' || pc_adicao_num || ')';

  END LOOP;

  /*IF px_mercadoria IS NULL THEN
    SELECT XMLType ( '<mercadoria>'||
                        '<nomeUnidadeMedidaComercializada />'||
                        '<quantidadeMercadoriaUnidadeComercializada />'||
                        '<textoDetalhamentoMercadoria />'||
                        '<valorUnidadeLocalEmbarque />'||
                        '<valorUnidadeMedidaCondicaoVenda />'||
                     '</mercadoria>').EXTRACT('*')
     INTO px_mercadoria
     FROM dual;
  END IF;*/
  ---------------------------------------------------------
EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, pc_aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_16;

PROCEDURE imp_prc_gera_reg_19 ( pc_ref_declaracao              VARCHAR2
                              , pc_adicao_num                  VARCHAR2
                              , pc_cd_item                     VARCHAR2
                              , pc_descricao                   LONG
                              , pc_fabric_part_number          VARCHAR2
                              , p_eq_atributo1                 VARCHAR2
                              , aux_erro               IN OUT  VARCHAR2
                              , pb_sem_erro            IN OUT  BOOLEAN
                              , pn_evento_id                   NUMBER
                              , pn_empresa_id                  NUMBER
                              , pc_mercadoria19        IN OUT  VARCHAR2
                              , pn_declaracao_lin_id   IN      NUMBER
                              ) IS

  CURSOR cur_parametros IS
    SELECT part_number_proprio
         , part_number_fabricante
      FROM imp_empresas_param
     WHERE empresa_id = pn_empresa_id;

  CURSOR cur_existe_dsc_drw IS
    SELECT declaracao_lin_id
      FROM imp_declaracoes_lin_siscomex
     WHERE declaracao_lin_id = pn_declaracao_lin_id;

  --StrLinha                  VARCHAR2(10000) := replace (substr (pc_descricao, 1, 10000), chr (10), ' ');
  StrLinha                  VARCHAR2(10000) := replace(replace(substr(pc_descricao, 1, 10000), chr(10), ' '), chr(13), ' ');
  cDsc_Linha1               VARCHAR2(3900)  := null;
  cDsc_Linha2               VARCHAR2(3900)  := null;
  cPN                       VARCHAR2(310)   := null;
  cPNFab                    VARCHAR2(60)    := null;
  vc_string                 VARCHAR2(8000)  := null;
  produto_a_concatenar      VARCHAR2(300)   := null;
  vc_part_number_proprio    VARCHAR2(30)    := null;
  vc_part_number_fabricante VARCHAR2(30)    := null;
  vn_dummy                  NUMBER;
  vb_existe_dsc_drw         BOOLEAN         := FALSE;

BEGIN
  produto_a_concatenar := pc_cd_item;

  aux_erro := 'Registro 19: erro na concatenação da descrição do part number ' || pc_cd_item || '... (ad. ' || pc_adicao_num || ')';
  pc_mercadoria19 := imp_fnc_descricao_siscomex(pn_declaracao_lin_id, NULL, pn_empresa_id);

  IF(pc_mercadoria19 IS NOT NULL) THEN

    OPEN  cur_existe_dsc_drw;
    FETCH cur_existe_dsc_drw INTO vn_dummy;
    vb_existe_dsc_drw := cur_existe_dsc_drw%FOUND;
    CLOSE cur_existe_dsc_drw;

    IF (vb_existe_dsc_drw) THEN
      UPDATE imp_declaracoes_lin_siscomex
         SET descricao_siscomex = cDsc_Linha1 || cDsc_Linha2
       WHERE declaracao_lin_id = pn_declaracao_lin_id;
    ELSE
      INSERT INTO imp_declaracoes_lin_siscomex (
         declaracao_lin_id
       , descricao_siscomex
       )
      VALUES (
         pn_declaracao_lin_id
       , cDsc_Linha1 || cDsc_Linha2
      );
    END IF;

  END IF;

  IF pc_mercadoria19 IS NULL THEN
    pc_mercadoria19 := ' ';
  END IF;

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_19;

PROCEDURE imp_prc_gera_reg_18 ( pc_ref_declaracao              VARCHAR2
                              , pn_declaracao_adi_id           NUMBER
                              , pc_adicao_num                  VARCHAR2
                              , aux_erro               IN OUT  VARCHAR2
                              , pb_sem_erro            IN OUT  BOOLEAN
                              , pn_evento_id                   NUMBER
                              , px_acrescimo           IN OUT  XMLType
                              ) IS

  CURSOR cur_dcl_adi_acresded IS
    SELECT acres_ded_id, moeda_id, valor_m, valor_mn
      FROM imp_dcl_adi_acresded
     WHERE declaracao_adi_id = pn_declaracao_adi_id
       AND tp_acres_ded      = 'A';

  vc_cd_acrescimo   VARCHAR2(02)   := null;
  vc_moeda          VARCHAR2(03)   := null;
  vc_valor_m        VARCHAR2(15)   := null;
  vc_valor_mn       VARCHAR2(15)   := null;
  vc_string         VARCHAR2(2000) := null;

BEGIN

  aux_erro := 'Registro 18: erro na consulta dos acréscimos do valor aduaneiro... (ad. ' || pc_adicao_num || ')';
  px_acrescimo := NULL;
  FOR m IN cur_dcl_adi_acresded LOOP
    --:block1.PROCESSO := '(18) processando acréscimos valor aduaneiro...';
    --SYNCHRONIZE;

    aux_erro      := 'Registro 18: erro na conversão do código do acréscimo... (ad. ' || pc_adicao_num || ')';
    vc_cd_acrescimo := RPAD( rtrim(ltrim(to_char(to_number( SubStr(cmx_pkg_tabelas.codigo (m.acres_ded_id),1,2))))),2,' ') ;

    aux_erro      := 'Registro 18: erro na conversão da moeda do acréscimo... (ad. ' || pc_adicao_num || ')';
    vc_moeda      := SubStr(cmx_pkg_tabelas.auxiliar (m.moeda_id,1),1,3);

    aux_erro      := 'Registro 18: erro na conversão do valor do acréscimo... (ad. ' || pc_adicao_num || ')';
    vc_valor_m    := LPad( LTrim(NVL(To_Char(m.valor_m,'99999999990.00'),'0')), 15,'0' );
    vc_valor_m    := '0' || SubStr(vc_valor_m,1,12) || SubStr(vc_valor_m,14,2);

    aux_erro      := 'Registro 18: erro na conversão do valor em real do acréscimo... (ad. ' || pc_adicao_num || ')';
    vc_valor_mn   := LPad( LTrim(NVL(To_Char(m.valor_mn,'99999999990.00'),'0')), 15,'0' );
    vc_valor_mn   := '0' || SubStr(vc_valor_mn,1,12) || SubStr(vc_valor_mn,14,2);

    aux_erro      := 'Registro 18: erro na composição do registro 18... (ad. ' || pc_adicao_num || ')';

    SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_acrescimo
                     , XMLElement ( "acrescimo"
                                  , XMLForest ( RPad(vc_cd_acrescimo, 2, ' ') AS "codigoMetodoAcrescimoValor"
                                              , RPad( vc_moeda, 3 )  AS "codigoMoedaNegociadaAcrescimo"
                                              , vc_valor_mn                   AS "valorAcrescimoMoedaNacional"
                                              , vc_valor_m                    AS "valorAcrescimoMoedaNegociada"
                                              )
                                  )
                     )--.EXTRACT('*')
      INTO px_acrescimo
      FROM dual;

  END LOOP;

  /*IF px_acrescimo IS NULL THEN
    SELECT XMLType ('<acrescimo>'||
                      '<codigoMetodoAcrescimoValor />'||
                      '<codigoMoedaNegociadaAcrescimo />'||
                      '<valorAcrescimoMoedaNacional />'||
                      '<valorAcrescimoMoedaNegociada />'||
                   '</acrescimo>').EXTRACT('*')
      INTO px_acrescimo
      FROM dual;
  END IF;*/

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_18;

PROCEDURE imp_prc_gera_reg_17 ( pc_ref_declaracao              VARCHAR2
                            , pn_declaracao_adi_id           NUMBER
                            , pc_adicao_num                  VARCHAR2
                            , aux_erro               IN OUT  VARCHAR2
                            , pb_sem_erro            IN OUT  BOOLEAN
                            , pn_evento_id                   NUMBER
                            , px_deducao             IN OUT  XMLType
                            ) IS

  CURSOR cur_dcl_adi_acresded IS
    SELECT acres_ded_id, moeda_id, valor_m, valor_mn
      FROM imp_dcl_adi_acresded
     WHERE declaracao_adi_id = pn_declaracao_adi_id
       AND tp_acres_ded      = 'D';

  vc_cd_deducao   VARCHAR2(02)   := null;
  vc_moeda        VARCHAR2(03)   := null;
  vc_valor_m      VARCHAR2(15)   := null;
  vc_valor_mn     VARCHAR2(15)   := null;
  vc_string       VARCHAR2(2000) := null;

BEGIN
  aux_erro := 'Registro 17: erro no cursor das deduções do valor aduaneiro... (ad. ' || pc_adicao_num || ')';
  px_deducao := NULL;
  For m In cur_dcl_adi_acresded Loop

    aux_erro      := 'Registro 17: erro na conversão do código da dedução... (ad. ' || pc_adicao_num || ')';
    vc_cd_deducao := RPAD( rtrim(ltrim(to_char(to_number( SubStr(cmx_pkg_tabelas.codigo (m.acres_ded_id),1,2) )))),2,' ');

    aux_erro      := 'Registro 17: erro na conversão da moeda da dedução... (ad. ' || pc_adicao_num || ')';
    vc_moeda      := SubStr(cmx_pkg_tabelas.auxiliar (m.moeda_id,1),1,3);

    aux_erro      := 'Registro 17: erro na conversão do valor da dedução... (ad. ' || pc_adicao_num || ')';
    vc_valor_m    := LPad( LTrim(NVL(To_Char(m.valor_m,'99999999990.00'),'0')), 15,'0' );
    vc_valor_m    := '0' || SubStr(vc_valor_m,1,12) || SubStr(vc_valor_m,14,2);

    aux_erro      := 'Registro 17: erro na conversão do valor em real da dedução... (ad. ' || pc_adicao_num || ')';
    vc_valor_mn   := LPad( LTrim(NVL(To_Char(m.valor_mn,'99999999990.00'),'0')), 15,'0' );
    vc_valor_mn   := '0' || SubStr(vc_valor_mn,1,12) || SubStr(vc_valor_mn,14,2);

    aux_erro      := 'Registro 17: erro na composição do registro 17... (ad. ' || pc_adicao_num || ')';

    SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_deducao
                     , XMLElement ( "deducao"
                                  , XMLForest ( RPad(vc_cd_deducao, 2, ' ' ) AS "codigoMetodoDeducaoValor"
                                              , RPad( vc_moeda, 3 ) AS "codigoMoedaNegociadaDeducao"
                                              , vc_valor_mn                  AS "valorDeducaoMoedaNacional"
                                              , vc_valor_m                   AS "valorDeducaoMoedaNegociada"
                                              )
                                  )
                     )--.EXTRACT('*')
      INTO px_deducao
      FROM dual;
  END LOOP;

  /*IF px_deducao IS NULL THEN
    SELECT XMLType ('<deducao>'||
                      '<codigoMetodoDeducaoValor />'||
                      '<codigoMoedaNegociadaDeducao />'||
                      '<valorDeducaoMoedaNacional />'||
                      '<valorDeducaoMoedaNegociada />'||
                    '</deducao>').EXTRACT('*')
      INTO px_deducao
      FROM dual;
  END IF;*/

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_17;

PROCEDURE imp_prc_gera_reg_20 ( pc_ref_declaracao        VARCHAR2
                            , pn_declaracao_adi_id     NUMBER
                            , pc_adicao_num            VARCHAR2
                            , pc_aux_erro       IN OUT VARCHAR2
                            , pb_sem_erro       IN OUT BOOLEAN
                            , pn_evento_id                   NUMBER
                            , px_destaque       IN OUT XMLType
                            ) IS

  vc_destaque   VARCHAR2(03)   := null;
  vc_string     VARCHAR2(2000) := null;

  CURSOR cur_dcl_adi_destaque IS
    SELECT destaque
      FROM imp_dcl_adi_destaque
     WHERE declaracao_adi_id = pn_declaracao_adi_id;

BEGIN

  pc_aux_erro := 'Registro 20: erro no cursor de destaque NCM...(ad. ' || pc_adicao_num || ')';
  px_destaque := NULL;
  FOR dtq IN cur_dcl_adi_destaque LOOP
    pc_aux_erro := 'Registro 20: erro na conversão do destaque NCM...(ad. ' || pc_adicao_num || ')';
    vc_destaque := LPad( LTrim(To_Char(NVL(dtq.destaque,0))), 03,'0' );

    pc_aux_erro := 'Registro 20: erro na composição do registro 20...(ad. ' || pc_adicao_num || ')';

    SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_destaque
                     , XMLElement ( "destaque"
                                  , XMLForest (vc_destaque AS "numeroDestaqueNCM" )
                                  )
                     )--.EXTRACT('*')
      INTO px_destaque
      FROM dual;
  END LOOP;

  /*IF px_destaque IS NULL THEN
    SELECT XMLType ('<destaque>'||
                      '<numeroDestaqueNCM />'||
                    '</destaque>').EXTRACT('*')
      INTO px_destaque
      FROM dual;
  END IF;*/

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, pc_aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_20;

PROCEDURE imp_prc_gera_reg_21 ( pc_ref_declaracao             VARCHAR2
                            , pn_declaracao_adi_id          NUMBER
                            , pc_adicao_num                 VARCHAR2
                            , aux_erro              IN OUT  VARCHAR2
                            , pb_sem_erro           IN OUT  BOOLEAN
                            , pn_evento_id                  NUMBER
                            , px_documento          IN OUT  XMLType
                            ) IS

  tp_dcto    VARCHAR2(01)   := null;
  nr_dcto    VARCHAR2(15)   := null;
  vc_string  VARCHAR2(2000) := null;

  CURSOR cur_dcl_adi_docvinc IS
    SELECT tp_dcto, nr_dcto
      FROM imp_dcl_adi_docvinc
     WHERE declaracao_adi_id = pn_declaracao_adi_id
       AND ROWNUM <= 10;

BEGIN

  aux_erro    := 'Registro 21: erro no cursor do documento vinculado... (ad. ' || pc_adicao_num || ')';
  px_documento := NULL;
  FOR i IN cur_dcl_adi_docvinc LOOP
    aux_erro  := 'Registro 21: erro na conversão do tipo do documento vinculado... (ad. ' || pc_adicao_num || ')';
    tp_dcto   := LTrim(i.tp_dcto);
    aux_erro  := 'Registro 21: erro na conversão do nr. do documento vinculado... (ad. ' || pc_adicao_num || ')';
    nr_dcto   := LTrim(i.nr_dcto);

    aux_erro  := 'Registro 21: erro na composição do registro 21... (ad. ' || pc_adicao_num || ')';

    SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_documento
                     , XMLElement ( "documento"
                                  , XMLForest ( tp_dcto AS "codigoTipoDocumentoVinculado"
                                              , RPad( nr_dcto, 15 ) AS "numeroDocumentoVinculado"
                                              )
                                  )
                     )--.EXTRACT('*')
      INTO px_documento
      FROM dual;

  END LOOP;

  /*IF px_documento IS NULL THEN
    SELECT XMLType ('<documento>'||
                      '<codigoTipoDocumentoVinculado />'||
                      '<numeroDocumentoVinculado />'||
                   '</documento>').EXTRACT('*')
      INTO px_documento
      FROM dual;
  END IF;*/

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_21;

PROCEDURE imp_prc_gera_reg_22 ( pc_ref_declaracao             VARCHAR2
                            , pn_declaracao_adi_id          NUMBER
                            , pc_adicao_num                 VARCHAR2
                            , aux_erro              IN OUT  VARCHAR2
                            , pb_sem_erro           IN OUT  BOOLEAN
                            , pn_evento_id                  NUMBER
                            , px_valAduaneira       IN OUT  XMLType
                            ) IS

  CURSOR cur_dcl_adi_nve IS
    SELECT abrangencia, atributo, especificacao
      FROM imp_dcl_adi_nve
     WHERE declaracao_adi_id = pn_declaracao_adi_id;

BEGIN

  IF (pb_sem_erro) THEN
    aux_erro := 'Registro 22: erro na consulta da especificação NCM... (ad. ' || pc_adicao_num || ')';
    px_valAduaneira := NULL;
    FOR i In cur_dcl_adi_nve LOOP
      aux_erro := 'Registro 22: erro na criação do registro 22... (ad. ' || pc_adicao_num || ')';
      SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_valAduaneira, XMLElement ( "valoracaoAduaneira"
                                    , XMLForest ( To_Char(NVL(i.abrangencia,0))               AS "codigoAbrangenciaNCM"
                                                , RPad(i.atributo,2)                          AS "codigoAtributoNCM"
                                                , LPad(To_Char(NVL(i.especificacao,0)),4,'0') AS "codigoEspecificacaoNCM"
                                                )
                                    )
                       )--.EXTRACT('*')
        INTO px_valAduaneira
        FROM dual;
    END LOOP;
  END IF;

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_22;

PROCEDURE imp_prc_gera_reg_23 ( pc_ref_declaracao             VARCHAR2
                            , pn_declaracao_adi_id          NUMBER
                            , pc_adicao_num                 VARCHAR2
                            , aux_erro              IN OUT  VARCHAR2
                            , pb_sem_erro           IN OUT  BOOLEAN
                            , pn_evento_id                  NUMBER
                            , px_docMercosul        IN OUT  XMLType
                            ) IS

  CURSOR cur_informacoes_mercosul IS
    SELECT cert.nr_de_mercosul
         , cert.nr_re_inicial
         , cert.nr_re_final
         , cmx_pkg_tabelas.auxiliar ('902', cmx_pkg_tabelas.codigo (cert.pais_certificado_id), 1) pais_emissor
         , cert.nr_di_certificado
         , cert.nr_item_certificado
         , cert.qtde_um_mercosul
      FROM imp_declaracoes_adi  ida
         , imp_dcl_adi_mercosul cert
     WHERE cert.declaracao_adi_id = ida.declaracao_adi_id
       AND ida.declaracao_adi_id  = pn_declaracao_adi_id
     ORDER BY cert.nr_seq_de;

  vc_qt_um_est  VARCHAR2(15);

BEGIN
  IF (pb_sem_erro) THEN
    aux_erro := 'Registro 23: erro nas informacoes do certificado de origem mercosul... (ad. ' || pc_adicao_num || ')';
    px_docMercosul := NULL;
    FOR i In cur_informacoes_mercosul LOOP
      aux_erro     := 'Registro 23: erro na conversão da qtde.un.medida estatística... (ad. ' || pc_adicao_num || ')';
      vc_qt_um_est := rtrim (ltrim (to_char (nvl(i.qtde_um_mercosul, 0), '000000000d00000')));
      vc_qt_um_est := substr (vc_qt_um_est,1,9) || substr (vc_qt_um_est,11,5);

      aux_erro := 'Registro 23: erro na criação do registro 23... (ad. ' || pc_adicao_num || ')';
      SELECT imp_pkg_gera_xml_ep.MyXMLConcat  ( px_docMercosul
                        , XMLElement ( "documentoMercosul"
                                     , XMLForest ( rpad ( i.pais_emissor, 2 )          AS "codigoPaisCertificado"
                                                   , rpad (i.nr_de_mercosul, 16)                 AS "numeroDEADMercosul"
                                                   , rpad ( i.nr_di_certificado, 16)   AS "numeroDICertificado"
                                                   , rpad ( i.nr_item_certificado, 4 ) AS "numeroItemCertificado"
                                                   , rpad (i.nr_re_final, 4 )                    AS "numeroREADFinal"
                                                   , rpad (i.nr_re_inicial, 4 )                  AS "numeroREADInicial"
                                                   , vc_qt_um_est                                AS "quantidadeUnidadeMercosul"
                                                 )
                                     )
                      )
        INTO px_docMercosul
        FROM dual;
    END LOOP;
  END IF;

--  IF px_docMercosul IS NULL THEN
--    SELECT XMLType ('<documentoMercosul>'||
--                        '<codigoPaisCertificado />'||
--                        '<numeroDEADMercosul />'||
--                        '<numeroDICertificado />'||
--                        '<numeroItemCertificado />'||
--                        '<numeroREADFinal />'||
--                        '<numeroREADInicial />'||
--                        '<quantidadeUnidadeMercosul />'||
--                    '</documentoMercosul>').EXTRACT('*')
--      INTO px_docMercosul
--      FROM dual;
--  END IF;

EXCEPTION
   WHEN Others THEN
     cmx_prc_gera_log_erros (pn_evento_id, aux_erro || sqlerrm, 'E');
     pb_sem_erro := false;
END imp_prc_gera_reg_23;

FUNCTION imp_fnc_controla_numerarios ( pn_vrt_icms      NUMBER
                                     , pn_evento_id     NUMBER
                                     , pn_embarque_id   NUMBER
                                     , pn_declaracao_id NUMBER
                                     , pn_empresa_id    NUMBER
                                     ) RETURN BOOLEAN IS

  vn_auxiliar           NUMBER := 0;
  vb_achou_numerario    BOOLEAN := False;

  vn_valor_ii           NUMBER := 0;
  vn_valor_ipi          NUMBER := 0;
  vn_valor_txsiscomex   NUMBER := 0;

  vb_retorno            BOOLEAN := true;

  CURSOR cur_dgerais_darf (pc_cd_receita  VARCHAR2) IS
    SELECT idd.valor_mn
      FROM imp_dcl_darf  idd
         , cmx_tabelas   ct
     WHERE idd.declaracao_id = pn_declaracao_id
       AND ct.tabela_id      = idd.cd_receita_id
       AND ct.codigo         = pc_cd_receita;

   CURSOR cur_adiantamento (pc_cdfixo_numerario  VARCHAR2) IS
     SELECT 0
     FROM imp_vw_numerarios_ebq  ivne
        , cmx_tabelas            ctn
        , cmx_tabelas            ctc
     WHERE ivne.embarque_id = pn_embarque_id
       AND ctn.tabela_id    = ivne.cd_numerario_id
       AND ctn.auxiliar1    = pc_cdfixo_numerario
       AND ctc.tabela_id    = ivne.categoria_id
       AND ctc.codigo       = 'A';

BEGIN
  vb_retorno := true;

  OPEN  cur_dgerais_darf( '0086' ); --- I.I.
  FETCH cur_dgerais_darf INTO vn_valor_ii;
  CLOSE cur_dgerais_darf;

  IF (nvl(vn_valor_ii,0) > 0) THEN
    OPEN   cur_adiantamento( 'II' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario) THEN
      cmx_prc_gera_log_erros (pn_evento_id, 'I.I. não solicitado nos numerários, estr.própria abortada...'||sqlerrm, 'E');
      vb_retorno := false;
    END IF;
  END IF;

  OPEN  cur_dgerais_darf( '1038' ); --- I.P.I.
  FETCH cur_dgerais_darf INTO vn_valor_ipi;
  CLOSE cur_dgerais_darf;

  IF ( nvl(vn_valor_ipi,0) > 0 ) THEN
    OPEN  cur_adiantamento( 'IPI' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario ) THEN
       cmx_prc_gera_log_erros (pn_evento_id, 'I.P.I. não solicitado nos numerários, estr.própria abortada...'||sqlerrm, 'E');
       vb_retorno := false;
    END IF;
  END IF;

  OPEN  cur_dgerais_darf( '7811' ); --- TAXA SISCOMEX
  FETCH cur_dgerais_darf INTO vn_valor_txsiscomex;
  CLOSE cur_dgerais_darf;

  IF (nvl(vn_valor_txsiscomex,0) > 0) THEN
    OPEN  cur_adiantamento( 'TXSIS' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario) THEN
      cmx_prc_gera_log_erros (pn_evento_id, 'Taxa utilização siscomex não solicitada nos numerários, estr.própria abortada...'||sqlerrm, 'E');
      vb_retorno := false;
    END IF;
  END IF;

  IF ( nvl(pn_vrt_icms,0) > 0 ) THEN
    OPEN  cur_adiantamento( 'ICMS' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario) THEN
      cmx_prc_gera_log_erros (pn_evento_id, 'I.C.M.S. não solicitado nos numerários, estr.própria abortada...'||sqlerrm, 'E');
      vb_retorno := false;
    END IF;
  END IF;

  RETURN (vb_retorno);
END imp_fnc_controla_numerarios;

PROCEDURE imp_prc_gera_dsi_header ( pn_evento_id   NUMBER
                                  , pn_declaracao_id NUMBER
                                  , pn_empresa_id            NUMBER
                                  , pn_embarque_id           NUMBER
                                  , pc_embarque_num          VARCHAR2
                                  , pn_embarque_ano          NUMBER
                                  , pc_cnpj                  VARCHAR2
                                  , pc_nome                  VARCHAR2
                                  , pc_fone                  VARCHAR2
                                  , pc_endereco              VARCHAR2
                                  , pc_complemento_end       VARCHAR2
                                  , pc_bairro                VARCHAR2
                                  , pc_cidade                VARCHAR2
                                  , pn_uf_id                 NUMBER
                                  , pc_cep                   VARCHAR2
                                  , pc_cpf_repres_legal      VARCHAR2
                                  , pc_trading               VARCHAR2
                                  , pn_da_id                 NUMBER
                                  , pc_rg_tipo_transmissao   VARCHAR2
                                  , pc_nome_arquivo          VARCHAR2
                                  , pn_xml_id                NUMBER
                                  , pc_remover_memo_calc     VARCHAR2 DEFAULT 'N'
                                ) IS

  vn_nr_tributos        NUMBER;
  vc_aux_erro           VARCHAR2(1000) := null;
  vc_string             VARCHAR2(15000) := null;
  vb_sem_erro           BOOLEAN        := TRUE;

  ----------------------------------------------------------
  -- Informacoes Gerais da DSI - (01)
  ----------------------------------------------------------
  vc_ref_declaracao     VARCHAR2(15)  := null;
  vc_dt_geracao         VARCHAR2(10)  := null;
  vc_nat_operacao       VARCHAR2(02)  := null;
  vc_nr_adicoes         VARCHAR2(03)  := null;
  vc_imp_cnpj           VARCHAR2(14)  := null;
  vc_imp_nome           VARCHAR2(60)  := null;
  vc_imp_fone           VARCHAR2(15)  := null;
  vc_imp_endereco       VARCHAR2(40)  := null;
  vc_imp_nrendereco     VARCHAR2(06)  := null;
  vc_imp_complemento    VARCHAR2(21)  := null;
  vc_imp_bairro         VARCHAR2(25)  := null;
  vc_imp_cidade         VARCHAR2(25)  := null;
  vc_imp_uf             VARCHAR2(02)  := null;
  vc_imp_cep            VARCHAR2(08)  := null;
  vc_urfd               VARCHAR2(07)  := null;
  vc_pais_proc          VARCHAR2(03)  := null;
  vc_via_transp         VARCHAR2(02)  := null;
  vc_termo_entrada      VARCHAR2(15)  := null;
  vc_tp_conhec          VARCHAR2(02)  := null;
  vc_conhec_transp      VARCHAR2(40)  := null;
  vc_house              VARCHAR2(18)  := null;
  vc_master             VARCHAR2(18)  := null;
  vc_ident_cg           VARCHAR2(36)  := null;
  vc_dt_embarque        VARCHAR2(08)  := null;
  vc_dt_chegada         VARCHAR2(08)  := null;
  vc_peso_bruto         VARCHAR2(20)  := null;
  vc_peso_liquido       VARCHAR2(20)  := null;
  vc_recinto_alfand     VARCHAR2(07)  := null;
  vc_setor_alfand       VARCHAR2(03)  := null;
  vc_moeda_frete        VARCHAR2(03)  := null;
  vc_vrt_fr_m           VARCHAR2(15)  := null;
  vc_vrt_fr_mn          VARCHAR2(15)  := null;
  vc_moeda_seguro       VARCHAR2(03)  := null;
  vc_vrt_sg_m           VARCHAR2(15)  := null;
  vc_vrt_sg_mn          VARCHAR2(15)  := null;
  vc_vrt_sg_us          VARCHAR2(15)  := null;
  vc_vrt_vmle_mn        VARCHAR2(15)  := null;
  vc_vrt_vmle_us        VARCHAR2(15)  := null;
  vc_vrt_vmld_mn        VARCHAR2(15)  := null;
  vc_vrt_ii_dev         VARCHAR2(15)  := null;
  vc_vrt_ipi_dev        VARCHAR2(15)  := null;
  vc_vrt_ii_rec         VARCHAR2(15)  := null;
  vc_vrt_ipi_rec        VARCHAR2(15)  := null;
  vc_vrt_tributos_rec   VARCHAR2(15)  := null;
  vc_nrconta_deb_aut    VARCHAR2(19)  := null;
  vc_tpconta_deb_aut    VARCHAR2(01)  := null;

  vc_total_pis_calc     VARCHAR2(15)  := null;
  vc_total_cofins_calc  VARCHAr2(15)  := null;
  vc_total_pis_a_rec    VARCHAR2(15)  := null;
  vc_total_cofins_a_rec VARCHAR2(15)  := null;


  vc_inf_complementar   VARCHAR2(32700):= null;
  vc_inf_complementar_clob   CLOB;

  vn_fund_legal         NUMBER;
  vn_reg_pis_cofins_id  NUMBER;


  vn_declaracao_id      NUMBER;
  vn_qtde_bens          NUMBER;

  vc_envelope           CLOB := NULL;            --:= '<?xml version="1.0" encoding="utf-8"?>'||Chr(13);
  vc_blob               BLOB;
  vc_nome_arquivo       VARCHAR2(256);
  vn_offset             NUMBER;
  vn_blob_id            NUMBER;
  vn_evento_id          NUMBER;

  xml_dsi               XMLType;
  xml_bem               XMLType;
  xml_embalagem         XMLType;
  xml_tributo           XMLType;
  xml_pagamento         XMLType;
  ----------------------------------------------------------

  ----------------------------------------------------------
  -- Informacoes de volumes - (02)
  ----------------------------------------------------------
  vc_tp_embalagem       VARCHAR2(02) := null;
  vc_qt_embalagem       VARCHAR2(05) := null;
  ----------------------------------------------------------

  ----------------------------------------------------------
  -- Informacoes de pagamento de tributos - (03)
  ----------------------------------------------------------
  vc_cd_pgto            VARCHAR2(20)  := null;
  vc_cd_banco           VARCHAR2(03)  := null;
  vc_cd_agencia         VARCHAR2(05)  := null;
  vc_vrt_tributo        VARCHAR2(15)  := null;
  vc_dt_pgto_trib       VARCHAR2(08)  := null;
  vc_vrt_multa_trib     VARCHAR2(09)  := null;
  vc_vrt_juros_trib     VARCHAR2(09)  := null;
  ----------------------------------------------------------

  CURSOR cur_declaracoes IS
    SELECT id.tp_declaracao_id, id.creation_date       , id.empresa_id
         , id.urfd_id         , id.pais_proc_id        , ic.via_transporte_id
         , id.nr_manifesto    , ic.tp_conhecimento_id  , ic.master
         , ic.house           , ic.peso_bruto          , ic.peso_liquido
         , id.rec_alfand_id   , id.setor_armazem_id    , decode ( cmx_pkg_tabelas.codigo(ic.via_transporte_id)
																							                  , '04' -- AEREO
																							                  , decode( cmx_pkg_tabelas.codigo(ic.tp_conhecimento_id)
																							                          , '14' -- DSIC
																							                          , null
																							                          , ic.moeda_id
																							                          )
																							                  , ic.moeda_id
																							                  ) moeda_frete_id
         , id.vrt_fr_m        , id.vrt_fr_mn           , cmx_pkg_tabelas.auxiliar(ie.moeda_seguro_id,1) moeda_seguro_id
         , ie.vrt_sg_m        , ie.vrt_sg_mn           , id.vmle_mn
         , id.vrt_ii          , id.vrt_ipi             , id.vrt_icms
         , ic.conhec_id       , id.txt_inf_complementar, id.data_taxa_conversao
         , imp_fnc_busca_dt_cronog(id.embarque_id, 'EMBARQUE', 'R') data_embarque
         , imp_fnc_busca_dt_cronog(id.embarque_id, 'CHEGADA' , 'R') data_chegada
         , trib.vrt_ii_dev    , trib.vrt_ipi_dev
         , id.conta_id
         , id.banco_agencia_id
         , trib.vrt_pis_dev
         , id.vrt_pis
         , trib.vrt_cofins_dev
         , id.vrt_cofins
         , ic.presenca_carga
         , id.ul_dse_id
         , id.data_emissao_dse
         , id.nr_represent_legal
         , id.numero_dde
         , id.numero_dse
         , id.numero_processo_dde
         , id.declaracao_id
      FROM imp_declaracoes    id
         , imp_embarques      ie
         , imp_conhecimentos  ic
         , (SELECT sum(valor_ii_dev) vrt_ii_dev
                 , sum(valor_ipi_dev) vrt_ipi_dev
                 , sum(valor_pis_dev) vrt_pis_dev
                 , sum(valor_cofins_dev) vrt_cofins_dev
              FROM imp_declaracoes_lin
             WHERE declaracao_id = pn_declaracao_id) trib
     WHERE id.declaracao_id = pn_declaracao_id
       AND ie.embarque_id   = id.embarque_id
       AND ic.conhec_id     = ie.conhec_id;

  CURSOR cur_dcl_darf IS
    SELECT cd_receita_id
         , valor_mn
         , dt_pgto
         , vrmulta_mn
         , vrjuros_mn
      FROM imp_dcl_darf
     WHERE declaracao_id = pn_declaracao_id
     ORDER BY retif_sequencia, cd_receita_id;

  CURSOR cur_conhecimento_lin (pn_conhec_id  NUMBER) IS
    SELECT tp_embalagem_id
         , Sum (qtde) qtde
      FROM imp_conhecimentos_lin
     WHERE conhec_id = pn_conhec_id
     GROUP BY tp_embalagem_id;

  CURSOR cur_conta_deb_aut (pn_conta_id NUMBER) IS
    SELECT numero
      FROM cmx_bancos_agencias_cta
     WHERE conta_id = pn_conta_id;

  CURSOR cur_banco_deb_aut (pn_bco_agc_id NUMBER) IS
    SELECT SubStr(LPad( RTrim(LTrim( NVL(cd_banco_bacen, '0'))), 5,'0' ),3,3)
         , LPad( RTrim(LTrim(NVL(cd_agencia_bacen, '0'))), 4,'0' )
      FROM cmx_bancos_agencias
     WHERE banco_agencia_id = pn_bco_agc_id;


BEGIN
  vc_aux_erro := 'Erro nos dados gerais de embarque...';
  FOR i In cur_declaracoes LOOP

     vn_declaracao_id := i.declaracao_id;

     IF ( nvl(cmx_fnc_profile('IMP_CONTROLA_NUMER_IMPOSTOS'),'N') = 'S' ) THEN
          vb_sem_erro := imp_fnc_controla_numerarios( i.vrt_icms, pn_evento_id,pn_embarque_id, pn_declaracao_id, pn_empresa_id );
     END IF;

     ----------------------------------------------------------
     -- Informações Gerais da Declaração - (01)
     ----------------------------------------------------------
     vc_aux_erro := 'Erro na composição do número da declaração...';
     vc_ref_declaracao  := LPad(LTrim(pc_embarque_num),10,'0') || '/' ||
                           RPad(LTrim(To_Char(pn_embarque_ano)),04    );

     vc_aux_erro        := 'Erro na conversão do número de adições...';
     vc_nr_adicoes      := '000';
     vc_aux_erro        := 'Erro na conversão da data de geração do embarque...';
     vc_dt_geracao      := to_char(i.creation_date,'yyyymmdd');
     vc_aux_erro        := 'Erro na conversão do número de CNPJ do importador...';
     vc_imp_cnpj        := LPad( NVL(LTrim(SubStr(pc_CNPJ,1,14)),'0'), 14,'0' );
     vc_aux_erro        := 'Erro na conversão do nome do importador...';
     vc_imp_nome        := SubStr(pc_nome,1,60);
     vc_aux_erro        := 'Erro na conversão do telefone do importador...';
     vc_imp_fone        := SubStr(pc_fone,1,15);
     vc_aux_erro        := 'Erro na conversão do endereço do importador...';
     vc_imp_endereco    := SubStr(pc_endereco,1,40);
     vc_aux_erro        := 'Erro na conversão do número do endereço do importador...';
     vc_imp_nrendereco  := '      ';
     vc_aux_erro        := 'Erro na conversão do complemento do importador...';
     vc_imp_complemento := SubStr(pc_complemento_end,1,21);
     vc_aux_erro        := 'Erro na conversão do bairro do importador...';
     vc_imp_bairro      := SubStr(pc_bairro,1,25);
     vc_aux_erro        := 'Erro na conversão da cidade do importador...';
     vc_imp_cidade      := SubStr(pc_cidade,1,25);
     vc_aux_erro        := 'Erro na conversão da UF do importador...';
     vc_imp_uf          := SubStr(cmx_pkg_tabelas.codigo (pn_uf_id),1,02);
     vc_aux_erro        := 'Erro na conversão do CEP do importador...';
     vc_imp_cep         := LPad( NVL(SubStr(pc_cep,1,08), '0'), 08,'0' );
     vc_aux_erro        := 'Erro na conversão da natureza de operação da DSI...';
     vc_nat_operacao    := RPad( NVL(cmx_pkg_tabelas.codigo (i.tp_declaracao_id),'0'), 02,'0' );
     vc_aux_erro        := 'Erro na conversão da URFD...';
     vc_urfd            := LPad( NVL(cmx_pkg_tabelas.codigo (i.urfd_id),'0'), 07,'0' );
     vc_aux_erro        := 'Erro na conversão do país de procedência...';
     vc_pais_proc       := LPad( NVL(cmx_pkg_tabelas.codigo (i.pais_proc_id),'0'), 03,'0' );

     vc_aux_erro        := 'Erro na conversão da via de transporte...';
     vc_via_transp      := LPad( NVL(cmx_pkg_tabelas.codigo (i.via_transporte_id),'0'), 02,'0' );

     vc_aux_erro        := 'Erro na conversão do tipo do documento de transporte...';
     vc_tp_conhec       := LPad( NVL(cmx_pkg_tabelas.codigo (i.tp_conhecimento_id),'0'), 02,'0' );
     vc_aux_erro        := 'Erro na conversão da presença de carga...';
     vc_conhec_transp   := SubStr(i.presenca_carga,1,40);
     vc_aux_erro        := 'Erro na conversão do nr. doc. transporte filhote...';
     vc_house           := SubStr(i.house,1,18);
     vc_aux_erro        := 'Erro na conversão do nr. doc. transporte master...';
     vc_master          := SubStr(i.master,1,18);
     vc_aux_erro        := 'Erro na conversão da identificação da carga...';
     vc_ident_cg        := SubStr(i.presenca_carga,1,36);

     vc_aux_erro        := 'Erro na conversão da data de embarque...';
     vc_dt_embarque     := RPad( NVL(To_Char(i.data_embarque, 'yyyymmdd'),'0'), 8, '0' );

     vc_aux_erro        := 'Erro na conversão do peso bruto...';
     vc_peso_bruto      := LPad( LTrim(NVL(To_Char(i.peso_bruto,'9999999990.00000'),'0')), 16,'0' );
     vc_peso_bruto      := Substr( vc_peso_bruto, 1, 10 ) || Substr( vc_peso_bruto, 12, 5 );

     vc_aux_erro        := 'Erro na conversão do peso líquido...';
     vc_peso_liquido    := LPad( LTrim(NVL(To_Char(i.peso_liquido,'9999999990.00000'),'0')), 16,'0' );
     vc_peso_liquido    := Substr( vc_peso_liquido, 1, 10 ) || Substr( vc_peso_liquido, 12, 5 );

     vc_aux_erro        := 'Erro na conversão da data de chegada...';
     vc_dt_chegada      := RPad( NVL(To_Char(i.data_chegada, 'yyyymmdd'),'0'), 8,'0' );

     vc_aux_erro        := 'Erro na conversão do nr. do termo de entrada...';
     vc_termo_entrada   := SubStr(i.nr_manifesto,1,15);
     vc_aux_erro        := 'Erro na conversão do recinto alfandegário...';
     vc_recinto_alfand  := RPad( NVL(cmx_pkg_tabelas.codigo (i.rec_alfand_id),'0'), 07,'0' );


     vc_aux_erro        := 'Erro na conversão do setor alfandegário...';
     vc_setor_alfand    := LPad( NVL(cmx_pkg_tabelas.auxiliar (i.setor_armazem_id, 1),'0'), 03,'0' );
     vc_aux_erro        := 'Erro na conversão da moeda do frete...';
     vc_moeda_frete     := LPad( NVL(cmx_pkg_tabelas.auxiliar (i.moeda_frete_id,1),'0'), 03,'0' );

     vc_aux_erro        := 'Erro na conversão do frete total na moeda...';
     vc_vrt_fr_m        := lpad( ltrim( replace( replace( to_char( nvl( i.vrt_fr_m , 0),'999999999990.00') , ',' ,null), '.', null)), 15,'0' );

     vc_aux_erro        := 'Erro na conversão do frete total em reais...';
     vc_vrt_fr_mn       := lpad( ltrim( replace( replace( to_char( nvl( i.vrt_fr_mn , 0),'999999999990.00'), ',', null), '.', null)), 15,'0' );

     vc_aux_erro        := 'Erro na conversão da moeda do seguro...';
     vc_moeda_seguro    := i.moeda_seguro_id;--RPad( NVL(cmx_pkg_tabelas.auxiliar (i.moeda_seguro_id,1),'0'), 03,'0' );

     vc_aux_erro        := 'Erro na conversão do seguro...';
     vc_vrt_sg_m        := lpad( ltrim( nvl( replace( replace( to_char( i.vrt_sg_m, '999999999990.00' ),',',null),'.',null) ,'0') ), 15,'0' );

     vc_aux_erro        := 'Erro na conversão do seguro total...';
     vc_vrt_sg_mn       := lpad( ltrim( nvl( replace( replace( to_char(i.vrt_sg_mn, '999999999990.00' ),',',null),'.',null) ,'0') ), 15,'0' );
     vc_vrt_sg_us       := '00000000000';

     vc_aux_erro        := 'Erro na conversão do valor da mercadoria no local de embarque (VMLE)...';
     vc_vrt_vmle_mn     := lpad( ltrim( replace( replace( to_char( nvl(i.vmle_mn,0),'999999999990.00' ),',',null),'.',null) ), 15,'0' );

     vc_vrt_vmle_us     := '000000000000000';
     vc_vrt_vmld_mn     := '000000000000000';

     vc_aux_erro        := 'Erro no I.I. devido...';
     vc_vrt_ii_dev      := lpad( ltrim( replace( replace( to_char( nvl(i.vrt_ii_dev,0),  '999999999990.00'), ',',null),'.',null) ), 15, '0' );

     vc_aux_erro        := 'Erro no I.P.I. devido...';
     vc_vrt_ipi_dev     := lpad( ltrim( replace( replace( to_char( nvl(i.vrt_ipi_dev,0), '999999999990.00'), ',',null),'.',null) ), 15, '0' );

     vc_aux_erro        := 'Erro no I.I. a recolher...';
     vc_vrt_ii_rec      := lpad( ltrim( replace( replace( to_char( nvl(i.vrt_ii,0)     , '999999999990.00'), ',',null),'.',null) ), 15, '0' );

     vc_aux_erro        := 'Erro no I.P.I. a recolher...';
     vc_vrt_ipi_rec     := lpad( ltrim( replace( replace( to_char( nvl(i.vrt_ipi,0)    , '999999999990.00'), ',',null),'.',null) ), 15, '0' );

     vc_aux_erro         := 'Erro no somatório de tributos a recolher...';
     vc_vrt_tributos_rec := lpad( ltrim( replace( replace( to_char( nvl(i.vrt_ii,0)+nvl(i.vrt_ipi,0),'999999999990.00'), ',',null),'.',null) ), 15, '0' );


     vc_aux_erro         := 'Erro no valor do pis calc...';
     vc_total_pis_calc   := lpad( ltrim( replace( replace( to_char( i.vrt_pis_dev,'999999999990.00'), ',',null),'.',null) ), 15, '0' );

     vc_aux_erro          := 'Erro no valor do Cofins calc...';
     vc_total_cofins_calc := lpad( ltrim( replace( replace( to_char( i.vrt_cofins_dev,'999999999990.00'), ',',null),'.',null) ), 15, '0' );


     vc_aux_erro          := 'Erro no valor do Pis rec...';
     vc_total_pis_a_rec   := lpad( ltrim( replace( replace( to_char( i.vrt_pis,'999999999990.00'), ',',null),'.',null) ), 15, '0' );

     vc_aux_erro          := 'Erro no valor do Cofins recc...';
     vc_total_cofins_a_rec   := lpad( ltrim( replace( replace( to_char( i.vrt_cofins,'999999999990.00'), ',',null),'.',null) ), 15, '0' );

     vc_aux_erro := 'Erro no contador dos tributos...';
     SELECT count(*) INTO vn_nr_tributos
       FROM imp_dcl_darf
      WHERE declaracao_id = pn_declaracao_id;

     vc_aux_erro := 'Erro na conversão da conta bancário p/ débito dos tributos...';
     vc_tpconta_deb_aut := '1';
     IF ( NVL(vn_nr_tributos,0) > 0 ) THEN

       OPEN  cur_conta_deb_aut (i.conta_id);
     	 FETCH cur_conta_deb_aut INTO vc_nrconta_deb_aut;
       CLOSE cur_conta_deb_aut;

       vc_nrconta_deb_aut := LPad( NVL(vc_nrconta_deb_aut,'0'), 19,'0' );
     ELSE
       vc_nrconta_deb_aut := '0000000000000000000';

       IF ( i.conta_id IS null ) THEN
         vc_nrconta_deb_aut := null;
       END IF;
     END IF;

     vc_aux_erro := 'Erro na criação das informações complementares...';

--     vc_inf_complementar := substr ( 'N/REF.: ' || pc_embarque_num || '/' || pn_embarque_ano || '  ' ||
--           				         replace (	    imp_fnc_converte_inf_compl (
--												            i.txt_inf_complementar       -- pc_texto
--											              , pn_declaracao_id             -- pn_declaracao_id
--											              , pn_embarque_id               -- pn_embarque_id
--											              , null                         -- pn_licenca_id
--											              , null                         -- pn_nota_fiscal_id
--											              , 'N'                          -- pc_traduzir_apenas_curingas
--											              , pc_remover_memo_calc -- pc_remover_memo_calc
--											             )
--												            , chr (10)
--												            , ' '
--												            )
--										            , 1
--										            , 7800
--										            );

     /* Delivery 99650
        A informação complementar será tratada da mesma forma que na DI, não quebra mais com 7800 caracteres.
        Será validado a quantidade de caracteres de acordo com a profile IMP_INFCOMPL_MAXIMO_CARACTERES na tela imp_gera_ep_java_web
     */
     vc_inf_complementar := 'N/REF.: ' || pc_embarque_num || '/' || pn_embarque_ano
       				              || Chr(10) ||
                            imp_fnc_converte_inf_compl (
		   					            i.txt_inf_complementar         -- pc_texto
		   				              , pn_declaracao_id             -- pn_declaracao_id
		   				              , pn_embarque_id               -- pn_embarque_id
		   				              , null                         -- pn_licenca_id
		   				              , null                         -- pn_nota_fiscal_id
		   				              , 'N'                          -- pc_traduzir_apenas_curingas
		   				              , pc_remover_memo_calc         -- pc_remover_memo_calc
		   				             );

     vc_inf_complementar := dbms_xmlgen.convert (vc_inf_complementar,1);

     FOR vol IN cur_conhecimento_lin (i.conhec_id) LOOP
       vc_aux_erro := 'Erro na conversão do tipo de embalagem...';
       vc_tp_embalagem   := LPad( NVL(cmx_pkg_tabelas.codigo (vol.tp_embalagem_id), '0'),  02,'0' );
       vc_aux_erro := 'Erro na conversão da quantidade de embalagem...';
       vc_qt_embalagem   := LPad( NVL(To_Char(vol.qtde), '0'),  05,'0' );

       vc_aux_erro := 'Erro na criação do tipo 02...';
       SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( xml_embalagem
                        , XMLElement ( "embalagem"
                                     , XMLForest ( vc_tp_embalagem AS "codigoTipoEmbalagem"
                                     ,vc_qt_embalagem AS "quantidadeVolumeCarga")))--.EXTRACT('*')
         INTO xml_embalagem
         FROM dual;
       vc_string := ( '02' || rpad (vc_ref_declaracao, 15) || vc_tp_embalagem || vc_qt_embalagem );

     END LOOP;

     OPEN  cur_banco_deb_aut (i.banco_agencia_id);
     FETCH cur_banco_deb_aut INTO vc_cd_banco, vc_cd_agencia;
     CLOSE cur_banco_deb_aut;

     vc_aux_erro := 'Erro no cursor dos tributos (DARF)...';

     FOR pg IN cur_dcl_darf LOOP
       vc_aux_erro       := 'Erro na conversão do código do tributo...';
       vc_cd_pgto        := LPad( LTrim(NVL(substr(cmx_pkg_tabelas.codigo (pg.cd_receita_id),1,4), '0')), 4,'0' );

       vc_aux_erro       := 'Erro na conversão do valor do tributo...';
       vc_vrt_tributo    := lpad( ltrim( nvl( replace( replace( to_char( pg.valor_mn,'999999999990.00'), ',', null), '.', null) ,'0') ), 15, '0' );

       vc_dt_pgto_trib   := '00000000';

       vc_vrt_multa_trib := '000000000';
       vc_vrt_juros_trib := '000000000';

       vc_aux_erro := 'Erro na criação do tipo 03...';
       SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( xml_pagamento
                        , XMLElement ("pagamento"
                                     , XMLForest ( vc_cd_banco AS "codigoBanco"
                                                 , vc_cd_pgto AS "codigoReceita"
                                                 , vc_dt_pgto_trib AS "data"
                                                 , vc_cd_agencia AS "numeroAgencia"
                                                 , RPad( vc_nrconta_deb_aut, 19 ) AS "numeroConta"
                                                 , vc_vrt_tributo AS "valorTributo")))--.EXTRACT('*')
         INTO xml_pagamento
         FROM dual;

     END LOOP;

     imp_prc_gera_dsi_lines ( vc_moeda_frete
                            , i.data_taxa_conversao
                            , pn_evento_id
                            , vc_aux_erro
                            , vb_sem_erro
                            , pn_declaracao_id
                            , pn_empresa_id
                            , xml_bem
                            , vn_qtde_bens
                            , i.moeda_seguro_id
                            );


     vc_aux_erro := 'Erro na criação do tipo 01...';

     vc_inf_complementar_clob := vc_inf_complementar;

     DECLARE
      vx_aux1 xmltype;
      vx_aux2 xmltype;
      vx_aux3 xmltype;
      vx_aux_final xmltype;

     BEGIN

     vc_aux_erro := 'Montando XML <declaracao>.aux1...';
     SELECT XMLForest ( cmx_pkg_tabelas.codigo(i.ul_dse_id)                                   AS "codigoLocalDeclaracaoSimplificadaExportacao"
                      , vc_urfd                                                               AS "codigoLocalDespacho"
                      , vc_moeda_frete                                                        AS "codigoMoedaFrete"
                      , vc_moeda_seguro                                                       AS "codigoMoedaSeguro"
                      , vc_nat_operacao                                                       AS "codigoNaturezaOperacao"
                      , ''                                                                    AS "codigoPaisImportador"
                      , vc_pais_proc                                                          AS "codigoPaisProcedenciaCarga"
                      , vc_recinto_alfand                                                     AS "codigoRecintoAlfandegado"
                      , vc_setor_alfand                                                       AS "codigoSetorArmazenamento"
                      , vc_tp_conhec                                                          AS "codigoTipoDocumentoCarga"
                      , '1'                                                                   AS "codigoTipoImportador"
                      , vc_tpconta_deb_aut                                                    AS "codigoTipoPagamentoTributo"
                      , vc_via_transp                                                         AS "codigoViaTransporteCarga"
                      , i.data_emissao_dse                                                    AS "dataDeclaracaoSimplificadaExportacao"
                      , vc_dt_embarque                                                        AS "dataEmbarque"
                      , vc_dt_chegada                                                         AS "dataEmissaoConhecimento")
       INTO vx_aux1
       FROM dual;

     vc_aux_erro := 'Montando XML <declaracao>.aux2...';
     SELECT XMLForest ( RPad( vc_imp_bairro    , 25 )                                AS "enderecoBairroImportador"
                      , vc_imp_cep                                                            AS "enderecoCEPImportador"
                      , RPad( vc_imp_complemento, 21 )                              AS "enderecoComplementoImportador"
                      , RPad( vc_imp_endereco   , 40 )                              AS "enderecoLogradouroImportador"
                      , RPad( vc_imp_cidade     , 25 )                              AS "enderecoMunicipioImportador"
                      , RPad( vc_imp_nrendereco, 06 )                                AS "enderecoNumeroImportador"
                      , RPad( vc_imp_uf        , 02 )                                AS "enderecoUFImportador"
                      , RPad(vc_ref_declaracao          , 15 )                                AS "identificacaoDeclaracaoSimplificadaImportacao"
                      , vc_inf_complementar_clob                                              AS "informacoesComplementares"
                      , RPad( vc_imp_nome       , 60 )                              AS "nomeImportador"
                      , pc_cpf_repres_legal                                                   AS "numeroCPFRepresentanteLegal"
                      , i.numero_dde                                                          AS "numeroDeclaracaoExportacao"
                      , i.numero_dse                                                          AS "numeroDeclaracaoSimplificadaExportacao"
                      , RPad( vc_house         , 11 )                                AS "numeroDocumentoCargaHouse"
                      , RPad( vc_master         , 11 )                              AS "numeroDocumentoCargaMaster"
                      , '00000000000000'                                                      AS "numeroEmpresaDeclarante"
                      , RPad( vc_ident_cg      , 36 )                                AS "numeroIdentidadeCarga"
                      , vc_imp_cnpj                                                           AS "numeroImportador"
                      , nvl (pc_rg_tipo_transmissao, '1')                                     AS "numeroMotivoTransmissao"
                      , i.numero_processo_dde                                                 AS "numeroProcessoDeclaracaoExportacao"
                      , RPad( vc_imp_fone      , 15 )                                AS "numeroTelefoneImportador"
                      , RPad( vc_termo_entrada , 9 )                                 AS "numeroTermoEntrada")
        INTO vx_aux2
        FROM dual;

     vc_aux_erro := 'Montando XML <declaracao>.aux3...';
     SELECT XMLForest ( vc_peso_bruto                                                         AS "pesoBrutoCarga"
                      , vc_peso_liquido                                                       AS "pesoLiquidoCarga"
                      , vn_qtde_bens                                                          AS "quantidadeBem"
                      , vc_total_cofins_a_rec                                                 AS "valorTotalCofinsARecolher"
                      , vc_total_cofins_calc                                                  AS "valorTotalCofinsCalculado"
                      , vc_vrt_fr_mn                                                          AS "valorTotalFreteMoedaNacional"
                      , vc_vrt_fr_m                                                           AS "valorTotalFreteMoedaNegociada"
                      , vc_vrt_ii_rec                                                         AS "valorTotalIIARecolher"
                      , vc_vrt_ii_dev                                                         AS "valorTotalIICalculado"
                      , vc_vrt_ipi_rec                                                        AS "valorTotalIPIARecolher"
                      , vc_vrt_ipi_dev                                                        AS "valorTotalIPICalculado"
                      , vc_vrt_vmld_mn                                                        AS "valorTotalMercadoriaLocalDescargaMoedaNacional"
                      , vc_vrt_vmle_us                                                        AS "valorTotalMercadoriaLocalEmbarqueDolar"
                      , vc_vrt_vmle_mn                                                        AS "valorTotalMercadoriaLocalEmbarqueMoedaNacional"
                      , vc_total_pis_a_rec                                                    AS "valorTotalPisARecolher"
                      , vc_total_pis_calc                                                     AS "valorTotalPisCalculado"
                      , vc_vrt_sg_us                                                          AS "valorTotalSeguroDolar"
                      , vc_vrt_sg_mn                                                          AS "valorTotalSeguroMoedaNacional"
                      , vc_vrt_sg_m                                                           AS "valorTotalSeguroMoedaNegociada"
                      , vc_vrt_tributos_rec                                                   AS "valorTotalTributoARecolher")
        INTO vx_aux3
        FROM dual;

     vc_aux_erro := 'Montando XML <declaracao>.aux_final';
     SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( xml_bem
                                            , vx_aux1
                                            , xml_embalagem
                                            , vx_aux2
                                            , xml_pagamento
                                            , vx_aux3)
       INTO vx_aux_final
       FROM dual;

     vc_aux_erro := 'Montando XML <declaracao>.';
     SELECT imp_pkg_gera_xml_ep.MyXMLElement( 'declaracao', vx_aux_final )
       INTO xml_dsi
       FROM dual;

     /*SELECT imp_pkg_gera_xml_ep.XMLElement( 'declaracao', imp_pkg_gera_xml_ep.MyXMLConcat ( xml_bem
                                                , XMLForest ( cmx_pkg_tabelas.codigo(i.ul_dse_id)                                   AS "codigoLocalDeclaracaoSimplificadaExportacao"
                                                            , vc_urfd                                                               AS "codigoLocalDespacho"
                                                            , vc_moeda_frete                                                        AS "codigoMoedaFrete"
                                                            , vc_moeda_seguro                                                       AS "codigoMoedaSeguro"
                                                            , vc_nat_operacao                                                       AS "codigoNaturezaOperacao"
                                                            , ''                                                                    AS "codigoPaisImportador"
                                                            , vc_pais_proc                                                          AS "codigoPaisProcedenciaCarga"
                                                            , vc_recinto_alfand                                                     AS "codigoRecintoAlfandegado"
                                                            , vc_setor_alfand                                                       AS "codigoSetorArmazenamento"
                                                            , vc_tp_conhec                                                          AS "codigoTipoDocumentoCarga"
                                                            , '1'                                                                   AS "codigoTipoImportador"
                                                            , vc_tpconta_deb_aut                                                    AS "codigoTipoPagamentoTributo"
                                                            , vc_via_transp                                                         AS "codigoViaTransporteCarga"
                                                            , i.data_emissao_dse                                                    AS "dataDeclaracaoSimplificadaExportacao"
                                                            , vc_dt_embarque                                                        AS "dataEmbarque"
                                                            , vc_dt_chegada                                                         AS "dataEmissaoConhecimento")
                                                , xml_embalagem
                                                , XMLForest ( RPad( NVL(vc_imp_bairro    ,' '), 25 )                                AS "enderecoBairroImportador"
                                                            , vc_imp_cep                                                            AS "enderecoCEPImportador"
                                                            , RPad( NVL(vc_imp_complemento, ' '), 21 )                              AS "enderecoComplementoImportador"
                                                            , RPad( NVL(vc_imp_endereco   , ' '), 40 )                              AS "enderecoLogradouroImportador"
                                                            , RPad( NVL(vc_imp_cidade     , ' '), 25 )                              AS "enderecoMunicipioImportador"
                                                            , RPad( NVL(vc_imp_nrendereco,' '), 06 )                                AS "enderecoNumeroImportador"
                                                            , RPad( NVL(vc_imp_uf        ,' '), 02 )                                AS "enderecoUFImportador"
                                                            , RPad(vc_ref_declaracao          , 15 )                                AS "identificacaoDeclaracaoSimplificadaImportacao"
                                                            --, AS "indicadorRepresentanteServidor"
                                                            , vc_inf_complementar_clob                                              AS "informacoesComplementares"
                                                            , RPad( NVL(vc_imp_nome       , ' '), 60 )                              AS "nomeImportador"
                                                            , pc_cpf_repres_legal                                                   AS "numeroCPFRepresentanteLegal"
                                                            , i.numero_dde                                                          AS "numeroDeclaracaoExportacao"
                                                            , i.numero_dse                                                          AS "numeroDeclaracaoSimplificadaExportacao"
                                                            , RPad( NVL(vc_house         ,' '), 11 )                                AS "numeroDocumentoCargaHouse"
                                                            , RPad( NVL(vc_master         , ' '), 11 )                              AS "numeroDocumentoCargaMaster"
                                                            , '00000000000000'                                                      AS "numeroEmpresaDeclarante"
                                                            , RPad( NVL(vc_ident_cg      ,' '), 36 )                                AS "numeroIdentidadeCarga"
                                                            , vc_imp_cnpj                                                           AS "numeroImportador"
                                                            , nvl (pc_rg_tipo_transmissao, '1')                                     AS "numeroMotivoTransmissao"
                                                            , i.numero_processo_dde                                                 AS "numeroProcessoDeclaracaoExportacao"
                                                            , RPad( NVL(vc_imp_fone      ,' '), 15 )                                AS "numeroTelefoneImportador"
                                                            , RPad( NVL(vc_termo_entrada ,' '), 9 )                                 AS "numeroTermoEntrada")
                                                , xml_pagamento
                                                , XMLForest ( vc_peso_bruto                                                         AS "pesoBrutoCarga"
                                                            , vc_peso_liquido                                                       AS "pesoLiquidoCarga"
                                                            , vn_qtde_bens                                                          AS "quantidadeBem"
                                                            , vc_total_cofins_a_rec                                                 AS "valorTotalCofinsARecolher"
                                                            , vc_total_cofins_calc                                                  AS "valorTotalCofinsCalculado"
                                                            , vc_vrt_fr_mn                                                          AS "valorTotalFreteMoedaNacional"
                                                            , vc_vrt_fr_m                                                           AS "valorTotalFreteMoedaNegociada"
                                                            , vc_vrt_ii_rec                                                         AS "valorTotalIIARecolher"
                                                            , vc_vrt_ii_dev                                                         AS "valorTotalIICalculado"
                                                            , vc_vrt_ipi_rec                                                        AS "valorTotalIPIARecolher"
                                                            , vc_vrt_ipi_dev                                                        AS "valorTotalIPICalculado"
                                                            , vc_vrt_vmld_mn                                                        AS "valorTotalMercadoriaLocalDescargaMoedaNacional"
                                                            , vc_vrt_vmle_us                                                        AS "valorTotalMercadoriaLocalEmbarqueDolar"
                                                            , vc_vrt_vmle_mn                                                        AS "valorTotalMercadoriaLocalEmbarqueMoedaNacional"
                                                            , vc_total_pis_a_rec                                                    AS "valorTotalPisARecolher"
                                                            , vc_total_pis_calc                                                     AS "valorTotalPisCalculado"
                                                            , vc_vrt_sg_us                                                          AS "valorTotalSeguroDolar"
                                                            , vc_vrt_sg_mn                                                          AS "valorTotalSeguroMoedaNacional"
                                                            , vc_vrt_sg_m                                                           AS "valorTotalSeguroMoedaNegociada"
                                                            , vc_vrt_tributos_rec                                                   AS "valorTotalTributoARecolher")))--.EXTRACT('*')
       INTO xml_dsi
       FROM dual;*/

      END;

      vn_offset := 1;
      vc_envelope := ' ';
      WHILE ( vn_offset <= dbms_lob.getlength(xml_dsi.getclobval()) ) LOOP

        dbms_lob.append(vc_envelope,  DBMS_LOB.SUBSTR( xml_dsi.getclobval(), 2048, vn_offset));

        vn_offset    := vn_offset    + 2048;

      END LOOP;
  END LOOP;

  INSERT INTO cmx_xml_ep_tmp VALUES ( pn_xml_id
                                    , vc_envelope);
   COMMIT;

  --BEGIN
     --vn_blob_id := cmx_fnc_clob_to_blob_base64(vc_envelope,pc_nome_arquivo,vn_evento_id);
     /*DELETE cmx_blob;
     INSERT INTO cmx_blob VALUES (vc_envelope);
     COMMIT;*/
     /*vc_blob := cmx_fnc_clob_to_blob(vc_envelope);
      vc_nome_arquivo := pn_nome_arquivo;
      INSERT INTO cmx_tmp_blob (tmp_blob_id, imagem, nome_arquivo, tamanho_arquivo_orig)
      VALUES (cmx_tmp_blob_sq1.NEXTVAL, vc_blob, vc_nome_arquivo,Length(vc_blob));
      --INSERT INTO cmx_xml_ep_tmp VALUES (vc_envelope);
      COMMIT */
   --END;

EXCEPTION
  WHEN others THEN
    IF ( vc_aux_erro is not null ) THEN
      cmx_prc_gera_log_erros(pn_evento_id, vc_aux_erro || sqlerrm, 'E');
      vb_sem_erro := false;
    ELSE
      cmx_prc_gera_log_erros(pn_evento_id, sqlerrm, 'E');
      vb_sem_erro := false;
    END IF;

    --:block1.PROCESSO := null;
    --SYNCHRONIZE;
END imp_prc_gera_dsi_header;

PROCEDURE imp_prc_gera_dsi_lines (
   pc_moeda_frete              VARCHAR2
 , pd_dt_tx_conversao          DATE
 , pn_evento_id                NUMBER
 , aux_erro            IN OUT  VARCHAR2
 , pb_sem_erro         IN OUT  BOOLEAN
 , pn_declaracao_id            NUMBER
 , pn_empresa_id               NUMBER
 , xml_bem             IN OUT  XMLType
 , pn_qtde_bens        IN OUT  NUMBER
 , pc_moeda_seguro_id          VARCHAR2
) IS

  CURSOR cur_declaracoes_lin IS
    SELECT il.nr_registro
         , idl.declaracao_lin_id
         , idl.declaracao_id
         , ida.declaracao_adi_id
         , ida.regtrib_ii_id
         , ida.fundamento_legal_id
         , ida.motivo_trib_simpl_dsi_id
         , ida.tp_classificacao
         , ida.class_fiscal_id
         , idl.un_medida_id
         , idl.pais_origem_id
         , ida.material_usado
         , ida.dsi_mercosul
         , idl.pesoliq_tot
         , idl.pesobrt_tot
         , idl.basecalc_ii
         , ida.moeda_id
         , ((iil.vrt_fr_m  / iil.qtde) * idl.qtde) vrt_fr_m
         , idl.qtde
         , ((iil.vrt_sg_m  / iil.qtde) * idl.qtde) vrt_sg_m
         , idl.item_id
         , ((iil.vrt_fr_mn / iil.qtde) * idl.qtde) vrt_fr_mn
         , idl.linha_num
         , ((iil.vrt_sg_mn / iil.qtde) * idl.qtde) vrt_sg_mn
         , idl.descricao
         , ((iil.vmle_mn   / iil.qtde) * idl.qtde) vmle_mn
         , ida.aliq_ii_dev
         , idl.aliq_ii_rec
         , idl.valor_ii_dev
         , idl.valor_ii
         , ida.aliq_ipi_dev
         , idl.aliq_ipi_rec
         , idl.valor_ipi_dev
         , idl.valor_ipi
         , idl.licenca_id
         , idl.licenca_lin_id
         , idl.fabric_part_number
         , idad.destaque
         , idl.basecalc_ipi
         , ((iil.vmle_us   / iil.qtde) * idl.qtde) vmle_us
         , ida.qtde_um_estatistica
         , ida.regtrib_icms_id
         , ida.aliq_icms
         , ida.aliq_icms_red
         , ida.perc_red_icms
         , ida.aliq_icms_fecp
         , cmx_pkg_tabelas.codigo(ida.fundamento_legal_icms_id) fundamento_legal_icms
         , ida.valor_icms_dev
         , cmx_pkg_tabelas.auxiliar(ida.regtrib_pis_cofins_id,1) regtrib_pis_cofins
         , ida.aliq_pis
         , ida.aliq_cofins
         , ida.perc_reducao_base_pis_cofins
         , substr (cmx_pkg_tabelas.codigo(ida.fundamento_legal_pis_cofins_id), 1, 2) fundamento_legal_pis_cofins
         , ida.basecalc_pis_cofins_tec
         , ida.aliq_pis_Dev
         , ida.aliq_cofins_dev
         , ida.valor_pis_dev
         , ida.valor_cofins_dev
         , ida.valor_pis
         , ida.valor_cofins
         , ida.basecalc_pis_cofins
      FROM imp_invoices_lin     iil
         , imp_declaracoes_lin  idl
         , imp_declaracoes_adi  ida
         , imp_dcl_adi_destaque idad
         , imp_licencas         il
     WHERE idl.declaracao_id         = pn_declaracao_id
       AND ida.declaracao_adi_id     = idl.declaracao_adi_id
       AND il.licenca_id(+)          = idl.licenca_id
       AND iil.invoice_lin_id        = idl.invoice_lin_id
       AND idad.declaracao_adi_id(+) = ida.declaracao_adi_id
  ORDER BY idl.linha_num;

  CURSOR cur_tab_simpl (pn_class_fiscal_id  NUMBER) IS
    SELECT codigo, descricao
      FROM imp_trib_simplificada
     WHERE trib_simplificada_id = pn_class_fiscal_id;

  CURSOR cur_NCM (pn_class_fiscal_id  NUMBER) IS
    SELECT ctn.codigo, ctn.descricao, ct.descricao
      FROM cmx_tab_ncm  ctn
         , cmx_tabelas  ct
     WHERE ctn.ncm_id      = pn_class_fiscal_id
       AND ct.tabela_id(+) = ctn.un_medida_id;

  CURSOR cur_mercosul (pc_pais_origem VARCHAR2) IS
    SELECT 'S'
      FROM cmx_tabelas
     WHERE tipo = '903' and codigo = pc_pais_origem;

  CURSOR cur_taxa (pn_moeda_id imp_declaracoes_adi.moeda_id%TYPE) IS
    SELECT ctx.taxa_mn
      FROM cmx_taxas   ctx
         , cmx_tabelas ctt
     WHERE ctx.data      = pd_dt_tx_conversao
       AND ctx.moeda_id  = pn_moeda_id
       AND ctt.tabela_id = ctx.tipo_id
       AND ctt.codigo    = 'FISCAL';

  CURSOR cur_parametros IS
    SELECT part_number_proprio
         , part_number_fabricante
         , incidir_perc_red_aliq_icms_pc
      FROM imp_empresas_param
     WHERE empresa_id = pn_empresa_id;

 --CURSOR cur_adi (pn_declaracao_id NUMBER) IS
 --  SELECT adi.declaracao_adi_id
 --       , adi.fundamento_legal_pis_cofins_id
 --       , adi.regtrib_pis_cofins_id
 --       , des.destaque
 --    FROM imp_declaracoes_adi adi
 --       , imp_dcl_adi_destaque des
 --   WHERE adi.declaracao_adi_id = des.declaracao_adi_id
 --     AND adi.declaracao_id = pn_declaracao_id;

 --CURSOR cur_class1 ( pn_declaracao_id NUMBER
 --                  , pn_declaracao_adi_id NUMBER) IS
 --    SELECT cmx_pkg_tabelas.codigo(class_fiscal_id)
 --      FROM imp_declaracoes_adi
 --     WHERE declaracao_id = pn_declaracao_id
 --       AND declaracao_adi_id = pn_declaracao_adi_id
 --       AND tp_classificacao = '1';
 --
 --CURSOR cur_class2 ( pn_declaracao_id NUMBER
 --                  , pn_declaracao_adi_id NUMBER) IS
 --    SELECT cmx_pkg_tabelas.codigo(class_fiscal_id)
 --      FROM imp_declaracoes_adi
 --     WHERE declaracao_id = pn_declaracao_id
 --       AND declaracao_adi_id = pn_declaracao_adi_id
 --       AND tp_classificacao = '2';


 --vc_adi                cur_adi%ROWTYPE;

  --------------------------------------------------------------------------
  -- Informacoes das linhas - (02)
  --------------------------------------------------------------------------
  vc_linha_num         VARCHAR2(03)  := null;   vc_licenca             VARCHAR2(10)   := null;
  vc_regtrib           VARCHAR2(01)  := null;   vc_fundamento_legal    VARCHAR2(02)   := null;
  vc_motivo_tsp        VARCHAR2(02)  := null;   vc_tp_classificacao    VARCHAR2(01)   := null;
  vc_class_fiscal      VARCHAR2(08)  := null;   vc_destaque            VARCHAR2(03)   := null;
  vc_class_fiscal_dsc  VARCHAR2(120) := null;   vc_pais_origem         VARCHAR2(03)   := null;
  vc_mercosul          VARCHAR2(01)  := null;   vc_material_usado      VARCHAR2(01)   := null;
  vc_un_medida_est     VARCHAR2(20)  := null;   vc_qtde_un_medida_est  VARCHAR2(15)   := null;
  vc_un_medida         VARCHAR2(150) := null;   vc_quantidade          VARCHAR2(15)   := null;
  vc_peso_bruto        VARCHAR2(20)  := null;   vc_peso_liquido        VARCHAR2(20)   := null;
  vc_vmle_unit_m       VARCHAR2(15)  := null;   vc_vmle_m              VARCHAR2(15)   := null;
  vc_moeda             VARCHAR2(03)  := null;   vc_vraduaneiro_mn      VARCHAR2(15)   := null;
  vc_vrt_fr_m          VARCHAR2(15)  := null;   vc_moeda_frete         VARCHAR2(03)   := null;
  vc_vrt_sg_m          VARCHAR2(15)  := NULL;
  vc_vrt_fr_mn         VARCHAR2(15)  := null;   vc_vrt_sg_us           VARCHAR2(15)   := null;
  vc_vrt_sg_mn         VARCHAR2(15)  := null;   vc_vmle_us             VARCHAR2(15)   := null;
  vc_vmle_mn           VARCHAR2(15)  := null;   vc_descricao           VARCHAR2(7800) := null;

  vc_aliq_icms_pis_cofins      VARCHAR2(05);

  vn_aliq_icms                 NUMBER;
  vn_dummy                     NUMBER;
  vc_regime_tributar_piscofins VARCHAR2(01);
  vc_fund_leg_regime_piscofins VARCHAR2(02);
  vc_class_fiscal1             NUMBER;
  vc_class_fiscal2             VARCHAR2(30);

  --------------------------------------------------------------------------

  --------------------------------------------------------------------------
  -- Informacoes de tributos das linhas - (05)
  --------------------------------------------------------------------------
  vc_aliq_ii_dev         VARCHAR2(06)  := null;
  vc_aliq_ii_rec         VARCHAR2(06)  := null;
  vc_valor_ii_dev        VARCHAR2(15)  := null;
  vc_valor_ii_rec        VARCHAR2(15)  := null;
  vc_basecalc_ii         VARCHAR2(15)  := null;
  vc_aliq_ipi_dev        VARCHAR2(06)  := null;
  vc_aliq_ipi_rec        VARCHAR2(06)  := null;
  vc_valor_ipi_dev       VARCHAR2(15)  := null;
  vc_valor_ipi_rec       VARCHAR2(15)  := null;
  vc_basecalc_ipi        VARCHAR2(15)  := null;

  vc_basecalc_pis_cofins VARCHAR2(15) := null;
  vc_aliq_pis            VARCHAR2(05) := null;
  vc_valor_pis_dev       VARCHAR2(15) := null;
  vc_valor_pis           VARCHAR2(15) := null;
  vc_aliq_cofins         VARCHAR2(05) := null;
  vc_valor_cofins_dev    VARCHAR2(15) := null;
  vc_valor_cofins        VARCHAR2(15) := null;

  xml_tributos           XMLType;

  --------------------------------------------------------------------------

  vn_vmle_unit_m            NUMBER                     := null;
  vn_vmle_m                 NUMBER                     := null;
  vn_taxa_m_mn              NUMBER                     := null;
  cPN                       VARCHAR2(100)              := null;
  cPNFab                    VARCHAR2(100)              := null;
  cStr                      VARCHAR2(9800)             := null;
  vc_part_number_proprio    VARCHAR2(30)               := null;
  vc_part_number_fabricante VARCHAR2(30)               := null;
  vc_cd_produto             CMX_ITENS.CODIGO%Type      := null;
  vc_un_medida_scx          CMX_TABELAS.DESCRICAO%TYPE := null;
  vc_incide_icms_pc         imp_empresas_param.incidir_perc_red_aliq_icms_pc%TYPE;

BEGIN

  pn_qtde_bens := 0;

  aux_erro := 'Erro na consulta das linhas...';
  FOR i IN cur_declaracoes_lin LOOP
    vc_linha_num        := null;      vc_licenca            := null;
    vc_regtrib          := null;      vc_fundamento_legal   := null;
    vc_motivo_tsp       := null;      vc_tp_classificacao   := null;
    vc_class_fiscal     := null;      vc_destaque           := null;
    vc_class_fiscal_dsc := null;      vc_pais_origem        := null;
    vc_mercosul         := null;      vc_material_usado     := null;
    vc_un_medida_est    := null;      vc_qtde_un_medida_est := null;
    vc_un_medida        := null;      vc_quantidade         := null;
    vc_peso_bruto       := null;      vc_peso_liquido       := null;
    vc_vmle_unit_m      := null;      vc_vmle_m             := null;
    vc_moeda            := null;      vc_vraduaneiro_mn     := null;
    vc_vrt_fr_m         := null;      vc_moeda_frete        := null;
    vc_vrt_sg_m         := null;
    vc_vrt_fr_mn        := null;      vc_vrt_sg_us          := null;
    vc_vrt_sg_mn        := null;      vc_vmle_us            := null;
    vc_vmle_mn          := null;      vc_descricao          := null;

    aux_erro            := 'Erro na conversão do nr. da linha...';
    vc_linha_num        := LPad( NVL(to_char(i.linha_num),'0'), 03,'0' );
    aux_erro            := 'Erro na conversão do número de L.I...';
    vc_licenca          := LPad( NVL(i.nr_registro, '0'), 10,'0' );
    aux_erro            := 'Erro na conversão do regime tributação...';
    vc_regtrib          := NVL(cmx_pkg_tabelas.codigo(i.regtrib_ii_id),'0');
    aux_erro            := 'Erro na conversão do fundamento legal...';
    vc_fundamento_legal := LPad( NVL(cmx_pkg_tabelas.codigo(i.fundamento_legal_id), '0'), 02,'0' );
    aux_erro            := 'Erro na conversão do motivo para TSP...';
    vc_motivo_tsp       := LPad( NVL(cmx_pkg_tabelas.auxiliar (i.motivo_trib_simpl_dsi_id, 1), '0'), 02,'0' );
    aux_erro            := 'Erro na conversão do tipo de classIFicação...';
    vc_tp_classificacao := NVL(i.tp_classificacao, '0');

    aux_erro := 'Erro na consulta da un.medida do siscomex...';
    vc_class_fiscal_dsc := null;
    vc_un_medida_scx    := null;
    vc_class_fiscal1    := '';
    vc_class_fiscal2    := '';

    IF (vc_tp_classificacao = '1') THEN
      OPEN cur_NCM (i.class_fiscal_id);
      FETCH cur_NCM INTO vc_class_fiscal1, vc_class_fiscal_dsc, vc_un_medida_scx;
      CLOSE cur_NCM;
    ELSE
      OPEN cur_tab_simpl (i.class_fiscal_id);
      FETCH cur_tab_simpl INTO vc_class_fiscal2, vc_class_fiscal_dsc;
      CLOSE cur_tab_simpl;
    END IF;

    aux_erro            := 'Erro na conversão da classificação...';
    vc_class_fiscal     := LPad( NVL(vc_class_fiscal,'0'), 08,'0' );
    aux_erro            := 'Erro na conversão do destaque...';
    vc_destaque         := SubStr( i.destaque,1,03 );
    aux_erro            := 'Erro na conversão da descrição do TSP...';
    vc_class_fiscal_dsc := SubStr( vc_class_fiscal_dsc, 1,120 );
    aux_erro            := 'Erro na conversão do país de procedência...';
    vc_pais_origem      := LPad( NVL(cmx_pkg_tabelas.codigo(i.pais_origem_id),'0'), 03,'0' );

    vc_mercosul := null;

  --  IF ( NVL(i.dsi_mercosul,'N') = 'N' ) THEN
  --       vc_mercosul := '0';
  --  ELSE
  --       vc_mercosul := '1';
  --  END IF;

    aux_erro := 'Erro na conversão do atributo de material usado...';
    --IF ( NVL(i.material_usado,'N') = 'N' ) THEN
    --     vc_material_usado := '0';
    --ELSE
    --     vc_material_usado := '1';
    --END IF;

    aux_erro        := 'Erro na consulta da descrição da unid.medida...';
    vc_un_medida    := RPad(Trim(cmx_pkg_tabelas.descricao(i.un_medida_id)), 20 );

    aux_erro        := 'Erro na conversão da quantidade...';
    vc_quantidade   := lpad( ltrim( nvl( replace( replace( to_char( i.qtde,'999999999.99999' ), ',' , null), '.', null), '0' ) ), 14, '0' );

    aux_erro        := 'Erro na conversão do peso líquido...';
    vc_peso_liquido := lpad( ltrim( nvl( to_char(i.pesoliq_tot,'9999999999.99999'),'0')), 16,'0' );
    vc_peso_liquido := Substr( vc_peso_liquido, 1, 10 ) || Substr( vc_peso_liquido, 12, 5 );

    aux_erro := 'Erro na conversão da qtde.un.medida estatística...';

    vc_qtde_un_medida_est := lpad( nvl( ltrim( replace( replace(to_char(i.qtde_um_estatistica,'9999990.00000'), ',' , null ), '.', null) ),'0'), 14,'0' );

    vc_un_medida_est   := SubStr( vc_un_medida_scx, 1,20 );

    aux_erro           := 'Erro na conversão do peso bruto...';
    -- Na digitação manual, o siscomex nao grava peso bruto, portanto, nao devemos enviá-lo no arquivo texto. Murilo/ANDre 21.03.2001
    vc_peso_bruto      := LPad( LTrim(NVL(To_Char(0,'9999999999.99999'),'0')), 16,'0' );
    vc_peso_bruto      := Substr( vc_peso_bruto, 1, 10 ) || Substr( vc_peso_bruto, 12, 5 );

    OPEN  cur_taxa (i.moeda_id);
    FETCH cur_taxa INTO vn_taxa_m_mn;
    CLOSE cur_taxa;

    vn_vmle_m := ROUND(i.vmle_mn / vn_taxa_m_mn, 2);

    aux_erro          := 'Erro na conversão do VMLE unitário...';
    vc_vmle_unit_m    := lpad( ltrim( nvl( replace( replace( to_char( (vn_vmle_m/i.qtde), '9999999999.99'),',',null) ,'.',null) , '0')), 13,'0' );

    aux_erro          := 'Erro na conversão do VMLE na moeda...';
    vc_vmle_m         := lpad( ltrim( nvl( replace( replace( to_char( vn_vmle_m         , '999999999999.99'),',',null) ,'.',null) , '0')), 15,'0' );

    aux_erro          := 'Erro na conversão da moeda...';
    vc_moeda          := lpad( nvl(cmx_pkg_tabelas.auxiliar (i.moeda_id, 1),'0'), 03,'0' );

    aux_erro          := 'Erro na conversão do valor aduaneiro em reais...';
    vc_vraduaneiro_mn := lpad( ltrim( nvl( replace( replace( to_char(i.basecalc_ii      , '9999999999.99'),',',null) ,'.',null) ,'0')), 13,'0' );

    aux_erro          := 'Erro na conversão do frete internacional total...';
    vc_vrt_fr_m       := lpad( ltrim( nvl( replace( replace( to_char(i.vrt_fr_m         , '999999999999.99'),',',null) ,'.',null) ,'0')), 15,'0' );

    vc_vrt_sg_m       := lpad( ltrim( nvl( replace( replace( to_char(i.vrt_sg_m         , '999999999999.99'),',',null) ,'.',null) ,'0')), 15,'0' );

    aux_erro          := 'Erro na conversão da moeda do frete...';
    vc_moeda_frete    := LPad( NVL(pc_moeda_frete,'0'), 03,'0' );

    aux_erro          := 'Erro na conversão do frete em real...';
    vc_vrt_fr_mn      := lpad( ltrim( nvl( replace( replace( to_char(i.vrt_fr_mn        , '999999999999.99'),',',null) ,'.',null) ,'0')), 15,'0' );

    aux_erro          := 'Erro na conversão do seguro total em dolar...';
    vc_vrt_sg_us      := '00000000000';

    aux_erro          := 'Erro na conversão do seguro em real...';
    vc_vrt_sg_mn      := lpad( ltrim( nvl( replace( replace( to_char((i.vrt_sg_mn)       ,'999999999999.99'),',',null) ,'.',null) ,'0')), 15,'0' );

    aux_erro      := 'Erro na conversão do VMLE em dolar...';
    vc_vmle_us    := lpad( ltrim( nvl( replace( replace( to_char(i.vmle_us,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );

    aux_erro      := 'Erro na conversão do VMLE em reais...';
    vc_vmle_mn    := lpad( ltrim( nvl( replace( replace( to_char(i.vmle_mn,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );

    aux_erro      := 'Erro na conversão da descrição da linha...';
    --vc_descricao  := SUBSTR(i.descricao,1,7800);
    vc_descricao  := replace(replace(substr(i.descricao, 1, 7800), chr(10), ' '), chr(13), ' ');

    vc_cd_produto := cmx_pkg_itens.codigo (i.item_id);

    OPEN  cur_parametros;
    FETCH cur_parametros INTO vc_part_number_proprio
                            , vc_part_number_fabricante
                            , vc_incide_icms_pc;
    CLOSE cur_parametros;

    aux_erro := 'Erro na conversão do part NUMBER ' || vc_cd_produto || '...';
    IF  (vc_cd_produto IS NOT null)
    AND (vc_part_number_proprio IS NOT null)
    THEN
      cPN    := '   (' || vc_part_number_proprio || ' ' || RTrim(LTrim(imp_fnc_formata_item(pn_empresa_id, vc_cd_produto))) || ')';
    END IF;

    IF  (RTrim(LTrim(i.fabric_part_number)) IS NOT null)
    AND (vc_part_number_fabricante IS NOT null)
    THEN
      cPNFab := '   (' || vc_part_number_fabricante || ' ' || RTrim(LTrim(i.fabric_part_number)) || ')';
    END IF;

    aux_erro := 'Erro na concatenação da descrição do part NUMBER ' || vc_cd_produto || '...';
    IF    ( (RTrim(LTrim(cPN)) is not null) AND (RTrim(LTrim(cPNFab)) is null) ) THEN
      aux_erro := 'Erro na concatenação do part NUMBER: ' || cPN || '...';
      vc_descricao := RTrim(SubStr( vc_descricao, 1,(3900-NVL(length(cPN), 0)) )) || cPN;
    ELSIF ( (RTrim(LTrim(cPN)) is null) AND (RTrim(LTrim(cPNFab)) is not null) ) THEN
      aux_erro := 'Erro na concatenação do part NUMBER: ' || cPNFab || '...';
      vc_descricao := RTrim(SubStr( vc_descricao, 1,(3900-NVL(length(cPNFab), 0)) )) || cPNFab;
    ELSIF ( (RTrim(LTrim(cPN)) is not null) AND (RTrim(LTrim(cPNFab)) is not null) ) THEN
      aux_erro := 'Erro na concatenação do part NUMBER: ' || cPN || cPNFab || '...';
      vc_descricao := RTrim(SubStr( vc_descricao, 1,(3900-NVL(length(cPN||cPNFab), 0)) )) || cPN || cPNFab;
    END IF;

    aux_erro := 'Erro na busca da alíquota de ICMS para PIS/Cofins do part NUMBER ' || vc_cd_produto || '...';
    -- Alteração PIS/COFINS calculo no SISCOMEX
    imp_pkg_calcula_pis_cofins.calcula_aliquota_icms ( i.aliq_icms
                                  , i.aliq_icms_red
                                  , i.perc_red_icms
                                  , i.aliq_icms_fecp
                                  , i.regtrib_icms_id
                                  , vc_incide_icms_pc
                                  , vn_aliq_icms
                                  , vn_dummy
                                  );

    aux_erro := 'Erro na formatação da alíquota de ICMS para PIS/Cofins do part NUMBER ' || vc_cd_produto || '...';
    -- vc_aliq_icms_pis_cofins      := replace(ltrim(rtrim(to_char( vn_aliq_icms,'000D00','NLS_NUMERIC_CHARACTERS=,.') )),',',null );
    -- vc_fund_legal_red_icms    := i.fundamento_legal_icms;
       vc_aliq_icms_pis_cofins  := '00000';

    aux_erro := 'Erro na formatação do regime de tributação de PIS/Cofins do part NUMBER ' || vc_cd_produto || '...';
    vc_regime_tributar_piscofins := i.regtrib_pis_cofins;

    aux_erro := 'Erro na formatação do fund. legal de PIS/Cofins do part NUMBER ' || vc_cd_produto || '... (fundamento: ' || i.fundamento_legal_pis_cofins || ')' ;
    vc_fund_leg_regime_piscofins := i.fundamento_legal_pis_cofins;

    aux_erro         := 'Erro na conversão da aliq.II dev do part NUMBER ' || vc_cd_produto || '...';
    vc_aliq_ii_dev   := lpad( ltrim( nvl( replace( replace( to_char(i.aliq_ii_dev ,          '999.99'), ',',null), '.',null) ,'0')), 06,'0' );
    aux_erro         := 'Erro na conversão da aliq.II rec do part NUMBER ' || vc_cd_produto || '...';
    vc_aliq_ii_rec   := lpad( ltrim( nvl( replace( replace( to_char(i.aliq_ii_rec ,          '999.99'), ',',null), '.',null) ,'0')), 06,'0' );
    aux_erro         := 'Erro na conversão do vr.devido II do part NUMBER ' || vc_cd_produto || '...';
    vc_valor_ii_dev  := lpad( ltrim( nvl( replace( replace( to_char(i.valor_ii_dev, '999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro         := 'Erro na conversão do vr.recolher II do part NUMBER ' || vc_cd_produto || '...';
    vc_valor_ii_rec  := lpad( ltrim( nvl( replace( replace( to_char(i.valor_ii    , '999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro         := 'Erro na conversão da base calc. II do part NUMBER ' || vc_cd_produto || '...';
    vc_basecalc_ii   := lpad( ltrim( nvl( replace( replace( to_char(i.basecalc_ii , '999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro         := 'Erro na conversão da aliq.IPI dev do part NUMBER ' || vc_cd_produto || '...';
    vc_aliq_ipi_dev  := lpad( ltrim( nvl( replace( replace( to_char(i.aliq_ipi_dev,          '999.99'), ',',null), '.',null) ,'0')), 06,'0' );
    aux_erro         := 'Erro na conversão da aliq.IPI rec do part NUMBER ' || vc_cd_produto || '...';
    vc_aliq_ipi_rec  := lpad( ltrim( nvl( replace( replace( to_char(i.aliq_ipi_rec,          '999.99'), ',',null), '.',null) ,'0')), 06,'0' );
    aux_erro         := 'Erro na conversão do vr.devido IPI do part NUMBER ' || vc_cd_produto || '...';
    vc_valor_ipi_dev := lpad( ltrim( nvl( replace( replace( to_char(i.valor_ipi_dev,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro         := 'Erro na conversão do vr.recolher IPI do part NUMBER ' || vc_cd_produto || '...';
    vc_valor_ipi_rec := lpad( ltrim( nvl( replace( replace( to_char(i.valor_ipi    ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro         := 'Erro na conversão da base calc. IPI do part NUMBER ' || vc_cd_produto || '...';
    vc_basecalc_ipi  := lpad( ltrim( nvl( replace( replace( to_char(i.basecalc_ipi ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );

    aux_erro         := 'Erro na conversão da base calc. IPI do part NUMBER ' || vc_cd_produto || '...';
    vc_basecalc_ipi  := lpad( ltrim( nvl( replace( replace( to_char(i.basecalc_ipi ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );

    aux_erro         := 'Erro na conversão da base calc. PIS/COFINS...';
    vc_basecalc_pis_cofins := lpad( ltrim( nvl( replace( replace( to_char(i.basecalc_pis_cofins ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );

    aux_erro            := 'Erro na conversão da aliq. PIS...';
    vc_aliq_pis         := lpad( ltrim( nvl( replace( replace( to_char(i.aliq_pis_dev   ,         '999.99'), ',',null), '.',null) ,'0')), 05,'0' );
    aux_erro            := 'Erro na conversão do PIS Dev...';
    vc_valor_pis_dev    := lpad( ltrim( nvl( replace( replace( to_char(i.valor_pis_dev  ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro            := 'Erro na conversão do PIS Rec...';
    vc_valor_pis        := lpad( ltrim( nvl( replace( replace( to_char(i.valor_pis      ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro            := 'Erro na conversão da aliq. Cofins...';
    vc_aliq_cofins      := lpad( ltrim( nvl( replace( replace( to_char(i.aliq_cofins_dev,          '999.99'), ',',null), '.',null) ,'0')), 05,'0' );
    aux_erro            := 'Erro na conversão do Cofins Dev...';
    vc_valor_cofins_dev := lpad( ltrim( nvl( replace( replace( to_char(i.valor_cofins_dev,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );
    aux_erro            := 'Erro na conversão do Cofins Rec...';
    vc_valor_cofins     := lpad( ltrim( nvl( replace( replace( to_char(i.valor_cofins    ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' );

    --OPEN cur_adi(i.declaracao_id);
    --FETCH cur_adi INTO vc_adi;
    --CLOSE cur_adi;

    aux_erro := 'Erro na busca de dados de Classificação Fiscal...';

    --OPEN cur_class1(i.declaracao_id,i.declaracao_adi_id);
    --IF cur_class1%FOUND THEN
    --  FETCH cur_class1 into vc_class_fiscal1;
    --ELSE
    --  vc_class_fiscal1 := '';
    --END IF;
    --CLOSE cur_class1;
    --
    --OPEN cur_class2(i.declaracao_id,i.declaracao_adi_id);
    --IF cur_class2%FOUND THEN
    --  FETCH cur_class2 into vc_class_fiscal2;
    --ELSE
    --  vc_class_fiscal2 := '';
    --END IF;
    --CLOSE cur_class2;

    aux_erro := 'Erro na criação dos tributos das linhas...';
    imp_prc_tributos(i.declaracao_id, i.declaracao_lin_id, xml_tributos);

    aux_erro := 'Erro na criação das linhas...';

    DECLARE
      vx_linha_aux1 xmltype;
      vx_linha_aux2 xmltype;
      vx_aux_final  xmltype;
    BEGIN
    aux_erro := 'Montando XML <bem>.aux1';
    SELECT XMLForest( vc_fundamento_legal                           AS "codigoFundamentoLegalRegime"
                    , i.fundamento_legal_pis_cofins                                       AS "codigoFundamentoLegalRegimePisCofins"
                    , vc_class_fiscal1                                                    AS "codigoMercadoriaNcm"
                    , vc_class_fiscal2                                                    AS "codigoMercadoriaNes"
                    , vc_moeda_frete                                                      AS "codigoMoedaFreteMercadoria"
                    , vc_moeda                                                            AS "codigoMoedaNegociada"
                    , pc_moeda_seguro_id                                                  AS "codigoMoedaSeguroMercadoria"
                    , vc_motivo_tsp                                                       AS "codigoMotivoFundamentoLegal"
                    , vc_pais_origem                                                      AS "codigoPaisOrigemMercadoria"
                    , vc_regtrib                                                          AS "codigoRegimeTributario"
                    , i.regtrib_pis_cofins                                                AS "codigoRegimeTributarioPisCofins"
                    --, Nvl(vc_descricao,' ')                                               AS "descricaoDetalhadaMercadoria"
                    , RPad( vc_descricao, 3900 )                                 AS "descricaoDetalhadaMercadoria"
                    , i.material_usado                                                    AS "indicadorMaterialUsado"
                    , NVL(i.dsi_mercosul,'N')                                             AS "indicadorMercosul"
                    , vc_un_medida                                                        AS "nomeUnidadeMedidaComercial"
                    , vc_linha_num                                                        AS "numeroBemUsuario"
                    , RPad( vc_destaque, 03 )                                    AS "numeroDestaqueNcm"
                    , vc_licenca                                                          AS "numeroOperacaoTratamentoPrevio"
                    , vc_peso_bruto                                                       AS "pesoBrutoBem"
                    , vc_peso_liquido                                                     AS "pesoLiquidoBem"
                    , vc_quantidade                                                       AS "quantidadeMercadoriaUnidadeComercial"
                    , vc_qtde_un_medida_est                                               AS "quantidadeUnidadeEstatistica")
      INTO vx_linha_aux1
      FROM dual;

    aux_erro := 'Montando XML <bem>.aux2';
    SELECT XMLForest( RPad( vc_un_medida_est, 20 )          AS "unidadeMedidaEstatistica"
                    , vc_vraduaneiro_mn                              AS "valorAduaneiro"
                    , vc_vrt_fr_mn                                   AS "valorFreteMercadoriaMoedaNacional"
                    , vc_vrt_fr_m                                    AS "valorFreteMercadoriaMoedaNegociada"
                    , vc_vmle_mn                                     AS "valorMercadoriaEmbarqueMoedaNacional"
                    , vc_vrt_sg_us                                   AS "valorSeguroMercadoriaDolar"
                    , vc_vrt_sg_mn                                   AS "valorSeguroMercadoriaMoedaNacional"
                    , vc_vrt_sg_m                                    AS "valorSeguroMercadoriaMoedaNegociada"
                    , vc_vmle_unit_m                                 AS "valorUnidadeLocalEmbarque")
      INTO vx_linha_aux2
      FROM dual;

    aux_erro := 'Montando XML <bem>.aux_final';
    SELECT imp_pkg_gera_xml_ep.MyXMLConcat( vx_linha_aux1
                                          , xml_tributos
                                          , vx_linha_aux2)
      INTO vx_aux_final
      FROM dual;

    aux_erro := 'Montando XML <bem>.';
    SELECT imp_pkg_gera_xml_ep.MyXMLConcat( xml_bem
                                          , imp_pkg_gera_xml_ep.MyXMLElement('bem', vx_aux_final)
                                          )
      INTO xml_bem
      FROM dual;

    END;
    /*SELECT imp_pkg_gera_xml_ep.MyXMLConcat(xml_bem,imp_pkg_gera_xml_ep.MyXMLElement( 'bem'
                     , imp_pkg_gera_xml_ep.MyXMLConcat ( XMLForest( vc_fundamento_legal                           AS "codigoFundamentoLegalRegime"
                                            , i.fundamento_legal_pis_cofins                                       AS "codigoFundamentoLegalRegimePisCofins"
                                            , vc_class_fiscal1                                                    AS "codigoMercadoriaNcm"
                                            , vc_class_fiscal2                                                    AS "codigoMercadoriaNes"
                                            , vc_moeda_frete                                                      AS "codigoMoedaFreteMercadoria"
                                            , vc_moeda                                                            AS "codigoMoedaNegociada"
                                            , pc_moeda_seguro_id                                                  AS "codigoMoedaSeguroMercadoria"
                                            , vc_motivo_tsp                                                       AS "codigoMotivoFundamentoLegal"
                                            , vc_pais_origem                                                      AS "codigoPaisOrigemMercadoria"
                                            , vc_regtrib                                                          AS "codigoRegimeTributario"
                                            , i.regtrib_pis_cofins                                                AS "codigoRegimeTributarioPisCofins"
                                            --, Nvl(vc_descricao,' ')                                               AS "descricaoDetalhadaMercadoria"
                                            , RPad( NVL(vc_descricao,' '), 3900 )                                 AS "descricaoDetalhadaMercadoria"
                                            , i.material_usado                                                    AS "indicadorMaterialUsado"
                                            , NVL(i.dsi_mercosul,'N')                                             AS "indicadorMercosul"
                                            , vc_un_medida                                                        AS "nomeUnidadeMedidaComercial"
                                            , vc_linha_num                                                        AS "numeroBemUsuario"
                                            , RPad( NVL(vc_destaque,' '), 03 )                                    AS "numeroDestaqueNcm"
                                            , vc_licenca                                                          AS "numeroOperacaoTratamentoPrevio"
                                            , vc_peso_bruto                                                       AS "pesoBrutoBem"
                                            , vc_peso_liquido                                                     AS "pesoLiquidoBem"
                                            , vc_quantidade                                                       AS "quantidadeMercadoriaUnidadeComercial"
                                            , vc_qtde_un_medida_est                                               AS "quantidadeUnidadeEstatistica")
                                  , xml_tributos
                                  , XMLForest( RPad( NVL(vc_un_medida_est,' '), 20 )           AS "unidadeMedidaEstatistica"
                                              , vc_vraduaneiro_mn                              AS "valorAduaneiro"
                                              , vc_vrt_fr_mn                                   AS "valorFreteMercadoriaMoedaNacional"
                                              , vc_vrt_fr_m                                    AS "valorFreteMercadoriaMoedaNegociada"
                                              , vc_vmle_mn                                     AS "valorMercadoriaEmbarqueMoedaNacional"
                                              , vc_vrt_sg_us                                   AS "valorSeguroMercadoriaDolar"
                                              , vc_vrt_sg_mn                                   AS "valorSeguroMercadoriaMoedaNacional"
                                              , vc_vrt_sg_m                                    AS "valorSeguroMercadoriaMoedaNegociada"
                                              , vc_vmle_unit_m                                 AS "valorUnidadeLocalEmbarque"))))--.EXTRACT('*')
       INTO xml_bem
       FROM dual;*/
    ---------------------------------------------------------
    pn_qtde_bens := pn_qtde_bens + 1;
  END LOOP;
  --:block1.PROCESSO := null;
  --SYNCHRONIZE;

EXCEPTION
   When OTHERS THEN
     cmx_prc_gera_log_erros(pn_evento_id, aux_erro || sqlerrm, 'E');
     pb_sem_erro := FALSE;

     --:block1.PROCESSO := null;
     --SYNCHRONIZE;
END;

FUNCTION imp_fnc_controla_numerarios ( pn_vrt_icms   NUMBER
                                   , pn_evento_id  NUMBER
                                   , pn_declaracao_id NUMBER
                                   , pn_empresa_id NUMBER
                                   , pn_embarque_id NUMBER
                                   ) RETURN BOOLEAN IS

  vn_auxiliar           NUMBER := 0;
  vb_achou_numerario    BOOLEAN := False;

  vn_valor_ii           NUMBER := 0;
  vn_valor_ipi          NUMBER := 0;
  vn_valor_txsiscomex   NUMBER := 0;

  vb_retorno            BOOLEAN := true;

  CURSOR cur_dgerais_darf (pc_cd_receita  VARCHAR2) IS
    SELECT idd.valor_mn
      FROM imp_dcl_darf  idd
         , cmx_tabelas   ct
     WHERE idd.declaracao_id = pn_declaracao_id
       AND ct.tabela_id      = idd.cd_receita_id
       AND ct.codigo         = pc_cd_receita;

   CURSOR cur_adiantamento (pc_cdfixo_numerario  VARCHAR2) IS
     SELECT 0
     FROM imp_vw_numerarios_ebq  ivne
        , cmx_tabelas            ctn
        , cmx_tabelas            ctc
     WHERE ivne.embarque_id = pn_embarque_id
       AND ctn.tabela_id    = ivne.cd_numerario_id
       AND ctn.auxiliar1    = pc_cdfixo_numerario
       AND ctc.tabela_id    = ivne.categoria_id
       AND ctc.codigo       = 'A';

BEGIN
  vb_retorno := true;

  OPEN  cur_dgerais_darf( '0086' ); --- I.I.
  FETCH cur_dgerais_darf INTO vn_valor_ii;
  CLOSE cur_dgerais_darf;

  IF (nvl(vn_valor_ii,0) > 0) THEN
    OPEN   cur_adiantamento( 'II' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario) THEN
      cmx_prc_gera_log_erros (pn_evento_id, 'I.I. não solicitado nos numerários, estr.própria abortada...', 'E');
      vb_retorno := false;
    END IF;
  END IF;

  OPEN  cur_dgerais_darf( '1038' ); --- I.P.I.
  FETCH cur_dgerais_darf INTO vn_valor_ipi;
  CLOSE cur_dgerais_darf;

  IF ( nvl(vn_valor_ipi,0) > 0 ) THEN
    OPEN  cur_adiantamento( 'IPI' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario ) THEN
       cmx_prc_gera_log_erros (pn_evento_id, 'I.P.I. não solicitado nos numerários, estr.própria abortada...', 'E');
       vb_retorno := false;
    END IF;
  END IF;

  OPEN  cur_dgerais_darf( '7811' ); --- TAXA SISCOMEX
  FETCH cur_dgerais_darf INTO vn_valor_txsiscomex;
  CLOSE cur_dgerais_darf;

  IF (nvl(vn_valor_txsiscomex,0) > 0) THEN
    OPEN  cur_adiantamento( 'TXSIS' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario) THEN
      cmx_prc_gera_log_erros (pn_evento_id, 'Taxa utilização siscomex não solicitada nos numerários, estr.própria abortada...', 'E');
      vb_retorno := false;
    END IF;
  END IF;

  IF ( nvl(pn_vrt_icms,0) > 0 ) THEN
    OPEN  cur_adiantamento( 'ICMS' );
    FETCH cur_adiantamento INTO vn_auxiliar;
    vb_achou_numerario := cur_adiantamento%FOUND;
    CLOSE cur_adiantamento;

    IF (NOT vb_achou_numerario) THEN
      cmx_prc_gera_log_erros (pn_evento_id, 'I.C.M.S. não solicitado nos numerários, estr.própria abortada...', 'E');
      vb_retorno := false;
    END IF;
  END IF;

  RETURN (vb_retorno);
END imp_fnc_controla_numerarios;

PROCEDURE imp_prc_tributos( pn_declaracao_id NUMBER
                          , pn_declaracao_lin_id NUMBER
                          , px_tributos IN OUT XMLType)
IS

CURSOR cur_tributos ( pn_declaracao_id NUMBER
                    , pn_declaracao_lin_id NUMBER)
    IS SELECT ii.aliq_ii_dev            aliq
            , ii.basecalc_ii            base
            , ii.valor_ii_dev           vlr_dev
            , ii.valor_ii_rec           vlr_rec
            , c.auxiliar3               cod
        FROM imp_declaracoes_lin lin
           , imp_declaracoes_adi ii
           , cmx_tabelas c
       WHERE lin.declaracao_adi_id = ii.declaracao_adi_id
         AND lin.declaracao_id = pn_declaracao_id
         AND lin.declaracao_lin_id = pn_declaracao_lin_id
         AND c.codigo = '0086'
         AND c.tipo = '106'
       UNION ALL
      SELECT ipi.aliq_ipi_dev
           , ipi.basecalc_ipi
           , ipi.valor_ipi_dev
           , ipi.valor_ipi_rec
           , c.auxiliar3
        FROM imp_declaracoes_lin lin
           , imp_declaracoes_adi ipi
           , cmx_tabelas c
       WHERE lin.declaracao_adi_id = ipi.declaracao_adi_id
         AND lin.declaracao_id = pn_declaracao_id
         AND lin.declaracao_lin_id = pn_declaracao_lin_id
         AND c.codigo = '1038'
         AND c.tipo = '106'
       UNION ALL
      SELECT pis.aliq_pis_dev
           , pis.basecalc_pis_cofins
           , pis.valor_pis_dev
           , pis.valor_pis
           , c.auxiliar3
        FROM imp_declaracoes_lin lin
           , imp_declaracoes_adi pis
           , cmx_tabelas c
       WHERE lin.declaracao_adi_id = pis.declaracao_adi_id
         AND lin.declaracao_id = pn_declaracao_id
         AND lin.declaracao_lin_id = pn_declaracao_lin_id
         AND c.codigo = '5602'
         AND c.tipo = '106'
       UNION ALL
      SELECT cofins.aliq_cofins_dev
           , cofins.basecalc_pis_cofins
           , cofins.valor_cofins_dev
           , cofins.valor_cofins
           , c.auxiliar3
        FROM imp_declaracoes_lin lin
           , imp_declaracoes_adi cofins
           , cmx_tabelas c
       WHERE lin.declaracao_adi_id = cofins.declaracao_adi_id
         AND lin.declaracao_id = pn_declaracao_id
         AND lin.declaracao_lin_id = pn_declaracao_lin_id
         AND c.codigo = '5629'
         AND c.tipo = '106';

BEGIN
  px_tributos := null;
  FOR t IN cur_tributos(pn_declaracao_id, pn_declaracao_lin_id)
  LOOP
    SELECT imp_pkg_gera_xml_ep.MyXMLConcat ( px_tributos
                     , XMLElement ("tributo"
                                  , XMLForest ( t.cod AS "codigoReceitaImposto"
                                              --'<nomeUnidadeAliquotaEspecificaIpt />'||
                                              , lpad( ltrim( nvl( replace( replace( to_char(t.aliq  ,'999.99'), ',',null), '.',null) ,'0')), 05,'0' ) AS "percentualAliquotaNormalAdval"
                                    --'<quantidadeMercadoriaUnidadeAliquotaEspecifica />'||
                                    --'<valorAliquotaEspecificaIpt />'||
                                              , lpad( ltrim( nvl( replace( replace( to_char(t.base     ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' ) AS "valorBaseCalculoAdval"
                                              , lpad( ltrim( nvl( replace( replace( to_char(t.vlr_dev  ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' ) AS "valorImpostoCalculado"
                                              , lpad( ltrim( nvl( replace( replace( to_char(t.vlr_dev  ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' ) AS "valorImpostoDevido"
                                              , lpad( ltrim( nvl( replace( replace( to_char(t.vlr_rec  ,'999999999999.99'), ',',null), '.',null) ,'0')), 15,'0' ) AS "valorIptARecolher")))--.EXTRACT('*')
      INTO px_tributos
      FROM dual;
  END LOOP;

END;

PROCEDURE imp_prc_gera_xml( pn_evento_id           NUMBER
                          , pn_id                  NUMBER
                          , pc_nome_arquivo        VARCHAR2
                          , vn_blob_id      IN OUT NUMBER)
IS
  CURSOR cur_blobs(pn_id NUMBER) IS
    SELECT mensagem
      FROM cmx_xml_ep_tmp
     WHERE id = pn_id;

  xml_blobs xmltype;
--  xml_final xmltype;
  xml_final CLOB;

  vc_envelope            CLOB            := '<?xml version="1.0" encoding="utf-8"?>';
  vn_offset              NUMBER;
  vn_evento_id           NUMBER := pn_evento_id;
  vc_aux_erro            VARCHAR2(400);

BEGIN
  vc_aux_erro := 'Erro ao concatenar CLOBs';

--  FOR i IN cur_blobs(pn_id)
--  LOOP
--
--    SELECT imp_pkg_gera_xml_ep.MyXMLConcat (xml_blobs, XMLType(i.mensagem))
--      INTO xml_blobs
--      FROM dual;
--
--  END LOOP;
--
--  vc_aux_erro := 'Erro ao gerar XML Final';
--  SELECT imp_pkg_gera_xml_ep.MyXMLElement ( 'listaDeclaracoesTransmissao'
--                    , xml_blobs)
--    INTO xml_final
--    FROM dual;
--  vn_offset := 1;
--  WHILE ( vn_offset <= dbms_lob.getlength(xml_final.getclobval()) ) LOOP
--
--   dbms_lob.append(vc_envelope, DBMS_LOB.SUBSTR( xml_final.getclobval(), 2048, vn_offset));
--
--   vn_offset    := vn_offset    + 2048;
--
--  END LOOP;
--  vc_aux_erro := 'Convertendo base64';
--  vn_blob_id := cmx_fnc_clob_to_blob_base64(vc_envelope,pc_nome_arquivo,vn_evento_id);

  xml_final := '<listaDeclaracoesTransmissao>';
  vc_aux_erro := 'Erro ao concatenar CLOBs.2';
  FOR i IN (SELECT mensagem
              FROM cmx_xml_ep_tmp
             WHERE id = pn_id)
  LOOP
    xml_final  := xml_final  || i.mensagem;
  END LOOP;
  vc_aux_erro := 'Erro ao concatenar CLOBs.3';
  xml_final  := xml_final  ||'</listaDeclaracoesTransmissao>';

  vc_aux_erro := 'Erro ao concatenar CLOBs.4';
  SELECT xmltype(xml_final).extract('*').getclobval()
    INTO xml_final
    FROM dual;

  vc_aux_erro := 'Erro ao concatenar CLOBs.5';
  xml_final := '<?xml version="1.0" encoding="utf-8"?>'||xml_final;

  vc_aux_erro := 'Convertendo base64';
  vn_blob_id := cmx_fnc_clob_to_blob_base64(xml_final,pc_nome_arquivo,vn_evento_id);

EXCEPTION
    When OTHERS Then
      cmx_prc_gera_log_erros (pn_evento_id, vc_aux_erro || sqlerrm, 'E');

END;


FUNCTION fnc_tamanho_inf_complementar ( pn_declaracao_id NUMBER, pc_remover_memo_calc_pis_cof VARCHAR2 DEFAULT 'N')
  RETURN NUMBER IS

  CURSOR cur_dados IS
    SELECT id.txt_inf_complementar
         , id.embarque_id
         , ie.embarque_num
         , ie.embarque_ano
      FROM imp_embarques   ie
         , imp_declaracoes id
     WHERE id.declaracao_id = pn_declaracao_id
       AND id.embarque_id   = ie.embarque_id;

  vr_dados             cur_dados%ROWTYPE;
  vc_inf_complementar  VARCHAR2(32767);

BEGIN

  OPEN cur_dados;
  FETCH cur_dados INTO vr_dados;
  CLOSE cur_dados;

  vc_inf_complementar :=  'N/REF.: ' || vr_dados.embarque_ano || '/' || vr_dados.embarque_num
                          || Chr(10) ||
                          imp_fnc_converte_inf_compl ( pc_texto                     => vr_dados.txt_inf_complementar
                                                     , pn_declaracao_id             => pn_declaracao_id
                                                     , pn_embarque_id               => vr_dados.embarque_id
                                                     , pn_licenca_id                => NULL
                                                     , pn_nota_fiscal_id            => NULL
                                                     , pc_traduzir_apenas_curingas  => 'N'
                                                     , pc_remover_memo_calc_pis_cof => pc_remover_memo_calc_pis_cof
                                                     );

  RETURN Length(vc_inf_complementar);

END fnc_tamanho_inf_complementar;


END imp_pkg_gera_xml_ep;
/
