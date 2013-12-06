SG = {
  UI: {},
  Paths: {},
  Graphs: {},
  StripeClient: {},
  Giveaways: {},
  Users: {}
};

$(function() {
  SG.UI.initialize();
  SG.Users.initialize();
  SG.Giveaways.initialize();
  SG.StripeClient.initialize();
});
