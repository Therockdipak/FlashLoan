// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("LockModule", (m) => {
   const addressProvider = "0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A"; 
   
  const lock = m.contract("FlashLoan", [addressProvider], {
    gasLimit: 8000000,
  });

  return { lock };
});
