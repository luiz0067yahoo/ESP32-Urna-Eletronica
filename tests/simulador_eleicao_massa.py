#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
🗳️ SIMULADOR DE ELEIÇÃO EM MASSA & TESTE DE CARGA (STRESS TEST)
=============================================================================
Simula centenas de eleitores votando em paralelo no sistema da Urna:
- Envio simultâneo de requisições com multi-threading
- Distribuição estatística ponderada (candidatos favoritos, brancos e nulos)
- Métricas em tempo real: Requisições/segundo, latência média/p95, taxa de sucesso
- Comparativo final com a API de Apuração (/backend/apuracao)
=============================================================================
"""

import urllib.request
import urllib.error
import json
import time
import sys
import random
from concurrent.futures import ThreadPoolExecutor, as_completed

# Garante suporte a UTF-8 no console Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')


DEFAULT_API_VOTOS = "http://localhost:8080/backend/votos"
DEFAULT_API_APURACAO = "http://localhost:8080/backend/apuracao"

# Distribuição de probabilidade por candidato (simula tendências de pesquisa)
CANDIDATOS_PESOS = {
    "PRESIDENTE": [
        ("65", 0.45),  # Pikachu (favorito)
        ("63", 0.35),  # Squirtle
        ("62", 0.15),  # Charmander
        ("BRANCO", 0.03),
        ("00", 0.02)   # Nulo
    ],
    "GOVERNADOR": [
        ("81", 0.25),  # Manectric
        ("85", 0.25),  # Blaziken
        ("88", 0.20),  # Greninja
        ("82", 0.15),  # Zapdos
        ("BRANCO", 0.08),
        ("00", 0.07)
    ],
    "1º SENADOR": [
        ("701", 0.45), # Alakazam
        ("702", 0.35), # Gengar
        ("703", 0.15), # Dragonite
        ("BRANCO", 0.05)
    ],
    "2º SENADOR": [
        ("751", 0.50), # Mewtwo
        ("752", 0.30), # Lugia
        ("753", 0.15), # Ho-Oh
        ("BRANCO", 0.05)
    ],
    "DEPUTADO FEDERAL": [
        ("9101", 0.35), # Raichu
        ("9201", 0.30), # Charizard
        ("9301", 0.20), # Blastoise
        ("9102", 0.10), # Jolteon
        ("BRANCO", 0.05)
    ],
    "DEPUTADO ESTADUAL": [
        ("11101", 0.40), # Pichu
        ("12101", 0.30), # Cyndaquil
        ("13101", 0.25), # Totodile
        ("BRANCO", 0.05)
    ]
}

def sortear_voto(cargo):
    opcoes = CANDIDATOS_PESOS[cargo]
    candidatos = [op[0] for op in opcoes]
    pesos = [op[1] for op in opcoes]
    return random.choices(candidatos, weights=pesos, k=1)[0]

def enviar_voto_unitario(api_url, cargo, numero):
    payload = {"cargo": cargo, "numero_candidato": str(numero)}
    data_json = json.dumps(payload).encode('utf-8')
    headers = {"Content-Type": "application/json", "User-Agent": "SimuladorCarga/1.0"}
    req = urllib.request.Request(api_url, data=data_json, headers=headers, method="POST")
    
    t0 = time.time()
    try:
        with urllib.request.urlopen(req, timeout=8) as res:
            t1 = time.time()
            return True, (t1 - t0) * 1000, res.status
    except urllib.error.HTTPError as e:
        t1 = time.time()
        return False, (t1 - t0) * 1000, e.code
    except Exception:
        t1 = time.time()
        return False, (t1 - t0) * 1000, 0

def enviar_sessao_eleitor(api_url, eleitor_id):
    """Envia votos de 1 eleitor para os 6 cargos"""
    resultados = []
    for cargo in CANDIDATOS_PESOS.keys():
        numero = sortear_voto(cargo)
        sucesso, latencia, status = enviar_voto_unitario(api_url, cargo, numero)
        resultados.append({
            "eleitor": eleitor_id,
            "cargo": cargo,
            "numero": numero,
            "sucesso": sucesso,
            "latencia_ms": latencia,
            "status": status
        })
    return resultados

def executar_simulacao(num_eleitores=50, max_threads=10, api_url=DEFAULT_API_VOTOS):
    print("\n" + "="*70)
    print("  🚀 INICIANDO SIMULADOR DE ELEIÇÃO EM MASSA (TESTE DE CARGA)")
    print("="*70)
    print(f" • Total de Eleitores Virtuais: {num_eleitores}")
    print(f" • Votos Totais Estimados:      {num_eleitores * 6} (6 cargos por eleitor)")
    print(f" • Threads Concorrentes:        {max_threads}")
    print(f" • Endpoint da API:             {api_url}")
    print("="*70 + "\n")

    inicio_global = time.time()
    todos_votos = []
    sucessos = 0
    falhas = 0
    latencias = []

    print("▶ Disparando eleitores virtuais...")
    with ThreadPoolExecutor(max_workers=max_threads) as executor:
        futures = {executor.submit(enviar_sessao_eleitor, api_url, i+1): i+1 for i in range(num_eleitores)}
        concluidos = 0
        for f in as_completed(futures):
            concluidos += 1
            res_sessao = f.result()
            for v in res_sessao:
                todos_votos.append(v)
                latencias.append(v["latencia_ms"])
                if v["sucesso"]:
                    sucessos += 1
                else:
                    falhas += 1

            # Barra de progresso visual
            pct = (concluidos / num_eleitores) * 100
            barra = "█" * int(pct // 4) + "-" * (25 - int(pct // 4))
            print(f"\r  Progresso: [{barra}] {concluidos}/{num_eleitores} eleitores ({pct:.1f}%)", end="", flush=True)

    tempo_total = time.time() - inicio_global
    print("\n\n" + "="*70)
    print("  📊 RELATÓRIO DE DESEMPENHO E CARGA")
    print("="*70)
    print(f" • Tempo total de execução:     {tempo_total:.2f} segundos")
    print(f" • Total de votos processados:   {len(todos_votos)}")
    print(f" • Votos com SUCESSO (HTTP 201): {sucessos} ({ (sucessos/len(todos_votos))*100:.1f}%)")
    print(f" • Votos com FALHA:              {falhas}")
    if latencias:
        lat_ordenadas = sorted(latencias)
        media_ms = sum(latencias) / len(latencias)
        p50 = lat_ordenadas[int(len(lat_ordenadas) * 0.5)]
        p95 = lat_ordenadas[int(len(lat_ordenadas) * 0.95)]
        p99 = lat_ordenadas[int(len(lat_ordenadas) * 0.99)]
        rps = len(todos_votos) / tempo_total if tempo_total > 0 else 0
        print(f" • Throughput (Vazão):           {rps:.1f} votos/segundo")
        print(f" • Latência Média:               {media_ms:.1f} ms")
        print(f" • Latência Mediana (p50):       {p50:.1f} ms")
        print(f" • Latência 95º percentil (p95): {p95:.1f} ms")
        print(f" • Latência 99º percentil (p99): {p99:.1f} ms")
    print("="*70)

    # Consulta apuração se disponível
    try:
        req_apuracao = urllib.request.Request(DEFAULT_API_APURACAO, headers={"User-Agent": "SimuladorCarga/1.0"})
        with urllib.request.urlopen(req_apuracao, timeout=5) as res_a:
            dados_apuracao = json.loads(res_a.read().decode('utf-8'))
            print("\n  🗳️ RESUMO DA APURAÇÃO ATUALIZADA (PRESIDENTE):")
            pres = dados_apuracao.get("cargos", {}).get("PRESIDENTE", {})
            total_pres = pres.get("total_votos", 0)
            print(f"  • Total de Votos para Presidente: {total_pres}")
            for c in pres.get("candidatos", []):
                print(f"    - {c.get('nome')} ({c.get('numero')}): {c.get('votos')} votos ({c.get('percentual', 0):.1f}%)")
    except Exception as e:
        print(f"\n  (Não foi possível consultar apuração: {e})")

    print("\n✔ Simulação em massa concluída com sucesso!\n")
    return {
        "eleitores": num_eleitores,
        "votos_totais": len(todos_votos),
        "sucessos": sucessos,
        "falhas": falhas,
        "tempo_s": tempo_total
    }

if __name__ == "__main__":
    n = int(sys.argv[1]) if len(sys.argv) > 1 and sys.argv[1].isdigit() else 30
    threads = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2].isdigit() else 10
    url = sys.argv[3] if len(sys.argv) > 3 else DEFAULT_API_VOTOS
    executar_simulacao(num_eleitores=n, max_threads=threads, api_url=url)
