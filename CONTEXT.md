# PROJECT_CONTEXT.md

# Projeto: Plataforma SIP Escalável com Kamailio + FreeSWITCH + AMD Inteligente

---

# 1. Visão Geral

Este projeto tem como objetivo construir uma arquitetura SIP altamente escalável e multi-tenant utilizando:

- Kamailio como controlador e roteador SIP principal
- FreeSWITCH como servidor de mídia
- Microserviço AMD em Python para detecção inteligente de atendimento
- PostgreSQL como banco principal
- Redis para controle de estado temporário
- Docker como ambiente inicial de desenvolvimento

A arquitetura deve permitir crescimento horizontal e suportar aumento progressivo de CPS (Calls Per Second), considerando carga agregada de múltiplos clientes.

---

# 2. Problema Atual

A empresa trabalha com múltiplos clientes, cada um com:

- Troncos próprios
- Servidores próprios
- Regras de roteamento específicas

Necessidades principais:

- Controle centralizado de chamadas
- Classificação automática de atendimento (Humano vs Máquina)
- Capacidade de expansão futura
- Alta disponibilidade desde a primeira versão
- Arquitetura modular e desacoplada

---

# 3. Objetivos Técnicos

1. Separar completamente:
   - Controle SIP (Kamailio)
   - Mídia (FreeSWITCH)
   - Inteligência de classificação (Microserviço AMD)

2. Implementar AMD assíncrono configurável por cliente.

3. Permitir escalabilidade horizontal:
   - Múltiplos Kamailios
   - Múltiplos FreeSWITCH
   - Múltiplas instâncias do serviço AMD

4. Garantir:
   - Alta disponibilidade
   - Observabilidade
   - Versionamento de configurações
   - Facilidade de migração futura para bare metal

---

# 4. Escopo Inicial

Fase inicial (PoC com HA):

- Kamailio rodando em Docker (network_mode host)
- FreeSWITCH rodando em Docker
- Microserviço AMD em Python (FastAPI)
- PostgreSQL
- Redis
- HAProxy para balanceamento SIP

---

# 5. Modelo de AMD Escolhido

## Tipo:
AMD Assíncrono Inteligente

## Funcionamento:

1. Chamada atende
2. FreeSWITCH captura primeiros segundos de áudio
3. Envia buffer para microserviço Python
4. Serviço executa:
   - VAD (Voice Activity Detection)
   - Análise de silêncio
   - Análise de greeting
   - Detecção de beep
5. Retorna classificação:
   - HUMAN
   - MACHINE
   - FAX
   - UNKNOWN

## Configurável por cliente:

- Tempo máximo de análise
- Tolerância de silêncio inicial
- Limite de greeting
- Sensibilidade VAD
- Modo (aggressive / balanced / conservative)

---

# 6. Requisitos Não Funcionais

- Alta disponibilidade desde a primeira versão
- Capacidade de crescimento para altos volumes agregados de CPS
- Zero dependência de estado local
- Preparado para cluster futuro
- Logs estruturados
- Métricas exportáveis (Prometheus-ready)

---

# 7. Arquitetura Multi-Tenant

Cada cliente poderá possuir:

- Regras próprias de roteamento
- Troncos dedicados
- Configurações específicas de AMD
- Estratégias de fallback

O sistema deve garantir isolamento lógico entre clientes.

---

# 8. Estratégia de Crescimento

O projeto deve ser desenvolvido considerando:

- Docker apenas como ambiente inicial
- Fácil migração futura para ambiente bare metal otimizado
- Escala horizontal como padrão
- Nenhum componente monolítico

---

# 9. Atualização Contínua do Contexto

Este documento deve ser atualizado progressivamente à medida que:

- Decisões arquiteturais forem alteradas
- Novos requisitos surgirem
- Componentes forem adicionados
- Ajustes de performance forem definidos
- Estratégias de escalabilidade forem refinadas

Toda alteração significativa no projeto deve refletir neste arquivo.

Este arquivo é a fonte oficial de verdade do projeto.

---

# 10. Interface de Gerenciamento (Siremis)

Adicionado Siremis como interface web administrativa do Kamailio:

- Containerizado via Docker (PHP 8.2 + Apache)
- Conecta ao PostgreSQL para gerenciamento de configuração
- Conecta ao Kamailio via HTTP JSONRPC (porta 5064)
- Acessível em http://host:8088/siremis/
- Configuração inicial via wizard web

---

# 11. Fora do Escopo (Inicialmente)

- IA baseada em redes neurais profundas
- Transcrição completa de áudio
- Billing

Esses poderão ser considerados em fases futuras.

---

# 11. Critério de Sucesso

O projeto será considerado bem-sucedido quando:

- O fluxo completo Kamailio → FreeSWITCH → AMD → decisão estiver funcionando
- A arquitetura suportar múltiplas instâncias
- O sistema estiver preparado para expansão horizontal
- O AMD for configurável por cliente
- O ambiente estiver containerizado e versionado
