/**
 * ==============================================================================
 * SISTEMA INTERNACIONALIZAÇÃO (i18n) • URNA ELETRÔNICA POKÉMON
 * Suporta 4 idiomas com detecção automática do navegador:
 *  - Português (pt)
 *  - Inglês (en)
 *  - Espanhol (es)
 *  - Italiano (it)
 * ==============================================================================
 */

const I18N_IDIOMAS_SUPORTADOS = ['pt', 'en', 'es', 'it'];

const I18N_DICIONARIOS = {
    pt: {
        codigo: 'pt',
        nome: 'Português',
        bandeira: '🇧🇷',
        // Títulos de páginas
        page_title_urna: 'Urna Eletrônica • Eleições Pokémon',
        page_title_apuracao: 'Apuração Eleições Pokémon 2026 • Em Tempo Real',

        // Tela da Urna (Slides)
        treinamento: 'TREINAMENTO',
        cargo_deputado_federal: 'DEPUTADO FEDERAL',
        cargo_deputado_estadual: 'DEPUTADO ESTADUAL',
        cargo_senador_1: '1º SENADOR',
        cargo_senador_2: '2º SENADOR',
        cargo_governador: 'GOVERNADOR',
        cargo_presidente: 'PRESIDENTE',

        // Rótulos de campos
        rotulo_numero: 'Número:',
        rotulo_nome: 'Nome:',
        rotulo_partido: 'Partido:',
        rotulo_vice_governador: 'Vice-governador:',
        rotulo_vice_presidente: 'Vice-presidente:',

        // Instruções de rodapé da urna
        instrucao_aperte: 'Aperte a tecla:',
        instrucao_verde: 'VERDE para CONFIRMAR este voto',
        instrucao_vermelho: 'LARANJA para CORRIGIR este voto',
        instrucao_branco: 'BRANCO para votar em BRANCO',

        // Teclado físico / virtual
        btn_branco: 'BRANCO',
        btn_corrige: 'CORRIGE',
        btn_confirma: 'CONFIRMA',
        btn_santinhos: '📋 SANTINHOS DE CANDIDATOS',

        // Votos especiais
        voto_em_branco: 'VOTO EM BRANCO',
        voto_nulo: 'VOTO NULO',

        // Modal de finalização
        voto_finalizado_titulo: 'Voto Finalizado',
        voto_finalizado_msg: 'Obrigado por participar do treinamento.',
        btn_reiniciar: 'Reiniciar Treinamento',
        btn_apuracao: '📊 Apuração dos Votos',

        // Modal de Santinhos
        santinhos_titulo: 'Santinhos de Candidatos',
        santinhos_fechar: 'Fechar',
        tab_deputados_estaduais: 'Deputados Estaduais',
        tab_deputados_federais: 'Deputados Federais',
        tab_senador_1: '1º Senador',
        tab_senador_2: '2º Senador',
        tab_governador: 'Governador',
        tab_presidente: 'Presidente',
        rotulo_coligacao: 'Coligação:',
        rotulo_vice: 'Vice:',

        // Apuração ao Vivo
        ao_vivo: 'AO VIVO',
        btn_atualizar: '🔄 Atualizar',
        btn_ir_urna: '🗳️ Ir para a Urna',
        subtitulo_apuracao: 'APURAÇÃO EM TEMPO REAL - ELEIÇÕES 2026',
        cargo_nome_presidente_br: 'PRESIDENTE DO BRASIL',
        cargo_nome_governador_est: 'GOVERNADOR DO ESTADO',
        cargo_nome_senador_1_rep: '1º SENADOR DA REPÚBLICA',
        cargo_nome_senador_2_rep: '2º SENADOR DA REPÚBLICA',
        cargo_nome_deputado_fed: 'DEPUTADO FEDERAL',
        cargo_nome_deputado_est: 'DEPUTADO ESTADUAL',
        urnas_apuradas: 'DE URNAS APURADAS',
        resumo_validos: 'Válidos:',
        resumo_brancos: 'Brancos:',
        resumo_nulos: 'Nulos:',
        resumo_total: 'Total:',
        voto_singular: 'voto',
        votos_plural: 'votos',
        todos_candidatos: 'Todos os Candidatos do Cargo',
        cargo_anterior: 'Cargo anterior',
        proximo_cargo: 'Próximo cargo',
        seletor_idioma: 'Idioma'
    },

    en: {
        codigo: 'en',
        nome: 'English',
        bandeira: '🇺🇸',
        page_title_urna: 'Electronic Voting Machine • Pokémon Elections',
        page_title_apuracao: 'Pokémon 2026 Elections Tally • Live Results',

        treinamento: 'TRAINING',
        cargo_deputado_federal: 'FEDERAL REPRESENTATIVE',
        cargo_deputado_estadual: 'STATE REPRESENTATIVE',
        cargo_senador_1: '1ST SENATOR',
        cargo_senador_2: '2ND SENATOR',
        cargo_governador: 'GOVERNOR',
        cargo_presidente: 'PRESIDENT',

        rotulo_numero: 'Number:',
        rotulo_nome: 'Name:',
        rotulo_partido: 'Party:',
        rotulo_vice_governador: 'Lt. Governor:',
        rotulo_vice_presidente: 'Vice President:',

        instrucao_aperte: 'Press key:',
        instrucao_verde: 'GREEN to CONFIRM this vote',
        instrucao_vermelho: 'ORANGE to CORRECT this vote',
        instrucao_branco: 'WHITE to cast a BLANK vote',

        btn_branco: 'BLANK',
        btn_corrige: 'CORRECT',
        btn_confirma: 'CONFIRM',
        btn_santinhos: '📋 CANDIDATE CHEAT SHEET',

        voto_em_branco: 'BLANK VOTE',
        voto_nulo: 'NULL VOTE',

        voto_finalizado_titulo: 'Voting Completed',
        voto_finalizado_msg: 'Thank you for participating in the training session.',
        btn_reiniciar: 'Restart Training',
        btn_apuracao: '📊 Live Results Tally',

        santinhos_titulo: 'Candidate Cheat Sheet',
        santinhos_fechar: 'Close',
        tab_deputados_estaduais: 'State Representatives',
        tab_deputados_federais: 'Federal Representatives',
        tab_senador_1: '1st Senator',
        tab_senador_2: '2nd Senator',
        tab_governador: 'Governor',
        tab_presidente: 'President',
        rotulo_coligacao: 'Coalition:',
        rotulo_vice: 'Vice:',

        ao_vivo: 'LIVE',
        btn_atualizar: '🔄 Refresh',
        btn_ir_urna: '🗳️ Go to Ballot Box',
        subtitulo_apuracao: 'REAL-TIME VOTE TALLY - 2026 ELECTIONS',
        cargo_nome_presidente_br: 'PRESIDENT OF BRAZIL',
        cargo_nome_governador_est: 'STATE GOVERNOR',
        cargo_nome_senador_1_rep: '1ST SENATOR OF THE REPUBLIC',
        cargo_nome_senador_2_rep: '2ND SENATOR OF THE REPUBLIC',
        cargo_nome_deputado_fed: 'FEDERAL REPRESENTATIVE',
        cargo_nome_deputado_est: 'STATE REPRESENTATIVE',
        urnas_apuradas: 'OF BALLOT BOXES TALLIED',
        resumo_validos: 'Valid:',
        resumo_brancos: 'Blank:',
        resumo_nulos: 'Null:',
        resumo_total: 'Total:',
        voto_singular: 'vote',
        votos_plural: 'votes',
        todos_candidatos: 'All Candidates for this Office',
        cargo_anterior: 'Previous office',
        proximo_cargo: 'Next office',
        seletor_idioma: 'Language'
    },

    es: {
        codigo: 'es',
        nome: 'Español',
        bandeira: '🇪🇸',
        page_title_urna: 'Urna Electrónica • Elecciones Pokémon',
        page_title_apuracao: 'Escrutinio Elecciones Pokémon 2026 • En Tiempo Real',

        treinamento: 'ENTRENAMIENTO',
        cargo_deputado_federal: 'DIPUTADO FEDERAL',
        cargo_deputado_estadual: 'DIPUTADO ESTATAL',
        cargo_senador_1: '1º SENADOR',
        cargo_senador_2: '2º SENADOR',
        cargo_governador: 'GOBERNADOR',
        cargo_presidente: 'PRESIDENTE',

        rotulo_numero: 'Número:',
        rotulo_nome: 'Nombre:',
        rotulo_partido: 'Partido:',
        rotulo_vice_governador: 'Vicegobernador:',
        rotulo_vice_presidente: 'Vicepresidente:',

        instrucao_aperte: 'Presione la tecla:',
        instrucao_verde: 'VERDE para CONFIRMAR este voto',
        instrucao_vermelho: 'NARANJA para CORREGIR este voto',
        instrucao_branco: 'BLANCO para votar en BLANCO',

        btn_branco: 'BLANCO',
        btn_corrige: 'CORRIGE',
        btn_confirma: 'CONFIRMA',
        btn_santinhos: '📋 LISTA DE CANDIDATOS',

        voto_em_branco: 'VOTO EN BLANCO',
        voto_nulo: 'VOTO NULO',

        voto_finalizado_titulo: 'Votación Finalizada',
        voto_finalizado_msg: 'Gracias por participar en el entrenamiento.',
        btn_reiniciar: 'Reiniciar Entrenamiento',
        btn_apuracao: '📊 Escrutinio de Votos',

        santinhos_titulo: 'Lista de Candidatos',
        santinhos_fechar: 'Cerrar',
        tab_deputados_estaduais: 'Diputados Estatales',
        tab_deputados_federais: 'Diputados Federales',
        tab_senador_1: '1º Senador',
        tab_senador_2: '2º Senador',
        tab_governador: 'Gobernador',
        tab_presidente: 'Presidente',
        rotulo_coligacao: 'Coalición:',
        rotulo_vice: 'Vice:',

        ao_vivo: 'EN VIVO',
        btn_atualizar: '🔄 Actualizar',
        btn_ir_urna: '🗳️ Ir a la Urna',
        subtitulo_apuracao: 'ESCRUTINIO EN TIEMPO REAL - ELECCIONES 2026',
        cargo_nome_presidente_br: 'PRESIDENTE DE BRASIL',
        cargo_nome_governador_est: 'GOBERNADOR DEL ESTADO',
        cargo_nome_senador_1_rep: '1º SENADOR DE LA REPÚBLICA',
        cargo_nome_senador_2_rep: '2º SENADOR DE LA REPÚBLICA',
        cargo_nome_deputado_fed: 'DIPUTADO FEDERAL',
        cargo_nome_deputado_est: 'DIPUTADO ESTATAL',
        urnas_apuradas: 'DE URNAS ESCRUTADAS',
        resumo_validos: 'Válidos:',
        resumo_brancos: 'Blancos:',
        resumo_nulos: 'Nulos:',
        resumo_total: 'Total:',
        voto_singular: 'voto',
        votos_plural: 'votos',
        todos_candidatos: 'Todos los Candidatos del Cargo',
        cargo_anterior: 'Cargo anterior',
        proximo_cargo: 'Próximo cargo',
        seletor_idioma: 'Idioma'
    },

    it: {
        codigo: 'it',
        nome: 'Italiano',
        bandeira: '🇮🇹',
        page_title_urna: 'Urna Elettronica • Elezioni Pokémon',
        page_title_apuracao: 'Scrutinio Elezioni Pokémon 2026 • In Tempo Reale',

        treinamento: 'ADDESTRAMENTO',
        cargo_deputado_federal: 'DEPUTATO FEDERALE',
        cargo_deputado_estadual: 'DEPUTATO STATALE',
        cargo_senador_1: '1º SENATORE',
        cargo_senador_2: '2º SENATORE',
        cargo_governador: 'GOVERNATORE',
        cargo_presidente: 'PRESIDENTE',

        rotulo_numero: 'Numero:',
        rotulo_nome: 'Nome:',
        rotulo_partido: 'Partito:',
        rotulo_vice_governador: 'Vicegovernatore:',
        rotulo_vice_presidente: 'Vicepresidente:',

        instrucao_aperte: 'Premi il tasto:',
        instrucao_verde: 'VERDE per CONFERMARE questo voto',
        instrucao_vermelho: 'ARANCIONE per CORREGGERE questo voto',
        instrucao_branco: 'BIANCO per votare SCHEDA BIANCA',

        btn_branco: 'BIANCO',
        btn_corrige: 'CORREGGI',
        btn_confirma: 'CONFERMA',
        btn_santinhos: '📋 PROMEMORIA CANDIDATI',

        voto_em_branco: 'SCHEDA BIANCA',
        voto_nulo: 'SCHEDA NULLA',

        voto_finalizado_titulo: 'Votazione Completata',
        voto_finalizado_msg: "Grazie per aver partecipato all'addestramento.",
        btn_reiniciar: 'Riavvia Addestramento',
        btn_apuracao: '📊 Scrutinio dei Voti',

        santinhos_titulo: 'Promemoria Candidati',
        santinhos_fechar: 'Chiudi',
        tab_deputados_estaduais: 'Deputati Statali',
        tab_deputados_federais: 'Deputati Federali',
        tab_senador_1: '1º Senatore',
        tab_senador_2: '2º Senatore',
        tab_governador: 'Governatore',
        tab_presidente: 'Presidente',
        rotulo_coligacao: 'Coalizione:',
        rotulo_vice: 'Vice:',

        ao_vivo: 'DAL VIVO',
        btn_atualizar: '🔄 Aggiorna',
        btn_ir_urna: '🗳️ Vai alla Cabina',
        subtitulo_apuracao: 'SCRUTINIO IN TEMPO REALE - ELEZIONI 2026',
        cargo_nome_presidente_br: 'PRESIDENTE DEL BRASILE',
        cargo_nome_governador_est: 'GOVERNATORE DELLO STATO',
        cargo_nome_senador_1_rep: '1º SENATORE DELLA REPUBBLICA',
        cargo_nome_senador_2_rep: '2º SENATORE DELLA REPUBBLICA',
        cargo_nome_deputado_fed: 'DEPUTATO FEDERALE',
        cargo_nome_deputado_est: 'DEPUTATO STATALE',
        urnas_apuradas: 'DI URNE SCRUTINATE',
        resumo_validos: 'Validi:',
        resumo_brancos: 'Bianche:',
        resumo_nulos: 'Nulle:',
        resumo_total: 'Totale:',
        voto_singular: 'voto',
        votos_plural: 'voti',
        todos_candidatos: 'Tutti i Candidati della Carica',
        cargo_anterior: 'Carica precedente',
        proximo_cargo: 'Prossima carica',
        seletor_idioma: 'Lingua'
    }
};

class I18nManager {
    constructor() {
        this.listeners = [];
        this.idiomaAtual = this.detectarIdioma();
    }

    /**
     * Detecta automaticamente o idioma baseado no navegador ou escolha salva
     */
    detectarIdioma() {
        // 1. Preferência explícita salva anteriormente
        const salvo = localStorage.getItem('urna_i18n_lang');
        if (salvo && I18N_IDIOMAS_SUPORTADOS.includes(salvo.toLowerCase())) {
            return salvo.toLowerCase();
        }

        // 2. Detecção automática das preferências de idioma do navegador
        const idiomasNavegador = navigator.languages || [navigator.language || navigator.userLanguage || ''];
        for (const lang of idiomasNavegador) {
            if (!lang) continue;
            const prefixo = String(lang).toLowerCase().slice(0, 2);
            if (I18N_IDIOMAS_SUPORTADOS.includes(prefixo)) {
                return prefixo;
            }
        }

        // 3. Padrão se não for detectado pt, es ou it
        return 'en';
    }

    /**
     * Altera o idioma ativo, persiste no localStorage e notifica observadores
     */
    definirIdioma(novoIdioma) {
        if (!I18N_IDIOMAS_SUPORTADOS.includes(novoIdioma)) return;
        this.idiomaAtual = novoIdioma;
        localStorage.setItem('urna_i18n_lang', novoIdioma);
        document.documentElement.lang = novoIdioma;

        this.aplicarTraducoesDOM();
        this.atualizarSeletorVisual();

        // Notifica callbacks registrados
        this.listeners.forEach(fn => {
            try { fn(novoIdioma); } catch (e) { console.error("Erro listener i18n:", e); }
        });
    }

    /**
     * Retorna a tradução da chave fornecida
     */
    t(chave, params = {}) {
        const dic = I18N_DICIONARIOS[this.idiomaAtual] || I18N_DICIONARIOS.en;
        let texto = dic[chave] || (I18N_DICIONARIOS.en[chave] || chave);

        // Substituição de parâmetros {chave}
        for (const [k, v] of Object.entries(params)) {
            texto = texto.replace(new RegExp(`\\{${k}\\}`, 'g'), v);
        }
        return texto;
    }

    /**
     * Registra callback para atualizações dinâmicas
     */
    aoMudarIdioma(callback) {
        if (typeof callback === 'function') {
            this.listeners.push(callback);
        }
    }

    /**
     * Traduz todos os elementos do DOM com o atributo data-i18n
     */
    aplicarTraducoesDOM() {
        document.documentElement.lang = this.idiomaAtual;

        // Tradução de elementos com data-i18n
        const elementos = document.querySelectorAll('[data-i18n]');
        elementos.forEach(el => {
            const chave = el.getAttribute('data-i18n');
            const attr = el.getAttribute('data-i18n-attr');
            const texto = this.t(chave);

            if (attr) {
                el.setAttribute(attr, texto);
            } else if (el.tagName === 'INPUT' && el.type === 'button') {
                el.value = texto;
            } else {
                el.textContent = texto;
            }
        });

        // Tradução do título da página se existir chave no body/head
        const pageTitleKey = document.body && document.body.getAttribute('data-i18n-title');
        if (pageTitleKey) {
            document.title = this.t(pageTitleKey);
        }
    }

    /**
     * Atualiza o estado visual do componente de seleção de idioma
     */
    atualizarSeletorVisual() {
        const selects = document.querySelectorAll('.urna-lang-select');
        selects.forEach(select => {
            if (select.value !== this.idiomaAtual) {
                select.value = this.idiomaAtual;
            }
        });

        const btns = document.querySelectorAll('.urna-lang-btn');
        btns.forEach(btn => {
            const lang = btn.getAttribute('data-lang');
            if (lang === this.idiomaAtual) {
                btn.classList.add('active');
            } else {
                btn.classList.remove('active');
            }
        });
    }

    /**
     * Injeta widget discreto e elegante de troca de idioma caso não exista no HTML
     */
    injetarWidgetSeletor(containerId = null) {
        if (document.getElementById('urna-i18n-widget')) return;

        const widget = document.createElement('div');
        widget.id = 'urna-i18n-widget';
        widget.className = 'urna-i18n-widget';
        widget.innerHTML = `
            <div class="i18n-widget-inner">
                <span class="i18n-globe-icon" title="Select Language">🌐</span>
                <select class="urna-lang-select" aria-label="Select Language" onchange="i18n.definirIdioma(this.value)">
                    <option value="en">🇺🇸 EN</option>
                    <option value="pt">🇧🇷 PT</option>
                    <option value="es">🇪🇸 ES</option>
                    <option value="it">🇮🇹 IT</option>
                </select>
            </div>
        `;

        if (containerId && document.getElementById(containerId)) {
            document.getElementById(containerId).appendChild(widget);
        } else {
            document.body.appendChild(widget);
        }

        this.atualizarSeletorVisual();
    }
}

// Instância global
const i18n = new I18nManager();

// Atalho global conveniente
const _t = (chave, params) => i18n.t(chave, params);

// Inicialização automática ao carregar o DOM
document.addEventListener('DOMContentLoaded', () => {
    i18n.aplicarTraducoesDOM();
    i18n.injetarWidgetSeletor();
});
