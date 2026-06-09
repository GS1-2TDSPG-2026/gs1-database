# 🌿 Phycocarbon — Database Layer

> **FIAP Global Solution 2026/1 — 2TDSPG**
> Disciplina: Mastering Relational and Non-Relational Database

---

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Contexto do Ecossistema](#contexto-do-ecossistema)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Arquitetura do Banco de Dados](#arquitetura-do-banco-de-dados)
- [Modelagem Relacional](#modelagem-relacional)
- [Dicionário de Dados](#dicionário-de-dados)
- [Índices e Performance](#índices-e-performance)
- [Triggers Automáticos](#triggers-automáticos)
- [PL/SQL — Componentes Avançados](#plsql--componentes-avançados)
- [DML — Dados de Seed](#dml--dados-de-seed)
- [Estrutura de Arquivos](#estrutura-de-arquivos)
- [Como Executar](#como-executar)
- [Credenciais de Demonstração](#credenciais-de-demonstração)
- [Segurança](#segurança)
- [Relação com o Tema da Global Solution](#relação-com-o-tema-da-global-solution)

---

## Sobre o Projeto

O **Phycocarbon Database** é a camada de persistência e inteligência de dados da plataforma Phycocarbon — uma solução de bioeconomia que conecta **microalgas, IoT, dados orbitais, inteligência artificial, créditos de carbono e marketplace B2B**.

Este repositório contém toda a modelagem relacional em **Oracle Database** e os scripts PL/SQL avançados, projetados para suportar o ecossistema completo da plataforma.

---

## Contexto do Ecossistema

A plataforma Phycocarbon é composta por múltiplas camadas integradas:

| Camada | Repositório | Descrição |
|---|---|---|
| 📱 Mobile | `gs1-mobile-application` | App React Native (Expo + TypeScript) |
| ☕ Backend Java | `gs1-java-api` | API Spring Boot — negócio e autenticação |
| 🔷 Backend .NET | `gs1-dotnet-api` | API .NET — IoT, telemetria e IA |
| 🗄️ **Database** | **`gs1-database`** | **Oracle Database — este repositório** |

A camada de banco de dados suporta diretamente:
- A **API Java Spring Boot** — para operações de negócio (usuários, fazendas, marketplace, créditos de carbono)
- A **API .NET** — para ingestão de telemetria IoT, alertas e previsões de IA
- O **App Mobile** — consumindo dados via APIs

---

## Tecnologias Utilizadas

| Tecnologia | Versão | Uso |
|---|---|---|
| Oracle Database | 21c+ | Banco relacional principal |
| PL/SQL | Oracle 21c | Procedures, Functions, Triggers, Package, Cursores |
| SQL*Plus / SQLcl | — | Execução dos scripts DDL/DML/PL/SQL |

---

## Arquitetura do Banco de Dados

### Visão Geral

```
┌─────────────────────────────────────────────────────────────────┐
│                    ORACLE DATABASE (Relacional)                  │
│                                                                  │
│  TB_PERFIL ──► TB_USUARIO ──► TB_FAZENDA ──► TB_TANQUE         │
│                                    │              │              │
│                               TB_DADO_ORBITAL  TB_DISPOSITIVO   │
│                               TB_DADO_ORBITAL_BR    │            │
│                                    │          TB_METRICAS_TANQUE │
│                                    │          TB_ALERTA_CRITICO  │
│                               TB_PREVISOES_IA                    │
│                                                                  │
│  TB_FAZENDA ──► TB_LOTE_BIOMASSA ──► TB_CREDITO_CARBONO         │
│                         │                   │                    │
│                    TB_TRANSACAO_MARKETPLACE ◄┘                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## Modelagem Relacional

### Diagrama de Entidade-Relacionamento

```
TB_PERFIL (1) ──────< TB_USUARIO
                          │
               ┌──────────┤
               │          │
           TB_FAZENDA     │
               │          │
        ┌──────┤          │
        │      │          │
   TB_DADO_ORBITAL   TB_TANQUE
   TB_DADO_ORBITAL_BR     │
        │            ┌────┤────────────────┐
        │            │    │                │
   TB_PREVISOES_IA  TB_DISPOSITIVO_IOT  TB_ALERTA_CRITICO
                     │                    │
                TB_METRICAS_TANQUE ───────┘

   TB_FAZENDA ──────< TB_LOTE_BIOMASSA >──── TB_TANQUE
                           │
                    TB_CREDITO_CARBONO
                           │
                    TB_TRANSACAO_MARKETPLACE >─── TB_USUARIO
```

### Normalização

Toda a modelagem foi desenvolvida na **3ª Forma Normal (3FN)**:

- **1FN**: Todos os atributos são atômicos. Sem grupos repetidos.
- **2FN**: Nenhum atributo não-chave depende parcialmente de uma chave composta.
- **3FN**: Nenhum atributo não-chave depende transitivamente de outro atributo não-chave.

---

## Dicionário de Dados

### TB_PERFIL
> Catálogo de perfis de acesso ao sistema Phycocarbon

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_perfil` | NUMBER(5) | PK | Identificador do perfil |
| `nome_perfil` | VARCHAR2(30) | NOT NULL, UNIQUE | Nome do perfil (`ADMIN`, `OPERADOR_CAMPO`, `INVESTIDOR`, `COMPRADOR_B2B`) |
| `descricao` | VARCHAR2(200) | NULL | Descrição do perfil |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Data/hora de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Data/hora de atualização |

---

### TB_USUARIO
> Usuários cadastrados na plataforma

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_usuario` | NUMBER(10) | PK | Identificador do usuário |
| `id_perfil` | NUMBER(5) | FK → TB_PERFIL | Perfil de acesso |
| `nome` | VARCHAR2(100) | NOT NULL | Nome completo |
| `email` | VARCHAR2(150) | NOT NULL, UNIQUE | E-mail (validado com CHECK `LIKE '%@%.%'`) |
| `senha_hash` | VARCHAR2(255) | NOT NULL | Hash BCrypt gerado pela API Java |
| `telefone` | VARCHAR2(20) | NULL | Telefone com DDD |
| `status` | CHAR(1) | DEFAULT 'A' | `A` = Ativo, `I` = Inativo, `B` = Bloqueado |
| `dt_criacao` | DATE | DEFAULT SYSDATE | Data de criação |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_FAZENDA
> Fazendas biológicas de cultivo de microalgas

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_fazenda` | NUMBER(10) | PK | Identificador da fazenda |
| `id_usuario_responsavel` | NUMBER(10) | FK → TB_USUARIO | Operador responsável |
| `nome` | VARCHAR2(100) | NOT NULL | Nome da fazenda |
| `cidade` | VARCHAR2(80) | NOT NULL | Cidade |
| `uf` | CHAR(2) | NOT NULL, CHECK (UPPER, LENGTH=2) | UF em maiúsculas |
| `latitude` | NUMBER(10,7) | CHECK (-90 a 90) | Coordenada geográfica |
| `longitude` | NUMBER(11,7) | CHECK (-180 a 180) | Coordenada geográfica |
| `status` | VARCHAR2(10) | DEFAULT 'ATIVA' | `ATIVA`, `INATIVA`, `SUSPENSA` |
| `dt_cadastro` | DATE | DEFAULT SYSDATE | Data de cadastro |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_TANQUE
> Tanques/biofotorreatores de cultivo de microalgas

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_tanque` | NUMBER(10) | PK | Identificador do tanque |
| `id_fazenda` | NUMBER(10) | FK → TB_FAZENDA | Fazenda proprietária |
| `codigo_tanque` | VARCHAR2(20) | UNIQUE por fazenda | Código do tanque |
| `tipo_alga` | VARCHAR2(100) | NOT NULL | Taxonomia da espécie cultivada |
| `capacidade_litros` | NUMBER(10,2) | CHECK (> 0) | Volume em litros |
| `ph_min` | NUMBER(4,2) | CHECK (0-14, min < max) | pH mínimo ideal |
| `ph_max` | NUMBER(4,2) | CHECK (0-14, min < max) | pH máximo ideal |
| `temperatura_min` | NUMBER(5,2) | CHECK (min < max) | Temperatura mínima ideal em °C |
| `temperatura_max` | NUMBER(5,2) | CHECK (min < max) | Temperatura máxima ideal em °C |
| `status` | VARCHAR2(15) | DEFAULT 'ATIVO' | `ATIVO`, `INATIVO`, `MANUTENCAO`, `COLHEITA` |
| `dt_instalacao` | DATE | DEFAULT SYSDATE | Data de instalação |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_DISPOSITIVO_IOT
> Dispositivos ESP32 instalados nos tanques

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_dispositivo` | NUMBER(10) | PK | Identificador do dispositivo |
| `id_tanque` | NUMBER(10) | FK → TB_TANQUE | Tanque monitorado |
| `codigo_serie` | VARCHAR2(50) | UNIQUE | Número de série do hardware |
| `topico_mqtt` | VARCHAR2(200) | UNIQUE | Tópico MQTT para comunicação |
| `modelo` | VARCHAR2(50) | NULL | Modelo do dispositivo |
| `ativo` | CHAR(1) | DEFAULT 'S' | `S` = Ativo, `N` = Inativo |
| `dt_instalacao` | DATE | DEFAULT SYSDATE | Data de instalação |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_METRICAS_TANQUE
> Série temporal de leituras IoT dos sensores

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_metrica` | NUMBER(15) | PK | Identificador da métrica |
| `id_dispositivo` | NUMBER(10) | FK → TB_DISPOSITIVO_IOT | Dispositivo que gerou a leitura |
| `id_tanque` | NUMBER(10) | FK → TB_TANQUE | Tanque monitorado |
| `dt_leitura` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp da coleta |
| `ph` | NUMBER(5,2) | CHECK (0-14) | pH da solução |
| `temperatura` | NUMBER(6,2) | CHECK (-10 a 100) | Temperatura em °C |
| `turbidez` | NUMBER(8,3) | CHECK (>= 0) | Turbidez em NTU |
| `luminosidade` | NUMBER(10,2) | CHECK (>= 0) | Luminosidade em lux |
| `payload_original` | VARCHAR2(4000) | NULL | JSON bruto enviado pelo ESP32 via MQTT |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_ALERTA_CRITICO
> Alertas automáticos gerados quando métricas saem dos limites

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_alerta` | NUMBER(15) | PK | Identificador do alerta |
| `id_metrica` | NUMBER(15) | FK → TB_METRICAS_TANQUE | Métrica que originou o alerta |
| `id_tanque` | NUMBER(10) | FK → TB_TANQUE | Tanque do alerta |
| `tipo_alerta` | VARCHAR2(30) | NOT NULL | `PH_CRITICO`, `PH_ALTO`, `PH_BAIXO`, `TEMPERATURA_ALTA`, `TEMPERATURA_BAIXA`, `TURBIDEZ_FORA_PADRAO`, `LUMINOSIDADE_BAIXA` |
| `severidade` | VARCHAR2(10) | NOT NULL | `BAIXA`, `MEDIA`, `ALTA`, `CRITICA` |
| `mensagem` | VARCHAR2(500) | NOT NULL | Descrição do alerta |
| `status` | VARCHAR2(15) | DEFAULT 'ABERTO' | `ABERTO`, `EM_ANALISE`, `RESOLVIDO`, `IGNORADO` |
| `dt_alerta` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp do alerta |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_DADO_ORBITAL
> Dados de radiação e clima via fontes orbitais/meteorológicas

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_dado_orbital` | NUMBER(15) | PK | Identificador do dado orbital |
| `id_fazenda` | NUMBER(10) | FK → TB_FAZENDA | Fazenda de referência |
| `fonte` | VARCHAR2(30) | NOT NULL | `NASA_POWER`, `COPERNICUS`, `INPE`, `GOES_16`, `OPEN_METEO`, `ERA5_ARCHIVE` |
| `dt_coleta` | DATE | NOT NULL | Data da coleta |
| `irradiancia_par` | NUMBER(8,3) | CHECK (>= 0) | Irradiância PAR em µmol/m²/s |
| `nebulosidade` | NUMBER(5,2) | CHECK (0-100) | Percentual de cobertura de nuvens |
| `temperatura_ambiente` | NUMBER(6,2) | NULL | Temperatura externa em °C |
| `latitude` | NUMBER(10,7) | CHECK (-90 a 90) | Coordenada geográfica |
| `longitude` | NUMBER(11,7) | CHECK (-180 a 180) | Coordenada geográfica |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_DADO_ORBITAL_BR
> Dados meteorológicos de estações INMET brasileiras

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_dado_orbital_br` | NUMBER(15) | PK | Identificador do registro |
| `cod_estacao` | VARCHAR2(10) | NOT NULL | Código da estação INMET |
| `nome_estacao` | VARCHAR2(100) | NULL | Nome da estação |
| `dt_medicao` | VARCHAR2(10) | NOT NULL | Data da medição |
| `hr_medicao` | VARCHAR2(4) | NULL | Hora da medição |
| `temp_maxima` | NUMBER(6,2) | NULL | Temperatura máxima em °C |
| `temp_minima` | NUMBER(6,2) | NULL | Temperatura mínima em °C |
| `temp_media` | NUMBER(6,2) | NULL | Temperatura média em °C |
| `umidade_relativa` | NUMBER(6,2) | NULL | Umidade relativa do ar em % |
| `precipitacao` | NUMBER(8,2) | NULL | Precipitação em mm |
| `velocidade_vento` | NUMBER(6,2) | NULL | Velocidade do vento em m/s |
| `direcao_vento` | NUMBER(6,2) | NULL | Direção do vento em graus |
| `pressao_atm` | NUMBER(8,2) | NULL | Pressão atmosférica em hPa |
| `radiacao_global` | NUMBER(10,2) | NULL | Radiação global em kJ/m² |
| `json_original` | CLOB | NULL | Payload bruto da API INMET |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

> Constraint UNIQUE em `(cod_estacao, dt_medicao, hr_medicao)` — impede duplicidade de leitura por estação/data/hora.

---

### TB_PREVISOES_IA
> Previsões de produção de biomassa geradas pelo motor de IA

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_previsao` | NUMBER(15) | PK | Identificador da previsão |
| `id_tanque` | NUMBER(10) | FK → TB_TANQUE | Tanque previsto |
| `id_dado_orbital` | NUMBER(15) | FK → TB_DADO_ORBITAL | Dado orbital que embasou a previsão |
| `dt_previsao` | DATE | DEFAULT SYSDATE | Data em que a previsão foi gerada |
| `biomassa_g_l` | NUMBER(8,4) | CHECK (> 0) | Biomassa prevista em g/L |
| `dt_pico_previsto` | DATE | NOT NULL, CHECK (>= dt_previsao) | Data estimada de pico de produção |
| `confianca_pct` | NUMBER(5,2) | CHECK (0-100) | Confiança do modelo em % |
| `modelo_utilizado` | VARCHAR2(100) | NOT NULL | Identificação do modelo de IA usado |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_LOTE_BIOMASSA
> Lotes de biomassa colhidos disponíveis no marketplace B2B

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_lote` | NUMBER(10) | PK | Identificador do lote |
| `id_fazenda` | NUMBER(10) | FK → TB_FAZENDA | Fazenda de origem |
| `id_tanque` | NUMBER(10) | FK → TB_TANQUE | Tanque de origem |
| `taxonomia_alga` | VARCHAR2(150) | NOT NULL | Taxonomia científica da espécie |
| `peso_kg` | NUMBER(10,3) | CHECK (> 0) | Peso do lote em kg |
| `preco_unitario` | NUMBER(10,2) | CHECK (> 0) | Preço por kg em R$ |
| `status` | VARCHAR2(15) | DEFAULT 'DISPONIVEL' | `DISPONIVEL`, `RESERVADO`, `VENDIDO`, `CANCELADO` |
| `dt_colheita` | DATE | DEFAULT SYSDATE | Data da colheita |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_CREDITO_CARBONO
> Créditos de carbono gerados pelo sequestro de CO₂ das microalgas

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_credito` | NUMBER(10) | PK | Identificador do crédito |
| `id_fazenda` | NUMBER(10) | FK → TB_FAZENDA | Fazenda geradora |
| `id_lote` | NUMBER(10) | FK → TB_LOTE_BIOMASSA | Lote de biomassa correspondente |
| `co2_toneladas` | NUMBER(10,4) | CHECK (> 0) | CO₂ sequestrado em toneladas |
| `hash_auditoria` | VARCHAR2(64) | UNIQUE, NOT NULL | Hash criptográfico para rastreabilidade |
| `status` | VARCHAR2(15) | DEFAULT 'GERADO' | `GERADO`, `VALIDADO`, `DISPONIVEL`, `VENDIDO`, `CANCELADO` |
| `dt_validacao` | DATE | NULL | Data da validação pelo auditor |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

---

### TB_TRANSACAO_MARKETPLACE
> Registro de compras e vendas no marketplace B2B

| Coluna | Tipo | Constraint | Descrição |
|---|---|---|---|
| `id_transacao` | NUMBER(15) | PK | Identificador da transação |
| `id_usuario_comprador` | NUMBER(10) | FK → TB_USUARIO | Usuário comprador |
| `id_lote` | NUMBER(10) | FK → TB_LOTE_BIOMASSA | Lote de biomassa (exclusivo com id_credito) |
| `id_credito` | NUMBER(10) | FK → TB_CREDITO_CARBONO | Crédito de carbono (exclusivo com id_lote) |
| `tipo_transacao` | VARCHAR2(25) | NOT NULL | `COMPRA_BIOMASSA`, `COMPRA_CREDITO_CARBONO` |
| `quantidade` | NUMBER(10,4) | CHECK (> 0) | Quantidade transacionada |
| `valor_total` | NUMBER(15,2) | CHECK (> 0) | Valor total em R$ |
| `status` | VARCHAR2(15) | DEFAULT 'PENDENTE' | `PENDENTE`, `CONFIRMADA`, `CANCELADA`, `ESTORNADA` |
| `dt_transacao` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp da transação |
| `criado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de criação |
| `atualizado_em` | TIMESTAMP | DEFAULT SYSTIMESTAMP | Timestamp de atualização |

> **Integridade**: A constraint `CK_TRANSACAO_OBJETO` garante que cada transação pertence **exclusivamente** a um lote de biomassa **ou** a um crédito de carbono — nunca ambos e nunca nenhum.

---

## Índices e Performance

O banco possui **22 índices** estratégicos além das PKs e UQs:

| Índice | Tabela | Colunas | Justificativa |
|---|---|---|---|
| `IDX_USUARIO_PERFIL` | TB_USUARIO | `(id_perfil)` | Filtro de usuários por perfil |
| `IDX_FAZENDA_RESPONSAVEL` | TB_FAZENDA | `(id_usuario_responsavel)` | Fazendas por operador responsável |
| `IDX_FAZENDA_UF` | TB_FAZENDA | `(uf)` | Filtro geográfico por estado |
| `IDX_TANQUE_FAZENDA` | TB_TANQUE | `(id_fazenda)` | Tanques por fazenda |
| `IDX_TANQUE_STATUS` | TB_TANQUE | `(status)` | Tanques ativos/em manutenção |
| `IDX_DISPOSITIVO_TANQUE` | TB_DISPOSITIVO_IOT | `(id_tanque)` | Dispositivos por tanque |
| `IDX_METRICA_TANQUE_DT` | TB_METRICAS_TANQUE | `(id_tanque, dt_leitura DESC)` | **Query mais crítica**: últimas leituras por tanque |
| `IDX_METRICA_DISPOSITIVO` | TB_METRICAS_TANQUE | `(id_dispositivo)` | Leituras por dispositivo ESP32 |
| `IDX_ALERTA_TANQUE_STATUS` | TB_ALERTA_CRITICO | `(id_tanque, status)` | Alertas abertos por tanque — dashboard |
| `IDX_ALERTA_DT` | TB_ALERTA_CRITICO | `(dt_alerta DESC)` | Alertas mais recentes |
| `IDX_DADO_ORBITAL_FAZENDA_DT` | TB_DADO_ORBITAL | `(id_fazenda, dt_coleta DESC)` | Dados orbitais por fazenda e período |
| `IDX_DADO_ORBITAL_FONTE` | TB_DADO_ORBITAL | `(fonte)` | Filtro por fonte orbital |
| `IDX_DADO_ORBITAL_BR_ESTACAO_DT` | TB_DADO_ORBITAL_BR | `(cod_estacao, dt_medicao DESC, hr_medicao DESC)` | Série temporal INMET |
| `IDX_PREVISAO_TANQUE_DT` | TB_PREVISOES_IA | `(id_tanque, dt_pico_previsto)` | Previsões futuras por tanque |
| `IDX_PREVISAO_DADO_ORBITAL` | TB_PREVISOES_IA | `(id_dado_orbital)` | Rastreabilidade da previsão → dado orbital |
| `IDX_LOTE_FAZENDA_STATUS` | TB_LOTE_BIOMASSA | `(id_fazenda, status)` | Lotes disponíveis por fazenda |
| `IDX_LOTE_TANQUE` | TB_LOTE_BIOMASSA | `(id_tanque)` | Lotes por tanque de origem |
| `IDX_CREDITO_STATUS` | TB_CREDITO_CARBONO | `(status)` | Créditos disponíveis para venda |
| `IDX_CREDITO_FAZENDA` | TB_CREDITO_CARBONO | `(id_fazenda)` | Créditos por fazenda |
| `IDX_CREDITO_LOTE` | TB_CREDITO_CARBONO | `(id_lote)` | Crédito → lote de biomassa |
| `IDX_TRANSACAO_COMPRADOR` | TB_TRANSACAO_MARKETPLACE | `(id_usuario_comprador)` | Histórico por comprador |
| `IDX_TRANSACAO_DT` | TB_TRANSACAO_MARKETPLACE | `(dt_transacao DESC)` | Transações mais recentes |

---

## Triggers Automáticos

**13 triggers BEFORE INSERT** (padrão `TRG_BI_TB_*`) garantem geração automática de IDs via sequences:

```sql
-- Padrão aplicado a todas as tabelas
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
```

| Trigger | Tabela | Sequence | Cache |
|---|---|---|---|
| TRG_BI_TB_PERFIL | TB_PERFIL | SQ_PERFIL | NOCACHE |
| TRG_BI_TB_USUARIO | TB_USUARIO | SQ_USUARIO | 20 |
| TRG_BI_TB_FAZENDA | TB_FAZENDA | SQ_FAZENDA | 20 |
| TRG_BI_TB_TANQUE | TB_TANQUE | SQ_TANQUE | 20 |
| TRG_BI_TB_DISPOSITIVO_IOT | TB_DISPOSITIVO_IOT | SQ_DISPOSITIVO_IOT | 20 |
| TRG_BI_TB_METRICAS_TANQUE | TB_METRICAS_TANQUE | SQ_METRICAS_TANQUE | **100** |
| TRG_BI_TB_ALERTA_CRITICO | TB_ALERTA_CRITICO | SQ_ALERTA_CRITICO | 20 |
| TRG_BI_TB_DADO_ORBITAL | TB_DADO_ORBITAL | SQ_DADO_ORBITAL | 20 |
| TRG_BI_TB_DADO_ORBITAL_BR | TB_DADO_ORBITAL_BR | SQ_DADO_ORBITAL_BR | 20 |
| TRG_BI_TB_PREVISOES_IA | TB_PREVISOES_IA | SQ_PREVISOES_IA | 20 |
| TRG_BI_TB_LOTE_BIOMASSA | TB_LOTE_BIOMASSA | SQ_LOTE_BIOMASSA | 20 |
| TRG_BI_TB_CREDITO_CARBONO | TB_CREDITO_CARBONO | SQ_CREDITO_CARBONO | 20 |
| TRG_BI_TB_TRANSACAO_MARKETPLACE | TB_TRANSACAO_MARKETPLACE | SQ_TRANSACAO_MARKETPLACE | 20 |

> `SQ_METRICAS_TANQUE` usa `CACHE 100` por ser a sequence de maior demanda — leituras de sensores enviadas continuamente via IoT.

---

## PL/SQL — Componentes Avançados

O arquivo `GS_Phycocarbon_PLSQL.sql` contém **7 seções** de componentes avançados:

### Seção 1 — Blocos Anônimos

| Bloco | Descrição |
|---|---|
| **Bloco 1** | Consulta de status de um tanque pelo ID com classificação por porte (PEQUENO/MÉDIO/GRANDE) |
| **Bloco 2** | Verificação de alertas críticos abertos por tanque com escalonamento (NORMAL/ATENÇÃO/CRÍTICO/EMERGÊNCIA) |
| **Bloco 3** | Cálculo do valor total de vendas de biomassa por fazenda com classificação de desempenho |
| **Bloco 4** | Monitoramento de métricas do último dia com `WHILE LOOP` |

### Seção 2 — Cursores Explícitos

| Cursor | Descrição |
|---|---|
| `c_tanques_ativos` | Lista todos os tanques ativos com seus dispositivos IoT |
| `c_alertas_abertos` | Lista alertas abertos com dados do tanque e fazenda |
| `c_marketplace` | Lista lotes disponíveis no marketplace com valor estimado |
| `c_usuarios` | Lista usuários por perfil com contagem de fazendas responsáveis |

### Seção 3 — Relatórios SQL com JOIN

Queries complexas utilizando `INNER JOIN`, `LEFT JOIN`, `GROUP BY`, `HAVING`, funções analíticas e agregações para geração de relatórios gerenciais.

### Seção 4 — Function

```sql
-- Calcula o índice de saúde de um tanque (0 a 100)
CREATE OR REPLACE FUNCTION FN_CALCULA_SAUDE_TANQUE (
    p_id_tanque IN NUMBER
) RETURN NUMBER
```

Retorna score de saúde baseado nas métricas recentes, desvios de pH e temperatura, e alertas ativos.

### Seção 5 — Procedure

```sql
-- Gera relatório consolidado de uma fazenda via DBMS_OUTPUT
CREATE OR REPLACE PROCEDURE PRC_GERA_RELATORIO_FAZENDA (
    p_id_fazenda IN NUMBER
)
```

Exibe informações completas da fazenda: tanques, métricas recentes e alertas ativos.

### Seção 6 — Trigger de Negócio

Trigger adicional de negócio (além dos triggers de ID automático) que aplica regras de validação e auditoria em operações DML.

### Seção 7 — Package `PKG_PHYCOCARBON`

```sql
CREATE OR REPLACE PACKAGE PKG_PHYCOCARBON AS
    FUNCTION  FN_SAUDE_TANQUE       (p_id_tanque  IN NUMBER) RETURN NUMBER;
    FUNCTION  FN_CONTAR_ALERTAS     (p_id_tanque  IN NUMBER) RETURN NUMBER;
    PROCEDURE PRC_RELATORIO_FAZENDA (p_id_fazenda IN NUMBER);
    PROCEDURE PRC_RESUMO_PLATAFORMA;
END PKG_PHYCOCARBON;
/
```

O package centraliza os objetos PL/SQL mais reutilizáveis, seguindo o padrão de encapsulamento Oracle.

---

## DML — Dados de Seed

O arquivo `GS_Phycocarbon_DML.sql` popula o banco com dados realistas para demonstração acadêmica:

| Tabela | Conteúdo |
|---|---|
| TB_PERFIL | 4 perfis (`ADMIN`, `OPERADOR_CAMPO`, `INVESTIDOR`, `COMPRADOR_B2B`) |
| TB_USUARIO | 15+ usuários distribuídos entre os perfis |
| TB_FAZENDA | Fazendas nos estados BA, CE, RJ, GO, SP |
| TB_TANQUE | Tanques com diferentes espécies de microalgas e faixas de operação |
| TB_DISPOSITIVO_IOT | Dispositivos ESP32 com código de série e tópicos MQTT |
| TB_METRICAS_TANQUE | Leituras com variações realistas de pH, temperatura, turbidez e luminosidade |
| TB_ALERTA_CRITICO | Alertas com diferentes severidades e status |
| TB_DADO_ORBITAL | Dados de NASA POWER, Copernicus, INPE, GOES-16 |
| TB_DADO_ORBITAL_BR | Dados de estações INMET brasileiras |
| TB_PREVISOES_IA | Previsões de biomassa com diferentes modelos de IA |
| TB_LOTE_BIOMASSA | Lotes em diferentes status do marketplace |
| TB_CREDITO_CARBONO | Créditos com hash de auditoria único |
| TB_TRANSACAO_MARKETPLACE | Transações confirmadas, pendentes e canceladas |

---

## Estrutura de Arquivos

```
gs1-database-main/
│
├── GS_Phycocarbon_DDL.sql        # Data Definition Language
│   ├── Seção 0: Limpeza do ambiente (DROP tables e sequences)
│   ├── Seção 1: Sequences (13 sequences)
│   ├── Seção 2: Tabelas (13 tabelas com constraints)
│   ├── Seção 3: Triggers de IDs automáticos (13 triggers)
│   ├── Seção 4: Comments nas tabelas
│   ├── Seção 5: Índices (22 índices de performance)
│   └── Seção 6: Queries de confirmação
│
├── GS_Phycocarbon_DML.sql        # Data Manipulation Language (seed data)
│   ├── Seção 1:  TB_PERFIL
│   ├── Seção 2:  TB_USUARIO
│   ├── Seção 3:  TB_FAZENDA
│   ├── Seção 4:  TB_TANQUE
│   ├── Seção 5:  TB_DISPOSITIVO_IOT
│   ├── Seção 6:  TB_METRICAS_TANQUE
│   ├── Seção 7:  TB_ALERTA_CRITICO
│   ├── Seção 8:  TB_DADO_ORBITAL
│   ├── Seção 9:  TB_DADO_ORBITAL_BR
│   ├── Seção 10: TB_PREVISOES_IA
│   ├── Seção 11: TB_LOTE_BIOMASSA
│   ├── Seção 12: TB_CREDITO_CARBONO
│   └── Seção 13: TB_TRANSACAO_MARKETPLACE
│
├── GS_Phycocarbon_PLSQL.sql      # PL/SQL avançado
│   ├── Seção 1: Blocos anônimos (4 blocos)
│   ├── Seção 2: Cursores explícitos (4 cursores)
│   ├── Seção 3: Relatórios SQL com JOIN
│   ├── Seção 4: Function FN_CALCULA_SAUDE_TANQUE
│   ├── Seção 5: Procedure PRC_GERA_RELATORIO_FAZENDA
│   ├── Seção 6: Trigger de negócio
│   └── Seção 7: Package PKG_PHYCOCARBON
│
├── GS_Phycocarbon_DER.pdf        # Diagrama Entidade-Relacionamento
│
└── LICENSE                       # Licença do projeto
```

---

## Como Executar

### Pré-requisitos

- Oracle Database 21c+ (ou Oracle Live SQL / Oracle 19c)
- SQL*Plus ou SQLcl instalado
- Usuário Oracle com permissões para `CREATE TABLE`, `CREATE SEQUENCE`, `CREATE TRIGGER`, `CREATE INDEX`, `CREATE PROCEDURE`, `CREATE FUNCTION`, `CREATE PACKAGE`

### Passo a Passo

**1. Conectar ao banco Oracle:**
```bash
sqlplus seu_usuario/sua_senha@seu_host:1521/XEPDB1
```

**2. Executar o DDL (criação da estrutura):**
```sql
@GS_Phycocarbon_DDL.sql
```
> O DDL já inclui limpeza automática na Seção 0 — pode ser reexecutado com segurança em ambiente de desenvolvimento.

**3. Executar o DML (dados de seed):**
```sql
@GS_Phycocarbon_DML.sql
```

**4. Executar os objetos PL/SQL:**
```sql
SET SERVEROUTPUT ON
@GS_Phycocarbon_PLSQL.sql
```

### Verificação Pós-Instalação

Após executar o DDL, as queries de verificação da Seção 6 exibirão automaticamente:
- Lista de tabelas criadas
- Sequences configuradas
- Triggers ativos
- Índices criados

---

## Credenciais de Demonstração

> ⚠️ Credenciais exclusivamente para fins acadêmicos.

As senhas abaixo correspondem aos hashes BCrypt inseridos pelo DML. A autenticação real é realizada via **API Java Spring Boot** — o banco armazena apenas o hash, nunca a senha em texto puro.

| Perfil | E-mail | Senha | Nome |
|---|---|---|---|
| ADMIN | rafael.monteiro@algaspace.com | `Admin@2026` | Rafael Monteiro Silva |
| ADMIN | priscila.tavares@algaspace.com | `Usuario@2026` | Priscila Tavares Nunes |
| OPERADOR_CAMPO | joao.almeida@algaspace.com | `Operador@2026` | João Pedro Almeida |
| OPERADOR_CAMPO | mariana.ferreira@algaspace.com | `Usuario@2026` | Mariana Costa Ferreira |
| OPERADOR_CAMPO | carlos.rocha@algaspace.com | `Usuario@2026` | Carlos Eduardo Rocha |
| INVESTIDOR | contato@biocapital.com.br | `Investidor@2026` | Grupo BioCapital |
| INVESTIDOR | gestora@sustentafundo.com.br | `Usuario@2026` | SustentaFundo Gestora |
| COMPRADOR_B2B | compras@nutrialga.com.br | `Comprador@2026` | NutriAlga Alimentos SA |
| COMPRADOR_B2B | suprimentos@farmaverde.com.br | `Usuario@2026` | FarmaVerde Biotecnologia |

---

## Segurança

### Medidas Implementadas no Banco

| Área | Medida |
|---|---|
| **Senhas** | Armazenadas como hash BCrypt — nunca em texto puro |
| **E-mail** | Constraint `CHECK (email LIKE '%@%.%')` — validação básica no banco |
| **Status de usuário** | `CHECK IN ('A','I','B')` — bloqueio imediato sem DELETE de registro |
| **Hash de auditoria** | `hash_auditoria VARCHAR2(64) UNIQUE` — rastreabilidade de créditos de carbono |
| **Integridade referencial** | `CASCADE CONSTRAINTS` aplicado em todas as FKs |
| **Transações** | `CK_TRANSACAO_OBJETO` previne transação sem objeto associado |
| **Coordenadas geográficas** | CHECK em latitude e longitude impede valores fisicamente impossíveis |
| **SQL Injection** | Objetos PL/SQL usam bind variables (`:NEW`, parâmetros `IN`) — sem concatenação direta |
| **Separação de perfis** | Perfis distintos por papel (`ADMIN`, `OPERADOR_CAMPO`, `INVESTIDOR`, `COMPRADOR_B2B`) |

### Boas Práticas para Produção

- Habilitar **Oracle Unified Auditing** para todas as tabelas sensíveis
- Aplicar **VPD (Virtual Private Database)** para isolar dados de fazenda por perfil
- Usar **Oracle TDE (Transparent Data Encryption)** nas colunas `senha_hash` e `hash_auditoria`
- Implementar **connection pooling** na camada de API (nunca conexão direta do mobile ao banco)
- Rotação periódica das credenciais de serviço das APIs

---

## Relação com o Tema da Global Solution

O projeto se conecta ao tema **"O Espaço é a nova fronteira"** por incorporar dados orbitais e satelitais como insumo direto para decisões operacionais no cultivo de microalgas.

No banco de dados Oracle, isso se materializa em:

| Tabela | Conexão Espacial |
|---|---|
| `TB_DADO_ORBITAL` | Armazena dados de NASA POWER, Copernicus, GOES-16 e INPE — irradiância PAR e nebulosidade via satélite |
| `TB_DADO_ORBITAL_BR` | Complemento meteorológico terrestre via estações INMET |
| `TB_PREVISOES_IA` | FK para `id_dado_orbital` — previsões de biomassa alimentadas diretamente por dados espaciais |
| `TB_METRICAS_TANQUE` | Série temporal que correlaciona condições orbitais com métricas dos tanques |

A arquitetura de dados reflete que **dados do espaço (satélites) alimentam a inteligência artificial**, que por sua vez orienta as decisões dos operadores de fazenda na plataforma.

---

## Integrantes do Grupo

| Nome | RM | Turma |
|---|---|---|
| *Alexander Dennis Isidro* | *RM565554* | 2TDSPG |
| *Arthur Brito da Silva* | *RM562085* | 2TDSPG |
| *Kelson Zhang* | *RM563748* | 2TDSPG |
| *Luiz Felipe Flosi* | *RM563197* | 2TDSPG |
| *Pedro Henrique Brum Lopes* | *RM561780* | 2TDSPG |

---

## Licença

Projeto desenvolvido exclusivamente para fins acadêmicos — **FIAP Global Solution 2026/1**.