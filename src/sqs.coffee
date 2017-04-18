# Description
#   Send AWS SQS messages to Hubot
#
# Configuration:
#   HUBOT_AWS_SQS_QUEUE_URL - SQS queue to listen to, e.g. https://sqs.us-east-1.amazonaws.com/XXXXXXXXXXXXX/hubot
#   HUBOT_AWS_SQS_ACCESS_KEY_ID - AWS access key id with SQS permissions
#   HUBOT_AWS_SQS_SECRET_ACCESS_KEY - AWS secret key with SQS permissions
#   HUBOT_AWS_SQS_REGION - (optional) Defaults to 'us-east-1'
#
#
# Author:
#   Tatsuhiko Miyagawa
#   @chosak
#   @contolini

AWS = require 'aws-sdk'

module.exports = (robot) ->
  unless process.env.HUBOT_AWS_SQS_QUEUE_URL
    robot.logger.error "Disabling incoming-sqs plugin because HUBOT_AWS_SQS_QUEUE_URL is not set."
    return

  sqs = new AWS.SQS {
    region: process.env.HUBOT_AWS_SQS_REGION or process.env.AWS_REGION or 'us-east-1'
    accessKeyId: process.env.HUBOT_AWS_SQS_ACCESS_KEY_ID
    secretAccessKey: process.env.HUBOT_AWS_SQS_SECRET_ACCESS_KEY
  }

  receiver = (sqs, queue) ->
    robot.logger.debug "Fetching from #{queue}"
    sqs.receiveMessage {
      QueueUrl: queue
      MaxNumberOfMessages: 10
      VisibilityTimeout: 30
      WaitTimeSeconds: 20
      MessageAttributeNames: [
        "room"
        "user"
      ]
    }, (err, data) ->
      if err?
        robot.logger.error err
      else if data.Messages
        data.Messages.forEach (message) ->
          new Command({
              user: message.MessageAttributes.user.StringValue
              room: message.MessageAttributes.room.StringValue
            }
            message.Body
            robot
          ).run()
          sqs.deleteMessage {
            QueueUrl: queue
            ReceiptHandle: message.ReceiptHandle
          }, (err, data) ->
            robot.logger.error err if err?
      setTimeout receiver, 50, sqs, queue

  setTimeout receiver, 0, sqs, process.env.HUBOT_AWS_SQS_QUEUE_URL

class Command
  constructor: (@envelope, @message, @robot) ->

  run: ->
    try
      @robot.send @envelope, @message
    catch err
      @robot.logger.error err
