"use strict";
const db = require("../config/database");

const viewOneSoundtrack_By_Id = id => {};

const viewAllSoundtrack_By_Title = title => {};

const viewAllSoundtrack_By_Singer = singer => {};

const viewAllSoundtrack_By_Lyricist = lyricist => {};

const viewAllSoundtrack_By_Composer = composer => {};

const viewAllSoundtrack_By_Language = language => {};

const createOneSoundtrack = () => {};

const deleteOneSoundtrack = id => {};

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
