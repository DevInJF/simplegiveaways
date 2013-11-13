SG = {
  UI: {},
  Paths: {},
  StripeClient: {},
  Giveaways: {}
};

$(function() {
  SG.UI.initialize();
  SG.Giveaways.initialize();
  SG.StripeClient.initialize();
});
