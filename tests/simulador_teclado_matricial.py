#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
⌨️ SIMULADOR DE TECLADO VIRTUAL & VALIDADOR DE VOTOS • URNA ELETRÔNICA
=============================================================================
Emula a lógica do teclado digital de votação da Urna por software:
- Digitação numérica (0-9) e teclas de ação (BRANCO, CORRIGE, CONFIRMA)
- Validação de máscara de dígitos por cargo eleitoral:
    * Deputado Estadual: 5 dígitos
    * Deputado Federal:  4 dígitos
    * Senador:           3 dígitos
    * Governador:        2 dígitos
    * Presidente:        2 dígitos
- Tratamento de debounce de software (rejeição de duplo clique rápido)
- Feedback sonoro e textual dos estados da cabine eleitoral
=============================================================================
"""

import time
import sys

# Garante suporte a UTF-8 no console Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')


# Regras de preenchimento de dígitos por cargo eleitoral oficial (TSE / Pokémon)
REGRAS_CARGOS = {
    "DEPUTADO ESTADUAL": {"digitos": 5, "exemplo": "11101"},
    "DEPUTADO FEDERAL":  {"digitos": 4, "exemplo": "9101"},
    "1º SENADOR":        {"digitos": 3, "exemplo": "701"},
    "2º SENADOR":        {"digitos": 3, "exemplo": "751"},
    "GOVERNADOR":        {"digitos": 2, "exemplo": "81"},
    "PRESIDENTE":        {"digitos": 2, "exemplo": "65"}
}

# Layout do teclado virtual da Urna Eletrônica
LAYOUT_TECLADO = [
    ['1', '2', '3', 'BRANCO'],
    ['4', '5', '6', 'CORRIGE'],
    ['7', '8', '9', 'CONFIRMA'],
    [' ', '0', ' ', ' ']
]

class TecladoVirtualUrna:
    def __init__(self, debounce_ms=100):
        self.debounce_ms = debounce_ms
        self.ultimo_tempo = 0
        self.buffer_voto = ""
        self.modo_branco = False
        self.cargo_atual = "PRESIDENTE"

    def definir_cargo(self, cargo):
        if cargo in REGRAS_CARGOS:
            self.cargo_atual = cargo
            self.limpar()

    def limpar(self):
        self.buffer_voto = ""
        self.modo_branco = False

    def pressionar(self, tecla):
        agora = time.time() * 1000
        if (agora - self.ultimo_tempo) < self.debounce_ms:
            return {"status": "IGNORADO", "motivo": "Debounce de software ativo"}

        self.ultimo_tempo = agora
        tecla = str(tecla).strip().upper()

        if tecla == "CORRIGE":
            self.limpar()
            return {"status": "CORRIGIDO", "buffer": "", "mensagem": "Buffer apagado. Digite novamente."}

        if tecla == "BRANCO":
            if len(self.buffer_voto) > 0:
                return {"status": "AVISO", "buffer": self.buffer_voto, "mensagem": "Para votar em BRANCO, limpe os números antes com CORRIGE."}
            self.modo_branco = True
            return {"status": "BRANCO_SELECIONADO", "buffer": "BRANCO", "mensagem": "Voto em BRANCO pré-selecionado. Pressione CONFIRMA."}

        if tecla == "CONFIRMA":
            if self.modo_branco:
                return {"status": "VOTO_CONFIRMADO", "valor": "BRANCO", "mensagem": "Voto em BRANCO aceito."}

            max_digitos = REGRAS_CARGOS[self.cargo_atual]["digitos"]
            if len(self.buffer_voto) < max_digitos:
                return {
                    "status": "INCOMPLETO",
                    "buffer": self.buffer_voto,
                    "mensagem": f"Cargo {self.cargo_atual} requer {max_digitos} dígitos! Faltam {max_digitos - len(self.buffer_voto)}."
                }
            
            valor_voto = self.buffer_voto
            self.limpar()
            return {"status": "VOTO_CONFIRMADO", "valor": valor_voto, "mensagem": f"Voto {valor_voto} confirmado com sucesso!"}

        if tecla.isdigit():
            if self.modo_branco:
                return {"status": "AVISO", "buffer": "BRANCO", "mensagem": "Pressione CORRIGE antes de digitar números."}

            max_digitos = REGRAS_CARGOS[self.cargo_atual]["digitos"]
            if len(self.buffer_voto) < max_digitos:
                self.buffer_voto += tecla
                return {"status": "DIGITANDO", "buffer": self.buffer_voto, "mensagem": f"Dígito [{tecla}] inserido ({len(self.buffer_voto)}/{max_digitos})"}
            else:
                return {"status": "CHEIO", "buffer": self.buffer_voto, "mensagem": f"Limite de {max_digitos} dígitos já atingido. Pressione CONFIRMA ou CORRIGE."}

        return {"status": "INVALIDO", "mensagem": f"Tecla [{tecla}] não reconhecida."}

def demonstrar_teclado():
    print("=" * 65)
    print("  ⌨️ SIMULADOR DE TECLADO VIRTUAL & VALIDADOR DE ENTRADA")
    print("=" * 65)
    print(" Layout do Teclado Digital:")
    for linha in LAYOUT_TECLADO:
        print("  | " + " | ".join(f"{t:8}" for t in linha) + " |")
    print("\n Regras Eleitorais de Dígitos por Cargo:")
    for cargo, info in REGRAS_CARGOS.items():
        print(f"  • {cargo:20}: {info['digitos']} dígitos (ex: {info['exemplo']})")
    print("=" * 65 + "\n")

    teclado = TecladoVirtualUrna()

    print("▶ 1. Testando digitação e confirmação válida para Presidente (2 dígitos: 65)...")
    teclado.definir_cargo("PRESIDENTE")
    for t in ['6', '5', 'CONFIRMA']:
        res = teclado.pressionar(t)
        print(f" • Tecla [{t:8}] -> Status: {res['status']:16} | Msg: {res['mensagem']}")
        time.sleep(0.1)

    print("\n▶ 2. Testando tentativa de confirmação com dígitos incompletos (Deputado Federal: 4 dígitos)...")
    teclado.definir_cargo("DEPUTADO FEDERAL")
    for t in ['9', '1', 'CONFIRMA']:
        res = teclado.pressionar(t)
        print(f" • Tecla [{t:8}] -> Status: {res['status']:16} | Msg: {res['mensagem']}")
        time.sleep(0.1)

    print("\n▶ 3. Corrigindo e completando com 9101:")
    for t in ['CORRIGE', '9', '1', '0', '1', 'CONFIRMA']:
        res = teclado.pressionar(t)
        print(f" • Tecla [{t:8}] -> Status: {res['status']:16} | Msg: {res['mensagem']}")
        time.sleep(0.1)

    print("\n▶ 4. Testando voto em BRANCO:")
    teclado.definir_cargo("GOVERNADOR")
    for t in ['BRANCO', 'CONFIRMA']:
        res = teclado.pressionar(t)
        print(f" • Tecla [{t:8}] -> Status: {res['status']:16} | Msg: {res['mensagem']}")
        time.sleep(0.1)

    print("\n✔ Validação e emulação de teclado virtual por software concluída com sucesso!\n")

if __name__ == "__main__":
    demonstrar_teclado()
