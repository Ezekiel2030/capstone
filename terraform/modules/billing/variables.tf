variable "budget_name" {
  description = "The name of the budget"
  type        = string
}

variable "limit_amount" {
  description = "The maximum spend limit for the month"
  type        = string
}

variable "subscriber_emails" {
  description = "List of email addresses to receive notifications"
  type        = list(string)
}

variable "threshold" {
  description = "The percentage of the budget to trigger a notification"
  type        = number
}