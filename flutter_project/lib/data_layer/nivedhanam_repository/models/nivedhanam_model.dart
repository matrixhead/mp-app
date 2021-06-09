import 'package:equatable/equatable.dart';

class Nivedhanam extends Equatable {
  Nivedhanam.fromJson(Map<String, dynamic> json)
      : siNo = json['SI_no'],
        id = json['_id'],
        name = json['name'],
        address = json['address'],
        letterno = json['letterno'],
        date = json['date'],
        replyRecieved = json['reply_recieved'],
        amountSanctioned = json['amount_sanctioned'],
        dateSanctioned = json['date_sanctioned'],
        remarks = json['remarks'];

  final int siNo;
  final String id;
  final String name;
  final String address;
  final int letterno;
  final String date;
  final bool replyRecieved;
  final double amountSanctioned;
  final String dateSanctioned;
  final String remarks;

  Map<String, String> toMap() {
    return {
      "SI_no": this.siNo.toString(),
      "_id": this.id,
      "name": this.name,
      "address": this.address,
      "letterno": this.letterno.toString(),
      "date": this.date,
      "reply_recieved": this.replyRecieved.toString(),
      "amount_sanctioned": this.amountSanctioned.toString(),
      "date_sanctioned": this.dateSanctioned.toString(),
      "remarks": this.remarks
    };
  }

  @override
  List<Object?> get props => [id, name];
}
