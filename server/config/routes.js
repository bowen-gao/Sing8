const router = require("koa-router")();

const AccountController = require("../controllers/account");
const ProfileController = require("../controllers/profile");
const RecordController = require("../controllers/record");
const SoundtrackController = require("../controllers/soundtrack");
const TagController = require("../controllers/tag");

const routers = router
  .get("/api/account/email/:email", AccountController.showByEmail)
  .get("/api/account/country_code/:country_code/phone/:phone", AccountController.showByPhone)
  .get("/api/profile/email/:email", ProfileController.showByEmail)
  .get("/api/profile/username/:username", ProfileController.showByUsername)
  .get("/api/tag/tag_id/:tag_id", TagController.showById)
  .get("/api/tag/category/:category", TagController.showByCategory)
  .get("/api/record/record_id/:record_id", RecordController.showById)
  .get("/api/record/singer/:singer", RecordController.showBySinger)
  .get("/api/record/soundtrack_id/:soundtrack_id", RecordController.showBySoundtrack_id)
  .get("/api/record/soundtrack_title/:soundtrack_title", RecordController.showBySoundtrack_title)
  .get("/api/record/soundtrack_singer/:soundtrack_singer", RecordController.showBySoundtrack_singer)
  .get("/api/soundtrack/soundtrack_id/:soundtrack_id", SoundtrackController.showById)
  .get("/api/soundtrack/title/:title", SoundtrackController.showByTitle)
  .get("/api/soundtrack/singer/:singer", SoundtrackController.showBySinger)
  .get("/api/soundtrack/lyricist/:lyricist", SoundtrackController.showByLyricist)
  .get("/api/soundtrack/composer/:composer", SoundtrackController.showByComposer)
  .get("/api/soundtrack/language/:language", SoundtrackController.showByLanguage)
  .post("/api/account", AccountController.create)
  .post("/api/profile", ProfileController.create)
  .post("/api/record", RecordController.create)
  .post("/api/soundtrack", SoundtrackController.create)
  .post("/api/tag", TagController.create)
  .put("/api/account/:email", AccountController.update)
  .put("/api/profile/:email", ProfileController.update)
  .del("/api/account/:email", AccountController.destroy)
  .del("/api/profile/:email", ProfileController.destroy)
  .del("/api/record/:record_id", RecordController.destroy)
  .del("/api/soundtrack/:soundtrack_id", SoundtrackController.destroy)
  .del("/api/tag/:tag_id", TagController.destroy);

module.exports = routers;
