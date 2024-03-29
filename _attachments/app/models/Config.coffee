$           = require('jquery')
Backbone    = require('backbone')
Backbone.$  = $

class Config extends Backbone.Model
  initialize: ->
    @set
      _id: "coconut.config"

  fetch: (options) =>
    Coconut.database.get "coconut.config",
      (error,result) =>
        @set(result)
        Coconut.database.get "coconut.config.local",
          (error,result) =>
            Coconut.config.local = new Backbone.Model()
            Coconut.config.local.set(result)
            options.success?()

  title: -> @get("title") || "Coconut"

  # See app/config.js
  database_name: -> Coconut.database._db_name
  cloud_database_name: => @get("cloud_database_name") || @database_name()

  cloud_url: ->
    "#{@httpOrHttps()}://#{@cloud_url_no_http()}/#{@cloud_database_name()}"

  cloud_url_with_credentials: ->
    "#{@httpOrHttps()}://#{@get "cloud_credentials"}@#{@cloud_url_no_http()}/#{@cloud_database_name()}"

  cloud_log_url_with_credentials: ->
    "#{@httpOrHttps()}://#{@get "cloud_credentials"}@#{@cloud_url_no_http()}/#{@cloud_database_name()}-log"

  cloud_url_no_http: => @get("cloud").replace(/^https{0,1}:\/\//,"")

  httpOrHttps: =>
    if @get("cloud").match(/^https/)
      "https"
    else
      "http"

module.exports =  Config
