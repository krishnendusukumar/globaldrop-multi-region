resource "aws_iam_role" "lambda_exec" {
    name = "globaldrop-lambda-exec-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {Service = "lambda.amazonaws.com"}
        }]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_sqs" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_exec" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_lambda_function" "file_processor" {
    filename = "lambda/function.zip"
    function_name = "globaldrop-file-processor"
    role = aws_iam_role.lambda_exec.arn
    handler = "index.handler"
    runtime = "nodejs20.x"
    timeout = 60

    source_code_hash = filebase64sha256("lambda/function.zip")

    environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.file_processed.arn  
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
    event_source_arn = aws_sqs_queue.processing_queue.arn
    function_name = aws_lambda_function.file_processor.arn
    enabled = true
}