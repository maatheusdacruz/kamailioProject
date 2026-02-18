# ARCHITECTURE.md

# Arquitetura Técnica – Plataforma SIP Escalável com AMD Inteligente

---

# 1. Visão Arquitetural Geral

A arquitetura segue o princípio de separação total de responsabilidades:

- Camada de Entrada SIP
- Camada de Controle (Kamailio)
- Camada de Mídia (FreeSWITCH)
- Camada de Inteligência (AMD Service Python)
- Camada de Dados (PostgreSQL + Redis)
- Camada de Observabilidade

Arquitetura orientada a escalabilidade horizontal e alta disponibilidade.

---

# 2. Diagrama Lógico Simplificado

                ┌────────────────────┐
                │   HAProxy / LB     │
                └─────────┬──────────┘
                          │
            ┌─────────────┴─────────────┐
            │                           │
     ┌────────────┐             ┌────────────┐
     │ Kamailio 1 │             │ Kamailio 2 │
     └──────┬─────┘             └──────┬─────┘
            │                            │
            └─────────────┬──────────────┘
                          │
                 Dispatcher Module
                          │
            ┌─────────────┴─────────────┐
            │                           │
     ┌────────────┐             ┌────────────┐
     │ FreeSW 1   │             │ FreeSW 2   │
     └──────┬─────┘             └──────┬─────┘
            │                            │
            └─────────────┬──────────────┘
                          │
              AMD Microservice Cluster
                          │
                 ┌────────┴────────┐
                 │ PostgreSQL      │
                 │ Redis Cluster   │
                 └─────────────────┘

---

# 3. Componentes e Responsabilidades

---

## 3.1 HAProxy (Camada de Entrada)

Responsável por:

- Balanceamento TCP (SIP)
- Failover automático
- Health check dos Kamailios
- Alta disponibilidade ativa/ativa ou ativa/passiva

Modo recomendado:
- TCP mode
- Keepalived opcional para VIP

---

## 3.2 Kamailio (Camada de Controle SIP)

Responsável por:

- Autenticação
- Multi-tenant
- Roteamento por cliente
- Seleção de FreeSWITCH via dispatcher
- Inserção de headers AMD
- Controle de diálogo
- Failover entre FreeSWITCH

Módulos principais:

- dispatcher
- dialog
- tm
- sl
- rr
- pv
- xlog
- sqlops
- htable
- topos
- dmq (replicação futura)
- rtpengine (se necessário)

Kamailio NÃO processa mídia.

---

## 3.3 FreeSWITCH (Camada de Mídia)

Responsável por:

- Media handling
- Controle RTP
- Execução do fluxo AMD
- Comunicação com microserviço Python
- Aplicação da decisão (hangup/continue/transfer)

Módulos principais:

- mod_sofia
- mod_event_socket
- mod_lua (opcional)
- mod_http_cache (opcional)

FreeSWITCH não deve conter lógica SIP complexa.

---

## 3.4 Microserviço AMD (Python)

Responsável por:

- Receber áudio inicial da chamada
- Executar VAD
- Analisar padrão de fala
- Detectar beep
- Classificar atendimento

Stack:

- Python 3.11+
- FastAPI
- Uvicorn
- WebRTC VAD ou Silero VAD
- NumPy
- SciPy

Características:

- Stateless
- Escalável horizontalmente
- Configurável por cliente
- Retorno JSON estruturado

Resposta padrão:

{
  "result": "HUMAN | MACHINE | FAX | UNKNOWN",
  "confidence": 0.0-1.0,
  "analysis_time_ms": integer
}

---

## 3.5 PostgreSQL

Responsável por:

- Cadastro de clientes
- Troncos
- Regras de roteamento
- Configuração de AMD por cliente
- Histórico de chamadas

Preparado para:

- Replica futura
- Cluster Patroni (fase avançada)

---

## 3.6 Redis

Responsável por:

- Estado temporário de chamadas
- Flags de decisão
- Cache de configuração
- Rate limiting
- Controle de CPS por cliente

Deve ser configurado para cluster futuro.

---

# 4. Fluxo de Chamada – Outbound

1. Discador envia INVITE
2. HAProxy encaminha para Kamailio
3. Kamailio:
   - Identifica cliente
   - Consulta regras
   - Seleciona FreeSWITCH
4. FreeSWITCH atende
5. AMD é iniciado
6. Áudio inicial é analisado
7. Microserviço retorna decisão
8. FreeSWITCH:
   - HUMAN → continua
   - MACHINE → encerra ou transfere
9. Resultado pode ser enviado via header de volta ao Kamailio

---

# 5. Modelo AMD Assíncrono

AMD roda paralelamente após answer.

Benefícios:

- Redução de Post Dial Delay
- Melhor experiência
- Escalabilidade superior

Tempo recomendado de análise inicial:
2 a 4 segundos

---

# 6. Escalabilidade Horizontal

Cada camada escala independentemente:

Kamailio:
- Adicionar novos nós
- Balanceamento via HAProxy

FreeSWITCH:
- Adicionar novos nós
- Dispatcher atualiza lista

AMD Service:
- Auto scale baseado em CPU

Banco:
- Replica de leitura
- Futuro cluster

Redis:
- Cluster mode

---

# 7. Alta Disponibilidade

Desde a primeira versão:

- Múltiplos Kamailio
- Múltiplos FreeSWITCH
- HAProxy redundante
- Containers isolados
- Volume externo para persistência

Nenhum estado deve depender de um único nó.

---

# 8. Comunicação entre Componentes

Kamailio → FreeSWITCH:
- SIP

FreeSWITCH → AMD Service:
- HTTP REST ou TCP socket interno

Kamailio → Banco:
- SQL

Kamailio → Redis:
- Cache e estado

---

# 9. Observabilidade

Deve incluir:

- Logs estruturados
- Métricas Prometheus
- Monitoramento de:
  - CPS
  - PDD
  - Taxa de HUMAN vs MACHINE
  - Tempo médio de análise
  - CPU por instância

---

# 10. Estratégia de Migração Futura

Arquitetura preparada para:

Docker → Bare Metal

Requisitos:

- Configuração versionada
- Network host mode
- Portas padronizadas
- Separação completa de serviços

Nenhuma dependência exclusiva de container runtime.

---

# 11. Princípios Arquiteturais

- Desacoplamento total
- Escala horizontal
- Stateless sempre que possível
- Nenhum componente único crítico
- Preparado para crescimento agressivo
