-- ==============================================================================
-- SEED • TABELA: votos
-- Povoamento de votos iniciais para demonstração e teste da apuração
-- ==============================================================================

INSERT INTO `votos` (`cargo`, `numero_candidato`) VALUES
-- Presidente
('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'), ('PRESIDENTE', '65'),
('PRESIDENTE', '63'), ('PRESIDENTE', '63'), ('PRESIDENTE', '63'), ('PRESIDENTE', '63'),
('PRESIDENTE', '62'), ('PRESIDENTE', '62'),
('PRESIDENTE', 'BRANCO'),
-- Governador
('GOVERNADOR', '81'), ('GOVERNADOR', '81'), ('GOVERNADOR', '81'), ('GOVERNADOR', '81'),
('GOVERNADOR', '85'), ('GOVERNADOR', '85'), ('GOVERNADOR', '85'),
('GOVERNADOR', '88'), ('GOVERNADOR', '88'),
-- 1º Senador
('1º SENADOR', '701'), ('1º SENADOR', '701'), ('1º SENADOR', '701'),
('1º SENADOR', '702'), ('1º SENADOR', '702'),
('1º SENADOR', '703'),
-- 2º Senador
('2º SENADOR', '751'), ('2º SENADOR', '751'), ('2º SENADOR', '751'), ('2º SENADOR', '751'),
('2º SENADOR', '752'), ('2º SENADOR', '752'),
-- Deputado Federal
('DEPUTADO FEDERAL', '9101'), ('DEPUTADO FEDERAL', '9101'), ('DEPUTADO FEDERAL', '9101'),
('DEPUTADO FEDERAL', '9201'), ('DEPUTADO FEDERAL', '9201'),
('DEPUTADO FEDERAL', '9301'),
-- Deputado Estadual
('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'), ('DEPUTADO ESTADUAL', '90101'),
('DEPUTADO ESTADUAL', '90201'), ('DEPUTADO ESTADUAL', '90201');
