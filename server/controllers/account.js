/*
let test = async (ctx, next) => {};
*/
const Account = require("../models/account");

let showByEmail = async (ctx, next) => {
  Account.viewOneAccount_By_Email(ctx.params.email)
    .then(data => {
      if (data) {
        ctx.status = 200;
        ctx.body = { status: "found", result: data };
      } else {
        ctx.status = 404;
        ctx.body = { status: "not found" };
      }
    })
    .catch(error => {
      ctx.status = 500;
      ctx.body = { status: "server error" };
    });
};

let showByPhone = async (ctx, next) => {
  Account.viewOneAccount_By_Phone(ctx.params.country_code, ctx.params.email)
    .then(data => {
      if (data) {
        ctx.status = 200;
        ctx.body = { status: "ok", result: data };
      } else {
        ctx.status = 404;
        ctx.body = { status: "not found" };
      }
    })
    .catch(error => {
      ctx.status = 500;
      ctx.body = { status: "server error" };
    });
};

let create = async (ctx, next) => {
  Account.viewOneAccount_By_Email(ctx.request.body.email)
    .then(data => {
      if (data) {
        ctx.status = 400;
        ctx.body = { status: "account exists", result: data };
      } else {
        Account.createOneAccount(
          ctx.request.body.email,
          ctx.request.body.role,
          ctx.request.body.country_code,
          ctx.request.body.phone,
          ctx.request.body.password,
          ctx.request.body.last_login
        )
          .then(data => {
            ctx.status = 200;
            ctx.body = { status: "ok", result: data };
          })
          .catch(error => {
            ctx.status = 500;
            ctx.body = { status: "server error" };
          });
      }
    })
    .catch(error => {
      ctx.status = 500;
      ctx.body = { status: "server error" };
    });
};

let update = async (ctx, next) => {
  
};

let destroy = async (ctx, next) => {
  Account.deleteOneAccount(ctx.params.email)
    .then(data => {
      ctx.status = 200;
      ctx.body = { status: "ok"};
    })
    .catch(error => {
      ctx.status = 500;
      ctx.body = { status: "server error" };
    });
};

module.exports = {
  showByEmail: showByEmail,
  showByPhone: showByPhone,
  create: create,
  update: update,
  destroy: destroy
};
