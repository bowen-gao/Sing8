const router = require("koa-router")();

const AccountController = require("../controllers/account");
const ProfileController = require("../controllers/profile");
const RecordController = require("../controllers/record");
const SoundtrackController = require("../controllers/soundtrack");
const TagController = require("../controllers/tag");

const routers = router
  .post("/test", AccountController.test);

module.exports = routers;
