"use strict";

let dataSet = new Object();

// All the test music is under licensed and provided by Bensound.com

dataSet["test"] = [
	[10, "testUser-a", "bensound-creativeminds.mp3", "2019-03-19-02-34"],
	[10, "testUser-b", "bensound-creativeminds.mp3", "2019-03-19-02-35"],
	[10, "testUser-c", "bensound-creativeminds.mp3", "2019-03-19-03-34"]
]

dataSet["分手后不要做朋友"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];

dataSet["离人"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["青花瓷"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["喜帖街"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["Jingle Bells"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];



dataSet["Just give me a reason"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["Lonely Christmas"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["My Heart Will Go On"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];

dataSet["Someone Like You"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];

dataSet["Yesterday Once More"] = [
	[10, "testUser", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


let addRecord = (score, username, musicTitle, fileLocation, timestamp) => {
	if (showByTitle(musicTitle) !== undefined) {
		dataSet[musicTitle].push([score, username, fileLocation, timestamp]);
		dataSet[musicTitle].sort((a, b)=> a[0] < b[0]);
	} else {
		dataSet[musicTitle] = [[score, username, fileLocation, timestamp]];
	}
}

let showByTitle = (musicTitle) => {
	// Only return top 10
	if (dataSet[musicTitle] == undefined || dataSet[musicTitle].length<=10) {
		return dataSet[musicTitle]
	}
	return dataSet[musicTitle].slice(0,10);
}

let clearRecord = (musicTitle) => {
	for (let key of Object.keys(dataSet)) {
		delete dataSet[key];
	}
}

module.exports = {
	addRecord: addRecord,
	showByTitle: showByTitle,
	clearRecord: clearRecord
};
