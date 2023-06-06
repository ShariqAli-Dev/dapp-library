import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { Crud } from "../typechain-types";

describe("Escrow", async () => {
  let user: SignerWithAddress;
  let crud: Crud;

  beforeEach(async () => {
    [user] = await ethers.getSigners();
    // deploy
    const Crud = await ethers.getContractFactory("Crud");
    crud = await Crud.deploy();
  });

  describe("deployment", () => {
    it("has default id", async () => {
      const id = await crud.nextId();
      expect(id).to.be.equal(0);
    });

    it("has default users", async () => {
      const users = await crud.getUsers();
      expect(users.length).to.be.equal(0);
    });
  });
});
