// brunch-config.js
module.exports = {
  files: {
    javascripts: {joinTo: 'js/app.js'},
    stylesheets: {joinTo: 'css/app.css'}
  },

  plugins: {
    elmBrunch: {
      mainModules: ['app/elm/Main.elm'],
      outputFolder: 'public/js',
      executablePath: 'node_modules/elm/bin',
      /* '--debug' parameter activates Elm 0.18 history debugger */
      makeParameters: '--debug'
    },
  },
  overrides: {
    production: {
      plugins: {
        elmBrunch: {
          makeParameters: []
        }
      }
    }
  }
}
