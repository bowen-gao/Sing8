'use strict';

const koa = require('koa');
const routers = require('./config/routes')
const bodyParser = require('koa-bodyparser');

const app = new koa();
app.use(bodyParser());


app.use(routers.routes()).use(routers.allowedMethods())

app.listen(3000);
