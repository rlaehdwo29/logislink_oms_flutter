import 'package:json_annotation/json_annotation.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';

class StopPointModel extends ReturnMap {

  String? orderId;
  int? stopSeq;
  int? stopNo;
  String? eComName;
  String? eAddr;
  String? eAddrDetail;
  String? eStaff;
  String? eTel;
  String? finishYn;
  String? finishDate;
  String? goodsWeight;
  double? eLat;
  double? eLon;
  String? weightUnitCode;
  String? goodsQty;
  String? qtyUnitCode;
  String? qtyUnitName;
  String? goodsName;
  String? useYn;
  String? stopSe;             //S:상차지, E:하차지

  StopPointModel({
    this.orderId,
    this.stopSeq,
    this.stopNo,
    this.eComName,
    this.eAddr,
    this.eAddrDetail,
    this.eStaff,
    this.eTel,
    this.finishYn,
    this.finishDate,
    this.goodsWeight,
    this.eLat,
    this.eLon,
    this.weightUnitCode,
    this.goodsQty,
    this.qtyUnitCode,
    this.qtyUnitName,
    this.goodsName,
    this.useYn,
    this.stopSe
  });

  factory StopPointModel.fromJSON(Map<String,dynamic> json) {
    return StopPointModel(
        orderId : json["orderId"],
        stopSeq : json["stopSeq"],
        stopNo : json["stopNo"],
        eComName : json["eComName"],
        eAddr : json["eAddr"],
        eAddrDetail : json["eAddrDetail"],
        eStaff : json["eStaff"],
        eTel : json["eTel"],
        finishYn : json["finishYn"],
        finishDate : json["finishDate"],
        goodsWeight : json["goodsWeight"].toString(),
        eLat : json["eLat"],
        eLon : json["eLon"],
        weightUnitCode : json["weightUnitCode"],
        goodsQty : json["goodsQty"],
        qtyUnitCode : json["qtyUnitCode"],
        qtyUnitName : json["qtyUnitName"],
        goodsName : json["goodsName"],
        useYn : json["useYn"],
        stopSe : json["stopSe"]
    );
  }

  Map<String,dynamic> toJson() {
    return {
      "eAddr": eAddr,
      "eAddrDetail": eAddrDetail,
      "eComName": eComName,
      "eLat": eLat,
      "eLon": eLon,
      "eStaff": eStaff,
      "eTel": eTel,
      "stopSe": stopSe
    };
  }

  Map<String,dynamic> toMap() {
    return <String,dynamic>{
      "orderId": orderId,
      "stopSeq": stopSeq,
      "stopNo": stopNo,
      "eComName": eComName,
      "eAddr": eAddr,
      "eAddrDetail": eAddrDetail,
      "eStaff": eStaff,
      "eTel": eTel,
      "finishYn": finishYn,
      "finishDate": finishDate,
      "goodsWeight": goodsWeight,
      "eLat": eLat,
      "eLon": eLon,
      "weightUnitCode": weightUnitCode,
      "goodsQty": goodsQty,
      "qtyUnitCode": qtyUnitCode,
      "qtyUnitName": qtyUnitName,
      "goodsName": goodsName,
      "useYn": useYn,
      "stopSe": stopSe
    };
  }

}