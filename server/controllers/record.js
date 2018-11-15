const Record = require("../models/record");

let showById = async (ctx, next) => {
  Record.viewOneRecord_By_Id(ctx.params.record_id)
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

let showBySinger = async (ctx, next) => {
  Record.viewAllRecord_By_Singer(ctx.params.singer)
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

let showBySoundtrack_id = async (ctx, next) => {
  Record.viewAllRecord_By_SoundtrackID(ctx.params.soundtrack_id)
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

let showBySoundtrack_title = async (ctx, next) => {
  Record.viewAllRecord_By_SoundtrackTitle(ctx.params.soundtrack_title)
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

let showBySoundtrack_singer = async (ctx, next) => {
  Record.viewAllRecord_By_SoundtrackSinger(ctx.params.soundtrack_singer)
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
  Record.createOneRecord(
    ctx.request.body.singer,
    ctx.request.body.soundtrack_id,
    ctx.request.body.score,
    ctx.request.body.time_create,
    ctx.request.body.tags,
    ctx.request.body.file_link
  )
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
  Record.deleteOneRecord(ctx.params.record_id)
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
  showBySinger: showBySinger,
  showBySoundtrack_id: showBySoundtrack_id,
  showBySoundtrack_title: showBySoundtrack_title,
  showBySoundtrack_singer: showBySoundtrack_singer,
  create: create,
  destroy: destroy
};
