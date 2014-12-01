var gulp = require('gulp'),
  gutil = require('gulp-util'),
  connect = require('gulp-connect'),
  concat = require('gulp-concat'),
  coffee = require('gulp-coffee'),
  coffeelint = require('gulp-coffeelint'),
  exec = require('gulp-exec'),
  sourcemaps = require('gulp-sourcemaps');

gulp.task('coffee', ['lint'], function() {
  gulp.src('lib/**/*.coffee')
    .pipe(sourcemaps.init())
    .pipe(coffee({ bare: true }).on('error', gutil.log))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('release'))
});

gulp.task('lint', function () {
  gulp.src('lib/**/*.coffee')
    .pipe(coffeelint({
      max_line_length: { level: 'ignore' }
    }))
    .pipe(coffeelint.reporter())
});

gulp.task('livereload', function() {
  gulp.src('test/*.html')
    .pipe(connect.reload())
});

gulp.task('watch', ['coffee'], function() {
  gulp.watch('lib/**/*.coffee', ['coffee', 'livereload']);
  gulp.watch('test/*.html', ['livereload']);
});

gulp.task('server', function() {
  connect.server({
    livereload: true,
    root: ['.', 'test'],
    port: 9000
  })
});

gulp.task('default', ['server', 'watch']);
