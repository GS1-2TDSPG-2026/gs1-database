-- PROJETO: Phycocarbon — Plataforma de Monitoramento de Microalgas
-- DISCIPLINA: Mastering Relational and Non-Relational Database
-- FIAP Global Solution 2026 | 2TDSPG

SET SERVEROUTPUT ON;
SET DEFINE OFF;

-- SECAO 1: TB_PERFIL

INSERT INTO TB_PERFIL (nome_perfil, descricao)
VALUES ('ADMIN',
        'Administrador com acesso total ao sistema, gestao de usuarios e configuracoes');

INSERT INTO TB_PERFIL (nome_perfil, descricao)
VALUES ('OPERADOR_CAMPO',
        'Operador responsavel pelo monitoramento diario dos tanques e colheitas em campo');

INSERT INTO TB_PERFIL (nome_perfil, descricao)
VALUES ('INVESTIDOR',
        'Investidor com acesso a dashboards de producao, previsoes de IA e relatorios financeiros');

INSERT INTO TB_PERFIL (nome_perfil, descricao)
VALUES ('COMPRADOR_B2B',
        'Comprador corporativo com acesso ao marketplace de biomassa e creditos de carbono');

-- SECAO 2: TB_USUARIO
-- Credenciais academicas de demonstracao:
-- ADMIN:       rafael.monteiro@algaspace.com   / Admin@2026
-- OPERADOR:    joao.almeida@algaspace.com      / Operador@2026
-- INVESTIDOR:  contato@biocapital.com.br       / Investidor@2026
-- COMPRADOR:   compras@nutrialga.com.br        / Comprador@2026
-- DEMAIS:      Usuario@2026
--
-- Observacao:
-- Os hashes abaixo foram gerados com BCryptPasswordEncoder na API Java.
-- Em ambiente real, usuarios devem ser cadastrados pela API, nao diretamente por DML.

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (1, 'Rafael Monteiro Silva',
        'rafael.monteiro@algaspace.com',
        '$2a$10$O2F5h6JYq4WZnahO5HlbNOxEA4ZspvOyHK7lCWOHDEygzCLR/oGQG',
        '+5511999870001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (1, 'Priscila Tavares Nunes',
        'priscila.tavares@algaspace.com',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5511999870002', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (2, 'Joao Pedro Almeida',
        'joao.almeida@algaspace.com',
        '$2a$10$RK4by1ppcImL5z6l.khK0u/Gb/LUAWRsrBWxEjpEWEpmshIMx9UWG',
        '+5571988650001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (2, 'Mariana Costa Ferreira',
        'mariana.ferreira@algaspace.com',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5585997340001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (2, 'Carlos Eduardo Rocha',
        'carlos.rocha@algaspace.com',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5521998760001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (2, 'Fernanda Lima Souza',
        'fernanda.lima@algaspace.com',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5562987230001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (3, 'Grupo BioCapital Investimentos',
        'contato@biocapital.com.br',
        '$2a$10$PJzHEEMZf9pMmM12BbWle.Y.9D5SSW.m7KttQXOvPuPyPFFN1J4j2',
        '+5511999340001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (3, 'SustentaFundo Gestora',
        'gestora@sustentafundo.com.br',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5511999340002', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (3, 'Instituto Verde Horizonte',
        'diretoria@verdehorizonte.org',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5531988450001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (4, 'NutriAlga Alimentos SA',
        'compras@nutrialga.com.br',
        '$2a$10$CV/WH4kRFnLOGIRYTU78ROe52tPDEO5IalvO7saIudwoqOujGYxRq',
        '+5511999110001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (4, 'FarmaVerde Biotecnologia',
        'suprimentos@farmaverde.com.br',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5541988220001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (4, 'CarbonCredit Brasil Ltda',
        'operacoes@carboncredit.com.br',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5511999110002', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (4, 'OceanBio Exportacoes',
        'importacao@oceanbio.com.br',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5511999110003', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (4, 'AquaFeed Nutricao Animal',
        'compras@aquafeed.agr.br',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5519988330001', 'A');

INSERT INTO TB_USUARIO (id_perfil, nome, email, senha_hash, telefone, status)
VALUES (2, 'Thiago Barbosa Mendes',
        'thiago.barbosa@algaspace.com',
        '$2a$10$vf29Q3/eMgPUnghDWuZrp.Ydm9xtx6G8vBXiWqmVyHdmKkeXaU.qm',
        '+5548997870001', 'I');

-- SECAO 3: TB_FAZENDA

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (3, 'Fazenda AlgaSol Nordeste', 'Mossoró', 'RN', -5.1877, -37.3438, 'ATIVA');

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (3, 'Estacao Biologica Litoral RN', 'Natal', 'RN', -5.7945, -35.2110, 'ATIVA');

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (4, 'AlgaCeara BioParque', 'Fortaleza', 'CE', -3.7172, -38.5433, 'ATIVA');

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (4, 'Complexo Aquatico Serra da Ibiapaba', 'Tianguá', 'CE', -3.7272, -40.9916, 'ATIVA');

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (5, 'BioReator Sudeste SP', 'Piracicaba', 'SP', -22.7253, -47.6492, 'ATIVA');

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (5, 'Polo AlgaTec Campinas', 'Campinas', 'SP', -22.9099, -47.0626, 'ATIVA');

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (6, 'Centro de Cultivo Centro-Oeste', 'Goiania', 'GO', -16.6869, -49.2648, 'ATIVA');

INSERT INTO TB_FAZENDA (id_usuario_responsavel, nome, cidade, uf, latitude, longitude, status)
VALUES (6, 'Reserva Biologica Pantanal MS', 'Corumbá', 'MS', -19.0078, -57.6547, 'INATIVA');

-- SECAO 4: TB_TANQUE

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (1, 'TQ-001', 'Spirulina platensis', 5000, 8.50, 10.50, 30.0, 38.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (1, 'TQ-002', 'Spirulina platensis', 8000, 8.50, 10.50, 30.0, 38.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (1, 'TQ-003', 'Arthrospira maxima', 3000, 8.00, 11.00, 28.0, 35.0, 'MANUTENCAO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (2, 'TQ-001', 'Chlorella vulgaris', 10000, 6.50, 8.50, 20.0, 30.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (2, 'TQ-002', 'Chlorella vulgaris', 10000, 6.50, 8.50, 20.0, 30.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (3, 'BF-001', 'Nannochloropsis oceanica', 2000, 7.00, 9.00, 18.0, 28.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (3, 'BF-002', 'Haematococcus pluvialis', 1500, 6.00, 8.00, 20.0, 25.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (3, 'BF-003', 'Dunaliella salina', 4000, 7.50, 9.50, 25.0, 35.0, 'COLHEITA');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (4, 'TQ-001', 'Spirulina platensis', 6000, 8.50, 10.50, 30.0, 38.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (5, 'BR-001', 'Chlorella vulgaris', 15000, 6.50, 8.50, 18.0, 28.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (5, 'BR-002', 'Nannochloropsis oceanica', 12000, 7.00, 9.00, 18.0, 28.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (6, 'AT-001', 'Haematococcus pluvialis', 3000, 6.00, 8.00, 20.0, 25.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (6, 'AT-002', 'Dunaliella salina', 5000, 7.50, 9.50, 25.0, 35.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (6, 'AT-003', 'Spirulina platensis', 7000, 8.50, 10.50, 30.0, 38.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (7, 'TQ-001', 'Chlorella vulgaris', 8000, 6.50, 8.50, 20.0, 30.0, 'ATIVO');

INSERT INTO TB_TANQUE (id_fazenda, codigo_tanque, tipo_alga, capacidade_litros, ph_min, ph_max, temperatura_min, temperatura_max, status)
VALUES (7, 'TQ-002', 'Arthrospira maxima', 6000, 8.00, 11.00, 28.0, 35.0, 'ATIVO');

-- SECAO 5: TB_DISPOSITIVO_IOT

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (1, 'ESP32-F1-TQ001-A2C4', 'algaspace/fazenda/1/tanque/1/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (2, 'ESP32-F1-TQ002-B3D5', 'algaspace/fazenda/1/tanque/2/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (3, 'ESP32-F1-TQ003-C4E6', 'algaspace/fazenda/1/tanque/3/metricas', 'ESP32-S3', 'N');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (4, 'ESP32-F2-TQ001-D5F7', 'algaspace/fazenda/2/tanque/4/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (5, 'ESP32-F2-TQ002-E6G8', 'algaspace/fazenda/2/tanque/5/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (6, 'ESP32-F3-BF001-F7H9', 'algaspace/fazenda/3/tanque/6/metricas', 'ESP32-S3', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (7, 'ESP32-F3-BF002-G8I0', 'algaspace/fazenda/3/tanque/7/metricas', 'ESP32-S3', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (8, 'ESP32-F3-BF003-H9J1', 'algaspace/fazenda/3/tanque/8/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (9, 'ESP32-F4-TQ001-I0K2', 'algaspace/fazenda/4/tanque/9/metricas', 'ESP32-S3', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (10, 'ESP32-F5-BR001-J1L3', 'algaspace/fazenda/5/tanque/10/metricas', 'ESP32-S3', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (11, 'ESP32-F5-BR002-K2M4', 'algaspace/fazenda/5/tanque/11/metricas', 'ESP32-S3', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (12, 'ESP32-F6-AT001-L3N5', 'algaspace/fazenda/6/tanque/12/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (13, 'ESP32-F6-AT002-M4O6', 'algaspace/fazenda/6/tanque/13/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (14, 'ESP32-F6-AT003-N5P7', 'algaspace/fazenda/6/tanque/14/metricas', 'ESP32-S3', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (15, 'ESP32-F7-TQ001-O6Q8', 'algaspace/fazenda/7/tanque/15/metricas', 'ESP32-WROOM-32', 'S');

INSERT INTO TB_DISPOSITIVO_IOT (id_tanque, codigo_serie, topico_mqtt, modelo, ativo)
VALUES (16, 'ESP32-F7-TQ002-P7R9', 'algaspace/fazenda/7/tanque/16/metricas', 'ESP32-WROOM-32', 'S');

-- SECAO 6: TB_METRICAS_TANQUE

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (1, 1, SYSTIMESTAMP - INTERVAL '6' DAY, 9.20, 33.5, 45.2, 12500);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (1, 1, SYSTIMESTAMP - INTERVAL '5' DAY, 9.35, 34.1, 47.8, 13200);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (1, 1, SYSTIMESTAMP - INTERVAL '4' DAY, 9.10, 33.8, 44.5, 11800);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (1, 1, SYSTIMESTAMP - INTERVAL '3' DAY, 11.20, 34.5, 52.1, 10900);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (1, 1, SYSTIMESTAMP - INTERVAL '1' DAY, 9.45, 33.2, 46.3, 12800);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (2, 2, SYSTIMESTAMP - INTERVAL '5' DAY, 8.90, 32.0, 43.1, 11500);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (2, 2, SYSTIMESTAMP - INTERVAL '3' DAY, 9.15, 33.7, 45.9, 12300);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (2, 2, SYSTIMESTAMP - INTERVAL '2' DAY, 9.00, 40.3, 50.0, 9800);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (2, 2, SYSTIMESTAMP - INTERVAL '1' DAY, 9.30, 34.0, 46.7, 12600);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (4, 4, SYSTIMESTAMP - INTERVAL '7' DAY, 7.20, 24.5, 35.8, 8500);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (4, 4, SYSTIMESTAMP - INTERVAL '5' DAY, 7.45, 25.2, 37.2, 9100);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (4, 4, SYSTIMESTAMP - INTERVAL '3' DAY, 7.80, 25.8, 38.5, 9400);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (4, 4, SYSTIMESTAMP - INTERVAL '1' DAY, 7.60, 24.9, 36.9, 9200);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (5, 5, SYSTIMESTAMP - INTERVAL '6' DAY, 7.30, 23.5, 34.2, 8800);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (5, 5, SYSTIMESTAMP - INTERVAL '4' DAY, 5.90, 24.0, 60.5, 7200);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (5, 5, SYSTIMESTAMP - INTERVAL '2' DAY, 7.10, 24.5, 36.0, 9000);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (6, 6, SYSTIMESTAMP - INTERVAL '5' DAY, 7.85, 22.3, 28.5, 7800);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (6, 6, SYSTIMESTAMP - INTERVAL '3' DAY, 8.10, 23.1, 29.8, 8200);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (6, 6, SYSTIMESTAMP - INTERVAL '1' DAY, 7.95, 22.8, 30.2, 8100);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (7, 7, SYSTIMESTAMP - INTERVAL '4' DAY, 6.80, 21.5, 22.3, 6500);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (7, 7, SYSTIMESTAMP - INTERVAL '2' DAY, 7.10, 22.0, 23.8, 7000);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (9, 9, SYSTIMESTAMP - INTERVAL '3' DAY, 9.50, 35.0, 48.0, 13500);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (9, 9, SYSTIMESTAMP - INTERVAL '1' DAY, 9.20, 34.2, 46.5, 13100);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (10, 10, SYSTIMESTAMP - INTERVAL '6' DAY, 7.40, 22.5, 33.5, 7600);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (10, 10, SYSTIMESTAMP - INTERVAL '4' DAY, 7.55, 23.0, 35.1, 7900);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (10, 10, SYSTIMESTAMP - INTERVAL '2' DAY, 7.45, 22.8, 34.8, 1200);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (10, 10, SYSTIMESTAMP - INTERVAL '1' DAY, 7.60, 23.2, 35.5, 8000);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (11, 11, SYSTIMESTAMP - INTERVAL '3' DAY, 7.90, 23.5, 30.2, 8300);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (11, 11, SYSTIMESTAMP - INTERVAL '1' DAY, 8.05, 24.0, 31.5, 8600);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (12, 12, SYSTIMESTAMP - INTERVAL '4' DAY, 6.90, 21.8, 24.5, 6700);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (13, 13, SYSTIMESTAMP - INTERVAL '3' DAY, 8.20, 28.5, 55.3, 11200);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (14, 14, SYSTIMESTAMP - INTERVAL '2' DAY, 9.10, 33.0, 45.0, 12000);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (15, 15, SYSTIMESTAMP - INTERVAL '5' DAY, 7.30, 24.2, 36.1, 8900);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (15, 15, SYSTIMESTAMP - INTERVAL '2' DAY, 7.55, 24.8, 37.4, 9100);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (16, 16, SYSTIMESTAMP - INTERVAL '4' DAY, 8.80, 30.5, 42.5, 11000);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (16, 16, SYSTIMESTAMP - INTERVAL '1' DAY, 9.00, 31.2, 44.1, 11400);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (1, 1, SYSTIMESTAMP - INTERVAL '7' DAY, 9.05, 32.8, 43.9, 12100);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (4, 4, SYSTIMESTAMP - INTERVAL '6' DAY, 7.15, 23.8, 34.8, 8600);

INSERT INTO TB_METRICAS_TANQUE (id_dispositivo, id_tanque, dt_leitura, ph, temperatura, turbidez, luminosidade)
VALUES (9, 9, SYSTIMESTAMP - INTERVAL '5' DAY, 9.35, 34.8, 47.2, 13300);

-- SECAO 7: TB_ALERTA_CRITICO

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (4, 1, 'PH_ALTO', 'ALTA',
        'pH 11.20 acima do limite maximo configurado (10.50) para Spirulina platensis no TQ-001. Verificar suprimento de CO2.',
        'EM_ANALISE');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (8, 2, 'TEMPERATURA_ALTA', 'CRITICA',
        'Temperatura 40.3 graus C acima do limite maximo configurado (38.0) para Spirulina platensis no TQ-002. Ativar sistema de resfriamento.',
        'ABERTO');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (15, 5, 'PH_BAIXO', 'ALTA',
        'pH 5.90 abaixo do limite minimo configurado (6.50) para Chlorella vulgaris no TQ-002. Verificar sistema de injecao de NaHCO3.',
        'ABERTO');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (27, 10, 'LUMINOSIDADE_BAIXA', 'MEDIA',
        'Luminosidade 1200 lux muito abaixo do esperado para Chlorella vulgaris no BR-001. Verificar obstrucao da fonte de luz.',
        'RESOLVIDO');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (1, 1, 'TURBIDEZ_FORA_PADRAO', 'BAIXA',
        'Turbidez 45.2 NTU acima da media esperada para o estagio de crescimento atual.',
        'RESOLVIDO');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (6, 2, 'PH_CRITICO', 'MEDIA',
        'Variacao de pH detectada fora da faixa ideal. Monitoramento continuo recomendado.',
        'RESOLVIDO');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (10, 4, 'TEMPERATURA_BAIXA', 'BAIXA',
        'Temperatura 24.5 proxima ao limite minimo. Monitorar tendencia nas proximas 2 horas.',
        'IGNORADO');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (17, 6, 'TURBIDEZ_FORA_PADRAO', 'BAIXA',
        'Turbidez em queda progressiva. Possivel final de ciclo de crescimento.',
        'RESOLVIDO');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (22, 9, 'TEMPERATURA_ALTA', 'MEDIA',
        'Temperatura 35.0 no limite superior. Verificar ventilacao e protecao solar do TQ-001.',
        'EM_ANALISE');

INSERT INTO TB_ALERTA_CRITICO (id_metrica, id_tanque, tipo_alerta, severidade, mensagem, status)
VALUES (33, 13, 'TURBIDEZ_FORA_PADRAO', 'MEDIA',
        'Turbidez 55.3 NTU acima do esperado para Dunaliella salina. Avaliar concentracao de sal.',
        'ABERTO');

-- SECAO 8: TB_DADO_ORBITAL

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (1, 'NASA_POWER', SYSDATE - 7, 285.50, 15.20, 32.5, -5.1877, -37.3438);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (1, 'NASA_POWER', SYSDATE - 3, 310.75, 8.50, 34.2, -5.1877, -37.3438);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (1, 'NASA_POWER', SYSDATE - 1, 298.30, 12.80, 33.8, -5.1877, -37.3438);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (2, 'COPERNICUS', SYSDATE - 5, 275.40, 22.30, 29.8, -5.7945, -35.2110);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (2, 'COPERNICUS', SYSDATE - 2, 290.15, 18.60, 31.5, -5.7945, -35.2110);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (3, 'NASA_POWER', SYSDATE - 6, 320.80, 5.20, 35.1, -3.7172, -38.5433);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (3, 'NASA_POWER', SYSDATE - 2, 315.60, 7.80, 34.7, -3.7172, -38.5433);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (4, 'GOES_16', SYSDATE - 4, 280.20, 35.50, 27.3, -3.7272, -40.9916);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (5, 'NASA_POWER', SYSDATE - 5, 220.45, 45.80, 23.5, -22.7253, -47.6492);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (5, 'NASA_POWER', SYSDATE - 1, 245.70, 38.20, 25.2, -22.7253, -47.6492);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (6, 'COPERNICUS', SYSDATE - 3, 235.90, 42.10, 24.8, -22.9099, -47.0626);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (7, 'GOES_16', SYSDATE - 4, 260.30, 28.70, 28.5, -16.6869, -49.2648);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (7, 'GOES_16', SYSDATE - 1, 275.80, 22.30, 30.1, -16.6869, -49.2648);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (3, 'INPE', SYSDATE - 1, 325.10, 4.50, 35.8, -3.7172, -38.5433);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (1, 'OPEN_METEO', SYSDATE, 302.40, 10.00, 33.0, -5.1877, -37.3438);

INSERT INTO TB_DADO_ORBITAL (id_fazenda, fonte, dt_coleta, irradiancia_par, nebulosidade, temperatura_ambiente, latitude, longitude)
VALUES (5, 'ERA5_ARCHIVE', SYSDATE - 10, 238.60, 31.20, 24.1, -22.7253, -47.6492);

-- SECAO 9: TB_DADO_ORBITAL_BR

INSERT INTO TB_DADO_ORBITAL_BR (
    cod_estacao, nome_estacao, dt_medicao, hr_medicao,
    temp_maxima, temp_minima, temp_media, umidade_relativa,
    precipitacao, velocidade_vento, direcao_vento, pressao_atm,
    radiacao_global, json_original
) VALUES (
    'A318', 'Natal - RN', TO_CHAR(SYSDATE - 1, 'YYYY-MM-DD'), '1200',
    31.8, 24.5, 28.1, 72.0,
    0.0, 4.2, 110, 1012.5,
    780.2, '{"fonte":"INMET","estacao":"A318"}'
);

INSERT INTO TB_DADO_ORBITAL_BR (
    cod_estacao, nome_estacao, dt_medicao, hr_medicao,
    temp_maxima, temp_minima, temp_media, umidade_relativa,
    precipitacao, velocidade_vento, direcao_vento, pressao_atm,
    radiacao_global, json_original
) VALUES (
    'A305', 'Mossoro - RN', TO_CHAR(SYSDATE - 1, 'YYYY-MM-DD'), '1200',
    35.2, 25.7, 30.4, 58.0,
    0.0, 5.1, 95, 1009.8,
    845.7, '{"fonte":"INMET","estacao":"A305"}'
);

INSERT INTO TB_DADO_ORBITAL_BR (
    cod_estacao, nome_estacao, dt_medicao, hr_medicao,
    temp_maxima, temp_minima, temp_media, umidade_relativa,
    precipitacao, velocidade_vento, direcao_vento, pressao_atm,
    radiacao_global, json_original
) VALUES (
    'A305', 'Mossoro - RN', TO_CHAR(SYSDATE - 2, 'YYYY-MM-DD'), '1200',
    34.7, 25.1, 29.9, 61.0,
    1.2, 4.8, 100, 1010.2,
    820.4, '{"fonte":"INMET","estacao":"A305"}'
);

INSERT INTO TB_DADO_ORBITAL_BR (
    cod_estacao, nome_estacao, dt_medicao, hr_medicao,
    temp_maxima, temp_minima, temp_media, umidade_relativa,
    precipitacao, velocidade_vento, direcao_vento, pressao_atm,
    radiacao_global, json_original
) VALUES (
    'A701', 'Campinas - SP', TO_CHAR(SYSDATE - 1, 'YYYY-MM-DD'), '1200',
    28.6, 18.4, 23.5, 67.0,
    0.4, 3.2, 130, 1016.3,
    690.8, '{"fonte":"INMET","estacao":"A701"}'
);

-- SECAO 10: TB_PREVISOES_IA

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (1, 2, SYSDATE - 3, 2.8500, SYSDATE + 5, 87.50, 'AlgaNet-v2.1-Spirulina');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (2, 2, SYSDATE - 3, 3.1200, SYSDATE + 7, 82.30, 'AlgaNet-v2.1-Spirulina');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (4, 4, SYSDATE - 2, 4.5600, SYSDATE + 4, 91.20, 'AlgaNet-v2.1-Chlorella');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (5, 5, SYSDATE - 2, 4.2300, SYSDATE + 6, 78.90, 'AlgaNet-v2.1-Chlorella');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (6, 7, SYSDATE - 1, 1.9800, SYSDATE + 9, 85.60, 'AlgaNet-v2.1-Nannochloropsis');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (9, 8, SYSDATE - 1, 2.7400, SYSDATE + 6, 88.10, 'AlgaNet-v2.1-Spirulina');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (10, 10, SYSDATE - 2, 5.1200, SYSDATE + 3, 93.40, 'AlgaNet-v2.1-Chlorella');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (11, 10, SYSDATE - 1, 2.3600, SYSDATE + 8, 79.50, 'AlgaNet-v2.1-Nannochloropsis');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (14, 11, SYSDATE - 1, 3.8900, SYSDATE + 5, 90.20, 'AlgaNet-v2.1-Spirulina');

INSERT INTO TB_PREVISOES_IA (id_tanque, id_dado_orbital, dt_previsao, biomassa_g_l, dt_pico_previsto, confianca_pct, modelo_utilizado)
VALUES (15, 12, SYSDATE - 2, 4.1500, SYSDATE + 4, 84.70, 'AlgaNet-v2.1-Chlorella');

-- SECAO 11: TB_LOTE_BIOMASSA

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (1, 1, 'Spirulina platensis', 125.500, 85.00, 'VENDIDO', SYSDATE - 30);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (1, 2, 'Spirulina platensis', 210.750, 85.00, 'VENDIDO', SYSDATE - 20);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (2, 4, 'Chlorella vulgaris', 340.000, 62.00, 'VENDIDO', SYSDATE - 25);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (2, 5, 'Chlorella vulgaris', 298.250, 62.00, 'DISPONIVEL', SYSDATE - 5);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (3, 6, 'Nannochloropsis oceanica', 88.000, 145.00, 'DISPONIVEL', SYSDATE - 3);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (3, 7, 'Haematococcus pluvialis', 42.500, 380.00, 'RESERVADO', SYSDATE - 7);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (3, 8, 'Dunaliella salina', 176.000, 210.00, 'VENDIDO', SYSDATE - 15);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (5, 10, 'Chlorella vulgaris', 520.000, 58.00, 'DISPONIVEL', SYSDATE - 2);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (5, 11, 'Nannochloropsis oceanica', 95.000, 140.00, 'DISPONIVEL', SYSDATE - 4);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (6, 12, 'Haematococcus pluvialis', 38.750, 395.00, 'RESERVADO', SYSDATE - 6);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (6, 14, 'Spirulina platensis', 185.000, 82.00, 'DISPONIVEL', SYSDATE - 1);

INSERT INTO TB_LOTE_BIOMASSA (id_fazenda, id_tanque, taxonomia_alga, peso_kg, preco_unitario, status, dt_colheita)
VALUES (7, 15, 'Chlorella vulgaris', 410.500, 60.00, 'CANCELADO', SYSDATE - 10);

-- SECAO 12: TB_CREDITO_CARBONO

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (1, 1, 0.6275,
        'a3f8e2b4c1d9f7e5a2b6c3d8f4e1a9b7c5d2f8e3a6b1c4d7f2e9a5b8c6d3f1e7',
        'VENDIDO', SYSDATE - 25);

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (1, 2, 1.0538,
        'b4a9f3c2e8d6b1a7c5e2f9d4b8a3c6f1e5d2b9a4c7f3e6d1b5a8c2',
        'DISPONIVEL', SYSDATE - 15);

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (2, 3, 1.7000,
        'c5b1a8d4f2e7c3b9a6d1f8e2c4b7a5d9f3e6c2b4a1d8f5e3c9b6a2',
        'VENDIDO', SYSDATE - 20);

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (3, 7, 0.8800,
        'd6c2b9a5e3f1d8c4b7a2e9f6d3c1b8a4e2f7d5c9b3a6e1f4d2c8b5',
        'DISPONIVEL', SYSDATE - 10);

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (5, 8, 2.6000,
        'e7d3c1a9f6b4e2d8c5a1f9b7e4d6c2a8f3b1e9d5c7a4f2b8e1d4',
        'VALIDADO', SYSDATE - 2);

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (3, 6, 0.2125,
        'f8e4d2b1a7c5f3e9d6b2a8c4f1e7d3b9a5c2f6e1d8b4a9c7f5e2',
        'GERADO', NULL);

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (6, 11, 0.1938,
        'a1b7c4d9e2f6a8b3c5d1e9f4a6b2c8d7e3f1a5b9c6d4e8f2a3b1',
        'GERADO', NULL);

INSERT INTO TB_CREDITO_CARBONO (id_fazenda, id_lote, co2_toneladas, hash_auditoria, status, dt_validacao)
VALUES (2, 4, 1.4913,
        'b2c8d5e1f7a4b9c3d6e2f8a1b5c9d4e7f3a6b8c2d1e5f9a3b7',
        'DISPONIVEL', SYSDATE - 3);

-- SECAO 13: TB_TRANSACAO_MARKETPLACE

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (10, 1, NULL, 'COMPRA_BIOMASSA', 125.500, 10667.50, 'CONFIRMADA');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (11, 2, NULL, 'COMPRA_BIOMASSA', 210.750, 17913.75, 'CONFIRMADA');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (14, 3, NULL, 'COMPRA_BIOMASSA', 340.000, 21080.00, 'CONFIRMADA');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (10, 7, NULL, 'COMPRA_BIOMASSA', 176.000, 36960.00, 'CONFIRMADA');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (14, 4, NULL, 'COMPRA_BIOMASSA', 150.000, 9300.00, 'PENDENTE');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (11, 6, NULL, 'COMPRA_BIOMASSA', 42.500, 16150.00, 'PENDENTE');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (13, 10, NULL, 'COMPRA_BIOMASSA', 95.000, 13300.00, 'PENDENTE');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (14, 11, NULL, 'COMPRA_BIOMASSA', 38.750, 15306.25, 'PENDENTE');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (12, NULL, 1, 'COMPRA_CREDITO_CARBONO', 0.6275, 18825.00, 'CONFIRMADA');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (12, NULL, 3, 'COMPRA_CREDITO_CARBONO', 1.7000, 51000.00, 'CONFIRMADA');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (12, NULL, 2, 'COMPRA_CREDITO_CARBONO', 1.0538, 31614.00, 'PENDENTE');

INSERT INTO TB_TRANSACAO_MARKETPLACE (id_usuario_comprador, id_lote, id_credito, tipo_transacao, quantidade, valor_total, status)
VALUES (13, NULL, 4, 'COMPRA_CREDITO_CARBONO', 0.8800, 26400.00, 'PENDENTE');

-- SECAO 14: CONFIRMACAO DE CARGA

SELECT 'TB_PERFIL'                AS tabela, COUNT(*) AS registros FROM TB_PERFIL                UNION ALL
SELECT 'TB_USUARIO'               AS tabela, COUNT(*) AS registros FROM TB_USUARIO               UNION ALL
SELECT 'TB_FAZENDA'               AS tabela, COUNT(*) AS registros FROM TB_FAZENDA               UNION ALL
SELECT 'TB_TANQUE'                AS tabela, COUNT(*) AS registros FROM TB_TANQUE                UNION ALL
SELECT 'TB_DISPOSITIVO_IOT'       AS tabela, COUNT(*) AS registros FROM TB_DISPOSITIVO_IOT       UNION ALL
SELECT 'TB_METRICAS_TANQUE'       AS tabela, COUNT(*) AS registros FROM TB_METRICAS_TANQUE       UNION ALL
SELECT 'TB_ALERTA_CRITICO'        AS tabela, COUNT(*) AS registros FROM TB_ALERTA_CRITICO        UNION ALL
SELECT 'TB_DADO_ORBITAL'          AS tabela, COUNT(*) AS registros FROM TB_DADO_ORBITAL          UNION ALL
SELECT 'TB_DADO_ORBITAL_BR'       AS tabela, COUNT(*) AS registros FROM TB_DADO_ORBITAL_BR       UNION ALL
SELECT 'TB_PREVISOES_IA'          AS tabela, COUNT(*) AS registros FROM TB_PREVISOES_IA          UNION ALL
SELECT 'TB_LOTE_BIOMASSA'         AS tabela, COUNT(*) AS registros FROM TB_LOTE_BIOMASSA         UNION ALL
SELECT 'TB_CREDITO_CARBONO'       AS tabela, COUNT(*) AS registros FROM TB_CREDITO_CARBONO       UNION ALL
SELECT 'TB_TRANSACAO_MARKETPLACE' AS tabela, COUNT(*) AS registros FROM TB_TRANSACAO_MARKETPLACE
ORDER BY tabela;

COMMIT;