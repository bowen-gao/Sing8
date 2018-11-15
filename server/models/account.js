"use strict";
const db = require("../config/database");

const viewOneAccount_By_Email = email => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Account WHERE email = $1;", [email])
      .then(function(data) {
        resolve(data[0]);
      })
      .catch(function(error) {
        reject("ERROR:", error);
      });
  });
};

const viewOneAccount_By_Phone = phone => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Account WHERE phone = $1;", [phone])
      .then(function(data) {
        resolve(data[0]);
      })
      .catch(function(error) {
        reject("ERROR:", error);
      });
  });
};

const createOneAccount = () => {};

const updateAccount_Phone = email => {};

const deleteOneAccount = email => {};

module.exports = {
  viewOneAccount_By_Email: viewOneAccount_By_Email,
  viewOneAccount_By_Phone: viewOneAccount_By_Phone,
  createOneAccount: createOneAccount,
  updateAccount_Phone: updateAccount_Phone,
  deleteOneAccount: deleteOneAccount
};
