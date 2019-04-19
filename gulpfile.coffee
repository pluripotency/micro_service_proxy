gulp = require('gulp')
nodemon = require('gulp-nodemon')

gulp.task 'default', () =>
  nodemon
    script: './src/server/app.coffee'
    ext: 'coffee'
    watch: ['./src/server']
    env: { 'NODE_ENV': 'development' }

