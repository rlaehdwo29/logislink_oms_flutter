import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:logislink_oms_flutter/common/app.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';
import 'package:logislink_oms_flutter/common/model/code_model.dart';
import 'package:logislink_oms_flutter/common/model/cust_user_model.dart';
import 'package:logislink_oms_flutter/common/model/sido_area_model.dart';
import 'package:logislink_oms_flutter/common/model/user_model.dart';
import 'package:logislink_oms_flutter/common/strings.dart';
import 'package:logislink_oms_flutter/constants/const.dart';
import 'package:logislink_oms_flutter/provider/dio_service.dart';
import 'package:logislink_oms_flutter/utils/sp.dart';
import 'package:dio/dio.dart';

class CodeService with ChangeNotifier {

  Future<List<CodeModel>> codeFilter(BuildContext context, String codeType, String? mFilter) async {
    List<CodeModel>? mList = List.empty(growable: true);
    if(mFilter?.isEmpty == true) {
      var list = await getCodeList(codeType);
      mList.addAll(list);
    } else {
      if(codeType == Const.SIDO_AREA) {
        mList = await getSidoArea(context,mFilter);
      }else{
        mList = await getCodeFilter(context,codeType,mFilter);
      }
    }
    return mList;
  }

  Future<List<CodeModel>> getCodeList(String codeType) async {
    List<CodeModel> mList = List.empty(growable: true);
    var list = await SP.getCodeList(codeType);
    mList.addAll(list);
    if (codeType == Const.ORDER_STATE_CD) {
      mList.insert(0, CodeModel(code: "",codeName: "전체"));
    }
    return mList;
  }

  Future<List<CodeModel>> getSidoArea(BuildContext context, String? mFilter) async {
    List<CodeModel> sidoList = List.empty(growable: true);
    if(sidoList.isNotEmpty) sidoList.clear();
    Logger logger = Logger();
    await DioService.dioClient(header: true).getSidoArea(mFilter).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getSidoArea() _response -> ${_response.status} // ${_response.resultMap}");
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if (_response.resultMap?["data"] != null) {
            var list = _response.resultMap?["data"] as List;
            List<SidoAreaModel> itemsList = list.map((i) => SidoAreaModel.fromJSON(i)).toList();
            for(var item in itemsList) {
              sidoList.add(CodeModel(code: item.areaCd,codeName: item.sigun));
            }
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
          print("getSidoArea() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getSidoArea() getOrder Default => ");
          break;
      }
    });
    return sidoList;
  }

  Future<List<CodeModel>> getDeptUser(BuildContext context, String mFilter) async {
    List<CodeModel> deptUserList = List.empty(growable: true);
    final controller = Get.find<App>();
    UserModel? user = await controller.getUserInfo();
    Logger logger = Logger();
    await DioService.dioClient(header: true).getCustUser(user.authorization,user.custId,mFilter
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getDeptUser() _response -> ${_response.status} // ${_response.resultMap}");
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if (_response.resultMap?["data"] != null) {
            var list = _response.resultMap?["data"] as List;
            List<CustUserModel> itemsList = list.map((i) => CustUserModel.fromJSON(i)).toList();
            deptUserList.add(CodeModel(code: "",codeName: "전체"));
            for(var item in itemsList) {
              deptUserList.add(CodeModel(code: item.userId,codeName: item.userName));
            }
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
          print("getDeptUser() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getDeptUser() getOrder Default => ");
          break;
      }
    });
    return deptUserList;
  }

  Future<List<CodeModel>> getCodeFilter(BuildContext context, String? codeType, String? mFilter) async {
    List<CodeModel> codeList = List.empty(growable: true);
    Logger logger = Logger();
    await DioService.dioClient(header: true).getCodeDetail(codeType,mFilter).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getCodeFilter() _response -> ${_response.status} // ${_response.resultMap}");
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if (_response.resultMap?["data"] != null) {
            var list = _response.resultMap?["data"] as List;
            List<CodeModel> itemsList = list.map((i) => CodeModel.fromJSON(i)).toList();
            codeList.addAll(itemsList);
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
          print("getCodeFilter() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getCodeFilter() getOrder Default => ");
          break;
      }
    });
    return codeList;
  }


}