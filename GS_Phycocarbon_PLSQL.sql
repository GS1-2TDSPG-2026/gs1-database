-- PROJETO: Phycocarbon — Plataforma de Monitoramento de Microalgas
-- DISCIPLINA: Mastering Relational and Non-Relational Database
-- FIAP Global Solution 2026 | 2TDSPG 

SET SERVEROUTPUT ON;

-- SECAO 1: BLOCOS ANONIMOS
-- BLOCO 1: Consulta de status de um tanque pelo ID

DECLARE
    v_id_tanque     TB_TANQUE.id_tanque%TYPE     := 1;
    v_codigo        TB_TANQUE.codigo_tanque%TYPE;
    v_tipo_alga     TB_TANQUE.tipo_alga%TYPE;
    v_status        TB_TANQUE.status%TYPE;
    v_capacidade    TB_TANQUE.capacidade_litros%TYPE;
    v_classificacao VARCHAR2(30);
BEGIN
    SELECT codigo_tanque, tipo_alga, status, capacidade_litros
    INTO   v_codigo, v_tipo_alga, v_status, v_capacidade
    FROM   TB_TANQUE
    WHERE  id_tanque = v_id_tanque;

    IF v_status = 'ATIVO' THEN
        v_classificacao := 'OPERACIONAL';
    ELSIF v_status = 'MANUTENCAO' THEN
        v_classificacao := 'PARADO PARA MANUTENCAO';
    ELSIF v_status = 'COLHEITA' THEN
        v_classificacao := 'EM PROCESSO DE COLHEITA';
    ELSE
        v_classificacao := 'INATIVO';
    END IF;

    IF v_capacidade >= 10000 THEN
        DBMS_OUTPUT.PUT_LINE('Porte: GRANDE (>= 10.000L)');
    ELSIF v_capacidade >= 5000 THEN
        DBMS_OUTPUT.PUT_LINE('Porte: MEDIO (>= 5.000L)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Porte: PEQUENO (< 5.000L)');
    END IF;

    DBMS_OUTPUT.PUT_LINE('TANQUE ' || v_codigo || '');
    DBMS_OUTPUT.PUT_LINE('Especie  : ' || v_tipo_alga);
    DBMS_OUTPUT.PUT_LINE('Status   : ' || v_classificacao);
    DBMS_OUTPUT.PUT_LINE('Capacidade: ' || v_capacidade || ' litros');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: Tanque ID ' || v_id_tanque || ' nao encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO inesperado: ' || SQLERRM);
END;
/

-- BLOCO 2: Verificacao de alertas criticos abertos por tanque

DECLARE
    v_id_tanque     TB_TANQUE.id_tanque%TYPE := 2;
    v_codigo        TB_TANQUE.codigo_tanque%TYPE;
    v_qtd_alertas   NUMBER;
    v_prioridade    VARCHAR2(20);
BEGIN
    SELECT codigo_tanque
    INTO   v_codigo
    FROM   TB_TANQUE
    WHERE  id_tanque = v_id_tanque;

    SELECT COUNT(*)
    INTO   v_qtd_alertas
    FROM   TB_ALERTA_CRITICO
    WHERE  id_tanque = v_id_tanque
    AND    status    IN ('ABERTO', 'EM_ANALISE');

    IF v_qtd_alertas = 0 THEN
        v_prioridade := 'NORMAL';
        DBMS_OUTPUT.PUT_LINE('Tanque ' || v_codigo || ': sem alertas ativos.');
    ELSIF v_qtd_alertas = 1 THEN
        v_prioridade := 'ATENCAO';
        DBMS_OUTPUT.PUT_LINE('Tanque ' || v_codigo || ': 1 alerta ativo. Monitorar.');
    ELSIF v_qtd_alertas <= 3 THEN
        v_prioridade := 'CRITICO';
        DBMS_OUTPUT.PUT_LINE('Tanque ' || v_codigo || ': ' || v_qtd_alertas || ' alertas ativos. Intervencao necessaria.');
    ELSE
        v_prioridade := 'EMERGENCIA';
        DBMS_OUTPUT.PUT_LINE('Tanque ' || v_codigo || ': ' || v_qtd_alertas || ' alertas. EMERGENCIA — acionar equipe.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Nivel de prioridade: ' || v_prioridade);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: Tanque ID ' || v_id_tanque || ' nao encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- BLOCO 3: Calculo do valor total de vendas de biomassa por fazenda

DECLARE
    v_total_vendas  NUMBER(15,2);
    v_nome_fazenda  TB_FAZENDA.nome%TYPE;
    v_contador      NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('RELATORIO DE VENDAS POR FAZENDA');

    FOR r IN (
        SELECT f.id_fazenda, f.nome
        FROM   TB_FAZENDA f
        WHERE  f.status = 'ATIVA'
        ORDER  BY f.nome
    ) LOOP
        SELECT NVL(SUM(t.valor_total), 0)
        INTO   v_total_vendas
        FROM   TB_TRANSACAO_MARKETPLACE t
        JOIN   TB_LOTE_BIOMASSA l ON l.id_lote = t.id_lote
        WHERE  l.id_fazenda     = r.id_fazenda
        AND    t.tipo_transacao = 'COMPRA_BIOMASSA'
        AND    t.status         = 'CONFIRMADA';

        v_contador := v_contador + 1;

        IF v_total_vendas > 50000 THEN
            DBMS_OUTPUT.PUT_LINE(r.nome || ' | R$ ' || TO_CHAR(v_total_vendas, 'FM999G990D00') || ' [ALTO DESEMPENHO]');
        ELSIF v_total_vendas > 10000 THEN
            DBMS_OUTPUT.PUT_LINE(r.nome || ' | R$ ' || TO_CHAR(v_total_vendas, 'FM999G990D00') || ' [DESEMPENHO REGULAR]');
        ELSE
            DBMS_OUTPUT.PUT_LINE(r.nome || ' | R$ ' || TO_CHAR(v_total_vendas, 'FM999G990D00') || ' [SEM VENDAS / BAIXO]');
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total de fazendas processadas: ' || v_contador);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- BLOCO 4: Monitoramento de metricas do ultimo dia com WHILE LOOP

DECLARE
    v_contador      NUMBER := 1;
    v_max           NUMBER;
    v_ph            TB_METRICAS_TANQUE.ph%TYPE;
    v_temperatura   TB_METRICAS_TANQUE.temperatura%TYPE;
    v_id_tanque     TB_METRICAS_TANQUE.id_tanque%TYPE;
    v_dt            TB_METRICAS_TANQUE.dt_leitura%TYPE;
    v_status_ph     VARCHAR2(20);
BEGIN
    SELECT COUNT(*)
    INTO   v_max
    FROM   TB_METRICAS_TANQUE
    WHERE  dt_leitura >= SYSTIMESTAMP - INTERVAL '1' DAY;

    DBMS_OUTPUT.PUT_LINE('METRICAS ULTIMAS 24H: ' || v_max || ' leituras');

    WHILE v_contador <= v_max LOOP
        SELECT ph, temperatura, id_tanque, dt_leitura
        INTO   v_ph, v_temperatura, v_id_tanque, v_dt
        FROM   (
            SELECT ph, temperatura, id_tanque, dt_leitura,
                   ROW_NUMBER() OVER (ORDER BY dt_leitura) AS rn
            FROM   TB_METRICAS_TANQUE
            WHERE  dt_leitura >= SYSTIMESTAMP - INTERVAL '1' DAY
        )
        WHERE  rn = v_contador;

        IF v_ph < 6 OR v_ph > 11 THEN
            v_status_ph := 'CRITICO';
        ELSIF v_ph < 7 OR v_ph > 10 THEN
            v_status_ph := 'ATENCAO';
        ELSE
            v_status_ph := 'NORMAL';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Tanque ' || v_id_tanque ||
            ' | pH: ' || v_ph ||
            ' [' || v_status_ph || ']' ||
            ' | Temp: ' || v_temperatura || 'C'
        );

        v_contador := v_contador + 1;
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma leitura encontrada nas ultimas 24 horas.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- BLOCO 5: Atualizacao em lote do status de lotes de biomassa vencidos

DECLARE
    v_id_lote       TB_LOTE_BIOMASSA.id_lote%TYPE;
    v_peso          TB_LOTE_BIOMASSA.peso_kg%TYPE;
    v_dias          NUMBER;
    v_atualizados   NUMBER := 0;
    v_ignorados     NUMBER := 0;

    CURSOR c_lotes_antigos IS
        SELECT id_lote, peso_kg,
               TRUNC(SYSDATE) - TRUNC(dt_colheita) AS dias_estoque
        FROM   TB_LOTE_BIOMASSA
        WHERE  status     = 'DISPONIVEL'
        AND    dt_colheita < SYSDATE - 30
        ORDER  BY dt_colheita;
BEGIN
    DBMS_OUTPUT.PUT_LINE('VERIFICACAO DE LOTES VENCIDOS (> 30 dias)');

    OPEN c_lotes_antigos;
    LOOP
        FETCH c_lotes_antigos INTO v_id_lote, v_peso, v_dias;
        EXIT WHEN c_lotes_antigos%NOTFOUND;

        IF v_dias > 30 THEN
            UPDATE TB_LOTE_BIOMASSA
            SET    status = 'CANCELADO'
            WHERE  id_lote = v_id_lote;

            v_atualizados := v_atualizados + 1;
            DBMS_OUTPUT.PUT_LINE(
                'Lote ID ' || v_id_lote ||
                ' | ' || v_peso || ' kg' ||
                ' | ' || v_dias || ' dias — CANCELADO'
            );
        ELSE
            v_ignorados := v_ignorados + 1;
        END IF;
    END LOOP;
    CLOSE c_lotes_antigos;

    DBMS_OUTPUT.PUT_LINE('Lotes cancelados : ' || v_atualizados);
    DBMS_OUTPUT.PUT_LINE('Lotes ignorados  : ' || v_ignorados);
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- BLOCO 6: Relatorio de previsoes de IA com confianca e classificacao

DECLARE
    v_total     NUMBER := 0;
    v_alta      NUMBER := 0;
    v_media     NUMBER := 0;
    v_baixa     NUMBER := 0;
    v_nivel     VARCHAR2(10);
BEGIN
    DBMS_OUTPUT.PUT_LINE('PREVISOES DE BIOMASSA — CLASSIFICACAO POR CONFIANCA');

    FOR r IN (
        SELECT p.id_previsao,
               p.biomassa_g_l,
               p.confianca_pct,
               p.dt_pico_previsto,
               p.modelo_utilizado,
               t.codigo_tanque,
               t.tipo_alga
        FROM   TB_PREVISOES_IA p
        JOIN   TB_TANQUE t ON t.id_tanque = p.id_tanque
        ORDER  BY p.confianca_pct DESC
    ) LOOP
        v_total := v_total + 1;

        IF r.confianca_pct >= 90 THEN
            v_nivel := 'ALTA';
            v_alta  := v_alta + 1;
        ELSIF r.confianca_pct >= 75 THEN
            v_nivel := 'MEDIA';
            v_media := v_media + 1;
        ELSE
            v_nivel := 'BAIXA';
            v_baixa := v_baixa + 1;
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            'Tanque: ' || r.codigo_tanque ||
            ' | ' || r.tipo_alga ||
            ' | Biomassa: ' || r.biomassa_g_l || ' g/L' ||
            ' | Confianca: ' || r.confianca_pct || '%' ||
            ' [' || v_nivel || ']' ||
            ' | Pico: ' || TO_CHAR(r.dt_pico_previsto, 'DD/MM/YYYY')
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total de previsoes : ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Alta confianca     : ' || v_alta);
    DBMS_OUTPUT.PUT_LINE('Media confianca    : ' || v_media);
    DBMS_OUTPUT.PUT_LINE('Baixa confianca    : ' || v_baixa);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- SECAO 2: CURSORES EXPLICITOS 
-- CURSOR 1: Listar todos os tanques ativos com seus dispositivos IoT

DECLARE
    CURSOR c_tanques_ativos IS
        SELECT t.codigo_tanque,
               t.tipo_alga,
               t.capacidade_litros,
               d.codigo_serie,
               d.modelo,
               d.ativo
        FROM   TB_TANQUE t
        JOIN   TB_DISPOSITIVO_IOT d ON d.id_tanque = t.id_tanque
        WHERE  t.status = 'ATIVO'
        ORDER  BY t.codigo_tanque;

    v_tanque    c_tanques_ativos%ROWTYPE;
    v_contador  NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('TANQUES ATIVOS E DISPOSITIVOS IoT');

    OPEN c_tanques_ativos;
    LOOP
        FETCH c_tanques_ativos INTO v_tanque;
        EXIT WHEN c_tanques_ativos%NOTFOUND;

        v_contador := v_contador + 1;
        DBMS_OUTPUT.PUT_LINE(
            v_tanque.codigo_tanque ||
            ' | ' || v_tanque.tipo_alga ||
            ' | ' || v_tanque.capacidade_litros || 'L' ||
            ' | Dispositivo: ' || v_tanque.codigo_serie ||
            ' (' || v_tanque.modelo || ')' ||
            ' | Ativo: ' || v_tanque.ativo
        );
    END LOOP;
    CLOSE c_tanques_ativos;

    DBMS_OUTPUT.PUT_LINE('Total: ' || v_contador || ' tanques ativos com dispositivo.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- CURSOR 2: Listar alertas abertos com dados do tanque e fazenda

DECLARE
    CURSOR c_alertas_abertos IS
        SELECT a.id_alerta,
               a.tipo_alerta,
               a.severidade,
               a.mensagem,
               a.dt_alerta,
               t.codigo_tanque,
               f.nome AS nome_fazenda
        FROM   TB_ALERTA_CRITICO a
        JOIN   TB_TANQUE  t ON t.id_tanque  = a.id_tanque
        JOIN   TB_FAZENDA f ON f.id_fazenda = t.id_fazenda
        WHERE  a.status IN ('ABERTO', 'EM_ANALISE')
        ORDER  BY a.severidade DESC, a.dt_alerta DESC;

    v_alerta    c_alertas_abertos%ROWTYPE;
    v_total     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('ALERTAS ABERTOS / EM ANALISE');

    OPEN c_alertas_abertos;
    LOOP
        FETCH c_alertas_abertos INTO v_alerta;
        EXIT WHEN c_alertas_abertos%NOTFOUND;

        v_total := v_total + 1;
        DBMS_OUTPUT.PUT_LINE(
            '[' || v_alerta.severidade || '] ' ||
            v_alerta.tipo_alerta ||
            ' | Fazenda: ' || v_alerta.nome_fazenda ||
            ' | Tanque: '  || v_alerta.codigo_tanque ||
            ' | ' || TO_CHAR(v_alerta.dt_alerta, 'DD/MM/YYYY HH24:MI')
        );
        DBMS_OUTPUT.PUT_LINE('   Mensagem: ' || v_alerta.mensagem);
    END LOOP;
    CLOSE c_alertas_abertos;

    DBMS_OUTPUT.PUT_LINE('Total de alertas pendentes: ' || v_total);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- CURSOR 3: Listar lotes disponiveis no marketplace com valor estimado

DECLARE
    CURSOR c_marketplace IS
        SELECT l.id_lote,
               l.taxonomia_alga,
               l.peso_kg,
               l.preco_unitario,
               l.peso_kg * l.preco_unitario AS valor_total,
               l.dt_colheita,
               f.nome AS fazenda
        FROM   TB_LOTE_BIOMASSA l
        JOIN   TB_FAZENDA f ON f.id_fazenda = l.id_fazenda
        WHERE  l.status = 'DISPONIVEL'
        ORDER  BY valor_total DESC;

    v_lote          c_marketplace%ROWTYPE;
    v_total_market  NUMBER(15,2) := 0;
    v_qtd           NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('MARKETPLACE — LOTES DISPONIVEIS');
    DBMS_OUTPUT.PUT_LINE(RPAD('Especie', 30) || RPAD('Kg', 10) || RPAD('R$/kg', 10) || 'Valor Total');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 65, '-'));

    OPEN c_marketplace;
    LOOP
        FETCH c_marketplace INTO v_lote;
        EXIT WHEN c_marketplace%NOTFOUND;

        v_qtd          := v_qtd + 1;
        v_total_market := v_total_market + v_lote.valor_total;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_lote.taxonomia_alga, 30) ||
            RPAD(v_lote.peso_kg, 10) ||
            RPAD(v_lote.preco_unitario, 10) ||
            'R$ ' || TO_CHAR(v_lote.valor_total, 'FM999G990D00')
        );
    END LOOP;
    CLOSE c_marketplace;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 65, '-'));
    DBMS_OUTPUT.PUT_LINE('Lotes disponiveis : ' || v_qtd);
    DBMS_OUTPUT.PUT_LINE('Valor total oferta: R$ ' || TO_CHAR(v_total_market, 'FM999G990D00'));

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- CURSOR 4: Listar usuarios por perfil com contagem de fazendas responsaveis

DECLARE
    CURSOR c_usuarios IS
        SELECT u.id_usuario,
               u.nome,
               u.email,
               u.status,
               p.nome_perfil,
               COUNT(f.id_fazenda) AS qtd_fazendas
        FROM   TB_USUARIO u
        JOIN   TB_PERFIL  p ON p.id_perfil = u.id_perfil
        LEFT JOIN TB_FAZENDA f ON f.id_usuario_responsavel = u.id_usuario
        GROUP  BY u.id_usuario, u.nome, u.email, u.status, p.nome_perfil
        ORDER  BY p.nome_perfil, u.nome;

    v_usuario   c_usuarios%ROWTYPE;
    v_total     NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('USUARIOS CADASTRADOS POR PERFIL');

    OPEN c_usuarios;
    LOOP
        FETCH c_usuarios INTO v_usuario;
        EXIT WHEN c_usuarios%NOTFOUND;

        v_total := v_total + 1;
        DBMS_OUTPUT.PUT_LINE(
            '[' || v_usuario.nome_perfil || '] ' ||
            v_usuario.nome ||
            ' | Status: ' || v_usuario.status ||
            ' | Fazendas: ' || v_usuario.qtd_fazendas
        );
    END LOOP;
    CLOSE c_usuarios;

    DBMS_OUTPUT.PUT_LINE('Total de usuarios: ' || v_total);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END;
/

-- SECAO 3: RELATORIOS SQL COM JOIN

-- RELATORIO 1: Dashboard por fazenda — tanques, alertas e ultima leitura

SELECT
    f.nome                                          AS fazenda,
    f.uf,
    COUNT(DISTINCT t.id_tanque)                     AS total_tanques,
    COUNT(DISTINCT CASE WHEN t.status = 'ATIVO'
          THEN t.id_tanque END)                     AS tanques_ativos,
    COUNT(DISTINCT a.id_alerta)                     AS total_alertas,
    COUNT(DISTINCT CASE WHEN a.status IN ('ABERTO','EM_ANALISE')
          THEN a.id_alerta END)                     AS alertas_abertos,
    MAX(m.dt_leitura)                               AS ultima_leitura
FROM
    TB_FAZENDA          f
    LEFT JOIN TB_TANQUE          t ON t.id_fazenda  = f.id_fazenda
    LEFT JOIN TB_ALERTA_CRITICO  a ON a.id_tanque   = t.id_tanque
    LEFT JOIN TB_METRICAS_TANQUE m ON m.id_tanque   = t.id_tanque
GROUP BY
    f.nome, f.uf
ORDER BY
    total_alertas DESC, f.nome;

-- RELATORIO 2: Metricas criticas — leituras fora dos limites do tanque

SELECT
    f.nome                  AS fazenda,
    t.codigo_tanque,
    t.tipo_alga,
    m.dt_leitura,
    m.ph,
    t.ph_min,
    t.ph_max,
    m.temperatura,
    t.temperatura_min,
    t.temperatura_max,
    CASE
        WHEN m.ph < t.ph_min THEN 'pH BAIXO'
        WHEN m.ph > t.ph_max THEN 'pH ALTO'
        WHEN m.temperatura > t.temperatura_max THEN 'TEMPERATURA ALTA'
        WHEN m.temperatura < t.temperatura_min THEN 'TEMPERATURA BAIXA'
        ELSE 'NORMAL'
    END                     AS situacao
FROM
    TB_METRICAS_TANQUE  m
    INNER JOIN TB_TANQUE         t ON t.id_tanque  = m.id_tanque
    INNER JOIN TB_FAZENDA        f ON f.id_fazenda = t.id_fazenda
WHERE
    m.ph < t.ph_min
    OR m.ph > t.ph_max
    OR m.temperatura > t.temperatura_max
    OR m.temperatura < t.temperatura_min
ORDER BY
    m.dt_leitura DESC;

-- RELATORIO 3: Marketplace — transacoes com dados do comprador e produto

SELECT
    tm.id_transacao,
    TO_CHAR(tm.dt_transacao, 'DD/MM/YYYY HH24:MI')  AS data_transacao,
    u.nome                                           AS comprador,
    p.nome_perfil                                    AS perfil,
    tm.tipo_transacao,
    COALESCE(lb.taxonomia_alga, 'Credito de Carbono') AS produto,
    tm.quantidade,
    tm.valor_total,
    tm.status
FROM
    TB_TRANSACAO_MARKETPLACE  tm
    INNER JOIN TB_USUARIO          u  ON u.id_usuario = tm.id_usuario_comprador
    INNER JOIN TB_PERFIL           p  ON p.id_perfil  = u.id_perfil
    LEFT  JOIN TB_LOTE_BIOMASSA    lb ON lb.id_lote   = tm.id_lote
    LEFT  JOIN TB_CREDITO_CARBONO  cc ON cc.id_credito = tm.id_credito
ORDER BY
    tm.dt_transacao DESC;

-- RELATORIO 4: Previsoes de IA vs dados orbitais — correlacao por fazenda

SELECT
    f.nome                          AS fazenda,
    f.uf,
    t.codigo_tanque,
    t.tipo_alga,
    pi.biomassa_g_l                 AS biomassa_prevista_g_l,
    pi.confianca_pct,
    pi.dt_pico_previsto,
    pi.modelo_utilizado,
    dor.fonte                       AS fonte_orbital,
    dor.irradiancia_par             AS par_w_m2,
    dor.nebulosidade                AS nebulosidade_pct,
    dor.temperatura_ambiente        AS temp_ambiente_c
FROM
    TB_PREVISOES_IA     pi
    INNER JOIN TB_TANQUE         t   ON t.id_tanque       = pi.id_tanque
    INNER JOIN TB_FAZENDA        f   ON f.id_fazenda      = t.id_fazenda
    INNER JOIN TB_DADO_ORBITAL   dor ON dor.id_dado_orbital = pi.id_dado_orbital
ORDER BY
    pi.confianca_pct DESC, f.nome;

-- RELATORIO 5: Creditos de carbono — rastreabilidade completa

SELECT
    cc.id_credito,
    cc.co2_toneladas,
    cc.status                               AS status_credito,
    cc.dt_validacao,
    lb.taxonomia_alga,
    lb.peso_kg                              AS peso_lote_kg,
    lb.dt_colheita,
    f.nome                                  AS fazenda,
    f.uf,
    u.nome                                  AS responsavel,
    ROUND(cc.co2_toneladas * 30000, 2)      AS valor_estimado_reais,
    SUBSTR(cc.hash_auditoria, 1, 16) || '...' AS hash_resumido
FROM
    TB_CREDITO_CARBONO   cc
    INNER JOIN TB_LOTE_BIOMASSA  lb ON lb.id_lote    = cc.id_lote
    INNER JOIN TB_FAZENDA        f  ON f.id_fazenda  = cc.id_fazenda
    INNER JOIN TB_USUARIO        u  ON u.id_usuario  = f.id_usuario_responsavel
ORDER BY
    cc.co2_toneladas DESC;

-- SECAO 4: FUNCTION

CREATE OR REPLACE FUNCTION FN_CALCULA_SAUDE_TANQUE (
    p_id_tanque IN TB_TANQUE.id_tanque%TYPE
) RETURN NUMBER IS

    v_ph_medio      NUMBER;
    v_temp_media    NUMBER;
    v_ph_min        TB_TANQUE.ph_min%TYPE;
    v_ph_max        TB_TANQUE.ph_max%TYPE;
    v_temp_min      TB_TANQUE.temperatura_min%TYPE;
    v_temp_max      TB_TANQUE.temperatura_max%TYPE;
    v_alertas_abertos NUMBER;
    v_nota          NUMBER := 100;

BEGIN
    SELECT ph_min, ph_max, temperatura_min, temperatura_max
    INTO   v_ph_min, v_ph_max, v_temp_min, v_temp_max
    FROM   TB_TANQUE
    WHERE  id_tanque = p_id_tanque;

    SELECT AVG(ph), AVG(temperatura)
    INTO   v_ph_medio, v_temp_media
    FROM   TB_METRICAS_TANQUE
    WHERE  id_tanque  = p_id_tanque
    AND    dt_leitura >= SYSTIMESTAMP - INTERVAL '7' DAY;

    SELECT COUNT(*)
    INTO   v_alertas_abertos
    FROM   TB_ALERTA_CRITICO
    WHERE  id_tanque = p_id_tanque
    AND    status IN ('ABERTO', 'EM_ANALISE');

    IF v_ph_medio IS NOT NULL THEN
        IF v_ph_medio < v_ph_min OR v_ph_medio > v_ph_max THEN
            v_nota := v_nota - 30;
        END IF;
    END IF;

    IF v_temp_media IS NOT NULL THEN
        IF v_temp_media < v_temp_min OR v_temp_media > v_temp_max THEN
            v_nota := v_nota - 30;
        END IF;
    END IF;

    v_nota := v_nota - (v_alertas_abertos * 10);

    IF v_nota < 0 THEN
        v_nota := 0;
    END IF;

    RETURN v_nota;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        RETURN -1;
END FN_CALCULA_SAUDE_TANQUE;
/

-- SECAO 5: PROCEDURE

CREATE OR REPLACE PROCEDURE PRC_GERA_RELATORIO_FAZENDA (
    p_id_fazenda IN TB_FAZENDA.id_fazenda%TYPE
) IS

    v_nome_fazenda  TB_FAZENDA.nome%TYPE;
    v_uf            TB_FAZENDA.uf%TYPE;
    v_status        TB_FAZENDA.status%TYPE;
    v_responsavel   TB_USUARIO.nome%TYPE;
    v_total_tanques NUMBER;
    v_total_alertas NUMBER;
    v_total_lotes   NUMBER;
    v_receita_total NUMBER;
    v_nota_media    NUMBER := 0;
    v_soma_notas    NUMBER := 0;
    v_cnt_tanques   NUMBER := 0;

BEGIN
    SELECT f.nome, f.uf, f.status, u.nome
    INTO   v_nome_fazenda, v_uf, v_status, v_responsavel
    FROM   TB_FAZENDA f
    JOIN   TB_USUARIO u ON u.id_usuario = f.id_usuario_responsavel
    WHERE  f.id_fazenda = p_id_fazenda;

    SELECT COUNT(*) INTO v_total_tanques
    FROM   TB_TANQUE
    WHERE  id_fazenda = p_id_fazenda;

    SELECT COUNT(*) INTO v_total_alertas
    FROM   TB_ALERTA_CRITICO a
    JOIN   TB_TANQUE t ON t.id_tanque = a.id_tanque
    WHERE  t.id_fazenda = p_id_fazenda
    AND    a.status IN ('ABERTO', 'EM_ANALISE');

    SELECT COUNT(*), NVL(SUM(tm.valor_total), 0)
    INTO   v_total_lotes, v_receita_total
    FROM   TB_LOTE_BIOMASSA lb
    JOIN   TB_TRANSACAO_MARKETPLACE tm ON tm.id_lote = lb.id_lote
    WHERE  lb.id_fazenda  = p_id_fazenda
    AND    tm.status      = 'CONFIRMADA';

    FOR r IN (SELECT id_tanque FROM TB_TANQUE WHERE id_fazenda = p_id_fazenda AND status = 'ATIVO') LOOP
        v_soma_notas  := v_soma_notas + FN_CALCULA_SAUDE_TANQUE(r.id_tanque);
        v_cnt_tanques := v_cnt_tanques + 1;
    END LOOP;

    IF v_cnt_tanques > 0 THEN
        v_nota_media := ROUND(v_soma_notas / v_cnt_tanques, 1);
    END IF;

    DBMS_OUTPUT.PUT_LINE('RELATORIO DA FAZENDA: ' || v_nome_fazenda);
    DBMS_OUTPUT.PUT_LINE('Estado      : ' || v_uf);
    DBMS_OUTPUT.PUT_LINE('Status      : ' || v_status);
    DBMS_OUTPUT.PUT_LINE('Responsavel : ' || v_responsavel);
    DBMS_OUTPUT.PUT_LINE('Tanques     : ' || v_total_tanques);
    DBMS_OUTPUT.PUT_LINE('Alertas ativos: ' || v_total_alertas);
    DBMS_OUTPUT.PUT_LINE('Transacoes confirmadas: ' || v_total_lotes);
    DBMS_OUTPUT.PUT_LINE('Receita total: R$ ' || TO_CHAR(v_receita_total, 'FM999G990D00'));
    DBMS_OUTPUT.PUT_LINE('Saude media dos tanques: ' || v_nota_media || '/100');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: Fazenda ID ' || p_id_fazenda || ' nao encontrada.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
END PRC_GERA_RELATORIO_FAZENDA;
/

BEGIN
    PRC_GERA_RELATORIO_FAZENDA(1);
    PRC_GERA_RELATORIO_FAZENDA(3);
END;
/

-- SECAO 6: TRIGGER

CREATE OR REPLACE TRIGGER TRG_GERA_ALERTA_CRITICO
    AFTER INSERT ON TB_METRICAS_TANQUE
    FOR EACH ROW
DECLARE
    v_ph_min        TB_TANQUE.ph_min%TYPE;
    v_ph_max        TB_TANQUE.ph_max%TYPE;
    v_temp_min      TB_TANQUE.temperatura_min%TYPE;
    v_temp_max      TB_TANQUE.temperatura_max%TYPE;
    v_tipo_alerta   TB_ALERTA_CRITICO.tipo_alerta%TYPE;
    v_severidade    TB_ALERTA_CRITICO.severidade%TYPE;
    v_mensagem      TB_ALERTA_CRITICO.mensagem%TYPE;
BEGIN
    SELECT ph_min, ph_max, temperatura_min, temperatura_max
    INTO   v_ph_min, v_ph_max, v_temp_min, v_temp_max
    FROM   TB_TANQUE
    WHERE  id_tanque = :NEW.id_tanque;

    IF :NEW.ph IS NOT NULL THEN
        IF :NEW.ph < v_ph_min THEN
            v_tipo_alerta := 'PH_BAIXO';
            v_severidade  := 'ALTA';
            v_mensagem    := 'pH ' || :NEW.ph || ' abaixo do limite minimo (' || v_ph_min || ') para o tanque ID ' || :NEW.id_tanque;

            INSERT INTO TB_ALERTA_CRITICO (
                id_metrica, id_tanque,
                tipo_alerta, severidade, mensagem, status
            ) VALUES (
                :NEW.id_metrica, :NEW.id_tanque,
                v_tipo_alerta, v_severidade, v_mensagem, 'ABERTO'
            );

        ELSIF :NEW.ph > v_ph_max THEN
            v_tipo_alerta := 'PH_ALTO';
            v_severidade  := 'ALTA';
            v_mensagem    := 'pH ' || :NEW.ph || ' acima do limite maximo (' || v_ph_max || ') para o tanque ID ' || :NEW.id_tanque;

            INSERT INTO TB_ALERTA_CRITICO (
                id_metrica, id_tanque,
                tipo_alerta, severidade, mensagem, status
            ) VALUES (
                :NEW.id_metrica, :NEW.id_tanque,
                v_tipo_alerta, v_severidade, v_mensagem, 'ABERTO'
            );
        END IF;
    END IF;

    IF :NEW.temperatura IS NOT NULL THEN
        IF :NEW.temperatura > v_temp_max THEN
            v_tipo_alerta := 'TEMPERATURA_ALTA';
            v_severidade  := 'CRITICA';
            v_mensagem    := 'Temperatura ' || :NEW.temperatura || 'C acima do limite maximo (' || v_temp_max || 'C) para o tanque ID ' || :NEW.id_tanque;

            INSERT INTO TB_ALERTA_CRITICO (
                id_metrica, id_tanque,
                tipo_alerta, severidade, mensagem, status
            ) VALUES (
                :NEW.id_metrica, :NEW.id_tanque,
                v_tipo_alerta, v_severidade, v_mensagem, 'ABERTO'
            );

        ELSIF :NEW.temperatura < v_temp_min THEN
            v_tipo_alerta := 'TEMPERATURA_BAIXA';
            v_severidade  := 'MEDIA';
            v_mensagem    := 'Temperatura ' || :NEW.temperatura || 'C abaixo do limite minimo (' || v_temp_min || 'C) para o tanque ID ' || :NEW.id_tanque;

            INSERT INTO TB_ALERTA_CRITICO (
                id_metrica, id_tanque,
                tipo_alerta, severidade, mensagem, status
            ) VALUES (
                :NEW.id_metrica, :NEW.id_tanque,
                v_tipo_alerta, v_severidade, v_mensagem, 'ABERTO'
            );
        END IF;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        NULL;
END TRG_GERA_ALERTA_CRITICO;
/

INSERT INTO TB_METRICAS_TANQUE (
    id_dispositivo, id_tanque, dt_leitura,
    ph, temperatura, turbidez, luminosidade
) VALUES (
    1, 1,
    SYSTIMESTAMP, 11.80, 34.5, 48.0, 12000
);

COMMIT;

SELECT id_alerta, tipo_alerta, severidade, mensagem, status
FROM   TB_ALERTA_CRITICO
WHERE  id_alerta = (SELECT MAX(id_alerta) FROM TB_ALERTA_CRITICO);

-- SECAO 7: PACKAGE

CREATE OR REPLACE PACKAGE PKG_PHYCOCARBON AS

    FUNCTION FN_SAUDE_TANQUE (p_id_tanque IN NUMBER) RETURN NUMBER;
    FUNCTION FN_CONTAR_ALERTAS (p_id_tanque IN NUMBER) RETURN NUMBER;
    PROCEDURE PRC_RELATORIO_FAZENDA (p_id_fazenda IN NUMBER);
    PROCEDURE PRC_RESUMO_PLATAFORMA;
END PKG_PHYCOCARBON;
/

CREATE OR REPLACE PACKAGE BODY PKG_PHYCOCARBON AS

    FUNCTION FN_SAUDE_TANQUE (p_id_tanque IN NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN FN_CALCULA_SAUDE_TANQUE(p_id_tanque);
    END FN_SAUDE_TANQUE;

    FUNCTION FN_CONTAR_ALERTAS (p_id_tanque IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO   v_total
        FROM   TB_ALERTA_CRITICO
        WHERE  id_tanque = p_id_tanque
        AND    status IN ('ABERTO', 'EM_ANALISE');

        RETURN v_total;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END FN_CONTAR_ALERTAS;

    PROCEDURE PRC_RELATORIO_FAZENDA (p_id_fazenda IN NUMBER) IS
    BEGIN
        PRC_GERA_RELATORIO_FAZENDA(p_id_fazenda);
    END PRC_RELATORIO_FAZENDA;

    PROCEDURE PRC_RESUMO_PLATAFORMA IS
        v_fazendas  NUMBER;
        v_tanques   NUMBER;
        v_alertas   NUMBER;
        v_lotes     NUMBER;
        v_creditos  NUMBER;
        v_receita   NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_fazendas  FROM TB_FAZENDA WHERE status = 'ATIVA';
        SELECT COUNT(*) INTO v_tanques   FROM TB_TANQUE  WHERE status = 'ATIVO';
        SELECT COUNT(*) INTO v_alertas   FROM TB_ALERTA_CRITICO WHERE status IN ('ABERTO','EM_ANALISE');
        SELECT COUNT(*) INTO v_lotes     FROM TB_LOTE_BIOMASSA  WHERE status = 'DISPONIVEL';
        SELECT COUNT(*) INTO v_creditos  FROM TB_CREDITO_CARBONO WHERE status IN ('DISPONIVEL','VALIDADO');
        SELECT NVL(SUM(valor_total), 0) INTO v_receita FROM TB_TRANSACAO_MARKETPLACE WHERE status = 'CONFIRMADA';

        DBMS_OUTPUT.PUT_LINE('   PHYCOCARBON — RESUMO DA PLATAFORMA');
        DBMS_OUTPUT.PUT_LINE('Fazendas ativas       : ' || v_fazendas);
        DBMS_OUTPUT.PUT_LINE('Tanques em operacao   : ' || v_tanques);
        DBMS_OUTPUT.PUT_LINE('Alertas pendentes     : ' || v_alertas);
        DBMS_OUTPUT.PUT_LINE('Lotes disponiveis     : ' || v_lotes);
        DBMS_OUTPUT.PUT_LINE('Creditos de carbono   : ' || v_creditos);
        DBMS_OUTPUT.PUT_LINE('Receita confirmada    : R$ ' || TO_CHAR(v_receita, 'FM999G990D00'));
    END PRC_RESUMO_PLATAFORMA;

END PKG_PHYCOCARBON;
/

BEGIN
    PKG_PHYCOCARBON.PRC_RESUMO_PLATAFORMA;
END;
/

SELECT
    t.codigo_tanque,
    t.tipo_alga,
    PKG_PHYCOCARBON.FN_SAUDE_TANQUE(t.id_tanque)   AS saude,
    PKG_PHYCOCARBON.FN_CONTAR_ALERTAS(t.id_tanque) AS alertas_abertos
FROM
    TB_TANQUE t
WHERE
    t.status = 'ATIVO'
ORDER BY
    saude DESC;