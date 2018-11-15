const Soundtrack = require("../models/soundtrack");

let showById = async (ctx, next) => {
  Soundtrack.viewOneSoundtrack_By_Id(ctx.params.soundtrack_id)
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

let showByTitle = async (ctx, next) => {
  Soundtrack.viewAllSoundtrack_By_Title(ctx.params.title)
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
  Soundtrack.viewAllSoundtrack_By_Singer(ctx.params.singer)
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

let showByLyricist = async (ctx, next) => {
  Soundtrack.viewAllSoundtrack_By_Lyricist(ctx.params.lyricist)
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

let showByComposer = async (ctx, next) => {
  Soundtrack.viewAllSoundtrack_By_Composer(ctx.params.composer)
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

let showByLanguage = async (ctx, next) => {
  Soundtrack.viewAllSoundtrack_By_Language(ctx.params.language)
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
  Soundtrack.createOneSoundtrack(
    ctx.request.body.title,
    ctx.request.body.size,
    ctx.request.body.singer,
    ctx.request.body.lyricist,
    ctx.request.body.composer,
    ctx.request.body.music_link,
    ctx.request.body.lyric_link,
    ctx.request.body.language
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
  Soundtrack.deleteOneSoundtrack(ctx.params.soundtrack_id)
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
  showByTitle: showByTitle,
  showBySinger: showBySinger,
  showByLyricist: showByLyricist,
  showByComposer: showByComposer,
  showByLanguage: showByLanguage,
  create: create,
  destroy: destroy
};
