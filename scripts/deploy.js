async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const Escrow = await ethers.getContractFactory("Escrow");
  const seller = "0x392af8Ea0A0933a838D2F31B820d811336431149"; // Test Wallet Addresses
  const arbiter = "0x9aA46c0270bbF647E6A811859789169f4a42E8eA"; // Test Wallet Addresses
  const escrow = await Escrow.deploy(seller, arbiter);

  // No need for .deployed(), just wait for the transaction
  await escrow.waitForDeployment(); // Use this instead if needed (ethers v6)
  console.log("Escrow deployed to:", escrow.target); // Use .target instead of .address in ethers v6
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});