"use strict";

let dataSet = new Object();

// All the test music is under licensed and provided by Bensound.com

dataSet["test"] = [
	[10, "testUser-a", "bensound-creativeminds.mp3", "2019-03-19-02-34"],
	[10, "testUser-b", "bensound-creativeminds.mp3", "2019-03-19-02-35"],
	[10, "testUser-c", "bensound-creativeminds.mp3", "2019-03-19-03-34"]
]

dataSet["FenShouHouBuYaoZuoPengYou"] = [
	[10, "testUser-FS", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];

dataSet["LiRen"] = [
	[10, "testUser-LR", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["QingHuaCi"] = [
	[10, "testUser-QH", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["XiTieJie"] = [
	[10, "testUser-XT", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["JingleBells"] = [
	[10, "testUser-JB", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];



dataSet["Justgivemeareason"] = [
	[10, "testUser-JG", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["LonelyChristmas"] = [
	[10, "testUser-LC", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];


dataSet["MyHeartWillGoOn"] = [
	[10, "testUser-MH", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];

dataSet["SomeoneLikeYou"] = [
	[10, "testUser-SL", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
];

dataSet["YesterdayOnceMore"] = [
	[10, "testUser-YO", "bensound-creativeminds.mp3", "2019-03-19-02-34"]
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

let clearRecord = () => {
	for (let key of Object.keys(dataSet)) {
		delete dataSet[key];
	}
}

module.exports = {
	addRecord: addRecord,
	showByTitle: showByTitle,
	clearRecord: clearRecord
};
