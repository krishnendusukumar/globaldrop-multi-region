const { SNSClient, PublishCommand } = require("@aws-sdk/client-sns");

const sns = new SNSClient({});

exports.handler = async (event) => {
  console.log("Event received:", JSON.stringify(event, null, 2));

  for (const record of event.Records) {
    // const bucket = record.s3.bucket.name;
    // const key = decodeURIComponent(record.s3.object.key.replace(/\+/g, " "));

    const command = new PublishCommand({
      TopicArn: process.env.SNS_TOPIC_ARN,
      Subject: `File Processed:`,
      Message: `File has been processed from bucket}`,
    });

    await sns.send(command);
    console.log(`SNS published for ${key}`);
  }

  return { status: "success" };
};
