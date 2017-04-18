Helper = require 'hubot-test-helper'
sinon = require 'sinon'
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/sqs.coffee')

describe 'sqs', ->
  beforeEach ->
    @room = helper.createRoom()
    @room.user.isAdmin = true
    @room.robot.auth = isAdmin: =>
      return @room.user.isAdmin

  afterEach ->
    @room.destroy()

  it 'does absolutely nothing interactive', ->
    @room.user.say('alice', '@hubot hello').then =>
      expect(1 + 1).to.eql(2)
