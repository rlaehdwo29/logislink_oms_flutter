
import 'package:json_annotation/json_annotation.dart';
import 'package:logislink_oms_flutter/common/model/result_model.dart';

part 'monitor_alloc_model.g.dart';

@JsonSerializable()
class MonitorAllocModel extends ResultModel {

  // 배차현황
  int? orderCnt;           // 전체오더
  int? allocCnt;           // 배차
  int? notAllocCnt;        // 미배차

  // 돈급별 배차대수
  int? cntTotal;
  int? cntSTotal;
  int? cntMTotal;
  int? cntLTotal;
  int? cntEtcTotal;
  int? cnt1T;
  int? cnt2T5;
  int? cnt3T5;
  int? cnt5T;
  int? cnt5A;
  int? cnt11T;
  int? cnt15T;
  int? cnt25T;
  int? cnt20FT;
  int? cnt40FT;
  int? cntETC;

  // 톤급별 운송비
  int? amtTotal;
  int? amtSTotal;
  int? amtMTotal;
  int? amtLTotal;
  int? amtEtcTotal;
  int? amt1T;
  int? amt2T5;
  int? amt3T5;
  int? amt5T;
  int? amt5A;
  int? amt11T;
  int? amt15T;
  int? amt25T;
  int? amt20FT;
  int? amt40FT;
  int? amtETC;

  MonitorAllocModel({
    // 배차현황
    this.orderCnt,           // 전체오,
    this.allocCnt,           // 배,
    this.notAllocCnt,        // 미배,

    // 돈급별 배차대수
    this.cntTotal,
    this.cntSTotal,
    this.cntMTotal,
    this.cntLTotal,
    this.cntEtcTotal,
    this.cnt1T,
    this.cnt2T5,
    this.cnt3T5,
    this.cnt5T,
    this.cnt5A,
    this.cnt11T,
    this.cnt15T,
    this.cnt25T,
    this.cnt20FT,
    this.cnt40FT,
    this.cntETC,

    // 톤급별 운송비
    this.amtTotal,
    this.amtSTotal,
    this.amtMTotal,
    this.amtLTotal,
    this.amtEtcTotal,
    this.amt1T,
    this.amt2T5,
    this.amt3T5,
    this.amt5T,
    this.amt5A,
    this.amt11T,
    this.amt15T,
    this.amt25T,
    this.amt20FT,
    this.amt40FT,
    this.amtETC
  });

  factory MonitorAllocModel.fromJSON(Map<String,dynamic> json) => _$MonitorAllocModelFromJson(json);

  Map<String,dynamic> toJson() => _$MonitorAllocModelToJson(this);

}
