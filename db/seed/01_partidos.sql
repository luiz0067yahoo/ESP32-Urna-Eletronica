-- ==============================================================================
-- SEED • TABELA: partidos
-- Povoamento oficial das legendas partidárias Pokémon
-- ==============================================================================

INSERT INTO `partidos` (`sigla`, `nome`, `slogan`) VALUES
('POKPELE', 'Partido Organizado Karvalho Professor Elétrico', 'Energia e inovação para todos.'),
('POKPFGO', 'Partido Organizado Karvalho Professor Fogo', 'Chama da mudança e energia que move o país.'),
('POKPAGU', 'Partido Organizado Karvalho Professor Água', 'Água é vida e preservação.'),
('POKPPLA', 'Partido Organizado Karvalho Professor Planta', 'Mais verde, mais futuro sustentável.'),
('POKPNOR', 'Partido Organizado Karvalho Professor Normal', 'Equilíbrio, transparência e bom senso.'),
('POKPLUT', 'Partido Organizado Karvalho Professor Lutador', 'Determinação, esporte e superação.'),
('POKPPED', 'Partido Organizado Karvalho Professor Pedra', 'Base sólida para o desenvolvimento.'),
('POKPVEN', 'Partido Organizado Karvalho Professor Veneno', 'Defesa, proteção e vigilância.'),
('POKPPSI', 'Partido Organizado Karvalho Professor Psíquico', 'Conhecimento, ciência e sabedoria.'),
('POKPACO', 'Partido Organizado Karvalho Professor Aço', 'Estrutura forte e duradoura.'),
('POKPDRA', 'Partido Organizado Karvalho Professor Dragão', 'Força e liderança estratégica.')
ON DUPLICATE KEY UPDATE `nome` = VALUES(`nome`), `slogan` = VALUES(`slogan`);
