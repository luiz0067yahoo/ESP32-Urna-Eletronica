#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
🤖 SIMULADOR DE FIRMWARE ESP32 • URNA ELETRÔNICA POKÉMON
=============================================================================
Emula com precisão o comportamento do microcontrolador ESP32:
- Conexão Wi-Fi (status simulado, IP e RSSI)
- Leitura do Teclado Matricial (digitação de números, BRANCO, CORRIGE, CONFIRMA)
- Serial / Som Buzzer (bip curto para teclas, intermitente para confirma, trissono para FIM)
- Envio de votos via HTTP POST com payload JSON idêntico ao firmware real
=============================================================================
"""

import urllib.request
import urllib.error
import json
import time
import sys
import random

# Garante suporte a UTF-8 no console Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')


DEFAULT_API_URL = "http://localhost:8080/backend/votos"

# Candidatos Oficiais Pokémon por Cargo
CANDIDATOS_ESP32 = {
    "DEPUTADO ESTADUAL": [
        {"numero": "11101", "nome": "Pichu (POKPELE)"},
        {"numero": "12101", "nome": "Cyndaquil (POKPFGO)"},
        {"numero": "13101", "nome": "Totodile (POKPAGU)"},
    ],
    "DEPUTADO FEDERAL": [
        {"numero": "9101", "nome": "Raichu (POKPELE)"},
        {"numero": "9102", "nome": "Jolteon (POKPELE)"},
        {"numero": "9201", "nome": "Charizard (POKPFGO)"},
        {"numero": "9301", "nome": "Blastoise (POKPAGU)"},
    ],
    "1º SENADOR": [
        {"numero": "701", "nome": "Alakazam (POKPPSI)"},
        {"numero": "702", "nome": "Gengar (POKPFAN)"},
        {"numero": "703", "nome": "Dragonite (POKPDRA)"},
    ],
    "2º SENADOR": [
        {"numero": "751", "nome": "Mewtwo (POKPPSI)"},
        {"numero": "752", "nome": "Lugia (POKPPSI)"},
        {"numero": "753", "nome": "Ho-Oh (POKPFGO)"},
    ],
    "GOVERNADOR": [
        {"numero": "81", "nome": "Manectric (POKPELE)"},
        {"numero": "82", "nome": "Zapdos (POKPELE)"},
        {"numero": "84", "nome": "Magmortar (POKPFGO)"},
        {"numero": "85", "nome": "Blaziken (POKPFGO)"},
        {"numero": "87", "nome": "Feraligatr (POKPAGU)"},
        {"numero": "88", "nome": "Greninja (POKPAGU)"},
    ],
    "PRESIDENTE": [
        {"numero": "65", "nome": "Pikachu & Totodile (POKPELE)"},
        {"numero": "63", "nome": "Squirtle & Bulbasaur (POKPAGU)"},
        {"numero": "62", "nome": "Charmander & Flareon (POKPFGO)"},
    ]
}

def log_esp32(msg):
    timestamp = time.strftime("%H:%M:%S")
    print(f"[ESP32 | {timestamp}] {msg}")

def buzzer_bip(tipo="curto"):
    sons = {
        "curto": "🔊 *BIP* (440Hz)",
        "corrige": "🔊 *BOP-BOP* (220Hz)",
        "fim": "🔊 🎶 *TU-TU-TU-TURUUUUUU* (Buzzer TSE • FIM DA VOTAÇÃO!)"
    }
    print(f"      {sons.get(tipo, '🔊 *BIP*')}")

class ESP32Simulator:
    def __init__(self, api_url=DEFAULT_API_URL):
        self.api_url = api_url
        self.mac = "24:6F:28:B1:C4:A8"
        self.ip = f"192.168.1.{random.randint(100, 250)}"
        self.rssi = random.randint(-65, -45)
        self.connected = False

    def inicializar_hardware(self):
        print("\n" + "="*65)
        print("  ⚡ INICIALIZANDO ESP32 DUAL-CORE XTENSA LX6 • URNA ELETRÔNICA")
        print("="*65)
        log_esp32("Clock: 240MHz | Flash: 4MB | Free Heap: 284KB")
        log_esp32(f"MAC Address: {self.mac}")
        log_esp32("Inicializando GPIOs do Teclado Matricial (Pinos 13, 12, 14, 27, 26, 25, 33, 32)... OK")
        log_esp32("Inicializando Buzzer PWM no GPIO 18... OK")
        
        # Simula conexão Wi-Fi
        log_esp32("Conectando ao Wi-Fi 'TRE-URNA-REDE-SECRETA'...")
        time.sleep(0.6)
        self.connected = True
        log_esp32(f"✔ Wi-Fi Conectado! IP: {self.ip} | Sinal RSSI: {self.rssi} dBm")
        log_esp32(f"Endpoint de Destino: {self.api_url}")
        print("="*65 + "\n")

    def enviar_voto_http(self, cargo, numero):
        """Envia um voto individual via HTTP POST como o ESP32 real"""
        payload = {
            "cargo": cargo,
            "numero_candidato": str(numero)
        }
        data_json = json.dumps(payload).encode('utf-8')
        headers = {
            "Content-Type": "application/json",
            "User-Agent": "ESP32-UrnaEletronica/1.0 (Xtend-LX6)",
            "X-ESP32-MAC": self.mac
        }

        req = urllib.request.Request(self.api_url, data=data_json, headers=headers, method="POST")
        inicio = time.time()
        try:
            with urllib.request.urlopen(req, timeout=5) as response:
                duracao = (time.time() - inicio) * 1000
                res_body = response.read().decode('utf-8')
                return True, response.status, duracao, res_body
        except urllib.error.HTTPError as e:
            duracao = (time.time() - inicio) * 1000
            err_body = e.read().decode('utf-8') if e.fp else str(e)
            return False, e.code, duracao, err_body
        except Exception as e:
            duracao = (time.time() - inicio) * 1000
            return False, 0, duracao, str(e)

    def simular_eleitor_completo(self, escolha="random"):
        """Simula a votação sequencial de um eleitor por todos os 6 cargos"""
        log_esp32("▶ Novo eleitor entrou na cabine de votação.")
        cargos = list(CANDIDATOS_ESP32.keys())
        votos_sessao = []

        for cargo in cargos:
            opcoes = CANDIDATOS_ESP32[cargo]
            if escolha == "branco":
                cand_num = "BRANCO"
                cand_nome = "VOTO EM BRANCO"
            elif escolha == "nulo":
                cand_num = "99"
                cand_nome = "VOTO NULO"
            else:
                # 85% voto válido, 8% branco, 7% nulo
                sorteio = random.random()
                if sorteio < 0.08:
                    cand_num = "BRANCO"
                    cand_nome = "VOTO EM BRANCO"
                elif sorteio < 0.15:
                    cand_num = "00"
                    cand_nome = "VOTO NULO"
                else:
                    candidato = random.choice(opcoes)
                    cand_num = candidato["numero"]
                    cand_nome = candidato["nome"]

            log_esp32(f"Votando para {cargo}: digitando '{cand_num}' ({cand_nome})...")
            buzzer_bip("curto")
            time.sleep(0.2)
            buzzer_bip("curto")
            
            log_esp32("Pressionou [CONFIRMA]")
            buzzer_bip("curto")
            
            sucesso, status, latencia, resposta = self.enviar_voto_http(cargo, cand_num)
            if sucesso:
                log_esp32(f"   ✔ Voto para {cargo} transmitido! HTTP {status} ({latencia:.1f}ms)")
            else:
                log_esp32(f"   ⚠️ Falha ao transmitir ({latencia:.1f}ms): Status={status} | Erro={resposta}")

            votos_sessao.append({"cargo": cargo, "numero": cand_num, "ok": sucesso})
            time.sleep(0.3)

        print("\n" + "-"*65)
        log_esp32("🎉 VOTAÇÃO CONCLUÍDA PARA TODOS OS CARGOS!")
        buzzer_bip("fim")
        print("-"*65 + "\n")
        return votos_sessao

def modo_interativo(sim):
    print("=== MODO INTERATIVO ESP32 ===")
    print("Escolha o tipo de teste:")
    print("1. Votar em um candidato individual")
    print("2. Simular uma sessão eleitoral completa (6 cargos)")
    print("3. Votar BRANCO em todos os cargos")
    print("4. Votar NULO em todos os cargos")
    print("0. Sair")
    
    escolha = input("\nDigite a opção desejada: ").strip()
    if escolha == "1":
        print("\nCargos disponíveis:")
        cargos = list(CANDIDATOS_ESP32.keys())
        for idx, c in enumerate(cargos, 1):
            print(f" {idx}. {c}")
        c_idx = int(input("Escolha o cargo (1-6): ")) - 1
        cargo = cargos[c_idx]
        numero = input(f"Digite o número para {cargo} (ou BRANCO/00): ").strip()
        sucesso, status, latencia, resp = sim.enviar_voto_http(cargo, numero)
        print(f"\nResultado: Sucesso={sucesso} | HTTP {status} | Latência={latencia:.1f}ms\nResposta: {resp}\n")
    elif escolha == "2":
        sim.simular_eleitor_completo("random")
    elif escolha == "3":
        sim.simular_eleitor_completo("branco")
    elif escolha == "4":
        sim.simular_eleitor_completo("nulo")

if __name__ == "__main__":
    url = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_API_URL
    simulador = ESP32Simulator(api_url=url)
    simulador.inicializar_hardware()

    if len(sys.argv) > 2 and sys.argv[2] == "--auto":
        simulador.simular_eleitor_completo("random")
    else:
        modo_interativo(simulador)
