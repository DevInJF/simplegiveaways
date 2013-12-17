function deepFreeze (o) {
  var prop, propKey;
  Object.freeze(o);
  for (propKey in o) {
    prop = o[propKey];
    if (!o.hasOwnProperty(propKey) || !(typeof prop === "object") || Object.isFrozen(prop)) {
      continue;
    }
    deepFreeze(prop);
  }
}

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
