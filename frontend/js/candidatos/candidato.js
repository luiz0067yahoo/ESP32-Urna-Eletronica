class Candidato {
    constructor(numero, nome, partido, fotoCandidato, vice, fotoVice) {
        this.numero = numero;
        this.nome = nome;
        this.partido = partido;
        this.fotoCandidato = fotoCandidato;
        this.vice = vice;
        this.fotoVice = fotoVice;
    }
}

if (typeof module !== 'undefined' && module.exports) {
    module.exports = Candidato;
}
