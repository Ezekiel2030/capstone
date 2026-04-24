output "budget_arn" {
  description = "The ARN of the created budget"
  value       = aws_budgets_budget.monthly_account_budget.arn
}

output "budget_id" {
  description = "The ID of the budget"
  value       = aws_budgets_budget.monthly_account_budget.id
}
