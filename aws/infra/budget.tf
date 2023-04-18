

resource "aws_budgets_budget" "budget" {
  name        = "${local.project_name}-Budget"
  budget_type = "COST"

  cost_types {
    include_credit = false
    include_discount = true
    include_other_subscription = true
    include_recurring = true
    include_refund = true
    include_subscription = true
    include_support = true
    include_tax = true
    include_upfront = true
  }

  limit_amount            = local.limit_amount
  limit_unit              = "USD"
  time_unit               = "MONTHLY"

  dynamic "notification" {
    for_each = range(1, (local.limit_amount / local.incremental_value) + 1)
    content {
      notification_type = "ACTUAL"
      comparison_operator = "GREATER_THAN"
      threshold = (1 + notification.key) * local.incremental_value
      threshold_type = "ABSOLUTE_VALUE"
      subscriber_email_addresses = [local.email_notification]
    }
  }
}