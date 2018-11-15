const Tag = require("../models/tag");

let showById = async (ctx, next) => {
  Tag.viewOneTag_By_id(ctx.params.tag_id)
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

let showByCategory = async (ctx, next) => {
  Tag.viewAllTags_By_Category(ctx.params.category)
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
  Tag.createOneTag(ctx.request.body.category, ctx.request.body.adjective)
    .then(data => {
      ctx.status = 200;
      ctx.body = { status: "ok", result: data };
    })
    .catch(error => {
      ctx.status = 500;
      ctx.body = { status: "server error" };
    });
};

let destroy = async (ctx, next) => {
  Tag.deleteOneTag(ctx.params.tag_id)
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
  showById: showById,
  showByCategory: showByCategory,
  create: create,
  destroy: destroy
};
