const PRESIDENTES = [
    // 1. Chapa Elétrica Coligada
    new Candidato(
        "65",
        "Pikachu",
        "POKPELE",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png",
        "Totodile",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/158.png"
    ),

    // 2. Chapa de Água Coligada
    new Candidato(
        "63",
        "Squirtle",
        "POKPAGU",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png",
        "Bulbasaur",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    ),

    // 3. Chapa de Fogo Coligada
    new Candidato(
        "62",
        "Charmander",
        "POKPFGO",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png",
        "Flareon",
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/136.png"
    )
];

if (typeof module !== 'undefined' && module.exports) {
    module.exports = PRESIDENTES;
}
