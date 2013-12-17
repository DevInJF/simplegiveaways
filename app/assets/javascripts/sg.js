function deepFreeze (o) {
  Object.freeze(o);

  Object.getOwnPropertyNames(o).forEach(function (prop) {
    if (o.hasOwnProperty(prop)
    && o[prop] !== null
    && (typeof o[prop] === "object" || typeof o[prop] === "function")
    && !Object.isFrozen(o[prop])) {
      deepFreeze(o[prop]);
    }
  });

  return o;
};

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
