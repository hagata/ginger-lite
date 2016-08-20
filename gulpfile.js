var gulp = require('gulp');
var sass = require('gulp-sass');
var fs = require('fs');
var path = require('path');
var merge = require('merge-stream');
var concat = require('gulp-concat');


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
 
gulp.task('sass:watch', function () {
  gulp.watch('./_sass/**/*.scss', ['sass']);
});