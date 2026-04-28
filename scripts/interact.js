const hre = require("hardhat");

async function main() {
  const ethers = hre.ethers;
  
  const LENTE_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
  const LUMEN_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";
  const STAKING_ADDRESS = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";
  const DAO_ADDRESS = "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9";

  const [deployer, user] = await ethers.getSigners();

  console.log("--- Iniciando Simulação do Farol Protocol ---\n");
  console.log("Simulando interação com a conta do usuário:", user.address);

  // Instanciar contratos
  const lente = await ethers.getContractAt("LenteQuartzo", LENTE_ADDRESS);
  const staking = await ethers.getContractAt("FarolStaking", STAKING_ADDRESS);
  const dao = await ethers.getContractAt("FarolDAO", DAO_ADDRESS);

  console.log("\n1. Usuário tentando mintar NFT Lente de Quartzo...");
  const mintTx = await lente.connect(user).mint();
  await mintTx.wait();
  console.log("Sucesso: NFT Adquirido!");

  console.log("\n2. Usuário realizando Stake de 0.5 ETH...");
  const stakeAmount = ethers.parseEther("0.5");
  const stakeTx = await staking.connect(user).stake({ value: stakeAmount });
  await stakeTx.wait();
  console.log("Sucesso: Stake realizado.");

  console.log("\n3. Pulando tempo (1 dia) para gerar recompensas...");
  await ethers.provider.send("evm_increaseTime", [86400]); // 24 horas
  await ethers.provider.send("evm_mine");

  const reward = await staking.calculateReward(user.address);
  console.log(`Recompensa acumulada: ${ethers.formatEther(reward)} LUMEN`);

  console.log("\n4. Usuário votando na Proposta 0 da DAO...");
  const voteTx = await dao.connect(user).vote(0, 1);
  await voteTx.wait();
  console.log("Sucesso: Voto registrado na DAO.");

  const proposal = await dao.getProposal(0);
  console.log("\n--- RESULTADO FINAL ---");
  console.log(`Proposta: ${proposal[0]}`);
  console.log(`Votos a favor: ${proposal[1].toString()}`);
  console.log("------------------------------------------");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});