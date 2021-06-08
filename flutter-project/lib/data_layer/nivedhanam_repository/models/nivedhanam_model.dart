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

  @override
  List<Object?> get props => [id, name];
}
