gulp = require("gulp")
$ = do require("gulp-load-plugins")
runSequence = require("run-sequence")
del = require("del")
browserSync = require("browser-sync").create()
webpack = require("webpack")
webpackConfig = require("./webpack.config.coffee")


gulp.task("clean", (cb) ->
  del(["dist"], cb)
)


gulp.task("copy-assets", ->
  gulp.src("./assets/**/*", {
    base: "./assets"
    dot: true
  })
  .pipe(gulp.dest("./dist"))
  .pipe(browserSync.stream())
)


gulp.task("bs", ->
  browserSync.init({
    notify: false
    server: {
      baseDir: "./dist"
    }
  })
)


gulp.task("bs:reload", ->
  browserSync.reload()
)


gulp.task("webpack", (cb) ->
  webpack(webpackConfig, (err, stats) ->
    if err
      throw new $.util.PluginError("webpack", err)

    $.util.log("[webpack]", stats.toString())

    browserSync.reload()
    cb()
  )
)


gulp.task("uglify", ->
  gulp.src("./dist/js/*.js")
  .pipe($.uglify(preserveComments: "some"))
  .pipe(gulp.dest("./dist/js/"))
)


gulp.task("sass", ->
  gulp.src("./src/sass/**/*.scss")
  .pipe($.sass.sync(
    outputStyle: "compressed"
  ).on("error", $.sass.logError))
  .pipe($.autoprefixer())
  .pipe(gulp.dest("./dist/css"))
  .pipe(browserSync.stream())
)


gulp.task("build", (cb) ->
  runSequence(
    "clean",
    ["sass", "webpack", "copy-assets"],
    "uglify"
  )
)


gulp.task("default", ["bs", "sass", "webpack", "copy-assets"], ->

  $.watch("./src/coffee/**/*", ->
    gulp.start("webpack")
  )

  $.watch("./assets/**/*", ->
    gulp.start("copy-assets")
  )

  $.watch("./src/**/*.scss", ->
    gulp.start("sass")
  )
)
