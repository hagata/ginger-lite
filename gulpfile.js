var gulp = require('gulp');
var del = require('del');
var sass = require('gulp-sass');
var fs = require('fs');
var path = require('path');
var merge = require('merge-stream');
var concat = require('gulp-concat');
var watch = require('gulp-watch');
var appengine = require('gulp-gae');

gulp.task('sass', function() {
  gulp.src('./_sass/global.scss')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./build/css'));
});

gulp.task('sass:partials', function() {

  return gulp.src('_modules/**/*.scss')
  .pipe(concat('_modules.scss'))
  .pipe(gulp.dest('_sass/'));

});

gulp.task('sass:watch', function() {
  gulp.watch('./_sass/**/*.scss', ['sass']);
});

gulp.task('clean', function() {
  return del('./build');
});

var appFiles = [
'app.yaml',
'main.py',
'assets/**/*',
'templates/**/*',
'_modules/**/*.html'];

gulp.task('copy:build', function() {
  gulp.src(appFiles, {base: './'})
  .pipe(gulp.dest('build/'));
});

gulp.task('watch', function() {
  gulp.src(appFiles, {base: './'})
  .pipe(watch(appFiles))
  .pipe(gulp.dest('build/'));
});


 
gulp.task('gae-serve', function() {
  gulp.src('build/app.yaml')
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
 

