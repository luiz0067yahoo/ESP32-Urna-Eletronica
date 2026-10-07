const partidos = [
    {
        sigla: "POKPELE",
        nome: "Partido Organizado Karvalho Professor Elétrico",
        slogan: "Energia e inovação para todos.",
        propostas: [
            "Isenção de impostos sobre energia solar.",
            "Expansão da rede elétrica inteligente.",
            "Wi-Fi gratuito em praças e escolas.",
            "Incentivo à produção de baterias sustentáveis."
        ]
    },
    {
        sigla: "POKPFGO",
        nome: "Partido Organizado Karvalho Professor Fogo",
        slogan: "Chama da mudança e energia que move o país.",
        propostas: [
            "Prevenção de incêndios florestais.",
            "Incentivo à indústria de energia térmica limpa.",
            "Cursos gratuitos para bombeiros.",
            "Pesquisa em combustíveis renováveis."
        ]
    },
    {
        sigla: "POKPAGU",
        nome: "Partido Organizado Karvalho Professor Água",
        slogan: "Água é vida e preservação.",
        propostas: [
            "Universalizar o saneamento básico.",
            "Recuperar rios e nascentes.",
            "Combate ao desperdício de água.",
            "Dessalinização em regiões secas."
        ]
    },
    {
        sigla: "POKPPLA",
        nome: "Partido Organizado Karvalho Professor Planta",
        slogan: "Mais verde, mais futuro sustentável.",
        propostas: [
            "Plantio de árvores em áreas urbanas.",
            "Incentivo à agricultura orgânica.",
            "Hortas comunitárias escolares.",
            "Preservação das florestas e biomas."
        ]
    },
    {
        sigla: "POKPNOR",
        nome: "Partido Organizado Karvalho Professor Normal",
        slogan: "Equilíbrio, transparência e bom senso.",
        propostas: [
            "Desburocratização dos serviços públicos.",
            "Apoio ao pequeno comércio local.",
            "Melhoria na iluminação pública.",
            "Gestão eficiente e transparente."
        ]
    },
    {
        sigla: "POKPLUT",
        nome: "Partido Organizado Karvalho Professor Lutador",
        slogan: "Determinação, esporte e superação.",
        propostas: [
            "Incentivo às artes marciais nas escolas.",
            "Construção de centros esportivos comunitários.",
            "Bolsa-atleta para novos talentos.",
            "Programas de saúde e condicionamento."
        ]
    },
    {
        sigla: "POKPPED",
        nome: "Partido Organizado Karvalho Professor Pedra",
        slogan: "Bases sólidas para um futuro inabalável.",
        propostas: [
            "Infraestrutura rodoviária resistente.",
            "Obras públicas duradouras.",
            "Mineração responsável e ecológica.",
            "Moradias populares seguras."
        ]
    },
    {
        sigla: "POKPFAN",
        nome: "Partido Organizado Karvalho Professor Fantasma",
        slogan: "Sabedoria, memória e visão do invisível.",
        propostas: [
            "Preservação da memória e patrimônio histórico.",
            "Combate rigoroso à corrupção.",
            "Segurança cibernética avançada.",
            "Incentivo a projetos culturais noturnos."
        ]
    },
    {
        sigla: "POKPPSI",
        nome: "Partido Organizado Karvalho Professor Psíquico",
        slogan: "Conhecimento e mente aberta transformam.",
        propostas: [
            "Investimento em ciência e inteligência.",
            "Saúde mental gratuita na rede pública.",
            "Bolsas de pesquisa científica.",
            "Laboratórios digitais nas escolas."
        ]
    },
    {
        sigla: "POKPDRA",
        nome: "Partido Organizado Karvalho Professor Dragão",
        slogan: "Coragem, liderança e visão de futuro.",
        propostas: [
            "Fortalecimento do desenvolvimento econômico.",
            "Incentivo a grandes projetos de engenharia.",
            "Capacitação de novas lideranças.",
            "Segurança e proteção soberana."
        ]
    },
    {
        sigla: "POKPSOM",
        nome: "Partido Organizado Karvalho Professor Sombrio",
        slogan: "Estratégia e justiça para todos.",
        propostas: [
            "Combate rigoroso ao crime organizado.",
            "Privacidade de dados dos cidadãos.",
            "Proteção dos direitos trabalhistas.",
            "Transparência em contratos públicos."
        ]
    },
    {
        sigla: "POKPACO",
        nome: "Partido Organizado Karvalho Professor Aço",
        slogan: "Resistência, tecnologia e desenvolvimento.",
        propostas: [
            "Modernização da indústria nacional.",
            "Siderurgia ecológica e sustentável.",
            "Reforço na segurança estrutural urbana.",
            "Formação técnica e profissional."
        ]
    },
    {
        sigla: "POKPFAD",
        nome: "Partido Organizado Karvalho Professor Fada",
        slogan: "Harmonia, solidariedade e justiça social.",
        propostas: [
            "Proteção dos animais e abrigos.",
            "Apoio à infância e terceira idade.",
            "Humanização no atendimento de saúde.",
            "Inclusão social e programas culturais."
        ]
    },
    {
        sigla: "POKPVEN",
        nome: "Partido Organizado Karvalho Professor Veneno",
        slogan: "Proteção, imunidade e prevenção sanitária.",
        propostas: [
            "Vacinação universal e prevenção sanitária.",
            "Combate a pragas e zoonoses urbanas.",
            "Descontaminação de rios e solos.",
            "Investimento em pesquisa farmacêutica."
        ]
    },
    {
        sigla: "POKPTER",
        nome: "Partido Organizado Karvalho Professor Terra",
        slogan: "Firmeza no solo e desenvolvimento agrícola.",
        propostas: [
            "Apoio ao pequeno produtor rural.",
            "Contenção de encostas e barragens.",
            "Mapeamento geológico de áreas de risco.",
            "Pavimentação de estradas rurais."
        ]
    },
    {
        sigla: "POKPVOA",
        nome: "Partido Organizado Karvalho Professor Voador",
        slogan: "Liberdade, conexão e voos mais altos.",
        propostas: [
            "Ampliação de aviação regional.",
            "Monitoramento aéreo de queimadas.",
            "Incentivo ao turismo e integração.",
            "Internet via satélite em áreas remotas."
        ]
    },
    {
        sigla: "POKPGEL",
        nome: "Partido Organizado Karvalho Professor Gelo",
        slogan: "Mente serena e preservação climática.",
        propostas: [
            "Cadeia de frio para conservar alimentos.",
            "Monitoramento do clima e temperatura.",
            "Eficiência em refrigeração pública.",
            "Proteção de nascentes de altitude."
        ]
    },
    {
        sigla: "POKPINSE",
        nome: "Partido Organizado Karvalho Professor Inseto",
        slogan: "Trabalho em equipe e resiliência.",
        propostas: [
            "Proteção dos insetos polinizadores.",
            "Desenvolvimento de agricultura sustentável.",
            "Preservação da fauna e microfauna.",
            "Educação ecológica comunitária."
        ]
    },
    {
        sigla: "POKPINSE",
        nome: "Partido Organizado Karvalho Professor - Cidadania",
        slogan: "O básico bem feito.",
        propostas: [
            "Simplificação de impostos.",
            "Atendimento público eficiente.",
            "Transparência.",
            "Redução da burocracia."
        ]
    }
];

const PARTIDOS = partidos;

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { partidos, PARTIDOS };
}
