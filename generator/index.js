import fs from "fs";
import path from "path";
import keccak256 from "keccak256";
import { MerkleTree } from "merkletreejs";
import * as url from "url";

const __filename = url.fileURLToPath(import.meta.url);
const __dirname = url.fileURLToPath(new URL(".", import.meta.url));
const configPath = path.join(__dirname, "./configNFT.json");

const outputPath = path.join(__dirname, "./merkleNFT.json");

function throwError(message) {
  throw new Error(`${message}`);
}

// check if config file exists
if (!fs.existsSync(configPath)) {
  throwError("Missing config file");
}

//Read config file
const configNFT = await fs.readFileSync(configPath, "utf8");
const configData = JSON.parse(configNFT);

if (configData["addresses"] === undefined) {
  throwError("Missing addresses in config file");
}

const addresses = configData.addresses;

const leaves = addresses.map((x) => keccak256(x));
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const root = tree.getRoot().toString("hex");

fs.writeFileSync(
  outputPath,
  JSON.stringify({ root: root, tree: tree }, null, 2)
);
console.log("Merkle tree generated");
const leaf = keccak256("0x7A77B4a12830B2266783F69192c6cddEd93C959d");
const proof = tree.getProof(leaf);
console.log(tree.verify(proof, leaf, root));
// console.log(root);
