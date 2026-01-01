resource "aws_sqs_queue" "processing_queue" {
    name = "globaldrop-processing-queue"
    visibility_timeout_seconds = 120  

    redrive_policy = jsonencode({
        deadLetterTargetArn = aws_sqs_queue.dlq_queue.arn
        maxReceiveCount = 5
    })
}

resource "aws_sqs_queue" "dlq_queue" {
    name = "globaldrop-processing-dlq"
    visibility_timeout_seconds = 120
}
