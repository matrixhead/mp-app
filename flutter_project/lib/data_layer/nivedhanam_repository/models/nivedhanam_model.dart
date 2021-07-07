import 'package:equatable/equatable.dart';

class Nivedhanam extends Equatable {
  Nivedhanam.fromJson(Map<String, dynamic> json)
      : siNo = json['SI_no'],
        categoryfields = json['categoryfields'],
        id = json['_id'],
        name = json['name'],
        address = json['address'],
        pincode = json['pincode'],
        letterno = json['letterno'],
        date = json['date'],
        mobile = json['mobile'],
        status = json['status'],
        amountSanctioned = json['amount_sanctioned'],
        dateSanctioned = json['date_sanctioned'],
        remarks = json['remarks'],
        category = json['Category'];

  final int siNo;
  final Map? categoryfields;
  final String id;
  final String name;
  final String? address;
  final int? pincode;
  final int letterno;
  final String date;
  final String? mobile;
  final String status;
  final double? amountSanctioned;
  final String? dateSanctioned;
  final String? remarks;
  final String? category;

  Map<String, dynamic> toMap() {
    return {
      "SI_no": this.siNo.toString(),
      "categoryfields": this.categoryfields,
      "_id": this.id.toString(),
      "name": this.name,
      "address": this.address,
      "pincode": this.pincode.toString(),
      "letterno": this.letterno.toString(),
      "date": this.date,
      "mobile": this.mobile,
      "status": this.status,
      "amount_sanctioned": this.amountSanctioned.toString(),
      "date_sanctioned": this.dateSanctioned.toString(),
      "remarks": this.remarks,
      'Category': this.category
    };
  }

  @override
  List<Object?> get props => [
        siNo,
        categoryfields,
        id,
        name,
        address,
        pincode,
        letterno,
        date,
        mobile,
        status,
        amountSanctioned,
        dateSanctioned,
        remarks,
        category
      ];
}
