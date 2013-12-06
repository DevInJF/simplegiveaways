# Create SubscriptionPlans
Rake::Task["stripe:prepare"].invoke

SubscriptionPlan.single_page
SubscriptionPlan.single_page_pro
SubscriptionPlan.multi_page_pro
