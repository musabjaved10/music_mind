class SubscriptionsPriceModel {
  var planName, planTagLine, price, duration, subs_id;
  bool? haveBestValue;
  SubscriptionsPriceModel({
    this.subs_id,
    this.planName,
    this.planTagLine,
    this.price,
    this.duration,
    this.haveBestValue = false,
  });
}
