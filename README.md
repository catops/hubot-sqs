# hubot-sqs [![Build Status](https://img.shields.io/travis/catops/hubot-sqs.svg?maxAge=2592000&style=flat-square)](https://travis-ci.org/catops/hubot-sqs) [![npm](https://img.shields.io/npm/v/hubot-sqs.svg?maxAge=2592000&style=flat-square)](https://www.npmjs.com/package/hubot-sqs)

:cat: Send AWS SQS messages to Hubot

See [`src/sqs.coffee`](src/sqs.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-sqs --save`

Then add **hubot-sqs** to your `external-scripts.json`:

```json
["hubot-sqs"]
```

## Configuration

### HUBOT_AWS_SQS_QUEUE_URL

You have to specify the queue URL to pull commands from.

e.g.: `https://sqs.us-east-1.amazonaws.com/XXXXXXXXXXXXX/hubot-queue`

### HUBOT_AWS_SQS_ACCESS_KEY_ID, HUBOT_AWS_SQS_SECRET_ACCESS_KEY

Your AWS account's access key ID and secret access key.

### HUBOT_AWS_SQS_REGION

You can configure the region of SQS with HUBOT_AWS_SQS_REGION, which defaults to `us-east-1`.

## Commands

The SQS messages needs to be in the following JSON format:

```json
{
    "MessageBody": "What's up?!",
    "MessageAttributes": {
        "user": {
            "DataType": "String",
            "StringValue": "CFPBot"
        },
        "room": {
            "DataType": "String",
            "StringValue": "off-topic"
        }
    }
}

```

Assuming the above JSON is in a file called `message.json`, it can be sent to SQS using the command:

```sh
aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/XXXXXXXXXXXXX/hubot-queue --cli-input-json file://message.json
```

Hubot will receive the message and post it to the specified room.

## Original author

Tatsuhiko Miyagawa (check out [hubot-incoming-sqs](https://github.com/miyagawa/hubot-incoming-sqs))

## Contributing

Please read our general [contributing guidelines](CONTRIBUTING.md).

## Open source licensing info
1. [TERMS](TERMS.md)
2. [LICENSE](LICENSE)
3. [CFPB Source Code Policy](https://github.com/cfpb/source-code-policy/)
