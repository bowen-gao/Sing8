"use strict";
const db = require("../config/database");

const viewOneRecord_By_Id = id => {
	return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Record WHERE record_id = $1;", [id])
      .then(data => {
        resolve(data[0]);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllRecord_By_Singer = email => {
	return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Record WHERE singer = $1;", [email])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllRecord_By_SoundtrackID = soundtrack_id => {
	return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Record WHERE soundtrack_id = $1;", [soundtrack_id])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllRecord_By_SoundtrackTitle = soundtrack_Title => {
	return new Promise((resolve, reject) => {
    db.query("SELECT Record.* FROM Record,Soundtrack WHERE Record.soundtrack_id = Soundtrack.soundtrack_id AND Soundtrack.name LIKE '%$1%';", [soundtrack_Title])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllRecord_By_SoundtrackSinger = soundtrack_singer => {
	return new Promise((resolve, reject) => {
    db.query("SELECT Record.* FROM Record,Soundtrack WHERE Record.soundtrack_id = Soundtrack.soundtrack_id AND Soundtrack.singer LIKE '%$1%';", [soundtrack_singer])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const createOneRecord = (singer, soundtrack_id, score, time_create, tags, file_link) => {
	return new Promise((resolve, reject) => {
    db.none(
      "INSERT INTO Record(singer, soundtrack_id, score, time_create, tags, file_link) VALUES ($1, $2, $3, $4, $5, $6);",
      [singer, soundtrack_id, score, time_create, tags, file_link]
    )
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const deleteOneRecord = id => {
	return new Promise((resolve, reject) => {
    db.none("DELETE FROM Record WHERE record_id = $1;", [id])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

module.exports = {
  viewOneRecord_By_Id: viewOneRecord_By_Id,
  viewAllRecord_By_Singer: viewAllRecord_By_Singer,
  createOneRecord: createOneRecord,
	deleteOneRecord: deleteOneRecord,
	viewAllRecord_By_SoundtrackID: viewAllRecord_By_SoundtrackID,
	viewAllRecord_By_SoundtrackTitle: viewAllRecord_By_SoundtrackTitle,
	viewAllRecord_By_SoundtrackSinger: viewAllRecord_By_SoundtrackSinger
};
