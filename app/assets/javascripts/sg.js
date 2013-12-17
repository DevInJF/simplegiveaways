SG = {
  UI: {},
  Graphs: {},
  StripeClient: {},
  Giveaways: {},
  Users: {}
};

_SG = {
  Config: {},
  CurrentUser: {},
  CurrentGiveaway: {},
  CurrentPage: {},
  Paths: {}
}

$(function() {
  SG.UI.initialize();
  SG.Users.initialize();
  SG.Giveaways.initialize();
  SG.StripeClient.initialize();
});
