const Users = artifacts.require("UserCrud");

module.exports = function(deployer) {
  deployer.deploy(Users);
};
