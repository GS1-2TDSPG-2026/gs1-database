-- PROJETO: Phycocarbon — Plataforma de Monitoramento de Microalgas
-- DISCIPLINA: Mastering Relational and Non-Relational Database
-- FIAP Global Solution 2026 | 2TDSPG 

-- SECAO 0: LIMPEZA DO AMBIENTE
-- Drops de tabelas 
BEGIN
    FOR t IN (
        SELECT table_name FROM user_tables
        WHERE table_name IN (
            'TB_TRANSACAO_MARKETPLACE',
            'TB_CREDITO_CARBONO',
            'TB_LOTE_BIOMASSA',
            'TB_PREVISOES_IA',
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
        SELECT sequence_name FROM user_sequences
        WHERE sequence_name IN (
            'SQ_PERFIL',
            'SQ_USUARIO',
            'SQ_FAZENDA',
            'SQ_TANQUE',
            'SQ_DISPOSITIVO_IOT',
            'SQ_METRICAS_TANQUE',
            'SQ_ALERTA_CRITICO',
            'SQ_DADO_ORBITAL',
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


-- SECAO 1: SEQUENCES

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


-- SECAO 2: TABELAS

CREATE TABLE TB_PERFIL (
    id_perfil       NUMBER(5)       NOT NULL,
    nome_perfil     VARCHAR2(30)    NOT NULL,
    descricao       VARCHAR2(200)   NULL,

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

COMMENT ON TABLE  TB_PERFIL              IS 'Catalogo de perfis de acesso ao sistema Phycocarbon';
COMMENT ON COLUMN TB_PERFIL.id_perfil    IS 'Identificador unico do perfil (PK)';
COMMENT ON COLUMN TB_PERFIL.nome_perfil  IS 'Nome tecnico do perfil: ADMIN, OPERADOR_CAMPO, INVESTIDOR, COMPRADOR_B2B';
COMMENT ON COLUMN TB_PERFIL.descricao    IS 'Descricao legivel da funcao e permissoes do perfil';


CREATE TABLE TB_USUARIO (

    id_usuario      NUMBER(10)      NOT NULL,
    id_perfil       NUMBER(5)       NOT NULL,
    nome            VARCHAR2(100)   NOT NULL,
    email           VARCHAR2(150)   NOT NULL,
    senha_hash      VARCHAR2(255)   NOT NULL,
    telefone        VARCHAR2(20)    NULL,
    status          CHAR(1)         DEFAULT 'A' NOT NULL,

    dt_criacao      DATE            DEFAULT SYSDATE NOT NULL,

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

COMMENT ON TABLE  TB_USUARIO             IS 'Usuarios cadastrados na plataforma Phycocarbon';
COMMENT ON COLUMN TB_USUARIO.id_usuario  IS 'Identificador unico do usuario (PK)';
COMMENT ON COLUMN TB_USUARIO.id_perfil   IS 'FK para TB_PERFIL — define o nivel de acesso';
COMMENT ON COLUMN TB_USUARIO.nome        IS 'Nome completo do usuario';
COMMENT ON COLUMN TB_USUARIO.email       IS 'Email unico, utilizado como login';
COMMENT ON COLUMN TB_USUARIO.senha_hash  IS 'Hash criptografico da senha (bcrypt/SHA-256)';
COMMENT ON COLUMN TB_USUARIO.telefone    IS 'Telefone de contato no formato +55DDDNUMERO';
COMMENT ON COLUMN TB_USUARIO.status      IS 'Status da conta: A=Ativo, I=Inativo, B=Bloqueado';
COMMENT ON COLUMN TB_USUARIO.dt_criacao  IS 'Data e hora do cadastro (DEFAULT SYSDATE)';


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

COMMENT ON TABLE  TB_FAZENDA                       IS 'Fazendas biologicas de cultivo de microalgas';
COMMENT ON COLUMN TB_FAZENDA.id_fazenda            IS 'Identificador unico da fazenda (PK)';
COMMENT ON COLUMN TB_FAZENDA.id_usuario_responsavel IS 'FK para TB_USUARIO — responsavel tecnico';
COMMENT ON COLUMN TB_FAZENDA.nome                  IS 'Nome comercial da fazenda';
COMMENT ON COLUMN TB_FAZENDA.cidade                IS 'Municipio de localizacao da fazenda';
COMMENT ON COLUMN TB_FAZENDA.uf                    IS 'Sigla do estado (ex: SP, RJ, BA)';
COMMENT ON COLUMN TB_FAZENDA.latitude              IS 'Latitude geografica decimal (-90 a +90)';
COMMENT ON COLUMN TB_FAZENDA.longitude             IS 'Longitude geografica decimal (-180 a +180)';
COMMENT ON COLUMN TB_FAZENDA.status                IS 'Status: ATIVA, INATIVA, SUSPENSA';
COMMENT ON COLUMN TB_FAZENDA.dt_cadastro           IS 'Data de cadastro da fazenda (DEFAULT SYSDATE)';


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

COMMENT ON TABLE  TB_TANQUE                  IS 'Tanques ou biofotorreatores de cultivo de microalgas';
COMMENT ON COLUMN TB_TANQUE.id_tanque        IS 'Identificador unico do tanque (PK)';
COMMENT ON COLUMN TB_TANQUE.id_fazenda       IS 'FK para TB_FAZENDA — fazenda proprietaria';
COMMENT ON COLUMN TB_TANQUE.codigo_tanque    IS 'Codigo fisico do tanque, unico por fazenda (ex: TQ-001)';
COMMENT ON COLUMN TB_TANQUE.tipo_alga        IS 'Nome cientifico/comercial da especie (ex: Spirulina platensis)';
COMMENT ON COLUMN TB_TANQUE.capacidade_litros IS 'Volume total do tanque em litros';
COMMENT ON COLUMN TB_TANQUE.ph_min           IS 'Limite inferior de pH para cultivo saudavel';
COMMENT ON COLUMN TB_TANQUE.ph_max           IS 'Limite superior de pH para cultivo saudavel';
COMMENT ON COLUMN TB_TANQUE.temperatura_min  IS 'Temperatura minima em graus Celsius';
COMMENT ON COLUMN TB_TANQUE.temperatura_max  IS 'Temperatura maxima em graus Celsius';
COMMENT ON COLUMN TB_TANQUE.status           IS 'Status: ATIVO, INATIVO, MANUTENCAO, COLHEITA';
COMMENT ON COLUMN TB_TANQUE.dt_instalacao    IS 'Data de instalacao fisica do tanque';

CREATE TABLE TB_DISPOSITIVO_IOT (
    id_dispositivo  NUMBER(10)      NOT NULL,
    id_tanque       NUMBER(10)      NOT NULL,
    codigo_serie    VARCHAR2(50)    NOT NULL,
    topico_mqtt     VARCHAR2(200)   NOT NULL,
    modelo          VARCHAR2(50)    NULL,
    ativo           CHAR(1)         DEFAULT 'S' NOT NULL,
    dt_instalacao   DATE            DEFAULT SYSDATE NOT NULL,

    CONSTRAINT PK_DISPOSITIVO_IOT
        PRIMARY KEY (id_dispositivo),

    CONSTRAINT FK_DISPOSITIVO_TANQUE
        FOREIGN KEY (id_tanque)
        REFERENCES TB_TANQUE (id_tanque),

    CONSTRAINT UQ_DISPOSITIVO_SERIE
        UNIQUE (codigo_serie),

    CONSTRAINT UQ_DISPOSITIVO_MQTT
        UNIQUE (topico_mqtt),

    CONSTRAINT CK_DISPOSITIVO_ATIVO
        CHECK (ativo IN ('S', 'N'))
);

COMMENT ON TABLE  TB_DISPOSITIVO_IOT               IS 'Dispositivos ESP32 instalados nos tanques para monitoramento IoT';
COMMENT ON COLUMN TB_DISPOSITIVO_IOT.id_dispositivo IS 'Identificador unico do dispositivo (PK)';
COMMENT ON COLUMN TB_DISPOSITIVO_IOT.id_tanque      IS 'FK para TB_TANQUE — tanque monitorado';
COMMENT ON COLUMN TB_DISPOSITIVO_IOT.codigo_serie   IS 'Numero de serie unico gravado no hardware';
COMMENT ON COLUMN TB_DISPOSITIVO_IOT.topico_mqtt    IS 'Topico MQTT para receber mensagens do sensor (ex: algaspace/fazenda/1/tanque/1)';
COMMENT ON COLUMN TB_DISPOSITIVO_IOT.modelo         IS 'Modelo do hardware (ex: ESP32-WROOM-32)';
COMMENT ON COLUMN TB_DISPOSITIVO_IOT.ativo          IS 'S=Dispositivo operacional, N=Desativado';
COMMENT ON COLUMN TB_DISPOSITIVO_IOT.dt_instalacao  IS 'Data de instalacao fisica no tanque';

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

COMMENT ON TABLE  TB_METRICAS_TANQUE                  IS 'Serie temporal de leituras IoT dos sensores instalados nos tanques';
COMMENT ON COLUMN TB_METRICAS_TANQUE.id_metrica        IS 'Identificador unico da leitura (PK)';
COMMENT ON COLUMN TB_METRICAS_TANQUE.id_dispositivo    IS 'FK para TB_DISPOSITIVO_IOT — sensor de origem';
COMMENT ON COLUMN TB_METRICAS_TANQUE.id_tanque         IS 'FK para TB_TANQUE — desnormalizacao para performance';
COMMENT ON COLUMN TB_METRICAS_TANQUE.dt_leitura        IS 'Timestamp exato da coleta pelo sensor ESP32';
COMMENT ON COLUMN TB_METRICAS_TANQUE.ph                IS 'pH medido (escala 0 a 14)';
COMMENT ON COLUMN TB_METRICAS_TANQUE.temperatura       IS 'Temperatura em graus Celsius';
COMMENT ON COLUMN TB_METRICAS_TANQUE.turbidez          IS 'Turbidez em NTU (Nephelometric Turbidity Units)';
COMMENT ON COLUMN TB_METRICAS_TANQUE.luminosidade      IS 'Luminosidade em lux';
COMMENT ON COLUMN TB_METRICAS_TANQUE.payload_original  IS 'JSON bruto enviado pelo ESP32 (auditoria e reprocessamento)';



CREATE TABLE TB_ALERTA_CRITICO (

    id_alerta       NUMBER(15)      NOT NULL,
    id_metrica      NUMBER(15)      NOT NULL,
    id_tanque       NUMBER(10)      NOT NULL,
    tipo_alerta     VARCHAR2(30)    NOT NULL,
    severidade      VARCHAR2(10)    NOT NULL,
    mensagem        VARCHAR2(500)   NOT NULL,
    status          VARCHAR2(15)    DEFAULT 'ABERTO' NOT NULL,
    dt_alerta       TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

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

COMMENT ON TABLE  TB_ALERTA_CRITICO            IS 'Alertas automaticos gerados por trigger quando metricas saem dos limites';
COMMENT ON COLUMN TB_ALERTA_CRITICO.id_alerta   IS 'Identificador unico do alerta (PK)';
COMMENT ON COLUMN TB_ALERTA_CRITICO.id_metrica  IS 'FK para TB_METRICAS_TANQUE — leitura que originou o alerta';
COMMENT ON COLUMN TB_ALERTA_CRITICO.id_tanque   IS 'FK para TB_TANQUE — tanque com parametro critico';
COMMENT ON COLUMN TB_ALERTA_CRITICO.tipo_alerta IS 'Tipo: PH_CRITICO, TEMPERATURA_ALTA, TURBIDEZ_FORA_PADRAO, LUMINOSIDADE_BAIXA, etc.';
COMMENT ON COLUMN TB_ALERTA_CRITICO.severidade  IS 'Nivel de severidade: BAIXA, MEDIA, ALTA, CRITICA';
COMMENT ON COLUMN TB_ALERTA_CRITICO.mensagem    IS 'Mensagem descritiva gerada automaticamente pelo trigger';
COMMENT ON COLUMN TB_ALERTA_CRITICO.status      IS 'Status do alerta: ABERTO, EM_ANALISE, RESOLVIDO, IGNORADO';
COMMENT ON COLUMN TB_ALERTA_CRITICO.dt_alerta   IS 'Timestamp de geracao do alerta pelo trigger';


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

    CONSTRAINT PK_DADO_ORBITAL
        PRIMARY KEY (id_dado_orbital),

    CONSTRAINT FK_DADO_ORBITAL_FAZENDA
        FOREIGN KEY (id_fazenda)
        REFERENCES TB_FAZENDA (id_fazenda),

    CONSTRAINT CK_DADO_ORBITAL_FONTE
        CHECK (fonte IN ('NASA_POWER', 'COPERNICUS', 'INPE', 'GOES_16')),

    CONSTRAINT CK_DADO_ORBITAL_NEBULOSIDADE
        CHECK (nebulosidade BETWEEN 0 AND 100),

    CONSTRAINT CK_DADO_ORBITAL_PAR
        CHECK (irradiancia_par >= 0)
);

COMMENT ON TABLE  TB_DADO_ORBITAL                      IS 'Dados de radiacao e clima coletados via satelites NASA/Copernicus';
COMMENT ON COLUMN TB_DADO_ORBITAL.id_dado_orbital       IS 'Identificador unico do registro orbital (PK)';
COMMENT ON COLUMN TB_DADO_ORBITAL.id_fazenda            IS 'FK para TB_FAZENDA — fazenda referenciada';
COMMENT ON COLUMN TB_DADO_ORBITAL.fonte                 IS 'Fonte: NASA_POWER, COPERNICUS, INPE, GOES_16';
COMMENT ON COLUMN TB_DADO_ORBITAL.dt_coleta             IS 'Data e hora da coleta pelo satelite';
COMMENT ON COLUMN TB_DADO_ORBITAL.irradiancia_par        IS 'Radiacao fotossinteticamente ativa em W/m2';
COMMENT ON COLUMN TB_DADO_ORBITAL.nebulosidade          IS 'Cobertura de nuvens em percentual (0-100%)';
COMMENT ON COLUMN TB_DADO_ORBITAL.temperatura_ambiente  IS 'Temperatura do ar em graus Celsius';
COMMENT ON COLUMN TB_DADO_ORBITAL.latitude              IS 'Latitude do ponto amostral do satelite';
COMMENT ON COLUMN TB_DADO_ORBITAL.longitude             IS 'Longitude do ponto amostral do satelite';

CREATE TABLE TB_PREVISOES_IA (

    id_previsao         NUMBER(15)      NOT NULL,
    id_tanque           NUMBER(10)      NOT NULL,
    id_dado_orbital     NUMBER(15)      NOT NULL,
    dt_previsao         DATE            DEFAULT SYSDATE NOT NULL,
    biomassa_g_l        NUMBER(8, 4)    NOT NULL,
    dt_pico_previsto    DATE            NOT NULL,
    confianca_pct       NUMBER(5, 2)    NOT NULL,
    modelo_utilizado    VARCHAR2(100)   NOT NULL,

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

COMMENT ON TABLE  TB_PREVISOES_IA                    IS 'Previsoes de producao de biomassa geradas pelo motor de IA';
COMMENT ON COLUMN TB_PREVISOES_IA.id_previsao         IS 'Identificador unico da previsao (PK)';
COMMENT ON COLUMN TB_PREVISOES_IA.id_tanque           IS 'FK para TB_TANQUE — tanque alvo da previsao';
COMMENT ON COLUMN TB_PREVISOES_IA.id_dado_orbital     IS 'FK para TB_DADO_ORBITAL — insumo climatico da IA';
COMMENT ON COLUMN TB_PREVISOES_IA.dt_previsao         IS 'Data de geracao da previsao pelo modelo';
COMMENT ON COLUMN TB_PREVISOES_IA.biomassa_g_l        IS 'Biomassa estimada em g/L';
COMMENT ON COLUMN TB_PREVISOES_IA.dt_pico_previsto    IS 'Data prevista para o pico maximo de producao celular';
COMMENT ON COLUMN TB_PREVISOES_IA.confianca_pct       IS 'Percentual de confianca do modelo de IA (0-100%)';
COMMENT ON COLUMN TB_PREVISOES_IA.modelo_utilizado    IS 'Identificador da versao do modelo de IA (ex: AlgaNet-v2.1)';

CREATE TABLE TB_LOTE_BIOMASSA (

    id_lote             NUMBER(10)      NOT NULL,
    id_fazenda          NUMBER(10)      NOT NULL,
    id_tanque           NUMBER(10)      NOT NULL,
    taxonomia_alga      VARCHAR2(150)   NOT NULL,
    peso_kg             NUMBER(10, 3)   NOT NULL,
    preco_unitario      NUMBER(10, 2)   NOT NULL,
    status              VARCHAR2(15)    DEFAULT 'DISPONIVEL' NOT NULL,
    dt_colheita         DATE            DEFAULT SYSDATE NOT NULL,

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

COMMENT ON TABLE  TB_LOTE_BIOMASSA               IS 'Lotes de biomassa colhidos e disponibilizados no marketplace B2B';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.id_lote        IS 'Identificador unico do lote (PK)';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.id_fazenda     IS 'FK para TB_FAZENDA — fazenda produtora';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.id_tanque      IS 'FK para TB_TANQUE — tanque de origem da colheita';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.taxonomia_alga IS 'Nome cientifico da especie (ex: Chlorella vulgaris)';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.peso_kg        IS 'Peso total do lote colhido em quilogramas';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.preco_unitario IS 'Preco de venda por kg em Reais (R$)';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.status         IS 'Status: DISPONIVEL, RESERVADO, VENDIDO, CANCELADO';
COMMENT ON COLUMN TB_LOTE_BIOMASSA.dt_colheita    IS 'Data de realizacao da colheita';

CREATE TABLE TB_CREDITO_CARBONO (

    id_credito          NUMBER(10)      NOT NULL,
    id_fazenda          NUMBER(10)      NOT NULL,
    id_lote             NUMBER(10)      NOT NULL,
    co2_toneladas       NUMBER(10, 4)   NOT NULL,
    hash_auditoria      VARCHAR2(64)    NOT NULL,
    status              VARCHAR2(15)    DEFAULT 'GERADO' NOT NULL,
    dt_validacao        DATE            NULL,

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

COMMENT ON TABLE  TB_CREDITO_CARBONO               IS 'Creditos de carbono gerados pelo sequestro de CO2 das microalgas';
COMMENT ON COLUMN TB_CREDITO_CARBONO.id_credito     IS 'Identificador unico do credito (PK)';
COMMENT ON COLUMN TB_CREDITO_CARBONO.id_fazenda     IS 'FK para TB_FAZENDA — fazenda geradora do credito';
COMMENT ON COLUMN TB_CREDITO_CARBONO.id_lote        IS 'FK para TB_LOTE_BIOMASSA — lote que originou o credito';
COMMENT ON COLUMN TB_CREDITO_CARBONO.co2_toneladas  IS 'Toneladas de CO2 sequestrado calculadas para o lote';
COMMENT ON COLUMN TB_CREDITO_CARBONO.hash_auditoria IS 'Hash SHA-256 para garantia de integridade e auditoria';
COMMENT ON COLUMN TB_CREDITO_CARBONO.status         IS 'Status: GERADO, VALIDADO, DISPONIVEL, VENDIDO, CANCELADO';
COMMENT ON COLUMN TB_CREDITO_CARBONO.dt_validacao   IS 'Data de validacao por orgao certificador (ex: VERRA, Gold Standard)';


CREATE TABLE TB_TRANSACAO_MARKETPLACE (
    id_transacao        NUMBER(15)      NOT NULL,
    id_usuario_comprador NUMBER(10)     NOT NULL,
    id_lote             NUMBER(10)      NULL,
    id_credito          NUMBER(10)      NULL,
    tipo_transacao      VARCHAR2(25)    NOT NULL,
    quantidade          NUMBER(10, 4)   NOT NULL,
    valor_total         NUMBER(15, 2)   NOT NULL,
    status              VARCHAR2(15)    DEFAULT 'PENDENTE' NOT NULL,
    dt_transacao        TIMESTAMP       DEFAULT SYSTIMESTAMP NOT NULL,

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

COMMENT ON TABLE  TB_TRANSACAO_MARKETPLACE                   IS 'Registro de transacoes de compra e venda no marketplace B2B';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.id_transacao       IS 'Identificador unico da transacao (PK)';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.id_usuario_comprador IS 'FK para TB_USUARIO — comprador da transacao';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.id_lote            IS 'FK para TB_LOTE_BIOMASSA (NULL em transacoes de credito)';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.id_credito         IS 'FK para TB_CREDITO_CARBONO (NULL em transacoes de biomassa)';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.tipo_transacao     IS 'Tipo: COMPRA_BIOMASSA ou COMPRA_CREDITO_CARBONO';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.quantidade         IS 'Quantidade transacionada (kg ou toneladas CO2)';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.valor_total        IS 'Valor financeiro total da transacao em Reais (R$)';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.status             IS 'Status: PENDENTE, CONFIRMADA, CANCELADA, ESTORNADA';
COMMENT ON COLUMN TB_TRANSACAO_MARKETPLACE.dt_transacao       IS 'Timestamp da realizacao da transacao';


CREATE INDEX IDX_USUARIO_EMAIL
    ON TB_USUARIO (email);

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

CREATE INDEX IDX_PREVISAO_TANQUE_DT
    ON TB_PREVISOES_IA (id_tanque, dt_pico_previsto);

CREATE INDEX IDX_LOTE_FAZENDA_STATUS
    ON TB_LOTE_BIOMASSA (id_fazenda, status);

CREATE INDEX IDX_CREDITO_STATUS
    ON TB_CREDITO_CARBONO (status);

CREATE INDEX IDX_CREDITO_FAZENDA
    ON TB_CREDITO_CARBONO (id_fazenda);

CREATE INDEX IDX_TRANSACAO_COMPRADOR
    ON TB_TRANSACAO_MARKETPLACE (id_usuario_comprador);

CREATE INDEX IDX_TRANSACAO_DT
    ON TB_TRANSACAO_MARKETPLACE (dt_transacao DESC);


-- SECAO 4: CONFIRMACAO FINAL

SELECT
    table_name      AS "TABELA",
    num_rows        AS "REGISTROS"
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
        'TB_PREVISOES_IA',
        'TB_LOTE_BIOMASSA',
        'TB_CREDITO_CARBONO',
        'TB_TRANSACAO_MARKETPLACE'
    )
ORDER BY
    table_name;

SELECT
    sequence_name   AS "SEQUENCE",
    min_value       AS "MIN",
    max_value       AS "MAX",
    increment_by    AS "INCREMENT",
    cache_size      AS "CACHE"
FROM
    user_sequences
WHERE
    sequence_name LIKE 'SQ_%'
ORDER BY
    sequence_name;

SELECT
    index_name      AS "INDICE",
    table_name      AS "TABELA",
    uniqueness      AS "TIPO"
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
        'TB_PREVISOES_IA',
        'TB_LOTE_BIOMASSA',
        'TB_CREDITO_CARBONO',
        'TB_TRANSACAO_MARKETPLACE'
    )
ORDER BY
    table_name, index_name;

COMMIT;