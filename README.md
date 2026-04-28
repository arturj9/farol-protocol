# Farol Protocol - Web3 MVP 🕯️

**Farol Protocol** é um ecossistema descentralizado desenvolvido como projeto final para a Residência em TIC 29 (Unidade 1 | Capítulo 5). O protocolo integra governação (DAO), staking de ativos e acesso exclusivo via NFT, utilizando oráculos da Chainlink para dinamizar a economia do projeto.



## 🏗️ Arquitetura do Protocolo

O ecossistema é composto por quatro contratos inteligentes principais:
- **Lumen Token ($LUM):** Token ERC-20 de utilidade e recompensa.
- **Lente de Quartzo (NFT):** Passe de acesso ERC-721 para membros da DAO.
- **Farol Staking:** Contrato que gere depósitos em ETH e distribui recompensas em $LUM.
- **Farol DAO:** Sistema de governação onde 1 NFT equivale a 1 voto em propostas on-chain.

## 🚀 Deploy em Testnet (Sepolia)

Os contratos foram implementados e verificados na rede de testes Sepolia. Pode consultar o código diretamente no explorer:

| Contrato | Endereço (Sepolia) | Explorer |
| :--- | :--- | :--- |
| **Lente de Quartzo (NFT)** | `0x74b937798A7571d66248B82b3204480FA37d1deC` | [Etherscan](https://sepolia.etherscan.io/address/0x74b937798A7571d66248B82b3204480FA37d1deC#code) |
| **Lumen Token (ERC20)** | `0x7A81925391cE45583F9d4dDb28DB3865A54B46e6` | [Etherscan](https://sepolia.etherscan.io/address/0x7A81925391cE45583F9d4dDb28DB3865A54B46e6#code) |
| **Farol Staking** | `0x60C1AC30C19115d8cb286aF850fBCD5E3202e689` | [Etherscan](https://sepolia.etherscan.io/address/0x60C1AC30C19115d8cb286aF850fBCD5E3202e689#code) |
| **Farol DAO** | `0xC6452BE0FDdF736eCA397Ca426784d2F0734dE59` | [Etherscan](https://sepolia.etherscan.io/address/0xC6452BE0FDdF736eCA397Ca426784d2F0734dE59#code) |

## 🛠️ Tecnologias Utilizadas

- **Solidity ^0.8.20**
- **Hardhat** (Ambiente de desenvolvimento)
- **OpenZeppelin** (Padrões ERC e Segurança)
- **Chainlink** (Oráculo de Preço ETH/USD)
- **Slither** (Auditoria Estática)
- **Ethers.js v6** (Integração Web3)

## 🔧 Como Executar Localmente

1. **Instalar dependências:**
   ```bash
   npm install

2. **Configurar variáveis de ambiente:**
Crie um arquivo .env na raiz e adicione:

INFURA_API_KEY=sua_chave
SEPOLIA_PRIVATE_KEY=sua_chave_privada
ETHERSCAN_API_KEY=sua_chave

3. **Compilar e Simular Interação:**
    ```bash
    npx hardhat compile
    npx hardhat run scripts/interact.js --network localhost

## 🛡️ Segurança e Auditoria
O protocolo foi submetido a uma auditoria estática utilizando Slither. Foram aplicadas as seguintes medidas de segurança:

- ReentrancyGuard: Proteção contra ataques de reentrada no contrato de Staking.
- AccessControl: Gestão rigorosa de permissões (Minter Role) para a cunhagem de tokens.
- Checks-Effects-Interactions: Padrão de codificação para prevenir vulnerabilidades lógicas.