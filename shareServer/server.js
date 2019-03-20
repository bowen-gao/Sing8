"use strict";

const koa = require("koa");
const routers = require("./config/routes");
const koaBody = require("koa-body");
const koaStatic = require("koa-static");

const app = new koa();

app.use(koaBody({ multipart: true }));

app.use(routers.routes()).use(routers.allowedMethods());

app.use(koaStatic('cache'));

app.listen(3000);
