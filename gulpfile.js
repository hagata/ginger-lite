var gulp = require('gulp');
var sass = require('gulp-sass');
var fs = require('fs');
var path = require('path');
var merge = require('merge-stream');
var concat = require('gulp-concat');
var watch = require('gulp-watch');
var appengine = require('gulp-gae');
 
gulp.task('parts', function() {
  return gulp.src('_modules/**/*.scss')
  .pipe(concat('_modules.scss'))
  .pipe(gulp.dest('_sass/'))
})

gulp.task('sass', ['parts'],function () {
  gulp.src('./_sass/global.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./static/css'));
});
  

gulp.task('sass:watch', function() {
  gulp.watch('./_sass/**/*.scss', ['sass']);
});
 
// TODO: Update the way we handle serving this project. 
// removed the /build directory for a simplified boilerplate
//  The following gulp-gae tasks were intended with use with a
// Docker container
gulp.task('gae-serve', function() {
  gulp.src('/app.yaml')
    .pipe(appengine('dev_appserver.py', [], {
      port: 8080,
      host: '0.0.0.0',
      admin_port: 8000,
      admin_host: '0.0.0.0',
      skip_sdk_update_check: undefined,
      use_mtime_file_watcher: undefined

    }));
});
 
 
gulp.task('gae-deploy', function() {
  gulp.src('app/app.yaml')
    .pipe(appengine('appcfg.py', ['update'], {
      version: 'dev',
      oauth2: undefined // for value-less parameters 
    }));
});


gulp.task('default', ['sass:partials','sass','copy:build','sass:watch', 'watch'])
 

