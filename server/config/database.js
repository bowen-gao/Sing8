"use strict";
const pgp = require("pg-promise")();

let db = pgp("postgres://username:password@domain:5432/name");

db.one("SELECT $1 AS value", 111111)
  .then(data => {
    console.log("Database Connected");
  })
  .catch(error => {
    console.log("ERROR:", error);
  });

module.exports = {
	db:db
};
