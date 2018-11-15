"use strict";
const db = require("../config/database");

const viewOneProfile_By_Email = email => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Profile WHERE email = $1;", [email])
      .then(data => {
        resolve(data[0]);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllProfile_By_username = username => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Profile WHERE username = $1;", [username])
      .then(data => {
        resolve(data[0]);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const createOneProfile = (email, username, facebook, twitter, weibo) => {
  return new Promise((resolve, reject) => {
    db.none(
      "INSERT INTO Profile(email,username,facebook,twitter,weibo) VALUES ($1, $2, $3, $4, $5);",
      [email, username, facebook, twitter, weibo]
    )
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const deleteOneProfile = email => {
  return new Promise((resolve, reject) => {
    db.none("DELETE FROM Profile WHERE email = $1;", [email])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const updateOneProfile_facebook = (email, facebook) => {
  return new Promise((resolve, reject) => {
    db.none("UPDATE Profile SET facebook = $1 WHERE email = $2;", [
      facebook,
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

const updateOneProfile_twitter = (email, twitter) => {
  return new Promise((resolve, reject) => {
    db.none("UPDATE Profile SET twitter = $1 WHERE email = $2;", [
      twitter,
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

const updateOneProfile_weibo = (email, weibo) => {
  return new Promise((resolve, reject) => {
    db.none("UPDATE Profile SET weibo = $1 WHERE email = $2;", [weibo, email])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        console.log("ERROR:", error);
        reject("ERROR:", error);
      });
  });
};

const updateOneProfile_username = (email, username) => {
  return new Promise((resolve, reject) => {
    db.none("UPDATE Profile SET username = $1 WHERE email = $2;", [
      username,
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

module.exports = {
  viewOneProfile_By_Email: viewOneProfile_By_Email,
  viewAllProfile_By_username: viewAllProfile_By_username,
  createOneProfile: createOneProfile,
  deleteOneProfile: deleteOneProfile,
  updateOneProfile_facebook: updateOneProfile_facebook,
  updateOneProfile_twitter: updateOneProfile_twitter,
  updateOneProfile_weibo: updateOneProfile_weibo,
  updateOneProfile_username: updateOneProfile_username
};
