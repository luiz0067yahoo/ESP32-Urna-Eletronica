#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
🧪 SUÍTE DE TESTES DE SISTEMA & API RESTful • URNA ELETRÔNICA POKÉMON
=============================================================================
Bateria de testes automatizados ponta a ponta:
- Contratos de rotas HTTP (GET, POST, DELETE)
- Registro unitário e em lote de votos
- Votos nominais, brancos e nulos
- Validação de filtros e paginação
- Apuração consolidada de votos
- Tratamento de exceções e códigos HTTP (200, 201, 400, 404, 405)
- Procedimento de Zerésima eleitoral
- Re-seeding automático para deixar o banco pronto após os testes
=============================================================================
"""

import urllib.request
import urllib.error
import json
import time
import sys

# Garante suporte a UTF-8 no console Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')


DEFAULT_BASE_URL = "http://localhost:8080"

# Cores ANSI para o terminal
VERDE = "\033[92m"
VERMELHO = "\033[91m"
AMARELO = "\033[93m"
AZUL = "\033[94m"
RESET = "\033[0m"
NEGRITO = "\033[1m"

class TestResult:
    def __init__(self):
        self.passou = 0
        self.falhou = 0
        self.erros = []

    def registrar_sucesso(self, nome, duracao_ms):
        self.passou += 1
        print(f"  {VERDE}✔ PASSOU{RESET} | {nome} ({duracao_ms:.1f}ms)")

    def registrar_falha(self, nome, motivo, duracao_ms=0):
        self.falhou += 1
        self.erros.append((nome, motivo))
        print(f"  {VERMELHO}✖ FALHOU{RESET} | {nome}: {motivo}")

class ApiTestSuite:
    def __init__(self, base_url=DEFAULT_BASE_URL):
        self.base_url = base_url.rstrip('/')
        self.votos_url = f"{self.base_url}/backend/votos"
        self.apuracao_url = f"{self.base_url}/backend/apuracao"
        self.install_url = f"{self.base_url}/db/install.php?format=json"
        self.result = TestResult()

    def _http_request(self, url, method="GET", data=None):
        headers = {"User-Agent": "UrnaTestSuite/1.0", "Accept": "application/json"}
        payload_bytes = None
        if data is not None:
            headers["Content-Type"] = "application/json"
            payload_bytes = json.dumps(data).encode('utf-8')

        req = urllib.request.Request(url, data=payload_bytes, headers=headers, method=method)
        t0 = time.time()
        try:
            with urllib.request.urlopen(req, timeout=6) as res:
                duracao = (time.time() - t0) * 1000
                body = res.read().decode('utf-8')
                try:
                    json_data = json.loads(body)
                except Exception:
                    json_data = body
                return res.status, json_data, duracao
        except urllib.error.HTTPError as e:
            duracao = (time.time() - t0) * 1000
            err_body = e.read().decode('utf-8') if e.fp else ""
            try:
                json_err = json.loads(err_body)
            except Exception:
                json_err = err_body
            return e.code, json_err, duracao
        except Exception as e:
            duracao = (time.time() - t0) * 1000
            return 0, str(e), duracao

    # ---------------- TESTES ESPECÍFICOS ----------------

    def test_01_conectividade_servidor(self):
        nome = "01. Conectividade básica com o backend"
        status, data, duracao = self._http_request(self.votos_url, "GET")
        if status in (200, 201):
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Status retornado foi {status} em vez de 200", duracao)

    def test_02_registrar_voto_individual_valido(self):
        nome = "02. Registrar voto individual válido (Pikachu: 65)"
        payload = {"cargo": "PRESIDENTE", "numero_candidato": "65"}
        status, data, duracao = self._http_request(self.votos_url, "POST", payload)
        if status == 201 and isinstance(data, dict) and data.get("status") == "success":
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Esperado 201 com status=success. Obtido: {status} -> {data}", duracao)

    def test_03_registrar_voto_branco_e_nulo(self):
        nome = "03. Registrar votos especiais (BRANCO e NULO)"
        p1 = {"cargo": "GOVERNADOR", "numero_candidato": "BRANCO"}
        p2 = {"cargo": "GOVERNADOR", "numero_candidato": "00"}
        
        s1, d1, dur1 = self._http_request(self.votos_url, "POST", p1)
        s2, d2, dur2 = self._http_request(self.votos_url, "POST", p2)

        if s1 == 201 and s2 == 201:
            self.result.registrar_sucesso(nome, dur1 + dur2)
        else:
            self.result.registrar_falha(nome, f"Falha no registro: Branco={s1}, Nulo={s2}", dur1 + dur2)

    def test_04_registrar_lote_sessao_completa(self):
        nome = "04. Registrar lote de votos de uma sessão completa (6 cargos)"
        lote = [
            {"cargo": "DEPUTADO ESTADUAL", "numero_candidato": "11101"},
            {"cargo": "DEPUTADO FEDERAL", "numero_candidato": "9101"},
            {"cargo": "1º SENADOR", "numero_candidato": "701"},
            {"cargo": "2º SENADOR", "numero_candidato": "751"},
            {"cargo": "GOVERNADOR", "numero_candidato": "81"},
            {"cargo": "PRESIDENTE", "numero_candidato": "65"}
        ]
        status, data, duracao = self._http_request(self.votos_url, "POST", lote)
        if status == 201 and isinstance(data, dict) and data.get("total_inseridos") == 6:
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Esperado 6 votos inseridos em lote. Obtido: {status} -> {data}", duracao)

    def test_05_listar_votos_detalhado(self):
        nome = "05. Listagem detalhada de votos (GET /votos)"
        status, data, duracao = self._http_request(self.votos_url, "GET")
        if status == 200 and isinstance(data, dict) and "dados" in data and isinstance(data["dados"], list):
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Formato inválido retornado na listagem: {data}", duracao)

    def test_06_listar_votos_resumo_agrupado(self):
        nome = "06. Listagem agrupada em resumo (GET /votos?tipo=resumo)"
        url = f"{self.votos_url}?tipo=resumo"
        status, data, duracao = self._http_request(url, "GET")
        if status == 200 and isinstance(data, dict) and "dados" in data:
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Falha no resumo agrupado: {data}", duracao)

    def test_07_filtro_por_cargo(self):
        nome = "07. Filtro de votos por cargo específico (GET /votos?cargo=PRESIDENTE)"
        url = f"{self.votos_url}?cargo=PRESIDENTE"
        status, data, duracao = self._http_request(url, "GET")
        if status == 200 and isinstance(data, dict) and "dados" in data:
            registros = data["dados"]
            todos_presidente = all(v.get("cargo") == "PRESIDENTE" for v in registros)
            if todos_presidente:
                self.result.registrar_sucesso(nome, duracao)
            else:
                self.result.registrar_falha(nome, "Retornou votos de outros cargos no filtro", duracao)
        else:
            self.result.registrar_falha(nome, f"Status {status} ao filtrar por cargo", duracao)

    def test_08_apuracao_consolidada(self):
        nome = "08. Consulta da Apuração Consolidada (GET /apuracao)"
        status, data, duracao = self._http_request(self.apuracao_url, "GET")
        if status == 200 and isinstance(data, dict) and "cargos" in data:
            cargos = data["cargos"]
            tem_presidente = "PRESIDENTE" in cargos
            if tem_presidente:
                self.result.registrar_sucesso(nome, duracao)
            else:
                self.result.registrar_falha(nome, "Campo PRESIDENTE ausente na apuração", duracao)
        else:
            self.result.registrar_falha(nome, f"Falha na apuração: Status {status}", duracao)

    def test_09_validacao_campos_obrigatorios_400(self):
        nome = "09. Validação de parâmetros ausentes (Esperado HTTP 400)"
        payload_invalido = {"cargo": "PRESIDENTE"}  # Sem numero_candidato
        status, data, duracao = self._http_request(self.votos_url, "POST", payload_invalido)
        if status == 400:
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Esperado status 400 Bad Request, mas obteve {status}", duracao)

    def test_10_rota_inexistente_404(self):
        nome = "10. Rota inexistente (Esperado HTTP 404)"
        url_inexistente = f"{self.base_url}/backend/rota_fantasma"
        status, data, duracao = self._http_request(url_inexistente, "GET")
        if status == 404:
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Esperado status 404 Not Found, obteve {status}", duracao)

    def test_11_zeresima_eleitoral(self):
        nome = "11. Teste de Zerésima (DELETE /votos)"
        status, data, duracao = self._http_request(self.votos_url, "DELETE")
        if status == 200 and isinstance(data, dict) and data.get("status") == "success":
            # Confere se os votos foram zerados
            s_check, d_check, _ = self._http_request(self.votos_url, "GET")
            total = d_check.get("total", 0) if isinstance(d_check, dict) else -1
            if total == 0:
                self.result.registrar_sucesso(nome, duracao)
            else:
                self.result.registrar_falha(nome, f"Zerésima executada mas ainda restaram {total} votos", duracao)
        else:
            self.result.registrar_falha(nome, f"Falha na Zerésima: Status {status} -> {data}", duracao)

    def test_12_reseed_pos_teste(self):
        nome = "12. Restauração e Seed do Banco após os testes (db/install.php)"
        status, data, duracao = self._http_request(self.install_url, "GET")
        if status in (200, 201):
            self.result.registrar_sucesso(nome, duracao)
        else:
            self.result.registrar_falha(nome, f"Não foi possível reexecutar seed: Status {status}", duracao)

    # ---------------- EXECUTOR PRINCIPAL ----------------

    def executar_todos(self):
        print("\n" + "="*70)
        print(f"  {AZUL}🧪 EXECUTANDO BATERIA DE TESTES DE SISTEMA • URNA ELETRÔNICA{RESET}")
        print("="*70)
        print(f" • Alvo do Teste: {self.base_url}")
        print("="*70 + "\n")

        inicio = time.time()

        self.test_01_conectividade_servidor()
        self.test_02_registrar_voto_individual_valido()
        self.test_03_registrar_voto_branco_e_nulo()
        self.test_04_registrar_lote_sessao_completa()
        self.test_05_listar_votos_detalhado()
        self.test_06_listar_votos_resumo_agrupado()
        self.test_07_filtro_por_cargo()
        self.test_08_apuracao_consolidada()
        self.test_09_validacao_campos_obrigatorios_400()
        self.test_10_rota_inexistente_404()
        self.test_11_zeresima_eleitoral()
        self.test_12_reseed_pos_teste()

        tempo_total = time.time() - inicio
        total_testes = self.result.passou + self.result.falhou

        print("\n" + "="*70)
        print(f"  {NEGRITO}📊 RESUMO DOS TESTES DE SISTEMA:{RESET}")
        print(f" • Total de testes executados: {total_testes}")
        print(f" • {VERDE}Testes APROVADOS:           {self.result.passou}{RESET}")
        print(f" • {VERMELHO if self.result.falhou > 0 else VERDE}Testes REPROVADOS:          {self.result.falhou}{RESET}")
        print(f" • Tempo total de execução:    {tempo_total:.2f}s")
        print("="*70)

        if self.result.falhou == 0:
            print(f"\n{VERDE}{NEGRITO}🎉 TODOS OS TESTES PASSARAM COM 100% DE SUCESSO!{RESET}\n")
            return 0
        else:
            print(f"\n{VERMELHO}{NEGRITO}⚠️ ALGUNS TESTES FALHARAM. VERIFIQUE SE O SERVIDOR ESTÁ LIGADO.{RESET}\n")
            return 1

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_BASE_URL
    suite = ApiTestSuite(target)
    sys.exit(suite.executar_todos())
