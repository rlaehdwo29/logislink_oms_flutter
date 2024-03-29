import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:logislink_oms_flutter/common/app.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';
import 'package:logislink_oms_flutter/common/model/customer_model.dart';
import 'package:logislink_oms_flutter/common/model/order_model.dart';
import 'package:logislink_oms_flutter/common/model/stop_point_model.dart';
import 'package:logislink_oms_flutter/common/model/user_model.dart';
import 'package:logislink_oms_flutter/common/strings.dart';
import 'package:logislink_oms_flutter/provider/dio_service.dart';
import 'package:logislink_oms_flutter/utils/util.dart';

class OrderService with ChangeNotifier {

  final orderList = List.empty(growable: true).obs;
  final orderRecentList = List.empty(growable: true).obs;
  final customerList = List.empty(growable: true).obs;
  List<StopPointModel> stopPointList = List.empty(growable: true);
  List<OrderModel> historyList = List.empty(growable: true);

  OrderService() {
    orderList.value = List.empty(growable: true);
    orderRecentList.value = List.empty(growable: true);
    customerList.value = List.empty(growable: true);
    stopPointList = List.empty(growable: true);
    historyList = List.empty(growable: true);
  }

  void init() {
    orderList.value = List.empty(growable: true);
    orderRecentList.value = List.empty(growable: true);
    customerList.value = List.empty(growable: true);
    stopPointList = List.empty(growable: true);
    historyList = List.empty(growable: true);
  }

  Future getStopPoint(BuildContext? context, String? orderId) async {
    Logger logger = Logger();
    var app = await App().getUserInfo();
    await DioService.dioClient(header: true).getStopPoint(app.authorization, orderId).then((it) {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getStopPoint() _response -> ${_response.status} // ${_response.resultMap}");

      if(_response.status == "200") {
        if(_response.resultMap?["data"] != null) {
          try{
            var list = _response.resultMap?["data"] as List;
            List<StopPointModel> itemsList = list.map((i) => StopPointModel.fromJSON(i)).toList();
            if(stopPointList.isNotEmpty) stopPointList.clear();
            stopPointList?.addAll(itemsList);
          }catch(e) {
            print(e);
          }
        } else {
          stopPointList = List.empty(growable: true);
        }
      }

    }).catchError((Object obj){
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getStopPoint() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getStopPoint() Error Default => ");
          break;
      }
    });
    return stopPointList;
  }

  Future getOrder(context, String? startDate, String? endDate, String? orderState, String? myOrder,int? page ) async {
    Logger logger = Logger();
    UserModel? user = await App().getUserInfo();
    orderList.value = List.empty(growable: true);
    int totalPage = 1;
    await DioService.dioClient(header: true).getOrder(
        user.authorization,
        startDate,
        endDate,
        orderState,
        myOrder,
        page
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getOrder() _response -> ${_response.status} // ${_response.resultMap}");
      //openOkBox(context,"${_response.resultMap}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
      var db = App().getRepository();
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if (_response.resultMap?["data"] != null) {
            try {
              var list = _response.resultMap?["data"] as List;
              List<OrderModel> itemsList = list.map((i) => OrderModel.fromJSON(i)).toList();
              if(itemsList.length > 0){
                if(page == 1) await db.deleteAll();
                await db.insertAll(context,itemsList);
              }else{
                await db.deleteAll();
              }
              if(orderList.isNotEmpty) orderList.clear();
              var reposi_order = await db.getOrderList(context);
              orderList?.addAll(reposi_order);
              totalPage = Util.getTotalPage(int.parse(_response.resultMap?["total"]));
            } catch (e) {
              print(e);
            }
          } else {
            orderList.value = List.empty(growable: true);
          }
        }else{
          openOkBox(context,"${_response.resultMap?["msg"]}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
        }
      }else{
        orderList.value = List.empty(growable: true);
        await db.deleteAll();
      }
    }).catchError((Object obj){
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getOrder() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getOrder() getOrder Default => ");
          break;
      }
    });
    Map<String,dynamic> maps = {"total":totalPage,"list":orderList};
    return maps;
  }

  Future getRecentOrder(context, String? startDate, String? endDate, int? page) async {
    Logger logger = Logger();
    UserModel? user = await App().getUserInfo();
    orderRecentList.value = List.empty(growable: true);
    int totalPage = 1;
    await DioService.dioClient(header: true).getRecentOrder(user.authorization, startDate, endDate, page).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getRecentOrder() _response -> ${_response.status} // ${_response.resultMap}");
      //openOkBox(context,"${_response.resultMap}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if (_response.resultMap?["data"] != null) {
            try {
              var list = _response.resultMap?["data"] as List;
              List<OrderModel> itemsList = list.map((i) => OrderModel.fromJSON(i)).toList();
              if(orderRecentList.isNotEmpty) orderRecentList.clear();
              orderRecentList?.addAll(itemsList);
              totalPage = Util.getTotalPage(int.parse(_response.resultMap?["total"]));
            } catch (e) {
              print(e);
            }
          } else {
            orderRecentList.value = List.empty(growable: true);
          }
        }else{
          openOkBox(context,"${_response.resultMap?["msg"]}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
        }
      }
    }).catchError((Object obj){
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getRecentOrder() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getRecentOrder() getOrder Default => ");
          break;
      }
    });
    Map<String,dynamic> maps = {"total":totalPage,"list":orderRecentList};
    return maps;
  }

  Future getCustomer(BuildContext? context, String? sellBuySctn, String? custName, String? telnum) async {
    Logger logger = Logger();
    var app = await App().getUserInfo();
    await DioService.dioClient(header: true).getCustomer(app.authorization, sellBuySctn,custName,telnum).then((it) {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getCustomer() _response -> ${_response.status} // ${_response.resultMap}");

      if(_response.status == "200") {
        if(_response.resultMap?["data"] != null) {
          try{
            var list = _response.resultMap?["data"] as List;
            List<CustomerModel> itemsList = list.map((i) => CustomerModel.fromJSON(i)).toList();
            if(customerList.isNotEmpty) customerList.clear();
            customerList.addAll(itemsList);
          }catch(e) {
            print(e);
          }
        }else{
          customerList.value = List.empty(growable: true);
        }
      }

    }).catchError((Object obj){
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getCustomer() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getCustomer() Error Default => ");
          break;
      }
    });
    return customerList;
  }

}