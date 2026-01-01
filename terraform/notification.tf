resource "aws_sns_topic" "file_processed" {
    name = "globaldrop_file_processed"
}

resource "aws_ses_email_identity" "notification_email" {
    email = "krrishnendusukumar@gmail.com"
}

resource "aws_sns_topic_subscription" "email_notification" {
    topic_arn = aws_sns_topic.file_processed.arn
    protocol = "email"
    endpoint  = "krishnendusukumar@gmail.com"
}