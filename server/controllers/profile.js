const Profile = require("../models/profile");

let showByEmail = async (ctx, next) => {
  Profile.viewOneProfile_By_Email(ctx.params.email)
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

let showByUsername = async (ctx, next) => {
  Profile.viewAllProfile_By_Username(ctx.params.username)
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

let create = async (ctx, next) => {
  Profile.viewOneProfile_By_Email(ctx.request.body.email)
    .then(data => {
      if (data) {
        ctx.status = 400;
        ctx.body = { status: "profile exists", result: data };
      } else {
        Profile.createOneProfile(
          ctx.request.body.email,
          ctx.request.body.username,
          ctx.request.body.facebook,
          ctx.request.body.twitter,
          ctx.request.body.weibo
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
  Profile.deleteOneProfile(ctx.params.email)
    .then(data => {
      ctx.status = 200;
      ctx.body = { status: "ok" };
    })
    .catch(error => {
      ctx.status = 500;
      ctx.body = { status: "server error" };
    });
};

module.exports = {
  showByEmail: showByEmail,
  showByUsername: showByUsername,
  create: create,
  update: update,
  destroy: destroy
};
