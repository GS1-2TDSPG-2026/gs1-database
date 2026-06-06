-- PROJETO: Phycocarbon — Plataforma de Monitoramento de Microalgas
-- DISCIPLINA: Mastering Relational and Non-Relational Database
-- FIAP Global Solution 2026 | 2TDSPG 

SET SERVEROUTPUT ON;

-- ============================================================
-- SEÇÃO 0: LIMPEZA DO AMBIENTE
-- ============================================================

BEGIN
    FOR t IN (
        SELECT table_name
        FROM user_tables
        WHERE table_name IN (
            'TB_TRANSACAO_MARKETPLACE',
            'TB_CREDITO_CARBONO',
            'TB_LOTE_BIOMASSA',
            'TB_PREVISOES_IA',
            'TB_DADO_ORBITAL_BR',
            'TB_DADO_ORBITAL',
            'TB_ALERTA_CRITICO',
            'TB_METRICAS_TANQUE',
            'TB_DISPOSITIVO_IOT',
            'TB_TANQUE',
            'TB_FAZENDA',
            'TB_USUARIO',
            'TB_PERFIL'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS PURGE';
    END LOOP;
END;
/

BEGIN
    FOR s IN (
        SELECT sequence_name
        FROM user_sequences
        WHERE sequence_name IN (
            'SQ_PERFIL',
            'SQ_USUARIO',
            'SQ_FAZENDA',
            'SQ_TANQUE',
            'SQ_DISPOSITIVO_IOT',
            'SQ_METRICAS_TANQUE',
            'SQ_ALERTA_CRITICO',
            'SQ_DADO_ORBITAL',
            'SQ_DADO_ORBITAL_BR',
            'SQ_PREVISOES_IA',
            'SQ_LOTE_BIOMASSA',
            'SQ_CREDITO_CARBONO',
            'SQ_TRANSACAO_MARKETPLACE'
        )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
    END LOOP;
END;
/

-- ============================================================
-- SEÇÃO 1: SEQUENCES
-- ============================================================

CREATE SEQUENCE SQ_PERFIL
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE SQ_USUARIO
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_FAZENDA
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_TANQUE
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_DISPOSITIVO_IOT
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_METRICAS_TANQUE
    START WITH 1
    INCREMENT BY 1
    CACHE 100
    NOCYCLE;

CREATE SEQUENCE SQ_ALERTA_CRITICO
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_DADO_ORBITAL
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_DADO_ORBITAL_BR
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_PREVISOES_IA
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_LOTE_BIOMASSA
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_CREDITO_CARBONO
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

CREATE SEQUENCE SQ_TRANSACAO_MARKETPLACE
    START WITH 1
    INCREMENT BY 1
    CACHE 20
    NOCYCLE;

-- ============================================================
-- SEÇÃO 2: TABELAS
-- ============================================================

CREATE TABLE TB_PERFIL (
    id_perfil       NUMBER(5)       NOT NULL,
    nome_perfil     VARCHAR2(30)    NOT NULL,
    descricao       VARCHAR2(200)   NULL,
    criado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em   TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_PERFIL
        PRIMARY KEY (id_perfil),

    CONSTRAINT UQ_PERFIL_NOME
        UNIQUE (nome_perfil),

    CONSTRAINT CK_PERFIL_NOME
        CHECK (nome_perfil IN (
            'ADMIN',
            'OPERADOR_CAMPO',
            'INVESTIDOR',
            'COMPRADOR_B2B'
        ))
);

CREATE TABLE TB_USUARIO (
    id_usuario      NUMBER(10)      NOT NULL,
    id_perfil       NUMBER(5)       NOT NULL,
    nome            VARCHAR2(100)   NOT NULL,
    email           VARCHAR2(150)   NOT NULL,
    senha_hash      VARCHAR2(255)   NOT NULL,
    telefone        VARCHAR2(20)    NULL,
    status          CHAR(1)         DEFAULT 'A' NOT NULL,
    dt_criacao      DATE            DEFAULT SYSDATE NOT NULL,
    criado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em   TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_USUARIO
        PRIMARY KEY (id_usuario),

    CONSTRAINT FK_USUARIO_PERFIL
        FOREIGN KEY (id_perfil)
        REFERENCES TB_PERFIL (id_perfil),

    CONSTRAINT UQ_USUARIO_EMAIL
        UNIQUE (email),

    CONSTRAINT CK_USUARIO_STATUS
        CHECK (status IN ('A', 'I', 'B')),

    CONSTRAINT CK_USUARIO_EMAIL
        CHECK (email LIKE '%@%.%')
);

CREATE TABLE TB_FAZENDA (
    id_fazenda              NUMBER(10)      NOT NULL,
    id_usuario_responsavel  NUMBER(10)      NOT NULL,
    nome                    VARCHAR2(100)   NOT NULL,
    cidade                  VARCHAR2(80)    NOT NULL,
    uf                      CHAR(2)         NOT NULL,
    latitude                NUMBER(10, 7)   NULL,
    longitude               NUMBER(11, 7)   NULL,
    status                  VARCHAR2(10)    DEFAULT 'ATIVA' NOT NULL,
    dt_cadastro             DATE            DEFAULT SYSDATE NOT NULL,
    criado_em               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_FAZENDA
        PRIMARY KEY (id_fazenda),

    CONSTRAINT FK_FAZENDA_USUARIO
        FOREIGN KEY (id_usuario_responsavel)
        REFERENCES TB_USUARIO (id_usuario),

    CONSTRAINT CK_FAZENDA_UF
        CHECK (uf = UPPER(uf) AND LENGTH(uf) = 2),

    CONSTRAINT CK_FAZENDA_LATITUDE
        CHECK (latitude BETWEEN -90 AND 90),

    CONSTRAINT CK_FAZENDA_LONGITUDE
        CHECK (longitude BETWEEN -180 AND 180),

    CONSTRAINT CK_FAZENDA_STATUS
        CHECK (status IN ('ATIVA', 'INATIVA', 'SUSPENSA'))
);

CREATE TABLE TB_TANQUE (
    id_tanque           NUMBER(10)      NOT NULL,
    id_fazenda          NUMBER(10)      NOT NULL,
    codigo_tanque       VARCHAR2(20)    NOT NULL,
    tipo_alga           VARCHAR2(100)   NOT NULL,
    capacidade_litros   NUMBER(10, 2)   NOT NULL,
    ph_min              NUMBER(4, 2)    NOT NULL,
    ph_max              NUMBER(4, 2)    NOT NULL,
    temperatura_min     NUMBER(5, 2)    NOT NULL,
    temperatura_max     NUMBER(5, 2)    NOT NULL,
    status              VARCHAR2(15)    DEFAULT 'ATIVO' NOT NULL,
    dt_instalacao       DATE            DEFAULT SYSDATE NOT NULL,
    criado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_TANQUE
        PRIMARY KEY (id_tanque),

    CONSTRAINT FK_TANQUE_FAZENDA
        FOREIGN KEY (id_fazenda)
        REFERENCES TB_FAZENDA (id_fazenda),

    CONSTRAINT UQ_TANQUE_CODIGO_FAZENDA
        UNIQUE (id_fazenda, codigo_tanque),

    CONSTRAINT CK_TANQUE_PH
        CHECK (ph_min >= 0 AND ph_max <= 14 AND ph_min < ph_max),

    CONSTRAINT CK_TANQUE_TEMPERATURA
        CHECK (temperatura_min < temperatura_max),

    CONSTRAINT CK_TANQUE_CAPACIDADE
        CHECK (capacidade_litros > 0),

    CONSTRAINT CK_TANQUE_STATUS
        CHECK (status IN ('ATIVO', 'INATIVO', 'MANUTENCAO', 'COLHEITA'))
);

CREATE TABLE TB_DISPOSITIVO_IOT (
    id_dispositivo  NUMBER(10)      NOT NULL,
    id_tanque       NUMBER(10)      NOT NULL,
    codigo_serie    VARCHAR2(50)    NOT NULL,
    topico_mqtt     VARCHAR2(200)   NOT NULL,
    modelo          VARCHAR2(50)    NULL,
    ativo           CHAR(1)         DEFAULT 'S' NOT NULL,
    dt_instalacao   DATE            DEFAULT SYSDATE NOT NULL,
    criado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em   TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_TB_DISPOSITIVO_IOT
        PRIMARY KEY (id_dispositivo),

    CONSTRAINT FK_TB_DISP_IOT_TANQUE
        FOREIGN KEY (id_tanque)
        REFERENCES TB_TANQUE (id_tanque),

    CONSTRAINT UQ_TB_DISP_IOT_SERIE
        UNIQUE (codigo_serie),

    CONSTRAINT UQ_TB_DISP_IOT_MQTT
        UNIQUE (topico_mqtt),

    CONSTRAINT CK_TB_DISP_IOT_ATIVO
        CHECK (ativo IN ('S', 'N'))
);

CREATE TABLE TB_METRICAS_TANQUE (
    id_metrica          NUMBER(15)      NOT NULL,
    id_dispositivo      NUMBER(10)      NOT NULL,
    id_tanque           NUMBER(10)      NOT NULL,
    dt_leitura          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    ph                  NUMBER(5, 2)    NULL,
    temperatura         NUMBER(6, 2)    NULL,
    turbidez            NUMBER(8, 3)    NULL,
    luminosidade        NUMBER(10, 2)   NULL,
    payload_original    VARCHAR2(4000)  NULL,
    criado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_METRICAS_TANQUE
        PRIMARY KEY (id_metrica),

    CONSTRAINT FK_METRICA_DISPOSITIVO
        FOREIGN KEY (id_dispositivo)
        REFERENCES TB_DISPOSITIVO_IOT (id_dispositivo),

    CONSTRAINT FK_METRICA_TANQUE
        FOREIGN KEY (id_tanque)
        REFERENCES TB_TANQUE (id_tanque),

    CONSTRAINT CK_METRICA_PH
        CHECK (ph BETWEEN 0 AND 14),

    CONSTRAINT CK_METRICA_TEMPERATURA
        CHECK (temperatura BETWEEN -10 AND 100),

    CONSTRAINT CK_METRICA_TURBIDEZ
        CHECK (turbidez >= 0),

    CONSTRAINT CK_METRICA_LUMINOSIDADE
        CHECK (luminosidade >= 0)
);

CREATE TABLE TB_ALERTA_CRITICO (
    id_alerta       NUMBER(15)      NOT NULL,
    id_metrica      NUMBER(15)      NOT NULL,
    id_tanque       NUMBER(10)      NOT NULL,
    tipo_alerta     VARCHAR2(30)    NOT NULL,
    severidade      VARCHAR2(10)    NOT NULL,
    mensagem        VARCHAR2(500)   NOT NULL,
    status          VARCHAR2(15)    DEFAULT 'ABERTO' NOT NULL,
    dt_alerta       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    criado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em   TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_ALERTA_CRITICO
        PRIMARY KEY (id_alerta),

    CONSTRAINT FK_ALERTA_METRICA
        FOREIGN KEY (id_metrica)
        REFERENCES TB_METRICAS_TANQUE (id_metrica),

    CONSTRAINT FK_ALERTA_TANQUE
        FOREIGN KEY (id_tanque)
        REFERENCES TB_TANQUE (id_tanque),

    CONSTRAINT CK_ALERTA_TIPO
        CHECK (tipo_alerta IN (
            'PH_CRITICO',
            'PH_ALTO',
            'PH_BAIXO',
            'TEMPERATURA_ALTA',
            'TEMPERATURA_BAIXA',
            'TURBIDEZ_FORA_PADRAO',
            'LUMINOSIDADE_BAIXA'
        )),

    CONSTRAINT CK_ALERTA_SEVERIDADE
        CHECK (severidade IN ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA')),

    CONSTRAINT CK_ALERTA_STATUS
        CHECK (status IN ('ABERTO', 'EM_ANALISE', 'RESOLVIDO', 'IGNORADO'))
);

CREATE TABLE TB_DADO_ORBITAL (
    id_dado_orbital         NUMBER(15)      NOT NULL,
    id_fazenda              NUMBER(10)      NOT NULL,
    fonte                   VARCHAR2(30)    NOT NULL,
    dt_coleta               DATE            NOT NULL,
    irradiancia_par         NUMBER(8, 3)    NULL,
    nebulosidade            NUMBER(5, 2)    NULL,
    temperatura_ambiente    NUMBER(6, 2)    NULL,
    latitude                NUMBER(10, 7)   NULL,
    longitude               NUMBER(11, 7)   NULL,
    criado_em               TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_DADO_ORBITAL
        PRIMARY KEY (id_dado_orbital),

    CONSTRAINT FK_DADO_ORBITAL_FAZENDA
        FOREIGN KEY (id_fazenda)
        REFERENCES TB_FAZENDA (id_fazenda),

    CONSTRAINT CK_DADO_ORBITAL_FONTE
        CHECK (fonte IN (
            'NASA_POWER',
            'COPERNICUS',
            'INPE',
            'GOES_16',
            'OPEN_METEO',
            'ERA5_ARCHIVE'
        )),

    CONSTRAINT CK_DADO_ORBITAL_NEBULOSIDADE
        CHECK (nebulosidade BETWEEN 0 AND 100),

    CONSTRAINT CK_DADO_ORBITAL_PAR
        CHECK (irradiancia_par >= 0),

    CONSTRAINT CK_DADO_ORBITAL_LATITUDE
        CHECK (latitude BETWEEN -90 AND 90),

    CONSTRAINT CK_DADO_ORBITAL_LONGITUDE
        CHECK (longitude BETWEEN -180 AND 180)
);

CREATE TABLE TB_DADO_ORBITAL_BR (
    id_dado_orbital_br  NUMBER(15)      NOT NULL,
    cod_estacao         VARCHAR2(10)    NOT NULL,
    nome_estacao        VARCHAR2(100)   NULL,
    dt_medicao          VARCHAR2(10)    NOT NULL,
    hr_medicao          VARCHAR2(4)     NULL,
    temp_maxima         NUMBER(6, 2)    NULL,
    temp_minima         NUMBER(6, 2)    NULL,
    temp_media          NUMBER(6, 2)    NULL,
    umidade_relativa    NUMBER(6, 2)    NULL,
    precipitacao        NUMBER(8, 2)    NULL,
    velocidade_vento    NUMBER(6, 2)    NULL,
    direcao_vento       NUMBER(6, 2)    NULL,
    pressao_atm         NUMBER(8, 2)    NULL,
    radiacao_global     NUMBER(10, 2)   NULL,
    json_original       CLOB            NULL,
    criado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_DADO_ORBITAL_BR
        PRIMARY KEY (id_dado_orbital_br),

    CONSTRAINT UQ_DADO_ORBITAL_BR_ESTACAO_DATA_HORA
        UNIQUE (cod_estacao, dt_medicao, hr_medicao)
);

CREATE TABLE TB_PREVISOES_IA (
    id_previsao         NUMBER(15)      NOT NULL,
    id_tanque           NUMBER(10)      NOT NULL,
    id_dado_orbital     NUMBER(15)      NOT NULL,
    dt_previsao         DATE            DEFAULT SYSDATE NOT NULL,
    biomassa_g_l        NUMBER(8, 4)    NOT NULL,
    dt_pico_previsto    DATE            NOT NULL,
    confianca_pct       NUMBER(5, 2)    NOT NULL,
    modelo_utilizado    VARCHAR2(100)   NOT NULL,
    criado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_PREVISOES_IA
        PRIMARY KEY (id_previsao),

    CONSTRAINT FK_PREVISAO_TANQUE
        FOREIGN KEY (id_tanque)
        REFERENCES TB_TANQUE (id_tanque),

    CONSTRAINT FK_PREVISAO_DADO_ORBITAL
        FOREIGN KEY (id_dado_orbital)
        REFERENCES TB_DADO_ORBITAL (id_dado_orbital),

    CONSTRAINT CK_PREVISAO_BIOMASSA
        CHECK (biomassa_g_l > 0),

    CONSTRAINT CK_PREVISAO_CONFIANCA
        CHECK (confianca_pct BETWEEN 0 AND 100),

    CONSTRAINT CK_PREVISAO_DATAS
        CHECK (dt_pico_previsto >= dt_previsao)
);

CREATE TABLE TB_LOTE_BIOMASSA (
    id_lote             NUMBER(10)      NOT NULL,
    id_fazenda          NUMBER(10)      NOT NULL,
    id_tanque           NUMBER(10)      NOT NULL,
    taxonomia_alga      VARCHAR2(150)   NOT NULL,
    peso_kg             NUMBER(10, 3)   NOT NULL,
    preco_unitario      NUMBER(10, 2)   NOT NULL,
    status              VARCHAR2(15)    DEFAULT 'DISPONIVEL' NOT NULL,
    dt_colheita         DATE            DEFAULT SYSDATE NOT NULL,
    criado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_LOTE_BIOMASSA
        PRIMARY KEY (id_lote),

    CONSTRAINT FK_LOTE_FAZENDA
        FOREIGN KEY (id_fazenda)
        REFERENCES TB_FAZENDA (id_fazenda),

    CONSTRAINT FK_LOTE_TANQUE
        FOREIGN KEY (id_tanque)
        REFERENCES TB_TANQUE (id_tanque),

    CONSTRAINT CK_LOTE_PESO
        CHECK (peso_kg > 0),

    CONSTRAINT CK_LOTE_PRECO
        CHECK (preco_unitario > 0),

    CONSTRAINT CK_LOTE_STATUS
        CHECK (status IN ('DISPONIVEL', 'RESERVADO', 'VENDIDO', 'CANCELADO'))
);

CREATE TABLE TB_CREDITO_CARBONO (
    id_credito          NUMBER(10)      NOT NULL,
    id_fazenda          NUMBER(10)      NOT NULL,
    id_lote             NUMBER(10)      NOT NULL,
    co2_toneladas       NUMBER(10, 4)   NOT NULL,
    hash_auditoria      VARCHAR2(64)    NOT NULL,
    status              VARCHAR2(15)    DEFAULT 'GERADO' NOT NULL,
    dt_validacao        DATE            NULL,
    criado_em           TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_CREDITO_CARBONO
        PRIMARY KEY (id_credito),

    CONSTRAINT FK_CREDITO_FAZENDA
        FOREIGN KEY (id_fazenda)
        REFERENCES TB_FAZENDA (id_fazenda),

    CONSTRAINT FK_CREDITO_LOTE
        FOREIGN KEY (id_lote)
        REFERENCES TB_LOTE_BIOMASSA (id_lote),

    CONSTRAINT UQ_CREDITO_HASH
        UNIQUE (hash_auditoria),

    CONSTRAINT CK_CREDITO_CO2
        CHECK (co2_toneladas > 0),

    CONSTRAINT CK_CREDITO_STATUS
        CHECK (status IN ('GERADO', 'VALIDADO', 'DISPONIVEL', 'VENDIDO', 'CANCELADO'))
);

CREATE TABLE TB_TRANSACAO_MARKETPLACE (
    id_transacao          NUMBER(15)      NOT NULL,
    id_usuario_comprador  NUMBER(10)      NOT NULL,
    id_lote               NUMBER(10)      NULL,
    id_credito            NUMBER(10)      NULL,
    tipo_transacao        VARCHAR2(25)    NOT NULL,
    quantidade            NUMBER(10, 4)   NOT NULL,
    valor_total           NUMBER(15, 2)   NOT NULL,
    status                VARCHAR2(15)    DEFAULT 'PENDENTE' NOT NULL,
    dt_transacao          TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    criado_em             TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,
    atualizado_em         TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

    CONSTRAINT PK_TRANSACAO_MARKETPLACE
        PRIMARY KEY (id_transacao),

    CONSTRAINT FK_TRANSACAO_USUARIO
        FOREIGN KEY (id_usuario_comprador)
        REFERENCES TB_USUARIO (id_usuario),

    CONSTRAINT FK_TRANSACAO_LOTE
        FOREIGN KEY (id_lote)
        REFERENCES TB_LOTE_BIOMASSA (id_lote),

    CONSTRAINT FK_TRANSACAO_CREDITO
        FOREIGN KEY (id_credito)
        REFERENCES TB_CREDITO_CARBONO (id_credito),

    CONSTRAINT CK_TRANSACAO_OBJETO
        CHECK (
            (id_lote IS NOT NULL AND id_credito IS NULL)
            OR
            (id_lote IS NULL AND id_credito IS NOT NULL)
        ),

    CONSTRAINT CK_TRANSACAO_TIPO
        CHECK (tipo_transacao IN ('COMPRA_BIOMASSA', 'COMPRA_CREDITO_CARBONO')),

    CONSTRAINT CK_TRANSACAO_QUANTIDADE
        CHECK (quantidade > 0),

    CONSTRAINT CK_TRANSACAO_VALOR
        CHECK (valor_total > 0),

    CONSTRAINT CK_TRANSACAO_STATUS
        CHECK (status IN ('PENDENTE', 'CONFIRMADA', 'CANCELADA', 'ESTORNADA'))
);

-- ============================================================
-- SEÇÃO 3: TRIGGERS PARA IDS AUTOMÁTICOS
-- ============================================================

CREATE OR REPLACE TRIGGER TRG_BI_TB_PERFIL
BEFORE INSERT ON TB_PERFIL
FOR EACH ROW
WHEN (NEW.id_perfil IS NULL)
BEGIN
    SELECT SQ_PERFIL.NEXTVAL
    INTO :NEW.id_perfil
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_USUARIO
BEFORE INSERT ON TB_USUARIO
FOR EACH ROW
WHEN (NEW.id_usuario IS NULL)
BEGIN
    SELECT SQ_USUARIO.NEXTVAL
    INTO :NEW.id_usuario
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_FAZENDA
BEFORE INSERT ON TB_FAZENDA
FOR EACH ROW
WHEN (NEW.id_fazenda IS NULL)
BEGIN
    SELECT SQ_FAZENDA.NEXTVAL
    INTO :NEW.id_fazenda
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_TANQUE
BEFORE INSERT ON TB_TANQUE
FOR EACH ROW
WHEN (NEW.id_tanque IS NULL)
BEGIN
    SELECT SQ_TANQUE.NEXTVAL
    INTO :NEW.id_tanque
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_DISPOSITIVO_IOT
BEFORE INSERT ON TB_DISPOSITIVO_IOT
FOR EACH ROW
WHEN (NEW.id_dispositivo IS NULL)
BEGIN
    SELECT SQ_DISPOSITIVO_IOT.NEXTVAL
    INTO :NEW.id_dispositivo
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_METRICAS_TANQUE
BEFORE INSERT ON TB_METRICAS_TANQUE
FOR EACH ROW
WHEN (NEW.id_metrica IS NULL)
BEGIN
    SELECT SQ_METRICAS_TANQUE.NEXTVAL
    INTO :NEW.id_metrica
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_ALERTA_CRITICO
BEFORE INSERT ON TB_ALERTA_CRITICO
FOR EACH ROW
WHEN (NEW.id_alerta IS NULL)
BEGIN
    SELECT SQ_ALERTA_CRITICO.NEXTVAL
    INTO :NEW.id_alerta
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_DADO_ORBITAL
BEFORE INSERT ON TB_DADO_ORBITAL
FOR EACH ROW
WHEN (NEW.id_dado_orbital IS NULL)
BEGIN
    SELECT SQ_DADO_ORBITAL.NEXTVAL
    INTO :NEW.id_dado_orbital
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_DADO_ORBITAL_BR
BEFORE INSERT ON TB_DADO_ORBITAL_BR
FOR EACH ROW
WHEN (NEW.id_dado_orbital_br IS NULL)
BEGIN
    SELECT SQ_DADO_ORBITAL_BR.NEXTVAL
    INTO :NEW.id_dado_orbital_br
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_PREVISOES_IA
BEFORE INSERT ON TB_PREVISOES_IA
FOR EACH ROW
WHEN (NEW.id_previsao IS NULL)
BEGIN
    SELECT SQ_PREVISOES_IA.NEXTVAL
    INTO :NEW.id_previsao
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_LOTE_BIOMASSA
BEFORE INSERT ON TB_LOTE_BIOMASSA
FOR EACH ROW
WHEN (NEW.id_lote IS NULL)
BEGIN
    SELECT SQ_LOTE_BIOMASSA.NEXTVAL
    INTO :NEW.id_lote
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_CREDITO_CARBONO
BEFORE INSERT ON TB_CREDITO_CARBONO
FOR EACH ROW
WHEN (NEW.id_credito IS NULL)
BEGIN
    SELECT SQ_CREDITO_CARBONO.NEXTVAL
    INTO :NEW.id_credito
    FROM dual;
END;
/

CREATE OR REPLACE TRIGGER TRG_BI_TB_TRANSACAO_MARKETPLACE
BEFORE INSERT ON TB_TRANSACAO_MARKETPLACE
FOR EACH ROW
WHEN (NEW.id_transacao IS NULL)
BEGIN
    SELECT SQ_TRANSACAO_MARKETPLACE.NEXTVAL
    INTO :NEW.id_transacao
    FROM dual;
END;
/

-- ============================================================
-- SEÇÃO 4: COMMENTS
-- ============================================================

COMMENT ON TABLE TB_PERFIL IS 'Catalogo de perfis de acesso ao sistema Phycocarbon';
COMMENT ON TABLE TB_USUARIO IS 'Usuarios cadastrados na plataforma Phycocarbon';
COMMENT ON TABLE TB_FAZENDA IS 'Fazendas biologicas de cultivo de microalgas';
COMMENT ON TABLE TB_TANQUE IS 'Tanques ou biofotorreatores de cultivo de microalgas';
COMMENT ON TABLE TB_DISPOSITIVO_IOT IS 'Dispositivos ESP32 instalados nos tanques para monitoramento IoT';
COMMENT ON TABLE TB_METRICAS_TANQUE IS 'Serie temporal de leituras IoT dos sensores instalados nos tanques';
COMMENT ON TABLE TB_ALERTA_CRITICO IS 'Alertas automaticos gerados quando metricas saem dos limites';
COMMENT ON TABLE TB_DADO_ORBITAL IS 'Dados de radiacao e clima coletados via fontes orbitais ou meteorologicas';
COMMENT ON TABLE TB_DADO_ORBITAL_BR IS 'Dados meteorologicos brasileiros coletados de estacoes INMET';
COMMENT ON TABLE TB_PREVISOES_IA IS 'Previsoes de producao de biomassa geradas pelo motor de IA';
COMMENT ON TABLE TB_LOTE_BIOMASSA IS 'Lotes de biomassa colhidos e disponibilizados no marketplace B2B';
COMMENT ON TABLE TB_CREDITO_CARBONO IS 'Creditos de carbono gerados pelo sequestro de CO2 das microalgas';
COMMENT ON TABLE TB_TRANSACAO_MARKETPLACE IS 'Registro de transacoes de compra e venda no marketplace B2B';

-- ============================================================
-- SEÇÃO 5: ÍNDICES
-- ============================================================

CREATE INDEX IDX_USUARIO_PERFIL
    ON TB_USUARIO (id_perfil);

CREATE INDEX IDX_FAZENDA_RESPONSAVEL
    ON TB_FAZENDA (id_usuario_responsavel);

CREATE INDEX IDX_FAZENDA_UF
    ON TB_FAZENDA (uf);

CREATE INDEX IDX_TANQUE_FAZENDA
    ON TB_TANQUE (id_fazenda);

CREATE INDEX IDX_TANQUE_STATUS
    ON TB_TANQUE (status);

CREATE INDEX IDX_DISPOSITIVO_TANQUE
    ON TB_DISPOSITIVO_IOT (id_tanque);

CREATE INDEX IDX_METRICA_TANQUE_DT
    ON TB_METRICAS_TANQUE (id_tanque, dt_leitura DESC);

CREATE INDEX IDX_METRICA_DISPOSITIVO
    ON TB_METRICAS_TANQUE (id_dispositivo);

CREATE INDEX IDX_ALERTA_TANQUE_STATUS
    ON TB_ALERTA_CRITICO (id_tanque, status);

CREATE INDEX IDX_ALERTA_DT
    ON TB_ALERTA_CRITICO (dt_alerta DESC);

CREATE INDEX IDX_DADO_ORBITAL_FAZENDA_DT
    ON TB_DADO_ORBITAL (id_fazenda, dt_coleta DESC);

CREATE INDEX IDX_DADO_ORBITAL_FONTE
    ON TB_DADO_ORBITAL (fonte);

CREATE INDEX IDX_DADO_ORBITAL_BR_ESTACAO_DT
    ON TB_DADO_ORBITAL_BR (cod_estacao, dt_medicao DESC, hr_medicao DESC);

CREATE INDEX IDX_PREVISAO_TANQUE_DT
    ON TB_PREVISOES_IA (id_tanque, dt_pico_previsto);

CREATE INDEX IDX_PREVISAO_DADO_ORBITAL
    ON TB_PREVISOES_IA (id_dado_orbital);

CREATE INDEX IDX_LOTE_FAZENDA_STATUS
    ON TB_LOTE_BIOMASSA (id_fazenda, status);

CREATE INDEX IDX_LOTE_TANQUE
    ON TB_LOTE_BIOMASSA (id_tanque);

CREATE INDEX IDX_CREDITO_STATUS
    ON TB_CREDITO_CARBONO (status);

CREATE INDEX IDX_CREDITO_FAZENDA
    ON TB_CREDITO_CARBONO (id_fazenda);

CREATE INDEX IDX_CREDITO_LOTE
    ON TB_CREDITO_CARBONO (id_lote);

CREATE INDEX IDX_TRANSACAO_COMPRADOR
    ON TB_TRANSACAO_MARKETPLACE (id_usuario_comprador);

CREATE INDEX IDX_TRANSACAO_LOTE
    ON TB_TRANSACAO_MARKETPLACE (id_lote);

CREATE INDEX IDX_TRANSACAO_CREDITO
    ON TB_TRANSACAO_MARKETPLACE (id_credito);

CREATE INDEX IDX_TRANSACAO_DT
    ON TB_TRANSACAO_MARKETPLACE (dt_transacao DESC);

-- ============================================================
-- SEÇÃO 6: CONFIRMAÇÃO FINAL
-- ============================================================

SELECT
    table_name AS "TABELA",
    num_rows   AS "REGISTROS"
FROM
    user_tables
WHERE
    table_name IN (
        'TB_PERFIL',
        'TB_USUARIO',
        'TB_FAZENDA',
        'TB_TANQUE',
        'TB_DISPOSITIVO_IOT',
        'TB_METRICAS_TANQUE',
        'TB_ALERTA_CRITICO',
        'TB_DADO_ORBITAL',
        'TB_DADO_ORBITAL_BR',
        'TB_PREVISOES_IA',
        'TB_LOTE_BIOMASSA',
        'TB_CREDITO_CARBONO',
        'TB_TRANSACAO_MARKETPLACE'
    )
ORDER BY
    table_name;

SELECT
    sequence_name AS "SEQUENCE",
    min_value     AS "MIN",
    max_value     AS "MAX",
    increment_by  AS "INCREMENT",
    cache_size    AS "CACHE"
FROM
    user_sequences
WHERE
    sequence_name LIKE 'SQ_%'
ORDER BY
    sequence_name;

SELECT
    trigger_name AS "TRIGGER",
    table_name   AS "TABELA",
    status       AS "STATUS"
FROM
    user_triggers
WHERE
    trigger_name LIKE 'TRG_BI_%'
ORDER BY
    trigger_name;

SELECT
    index_name AS "INDICE",
    table_name AS "TABELA",
    uniqueness AS "TIPO"
FROM
    user_indexes
WHERE
    table_name IN (
        'TB_PERFIL',
        'TB_USUARIO',
        'TB_FAZENDA',
        'TB_TANQUE',
        'TB_DISPOSITIVO_IOT',
        'TB_METRICAS_TANQUE',
        'TB_ALERTA_CRITICO',
        'TB_DADO_ORBITAL',
        'TB_DADO_ORBITAL_BR',
        'TB_PREVISOES_IA',
        'TB_LOTE_BIOMASSA',
        'TB_CREDITO_CARBONO',
        'TB_TRANSACAO_MARKETPLACE'
    )
ORDER BY
    table_name, index_name;

COMMIT;