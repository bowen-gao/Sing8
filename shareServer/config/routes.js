const router = require("koa-router")();

const RecordController = require("../controllers/record");

const routers = router
	.post("/api/leaderboard", RecordController.createOneRecord)
	.get("/api/leaderboard/:title", RecordController.showAllByTitle)
	.get("/api/reset", RecordController.deleteAll)
	.get("/api/files", RecordController.showAllFiles);;

module.exports = routers;
