const hre = require("hardhat");

async function main() {
  const ethers = hre.ethers;
  
  const [deployer] = await ethers.getSigners();
  console.log("--- Iniciando Deploy ---");
  console.log("Conta: ", deployer.address);
  console.log("Saldo: ", (await ethers.provider.getBalance(deployer.address)).toString(), "\n");

  console.log("Efetuando deploy: Lente de Quartzo...");
  const LenteFactory = await ethers.getContractFactory("LenteQuartzo");
  const lente = await LenteFactory.deploy();
  if (lente.waitForDeployment) { await lente.waitForDeployment(); } else { await lente.deployed(); }
  const lenteAddr = lente.target || lente.address;
  console.log("NFT Lente de Quartzo em:", lenteAddr);

  console.log("Efetuando deploy: Lumen Token...");
  const LumenFactory = await ethers.getContractFactory("LumenToken");
  const lumen = await LumenFactory.deploy(deployer.address);
  if (lumen.waitForDeployment) { await lumen.waitForDeployment(); } else { await lumen.deployed(); }
  const lumenAddr = lumen.target || lumen.address;
  console.log("Lumen Token em:", lumenAddr);

  console.log("Efetuando deploy: Farol Staking...");
  const DUMMY_PRICE_FEED = "0x694AA1769357215DE4FAC081bf1f309aDC325306"; 
  const StakingFactory = await ethers.getContractFactory("FarolStaking");
  const staking = await StakingFactory.deploy(lumenAddr, lenteAddr, DUMMY_PRICE_FEED);
  if (staking.waitForDeployment) { await staking.waitForDeployment(); } else { await staking.deployed(); }
  const stakingAddr = staking.target || staking.address;
  console.log("Farol Staking em:", stakingAddr);

  console.log("Efetuando deploy: Farol DAO...");
  const DAOFactory = await ethers.getContractFactory("FarolDAO");
  const dao = await DAOFactory.deploy(lenteAddr);
  if (dao.waitForDeployment) { await dao.waitForDeployment(); } else { await dao.deployed(); }
  const daoAddr = dao.target || dao.address;
  console.log("Farol DAO em:", daoAddr);

  console.log("\nConfigurando permissões de MINTER...");
  
  let minterRole;
  const roleName = "MINTER_ROLE";
  if (ethers.id) {
    minterRole = ethers.id(roleName);
  } else {
    minterRole = ethers.utils.keccak256(ethers.utils.toUtf8Bytes(roleName));
  }

  const tx = await lumen.grantRole(minterRole, stakingAddr);
  await tx.wait();
  console.log("Sucesso: Contrato de Staking autorizado a mintar Lumen.");

  console.log("\n===============================================");
  console.log("DEPLOY COMPLETO - COPIE OS ENDEREÇOS ABAIXO:");
  console.log("===============================================");
  console.log(`LENTE_ADDRESS = "${lenteAddr}"`);
  console.log(`LUMEN_ADDRESS = "${lumenAddr}"`);
  console.log(`STAKING_ADDRESS = "${stakingAddr}"`);
  console.log(`DAO_ADDRESS = "${daoAddr}"`);
  console.log("===============================================\n");
}

main().catch((error) => {
  console.error("\nERRO DURANTE O DEPLOY:");
  console.error(error);
  process.exitCode = 1;
});