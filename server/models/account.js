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

const viewOneAccount_By_Phone = (country_code, phone) => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Account WHERE country_code = $1 AND phone = $2;", [country_code, phone])
      .then(function(data) {
        resolve(data[0]);
      })
      .catch(function(error) {
        reject("ERROR:", error);
      });
  });
};

const createOneAccount = (
  email,
  role,
  country_code,
  phone,
  password,
  last_login
) => {
  return new Promise((resolve, reject) => {
    db.none(
      "INSERT INTO Account(email,role,countrycode,phone,password,last_login) VALUES ($1, $2, $3, $4, $5, $6);",
      [email, role, country_code, phone, password, last_login]
    )
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const updateAccount_Phone = (email, country_code, phone) => {
  return new Promise((resolve, reject) => {
    db.none(
      "UPDATE Account SET country_code = $1, phone = $2 WHERE email = $3;",
      [country_code, phone, email]
    )
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        console.log("ERROR:", error);
        reject("ERROR:", error);
      });
  });
};

const updateAccount_Password = (email, password) => {
  return new Promise((resolve, reject) => {
    db.none("UPDATE Account SET password = $1 WHERE email = $2;", [
      password,
      email
    ])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        console.log("ERROR:", error);
        reject("ERROR:", error);
      });
  });
};

const deleteOneAccount = email => {
  return new Promise((resolve, reject) => {
    db.none("DELETE FROM Account WHERE email = $1;", [email])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

module.exports = {
  viewOneAccount_By_Email: viewOneAccount_By_Email,
  viewOneAccount_By_Phone: viewOneAccount_By_Phone,
  createOneAccount: createOneAccount,
  updateAccount_Phone: updateAccount_Phone,
  deleteOneAccount: deleteOneAccount,
  updateAccount_Password: updateAccount_Password
};
