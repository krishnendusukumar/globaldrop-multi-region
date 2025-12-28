# GlobalDrop – Multi-Region Active-Active File Processing Pipeline ⚡

**Live Demo** → (coming soon)  
**Status**: in progress

### Architecture
- 2 Regions: us-east-1 + eu-west-1 (active-active)
- S3 + Cross-Region Replication
- SQS + Lambda processing
- DynamoDB Global Table
- SNS + SES notification
- Full Terraform infra
- Next.js frontend