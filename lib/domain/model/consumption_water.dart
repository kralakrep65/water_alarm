class Consumption {
  int id;
  double amount;
  String date;

  Consumption({required this.id, required this.amount, required this.date});
}

List<Consumption> convertQueryResultSet(List<Map<String, dynamic>> resultSet) {
  List<Consumption> consumptions = [];

  for (var row in resultSet) {
    Consumption consumption = Consumption(
      id: row['id'],
      amount: row['consumption_amount'],
      date: row['consumption_date'],
    );
    consumptions.add(consumption);
  }

  return consumptions;
}
