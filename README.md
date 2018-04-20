Hedwig Topic Terraform module
=============================

[Hedwig](https://github.com/Automatic/hedwig) is a inter-service communication bus that works on AWS SQS/SNS, while keeping things pretty simple and
straight forward. It uses [json schema](http://json-schema.org/) draft v4 for schema validation so all incoming
and outgoing messages are validated against pre-defined schema.

This module provides a custom [Terraform](https://www.terraform.io/) modules for deploying Hedwig infrastructure that
creates Hedwig topics.

## Usage

```hcl
module "topic-dev-user-updated" {
  source = "Automatic/hedwig-topic/aws"
  topic  = "dev-user-updated-v1"
}
```

It's recommended that `topic` include your environment, as well as a major version for the message schema. For 
example, [JSON Schema](http://json-schema.org/) is a good way to version message content while also keeping it 
human-readable. 

Naming convention - lowercase alphanumeric and dashes only.

The SNS topic name will be prefixed by `hedwig-`.

## Release Notes

[Github Releases](https://github.com/Automatic/terraform-aws-hedwig-topic/releases)

## How to publish

Go to [Terraform Registry](https://registry.terraform.io/modules/Automatic/hedwig-topic/aws), and Resync module.
