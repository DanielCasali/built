(function (){
  'use strict';

  var util = require('util');

  var domain = "";
  process.argv.forEach(function (val, index, array) {
    console.log("Paramater: " + val);
    var arg = val.split("=");
    if (arg.length > 1) {
      if (arg[0] == "--domain") {
        domain = "." + arg[1];
        console.log("Setting domain to:", domain);
      }
    }
  });

  if (domain == "") {
    console.log("Environment variable: " + process.env.DOMAIN);
    if (process.env.DOMAIN != undefined) {
      console.log("Setting domain to default (for PCF): .apps.pcfeu.dev.dynatracelabs.com");
      domain = process.env.DOMAIN;
    }
  }

  module.exports = {
    catalogueUrl:  util.format("http://catalogue%s", domain),
    tagsUrl:       util.format("http://catalogue%s/tags", domain),
    cartsUrl:      util.format("http://carts%s/carts", domain),
    ordersUrl:     util.format("http://orders%s", domain),
    customersUrl:  util.format("http://user%s/customers", domain),
    addressUrl:    util.format("http://user%s/addresses", domain),
    cardsUrl:      util.format("http://user%s/cards", domain),
    loginUrl:      util.format("http://user%s/login", domain),
    registerUrl:   util.format("http://user%s/register", domain),
  };
}());
