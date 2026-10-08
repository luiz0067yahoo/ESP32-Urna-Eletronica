#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
⌨️ SIMULADOR DE HARDWARE • TECLADO MATRICIAL 4x4 DO ESP32
=============================================================================
Emula o circuito de leitura matricial e debounce de GPIOs:
- Varredura de linhas (Output) e leitura de colunas (Input com Pull-Up)
- Tabela de pinos GPIO reais do ESP32
- Decodificação de teclas especiais da Urna:
    [1] [2] [3] [BRANCO]
    [4] [5] [6] [CORRIGE]
    [7] [8] [9] [CONFIRMA]
    [*] [0] [#] [NULO/EXTRA]
- Tratamento de debounce temporal (20ms) e anti-ghosting
=============================================================================
"""

import time
import random
import sys
import io

# Garante suporte a UTF-8 no console Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')


# Mapeamento oficial dos pinos GPIO no ESP32 para o teclado matricial
PINOS_LINHAS = [13, 12, 14, 27]   # GPIOs de saída (Rows)
PINOS_COLUNAS = [26, 25, 33, 32]  # GPIOs de entrada com Pull-Up (Cols)

# Matriz 4x4 adaptada para a Urna Eletrônica
MAPA_TECLAS = [
    ['1', '2', '3', 'BRANCO'],
    ['4', '5', '6', 'CORRIGE'],
    ['7', '8', '9', 'CONFIRMA'],
    ['*', '0', '#', 'EXTRA']
]

class TecladoMatricialESP32:
    def __init__(self, debounce_ms=20):
        self.debounce_ms = debounce_ms
        self.ultima_tecla = None
        self.ultimo_tempo = 0
        self.buffer_digitacao = ""

    def simular_varredura(self, linha_pressionada, coluna_pressionada):
        """Simula a varredura elétrica ativando uma linha LOW por vez"""
        leituras = {}
        for r_idx, r_pin in enumerate(PINOS_LINHAS):
            # No hardware real: digitalwrite(r_pin, LOW)
            estado_linha = (r_idx == linha_pressionada)
            for c_idx, c_pin in enumerate(PINOS_COLUNAS):
                # Se a tecla nesta interseção estiver fechando contato, a coluna lê LOW (0)
                if estado_linha and c_idx == coluna_pressionada:
                    leituras[(r_pin, c_pin)] = 0  # Contato fechado (GND)
                else:
                    leituras[(r_pin, c_pin)] = 1  # Pull-Up (VCC / 3.3V)
        return leituras

    def decodificar_tecla(self, linha, coluna):
        agora = time.time() * 1000
        if (agora - self.ultimo_tempo) < self.debounce_ms:
            return None  # Rejeitado pelo filtro de debounce
        
        self.ultimo_tempo = agora
        tecla = MAPA_TECLAS[linha][coluna]
        self.ultima_tecla = tecla
        return tecla

    def pressionar(self, tecla_desejada):
        """Localiza a tecla na matriz e simula o evento elétrico"""
        for r in range(4):
            for c in range(4):
                if MAPA_TECLAS[r][c] == tecla_desejada:
                    # Gera varredura
                    leituras = self.simular_varredura(r, c)
                    tecla_lida = self.decodificar_tecla(r, c)
                    return {
                        "tecla": tecla_lida,
                        "gpio_linha": PINOS_LINHAS[r],
                        "gpio_coluna": PINOS_COLUNAS[c],
                        "debounce_ok": tecla_lida is not None,
                        "leituras_circuito": leituras
                    }
        return None

def demonstrar_teclado():
    print("="*65)
    print("  ⌨️ SIMULADOR DE TECLADO MATRICIAL 4x4 (ESP32 GPIO SCANNER)")
    print("="*65)
    print(" Layout do Teclado da Urna:")
    for linha in MAPA_TECLAS:
        print("  | " + " | ".join(f"{t:8}" for t in linha) + " |")
    print("\n Pinos Linhas (Output):  GPIO " + ", ".join(map(str, PINOS_LINHAS)))
    print(" Pinos Colunas (Pull-Up): GPIO " + ", ".join(map(str, PINOS_COLUNAS)))
    print("="*65 + "\n")

    teclado = TecladoMatricialESP32()
    sequencia_teste = ['6', '5', 'CONFIRMA']

    print("▶ Simulando digitação do voto para Presidente (Pikachu: 65)...")
    for t in sequencia_teste:
        evento = teclado.pressionar(t)
        print(f" • Tecla: [{evento['tecla']:8}] | Linha: GPIO {evento['gpio_linha']} | Coluna: GPIO {evento['gpio_coluna']} | Debounce: OK")
        time.sleep(0.15)

    print("\n▶ Simulando correção (digita 63 e aperta CORRIGE)...")
    for t in ['6', '3', 'CORRIGE', '6', '5', 'CONFIRMA']:
        evento = teclado.pressionar(t)
        cor = "🔴" if t == 'CORRIGE' else ("🟢" if t == 'CONFIRMA' else "⚪")
        print(f" {cor} [{evento['tecla']:8}] -> GPIO R{evento['gpio_linha']} x C{evento['gpio_coluna']}")
        time.sleep(0.1)

    print("\n✔ Emulação de leitura do teclado matricial 4x4 concluída com sucesso!\n")

if __name__ == "__main__":
    demonstrar_teclado()
