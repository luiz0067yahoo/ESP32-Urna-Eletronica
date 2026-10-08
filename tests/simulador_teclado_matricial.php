<?php
/**
 * =============================================================================
 * ⌨️ SIMULADOR DE TECLADO VIRTUAL & VALIDADOR DE VOTOS (100% PHP)
 * Urna Eletrônica Pokémon • Eleições 2026
 * =============================================================================
 * Emula a lógica de entrada e validação eleitoral por software:
 * - Validação da máscara de dígitos por cargo eleitoral:
 *     * Deputado Estadual: 5 dígitos
 *     * Deputado Federal:  4 dígitos
 *     * Senador:           3 dígitos
 *     * Governador:        2 dígitos
 *     * Presidente:        2 dígitos
 * - Controle das teclas de ação (BRANCO, CORRIGE, CONFIRMA)
 * - Filtro de debounce por software contra duplos cliques acidentais
 * =============================================================================
 */

class TecladoVirtualUrna {
    private $regrasCargos = [
        "DEPUTADO ESTADUAL" => ["digitos" => 5, "exemplo" => "90101"],
        "DEPUTADO FEDERAL"  => ["digitos" => 4, "exemplo" => "9101"],
        "1º SENADOR"        => ["digitos" => 3, "exemplo" => "701"],
        "2º SENADOR"        => ["digitos" => 3, "exemplo" => "751"],
        "GOVERNADOR"        => ["digitos" => 2, "exemplo" => "81"],
        "PRESIDENTE"        => ["digitos" => 2, "exemplo" => "65"]
    ];

    private $layoutTeclado = [
        ['1', '2', '3', 'BRANCO'],
        ['4', '5', '6', 'CORRIGE'],
        ['7', '8', '9', 'CONFIRMA'],
        [' ', '0', ' ', ' ']
    ];

    private $debounceMs;
    private $ultimoTempo = 0;
    private $bufferVoto = "";
    private $modoBranco = false;
    private $cargoAtual = "PRESIDENTE";

    public function __construct($debounceMs = 100) {
        $this->debounceMs = $debounceMs;
    }

    public function getRegras() {
        return $this->regrasCargos;
    }

    public function getLayout() {
        return $this->layoutTeclado;
    }

    public function definirCargo($cargo) {
        if (isset($this->regrasCargos[$cargo])) {
            $this->cargoAtual = $cargo;
            $this->limpar();
        }
    }

    public function limpar() {
        $this->bufferVoto = "";
        $this->modoBranco = false;
    }

    public function pressionar($tecla) {
        $agora = microtime(true) * 1000;
        if (($agora - $this->ultimoTempo) < $this->debounceMs) {
            return ["status" => "IGNORADO", "motivo" => "Debounce de software ativo"];
        }
        $this->ultimoTempo = $agora;
        $tecla = strtoupper(trim($tecla));

        if ($tecla === "CORRIGE") {
            $this->limpar();
            return ["status" => "CORRIGIDO", "buffer" => "", "mensagem" => "Buffer apagado. Digite novamente."];
        }

        if ($tecla === "BRANCO") {
            if (strlen($this->bufferVoto) > 0) {
                return ["status" => "AVISO", "buffer" => $this->bufferVoto, "mensagem" => "Para votar em BRANCO, pressione CORRIGE antes."];
            }
            $this->modoBranco = true;
            return ["status" => "BRANCO_SELECIONADO", "buffer" => "BRANCO", "mensagem" => "Voto em BRANCO selecionado. Pressione CONFIRMA."];
        }

        if ($tecla === "CONFIRMA") {
            if ($this->modoBranco) {
                return ["status" => "VOTO_CONFIRMADO", "valor" => "BRANCO", "mensagem" => "Voto em BRANCO aceito."];
            }

            $maxDigitos = $this->regrasCargos[$this->cargoAtual]["digitos"];
            $tamanhoAtual = strlen($this->bufferVoto);
            if ($tamanhoAtual < $maxDigitos) {
                $faltam = $maxDigitos - $tamanhoAtual;
                return ["status" => "INCOMPLETO", "buffer" => $this->bufferVoto, "mensagem" => "Cargo {$this->cargoAtual} requer {$maxDigitos} dígitos! Faltam {$faltam}."];
            }

            $valor = $this->bufferVoto;
            $this->limpar();
            return ["status" => "VOTO_CONFIRMADO", "valor" => $valor, "mensagem" => "Voto {$valor} confirmado com sucesso!"];
        }

        if (ctype_digit($tecla)) {
            if ($this->modoBranco) {
                return ["status" => "AVISO", "buffer" => "BRANCO", "mensagem" => "Pressione CORRIGE antes de digitar números."];
            }

            $maxDigitos = $this->regrasCargos[$this->cargoAtual]["digitos"];
            if (strlen($this->bufferVoto) < $maxDigitos) {
                $this->bufferVoto .= $tecla;
                $len = strlen($this->bufferVoto);
                return ["status" => "DIGITANDO", "buffer" => $this->bufferVoto, "mensagem" => "Dígito [{$tecla}] inserido ({$len}/{$maxDigitos})"];
            } else {
                return ["status" => "CHEIO", "buffer" => $this->bufferVoto, "mensagem" => "Limite de {$maxDigitos} dígitos já atingido. Pressione CONFIRMA ou CORRIGE."];
            }
        }

        return ["status" => "INVALIDO", "mensagem" => "Tecla [{$tecla}] não reconhecida."];
    }
}

// Demonstração CLI
echo "=====================================================================\n";
echo "  ⌨️ SIMULADOR DE TECLADO VIRTUAL & VALIDADOR DE VOTOS (100% PHP)\n";
echo "=====================================================================\n";
$teclado = new TecladoVirtualUrna();

echo " Layout do Teclado Digital:\n";
foreach ($teclado->getLayout() as $linha) {
    echo "  | " . implode(" | ", array_map(function($t) { return sprintf("%-8s", $t); }, $linha)) . " |\n";
}

echo "\n Regras Eleitorais de Dígitos por Cargo:\n";
foreach ($teclado->getRegras() as $cargo => $info) {
    printf("  • %-20s: %d dígitos (ex: %s)\n", $cargo, $info['digitos'], $info['exemplo']);
}
echo "=====================================================================\n\n";

echo "▶ 1. Testando digitação e confirmação válida para Presidente (2 dígitos: 65)...\n";
$teclado->definirCargo("PRESIDENTE");
foreach (['6', '5', 'CONFIRMA'] as $t) {
    $res = $teclado->pressionar($t);
    printf(" • Tecla [%-8s] -> Status: %-16s | Msg: %s\n", $t, $res['status'], $res['mensagem']);
    usleep(50000);
}

echo "\n▶ 2. Testando tentativa de confirmação com dígitos incompletos (Deputado Federal: 4 dígitos)...\n";
$teclado->definirCargo("DEPUTADO FEDERAL");
foreach (['9', '1', 'CONFIRMA'] as $t) {
    $res = $teclado->pressionar($t);
    printf(" • Tecla [%-8s] -> Status: %-16s | Msg: %s\n", $t, $res['status'], $res['mensagem']);
    usleep(50000);
}

echo "\n▶ 3. Corrigindo com CORRIGE e completando com 9101:\n";
foreach (['CORRIGE', '9', '1', '0', '1', 'CONFIRMA'] as $t) {
    $res = $teclado->pressionar($t);
    printf(" • Tecla [%-8s] -> Status: %-16s | Msg: %s\n", $t, $res['status'], $res['mensagem']);
    usleep(50000);
}

echo "\n▶ 4. Testando voto em BRANCO para Governador:\n";
$teclado->definirCargo("GOVERNADOR");
foreach (['BRANCO', 'CONFIRMA'] as $t) {
    $res = $teclado->pressionar($t);
    printf(" • Tecla [%-8s] -> Status: %-16s | Msg: %s\n", $t, $res['status'], $res['mensagem']);
    usleep(50000);
}

echo "\n✔ Validação e emulação de teclado virtual por software concluída com sucesso!\n\n";
