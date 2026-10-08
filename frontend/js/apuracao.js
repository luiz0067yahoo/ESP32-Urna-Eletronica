/**
 * Lógica da Tela de Apuração das Eleições Pokémon 2026
 * Fiel ao Layout de Noticiário Eleitoral (colunas verticais, fotos circulares, timestamp)
 */

const ORDEM_CARGOS = [
    "PRESIDENTE",
    "GOVERNADOR",
    "1º SENADOR",
    "2º SENADOR",
    "DEPUTADO FEDERAL",
    "DEPUTADO ESTADUAL"
];

function obterNomeExibicaoCargo(cargo) {
    const c = (cargo || '').toUpperCase();
    if (c.includes('PRESIDENTE')) return typeof _t === 'function' ? _t('cargo_nome_presidente_br') : 'PRESIDENTE DO BRASIL';
    if (c.includes('GOVERNADOR')) return typeof _t === 'function' ? _t('cargo_nome_governador_est') : 'GOVERNADOR DO ESTADO';
    if (c.includes('1º SENADOR') || c.includes('SENADOR 1')) return typeof _t === 'function' ? _t('cargo_nome_senador_1_rep') : '1º SENADOR DA REPÚBLICA';
    if (c.includes('2º SENADOR') || c.includes('SENADOR 2')) return typeof _t === 'function' ? _t('cargo_nome_senador_2_rep') : '2º SENADOR DA REPÚBLICA';
    if (c.includes('FEDERAL')) return typeof _t === 'function' ? _t('cargo_nome_deputado_fed') : 'DEPUTADO FEDERAL';
    if (c.includes('ESTADUAL')) return typeof _t === 'function' ? _t('cargo_nome_deputado_est') : 'DEPUTADO ESTADUAL';
    return cargo;
}

let dadosApuracaoAtual = null;
let cargoFiltroAtivo = 'PRESIDENTE';
let timerInterval = null;
let timerRelogio = null;
let countdownSec = 5;

// Endpoint adaptativo para o backend
function getEndpointApuracao() {
    if (window.location.pathname.includes('/frontend/')) {
        return '../backend/apuracao';
    }
    return 'backend/apuracao';
}

// Obtém a lista completa de candidatos cadastrados para um determinado cargo
function obterTodosCandidatosDoCargo(cargo) {
    const c = (cargo || '').toUpperCase();
    if (c.includes('PRESIDENTE')) {
        return typeof PRESIDENTES !== 'undefined' ? PRESIDENTES : [];
    } else if (c.includes('GOVERNADOR')) {
        return typeof GOVERNADORES !== 'undefined' ? GOVERNADORES : [];
    } else if (c.includes('1º SENADOR') || c.includes('SENADOR 1')) {
        return typeof SENADORES_1 !== 'undefined' ? SENADORES_1 : [];
    } else if (c.includes('2º SENADOR') || c.includes('SENADOR 2')) {
        return typeof SENADORES_2 !== 'undefined' ? SENADORES_2 : [];
    } else if (c.includes('FEDERAL')) {
        return typeof DEPUTADOS_FEDERAIS !== 'undefined' ? DEPUTADOS_FEDERAIS : [];
    } else if (c.includes('ESTADUAL')) {
        return typeof DEPUTADOS_ESTADUAIS !== 'undefined' ? DEPUTADOS_ESTADUAIS : [];
    }
    return [];
}

// Localiza os detalhes de um candidato específico por número
function obterDetalhesCandidato(cargo, numero) {
    if (!numero) return null;
    const listaCargo = obterTodosCandidatosDoCargo(cargo);
    let cand = listaCargo.find(item => String(item.numero) === String(numero));
    if (cand) return cand;

    // Busca nas outras listas se não achou no cargo
    const todasListas = [
        ...(typeof PRESIDENTES !== 'undefined' ? PRESIDENTES : []),
        ...(typeof GOVERNADORES !== 'undefined' ? GOVERNADORES : []),
        ...(typeof SENADORES_1 !== 'undefined' ? SENADORES_1 : []),
        ...(typeof SENADORES_2 !== 'undefined' ? SENADORES_2 : []),
        ...(typeof DEPUTADOS_FEDERAIS !== 'undefined' ? DEPUTADOS_FEDERAIS : []),
        ...(typeof DEPUTADOS_ESTADUAIS !== 'undefined' ? DEPUTADOS_ESTADUAIS : [])
    ];

    cand = todasListas.find(item => String(item.numero) === String(numero));
    return cand || {
        numero: numero,
        nome: `Candidato ${numero}`,
        partido: 'PARTIDO',
        fotoCandidato: '',
        foto: ''
    };
}

// Formatação amigável de números e porcentagens (padrão brasileiro com vírgula)
function formatarPercentual(valor) {
    const num = Number(valor) || 0;
    return num.toFixed(2).replace('.', ',') + '%';
}

// Atualiza o relógio em tempo real no formato exato: 19H06
function atualizarRelogioAoVivo() {
    const el = document.getElementById('tvTimestamp');
    if (!el) return;

    const agora = new Date();
    const horas = String(agora.getHours()).padStart(2, '0');
    const minutos = String(agora.getMinutes()).padStart(2, '0');
    el.innerText = `${horas}H${minutos}`;
}

// Busca os dados da apuração no Backend
async function carregarApuracao() {
    try {
        let endpoint = getEndpointApuracao();
        let response = null;

        try {
            response = await fetch(endpoint);
        } catch (e) {
            const endpointFallback = endpoint.endsWith('.php') ? endpoint : `${endpoint}/index.php`;
            response = await fetch(endpointFallback);
        }

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        const data = await response.json();
        dadosApuracaoAtual = data;
        renderizarPainelApuracao(data);
    } catch (erro) {
        console.warn("Aviso ao carregar apuração do backend:", erro);
        // Mesmo sem backend rodando, renderiza os candidatos cadastrados para demonstração
        renderizarPainelComDadosLocais();
    }
}

// Fallback elegante com dados locais caso o backend não responda
function renderizarPainelComDadosLocais() {
    const apuracaoMock = ORDEM_CARGOS.map(cargo => ({
        cargo: cargo,
        total_votos: 0,
        votos_validos: 0,
        percentual_validos: 0,
        votos_brancos: 0,
        percentual_brancos: 0,
        votos_nulos: 0,
        percentual_nulos: 0,
        candidatos: []
    }));

    renderizarPainelApuracao({
        status: "success",
        total_geral_votos: 0,
        apuracao: apuracaoMock
    });
}

// Ordena os cargos na sequência correta
function ordenarCargos(apuracao) {
    if (!Array.isArray(apuracao)) return [];
    return [...apuracao].sort((a, b) => {
        let idxA = ORDEM_CARGOS.indexOf(a.cargo.toUpperCase());
        let idxB = ORDEM_CARGOS.indexOf(b.cargo.toUpperCase());
        if (idxA === -1) idxA = 99;
        if (idxB === -1) idxB = 99;
        return idxA - idxB;
    });
}

// Renderiza a tela principal de apuração
function renderizarPainelApuracao(data) {
    if (!data || !data.apuracao) return;

    const apuracaoOrdenada = ordenarCargos(data.apuracao);

    // Garante que o cargo ativo seja válido
    if (!apuracaoOrdenada.some(c => c.cargo.toUpperCase() === cargoFiltroAtivo.toUpperCase())) {
        cargoFiltroAtivo = apuracaoOrdenada[0] ? apuracaoOrdenada[0].cargo : 'PRESIDENTE';
    }

    const cargoAtual = apuracaoOrdenada.find(item => item.cargo.toUpperCase() === cargoFiltroAtivo.toUpperCase()) || apuracaoOrdenada[0];

    // Renderiza as pílulas de navegação por cargo
    renderizarPilulasCargos(apuracaoOrdenada);

    // Renderiza o Card de Apuração do Noticiário para o Cargo
    renderizarCardNoticiario(cargoAtual, apuracaoOrdenada);
}

// Renderiza a barra de navegação por cargos na topbar
function renderizarPilulasCargos(apuracao) {
    const nav = document.getElementById('navCargos');
    if (!nav) return;

    nav.innerHTML = '';

    apuracao.forEach(item => {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = `btn-cargo-pill ${cargoFiltroAtivo.toUpperCase() === item.cargo.toUpperCase() ? 'active' : ''}`;
        btn.innerText = item.cargo;
        btn.onclick = () => {
            cargoFiltroAtivo = item.cargo;
            renderizarPainelApuracao(dadosApuracaoAtual || { apuracao });
        };
        nav.appendChild(btn);
    });
}

// Consolida os candidatos cadastrados com os votos apurados no backend
function consolidarCandidatosDoCargo(cargoItem) {
    const cargoNome = cargoItem.cargo;
    const todosCadastrados = obterTodosCandidatosDoCargo(cargoNome);
    const votosBackend = cargoItem.candidatos || [];

    const mapaVotos = new Map();
    votosBackend.forEach(vb => {
        mapaVotos.set(String(vb.numero_candidato), vb);
    });

    const listaFinal = [];
    const numerosInseridos = new Set();

    // 1. Adiciona os candidatos com votos
    votosBackend.forEach(vb => {
        const info = obterDetalhesCandidato(cargoNome, vb.numero_candidato);
        numerosInseridos.add(String(vb.numero_candidato));
        listaFinal.push({
            numero: vb.numero_candidato,
            nome: info ? info.nome : `Candidato ${vb.numero_candidato}`,
            partido: info ? info.partido : 'PARTIDO',
            foto: (info && (info.fotoCandidato || info.foto)) ? (info.fotoCandidato || info.foto) : '',
            votos: vb.votos || 0,
            percentual_validos: vb.percentual_validos !== undefined ? vb.percentual_validos : (vb.percentual_total || 0)
        });
    });

    // 2. Adiciona os candidatos cadastrados que ainda não receberam votos (para exibição inicial completa)
    todosCadastrados.forEach(cand => {
        if (!numerosInseridos.has(String(cand.numero))) {
            listaFinal.push({
                numero: cand.numero,
                nome: cand.nome,
                partido: cand.partido,
                foto: cand.fotoCandidato || cand.foto || '',
                votos: 0,
                percentual_validos: 0
            });
        }
    });

    // 3. Ordena por quantidade de votos (decrescente)
    listaFinal.sort((a, b) => b.votos - a.votos);

    return listaFinal;
}

// Renderiza o Card de Noticiário (Layout idêntico ao modelo com os Pokémons)
function renderizarCardNoticiario(cargoItem, apuracaoCompleta) {
    if (!cargoItem) return;

    // Atualiza Título e Subtítulo
    const lblCargoNome = document.getElementById('tvCargoNome');
    if (lblCargoNome) {
        lblCargoNome.innerText = obterNomeExibicaoCargo(cargoItem.cargo);
    }

    // Configura botões de navegação anterior/próximo
    const currentIndex = apuracaoCompleta.findIndex(c => c.cargo.toUpperCase() === cargoItem.cargo.toUpperCase());
    const prevCargo = currentIndex > 0 ? apuracaoCompleta[currentIndex - 1] : apuracaoCompleta[apuracaoCompleta.length - 1];
    const nextCargo = currentIndex < apuracaoCompleta.length - 1 ? apuracaoCompleta[currentIndex + 1] : apuracaoCompleta[0];

    const btnPrev = document.getElementById('btnCargoAnterior');
    if (btnPrev) {
        btnPrev.title = typeof _t === 'function' ? _t('cargo_anterior') : 'Cargo anterior';
        btnPrev.onclick = () => {
            cargoFiltroAtivo = prevCargo.cargo;
            renderizarPainelApuracao(dadosApuracaoAtual || { apuracao: apuracaoCompleta });
        };
    }

    const btnNext = document.getElementById('btnCargoProximo');
    if (btnNext) {
        btnNext.title = typeof _t === 'function' ? _t('proximo_cargo') : 'Próximo cargo';
        btnNext.onclick = () => {
            cargoFiltroAtivo = nextCargo.cargo;
            renderizarPainelApuracao(dadosApuracaoAtual || { apuracao: apuracaoCompleta });
        };
    }

    // Consolida candidatos para renderização
    const listaCandidatos = consolidarCandidatosDoCargo(cargoItem);

    // Define quantos candidatos exibir nas colunas verticais principais
    let qtdNoGrafico = Math.min(3, listaCandidatos.length);

    const candidatosGrafico = listaCandidatos.slice(0, qtdNoGrafico);
    const candidatosRestantes = listaCandidatos.slice(qtdNoGrafico);

    // Renderiza as Colunas Verticais
    const containerColunas = document.getElementById('tvColunasCandidatos');
    const containerNomes = document.getElementById('tvColunasNomes');

    if (containerColunas) {
        containerColunas.innerHTML = '';
        if (containerNomes) containerNomes.innerHTML = '';

        candidatosGrafico.forEach((cand, idx) => {
            // 1. Coluna superior (Avatar, Percentual e Barra)
            const colTopo = document.createElement('div');
            colTopo.className = 'cand-col-topo';

            // Altura da barra proporcional (máximo de 220px)
            const pct = Number(cand.percentual_validos) || 0;
            let alturaBarra = 24; // Altura mínima de base visível
            if (cargoItem.votos_validos > 0) {
                alturaBarra = Math.max(24, Math.round((pct / 100) * 220));
            } else if (cand.votos > 0) {
                alturaBarra = 40;
            }

            const fotoSrc = cand.foto || 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png';

            colTopo.innerHTML = `
                <!-- Foto circular com borda branca e sombra -->
                <div class="cand-avatar-wrapper" title="${cand.nome}">
                    <img src="${fotoSrc}" class="cand-avatar-img" alt="${cand.nome}" onerror="this.src='https://via.placeholder.com/120?text=${cand.nome}'">
                </div>

                <!-- Percentual acima da barra -->
                <div class="cand-pct">${formatarPercentual(cand.percentual_validos)}</div>

                <!-- Barra vertical com cor única por candidato -->
                <div class="cand-bar-container">
                    <div class="cand-bar" style="height: ${alturaBarra}px;"></div>
                </div>
            `;
            containerColunas.appendChild(colTopo);

            // 2. Coluna inferior (Nome do Pokémon, Partido e Votos)
            if (containerNomes) {
                const rotVoto = cand.votos === 1 ? (typeof _t === 'function' ? _t('voto_singular') : 'voto') : (typeof _t === 'function' ? _t('votos_plural') : 'votos');
                const colBase = document.createElement('div');
                colBase.className = 'cand-col-base';
                colBase.innerHTML = `
                    <div class="cand-nome">${cand.nome}</div>
                    <div class="cand-numero-partido">${cand.numero} • ${cand.partido}</div>
                    <div class="cand-votos-qtd">${cand.votos.toLocaleString()} ${rotVoto}</div>
                `;
                containerNomes.appendChild(colBase);
            }
        });
    }

    // Seção de Urnas Apuradas e Barra Verde
    const totalVotos = cargoItem.total_votos || 0;
    const votosValidos = cargoItem.votos_validos || 0;
    const brancos = cargoItem.votos_brancos || 0;
    const nulos = cargoItem.votos_nulos || 0;

    const elUrnasPct = document.getElementById('tvUrnasPct');
    const elProgressFill = document.getElementById('tvProgressFill');
    const elResumoVotos = document.getElementById('tvResumoVotos');

    let pctApuradas = totalVotos > 0 ? 100 : 0;

    if (elUrnasPct) {
        elUrnasPct.innerText = `${pctApuradas}%`;
    }
    if (elProgressFill) {
        elProgressFill.style.width = `${pctApuradas}%`;
    }
    if (elResumoVotos) {
        const pctVal = totalVotos > 0 ? ((votosValidos / totalVotos) * 100).toFixed(1) : "0.0";
        const rotValidos = typeof _t === 'function' ? _t('resumo_validos') : 'Válidos:';
        const rotBrancos = typeof _t === 'function' ? _t('resumo_brancos') : 'Brancos:';
        const rotNulos = typeof _t === 'function' ? _t('resumo_nulos') : 'Nulos:';
        const rotTotal = typeof _t === 'function' ? _t('resumo_total') : 'Total:';

        elResumoVotos.innerHTML = `
            <span>${rotValidos} <b>${votosValidos} (${pctVal}%)</b></span>
            <span>${rotBrancos} <b>${brancos}</b></span>
            <span>${rotNulos} <b>${nulos}</b></span>
            <span>${rotTotal} <b>${totalVotos}</b></span>
        `;
    }

    // Se houver mais candidatos que os exibidos no gráfico, exibe seção expansível
    renderizarSecaoDetalhes(candidatosGrafico, candidatosRestantes, cargoItem);
}

// Renderiza seção expansível para cargos com muitos candidatos (como 9 Governadores ou 20 Senadores)
function renderizarSecaoDetalhes(candidatosGrafico, candidatosRestantes, cargoItem) {
    const secao = document.getElementById('secaoDetalhes');
    if (!secao) return;

    if (candidatosRestantes.length === 0) {
        secao.style.display = 'none';
        return;
    }

    secao.style.display = 'block';

    const lblTotal = document.getElementById('detalhesTotalTexto');
    if (lblTotal) {
        const rotVotos = typeof _t === 'function' ? _t('votos_plural') : 'votos';
        lblTotal.innerText = `${cargoItem.total_votos || 0} ${rotVotos}`;
    }

    const listaContainer = document.getElementById('detalhesListaCandidatos');
    if (!listaContainer) return;

    listaContainer.innerHTML = '';

    const todos = [...candidatosGrafico, ...candidatosRestantes];

    todos.forEach((cand, idx) => {
        const item = document.createElement('div');
        item.className = 'item-detalhe-cand';

        const fotoSrc = cand.foto || 'https://via.placeholder.com/60?text=PKMN';
        const rotVoto = cand.votos === 1 ? (typeof _t === 'function' ? _t('voto_singular') : 'voto') : (typeof _t === 'function' ? _t('votos_plural') : 'votos');

        item.innerHTML = `
            <div class="item-detalhe-pos">#${idx + 1}</div>
            <img src="${fotoSrc}" class="item-detalhe-foto" alt="${cand.nome}">
            <div class="item-detalhe-info">
                <div class="item-detalhe-nome">${cand.nome}</div>
                <div class="item-detalhe-sub">${cand.numero} • ${cand.partido}</div>
            </div>
            <div class="item-detalhe-votos">
                <div class="item-detalhe-pct">${formatarPercentual(cand.percentual_validos)}</div>
                <div class="item-detalhe-qtd">${cand.votos} ${rotVoto}</div>
            </div>
        `;

        listaContainer.appendChild(item);
    });
}

// Ciclo de Atualização Automática
function iniciarCicloAtualizacao() {
    if (timerInterval) clearInterval(timerInterval);

    countdownSec = 5;
    const elContador = document.getElementById('lblContadorAuto');

    timerInterval = setInterval(() => {
        countdownSec--;
        if (elContador) elContador.innerText = `(${countdownSec}s)`;

        if (countdownSec <= 0) {
            countdownSec = 5;
            carregarApuracao();
        }
    }, 1000);
}

// Inicia relógio ao vivo (formato 19H06)
function iniciarRelogio() {
    atualizarRelogioAoVivo();
    if (timerRelogio) clearInterval(timerRelogio);
    timerRelogio = setInterval(atualizarRelogioAoVivo, 1000);
}

// Inicialização da Página
window.addEventListener('DOMContentLoaded', () => {
    iniciarRelogio();
    carregarApuracao();
    iniciarCicloAtualizacao();

    if (typeof i18n !== 'undefined') {
        i18n.aoMudarIdioma(() => {
            if (dadosApuracaoAtual) {
                renderizarPainelApuracao(dadosApuracaoAtual);
            } else {
                renderizarPainelComDadosLocais();
            }
        });
    }
});
