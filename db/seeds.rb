# Create SubscriptionPlans
Rake::Task["stripe:prepare"].invoke

SubscriptionPlan.single_page_monthly
SubscriptionPlan.single_page_yearly
SubscriptionPlan.multi_page_monthly
SubscriptionPlan.multi_page_yearly
