const recordModel = require("../models/record");
const fs = require('fs');
const path = require('path');

let createOneRecord = async (ctx, next) => {

	// Referenced to: https://github.com/koajs/examples
	const file = ctx.request.files.file;
	const reader = fs.createReadStream(file.path);
	const stream = fs.createWriteStream(path.join("./cache/", ctx.request.body.username + "+" + ctx.request.body.music + "+" + ctx.request.body.timestamp+"+.wav"));
	reader.pipe(stream);
	console.log('uploading %s -> %s', file.name, stream.path);

	recordModel.addRecord(ctx.request.body.score, ctx.request.body.username, ctx.request.body.music, ctx.request.body.username + "+" + ctx.request.body.music + "+" + ctx.request.body.timestamp + "+.wav", ctx.request.body.timestamp);
	ctx.status = 200;
	ctx.body = { status: "ok"};
}

let showAllByTitle = async (ctx, next) => {
	let result = recordModel.showByTitle(ctx.params.title);
	if (result!==undefined && result.length > 0) {
		ctx.status = 200;
		ctx.body = { status: "ok", result: result};
	} else {
		ctx.status = 404;
		ctx.body = { status: "not_found"}
	}
}

let deleteAll = async (ctx, next) => {
	recordModel.clearRecord();
	ctx.status = 200;
	ctx.body = { status: "ok"};
}

module.exports = {
	createOneRecord: createOneRecord,
	showAllByTitle: showAllByTitle,
	deleteAll: deleteAll
};

