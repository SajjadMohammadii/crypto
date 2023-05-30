class crypto {
  String id;
  String name;
  String symbol;
  double changePercent24Hr;
  double priceUsd;
  double marketCapUsd;
  int rank;

  crypto(
    this.id,
    this.name,
    this.symbol,
    this.changePercent24Hr,
    this.priceUsd,
    this.marketCapUsd,
    this.rank,
  );

  factory crypto.fromMapJSON(Map<String, dynamic> JsonMapObject) {
    return crypto(
      JsonMapObject['id'],
      JsonMapObject['name'],
      JsonMapObject['symbol'],
      double.parse(JsonMapObject['changePercent24Hr']),
      double.parse(JsonMapObject['priceUsd']),
      double.parse(JsonMapObject['marketCapUsd']),
      int.parse(JsonMapObject['rank']),
    );
  }
}
