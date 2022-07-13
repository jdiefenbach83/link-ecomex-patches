PROMPT CREATE OR REPLACE PACKAGE cam_pkg_interface_importacao
CREATE OR REPLACE PACKAGE cam_pkg_interface_importacao
AS
  PROCEDURE gera_documentos (
     pn_empresa_id          imp_invoices.empresa_id%TYPE
   , pn_organizacao_id      imp_invoices.organizacao_id%TYPE
   , pn_moeda_id            imp_invoices.moeda_id%TYPE
   , pn_incoterm_id         imp_invoices.incoterm_id%TYPE
   , pn_usuario_id          sen_usuarios.id%TYPE
   , pn_export_id           imp_invoices.export_id%TYPE
   , pn_export_site_id      imp_invoices.export_site_id%TYPE
   , pn_termo_id            imp_invoices.termo_id%TYPE
   , pn_invoice_id          imp_invoices.invoice_id%TYPE
   , pc_invoice_num         imp_invoices.invoice_num%TYPE
   , pn_embarque_id         imp_invoices.embarque_id%TYPE
   , pc_embarque_num        imp_embarques.embarque_num%TYPE
   , pn_embarque_ano        imp_embarques.embarque_ano%TYPE
   , pc_embarque_totalizado imp_embarques.ebq_totalizado%TYPE
   , pd_data_emissao        imp_invoices.dt_emissao%TYPE
   , pd_data_base           imp_invoices.dt_base%TYPE
   , pd_data_conhecimento   imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque       imp_cronograma.dt_realizada%TYPE
  );

  PROCEDURE gera_commercial_invoice (
     pn_empresa_id        imp_invoices.empresa_id%TYPE
   , pn_organizacao_id    imp_invoices.organizacao_id%TYPE
   , pn_moeda_id          imp_invoices.moeda_id%TYPE
   , pn_incoterm_id       imp_invoices.incoterm_id%TYPE
   , pn_usuario_id        sen_usuarios.id%TYPE
   , pn_export_id         imp_invoices.export_id%TYPE
   , pn_export_site_id    imp_invoices.export_site_id%TYPE
   , pn_termo_id          imp_invoices.termo_id%TYPE
   , pn_invoice_id        imp_invoices.invoice_id%TYPE
   , pc_invoice_num       imp_invoices.invoice_num%TYPE
   , pn_embarque_id       imp_invoices.embarque_id%TYPE
   , pc_embarque_num      imp_embarques.embarque_num%TYPE
   , pn_embarque_ano      imp_embarques.embarque_ano%TYPE
   , pd_data_emissao      imp_invoices.dt_emissao%TYPE
   , pd_data_base         imp_invoices.dt_base%TYPE
   , pd_data_conhecimento imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque     imp_cronograma.dt_realizada%TYPE
   , pc_classe_invoice    VARCHAR2
  );

  PROCEDURE gera_invoice_financeira (
     pn_empresa_id        imp_invoices.empresa_id%TYPE
   , pn_organizacao_id    imp_invoices.organizacao_id%TYPE
   , pn_moeda_id          imp_invoices.moeda_id%TYPE
   , pn_incoterm_id       imp_invoices.incoterm_id%TYPE
   , pn_usuario_id        sen_usuarios.id%TYPE
   , pn_export_id         imp_invoices.export_id%TYPE
   , pn_export_site_id    imp_invoices.export_site_id%TYPE
   , pn_termo_id          imp_invoices.termo_id%TYPE
   , pn_invoice_id        imp_invoices.invoice_id%TYPE
   , pc_invoice_num       imp_invoices.invoice_num%TYPE
   , pn_embarque_id       imp_invoices.embarque_id%TYPE
   , pc_embarque_num      imp_embarques.embarque_num%TYPE
   , pn_embarque_ano      imp_embarques.embarque_ano%TYPE
   , pd_data_emissao      imp_invoices.dt_emissao%TYPE
   , pd_data_base         imp_invoices.dt_base%TYPE
   , pd_data_conhecimento imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque     imp_cronograma.dt_realizada%TYPE
   , pc_classe_invoice    VARCHAR2
  );

  PROCEDURE gera_comissao_importacao (
     pn_empresa_id        imp_invoices.empresa_id%TYPE
   , pn_organizacao_id    imp_invoices.organizacao_id%TYPE
   , pn_moeda_id          imp_invoices.moeda_id%TYPE
   , pn_incoterm_id       imp_invoices.incoterm_id%TYPE
   , pn_usuario_id        sen_usuarios.id%TYPE
   , pn_export_id         imp_invoices.export_id%TYPE
   , pn_export_site_id    imp_invoices.export_site_id%TYPE
   , pn_termo_id          imp_invoices.termo_id%TYPE
   , pn_invoice_id        imp_invoices.invoice_id%TYPE
   , pc_invoice_num       imp_invoices.invoice_num%TYPE
   , pn_embarque_id       imp_invoices.embarque_id%TYPE
   , pc_embarque_num      imp_embarques.embarque_num%TYPE
   , pn_embarque_ano      imp_embarques.embarque_ano%TYPE
   , pd_data_emissao      imp_invoices.dt_emissao%TYPE
   , pd_data_base         imp_invoices.dt_base%TYPE
   , pd_data_conhecimento imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque     imp_cronograma.dt_realizada%TYPE
   , pc_classe_invoice    VARCHAR2
  );
END cam_pkg_interface_importacao;





/

PROMPT CREATE OR REPLACE PACKAGE BODY cam_pkg_interface_importacao
CREATE OR REPLACE PACKAGE BODY cam_pkg_interface_importacao
AS
  /**
   * Declara��es globais do pacote.
   */
  CURSOR cur_origem_documento IS
    SELECT tabela_id
      FROM cmx_tabelas
     WHERE tipo   = '926'
       AND codigo = 'ECOMEX IMPORTACAO';

  gn_origem_documento_id  cam_documentos.origem_id%TYPE;

  CURSOR cur_tipo_documento (pc_codigo_documento cmx_tabelas.codigo%TYPE) IS
    SELECT tabela_id
      FROM cmx_tabelas
     WHERE tipo   = '301'
       AND codigo = pc_codigo_documento;

  CURSOR cur_banco_exterior (
     pn_export_id      imp_invoices.export_id%TYPE
   , pn_export_site_id imp_invoices.export_site_id%TYPE
  )
  IS
    SELECT conta_id
         , banco_agencia_id
      FROM cmx_bancos_agencias_cta
     WHERE entidade_id          = pn_export_id
       AND entidade_site_id     = pn_export_site_id
       AND tp_conta             = 'FORNECEDOR'
       AND flag_conta_primaria  = 'S'
       AND data_inativacao     IS null;

  /* Fun��o que retorna se uma invoice possui frete embutido */
  FUNCTION fr_embutido (pn_invoice_id NUMBER) RETURN VARCHAR2 IS
  PRAGMA autonomous_transaction;
    CURSOR c_invoice IS
      SELECT ii.flag_fr_embutido
        FROM imp_invoices     ii
       WHERE ii.invoice_id   = pn_invoice_id;

    vc_ret VARCHAR2(1);

  BEGIN
    OPEN  c_invoice;
    FETCH c_invoice INTO vc_ret;
    CLOSE c_invoice;
    COMMIT; /* S� para fechar a sess�o autonomous transaction */
    RETURN vc_ret;
  END;

  /* Fun��o que retorna se uma invoice possui despesa DDU embutida */
  FUNCTION dsp_ddu_embutida (pn_invoice_id NUMBER) RETURN VARCHAR2 IS
  PRAGMA autonomous_transaction;
    CURSOR c_invoice IS
      SELECT ii.flag_dsp_ddu_embutida
        FROM imp_invoices     ii
       WHERE ii.invoice_id   = pn_invoice_id;

    vc_ret VARCHAR2(1);

  BEGIN
    OPEN  c_invoice;
    FETCH c_invoice INTO vc_ret;
    CLOSE c_invoice;
    COMMIT; /* S� para fechar a sess�o autonomous transaction */
    RETURN vc_ret;
  END;

  /**
   * Prot�tipos de fun��es e procedimentos definidos ao final do pacote.
   */
  FUNCTION fnc_incluir_documento (
     pn_empresa_id                IN cam_documentos.empresa_id%TYPE                  /*  1 */
   , pn_organizacao_id            IN cam_documentos.organizacao_id%TYPE              /*  2 */
   , pn_moeda_id                  IN cam_documentos.moeda_id%TYPE                    /*  3 */
   , pn_incoterm_id               IN cam_documentos.incoterm_id%TYPE                 /*  4 */
   , pn_valor_total               IN cam_documentos.valor_total%TYPE                 /*  5 */
   , pn_usuario_id                IN sen_usuarios.id%TYPE                            /*  6 */
   , pn_embarque_importacao_id    IN cam_documentos.embarque_importacao_id%TYPE      /*  7 */
   , pc_embarque_num              IN cam_documentos.embarque_num%TYPE                /*  8 */
   , pn_embarque_ano              IN cam_documentos.embarque_ano%TYPE                /*  9 */
   , pn_entidade_id               IN cam_documentos.entidade_id%TYPE                 /* 10 */
   , pn_entidade_site_id          IN cam_documentos.entidade_site_id%TYPE            /* 11 */
   , pn_banco_exterior_agencia_id IN cam_documentos.banco_exterior_agencia_id%TYPE   /* 12 */
   , pn_banco_exterior_conta_id   IN cam_documentos.banco_exterior_conta_id%TYPE     /* 13 */
   , pn_condicao_id               IN cam_documentos.condicao_id%TYPE                 /* 14 */
   , pn_invoice_importacao_id     IN cam_documentos.invoice_importacao_id%TYPE       /* 15 */
   , pc_numero                    IN cam_documentos.numero%TYPE                      /* 16 */
   , pn_tipo_id                   IN cam_documentos.tipo_id%TYPE                     /* 17 */
   , pn_aplicado_a_documento_id   IN cam_documentos.documento_id%TYPE                /* 18 */
   , pd_data_emissao              IN cam_documentos.data_emissao%TYPE                /* 19 */
   , pd_data_base                 IN cam_documentos.data_base%TYPE                   /* 20 */
   , pd_data_conhecimento         IN cam_documentos.data_conhecimento%TYPE           /* 21 */
   , pd_data_embarque             IN cam_documentos.data_embarque%TYPE               /* 22 */
   , pn_aliq_irrf                 IN cam_documentos.aliquota_irrf%TYPE               /* 23 */
   , pc_descontar_irrf            IN cam_documentos.flag_irrf_descontado%TYPE        /* 24 */
   , pn_valor_bruto               IN cam_documentos.valor_bruto%TYPE                 /* 25 */
   , pc_tipo_calculo_irrf         IN cam_documentos.tipo_calculo_irrf%TYPE           /* 26 */
   , pn_aliq_iss                  IN cam_documentos.aliquota_iss%TYPE                /* 27 */
   , pc_descontar_iss             IN cam_documentos.flag_iss_descontado%TYPE         /* 28 */
   , pc_tipo_calculo_iss          IN cam_documentos.tipo_calculo_iss%TYPE            /* 29 */
  ) RETURN NUMBER;

  FUNCTION fnc_calcula_fob (
     pn_embarque_id   imp_embarques.embarque_id%TYPE
   , pc_embarque_ano  VARCHAR2
   , pn_invoice_id    imp_invoices.invoice_id%TYPE
   , pn_created_by    sen_usuarios.id%TYPE
  )
  RETURN cmx_eventos.evento_id%TYPE;


  /**
   * Esta procedure ser� utilizada para analisar a invoice, classific�-la em
   * um dos tr�s tipos e fazer chamadas �s rotinas necess�rias.
   * Os tr�s tipos de invoice que ser�o tratadas s�o:
   * 1) Invoice de mercadorias: o tipo c�mbio de todas as linhas � igual a M e
   *    tem ao menos uma linha com tipo fixo igual a M.
   * 2) Invoice de mercadorias e financeira: tem ao menos uma linha com tipo
   *    fixo igual a M e ao menos uma linha com tipo c�mbio igual a F.
   * 3) Invoice financeira: o tipo fixo de todas as linhas � diferente de M.
   *
   * Essa rotina ser� chamada em dois momentos: na vincula��o da invoice no
   * embarque que tenha conhecimento de transporte e ao informar o conhecimento
   * em um embarque que tenha invoices vinculadas.
   */
  PROCEDURE gera_documentos (
     pn_empresa_id          imp_invoices.empresa_id%TYPE
   , pn_organizacao_id      imp_invoices.organizacao_id%TYPE
   , pn_moeda_id            imp_invoices.moeda_id%TYPE
   , pn_incoterm_id         imp_invoices.incoterm_id%TYPE
   , pn_usuario_id          sen_usuarios.id%TYPE
   , pn_export_id           imp_invoices.export_id%TYPE
   , pn_export_site_id      imp_invoices.export_site_id%TYPE
   , pn_termo_id            imp_invoices.termo_id%TYPE
   , pn_invoice_id          imp_invoices.invoice_id%TYPE
   , pc_invoice_num         imp_invoices.invoice_num%TYPE
   , pn_embarque_id         imp_invoices.embarque_id%TYPE
   , pc_embarque_num        imp_embarques.embarque_num%TYPE
   , pn_embarque_ano        imp_embarques.embarque_ano%TYPE
   , pc_embarque_totalizado imp_embarques.ebq_totalizado%TYPE
   , pd_data_emissao        imp_invoices.dt_emissao%TYPE
   , pd_data_base           imp_invoices.dt_base%TYPE
   , pd_data_conhecimento   imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque       imp_cronograma.dt_realizada%TYPE
  )
  IS
    /* Cursor pra identificar invoices do tipo 1 */
    CURSOR cur_ivc_mercadoria IS
      SELECT null
        FROM dual
       WHERE 'M' = ALL  (SELECT ctt.auxiliar3
                           FROM imp_invoices_lin iil
                              , cmx_tabelas      ctt
                          WHERE iil.invoice_id = pn_invoice_id
                            AND ctt.tabela_id  = iil.tp_linha_id)
         AND 'M' = SOME (SELECT ctt.auxiliar3
                           FROM imp_invoices_lin iil
                              , cmx_tabelas      ctt
                          WHERE iil.invoice_id = pn_invoice_id
                            AND ctt.tabela_id  = iil.tp_linha_id);

    /* Cursor pra identificar invoices do tipo 2 */
    CURSOR cur_ivc_mercadoria_financeira IS
      SELECT null
        FROM dual
       WHERE 'M' = SOME  (SELECT ctt.auxiliar3
                           FROM imp_invoices_lin iil
                              , cmx_tabelas      ctt
                          WHERE iil.invoice_id = pn_invoice_id
                            AND ctt.tabela_id  = iil.tp_linha_id)
         AND 'F' = SOME (SELECT ctt.auxiliar3
                           FROM imp_invoices_lin iil
                              , cmx_tabelas      ctt
                          WHERE iil.invoice_id = pn_invoice_id
                            AND ctt.tabela_id  = iil.tp_linha_id);

    CURSOR cur_tem_representante_linhas IS
      SELECT null
        FROM imp_invoices_lin
       WHERE invoice_id =  pn_invoice_id
         AND repres_id  IS NOT null;

    CURSOR cur_erros (pn_evento_id cmx_eventos.evento_id%TYPE) IS
      SELECT null
        FROM cmx_log_erros
       WHERE tipo      = 'E'
         AND evento_id = pn_evento_id
         AND rownum    = 1;

    CURSOR cur_evento (pn_evento_id cmx_eventos.evento_id%TYPE) IS
      SELECT nome
           , data
        FROM cmx_eventos
       WHERE evento_id = pn_evento_id;

    vc_tipo_invoice     VARCHAR2(2);
    vn_evento_id        cmx_eventos.evento_id%TYPE;
    vc_evento           cmx_eventos.nome%TYPE;
    vd_data_evento      cmx_eventos.data%TYPE;
    vc_step_error       VARCHAR2(1000);
    vc_nada             VARCHAR2(1);
    vb_encontrou        BOOLEAN;
    ve_erro_calculo_fob EXCEPTION;
    ve_origem           EXCEPTION;

  BEGIN
    vc_step_error := 'Cursor origem do documento.';
    OPEN  cur_origem_documento;
    FETCH cur_origem_documento INTO gn_origem_documento_id;
    vb_encontrou  := cur_origem_documento%FOUND;
    CLOSE cur_origem_documento;
    vc_step_error := null;

    IF (NOT vb_encontrou) THEN
      RAISE ve_origem;
    END IF;

    vc_step_error := 'Cursor para verificar se invoice � do tipo mercadoria.';
    OPEN  cur_ivc_mercadoria;
    FETCH cur_ivc_mercadoria INTO vc_nada;
    vb_encontrou  := cur_ivc_mercadoria%FOUND;
    CLOSE cur_ivc_mercadoria;
    vc_step_error := null;

    IF (vb_encontrou) THEN
      vc_tipo_invoice := 'M';
      vc_step_error   := 'Chamando rotina gera_commercial_invoice, para invoices do tipo mercadoria.';
      gera_commercial_invoice (
         pn_empresa_id
       , pn_organizacao_id
       , pn_moeda_id
       , pn_incoterm_id
       , pn_usuario_id
       , pn_export_id
       , pn_export_site_id
       , pn_termo_id
       , pn_invoice_id
       , pc_invoice_num
       , pn_embarque_id
       , pc_embarque_num
       , pn_embarque_ano
       , pd_data_emissao
       , pd_data_base
       , pd_data_conhecimento
       , pd_data_embarque
       , vc_tipo_invoice
      );
      vc_step_error := null;

    ELSE
      vc_step_error := 'Cursor para verificar se invoice � do tipo mercadoria e financeira.';
      OPEN  cur_ivc_mercadoria_financeira;
      FETCH cur_ivc_mercadoria_financeira INTO vc_nada;
      vb_encontrou  := cur_ivc_mercadoria_financeira%FOUND;
      CLOSE cur_ivc_mercadoria_financeira;
      vc_step_error := null;

      IF (vb_encontrou) THEN
        vc_tipo_invoice := 'MF';
        vc_step_error   := 'Chamando rotina gera_commercial_invoice, para invoices do tipo mercadoria e financeira.';
        gera_commercial_invoice (
           pn_empresa_id
         , pn_organizacao_id
         , pn_moeda_id
         , pn_incoterm_id
         , pn_usuario_id
         , pn_export_id
         , pn_export_site_id
         , pn_termo_id
         , pn_invoice_id
         , pc_invoice_num
         , pn_embarque_id
         , pc_embarque_num
         , pn_embarque_ano
         , pd_data_emissao
         , pd_data_base
         , pd_data_conhecimento
         , pd_data_embarque
         , vc_tipo_invoice
        );
        vc_step_error := null;

        vc_step_error := 'Chamando rotina gera_invoice_financeira, para invoices do tipo mercadoria e financeira.';
        gera_invoice_financeira (
           pn_empresa_id
         , pn_organizacao_id
         , pn_moeda_id
         , pn_incoterm_id
         , pn_usuario_id
         , pn_export_id
         , pn_export_site_id
         , pn_termo_id
         , pn_invoice_id
         , pc_invoice_num
         , pn_embarque_id
         , pc_embarque_num
         , pn_embarque_ano
         , pd_data_emissao
         , pd_data_base
         , pd_data_conhecimento
         , pd_data_embarque
         , vc_tipo_invoice
        );
        vc_step_error := null;

      /* Se invoice � do tipo financeira */
      ELSE
        vc_step_error   := 'Chamando rotina gera_invoice_financeira, para invoices do tipo financeira.';
        vc_tipo_invoice := 'F';
        gera_invoice_financeira (
           pn_empresa_id
         , pn_organizacao_id
         , pn_moeda_id
         , pn_incoterm_id
         , pn_usuario_id
         , pn_export_id
         , pn_export_site_id
         , pn_termo_id
         , pn_invoice_id
         , pc_invoice_num
         , pn_embarque_id
         , pc_embarque_num
         , pn_embarque_ano
         , pd_data_emissao
         , pd_data_base
         , pd_data_conhecimento
         , pd_data_embarque
         , vc_tipo_invoice
        );
        vc_step_error := null;
      END IF;
    END IF;

    vc_step_error := 'Cursor para verificar se alguma linha da invoice tem representante.';
    OPEN  cur_tem_representante_linhas;
    FETCH cur_tem_representante_linhas INTO vc_nada;
    vb_encontrou := cur_tem_representante_linhas%FOUND;
    CLOSE cur_tem_representante_linhas;
    vc_step_error := null;

    /* Se alguma linha da invoice tiver representante, ser� calculada a comiss�o.*/
    IF (vb_encontrou) THEN

      /* Caso a invoice esteja vinculada a um embarque e este n�o esteja totalizado, ser� chamada a rotina
         calcular o valor FOB das linhas da invoice em quest�o, ou seja, esta rotina n�o ser� chamada para
         invoices financeiras. O valor FOB ser� utilizado no c�lculo da comiss�o de importa��o.
      */
      IF (pn_embarque_id IS NOT null) AND (pc_embarque_totalizado = 'N') THEN
        vc_step_error := 'Calcula FOB';
        vn_evento_id := fnc_calcula_fob (
                           pn_embarque_id
                         , pc_embarque_num || '/' || to_char (pn_embarque_ano)
                         , pn_invoice_id
                         , pn_usuario_id
                        );

        vc_step_error := 'Testa erros no calculo do valor FOB.';
        OPEN  cur_erros (vn_evento_id);
        FETCH cur_erros INTO vc_nada;
        vb_encontrou := cur_erros%FOUND;
        CLOSE cur_erros;
        vc_step_error := null;

        /* Caso ocorra algum erro no c�lculo do valor FOB o processo ser�
         * abortado com uma exce��o, apresentando ao usu�rio dados do evento.
         */
        IF (vb_encontrou) THEN
          RAISE ve_erro_calculo_fob;
        END IF;
      END IF;

      vc_step_error := 'Chamando rotina gera_comissao_importacao.';
      gera_comissao_importacao (
         pn_empresa_id
       , pn_organizacao_id
       , pn_moeda_id
       , pn_incoterm_id
       , pn_usuario_id
       , pn_export_id
       , pn_export_site_id
       , pn_termo_id
       , pn_invoice_id
       , pc_invoice_num
       , pn_embarque_id
       , pc_embarque_num
       , pn_embarque_ano
       , pd_data_emissao
       , pd_data_base
       , pd_data_conhecimento
       , pd_data_embarque
       , vc_tipo_invoice
      );
      vc_step_error := null;
    END IF;

  EXCEPTION
    WHEN ve_erro_calculo_fob THEN
      OPEN  cur_evento (vn_evento_id);
      FETCH cur_evento INTO vc_evento, vd_data_evento;
      CLOSE cur_evento;

      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_DOCUMENTOS. Erro na rotina de ' ||
         'gera��o de documentos [Calculando valor FOB - Evento: ' ||
         vc_evento || ' Data: ' ||
         to_char (vd_data_evento, 'DD/MM/RRRR HH24:MI:SS') || '].'
      );

    WHEN ve_origem THEN
      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_DOCUMENTOS. Erro na rotina de ' ||
         'gera��o de documentos [O c�digo ECOMEX IMPORTACAO n�o est� ' ||
         'cadastrado na tabela do sistema n� 926].'
      );

    WHEN others THEN
      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_DOCUMENTOS [' || sqlerrm ||
         ']. Erro na rotina de gera��o de documentos [' || vc_step_error ||
         '].'
      );
  END gera_documentos;


  /* Esta procedure ser� utilizada para gerar as commercial invoices.
     Ser� chamada da rotina de gera��o de documentos. */
  PROCEDURE gera_commercial_invoice (
     pn_empresa_id        imp_invoices.empresa_id%TYPE
   , pn_organizacao_id    imp_invoices.organizacao_id%TYPE
   , pn_moeda_id          imp_invoices.moeda_id%TYPE
   , pn_incoterm_id       imp_invoices.incoterm_id%TYPE
   , pn_usuario_id        sen_usuarios.id%TYPE
   , pn_export_id         imp_invoices.export_id%TYPE
   , pn_export_site_id    imp_invoices.export_site_id%TYPE
   , pn_termo_id          imp_invoices.termo_id%TYPE
   , pn_invoice_id        imp_invoices.invoice_id%TYPE
   , pc_invoice_num       imp_invoices.invoice_num%TYPE
   , pn_embarque_id       imp_invoices.embarque_id%TYPE
   , pc_embarque_num      imp_embarques.embarque_num%TYPE
   , pn_embarque_ano      imp_embarques.embarque_ano%TYPE
   , pd_data_emissao      imp_invoices.dt_emissao%TYPE
   , pd_data_base         imp_invoices.dt_base%TYPE
   , pd_data_conhecimento imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque     imp_cronograma.dt_realizada%TYPE
   , pc_classe_invoice    VARCHAR2
  )
  IS
    CURSOR cur_valor_total (pc_fr_embutido VARCHAR2, pc_dsp_ddu_embutida VARCHAR2) IS
      SELECT nvl (sum (imp_fnc_calc_total_inv_lin( iil.preco_unitario_m
                                                 , iil.qtde
                                                 , iil.invoice_lin_id
                                                 , NULL
                                                 , NULL
                                                 , NULL
                                                 , NULL
                                                 )), 0)
        FROM imp_invoices_lin iil
           , cmx_tabelas      ct
       WHERE iil.invoice_id  = pn_invoice_id
         AND iil.tp_linha_id = ct.tabela_id
         AND (    (ct.auxiliar3 = 'M' AND ct.auxiliar1 =  'I' AND pc_fr_embutido = 'N')
               OR (ct.auxiliar3 = 'M' AND ct.auxiliar1 <> 'I' AND pc_fr_embutido = 'N')
               OR (ct.auxiliar3 = 'M' AND ct.auxiliar1 <> 'I' AND pc_fr_embutido = 'S')
             )
         AND (    (ct.auxiliar3 = 'M' AND ct.auxiliar1 =  'N' AND pc_dsp_ddu_embutida = 'N')
               OR (ct.auxiliar3 = 'M' AND ct.auxiliar1 <> 'N' AND pc_dsp_ddu_embutida = 'N')
               OR (ct.auxiliar3 = 'M' AND ct.auxiliar1 <> 'N' AND pc_dsp_ddu_embutida = 'S')
             )
         AND nvl (iil.flag_vr_remeter, 'N') = 'S';

    vn_tipo_documento_id    cmx_tabelas.tabela_id%TYPE;
    vn_valor_total          cam_documentos.valor_total%TYPE;
    vn_documento_id         cam_documentos.documento_id%TYPE;
    vc_step_error           VARCHAR2(1000);
    vc_erros                VARCHAR2(2000) := null;
    ve_excecao              EXCEPTION;
    vn_banco_exterior_id    cmx_bancos_agencias_cta.banco_agencia_id%TYPE;
    vn_conta_exterior_id    cmx_bancos_agencias_cta.conta_id%TYPE;

  BEGIN
    vc_step_error := 'Cursor tipo do documento.';
    OPEN  cur_tipo_documento ('CI');
    FETCH cur_tipo_documento INTO vn_tipo_documento_id;
    CLOSE cur_tipo_documento;
    vc_step_error := null;

    IF (vn_tipo_documento_id IS null) THEN
      vc_erros := vc_erros || 'O c�digo CI n�o est� cadastrado na tabela do sistema n� 301.';
    END IF;

    IF (vc_erros IS NOT null) THEN
      RAISE ve_excecao;
    END IF;

    vc_step_error := 'Cursor banco exterior.';
    OPEN  cur_banco_exterior (pn_export_id, pn_export_site_id);
    FETCH cur_banco_exterior INTO vn_conta_exterior_id, vn_banco_exterior_id;
    CLOSE cur_banco_exterior;
    vc_step_error := null;

    /* O valor total do documento commercial invoice ser� a somat�ria do produto da quantidade
       pelo pre�o unit�rio das linhas da invoice que t�m o tipo c�mbio igual a 'M' */
    vc_step_error := 'Cursor para calcular valor total da commercial invoices.';
    OPEN  cur_valor_total (fr_embutido (pn_invoice_id), dsp_ddu_embutida (pn_invoice_id));
    FETCH cur_valor_total INTO vn_valor_total;
    CLOSE cur_valor_total;
    vc_step_error := null;

    IF (vn_valor_total > 0) THEN
      vc_step_error := 'Gerando o documento commercial invoice.';
      vn_documento_id := fnc_incluir_documento (
         pn_empresa_id                 /*  1 */
       , pn_organizacao_id             /*  2 */
       , pn_moeda_id                   /*  3 */
       , pn_incoterm_id                /*  4 */
       , vn_valor_total                /*  5 */
       , pn_usuario_id                 /*  6 */
       , pn_embarque_id                /*  7 */
       , pc_embarque_num               /*  8 */
       , pn_embarque_ano               /*  9 */
       , pn_export_id                  /* 10 */
       , pn_export_site_id             /* 11 */
       , vn_banco_exterior_id          /* 12 */
       , vn_conta_exterior_id          /* 13 */
       , pn_termo_id                   /* 14 */
       , pn_invoice_id                 /* 15 */
       , pc_invoice_num                /* 16 */
       , vn_tipo_documento_id          /* 17 */
       , null                          /* 18 */
       , trunc (pd_data_emissao)       /* 19 */
       , trunc (pd_data_base)          /* 20 */
       , trunc (pd_data_conhecimento)  /* 21 */
       , trunc (pd_data_embarque)      /* 22 */
       , null                          /* 23 aliq_irrf */
       , null                          /* 24 pc_descontar_irrf */
       , vn_valor_total                /* 25 valor_bruto */
       , 'D'                           /* 26 */
       , NULL                          /* 27 pn_aliq_iss         */
       , NULL                          /* 28 pc_descontar_iss    */
       , NULL                          /* 29 pc_tipo_calculo_iss */
      );
      vc_step_error := null;
      vc_step_error := 'UPDATE nas linhas da invoice com o ID do documento';
      UPDATE imp_invoices_lin iil
         SET iil.global_atributo1 = vn_documento_id
       WHERE iil.invoice_id  = pn_invoice_id
         AND nvl (iil.flag_vr_remeter, 'N') = 'S'
         AND EXISTS (SELECT 1
                       FROM cmx_tabelas ct
                      WHERE iil.tp_linha_id = ct.tabela_id
                        AND ct.auxiliar3    = 'M');
      vc_step_error := null;
    END IF;

  EXCEPTION
    WHEN ve_excecao THEN
      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_COMMERCIAL_INVOICE. Erro na ' ||
         'rotina de cria��o do documento commercial invoice [' || vc_erros ||
         '].'
      );

    WHEN others THEN
      IF (vc_erros IS null) THEN
        raise_application_error (
           -20000
         , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_COMMERCIAL_INVOICE [' || sqlerrm ||
           ']. Erro na rotina de cria��o do documento commercial invoice [' ||
           vc_step_error || '].'
        );
      ELSE
        raise_application_error (
           -20000
         , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_COMMERCIAL_INVOICE [' || sqlerrm ||
           ']. Erro na rotina de cria��o do documento commercial invoice [' ||
           vc_step_error || '] - [' || vc_erros || '].'
        );
      END IF;
  END gera_commercial_invoice;


  /**
   * Esta procedure ser� utilizada para gerar as invoices financeiras.
   * Ser� chamada da rotina de gera��o de documentos.
   */
  PROCEDURE gera_invoice_financeira (
     pn_empresa_id        imp_invoices.empresa_id%TYPE
   , pn_organizacao_id    imp_invoices.organizacao_id%TYPE
   , pn_moeda_id          imp_invoices.moeda_id%TYPE
   , pn_incoterm_id       imp_invoices.incoterm_id%TYPE
   , pn_usuario_id        sen_usuarios.id%TYPE
   , pn_export_id         imp_invoices.export_id%TYPE
   , pn_export_site_id    imp_invoices.export_site_id%TYPE
   , pn_termo_id          imp_invoices.termo_id%TYPE
   , pn_invoice_id        imp_invoices.invoice_id%TYPE
   , pc_invoice_num       imp_invoices.invoice_num%TYPE
   , pn_embarque_id       imp_invoices.embarque_id%TYPE
   , pc_embarque_num      imp_embarques.embarque_num%TYPE
   , pn_embarque_ano      imp_embarques.embarque_ano%TYPE
   , pd_data_emissao      imp_invoices.dt_emissao%TYPE
   , pd_data_base         imp_invoices.dt_base%TYPE
   , pd_data_conhecimento imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque     imp_cronograma.dt_realizada%TYPE
   , pc_classe_invoice    VARCHAR2
  )
  IS
    CURSOR cur_tipo_documento (pc_codigo_documento cmx_tabelas.codigo%TYPE) IS
      SELECT tabela_id
        FROM cmx_tabelas
       WHERE tipo      = '301'
         AND codigo    = pc_codigo_documento
         AND auxiliar1 = 'IF';

    /* Esse cursor ser� utilizado para calcular o valor total do documento quando o par�metro
       pc_classe_invoice for igual a 'F'. As linhas da invoice ser�o agrupadas pelo tipo
       documento c�mbio (auxiliar6 da tabela do sistema de tipos de linha de invoice n� 128). */
    CURSOR cur_valor_total_f IS
        SELECT nvl (
                  sum (
                        decode (
                            iil.desconta_irrf_ivc
                          , 'S'
                          , imp_fnc_calc_total_inv_lin( iil.preco_unitario_m
                                                      , iil.qtde
                                                      , iil.invoice_lin_id
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                      ) - round (iil.qtde * iil.preco_unitario_m * nvl (iil.aliq_irrf, 0) / 100, 2)
                          , imp_fnc_calc_total_inv_lin( iil.preco_unitario_m
                                                      , iil.qtde
                                                      , iil.invoice_lin_id
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                      )
                        ) -
                        decode (
                            iil.desconta_iss_ivc
                          , 'S'
                          , round (iil.qtde * iil.preco_unitario_m * nvl (iil.aliq_iss, 0) / 100, 2)
                          , 0
                        )
                  )
                , 0
               ) valor_total
             , iil.aliq_irrf          AS aliq_irrf_ivc
             , iil.desconta_irrf_ivc
             , iil.aliq_iss           AS aliq_iss_ivc
             , iil.desconta_iss_ivc
             , ct.auxiliar6
             , sum (imp_fnc_calc_total_inv_lin( iil.preco_unitario_m
                                              , iil.qtde
                                              , iil.invoice_lin_id
                                              , NULL
                                              , NULL
                                              , NULL
                                              , NULL
                                              )) valor_bruto
          FROM imp_invoices_lin iil
             , cmx_tabelas      ct
         WHERE iil.invoice_id  = pn_invoice_id
           AND iil.tp_linha_id = ct.tabela_id
           AND nvl (iil.flag_vr_remeter, 'N') = 'S'
      GROUP BY ct.auxiliar6
             , iil.aliq_irrf
             , iil.desconta_irrf_ivc
             , iil.aliq_iss
             , iil.desconta_iss_ivc;

    /* Esse cursor ser� utilizado para calcular o valor total do documento
     * quando o par�metro pc_classe_invoice for igual a 'MF'. Ser� somente para
     * as linhas de invoice que t�m o tipo c�mbio igual a F. As linhas da
     * invoice ser�o agrupadas pelo tipo documento c�mbio (auxiliar6 da tabela
     * do sistema de tipos de linha de invoice n� 128).
     */
    CURSOR cur_valor_total_mf IS
        SELECT nvl (
                  sum (
                        decode (
                            iil.desconta_irrf_ivc
                          , 'S'
                          , round (iil.qtde * iil.preco_unitario_m, 2) - round (iil.qtde * iil.preco_unitario_m * nvl (iil.aliq_irrf, 0) / 100, 2)
                          , imp_fnc_calc_total_inv_lin( iil.preco_unitario_m
                                                      , iil.qtde
                                                      , iil.invoice_lin_id
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                      , NULL
                                                      )
                        ) -
                        decode (
                            iil.desconta_iss_ivc
                          , 'S'
                          , round (iil.qtde * iil.preco_unitario_m * nvl (iil.aliq_iss, 0) / 100, 2)
                          , 0
                        )
                  )
                , 0
               ) valor_total
             , iil.aliq_irrf          AS aliq_irrf_ivc
             , iil.desconta_irrf_ivc
             , iil.aliq_iss           AS aliq_iss_ivc
             , iil.desconta_iss_ivc
             , ct.auxiliar6
             , imp_fnc_calc_total_inv_lin( iil.preco_unitario_m
                                         , iil.qtde
                                         , iil.invoice_lin_id
                                         , NULL
                                         , NULL
                                         , NULL
                                         , NULL
                                         ) valor_bruto
          FROM imp_invoices_lin iil
             , cmx_tabelas      ct
         WHERE iil.invoice_id  = pn_invoice_id
           AND iil.tp_linha_id = ct.tabela_id
           AND nvl (iil.flag_vr_remeter, 'N') = 'S'
           AND ct.auxiliar3    = 'F'
      GROUP BY ct.auxiliar6
             , iil.aliq_irrf
             , iil.desconta_irrf_ivc
             , iil.aliq_iss
             , iil.desconta_iss_ivc;

    vn_tipo_documento_id    cmx_tabelas.tabela_id%TYPE;
    vc_step_error           VARCHAR2(1000);
    ve_excecao              EXCEPTION;
    vn_documento_id         cam_documentos.documento_id%TYPE;
    vc_tipo_calculo_irrf    cam_documentos.tipo_calculo_irrf%TYPE;
    vc_tipo_calculo_iss     cam_documentos.tipo_calculo_iss%TYPE;
    vn_banco_exterior_id    cmx_bancos_agencias_cta.banco_agencia_id%TYPE;
    vn_conta_exterior_id    cmx_bancos_agencias_cta.conta_id%TYPE;

  BEGIN
    vc_step_error := 'Cursor banco exterior.';
    OPEN  cur_banco_exterior (pn_export_id, pn_export_site_id);
    FETCH cur_banco_exterior INTO vn_conta_exterior_id, vn_banco_exterior_id;
    CLOSE cur_banco_exterior;
    vc_step_error := null;

    /* Se a invoice for financeira */
    IF (pc_classe_invoice = 'F') THEN
      FOR i IN cur_valor_total_f LOOP

        IF (i.auxiliar6 IS null) THEN
          vc_step_error := 'O campo tipo documento c�mbio deve estar preenchido na tabela do sistema n� 128, para cada tipo de linha da invoice.';
          RAISE ve_excecao;
        END IF;

        vc_step_error := 'Cursor tipo do documento das invoices com classe = F.';
        OPEN  cur_tipo_documento (i.auxiliar6);
        FETCH cur_tipo_documento INTO vn_tipo_documento_id;
        CLOSE cur_tipo_documento;
        vc_step_error := null;

        IF (vn_tipo_documento_id IS null) THEN
          vc_step_error := 'O c�digo ' || i.auxiliar6 || ' n�o est� cadastrado na tabela do sistema n� 301 ou o tipo fixo � diferente de IF.';
          RAISE ve_excecao;
        END IF;

        IF (nvl (i.desconta_irrf_ivc, 'N') = 'S') THEN
          vc_tipo_calculo_irrf := 'F';
        ELSE
          vc_tipo_calculo_irrf := 'D';
        END IF;

        IF (nvl (i.desconta_iss_ivc, 'N') = 'S') THEN
          vc_tipo_calculo_iss := 'F';
        ELSE
          vc_tipo_calculo_iss := 'D';
        END IF;

        IF (i.valor_total > 0) THEN

          vc_step_error := 'Gerando o documento invoice financeira com classe da invoice = F.';
          vn_documento_id := fnc_incluir_documento (
             pn_empresa_id                 /*  1 */
           , pn_organizacao_id             /*  2 */
           , pn_moeda_id                   /*  3 */
           , pn_incoterm_id                /*  4 */
           , i.valor_total                 /*  5 */
           , pn_usuario_id                 /*  6 */
           , pn_embarque_id                /*  7 */
           , pc_embarque_num               /*  8 */
           , pn_embarque_ano               /*  9 */
           , pn_export_id                  /* 10 */
           , pn_export_site_id             /* 11 */
           , vn_banco_exterior_id          /* 12 */
           , vn_conta_exterior_id          /* 13 */
           , pn_termo_id                   /* 14 */
           , pn_invoice_id                 /* 15 */
           , pc_invoice_num                /* 16 */
           , vn_tipo_documento_id          /* 17 */
           , null                          /* 18 */
           , trunc (pd_data_emissao)       /* 19 */
           , trunc (pd_data_base)          /* 20 */
           , trunc (pd_data_conhecimento)  /* 21 */
           , trunc (pd_data_embarque)      /* 22 */
           , i.aliq_irrf_ivc               /* 23 */
           , i.desconta_irrf_ivc           /* 24 */
           , i.valor_bruto                 /* 25 */
           , vc_tipo_calculo_irrf          /* 26 */
           , i.aliq_iss_ivc                /* 27 */
           , i.desconta_iss_ivc            /* 28 */
           , vc_tipo_calculo_iss           /* 29 */
          );
          vc_step_error := null;

          vc_step_error := 'UPDATE nas linhas da invoice com o ID do documento';
          UPDATE imp_invoices_lin iil
             SET iil.global_atributo1 = vn_documento_id
           WHERE iil.invoice_id  = pn_invoice_id
             AND nvl (iil.flag_vr_remeter, 'N') = 'S'
             AND EXISTS (SELECT 1
                           FROM cmx_tabelas ct
                          WHERE iil.tp_linha_id                  = ct.tabela_id
                            AND ct.auxiliar6                     = i.auxiliar6
                            AND nvl (iil.aliq_irrf, 0)           = nvl (i.aliq_irrf_ivc, 0)
                            AND nvl (iil.desconta_irrf_ivc, 'N') = nvl (i.desconta_irrf_ivc, 'N')
                            AND nvl (iil.aliq_iss, 0)            = nvl (i.aliq_iss_ivc, 0)
                            AND nvl (iil.desconta_iss_ivc, 'N')  = nvl (i.desconta_iss_ivc, 'N') );
          vc_step_error := null;
        END IF;

      END LOOP;

    /* Se a invoice for de mercadoria e financeira */
    ELSIF (pc_classe_invoice = 'MF') THEN
      FOR i IN cur_valor_total_mf LOOP
        IF (i.auxiliar6 IS null) THEN
          vc_step_error := 'O campo tipo documento c�mbio deve estar preenchido na tabela do sistema n� 128, para todas as linhas da invoice que t�m tipo c�mbio igual a F.';
          RAISE ve_excecao;
        END IF;

        vc_step_error := 'Cursor tipo do documento das invoices com classe = MF.';
        OPEN  cur_tipo_documento (i.auxiliar6);
        FETCH cur_tipo_documento INTO vn_tipo_documento_id;
        CLOSE cur_tipo_documento;
        vc_step_error := null;

        IF (vn_tipo_documento_id IS null) THEN
          vc_step_error := 'O c�digo ' || i.auxiliar6 || ' n�o est� cadastrado na tabela do sistema n� 301 ou o tipo fixo � diferente de IF.';
          RAISE ve_excecao;
        END IF;

        IF (nvl (i.desconta_irrf_ivc, 'N') = 'S') THEN
          vc_tipo_calculo_irrf := 'F';
        ELSE
          vc_tipo_calculo_irrf := 'D';
        END IF;

        IF (nvl (i.desconta_iss_ivc, 'N') = 'S') THEN
          vc_tipo_calculo_iss := 'F';
        ELSE
          vc_tipo_calculo_iss := 'D';
        END IF;

        IF (i.valor_total > 0) THEN

          vc_step_error := 'Gerando o documento invoice financeira com classe da invoice = MF.';
          vn_documento_id := fnc_incluir_documento (
             pn_empresa_id                 /*  1 */
           , pn_organizacao_id             /*  2 */
           , pn_moeda_id                   /*  3 */
           , pn_incoterm_id                /*  4 */
           , i.valor_total                 /*  5 */
           , pn_usuario_id                 /*  6 */
           , pn_embarque_id                /*  7 */
           , pc_embarque_num               /*  8 */
           , pn_embarque_ano               /*  9 */
           , pn_export_id                  /* 10 */
           , pn_export_site_id             /* 11 */
           , vn_banco_exterior_id          /* 12 */
           , vn_conta_exterior_id          /* 13 */
           , pn_termo_id                   /* 14 */
           , pn_invoice_id                 /* 15 */
           , pc_invoice_num                /* 16 */
           , vn_tipo_documento_id          /* 17 */
           , null                          /* 18 */
           , trunc (pd_data_emissao)       /* 19 */
           , trunc (pd_data_base)          /* 20 */
           , trunc (pd_data_conhecimento)  /* 21 */
           , trunc (pd_data_embarque)      /* 22 */
           , i.aliq_irrf_ivc               /* 23 */
           , i.desconta_irrf_ivc           /* 24 */
           , i.valor_bruto                 /* 25 */
           , vc_tipo_calculo_irrf          /* 26 */
           , i.aliq_iss_ivc                /* 27 */
           , i.desconta_iss_ivc            /* 28 */
           , vc_tipo_calculo_iss           /* 29 */
          );
          vc_step_error := null;

          vc_step_error := 'UPDATE nas linhas da invoice com o ID do documento';
          UPDATE imp_invoices_lin iil
             SET iil.global_atributo1 = vn_documento_id
           WHERE iil.invoice_id  = pn_invoice_id
             AND nvl (iil.flag_vr_remeter, 'N') = 'S'
             AND EXISTS (SELECT 1
                           FROM cmx_tabelas ct
                          WHERE iil.tp_linha_id                  = ct.tabela_id
                            AND ct.auxiliar3                     = 'F'
                            AND ct.auxiliar6                     = i.auxiliar6
                            AND nvl (iil.aliq_irrf, 0)           = nvl (i.aliq_irrf_ivc, 0)
                            AND nvl (iil.desconta_irrf_ivc, 'N') = nvl (i.desconta_irrf_ivc, 'N')
                            AND nvl (iil.aliq_iss, 0)            = nvl (i.aliq_iss_ivc, 0)
                            AND nvl (iil.desconta_iss_ivc, 'N')  = nvl (i.desconta_iss_ivc, 'N') );
          vc_step_error := null;
        END IF;

      END LOOP;
    END IF;

  EXCEPTION
    WHEN ve_excecao THEN
      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_INVOICE_FINANCEIRA. Erro na ' ||
         'rotina de cria��o do documento invoice financeira [' ||
         vc_step_error || '].'
      );

    WHEN others THEN
      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_INVOICE_FINANCEIRA [' || sqlerrm ||
         ']. Erro na rotina de cria��o do documento invoice financeira [' ||
         vc_step_error || '].'
      );
  END gera_invoice_financeira;


  /**
   * Esta procedure ser� utilizada para gerar as comiss�es de importa��o.
   * Ser� chamada da rotina de gera��o de documentos.
   */
  PROCEDURE gera_comissao_importacao (
     pn_empresa_id            imp_invoices.empresa_id%TYPE
   , pn_organizacao_id        imp_invoices.organizacao_id%TYPE
   , pn_moeda_id              imp_invoices.moeda_id%TYPE
   , pn_incoterm_id           imp_invoices.incoterm_id%TYPE
   , pn_usuario_id            sen_usuarios.id%TYPE
   , pn_export_id             imp_invoices.export_id%TYPE
   , pn_export_site_id        imp_invoices.export_site_id%TYPE
   , pn_termo_id              imp_invoices.termo_id%TYPE
   , pn_invoice_id            imp_invoices.invoice_id%TYPE
   , pc_invoice_num           imp_invoices.invoice_num%TYPE
   , pn_embarque_id           imp_invoices.embarque_id%TYPE
   , pc_embarque_num          imp_embarques.embarque_num%TYPE
   , pn_embarque_ano          imp_embarques.embarque_ano%TYPE
   , pd_data_emissao          imp_invoices.dt_emissao%TYPE
   , pd_data_base             imp_invoices.dt_base%TYPE
   , pd_data_conhecimento     imp_conhecimentos.dt_emissao%TYPE
   , pd_data_embarque         imp_cronograma.dt_realizada%TYPE
   , pc_classe_invoice        VARCHAR2
  )
  IS
    /* Esse cursor ser� utilizado para calcular comiss�o de representante.
     * Ser� utilizado quando o par�metro pc_classe_invoice for igual a 'F'.
     * As linhas da invoice ser�o agrupadas pelo tipo documento c�mbio
     * (auxiliar6 da tabela do sistema de tipos de linha de invoice n� 128) e
     * pelos dados do representante.
     */
    CURSOR cur_comissao_representante_f IS
        SELECT round (
                  nvl (
                     sum (
                       decode (
                          nvl (iil.base_comissao,'FOB')
                        , 'VF', iil.valor_fixo_comissao
                        , iil.qtde * iil.preco_unitario_m * iil.repres_pc_comissao / 100
                       )
                     )
                   , 0
                  )
                , 2
               ) valor_comissao
             , iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id
             , ct.auxiliar6
          FROM imp_invoices_lin iil
             , cmx_tabelas      ct
         WHERE iil.invoice_id  =  pn_invoice_id
           AND iil.tp_linha_id =  ct.tabela_id
           AND iil.repres_id   IS NOT null
      GROUP BY ct.auxiliar6
             , iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id;

    /* Esse cursor ser� utilizado para calcular comiss�o de representante.
     * Ser� utilizado quando o par�metro pc_classe_invoice for igual a 'MF' (na
     * parte financeira). Ser� somente para as linhas de invoice que t�m o tipo
     * c�mbio igual a F. As linhas da invoice ser�o agrupadas pelo tipo
     * documento c�mbio (auxiliar6 da tabela do sistema de tipos de linha de
     * invoice n� 128) e pelos dados do representante.
     */
    CURSOR cur_comissao_representante_mf1 IS
        SELECT round (
                  nvl (
                     sum (
                       decode (
                          nvl (iil.base_comissao,'FOB')
                        , 'VF', iil.valor_fixo_comissao
                        , iil.qtde * iil.preco_unitario_m * iil.repres_pc_comissao / 100
                       )
                     )
                   , 0
                  )
                , 2
               ) valor_comissao
             , iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id
             , ct.auxiliar6
          FROM imp_invoices_lin iil
             , cmx_tabelas      ct
         WHERE iil.invoice_id  =  pn_invoice_id
           AND iil.tp_linha_id =  ct.tabela_id
           AND ct.auxiliar3    =  'F'
           AND iil.repres_id   IS NOT null
      GROUP BY ct.auxiliar6
             , iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id;

    /* Esse cursor ser� utilizado para calcular comiss�o de representante.
     * Ser� utilizado quando o par�metro pc_classe_invoice for igual a 'M'.
     * As linhas da invoice ser�o agrupadas pelos dados do representante.
     */
    CURSOR cur_comissao_representante_m IS
        SELECT round (
                  nvl (
                     sum (
                       decode (
                          nvl (iil.base_comissao,'FOB')
                        , 'VF', iil.valor_fixo_comissao
                        , decode (
                             ct.auxiliar1
                           , 'M', nvl (iil.vrt_fob_m, iil.qtde * iil.preco_unitario_m) * iil.repres_pc_comissao / 100
                           , iil.qtde * iil.preco_unitario_m * iil.repres_pc_comissao / 100
                          )
                       )
                     )
                     , 0
                  )
                , 2
               ) valor_comissao
             , iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id
          FROM imp_invoices_lin iil
             , cmx_tabelas      ct
         WHERE iil.invoice_id  =  pn_invoice_id
           AND iil.tp_linha_id =  ct.tabela_id
           AND iil.repres_id   IS NOT null
      GROUP BY iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id;

    /* Esse cursor ser� utilizado para calcular comiss�o de representante.
     * Ser� utilizado quando o par�metro pc_classe_invoice for igual a 'MF' (na
     * parte mercadoria). Ser� somente para as linhas de invoice que t�m o tipo
     * c�mbio igual a M. As linhas da invoice ser�o agrupadas pelos dados do
     * representante.
     */
    CURSOR cur_comissao_representante_mf2 IS
        SELECT round (
                  nvl (
                     sum (
                       decode (
                          nvl (iil.base_comissao,'FOB')
                        , 'VF', iil.valor_fixo_comissao
                        , decode (
                             ct.auxiliar1
                           , 'M', nvl (iil.vrt_fob_m, iil.qtde * iil.preco_unitario_m) * iil.repres_pc_comissao / 100
                           , iil.qtde * iil.preco_unitario_m * iil.repres_pc_comissao / 100
                          )
                       )
                     )
                   , 0
                  )
                , 2
               ) valor_comissao
             , iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id
          FROM imp_invoices_lin iil
             , cmx_tabelas      ct
         WHERE iil.invoice_id  =  pn_invoice_id
           AND iil.tp_linha_id =  ct.tabela_id
           AND ct.auxiliar3    =  'M'
           AND iil.repres_id   IS NOT null
      GROUP BY iil.repres_id
             , iil.repres_site_id
             , iil.repres_banco_agencia_id
             , iil.repres_conta_id;

    /* Esse cursor ser� utilizado para obter o n�mero do documento ao qual a
     * comiss�o ser� aplicada. Ser� utilizado quando o par�metro
     * pc_classe_invoice for igual a 'F' ou 'MF' (na parte financeira).
     */
    CURSOR cur_aplicado_a_documento_f (pc_cod_tipo_documento cmx_tabelas.auxiliar6%TYPE) IS
      SELECT ca_doc.documento_id
        FROM cam_documentos ca_doc
           , cmx_tabelas    ct
       WHERE ca_doc.entidade_origem   = 2
         AND ca_doc.entidade_id       = pn_export_id
         AND ca_doc.entidade_site_id  = pn_export_site_id
         AND ca_doc.tipo_id           = ct.tabela_id
         AND ct.tipo                  = '301'
         AND ct.codigo                = pc_cod_tipo_documento
         AND ca_doc.numero            = pc_invoice_num
         AND ca_doc.data_emissao      = trunc (pd_data_emissao);

    /* Esse cursor ser� utilizado para obter o n�mero do documento ao qual a
     * comiss�o ser� aplicada. Ser� utilizado quando o par�metro
     * pc_classe_invoice for igual a 'M' ou 'MF' (na parte mercadoria).
     */
    CURSOR cur_aplicado_a_documento_m IS
      SELECT ca_doc.documento_id
        FROM cam_documentos ca_doc
           , cmx_tabelas    ct
       WHERE ca_doc.entidade_origem   = 2
         AND ca_doc.entidade_id       = pn_export_id
         AND ca_doc.entidade_site_id  = pn_export_site_id
         AND ca_doc.tipo_id           = ct.tabela_id
         AND ct.tipo                  = '301'
         AND ct.codigo                = 'CI'
         AND ca_doc.numero            = pc_invoice_num
         AND ca_doc.data_emissao      = trunc (pd_data_emissao);

    vn_tipo_documento_id        cmx_tabelas.tabela_id%TYPE;
    vn_aplicado_a_documento_id  cam_documentos.aplicado_a_documento_id%TYPE;
    vn_qtde_comissoes_geradas   NUMBER := 0;
    vc_step_error               VARCHAR2(1000);
    ve_excecao                  EXCEPTION;
    vn_documento_id             cam_documentos.documento_id%TYPE;

  BEGIN
    vc_step_error := 'Cursor tipo do documento.';
    OPEN  cur_tipo_documento ('CIP');
    FETCH cur_tipo_documento INTO vn_tipo_documento_id;
    CLOSE cur_tipo_documento;
    vc_step_error := null;

    IF (vn_tipo_documento_id IS null) THEN
      vc_step_error := 'O c�digo CIP n�o est� cadastrado na tabela do sistema n� 301.';
      RAISE ve_excecao;
    END IF;

    /* O c�lculo da comiss�o ser� diferenciado por classe de invoice. */

    /* Se a classe da invoice for financeira */
    IF (pc_classe_invoice = 'F') THEN
      FOR i IN cur_comissao_representante_f LOOP
        IF (i.auxiliar6 IS null) THEN
          vc_step_error := 'O campo tipo documento c�mbio deve estar preenchido na tabela do sistema n� 128, para cada tipo de linha da invoice.';
          RAISE ve_excecao;
        END IF;

        IF (i.valor_comissao = 0) THEN
          vc_step_error := 'O valor da comiss�o deve ser maior que zero.';
          RAISE ve_excecao;
        END IF;

        vc_step_error := 'Cursor para obter o n�mero do documento ao qual a comiss�o ser� aplicada, quando a classe da invoice for F.';
        OPEN  cur_aplicado_a_documento_f (i.auxiliar6);
        FETCH cur_aplicado_a_documento_f INTO vn_aplicado_a_documento_id;
        CLOSE cur_aplicado_a_documento_f;
        vc_step_error := null;

        vc_step_error := 'Gerando o documento de comiss�o de importa��o, para invoices do tipo financeira.';
        vn_documento_id := fnc_incluir_documento (
           pn_empresa_id                 /*  1 */
         , pn_organizacao_id             /*  2 */
         , pn_moeda_id                   /*  3 */
         , pn_incoterm_id                /*  4 */
         , i.valor_comissao              /*  5 */
         , pn_usuario_id                 /*  6 */
         , pn_embarque_id                /*  7 */
         , pc_embarque_num               /*  8 */
         , pn_embarque_ano               /*  9 */
         , i.repres_id                   /* 10 */
         , i.repres_site_id              /* 11 */
         , i.repres_banco_agencia_id     /* 12 */
         , i.repres_conta_id             /* 13 */
         , pn_termo_id                   /* 14 */
         , pn_invoice_id                 /* 15 */
         , pc_invoice_num || '/' ||
           i.auxiliar6                   /* 16 */
         , vn_tipo_documento_id          /* 17 */
         , vn_aplicado_a_documento_id    /* 18 */
         , trunc (pd_data_emissao)       /* 19 */
         , trunc (pd_data_base)          /* 20 */
         , trunc (pd_data_conhecimento)  /* 21 */
         , trunc (pd_data_embarque)      /* 22 */
         , NULL                          /* 23 aliq_irrf */
         , NULL                          /* 24 pc_descontar_irrf */
         , i.valor_comissao              /* 25 valor_bruto */
         , 'D'                           /* 26 */
         , NULL                          /* 27 pn_aliq_iss         */
         , NULL                          /* 28 pc_descontar_iss    */
         , NULL                          /* 29 pc_tipo_calculo_iss */
        );
        vc_step_error := null;

        vn_qtde_comissoes_geradas := vn_qtde_comissoes_geradas + 1;
      END LOOP;

    /* Se a classe da invoice for mercadoria. */
    ELSIF (pc_classe_invoice = 'M') THEN
      FOR i IN cur_comissao_representante_m LOOP
        vc_step_error := 'Cursor para obter o n�mero do documento ao qual a comiss�o ser� aplicada, quando a classe da invoice for M.';
        OPEN  cur_aplicado_a_documento_m;
        FETCH cur_aplicado_a_documento_m INTO vn_aplicado_a_documento_id;
        CLOSE cur_aplicado_a_documento_m;
        vc_step_error := null;

        IF (i.valor_comissao = 0) THEN
          vc_step_error := 'O valor da comiss�o deve ser maior que zero.';
          RAISE ve_excecao;
        END IF;

        vc_step_error := 'Gerando o documento de comiss�o de importa��o, para invoices do tipo mercadoria.';
        vn_documento_id := fnc_incluir_documento (
           pn_empresa_id                 /*  1 */
         , pn_organizacao_id             /*  2 */
         , pn_moeda_id                   /*  3 */
         , pn_incoterm_id                /*  4 */
         , i.valor_comissao              /*  5 */
         , pn_usuario_id                 /*  6 */
         , pn_embarque_id                /*  7 */
         , pc_embarque_num               /*  8 */
         , pn_embarque_ano               /*  9 */
         , i.repres_id                   /* 10 */
         , i.repres_site_id              /* 11 */
         , i.repres_banco_agencia_id     /* 12 */
         , i.repres_conta_id             /* 13 */
         , pn_termo_id                   /* 14 */
         , pn_invoice_id                 /* 15 */
         , pc_invoice_num                /* 16 */
         , vn_tipo_documento_id          /* 17 */
         , vn_aplicado_a_documento_id    /* 18 */
         , trunc (pd_data_emissao)       /* 19 */
         , trunc (pd_data_base)          /* 20 */
         , trunc (pd_data_conhecimento)  /* 21 */
         , trunc (pd_data_embarque)      /* 22 */
         , null                          /* 23 aliq_irrf */
         , null                          /* 24 pc_descontar_irrf */
         , i.valor_comissao              /* 25 valor_bruto */
         , 'D'                           /* 26 */
         , NULL                          /* 27 pn_aliq_iss         */
         , NULL                          /* 28 pc_descontar_iss    */
         , NULL                          /* 29 pc_tipo_calculo_iss */
        );
        vc_step_error := null;

        vn_qtde_comissoes_geradas := vn_qtde_comissoes_geradas + 1;
      END LOOP;

    /* Se a classe da invoice for mercadoria e financeira. */
    ELSIF (pc_classe_invoice = 'MF') THEN
      /* Parte financeira */
      FOR i IN cur_comissao_representante_mf1 LOOP
        IF (i.auxiliar6 IS null) THEN
          vc_step_error := 'O campo tipo documento c�mbio deve estar preenchido na tabela do sistema n� 128, para todas as linhas da invoice que t�m tipo c�mbio igual a F.';
          RAISE ve_excecao;
        END IF;

        vc_step_error := 'Cursor para obter o n�mero do documento ao qual a comiss�o ser� aplicada, quando a classe da invoice for MF (parte financeira).';
        OPEN  cur_aplicado_a_documento_f (i.auxiliar6);
        FETCH cur_aplicado_a_documento_f INTO vn_aplicado_a_documento_id;
        CLOSE cur_aplicado_a_documento_f;
        vc_step_error := null;

        IF (i.valor_comissao = 0) THEN
          vc_step_error := 'O valor da comiss�o deve ser maior que zero para as linhas que t�m tipo c�mbio igual a F.';
          RAISE ve_excecao;
        END IF;

        vc_step_error := 'Gerando o documento de comiss�o de importa��o, para invoices do tipo mercadoria e financeira (parte financeira).';
        vn_documento_id := fnc_incluir_documento (
           pn_empresa_id                 /*  1 */
         , pn_organizacao_id             /*  2 */
         , pn_moeda_id                   /*  3 */
         , pn_incoterm_id                /*  4 */
         , i.valor_comissao              /*  5 */
         , pn_usuario_id                 /*  6 */
         , pn_embarque_id                /*  7 */
         , pc_embarque_num               /*  8 */
         , pn_embarque_ano               /*  9 */
         , i.repres_id                   /* 10 */
         , i.repres_site_id              /* 11 */
         , i.repres_banco_agencia_id     /* 12 */
         , i.repres_conta_id             /* 13 */
         , pn_termo_id                   /* 14 */
         , pn_invoice_id                 /* 15 */
         , pc_invoice_num || '/' ||
           i.auxiliar6                   /* 16 */
         , vn_tipo_documento_id          /* 17 */
         , vn_aplicado_a_documento_id    /* 18 */
         , trunc (pd_data_emissao)       /* 19 */
         , trunc (pd_data_base)          /* 20 */
         , trunc (pd_data_conhecimento)  /* 21 */
         , trunc (pd_data_embarque)      /* 22 */
         , null                          /* 23 aliq_irrf */
         , null                          /* 24 pc_descontar_irrf */
         , i.valor_comissao              /* 25 valor_bruto */
         , 'D'                           /* 26 */
         , NULL                          /* 27 pn_aliq_iss         */
         , NULL                          /* 28 pc_descontar_iss    */
         , NULL                          /* 29 pc_tipo_calculo_iss */
        );
        vc_step_error := null;

        vn_qtde_comissoes_geradas := vn_qtde_comissoes_geradas + 1;
      END LOOP;

      /* Parte mercadoria */
      FOR i IN cur_comissao_representante_mf2 LOOP
        vc_step_error := 'Cursor para obter o n�mero do documento ao qual a comiss�o ser� aplicada, quando a classe da invoice for MF (parte mercadoria).';
        OPEN  cur_aplicado_a_documento_m;
        FETCH cur_aplicado_a_documento_m INTO vn_aplicado_a_documento_id;
        CLOSE cur_aplicado_a_documento_m;
        vc_step_error := null;

        IF (i.valor_comissao = 0) THEN
          vc_step_error := 'O valor da comiss�o deve ser maior que zero para as linhas que t�m tipo c�mbio igual a M.';
          RAISE ve_excecao;
        END IF;

        vc_step_error := 'Gerando o documento de comiss�o de importa��o, para invoices do tipo mercadoria e financeira (parte mercadoria).';
        vn_documento_id := fnc_incluir_documento (
           pn_empresa_id                 /*  1 */
         , pn_organizacao_id             /*  2 */
         , pn_moeda_id                   /*  3 */
         , pn_incoterm_id                /*  4 */
         , i.valor_comissao              /*  5 */
         , pn_usuario_id                 /*  6 */
         , pn_embarque_id                /*  7 */
         , pc_embarque_num               /*  8 */
         , pn_embarque_ano               /*  9 */
         , i.repres_id                   /* 10 */
         , i.repres_site_id              /* 11 */
         , i.repres_banco_agencia_id     /* 12 */
         , i.repres_conta_id             /* 13 */
         , pn_termo_id                   /* 14 */
         , pn_invoice_id                 /* 15 */
         , pc_invoice_num || '/CI'       /* 16 */
         , vn_tipo_documento_id          /* 17 */
         , vn_aplicado_a_documento_id    /* 18 */
         , trunc (pd_data_emissao)       /* 19 */
         , trunc (pd_data_base)          /* 20 */
         , trunc (pd_data_conhecimento)  /* 21 */
         , trunc (pd_data_embarque)      /* 22 */
         , null                          /* 23 aliq_irrf */
         , null                          /* 24 pc_descontar_irrf */
         , i.valor_comissao              /* 25 valor_bruto */
         , 'D'                           /* 26 */
         , NULL                          /* 27 pn_aliq_iss         */
         , NULL                          /* 28 pc_descontar_iss    */
         , NULL                          /* 29 pc_tipo_calculo_iss */
        );
        vc_step_error := null;

        vn_qtde_comissoes_geradas := vn_qtde_comissoes_geradas + 1;
      END LOOP;
    END IF;

    IF (vn_qtde_comissoes_geradas = 1) AND (pc_classe_invoice <> 'M') THEN
      vc_step_error := 'Alterando o n�mero do documento de comiss�o.';
      UPDATE cam_documentos ca_doc
         SET numero = pc_invoice_num
       WHERE invoice_importacao_id = pn_invoice_id
         AND EXISTS                (SELECT auxiliar1
                                      FROM cmx_tabelas
                                     WHERE ca_doc.tipo_id = tabela_id
                                       AND auxiliar1      = 'CIP');
      vc_step_error := null;
    END IF;

  EXCEPTION
    WHEN ve_excecao THEN
      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_COMISSAO_IMPORTACAO. Erro na ' ||
         'rotina de cria��o do documento de comiss�o de importa��o [' ||
         vc_step_error || '].'
      );

    WHEN others THEN
      raise_application_error (
         -20000
       , 'CAM_PKG_INTERFACE_IMPORTACAO.GERA_COMISSAO_IMPORTACAO [' ||
         sqlerrm || ']. Erro na rotina de cria��o do documento de comiss�o ' ||
         'de importa��o [' || vc_step_error || '].'
      );
  END gera_comissao_importacao;


  /**
   * Essa rotina inclui um documento de cambio, gera suas parcelas a ajusta
   * seu valor de acordo com a soma dos valores das parcelas geradas.
   */
  FUNCTION fnc_incluir_documento (
     pn_empresa_id                IN cam_documentos.empresa_id%TYPE                  /*  1 */
   , pn_organizacao_id            IN cam_documentos.organizacao_id%TYPE              /*  2 */
   , pn_moeda_id                  IN cam_documentos.moeda_id%TYPE                    /*  3 */
   , pn_incoterm_id               IN cam_documentos.incoterm_id%TYPE                 /*  4 */
   , pn_valor_total               IN cam_documentos.valor_total%TYPE                 /*  5 */
   , pn_usuario_id                IN sen_usuarios.id%TYPE                            /*  6 */
   , pn_embarque_importacao_id    IN cam_documentos.embarque_importacao_id%TYPE      /*  7 */
   , pc_embarque_num              IN cam_documentos.embarque_num%TYPE                /*  8 */
   , pn_embarque_ano              IN cam_documentos.embarque_ano%TYPE                /*  9 */
   , pn_entidade_id               IN cam_documentos.entidade_id%TYPE                 /* 10 */
   , pn_entidade_site_id          IN cam_documentos.entidade_site_id%TYPE            /* 11 */
   , pn_banco_exterior_agencia_id IN cam_documentos.banco_exterior_agencia_id%TYPE   /* 12 */
   , pn_banco_exterior_conta_id   IN cam_documentos.banco_exterior_conta_id%TYPE     /* 13 */
   , pn_condicao_id               IN cam_documentos.condicao_id%TYPE                 /* 14 */
   , pn_invoice_importacao_id     IN cam_documentos.invoice_importacao_id%TYPE       /* 15 */
   , pc_numero                    IN cam_documentos.numero%TYPE                      /* 16 */
   , pn_tipo_id                   IN cam_documentos.tipo_id%TYPE                     /* 17 */
   , pn_aplicado_a_documento_id   IN cam_documentos.documento_id%TYPE                /* 18 */
   , pd_data_emissao              IN cam_documentos.data_emissao%TYPE                /* 19 */
   , pd_data_base                 IN cam_documentos.data_base%TYPE                   /* 20 */
   , pd_data_conhecimento         IN cam_documentos.data_conhecimento%TYPE           /* 21 */
   , pd_data_embarque             IN cam_documentos.data_embarque%TYPE               /* 22 */
   , pn_aliq_irrf                 IN cam_documentos.aliquota_irrf%TYPE               /* 23 */
   , pc_descontar_irrf            IN cam_documentos.flag_irrf_descontado%TYPE        /* 24 */
   , pn_valor_bruto               IN cam_documentos.valor_bruto%TYPE                 /* 25 */
   , pc_tipo_calculo_irrf         IN cam_documentos.tipo_calculo_irrf%TYPE           /* 26 */
   , pn_aliq_iss                  IN cam_documentos.aliquota_iss%TYPE                /* 27 */
   , pc_descontar_iss             IN cam_documentos.flag_iss_descontado%TYPE         /* 28 */
   , pc_tipo_calculo_iss          IN cam_documentos.tipo_calculo_iss%TYPE            /* 29 */
  ) RETURN NUMBER
  IS
    vn_documento_id  cam_documentos.documento_id%TYPE;
    vd_data_atual    DATE;
    vn_valor_total   cam_documentos.valor_total%TYPE;

    vc_step_error    VARCHAR2(1000);

  BEGIN
    /* Dados necess�rios ao documento. */
    vc_step_error := 'Obtendo o pr�ximo identificador do documento na seq��ncia.';
    SELECT cam_documentos_sq1.nextval
      INTO vn_documento_id
      FROM dual
     WHERE rownum = 1;
    vc_step_error := null;

    vd_data_atual := sysdate;

    /* Inclus�o do documento. */
    vc_step_error := 'Inclu�ndo o novo documento ' || pc_numero || '.';
    INSERT INTO cam_documentos (
       empresa_id                    /* 01 */
     , organizacao_id                /* 02 */
     , moeda_id                      /* 03 */
     , incoterm_id                   /* 04 */
     , valor_total                   /* 05 */
     , creation_date                 /* 06 */
     , created_by                    /* 07 */
     , last_update_date              /* 08 */
     , last_updated_by               /* 09 */
     , embarque_importacao_id        /* 10 */
     , embarque_num                  /* 11 */
     , embarque_ano                  /* 12 */
     , entidade_origem               /* 13 */
     , entidade_id                   /* 14 */
     , entidade_site_id              /* 15 */
     , banco_exterior_agencia_id     /* 16 */
     , banco_exterior_conta_id       /* 17 */
     , condicao_origem               /* 18 */
     , condicao_id                   /* 19 */
     , documento_id                  /* 20 */
     , invoice_importacao_id         /* 21 */
     , numero                        /* 22 */
     , tipo_id                       /* 23 */
     , aplicado_a_documento_id       /* 24 */
     , data_emissao                  /* 25 */
     , data_base                     /* 26 */
     , data_conhecimento             /* 27 */
     , data_embarque                 /* 28 */
     , tipo_operacao                 /* 29 */
     , origem_id                     /* 30 */
     , aliquota_irrf                 /* 31 */
     , flag_irrf_descontado          /* 32 */
     , valor_bruto                   /* 33 */
     , tipo_calculo_irrf             /* 34 */
     , aliquota_iss                  /* 35 */
     , flag_iss_descontado           /* 36 */
     , tipo_calculo_iss              /* 37 */
    )
    VALUES (
       pn_empresa_id                 /* 01 */
     , pn_organizacao_id             /* 02 */
     , pn_moeda_id                   /* 03 */
     , pn_incoterm_id                /* 04 */
     , pn_valor_total                /* 05 */
     , vd_data_atual                 /* 06 */
     , pn_usuario_id                 /* 07 */
     , vd_data_atual                 /* 08 */
     , pn_usuario_id                 /* 09 */
     , pn_embarque_importacao_id     /* 10 */
     , pc_embarque_num               /* 11 */
     , pn_embarque_ano               /* 12 */
     , 2                             /* 13 */
     , pn_entidade_id                /* 14 */
     , pn_entidade_site_id           /* 15 */
     , pn_banco_exterior_agencia_id  /* 16 */
     , pn_banco_exterior_conta_id    /* 17 */
     , 2                             /* 18 */
     , pn_condicao_id                /* 19 */
     , vn_documento_id               /* 20 */
     , pn_invoice_importacao_id      /* 21 */
     , pc_numero                     /* 22 */
     , pn_tipo_id                    /* 23 */
     , pn_aplicado_a_documento_id    /* 24 */
     , trunc (pd_data_emissao)       /* 25 */
     , trunc (pd_data_base)          /* 26 */
     , trunc (pd_data_conhecimento)  /* 27 */
     , trunc (pd_data_embarque)      /* 28 */
     , 'P'                           /* 29 */
     , gn_origem_documento_id        /* 30 */
     , pn_aliq_irrf                  /* 31 */
     , pc_descontar_irrf             /* 32 */
     , pn_valor_bruto                /* 33 */
     , pc_tipo_calculo_irrf          /* 34 */
     , pn_aliq_iss                   /* 35 */
     , pc_descontar_iss              /* 36 */
     , pc_tipo_calculo_iss           /* 37 */
    );
    vc_step_error := null;

    /* Gera��o das parcelas. */
    vc_step_error := 'Gerando as parcelas do documento ' || pc_numero || '.';
    vn_valor_total := cam_pkg_parcelas.fnc_gerar (
                         vn_documento_id
                       , 2
                       , pn_condicao_id
                       , pd_data_base
                       , pn_valor_total
                       , vd_data_atual
                       , pn_usuario_id
                       , pn_empresa_id
                      );
    vc_step_error := null;

    /* Atualiza��o do valor do documento. */
    vc_step_error := 'Atualizando o valor do documento ' || pc_numero || '.';
    UPDATE cam_documentos
       SET valor_total  = vn_valor_total
     WHERE documento_id = vn_documento_id;
    vc_step_error := null;

    RETURN (vn_documento_id);
  EXCEPTION
    WHEN others THEN
      raise_application_error (
         -20000
       , 'fnc_incluir_documento [' || sqlerrm || ']. Erro na rotina de ' ||
         'inclus�o de documentos [' || vc_step_error || '].'
      );
  END fnc_incluir_documento;


  /**
   * Fun��o que calcula o valor FOB das linhas da invoice sobre o qual ser�
   * calculada a comiss�o. Retorna o id do evento para verifica��o de erros.
   */
  FUNCTION fnc_calcula_fob (
     pn_embarque_id   imp_embarques.embarque_id%TYPE
   , pc_embarque_ano  VARCHAR2
   , pn_invoice_id    imp_invoices.invoice_id%TYPE
   , pn_created_by    sen_usuarios.id%TYPE
  )
  RETURN cmx_eventos.evento_id%TYPE
  IS
    TYPE reg_lin_mercadoria_ivc IS RECORD (
       invoice_lin_id          imp_invoices_lin.invoice_lin_id%TYPE
     , invoice_id              imp_invoices.invoice_id%TYPE
     , qtde                    imp_invoices_lin.qtde%TYPE
     , preco_unitario_m        imp_invoices_lin.preco_unitario_m%TYPE
     , pesoliq_tot_ivc         imp_invoices.peso_liquido%TYPE
     , pesoliq_tot             imp_invoices_lin.pesoliq_tot%TYPE
     , flag_fr_embutido        imp_invoices.flag_fr_embutido%TYPE
     , flag_sg_embutido        imp_invoices.flag_sg_embutido%TYPE
     , flag_dsp_ddu_embutida   imp_invoices.flag_dsp_ddu_embutida%TYPE
     , vrt_frivc_m             imp_invoices_lin.vrt_frivc_m%TYPE
     , vrt_sgivc_m             imp_invoices_lin.vrt_sgivc_m%TYPE
     , vrt_dspivc_m            imp_invoices_lin.vrt_dsp_ddu_m%TYPE
     , vrt_fob_m               imp_invoices_lin.vrt_fob_m%TYPE
     , invoice_num             imp_invoices.invoice_num%TYPE
     , nr_linha                imp_invoices_lin.nr_linha%TYPE
    );

    TYPE typ_lin_mercadoria_ivc IS TABLE OF reg_lin_mercadoria_ivc INDEX BY BINARY_INTEGER;
    tb_ivc_lin                  typ_lin_mercadoria_ivc;
    vn_global_qtde_lin          NUMBER := 0;
    vn_global_evento_id         cmx_eventos.evento_id%TYPE := 0;
    vn_global_total_pesoliq_ivc NUMBER := 0;

    /* Esta procedure carregar� numa PL/SQL table todas as linhas tipo
     * mercadoria para evitar outros acessos a tabela IMP_INVOICES.
     */
    PROCEDURE prc_carrega_linhas_invoice
    IS
      /* Evitar mutating table ao vincular uma invoice num embarque com conhecimento */
      pragma autonomous_transaction;

      CURSOR cur_invoices_lin IS
        SELECT iil.invoice_lin_id
             , iil.invoice_id
             , ii.invoice_num
             , iil.nr_linha
             , nvl (ii.peso_liquido, 0)             peso_liquido
             , iil.qtde
             , iil.preco_unitario_m
             , ii.flag_fr_embutido
             , ii.flag_sg_embutido
             , ii.flag_dsp_ddu_embutida
             , ii.moeda_id
             , nvl (iil.pesoliq_unit * iil.qtde, 0) pesoliq_tot
          FROM imp_invoices         ii
             , imp_invoices_lin     iil
             , cmx_tabelas          ctl
         WHERE ii.invoice_id  = pn_invoice_id
           AND iil.invoice_id = ii.invoice_id
           AND ctl.tabela_id  = iil.tp_linha_id
           AND ctl.auxiliar1  = 'M'
      ORDER BY iil.invoice_id
             , iil.invoice_lin_id;

    BEGIN
      FOR ivc IN cur_invoices_lin LOOP
        vn_global_qtde_lin := vn_global_qtde_lin + 1;

        tb_ivc_lin(vn_global_qtde_lin).invoice_lin_id    := ivc.invoice_lin_id;
        tb_ivc_lin(vn_global_qtde_lin).invoice_id        := ivc.invoice_id;
        tb_ivc_lin(vn_global_qtde_lin).invoice_num       := ivc.invoice_num;
        tb_ivc_lin(vn_global_qtde_lin).nr_linha          := ivc.nr_linha;
        tb_ivc_lin(vn_global_qtde_lin).qtde              := ivc.qtde;
        tb_ivc_lin(vn_global_qtde_lin).preco_unitario_m  := ivc.preco_unitario_m;
        tb_ivc_lin(vn_global_qtde_lin).pesoliq_tot       := ivc.pesoliq_tot;

        tb_ivc_lin(vn_global_qtde_lin).pesoliq_tot_ivc       := ivc.peso_liquido;
        tb_ivc_lin(vn_global_qtde_lin).flag_fr_embutido      := ivc.flag_fr_embutido;
        tb_ivc_lin(vn_global_qtde_lin).flag_sg_embutido      := ivc.flag_sg_embutido;
        tb_ivc_lin(vn_global_qtde_lin).flag_dsp_ddu_embutida := ivc.flag_dsp_ddu_embutida;
        tb_ivc_lin(vn_global_qtde_lin).vrt_fob_m             := ivc.preco_unitario_m * ivc.qtde;
      END LOOP;

      IF (vn_global_qtde_lin = 0) THEN
        cmx_prc_gera_log_erros (vn_global_evento_id, 'N�o existem linhas de invoice.', 'E');
      END IF;

      /* Fechando autonomous transaction. */
      COMMIT;

    EXCEPTION
      WHEN others THEN
        cmx_prc_gera_log_erros (
           vn_global_evento_id
         , 'Erro ao carregar as linhas da invoice: ' || sqlerrm
         , 'E'
        );
    END prc_carrega_linhas_invoice;

    /* Esta procedure ratear� as diferen�as de peso l�quido entre a invoice
     * e os pesos informados nas linhas da invoice.
     */
    PROCEDURE prc_acerta_pesos
    IS
      vn_ivc_somapesoliq_lin  NUMBER := 0;
      vn_fator_pesoliq_ivc    NUMBER := 0;
      vn_soma_rateio_pesoliq  NUMBER := 0;
      vn_pesoliq_rateado      NUMBER := 0;

    BEGIN
      /* Se tiver peso total na invoice calcula os rateios */
      IF (tb_ivc_lin(1).pesoliq_tot_ivc > 0) THEN
        vn_ivc_somapesoliq_lin := 0;
        vn_fator_pesoliq_ivc   := 0;

        /* Soma total de peso das linhas da invoice */
        FOR vn_ivcsoma IN 1..vn_global_qtde_lin LOOP
          vn_ivc_somapesoliq_lin := vn_ivc_somapesoliq_lin + nvl (tb_ivc_lin(vn_ivcsoma).pesoliq_tot, 0);
        END LOOP;

        /* Obt�m o fator entre o peso da invoice e a soma dos pesos das linhas */
        IF (vn_ivc_somapesoliq_lin > 0) THEN
           vn_fator_pesoliq_ivc := (tb_ivc_lin(1).pesoliq_tot_ivc - vn_ivc_somapesoliq_lin) / vn_ivc_somapesoliq_lin;
        END IF;

        FOR ivc IN 1..vn_global_qtde_lin LOOP
          /* Faz o rateio para cada linha usando o fator */
          IF (ivc = vn_global_qtde_lin) THEN
             vn_pesoliq_rateado := (tb_ivc_lin(1).pesoliq_tot_ivc - vn_ivc_somapesoliq_lin) - vn_soma_rateio_pesoliq;
          ELSE
             vn_pesoliq_rateado := nvl ((tb_ivc_lin(ivc).pesoliq_tot * vn_fator_pesoliq_ivc), 0);
          END IF;

          /* Acerta o peso */
          tb_ivc_lin(ivc).pesoliq_tot := tb_ivc_lin(ivc).pesoliq_tot + vn_pesoliq_rateado;

          vn_soma_rateio_pesoliq      := vn_soma_rateio_pesoliq      + vn_pesoliq_rateado;
          vn_global_total_pesoliq_ivc := vn_global_total_pesoliq_ivc + tb_ivc_lin(ivc).pesoliq_tot;
        END LOOP;
      ELSE
        /* Se n�o tiver peso total na invoice soma os pesos das linhas. */
        FOR ivc IN 1..vn_global_qtde_lin LOOP
          vn_global_total_pesoliq_ivc := vn_global_total_pesoliq_ivc + tb_ivc_lin(ivc).pesoliq_tot;
        END LOOP;
      END IF;

    EXCEPTION
      WHEN others THEN
        cmx_prc_gera_log_erros (
           vn_global_evento_id
         , 'Erro no rateio do peso l�quido: ' || sqlerrm
         , 'E'
        );
    END prc_acerta_pesos;


    /* Esta procedure ir� buscar todas as linhas de mercadoria da invoice e
     * ratear os valores frete internacional e seguro internacional quando
     * houver na invoice. Isto ocorre para que tenhamos o valor FOB de cada
     * linha nos casos onde o frete ou seguro estiver embutido.
     */
    PROCEDURE prc_rateia_valores_invoice
    IS
      vn_soma_frete_int_linhas  NUMBER := 0;
      vn_soma_seguro_int_linhas NUMBER := 0;
      vn_soma_dsp_int_linhas    NUMBER := 0;
      vn_fator_frete_ivc        NUMBER := 0;
      vn_fator_seguro_ivc       NUMBER := 0;
      vn_fator_dsp_ivc          NUMBER := 0;
      vn_soma_valor_fob_linhas  NUMBER := 0;
      vn_soma_rateio_frete      NUMBER := 0;
      vn_soma_rateio_seguro     NUMBER := 0;
      vn_soma_rateio_dsp        NUMBER := 0;

      CURSOR cur_vrt_ivc_por_tipo (pc_tipo_linha cmx_tabelas.auxiliar1%TYPE) IS
        SELECT sum (nvl (imp_fnc_calc_total_inv_lin( iil.preco_unitario_m
                                                   , iil.qtde
                                                   , iil.invoice_lin_id
                                                   , NULL
                                                   , NULL
                                                   , NULL
                                                   , NULL
                                                   ), 0))
          FROM imp_invoices_lin  iil
             , cmx_tabelas       ct
         WHERE iil.invoice_id = pn_invoice_id
           AND ct.tabela_id   = iil.tp_linha_id
           AND ct.auxiliar1   = pc_tipo_linha;

    BEGIN

      vn_soma_rateio_frete     := 0;
      vn_fator_frete_ivc       := 0;
      vn_soma_frete_int_linhas := 0;

      /* Somaremos os valores das linhas de frete internacional para ratear nas linhas tipo mercadoria. */
      OPEN  cur_vrt_ivc_por_tipo ('I');
      FETCH cur_vrt_ivc_por_tipo INTO vn_soma_frete_int_linhas;
      CLOSE cur_vrt_ivc_por_tipo;

      /* Obt�m o fator entre o peso total e o valor de frete internacional da invoice */
      IF (vn_global_total_pesoliq_ivc > 0) THEN
        vn_fator_frete_ivc := nvl (vn_soma_frete_int_linhas / vn_global_total_pesoliq_ivc, 0);

        /* Faremos um loop nas linhas e quando trocar a invoice buscaremos os valores das linhas de frete
           internacional para ratear nas linhas tipo mercadoria. */
        FOR ivc IN 1..vn_global_qtde_lin LOOP

          IF (ivc = vn_global_qtde_lin) THEN
            tb_ivc_lin(ivc).vrt_frivc_m := vn_soma_frete_int_linhas    - vn_soma_rateio_frete;
          ELSE
            tb_ivc_lin(ivc).vrt_frivc_m := tb_ivc_lin(ivc).pesoliq_tot * vn_fator_frete_ivc;
          END IF;

          /* Se o frete da invoice for embutido subtrair� o frete rateado do valor fob de cada linha. */
          IF (tb_ivc_lin(ivc).flag_fr_embutido = 'S') THEN
            tb_ivc_lin(ivc).vrt_fob_m := tb_ivc_lin(ivc).vrt_fob_m - nvl (tb_ivc_lin(ivc).vrt_frivc_m, 0);
          END IF;

          vn_soma_rateio_frete := vn_soma_rateio_frete + tb_ivc_lin(ivc).vrt_frivc_m;
        END LOOP;

      ELSE
        cmx_prc_gera_log_erros (
           vn_global_evento_id
         , 'Peso l�quido total zerado, frete internacional n�o rateado.'
         , 'E'
        );
      END IF;

      vn_soma_valor_fob_linhas  := 0;
      vn_soma_seguro_int_linhas := 0;
      vn_fator_seguro_ivc       := 0;

      /* Buscaremos a soma das linhas de seguro internacional para ratear nas linhas tipo mercadoria. */
      OPEN  cur_vrt_ivc_por_tipo ('S');
      FETCH cur_vrt_ivc_por_tipo INTO vn_soma_seguro_int_linhas;
      CLOSE cur_vrt_ivc_por_tipo;

      vn_soma_frete_int_linhas  := 0;
      FOR ivc IN 1..vn_global_qtde_lin LOOP
        vn_soma_valor_fob_linhas := vn_soma_valor_fob_linhas + nvl (tb_ivc_lin(ivc).vrt_fob_m, 0);
      END LOOP;

      /* Obt�m o fator entre o valor fob e o valor de seguro internacional da invoice. */
      IF (vn_soma_valor_fob_linhas > 0) THEN
        vn_fator_seguro_ivc := vn_soma_seguro_int_linhas / vn_soma_valor_fob_linhas;

        /* Com o valor FOB das linhas encontrado, faremos novamente um loop nas linhas para ratear o seguro nas
           linhas tipo mercadoria. */
        vn_soma_rateio_seguro := 0;
        FOR ivc IN 1..vn_global_qtde_lin LOOP
          IF (ivc = vn_global_qtde_lin) THEN
            tb_ivc_lin(ivc).vrt_sgivc_m := vn_soma_seguro_int_linhas - vn_soma_rateio_seguro;
          ELSE
            tb_ivc_lin(ivc).vrt_sgivc_m := tb_ivc_lin(ivc).vrt_fob_m * vn_fator_seguro_ivc;
          END IF;

          /* Se o seguro da invoice for embutido, subtrai o valor rateado do valor fob de cada linha. */
          IF (tb_ivc_lin(ivc).flag_sg_embutido = 'S') THEN
            tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_m - nvl (tb_ivc_lin(ivc).vrt_sgivc_m, 0);
          END IF;
          vn_soma_rateio_seguro := vn_soma_rateio_seguro + tb_ivc_lin(ivc).vrt_sgivc_m;
        END LOOP;

      ELSE
        cmx_prc_gera_log_erros (
           vn_global_evento_id
         , 'Valor FOB da invoice zerado, seguro internacional n�o rateado.'
         , 'E'
        );
      END IF;

      vn_soma_valor_fob_linhas := 0;
      vn_soma_dsp_int_linhas   := 0;
      vn_fator_dsp_ivc         := 0;

      /* Buscaremos a soma das linhas de despesa DDU para ratear nas linhas tipo mercadoria. */
      OPEN  cur_vrt_ivc_por_tipo ('N');
      FETCH cur_vrt_ivc_por_tipo INTO vn_soma_dsp_int_linhas;
      CLOSE cur_vrt_ivc_por_tipo;

      FOR ivc IN 1..vn_global_qtde_lin LOOP
        vn_soma_valor_fob_linhas := vn_soma_valor_fob_linhas + nvl (tb_ivc_lin(ivc).vrt_fob_m, 0);
      END LOOP;

      /* Obt�m o fator entre o valor fob e o valor de despesa DDU da invoice. */
      IF (vn_soma_valor_fob_linhas > 0) THEN
        vn_fator_dsp_ivc := vn_soma_dsp_int_linhas / vn_soma_valor_fob_linhas;

        /* Com o valor FOB das linhas encontrado, faremos novamente um loop nas linhas para ratear a despesa nas
           linhas tipo mercadoria. */
        vn_soma_rateio_dsp := 0;
        FOR ivc IN 1..vn_global_qtde_lin LOOP
          IF (ivc = vn_global_qtde_lin) THEN
            tb_ivc_lin(ivc).vrt_dspivc_m := vn_soma_dsp_int_linhas - vn_soma_rateio_dsp;
          ELSE
            tb_ivc_lin(ivc).vrt_dspivc_m := tb_ivc_lin(ivc).vrt_fob_m * vn_fator_dsp_ivc;
          END IF;

          /* Se a despesa DDU da invoice for embutida, subtrai o valor rateado do valor fob de cada linha. */
          IF (tb_ivc_lin(ivc).flag_dsp_ddu_embutida = 'S') THEN
            tb_ivc_lin(ivc).vrt_fob_m  := tb_ivc_lin(ivc).vrt_fob_m - nvl (tb_ivc_lin(ivc).vrt_dspivc_m, 0);
          END IF;
          vn_soma_rateio_dsp := vn_soma_rateio_dsp + tb_ivc_lin(ivc).vrt_dspivc_m;
        END LOOP;

      ELSE
        cmx_prc_gera_log_erros (
           vn_global_evento_id
         , 'Valor FOB da invoice zerado, despesa DDU n�o rateada.'
         , 'E'
        );
      END IF;

    EXCEPTION
      WHEN others THEN
        cmx_prc_gera_log_erros (
           vn_global_evento_id
         , 'Erro no rateio dos valores da invoice: ' || sqlerrm
         , 'E'
        );
    END prc_rateia_valores_invoice;


    PROCEDURE prc_grava_linhas_invoice
    IS
    BEGIN
      FOR ivc IN 1..vn_global_qtde_lin LOOP
        UPDATE imp_invoices_lin
           SET --pesoliq_tot    = tb_ivc_lin(ivc).pesoliq_tot
               vrt_frivc_m    = tb_ivc_lin(ivc).vrt_frivc_m
             , vrt_sgivc_m    = tb_ivc_lin(ivc).vrt_sgivc_m
--             , vrt_dsp_ddu_m  = tb_ivc_lin(ivc).vrt_dspivc_m
             , vrt_fob_m      = tb_ivc_lin(ivc).vrt_fob_m
         WHERE invoice_lin_id = tb_ivc_lin(ivc).invoice_lin_id;
      END LOOP;

    EXCEPTION
      WHEN others THEN
        cmx_prc_gera_log_erros (vn_global_evento_id, 'Erro na grava��o das linhas da invoice: ' || sqlerrm, 'E');
    END prc_grava_linhas_invoice;

  /* FUNCTION fnc_calcula_fob */
  BEGIN
    vn_global_evento_id := cmx_fnc_gera_evento (
       'Fechamento de C�mbio - Embarque: ' || pc_embarque_ano
     , sysdate
     , pn_created_by
    );

    vn_global_qtde_lin          := 0;
    vn_global_total_pesoliq_ivc := 0;

    prc_carrega_linhas_invoice;
    prc_acerta_pesos;
    prc_rateia_valores_invoice;
    prc_grava_linhas_invoice;

    RETURN (vn_global_evento_id);
  END fnc_calcula_fob;

END cam_pkg_interface_importacao;
/

