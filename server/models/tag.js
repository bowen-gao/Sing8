"use strict";
const db = require("../config/database");

const viewOneTag_By_id = id => {
	return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Tag WHERE tag_id = $1;", [id])
      .then(data => {
        resolve(data[0]);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllTags_By_Category = category => {
	return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Tag WHERE category = $1;", [category])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const createOneTag = (category,adjective) => {
	return new Promise((resolve, reject) => {
    db.none(
      "INSERT INTO Tag(category,adjective) VALUES ($1, $2);",
      [category,adjective]
    )
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const deleteOneTag = id => {
	return new Promise((resolve, reject) => {
    db.none("DELETE FROM Tag WHERE tag_id = $1;", [id])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

module.exports = {
  viewOneTag_By_id: viewOneTag_By_id,
  viewAllTags_By_Category: viewAllTags_By_Category,
  createOneTag: createOneTag,
  deleteOneTag: deleteOneTag
};
