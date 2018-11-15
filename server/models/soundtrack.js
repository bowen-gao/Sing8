"use strict";
const db = require("../config/database");

const viewOneSoundtrack_By_Id = id => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Soundtrack WHERE soundtrack_id = $1;", [id])
      .then(data => {
        resolve(data[0]);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllSoundtrack_By_Title = title => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Soundtrack WHERE title LIKE '%$1%';", [title])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllSoundtrack_By_Singer = singer => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Soundtrack WHERE singer = $1;", [singer])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllSoundtrack_By_Lyricist = lyricist => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Soundtrack WHERE lyricist = $1;", [lyricist])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllSoundtrack_By_Composer = composer => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Soundtrack WHERE composer = $1;", [composer])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const viewAllSoundtrack_By_Language = language => {
  return new Promise((resolve, reject) => {
    db.query("SELECT * FROM Soundtrack WHERE language = $1;", [language])
      .then(data => {
        resolve(data);
      })
      .catch(error => {
        reject("ERROR:", error);
      });
  });
};

const createOneSoundtrack = (title, size, singer, lyricist, composer, music_link, lyric_link, language) => {
	return new Promise((resolve, reject) => {
		db.none(
		  "INSERT INTO Soundtrack(title, size, singer, lyricist, composer, music_link, lyric_link, language) VALUES ($1, $2, $3, $4, $5, $6, $7, $8);",
		  [title, size, singer, lyricist, composer, music_link, lyric_link, language]
		)
		  .then(data => {
			resolve(data);
		  })
		  .catch(error => {
			reject("ERROR:", error);
		  });
	  });
};

const deleteOneSoundtrack = id => {
	return new Promise((resolve, reject) => {
		db.none("DELETE FROM Soundtrack WHERE soundtrack_id = $1;", [id])
		  .then(data => {
			resolve(data);
		  })
		  .catch(error => {
			reject("ERROR:", error);
		  });
	  });
};

module.exports = {
  viewOneSoundtrack_By_Id: viewOneSoundtrack_By_Id,
  viewAllSoundtrack_By_Title: viewAllSoundtrack_By_Title,
  viewAllSoundtrack_By_Singer: viewAllSoundtrack_By_Singer,
  viewAllSoundtrack_By_Lyricist: viewAllSoundtrack_By_Lyricist,
  viewAllSoundtrack_By_Composer: viewAllSoundtrack_By_Composer,
  viewAllSoundtrack_By_Language: viewAllSoundtrack_By_Language,
  createOneSoundtrack: createOneSoundtrack,
  deleteOneSoundtrack: deleteOneSoundtrack
};
