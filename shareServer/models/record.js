"use strict";

let dataSet = new Object();

dataSet["test"] = [[100, "aaaaaa", "1.mp3", "2019-03-19-02-34"], [90, "bbbbbb", "2.mp3", "2019-03-19-02-35"], [90, "gggggg", "3.mp3", "2019-03-19-03-34"]]

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
