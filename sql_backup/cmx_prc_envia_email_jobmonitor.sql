CREATE OR REPLACE PROCEDURE cmx_prc_envia_email_jobmonitor AS

  CURSOR cur_job_monitor IS
    SELECT job_monitor_id
         , user_job_id
         , descricao
         , agrupamento
         , what processo
         , frequencia
         , tempo_maximo_execucao
         , data_inativacao
         , inativar_no_futuro
      FROM cmx_vw_job_monitor
     WHERE job_monitor_id IS NOT NULL;

  CURSOR cur_user_jobs(pn_job_id NUMBER) IS
    SELECT job
         , this_date
         , broken
         , failures
         , what
      FROM user_jobs
     WHERE job = pn_job_id;

  CURSOR cur_dados_email(pc_tipo_erro VARCHAR2) IS
    SELECT descricao
      FROM cmx_tmp_log_job_inconsistencia
     WHERE pc_tipo_erro IS NULL OR tipo_erro = pc_tipo_erro
     ORDER BY tipo_erro;

  CURSOR cur_menu IS
    SELECT cmx_fnc_caminho_menu(id)
      FROM cmx_programas
     WHERE programa = 'cmx_job_monitor';

  CURSOR cur_remetente IS
    SELECT email_conta_id
      FROM cmx_email_contas
     WHERE dt_inativacao IS NULL;

  CURSOR cur_destinatario IS
    SELECT dest.email
         , dest.nome_usuario
         , dest.email_destinatario_id
      FROM sen_usuarios            usuario
         , cmx_email_destinatarios dest
     WHERE usuario.dba_responsavel = 'S'
       AND usuario.nm_usuario = dest.nome_usuario;

  vr_user_jobs             cur_user_jobs%ROWTYPE;
  vn_tempo_execucao_atual  NUMBER;
  vn_tempo_maximo_previsto NUMBER;
  vc_query                 VARCHAR2(400);
  vd_tempo_maximo          DATE;
  vb_achou                 BOOLEAN;
  vr_ret                   cur_dados_email%ROWTYPE;
  vc_caminho_menu          VARCHAR2(400);
  vn_contador              NUMBER;
  vc_corpo_mensagem        CLOB;
  vn_remetente_id          NUMBER;
  vn_email_caixa_saida_id  NUMBER;
  vb_gera_log              BOOLEAN;
  vc_ret                   VARCHAR2(4000);

BEGIN

  FOR monitor IN cur_job_monitor LOOP

    OPEN cur_user_jobs(monitor.user_job_id);
    FETCH cur_user_jobs INTO vr_user_jobs;
    CLOSE cur_user_jobs;

    -- Verifica se o job está inativo no setup (cmx_job_monitor) e ativo na user_jobs
    -- Erro: INATIVO_SETUP_ATIVO_USER_JOBS
    IF (monitor.data_inativacao IS NOT NULL AND Trunc(monitor.data_inativacao) <= Trunc(SYSDATE) AND vr_user_jobs.broken = 'N' ) THEN

      vb_gera_log := TRUE;

      INSERT INTO cmx_tmp_log_job_inconsistencia(
         job_id
       , tipo_erro
       , descricao
       ) VALUES
       ( monitor.user_job_id
       , 'INATIVO_SETUP_ATIVO_USER_JOBS'
       , 'Job: '||monitor.user_job_id ||' - Agrupamento: '||monitor.agrupamento || ' - Descrição: '||monitor.descricao ||' - Processo: '||monitor.processo);

    END IF;

    -- Verifica se o job está ativo no setup (cmx_job_monitor) e inativo na user_jobs
    -- Erro: ATIVO_SETUP_INATIVO_USER_JOBS
    IF (monitor.data_inativacao IS NULL AND vr_user_jobs.broken = 'Y' ) THEN

      vb_gera_log := TRUE;

      INSERT INTO cmx_tmp_log_job_inconsistencia(
         job_id
       , tipo_erro
       , descricao
       ) VALUES
       ( monitor.user_job_id
       , 'ATIVO_SETUP_INATIVO_USER_JOBS'
       , 'Job: '||monitor.user_job_id ||' - Agrupamento: '||monitor.agrupamento || ' - Descrição: '||monitor.descricao ||' - Processo: '||monitor.processo);

    END IF;

    -- Verifica se o tempo de execução do job é maior que o previsto no setup (cmx_job_monitor)
    -- Erro: TEMPO_MAIOR_QUE_PREVISTO
    IF (monitor.data_inativacao IS NULL AND monitor.tempo_maximo_execucao IS NOT NULL) THEN

      vb_gera_log := TRUE;

      vn_tempo_execucao_atual  := SYSDATE - vr_user_jobs.this_date;

      vc_query:= 'SELECT '||monitor.tempo_maximo_execucao||' FROM dual';
      EXECUTE IMMEDIATE vc_query INTO vd_tempo_maximo;
      vn_tempo_maximo_previsto := vd_tempo_maximo - SYSDATE;

      IF (vn_tempo_execucao_atual > vn_tempo_maximo_previsto) THEN

        INSERT INTO cmx_tmp_log_job_inconsistencia(
          job_id
        , tipo_erro
        , descricao
        ) VALUES
        ( monitor.user_job_id
        , 'TEMPO_MAIOR_QUE_PREVISTO'
        , 'Job: '||monitor.user_job_id ||' - Agrupamento: '||monitor.agrupamento || ' - Descrição: '||monitor.descricao ||' - Processo: '||monitor.processo);
      END IF;

    END IF;

    -- Verifica se o job estava marcado para ser inativado em data futura
    -- 'INATIVACAO_PROGRAMADA'
    IF (    Nvl(monitor.inativar_no_futuro,'N') = 'S'
        AND monitor.data_inativacao IS NOT NULL
        AND (Trunc(sysdate) = Trunc(monitor.data_inativacao))) THEN

      UPDATE cmx_job_monitor
         SET inativar_no_futuro = 'N'
       WHERE user_job_id = vr_user_jobs.job;

      IF (Nvl(vr_user_jobs.broken,'N') = 'N') THEN

        vb_gera_log := TRUE;

        dbms_job.broken (vr_user_jobs.job, true, null);

        INSERT INTO cmx_tmp_log_job_inconsistencia(
            job_id
          , tipo_erro
          , descricao
          ) VALUES
          ( monitor.user_job_id
          , 'INATIVACAO_PROGRAMADA'
          , 'Job: '||monitor.user_job_id ||' - Agrupamento: '||monitor.agrupamento || ' - Descrição: '||monitor.descricao ||' - Processo: '||monitor.processo);
      END IF;

    END IF;

  END LOOP;

  -------------------------------
  -- Cria texto para email
  -------------------------------
  IF (vb_gera_log) THEN

     OPEN cur_dados_email(null);
    FETCH cur_dados_email INTO vr_ret;
    vb_achou := cur_dados_email%FOUND;
    CLOSE cur_dados_email;

    OPEN cur_menu;
    FETCH cur_menu INTO vc_caminho_menu;
    CLOSE cur_menu;

    IF vb_achou THEN

      vc_corpo_mensagem := 'Verificar os jobs no menu '||vc_caminho_menu;

      vb_achou := FALSE;
      OPEN cur_dados_email('ATIVO_SETUP_INATIVO_USER_JOBS');
      FETCH cur_dados_email INTO vc_ret;
      vb_achou := cur_dados_email%FOUND;
      CLOSE cur_dados_email;

      IF vb_achou THEN
      vn_contador       := 1;
      vc_corpo_mensagem := vc_corpo_mensagem || Chr(10) || Chr(10);
      vc_corpo_mensagem := vc_corpo_mensagem ||'Job(s) ativo(s) no setup de job (cmx_job_monitor) que estão inativos (user_jobs)'|| Chr(10);
      FOR dados IN cur_dados_email('ATIVO_SETUP_INATIVO_USER_JOBS') LOOP
        vc_corpo_mensagem := vc_corpo_mensagem || vn_contador||'. '||dados.descricao|| Chr(10);
        vn_contador := vn_contador + 1;
      END LOOP;
      END IF;

      vb_achou := FALSE;
      OPEN cur_dados_email('INATIVO_SETUP_ATIVO_USER_JOBS');
      FETCH cur_dados_email INTO vc_ret;
      vb_achou := cur_dados_email%FOUND;
      CLOSE cur_dados_email;

      IF vb_achou THEN
      vn_contador       := 1;
      vc_corpo_mensagem := vc_corpo_mensagem || Chr(10);
      vc_corpo_mensagem := vc_corpo_mensagem ||'Job(s) inativo(s) no setup de job (cmx_job_monitor) que estão ativos (user_jobs)'|| Chr(10);
      FOR dados IN cur_dados_email('INATIVO_SETUP_ATIVO_USER_JOBS') LOOP
        vc_corpo_mensagem := vc_corpo_mensagem ||vn_contador||'. '||dados.descricao|| Chr(10);
        vn_contador := vn_contador + 1;
      END LOOP;
      END IF;

      vb_achou := FALSE;
      OPEN cur_dados_email('INATIVACAO_PROGRAMADA');
      FETCH cur_dados_email INTO vc_ret;
      vb_achou := cur_dados_email%FOUND;
      CLOSE cur_dados_email;

      IF vb_achou THEN
      vn_contador       := 1;
      vc_corpo_mensagem := vc_corpo_mensagem || Chr(10);
      vc_corpo_mensagem := vc_corpo_mensagem ||'Job(s) que foram inativados a partir do cadastro agendado no setup de job (cmx_job_monitor)'|| Chr(10);
      FOR dados IN cur_dados_email('INATIVACAO_PROGRAMADA') LOOP
        vc_corpo_mensagem := vc_corpo_mensagem ||vn_contador||'. '||dados.descricao|| Chr(10);
        vn_contador := vn_contador + 1;
      END LOOP;
      END IF;

      vb_achou := FALSE;
      OPEN cur_dados_email('TEMPO_MAIOR_QUE_PREVISTO');
      FETCH cur_dados_email INTO vc_ret;
      vb_achou := cur_dados_email%FOUND;
      CLOSE cur_dados_email;

      IF vb_achou THEN
      vn_contador       := 1;
      vc_corpo_mensagem := vc_corpo_mensagem || Chr(10);
      vc_corpo_mensagem := vc_corpo_mensagem ||'Job(s) que está(ão) sendo executado(s) com tempo maior que o previsto cadastrado no setup de job (cmx_job_monitor)'|| Chr(10);
      FOR dados IN cur_dados_email('TEMPO_MAIOR_QUE_PREVISTO') LOOP
        vc_corpo_mensagem := vc_corpo_mensagem ||vn_contador||'. '||dados.descricao|| Chr(10);
        vn_contador := vn_contador + 1;
      END LOOP;
      END IF;

      vc_corpo_mensagem := vc_corpo_mensagem || Chr(10) || Chr(10) || 'Esta é um mensagem automática, favor não respondê-la.';

    END IF;

    ---------------------------------
    -- Envia email
    ---------------------------------
     OPEN cur_remetente;
    FETCH cur_remetente INTO vn_remetente_id;
    CLOSE cur_remetente;

    vn_email_caixa_saida_id := cmx_fnc_proxima_sequencia ('cmx_email_caixa_saida_sq1');
    INSERT INTO cmx_email_caixa_saida (
      email_caixa_saida_id
    , remetente_id
    , assunto_msg
    , corpo_msg
    , tipo_mensagem
    , hora_envio_agendamento
    , creation_date
    , created_by
    , last_update_date
    , last_updated_by
    , hora_criacao_alteracao
    )
    VALUES (
      vn_email_caixa_saida_id
    , vn_remetente_id
    , 'ECOMEX 3.0.' || cmx_fnc_profile ('RELEASE_NUMBER') || ' - ' || cmx_fnc_profile ('NOME_AMBIENTE') || ' - Monitoramento de JOBs'
    , vc_corpo_mensagem
    , 'T'
    , SYSDATE --vd_data_hora_envio
    , sysdate
    , 0
    , sysdate
    , 0
    , sysdate
    );

    FOR d IN cur_destinatario LOOP

      INSERT INTO cmx_email_caixa_saida_dest (
        email_caixa_saida_dest_id
      , email_caixa_saida_id
      , nome_destinatario
      , email_destinatario
      , tipo
      , creation_date
      , created_by
      , last_update_date
      , last_updated_by
      , email_destinatario_id
      ) VALUES (
        cmx_fnc_proxima_sequencia ('cmx_email_caixa_saida_dest_sq1')
      , vn_email_caixa_saida_id
      , d.nome_usuario
      , d.email
      , 'P'--d.tipo
      , sysdate
      , 0
      , sysdate
      , 0
      , d.email_destinatario_id
      );

    END LOOP;

    DELETE FROM cmx_tmp_log_job_inconsistencia;

  END IF; --vb_gera_log := TRUE;

END cmx_prc_envia_email_jobmonitor;

/

