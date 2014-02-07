
# Dependencies
exec        = require('child_process').exec
fs          = require 'fs'
escapeShell = (arg) -> "'" + arg.replace(/[^\\]'/g, (m, i, s) -> m.slice(0, 1) + "\\'") + "'"

# Build task
task 'build', 'Compile CLI tool', ->

    # Build cli file
    exec 'coffee -c ' + escapeShell(__dirname+'/src/cli.coffee'), (err) ->
        if err then throw err
        js = ''+fs.readFileSync(__dirname+'/src/cli.js')
        js = '#!/usr/bin/env node'+"\n"+js
        unless fs.existsSync(__dirname+'/bin')
            fs.mkdirSync(__dirname+'/bin')
        fs.writeFileSync(__dirname+'/bin/ectrender', js)
        exec 'chmod +x ' + escapeShell(__dirname+'/bin/ectrender'), (err) ->
            if err then throw err
            fs.unlinkSync __dirname+'/src/cli.js'