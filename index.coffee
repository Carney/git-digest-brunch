replace = require 'replace'
chomp = require 'chomp'
exec = require('child_process').exec

module.exports = class GitDigest

  brunchPlugin: true

  constructor: (@config) ->

  onCompile: ->
    @execute 'git rev-parse --short HEAD', @replace

  execute: (command, callback) ->
    exec command, (error, stdout, stderr) -> callback stdout

  replace: (digest) =>
    replace
      regex: /\?DIGEST/g
      replacement: '?' + digest.chomp()
      paths: [@config.paths.public]
      recursive: true
      silent: true

    for keyword, processer of @config.keyword.map
      keywordRE = RegExp keyword, "g"
      replace
        regex: keywordRE
        replacement: processer
        paths: [@config.paths.public]
        recursive: true
        silent: true
