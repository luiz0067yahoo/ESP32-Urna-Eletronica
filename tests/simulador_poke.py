#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
🗳️ SIMULADOR DE TERMINAL DE VOTAÇÃO • URNA ELETRÔNICA POKÉMON
=============================================================================
Emula a operação do terminal de votação da Urna Eletrônica:
- Entrada de votos por teclado digital (números, BRANCO, CORRIGE, CONFIRMA)
- Efeitos sonoros do TSE (bip de digitação, aviso de correção e trissono de FIM)
- Transmissão de votos via HTTP POST para a API REST (/backend/votos)
- Suporte a votação manual interativa ou sessão eleitoral automatizada (6 cargos)
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
CANDIDATOS_POKE = {
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

def log_terminal(msg):
    timestamp = time.strftime("%H:%M:%S")
    print(f"[URNA | {timestamp}] {msg}")

def buzzer_bip(tipo="curto"):
    sons = {
        "curto": "🔊 *BIP* (440Hz)",
        "corrige": "🔊 *BOP-BOP* (220Hz)",
        "fim": "🔊 🎶 *TU-TU-TU-TURUUUUUU* (Sinal TSE • VOTAÇÃO FINALIZADA!)"
    }
    print(f"      {sons.get(tipo, '🔊 *BIP*')}")

class TerminalUrnaSimulator:
    def __init__(self, api_url=DEFAULT_API_URL):
        self.api_url = api_url
        self.secao = "001"
        self.zona = "042"

    def inicializar_terminal(self):
        print("\n" + "="*65)
        print("  🗳️ TERMINAL ELEITORAL DIGITAL • CABINE DE VOTAÇÃO")
        print("="*65)
        log_terminal(f"Seção Eleitoral: {self.secao} | Zona: {self.zona}")
        log_terminal("Módulo de Teclado Digital: PRONTO")
        log_terminal("Sintetizador Sonoro (Buzzer): PRONTO")
        log_terminal(f"Endpoint de Votação: {self.api_url}")
        print("="*65 + "\n")

    def enviar_voto_http(self, cargo, numero):
        """Transmite o voto computado via HTTP POST para a API"""
        payload = {
            "cargo": cargo,
            "numero_candidato": str(numero)
        }
        data_json = json.dumps(payload).encode('utf-8')
        headers = {
            "Content-Type": "application/json",
            "User-Agent": "TerminalUrna-ClienteWeb/2.0",
            "X-Secao-Eleitoral": self.secao
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
        log_terminal("▶ Eleitor liberado pelo mesário. Iniciando votação...")
        cargos = list(CANDIDATOS_POKE.keys())
        votos_sessao = []

        for cargo in cargos:
            opcoes = CANDIDATOS_POKE[cargo]
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

            log_terminal(f"Cargo: {cargo} -> Digitado '{cand_num}' ({cand_nome})")
            buzzer_bip("curto")
            time.sleep(0.15)
            
            log_terminal("Eleitor pressionou [CONFIRMA]")
            buzzer_bip("curto")
            
            sucesso, status, latencia, resposta = self.enviar_voto_http(cargo, cand_num)
            if sucesso:
                log_terminal(f"   ✔ Voto computado na API! HTTP {status} ({latencia:.1f}ms)")
            else:
                log_terminal(f"   ⚠️ Falha ao registrar ({latencia:.1f}ms): Status={status} | Erro={resposta}")

            votos_sessao.append({"cargo": cargo, "numero": cand_num, "ok": sucesso})
            time.sleep(0.2)

        print("\n" + "-"*65)
        log_terminal("🎉 VOTAÇÃO CONCLUÍDA PARA TODOS OS CARGOS!")
        buzzer_bip("fim")
        print("-"*65 + "\n")
        return votos_sessao

def modo_interativo(terminal):
    print("=== TERMINAL ELEITORAL DIGITAL ===")
    print("Escolha a operação desejada:")
    print("1. Votar em um candidato individual")
    print("2. Simular sessão eleitoral completa (6 cargos)")
    print("3. Votar BRANCO em todos os cargos")
    print("4. Votar NULO em todos os cargos")
    print("0. Sair")
    
    escolha = input("\nDigite a opção desejada: ").strip()
    if escolha == "1":
        print("\nCargos disponíveis:")
        cargos = list(CANDIDATOS_POKE.keys())
        for idx, c in enumerate(cargos, 1):
            print(f" {idx}. {c}")
        c_idx = int(input("Escolha o cargo (1-6): ")) - 1
        cargo = cargos[c_idx]
        numero = input(f"Digite o número para {cargo} (ou BRANCO/00): ").strip()
        sucesso, status, latencia, resp = terminal.enviar_voto_http(cargo, numero)
        print(f"\nResultado: Sucesso={sucesso} | HTTP {status} | Latência={latencia:.1f}ms\nResposta: {resp}\n")
    elif escolha == "2":
        terminal.simular_eleitor_completo("random")
    elif escolha == "3":
        terminal.simular_eleitor_completo("branco")
    elif escolha == "4":
        terminal.simular_eleitor_completo("nulo")

if __name__ == "__main__":
    url = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_API_URL
    simulador = TerminalUrnaSimulator(api_url=url)
    simulador.inicializar_terminal()

    if len(sys.argv) > 2 and sys.argv[2] == "--auto":
        simulador.simular_eleitor_completo("random")
    else:
        modo_interativo(simulador)
