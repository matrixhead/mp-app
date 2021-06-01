class Nivedhanam {
  Nivedhanam.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        id = json['_id'],
        name = json['name'],
        address = json['address'],
        letterno = json['letterno'],
        date = json['date'],
        replyRecieved = json['reply_recieved'],
        amountSanctioned = json['amount_sanctioned'],
        dateSanctioned = json['date_sanctioned'],
        remarks = json['remarks'];

  final String url;
  final String id;
  final String name;
  final String address;
  final int letterno;
  final String date;
  final String replyRecieved;
  final double amountSanctioned;
  final String dateSanctioned;
  final String remarks;
}
