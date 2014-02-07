
# Dependencies
ArgumentParser  = require('argparse').ArgumentParser
ECT             = require('ect')
path            = require("path")
fs              = require("fs")

# CLI options
cli = new ArgumentParser(
    prog: "ectrender"
    version: require("../package.json").version
    addHelp: true
)
cli.addArgument ["-c", "--context"],
    help: "Context file path. Can be relative to the current directory or absolute path. Ex: context.json"

cli.addArgument ["-t", "--template"],
    help: "Context file path. Can be relative to the current directory or absolute path. Ex: template.ect"

cli.addArgument ["-o", "--output"],
    help: "Output file path. Can be relative to the current directory or absolute path. Ex: output.xml"

# Parse options
options = cli.parseArgs()
rootPath = process.cwd()

# Helpers
parsePath = (input) ->
    output = undefined
    return rootPath unless input?
    output = path.normalize(input)
    return rootPath if output.length is 0
    output = path.normalize(rootPath + "/./" + output) if output.charAt(0) isnt "/"
    return output.substr(0, output.length - 1) if output.length > 1 and output.charAt(output.length - 1) is "/"
    return output

# CLI parsed values
if not options.context?.length
    process.stderr.write "Missing context file path (--context)\n"
    process.exit 1
    
if not options.template?.length
    process.stderr.write "Missing template file path (--template)\n"
    process.exit 2
    
if not options.output?.length
    process.stderr.write "Missing output file path (--output)\n"
    process.exit 4

contextFilePath = parsePath options.context
templateFilePath = parsePath options.template
outputFilePath = parsePath options.output

# Get context
if not contextFilePath
    process.stderr.write "Missing context file path (--context)\n"
    process.exit 8
try
    json = fs.readFileSync(''+contextFilePath)
    if not json
        process.stderr.write "File doesn't exist at path: #{contextFilePath}\n"
        process.exit 16
    context = JSON.parse(json)
catch e
    process.stderr.write "Error when parsing context: #{e}\n"
    process.exit 32

# Initialize ECT
ectRootPath = templateFilePath[0...templateFilePath.lastIndexOf('/')]
renderer = ECT(root: ectRootPath)

# Perform rendering
try
    result = renderer.render templateFilePath, context
catch e
    process.stderr.write "Error when rendering template: #{e}\n"
    process.exit 64

# Write context to output
if result
    try
        fs.writeFileSync outputFilePath, result
        process.stdout.write "Done.\n"
        process.exit 0
    catch e
        process.stderr.write "Error when writing output: #{e}\n"
        process.exit 128
else
    process.stderr.write "Invalid output: #{result}\n"
    process.exit 256

