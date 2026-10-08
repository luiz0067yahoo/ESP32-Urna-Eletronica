// ==========================================================================
// LÓGICA PRINCIPAL DA URNA ELETRÔNICA E MODAL DE SANTINHOS
// ==========================================================================

const PRIMEIRO_SLIDE = 0;
const ULTIMO_SLIDE = 5;
var candidatoAtual = null;
let indiceSlide = 0;
var slides = document.getElementsByClassName("slide");

class Voto {
    constructor(deputadoFederal, deputadoEstadual, senador1, senador2, governador, presidente) {
        this.deputadoFederal = deputadoFederal;
        this.deputadoEstadual = deputadoEstadual;
        this.senador1 = senador1;
        this.senador2 = senador2;
        this.governador = governador;
        this.presidente = presidente;
    }
}

var voto = new Voto(null, null, null, null, null, null);

const salvarVotoAtual = () => {
    const slide = slides[indiceSlide];
    const input = slide ? slide.querySelector('.numero-candidato') : null;
    const numDigitado = input ? input.value.trim() : '';

    let infoVoto = null;
    if (candidatoAtual && candidatoAtual.numero) {
        infoVoto = {
            numero: candidatoAtual.numero,
            nome: candidatoAtual.nome || '',
            partido: candidatoAtual.partido || ''
        };
    } else if (numDigitado === '' || numDigitado.toUpperCase() === 'BRANCO') {
        infoVoto = {
            numero: 'BRANCO',
            nome: (typeof _t === 'function' ? _t('voto_em_branco') : 'VOTO EM BRANCO'),
            partido: ''
        };
    } else {
        infoVoto = {
            numero: numDigitado,
            nome: (typeof _t === 'function' ? _t('voto_nulo') : 'VOTO NULO'),
            partido: ''
        };
    }
    salvaCandidato(infoVoto);
};

function proximoSlide() {
    salvarVotoAtual();
    if (indiceSlide < ULTIMO_SLIDE) {
        slides[indiceSlide].classList.add("d-none");
        indiceSlide++;
        slides[indiceSlide].classList.remove("d-none");
        candidatoAtual = null;
        const input = slides[indiceSlide].querySelector('.numero-candidato');
        if (input) input.focus();
    } else {
        finalizarVotacao();
    }
}

function slideAnterior() {
    if (indiceSlide > PRIMEIRO_SLIDE) {
        slides[indiceSlide].classList.add("d-none");
        indiceSlide--;
        slides[indiceSlide].classList.remove("d-none");
    }
}

const carregarCandidato = (numero) => {
    // Se o campo estiver em branco ou vazio, não exibe mensagem de erro
    if (!numero || String(numero).trim() === '' || String(numero).trim().toUpperCase() === 'BRANCO') {
        candidatoAtual = null;
        const slide = slides[indiceSlide];
        if (slide) {
            slide.querySelector('.nome').textContent = '';
            slide.querySelector('.partido').textContent = '';
            slide.querySelector('.foto-candidato').style.backgroundImage = '';
            try {
                slide.querySelector('.vice').textContent = '';
                slide.querySelector('.foto-vice').style.backgroundImage = '';
            } catch (error) {}
        }
        return;
    }

    candidatoAtual = {};
    var candidatoBuscado = undefined;
    switch (indiceSlide) {
        case 0:
            candidatoBuscado = DEPUTADOS_FEDERAIS.find(c => c.numero === numero);
            break;
        case 1:
            candidatoBuscado = DEPUTADOS_ESTADUAIS.find(c => c.numero === numero);
            break;
        case 2:
            candidatoBuscado = SENADORES_1.find(c => c.numero === numero);
            break;
        case 3:
            candidatoBuscado = SENADORES_2.find(c => c.numero === numero);
            break;
        case 4:
            candidatoBuscado = GOVERNADORES.find(c => c.numero === numero);
            break;
        case 5:
            candidatoBuscado = PRESIDENTES.find(c => c.numero === numero);
            break;
    }
    if (candidatoBuscado != undefined) {
        candidatoAtual = candidatoBuscado;
        const slide = slides[indiceSlide];
        slide.querySelector('.nome').textContent = candidatoAtual.nome;
        slide.querySelector('.partido').textContent = candidatoAtual.partido;
        slide.querySelector('.foto-candidato').style.backgroundImage = `url(${candidatoAtual.fotoCandidato})`;
        try {
            slide.querySelector('.vice').textContent = candidatoAtual.vice;
            slide.querySelector('.foto-vice').style.backgroundImage = `url(${candidatoAtual.fotoVice})`;
        } catch (error) {
            //console.error("Erro ao carregar informações do vice:", error);
        }
    } else {
        loadMessageBox("Candidato não encontrado!", 'Por favor, tente novamente.', 'ok', () => {
            closeMessageBox();
        });
        setTimeout(() => { closeMessageBox(); }, 2000);
    }
};

const inserirDigito = (digito) => {
    const slide = slides[indiceSlide];
    const input = slide.querySelector('.numero-candidato');
    if (input.value.length < input.maxLength) {
        input.value += digito;
        if (input.value.length === input.maxLength) {
            carregarCandidato(input.value);
        }
    }
};

const corrigeVoto = () => {
    limpar();
};

const salvaCandidato = (candidato) => {
    switch (indiceSlide) {
        case 0:
            voto.deputadoFederal = candidato;
            break;
        case 1:
            voto.deputadoEstadual = candidato;
            break;
        case 2:
            voto.senador1 = candidato;
            break;
        case 3:
            voto.senador2 = candidato;
            break;
        case 4:
            voto.governador = candidato;
            break;
        case 5:
            voto.presidente = candidato;
            break;
    }
};

const limpar = () => {
    salvaCandidato(null);
    candidatoAtual = null;
    const slide = slides[indiceSlide];
    const input = slide.querySelector('.numero-candidato');
    input.value = '';
    slide.querySelector('.nome').textContent = '';
    slide.querySelector('.partido').textContent = '';
    slide.querySelector('.foto-candidato').style.backgroundImage = '';
    try {
        slide.querySelector('.vice').textContent = '';
        slide.querySelector('.foto-vice').style.backgroundImage = '';
    } catch (error) {
        //console.error("Erro ao limpar informações do vice:", error);
    }
};

const votoBranco = () => {
    limpar();
    proximoSlide();
};

const confirmaVoto = () => {
    proximoSlide();
};

const coletarDadosVotacao = () => {
    const lista = [];
    const cargos = [
        { nome: "DEPUTADO FEDERAL", chave: "deputadoFederal" },
        { nome: "DEPUTADO ESTADUAL", chave: "deputadoEstadual" },
        { nome: "1º SENADOR", chave: "senador1" },
        { nome: "2º SENADOR", chave: "senador2" },
        { nome: "GOVERNADOR", chave: "governador" },
        { nome: "PRESIDENTE", chave: "presidente" }
    ];

    for (const c of cargos) {
        const item = voto[c.chave];
        const num = item && item.numero ? String(item.numero).trim() : "BRANCO";
        lista.push({
            cargo: c.nome,
            numero_candidato: num
        });
    }

    return lista;
};

const obterEndpointBackend = () => {
    if (window.location.pathname.includes('/frontend/')) {
        return '../backend/votos/index.php';
    }
    return 'backend/votos/index.php';
};

const enviarVotosBackend = async (dadosVotos) => {
    try {
        const endpoint = obterEndpointBackend();
        const response = await fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ votos: dadosVotos })
        });
        const result = await response.json();
        console.log("Votos registrados no backend:", result);
        return result;
    } catch (error) {
        console.warn("Aviso ao enviar dados de voto para o backend:", error);
    }
};

const resetarUrna = () => {
    // 1. Reseta o registro de votos e candidato selecionado
    voto = new Voto(null, null, null, null, null, null);
    candidatoAtual = null;

    // 2. Limpa todos os campos de todos os slides
    for (let i = 0; i < slides.length; i++) {
        const slide = slides[i];

        const input = slide.querySelector('.numero-candidato');
        if (input) input.value = '';

        const nome = slide.querySelector('.nome');
        if (nome) nome.textContent = '';

        const partido = slide.querySelector('.partido');
        if (partido) partido.textContent = '';

        const fotoCandidato = slide.querySelector('.foto-candidato');
        if (fotoCandidato) fotoCandidato.style.backgroundImage = '';

        const vice = slide.querySelector('.vice');
        if (vice) vice.textContent = '';

        const fotoVice = slide.querySelector('.foto-vice');
        if (fotoVice) fotoVice.style.backgroundImage = '';

        slide.classList.add('d-none');
    }

    // 3. Retorna ao primeiro slide
    indiceSlide = PRIMEIRO_SLIDE;
    if (slides[PRIMEIRO_SLIDE]) {
        slides[PRIMEIRO_SLIDE].classList.remove('d-none');
        const primeiroInput = slides[PRIMEIRO_SLIDE].querySelector('.numero-candidato');
        if (primeiroInput) primeiroInput.focus();
    }

    // 4. Fecha a caixa de mensagem
    closeMessageBox();
};

const finalizarVotacao = () => {
    const dadosVotos = coletarDadosVotacao();
    enviarVotosBackend(dadosVotos);

    const titulo = typeof _t === 'function' ? _t('voto_finalizado_titulo') : 'Voto Finalizado';
    const msg = typeof _t === 'function' ? _t('voto_finalizado_msg') : 'Obrigado por participar do treinamento.';
    const btnReiniciar = typeof _t === 'function' ? _t('btn_reiniciar') : 'Reiniciar Treinamento';

    loadMessageBox(titulo, msg, btnReiniciar, () => {
        resetarUrna();
    }, true);
};

const loadMessageBox = (title, body, buttonText, buttonAction, mostrarApuracao = false) => {
    const messageBox = document.querySelector('.message-box');
    messageBox.classList.remove('d-none');
    messageBox.querySelector('.title').textContent = title;
    messageBox.querySelector('.body').textContent = body;
    const button = messageBox.querySelector('.btn-primary');
    if (button) {
        button.textContent = buttonText;
        button.onclick = () => {
            buttonAction();
            messageBox.classList.add('d-none');
        };
    }

    const btnApuracao = messageBox.querySelector('.btn-apuracao');
    if (btnApuracao) {
        if (typeof _t === 'function') {
            btnApuracao.textContent = _t('btn_apuracao');
        }
        if (mostrarApuracao) {
            btnApuracao.classList.remove('d-none');
        } else {
            btnApuracao.classList.add('d-none');
        }
    }
};

const closeMessageBox = () => {
    const messageBox = document.querySelector('.message-box');
    messageBox.classList.add('d-none');
    messageBox.querySelector('.title').textContent = "";
    messageBox.querySelector('.body').textContent = "";
    const button = messageBox.querySelector('.btn-primary');
    if (button) {
        button.textContent = "";
        button.onclick = () => { };
    }
    const btnApuracao = messageBox.querySelector('.btn-apuracao');
    if (btnApuracao) {
        btnApuracao.classList.add('d-none');
    }
};


// ==========================================================================
// MODAL DE SANTINHOS E COLIGAÇÕES
// ==========================================================================

function obterAbasCargos() {
    return [
        { id: "estadual", nome: typeof _t === 'function' ? _t('tab_deputados_estaduais') : "Deputados Estaduais", lista: DEPUTADOS_ESTADUAIS, tipo: "estadual" },
        { id: "federal", nome: typeof _t === 'function' ? _t('tab_deputados_federais') : "Deputados Federais", lista: DEPUTADOS_FEDERAIS, tipo: "federal" },
        { id: "senador1", nome: typeof _t === 'function' ? _t('tab_senador_1') : "1º Senador", lista: SENADORES_1, tipo: "senador1" },
        { id: "senador2", nome: typeof _t === 'function' ? _t('tab_senador_2') : "2º Senador", lista: SENADORES_2, tipo: "senador2" },
        { id: "governador", nome: typeof _t === 'function' ? _t('tab_governador') : "Governador", lista: GOVERNADORES, tipo: "governador" },
        { id: "presidente", nome: typeof _t === 'function' ? _t('tab_presidente') : "Presidente", lista: PRESIDENTES, tipo: "presidente" }
    ];
}

let abasCargos = obterAbasCargos();

let abaAtivaIndex = 0;
let subIndiceAtual = 0;

function buscarCandidatoPorNumero(numero, cargo) {
    if (!numero) return null;
    let listaCandidatos = [];

    switch (cargo) {
        case "Dep. Estadual":
            listaCandidatos = DEPUTADOS_ESTADUAIS;
            break;
        case "Dep. Federal":
            listaCandidatos = DEPUTADOS_FEDERAIS;
            break;
        case "Senador 1":
            listaCandidatos = SENADORES_1;
            break;
        case "Senador 2":
            listaCandidatos = SENADORES_2;
            break;
        case "Governador":
            listaCandidatos = GOVERNADORES;
            break;
        case "Presidente":
            listaCandidatos = PRESIDENTES;
            break;
        default:
    }
    let candidatoBuscado = listaCandidatos.find(c => c.numero === numero);
    return candidatoBuscado;
}

function obterDadosColigacao(candidato, tipoCargo) {
    let relacao = null;

    if (tipoCargo === "estadual") {
        relacao = ARTES_DEPUTADOS_ESTADUAIS.find(a => a.deputadoEstadual === candidato.numero);
    } else if (tipoCargo === "federal") {
        const lista = (typeof ARTES_DEPUTADOS_FEDERAIS !== 'undefined' && ARTES_DEPUTADOS_FEDERAIS.length > 0) ? ARTES_DEPUTADOS_FEDERAIS : ARTES_DEPUTADOS_ESTADUAIS;
        relacao = lista.find(a => a.deputadoFederal === candidato.numero);
    } else if (tipoCargo === "senador1") {
        const lista = (typeof ARTES_SENADORES_1 !== 'undefined' && ARTES_SENADORES_1.length > 0) ? ARTES_SENADORES_1 : ARTES_DEPUTADOS_ESTADUAIS;
        relacao = lista.find(a => a.senador1 === candidato.numero);
    } else if (tipoCargo === "senador2") {
        const lista = (typeof ARTES_SENADORES_2 !== 'undefined' && ARTES_SENADORES_2.length > 0) ? ARTES_SENADORES_2 : ARTES_DEPUTADOS_ESTADUAIS;
        relacao = lista.find(a => a.senador2 === candidato.numero);
    } else if (tipoCargo === "governador") {
        const lista = (typeof ARTES_GOVERNADORES !== 'undefined' && ARTES_GOVERNADORES.length > 0) ? ARTES_GOVERNADORES : ARTES_DEPUTADOS_ESTADUAIS;
        relacao = lista.find(a => a.governador === candidato.numero);
    } else if (tipoCargo === "presidente") {
        const lista = (typeof ARTES_PRESIDENTES !== 'undefined' && ARTES_PRESIDENTES.length > 0) ? ARTES_PRESIDENTES : ARTES_DEPUTADOS_ESTADUAIS;
        relacao = lista.find(a => a.presidente === candidato.numero);
    }

    if (!relacao && typeof ARTES_DEPUTADOS_ESTADUAIS !== 'undefined' && ARTES_DEPUTADOS_ESTADUAIS.length > 0) {
        relacao = ARTES_DEPUTADOS_ESTADUAIS[0];
    }

    if (!relacao) return [];

    const coligacaoItens = [];

    if (tipoCargo !== "estadual" && relacao.deputadoEstadual) {
        const cand = buscarCandidatoPorNumero(relacao.deputadoEstadual, "Dep. Estadual");
        if (cand) coligacaoItens.push({ cargo: "Dep. Estadual", nome: cand.nome, numero: cand.numero, foto: cand.foto });
    }
    if (tipoCargo !== "federal" && relacao.deputadoFederal) {
        const cand = buscarCandidatoPorNumero(relacao.deputadoFederal, "Dep. Federal");
        if (cand) coligacaoItens.push({ cargo: "Dep. Federal", nome: cand.nome, numero: cand.numero, foto: cand.foto });
    }
    if (tipoCargo !== "senador1" && relacao.senador1) {
        const cand = buscarCandidatoPorNumero(relacao.senador1, "Senador 1");
        if (cand) coligacaoItens.push({ cargo: "Senador 1", nome: cand.nome, numero: cand.numero, foto: cand.foto });
    }
    if (tipoCargo !== "senador2" && relacao.senador2) {
        const cand = buscarCandidatoPorNumero(relacao.senador2, "Senador 2");
        if (cand) coligacaoItens.push({ cargo: "Senador 2", nome: cand.nome, numero: cand.numero, foto: cand.foto });
    }
    if (tipoCargo !== "governador" && relacao.governador) {
        const cand = buscarCandidatoPorNumero(relacao.governador, "Governador");
        if (cand) coligacaoItens.push({ cargo: "Governador", nome: cand.nome, numero: cand.numero, foto: cand.foto });
    }
    if (tipoCargo !== "presidente" && relacao.presidente) {
        const cand = buscarCandidatoPorNumero(relacao.presidente, "Presidente");
        if (cand) coligacaoItens.push({ cargo: "Presidente", nome: cand.nome, numero: cand.numero, foto: cand.foto });
    }

    return coligacaoItens;
}

function abrirSantinhos() {
    renderizarApp();
}

function fecharSantinhos() {
    const containerPrincipal = document.getElementById('urna-santinhos-container');
    if (containerPrincipal) {
        containerPrincipal.classList.add('d-none');
        containerPrincipal.style.display = 'none';
    }
}

function renderizarApp() {
    const containerPrincipal = document.getElementById('urna-santinhos-container');
    if (!containerPrincipal) return;

    containerPrincipal.classList.remove('d-none');
    containerPrincipal.style.display = 'flex';

    const btnFechar = document.getElementById('usBtnFechar');
    if (btnFechar) {
        btnFechar.onclick = fecharSantinhos;
    }

    renderizarAbasPrincipais();
    renderizarSubAbasECandidato();
}

function renderizarAbasPrincipais() {
    const navContainer = document.getElementById('usSlidesNav');
    if (!navContainer) return;
    navContainer.innerHTML = '';

    abasCargos.forEach((aba, index) => {
        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = `us-tab-btn us-nav-tab ${index === abaAtivaIndex ? 'active' : ''}`;
        btn.innerText = aba.nome;
        btn.onclick = () => {
            abaAtivaIndex = index;
            subIndiceAtual = 0;
            renderizarAbasPrincipais();
            renderizarSubAbasECandidato();
        };
        navContainer.appendChild(btn);
    });
}

function obterInfoPartido(partidoStr) {
    if (!partidoStr) return null;
    const siglaLimpa = partidoStr.split(' ')[0].trim();
    let partidoEncontrado = partidos.find(p => p.sigla === partidoStr || p.sigla === siglaLimpa);
    if (!partidoEncontrado) {
        partidoEncontrado = partidos.find(p => partidoStr.includes(p.sigla) || p.sigla.includes(siglaLimpa));
    }
    return partidoEncontrado;
}

function renderizarSubAbasECandidato() {
    const subNavContainer = document.getElementById('usSubNav');
    const wrapper = document.getElementById('usSantinhoWrapper');
    if (!subNavContainer || !wrapper) return;

    subNavContainer.innerHTML = '';
    wrapper.innerHTML = '';

    const abaAtual = abasCargos[abaAtivaIndex];
    if (!abaAtual) return;
    const listaCandidatos = abaAtual.lista;

    if (!listaCandidatos || listaCandidatos.length === 0) {
        wrapper.innerHTML = '<div style="color:#fff; grid-column: 1/-1; text-align:center; padding: 20px;">Nenhum candidato encontrado.</div>';
        return;
    }

    // Sub-aba para exibir Todos os Candidatos do Cargo
    const btnTodos = document.createElement('button');
    btnTodos.type = 'button';
    btnTodos.className = `us-sub-tab ${subIndiceAtual === 0 ? 'active' : ''}`;
    btnTodos.innerText = `Todos (${listaCandidatos.length})`;
    btnTodos.onclick = () => {
        subIndiceAtual = 0;
        renderizarSubAbasECandidato();
    };
    subNavContainer.appendChild(btnTodos);

    // Sub-abas para cada candidato individual
    listaCandidatos.forEach((cand, idx) => {
        const subBtn = document.createElement('button');
        subBtn.type = 'button';
        subBtn.className = `us-sub-tab ${idx + 1 === subIndiceAtual ? 'active' : ''}`;
        subBtn.innerText = `${cand.numero} - ${cand.nome}`;
        subBtn.onclick = () => {
            subIndiceAtual = idx + 1;
            renderizarSubAbasECandidato();
        };
        subNavContainer.appendChild(subBtn);
    });

    // Determina se exibe todos ou um candidato específico
    const candidatosExibir = (subIndiceAtual === 0)
        ? listaCandidatos
        : [listaCandidatos[subIndiceAtual - 1]];

    candidatosExibir.forEach(candidatoSelecionado => {
        if (!candidatoSelecionado) return;
        const coligacaoItens = obterDadosColigacao(candidatoSelecionado, abaAtual.tipo);

        const dadosPartido = obterInfoPartido(candidatoSelecionado.partido);
        const nomePartidoExibir = dadosPartido ? `${dadosPartido.nome} (${dadosPartido.sigla})` : (candidatoSelecionado.partido || 'PARTIDO');
        const sloganExibir = candidatoSelecionado.slogan || (dadosPartido ? dadosPartido.slogan : '');
        const propostasLista = (candidatoSelecionado.propostas && candidatoSelecionado.propostas.length > 0)
            ? candidatoSelecionado.propostas
            : (dadosPartido ? dadosPartido.propostas : []);

        let coligacaoHtml = '';
        if (coligacaoItens.length > 0) {
            const itensHtml = coligacaoItens.map(c => `
                <div class="us-item-cargo">
                    <div class="us-info-mini">
                        <img src="${buscarCandidatoPorNumero(c.numero, c.cargo)?.fotoCandidato || c.foto || ''}" class="us-mini-foto" alt="${c.nome}">
                        <span>${c.cargo}: <b>${c.nome}</b></span>
                    </div>
                    <span class="us-numero-item">${c.numero}</span>
                </div>
            `).join('');

            coligacaoHtml = `<div class="us-lista-coligacao">${itensHtml}</div>`;
        }

        let propostasHtml = '';
        if (propostasLista && propostasLista.length > 0) {
            const itensPropostas = propostasLista.map(p => `<li>${p}</li>`).join('');
            propostasHtml = `
                <div class="us-propostas-box">
                    <div class="us-propostas-titulo">Principais Propostas:</div>
                    <ul>${itensPropostas}</ul>
                </div>
            `;
        }

        const santinhoDiv = document.createElement('div');
        santinhoDiv.className = 'us-santinho';
        santinhoDiv.innerHTML = `
            <div class="us-header">COLIGAÇÃO ELEITORAL</div>
            <div class="us-candidato-principal">
                <div class="us-cargo">${abaAtual.nome}</div>
                <img src="${candidatoSelecionado.fotoCandidato || candidatoSelecionado.foto || ''}" alt="${candidatoSelecionado.nome}">
                <div class="us-nome-principal">${candidatoSelecionado.nome}</div>
                <div class="us-numero-principal">${candidatoSelecionado.numero}</div>
                <div class="us-nome-partido">${nomePartidoExibir}</div>
                ${sloganExibir ? `<div class="us-slogan">"${sloganExibir}"</div>` : ''}
            </div>
            ${propostasHtml}
            ${coligacaoHtml}
            <div class="us-footer">Vote consciente • Eleições</div>
        `;

        wrapper.appendChild(santinhoDiv);
    });
}

function mudarAbaCargo(direcao) {
    abaAtivaIndex += direcao;
    if (abaAtivaIndex < 0) {
        abaAtivaIndex = abasCargos.length - 1;
    } else if (abaAtivaIndex >= abasCargos.length) {
        abaAtivaIndex = 0;
    }
    subIndiceAtual = 0;
    renderizarAbasPrincipais();
    renderizarSubAbasECandidato();
}

window.onload = () => {
    slides = document.getElementsByClassName("slide");
    abasCargos = obterAbasCargos();
    renderizarAbasPrincipais();
    renderizarSubAbasECandidato();

    if (typeof i18n !== 'undefined') {
        i18n.aoMudarIdioma(() => {
            abasCargos = obterAbasCargos();
            renderizarAbasPrincipais();
            renderizarSubAbasECandidato();
        });
    }
};
