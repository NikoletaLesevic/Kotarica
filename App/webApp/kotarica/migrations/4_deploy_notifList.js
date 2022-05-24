const NotificationList = artifacts.require("NotificationList");

module.exports = function (deployer) {
  deployer.deploy(NotificationList);
};