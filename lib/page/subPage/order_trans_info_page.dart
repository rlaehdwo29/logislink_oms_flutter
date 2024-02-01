import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:logislink_oms_flutter/common/app.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';
import 'package:logislink_oms_flutter/common/model/cust_user_model.dart';
import 'package:logislink_oms_flutter/common/model/customer_model.dart';
import 'package:logislink_oms_flutter/common/model/order_model.dart';
import 'package:logislink_oms_flutter/common/model/unit_charge_model.dart';
import 'package:logislink_oms_flutter/common/model/user_model.dart';
import 'package:logislink_oms_flutter/common/strings.dart';
import 'package:logislink_oms_flutter/common/style_theme.dart';
import 'package:logislink_oms_flutter/constants/const.dart';
import 'package:logislink_oms_flutter/page/subPage/reg_order/order_cust_user_page.dart';
import 'package:logislink_oms_flutter/page/subPage/reg_order/order_customer_page.dart';
import 'package:logislink_oms_flutter/provider/dio_service.dart';
import 'package:logislink_oms_flutter/utils/util.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:dio/dio.dart';

class OrderTransInfoPage extends StatefulWidget {

  OrderModel order_vo;
  String? unit_charge_local;
  String? code;

  OrderTransInfoPage({Key? key,required this.order_vo, this.unit_charge_local, this.code}):super(key:key);

  _OrderTransInfoPageState createState() => _OrderTransInfoPageState();
}


class _OrderTransInfoPageState extends State<OrderTransInfoPage> {

  ProgressDialog? pr;

  final code = "".obs;

  final mData = OrderModel().obs;
  final mOrderOption = OrderModel().obs;
  final userInfo = UserModel().obs;

  final controller = Get.find<App>();

  final isOption = false.obs;

  final ChargeCheck = "".obs;
  final mBuyChargeDummy = "".obs;

  late TextEditingController tvCustName;
  late TextEditingController etBuyChargeController;
  late TextEditingController etOtherAddMemoController;
  late TextEditingController etRegMemoController;


  @override
  void initState() {
    super.initState();

    tvCustName = TextEditingController();
    etBuyChargeController = TextEditingController();
    etOtherAddMemoController = TextEditingController();
    etRegMemoController = TextEditingController();

    Future.delayed(Duration.zero, () async {

      userInfo.value = await controller.getUserInfo();
      if(widget.order_vo != null) {
        var order = widget.order_vo;
        mData.value = OrderModel(
          orderId: order.orderId,
          reqCustId: order.reqCustId,
          reqDeptId: order.reqDeptId,
          reqStaff: order.reqStaff,
          reqTel: order.reqTel,
          reqAddr: order.reqAddr,
          reqAddrDetail: order.reqAddrDetail,
          custId: order.custId,
          custName: order.custName,
          deptId: order.deptId,
          deptName: order.deptName,
          inOutSctn: order.inOutSctn,
          inOutSctnName: order.inOutSctnName,
          truckTypeCode: order.truckTypeCode,
          truckTypeName: order.truckTypeName,
          sComName: order.sComName,
          sSido: order.sSido,
          sGungu: order.sGungu,
          sDong: order.sDong,
          sAddr: order.sAddr,
          sAddrDetail: order.sAddrDetail,
          sDate: order.sDate,
          sStaff: order.sStaff,
          sTel: order.sTel,
          sMemo: order.sMemo,
          eComName: order.eComName,
          eSido: order.eSido,
          eGungu: order.eGungu,
          eDong: order.eDong,
          eAddr: order.eAddr,
          eAddrDetail: order.eAddrDetail,
          eDate: order.eDate,
          eStaff: order.eStaff,
          eTel: order.eTel,
          eMemo: order.eMemo,
          sLat: order.sLat,
          sLon: order.sLon,
          eLat: order.eLat,
          eLon: order.eLon,
          goodsName: order.goodsName,
          goodsWeight: order.goodsWeight,
          weightUnitCode: order.weightUnitCode,
          weightUnitName: order.weightUnitName,
          goodsQty: order.goodsQty,
          qtyUnitCode: order.qtyUnitCode,
          qtyUnitName: order.qtyUnitName,
          sWayCode: order.sWayCode,
          sWayName: order.sWayName,
          eWayCode: order.eWayCode,
          eWayName: order.eWayName,
          mixYn: order.mixYn,
          mixSize: order.mixSize,
          returnYn: order.returnYn,
          carTonCode: order.carTonCode,
          carTonName: order.carTonName,
          carTypeCode: order.carTypeCode,
          carTypeName: order.carTypeName,
          chargeType: order.chargeType,
          distance: order.distance,
          time: order.time,
          reqMemo: order.reqMemo,
          driverMemo: order.driverMemo,
          itemCode: order.itemCode,
          itemName: order.itemName,
          orderState: order.orderState,
          orderStateName: order.orderStateName,
          regid: order.regid,
          regdate: order.regdate,
          stopCount: order.stopCount,
          sellAllocId: order.sellAllocId,
          sellCustId: order.sellCustId,
          sellDeptId: order.sellDeptId,
          sellStaff: order.sellStaff,
          sellCustName: order.sellCustName,
          sellDeptName: order.sellDeptName,
          sellCharge: order.sellCharge,
          sellFee: order.sellFee,
          allocId: order.allocId,
          allocState: order.allocState,
          allocStateName: order.allocStateName,
          buyCustId: order.buyCustId,
          buyDeptId: order.buyDeptId,
          buyCustName: order.buyCustName,
          buyDeptName: order.buyDeptName,
          buyStaff: order.buyStaff,
          buyStaffName: order.buyStaffName,
          buyStaffTel: order.buyStaffTel,
          buyCharge: order.buyCharge,
          buyFee: order.buyFee,
          allocDate: order.allocDate,
          driverState: order.driverState,
          vehicId: order.vehicId,
          driverId: order.driverId,
          carNum: order.carNum,
          driverName: order.driverName,
          driverTel: order.driverTel,
          driverStateName: order.driverStateName,
          receiptYn: order.receiptYn,
          receiptPath: order.receiptPath,
          receiptDate: order.receiptDate,
          charge: order.charge,
          startDate: order.startDate,
          finishDate: order.finishDate,
          enterDate: order.enterDate,
          orderStopList: order.orderStopList,
        );;
      }else{
        mData.value = OrderModel();
      }
      if(widget.code != null) {
        code.value = widget.code!;
      }
      if(widget.unit_charge_local != null) {
        mBuyChargeDummy.value = widget.unit_charge_local!;
      }

      if(mData.value.buyCustName?.isEmpty == true) {
        await getUnitChargeCnt();
      }

      await initView();
    });

  }

  @override
  void dispose() {
    super.dispose();
    tvCustName.dispose();
    etBuyChargeController.dispose();
    etOtherAddMemoController.dispose();
    etRegMemoController.dispose();
  }

  Future<void> initView() async {

    etBuyChargeController.text = mData.value.buyCharge??"0";
    isOption.value = code.value.isNotEmpty;

  }

  Future<void> getUnitChargeCnt() async {
    if(mData.value.buyCustId?.isEmpty == true || mData.value.buyCustId == null || mData.value.buyDeptId?.isEmpty == true || mData.value.buyDeptId == null) {
      return;
    }
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).getOmsUnitCnt(
        user.authorization,
        mData.value.buyCustId,
        mData.value.buyDeptId,
        user.custId,
        user.deptId
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("OrderTransInfoPage getUnitChargeCnt() _response -> ${_response.status} // ${_response.resultMap}");
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          ChargeCheck.value = _response.resultMap?["msg"];
          if(_response.resultMap?["msg"] == "Y") {
            await getUnitChargeCnt();
          }else{
            mData.value.buyCharge = (mBuyChargeDummy.value?.isEmpty == true || mBuyChargeDummy.value == null) ? "0":mBuyChargeDummy.value;
            initView();
          }
          //Navigator.of(context).pop({'code':200,Const.RESULT_WORK:Const.RESULT_SETTING_TRANS});
        }
      }
    }).catchError((Object obj) async {
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("OrderTransInfoPage getUnitChargeCnt() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("OrderTransInfoPage getUnitChargeCnt() getOrder Default => ");
          break;
      }
    });
  }

  Future<void> getUnitChargeData() async {
    if(ChargeCheck.value.isEmpty == true || ChargeCheck.value == null) {
      return;
    }
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).getOmsUnitCharge(
        user.authorization,
        mData.value.buyCustId,
        mData.value.buyDeptId,
        mData.value.sSido,
        mData.value.sGungu,
        mData.value.sDong,
        mData.value.eSido,
        mData.value.eGungu,
        mData.value.eDong,
        mData.value.carTonCode,
        mData.value.carTypeCode,
        mData.value.sDate,
        mData.value.eDate
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("OrderTransInfoPage getUnitChargeData() _response -> ${_response.status} // ${_response.resultMap}");
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if(_response.resultMap?["data"] != null) {
            UnitChargeModel value = UnitChargeModel.fromJSON(it.response.data["data"]);
            mData.value.buyCharge = value.unit_charge;
            await initView();
          }else{
            mData.value.buyCharge = mBuyChargeDummy.value;
            initView();
          }
        }
      }
    }).catchError((Object obj) async {
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("OrderTransInfoPage getUnitChargeData() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("OrderTransInfoPage getUnitChargeData() getOrder Default => ");
          break;
      }
    });
  }

  Future<void> save() async {
    await pr?.show();
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).setOptionTrans(
        user.authorization,
        "Y",
        mData.value.buyCustId,
        mData.value.buyDeptId,
        mData.value.buyStaff,
        mData.value.buyCharge,
        mData.value.driverMemo,
        mData.value.reqMemo
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("OrderTransInfoPage save() _response -> ${_response.status} // ${_response.resultMap}");
      await pr?.hide();
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          Navigator.of(context).pop({'code':200,Const.RESULT_WORK:Const.RESULT_SETTING_TRANS});
        }else{
          openOkBox(context,"${_response.resultMap?["msg"]}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
        }
      }
    }).catchError((Object obj) async {
      await pr?.hide();
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("OrderTransInfoPage save() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("OrderTransInfoPage save() getOrder Default => ");
          break;
      }
    });
  }

  void showResetDialog() {
    openCommonConfirmBox(
      context,
      "화물 정보 설정값을 초기화 하시겠습니까?",
      Strings.of(context)?.get("cancel")??"Not Found",
      Strings.of(context)?.get("confirm")??"Not Found",
          () {Navigator.of(context).pop(false);},
          () async {
        Navigator.of(context).pop(false);
        await reset();
      }
    );
  }

  Future<void> goToCustomer() async {
    Map<String,dynamic> results = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OrderCustomerPage()));

    if(results != null && results.containsKey("code")) {
      if (results["code"] == 200) {
        if(results["cust"] != null) {
          await setActivityResult(results);
        }
      }
    }
  }

  Future<void> setActivityResult(Map<String,dynamic> results)async {
    if(results["cust"] != null) {
      await setCustomer(results["cust"]);
      if(ChargeCheck.value == "") {
        await getUnitChargeCnt();
      }else if(ChargeCheck.value == "Y") {
        await getUnitChargeData();
      }else{
        await getUnitChargeCnt();
      }
    }
  }

  Future<void> goToCustUser() async {
    if (mData.value.buyCustId != null) {
      Map<String, dynamic> results = await Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => OrderCustUserPage(
                  custId: mData.value.buyCustId,
                  deptId: mData.value.buyDeptId)));

      if (results != null && results.containsKey("code")) {
        if (results["code"] == 200) {
          await setCustUser(results["custUser"]);
        }
      }
    }
  }

  Future<void> setCustomer(CustomerModel data) async {
    setState(() {
      print("흐에에엥2222 => ${data.custId} // ${data.custId} // ${data.custName} // ${data.deptId} // ${data.deptName}");
      mData.value.buyCustId = data.custId;
      mData.value.buyCustName = data.custName;
      mData.value.buyDeptId = data.deptId;
      mData.value.buyDeptName = data.deptName;
    });

    await getCustUser();
  }

  Future<void> setCustUser(CustUserModel data) async {
    setState(() {
      mData.value.buyStaff = data.userId;
      mData.value.buyStaffName = data.userName;
    });
  }

  Future<void> getCustUser() async {
    await pr?.show();
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).getCustUser(
        user.authorization, mData.value.buyCustId, mData.value.buyDeptId
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("OrderTransInfoPage getCustUser() _response -> ${_response.status} // ${_response.resultMap}");
      await pr?.hide();
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if (_response.resultMap?["data"] != null) {
            try {
              var list = _response.resultMap?["data"] as List;
              List<CustUserModel> itemsList = list.map((i) => CustUserModel.fromJSON(i)).toList();
              if(itemsList.length == 1) {
                await setCustUser(itemsList[0]);
              }
            } catch (e) {
              print(e);
            }
          }
        }else{
          openOkBox(context,"${_response.resultMap?["msg"]}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
        }
      }
    }).catchError((Object obj) async {
      await pr?.hide();
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("OrderTransInfoPage getCustUser() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("OrderTransInfoPage getCustUser() getOrder Default => ");
          break;
      }
    });
  }

  Future<void> reset() async {
    await pr?.show();
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).setOptionTrans(
        user.authorization,
        "Y",
        null,
        null,
        null,
        null,
        null,
        null
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("OrderTransInfoPage reset() _response -> ${_response.status} // ${_response.resultMap}");
      await pr?.hide();
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          Navigator.of(context).pop({'code':200,Const.RESULT_WORK:Const.RESULT_SETTING_TRANS});
        }else{
          openOkBox(context,"${_response.resultMap?["msg"]}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
        }
      }
    }).catchError((Object obj) async {
      await pr?.hide();
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("OrderTransInfoPage reset() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("OrderTransInfoPage reset() getOrder Default => ");
          break;
      }
    });
  }

  Future<void> confirm() async {
      if(validation()) {
        Navigator.of(context).pop({'code':200,Const.RESULT_WORK:Const.RESULT_WORK_TRANS,Const.ORDER_VO: mData.value});
      }
  }

  bool validation() {
    if(mData.value.buyCustName.toString().trim().isEmpty == true) {
      Util.toast("운송사를 지정해 주세요.");
      return false;
    }
    return true;
  }

  Widget mainBodyWidget() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(5.h)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: line,
                          width: 1.w
                      )
                  )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding:EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h)),
                      child: Text(
                        Strings.of(context)?.get("order_trans_info_sub_title_01")??"배차_",
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      )
                  ),
                ],
              )),
          // 운송사(필수)
          Container(
            padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(5.h)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      Strings.of(context)?.get("order_trans_info_cust")??"운송사_",
                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w)),
                        child: Text(
                          Strings.of(context)?.get("essential")??"(필수)_",
                          style: CustomStyle.CustomFont(styleFontSize12, text_color_03),
                        )
                    )
                  ],
                ),
                InkWell(
                    onTap: () async {
                      await goToCustomer();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(10.w)),
                        margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h),right: CustomStyle.getWidth(5.w)),
                        height: CustomStyle.getHeight(35.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: text_box_color_02, width: 1.w),
                            borderRadius: BorderRadius.all(Radius.circular(5.w))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mData.value.buyCustName?.isEmpty == true || mData.value.buyCustName == null ?
                              Strings.of(context)?.get("order_trans_info_cust_hint")??"운송사를 지정해 주세요._" : mData.value.buyCustName!,
                              style: CustomStyle.CustomFont(styleFontSize14, mData.value.buyCustName?.isEmpty == true || mData.value.buyCustName == null ? styleDefaultGrey : text_color_01),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w)),
                              child: Icon(
                                Icons.search,
                                size: 24.h,
                                color: text_color_03,
                              ),
                            )
                          ],
                        )
                    )
                )
              ],
            ),
          ),
          // 담당부서(필수)
          Container(
            padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(5.h)),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            Strings.of(context)?.get("order_trans_info_dept")??"담당부서_",
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w)),
                              child: Text(
                                Strings.of(context)?.get("essential")??"(필수)_",
                                style: CustomStyle.CustomFont(styleFontSize12, text_color_03),
                              )
                          )
                        ],
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(10.w)),
                          margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h),right: CustomStyle.getWidth(5.w)),
                          height: CustomStyle.getHeight(35.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: text_box_color_02, width: 1.w),
                              borderRadius: BorderRadius.all(Radius.circular(5.w))
                          ),
                          child: Text(
                            mData.value.buyDeptName??"",
                            style: CustomStyle.CustomFont(styleFontSize12, text_color_01),
                          )
                      )
                    ],
                  ),
          ),
          // 담당자
          Container(
            padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(5.h)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.of(context)?.get("order_trans_info_staff")??"담당자_",
                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                ),
                InkWell(
                    onTap: () async {
                      await goToCustUser();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                        margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h),right: CustomStyle.getWidth(5.w)),
                        height: CustomStyle.getHeight(35.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: text_box_color_02, width: 1.w),
                            borderRadius: BorderRadius.all(Radius.circular(5.w))
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mData.value.buyStaffName?.isEmpty == true || mData.value.buyStaffName == null ? Strings.of(context)?.get("order_trans_info_staff_hint")??"담당자 지정_" : mData.value.buyStaffName!,
                              style: CustomStyle.CustomFont(styleFontSize12, mData.value.buyStaffName?.isEmpty == true || mData.value.buyStaffName == null ? styleDefaultGrey : text_color_01),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w)),
                              child: Icon(
                                Icons.search,
                                size: 24.h,
                                color: text_color_03,
                              ),
                            )
                          ],
                        )
                    )
                )
              ],
            ),
          ),
          // 지불운임
          Container(
            padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(5.h)),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.of(context)?.get("order_trans_info_charge")??"지불운임_",
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h),right: CustomStyle.getWidth(5.w)),
                          height: CustomStyle.getHeight(34.h),
                          child: TextField(
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.number,
                            controller: etBuyChargeController,
                            maxLines: 1,
                            decoration: etBuyChargeController.text.isNotEmpty
                                ? InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(10.h)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                                  borderRadius: BorderRadius.circular(5.h)
                              ),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                                  borderRadius: BorderRadius.circular(5.h)
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  etBuyChargeController.clear();
                                  mData.value.buyCharge = "0";
                                },
                                icon: Icon(
                                  Icons.clear,
                                  size: 18.h,
                                  color: Colors.black,
                                ),
                              ),
                              suffix: Text(
                                "원",
                                textAlign: TextAlign.center,
                                style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                              ),
                            )
                                : InputDecoration(
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(10.h)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                                  borderRadius: BorderRadius.circular(5.h)
                              ),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w))
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                                  borderRadius: BorderRadius.circular(5.h)
                              ),
                            ),
                            onChanged: (value) async {
                              if(value.length > 0) {
                                mData.value.buyCharge = int.parse(value.trim()).toString();
                                etBuyChargeController.text = int.parse(value.trim()).toString();
                              }else{
                                etBuyChargeController.text = "0";
                                mData.value.buyCharge = "0";
                              }
                            },
                            maxLength: 50,
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget etcPannelWidget() {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(10.w)),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("기타",
                    style:
                    CustomStyle.CustomFont(styleFontSize16, text_color_01))
              ],
            )),
        CustomStyle.getDivider1(),
        Container(
            padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(10.w)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(
                        color: line, width: 1.w
                    )
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 차주 확인 사항
                Text(
                  Strings.of(context)?.get("order_trans_info_driver_memo")??"차주확인사항_",
                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h)),
                    child: TextField(
                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      controller: etOtherAddMemoController,
                      maxLines: null,
                      decoration: etOtherAddMemoController.text.isNotEmpty
                          ? InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(10.h)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            etOtherAddMemoController.clear();
                            mData.value.driverMemo = "";
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 18.h,
                            color: Colors.black,
                          ),
                        ),
                      )
                          : InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(10.h)),
                        hintText: Strings.of(context)?.get("order_trans_info_driver_memo_hint")??"차주님에게 전달할 내용을 입력해 주세요._",
                        hintStyle: CustomStyle.greyDefFont(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                      ),
                      onChanged: (value){
                        etOtherAddMemoController.text = value;
                        mData.value.driverMemo = value;
                      },
                    )
                ),
                //요청사항
                Text(
                  Strings.of(context)?.get("order_trans_info_reg_memo")??"요청사항_",
                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                ),
                Container(
                    margin: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h)),
                    child: TextField(
                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      controller: etRegMemoController,
                      maxLines: null,
                      decoration: etRegMemoController.text.isNotEmpty
                          ? InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(10.h)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            etRegMemoController.clear();
                            mData.value.reqMemo = "";
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 18.h,
                            color: Colors.black,
                          ),
                        ),
                      )
                          : InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(10.h)),
                        hintText: Strings.of(context)?.get("order_trans_info_reg_memo_hint")??"요청사항을 입력해 주세요._",
                        hintStyle: CustomStyle.greyDefFont(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w))
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: text_box_color_02, width: CustomStyle.getWidth(1.0.w)),
                            borderRadius: BorderRadius.circular(5.h)
                        ),
                      ),
                      onChanged: (value){
                        etRegMemoController.text = value;
                        mData.value.reqMemo = value;
                      },
                    )
                )
              ],
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = Util.networkProgress(context);
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop({'code':100});
          return true;
        } ,
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          backgroundColor: sub_color,
          appBar: AppBar(
                title: Text(
                    Strings.of(context)?.get("order_trans_info_title")??"Not Found",
                    style: CustomStyle.appBarTitleFont(
                        styleFontSize16, styleWhiteCol)
                ),
                toolbarHeight: 50.h,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () async {
                    Navigator.of(context).pop({'code':100});
                  },
                  color: styleWhiteCol,
                  icon: Icon(Icons.arrow_back,size: 24.h, color: Colors.white),
                ),
              ),
          body: SafeArea(
              child: Obx((){
                  return SingleChildScrollView(
                    child: Column(
                    children: [
                      mainBodyWidget(),
                      Container(height: CustomStyle.getHeight(3.h)),
                      etcPannelWidget()
                      ],
                    ));
              })
          ),
            bottomNavigationBar: Obx((){
              return SizedBox(
                height: CustomStyle.getHeight(60.0.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //확인 버튼
                    !(isOption.value == true)? Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () async {
                              await confirm();
                            },
                            child: Container(
                                height: CustomStyle.getHeight(60.0.h),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: main_color),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check,
                                          size: 20.h, color: styleWhiteCol),
                                      CustomStyle.sizedBoxWidth(5.0.w),
                                      Text(
                                        textAlign: TextAlign.center,
                                        Strings.of(context)?.get("confirm") ??
                                            "Not Found",
                                        style: CustomStyle.CustomFont(
                                            styleFontSize16, styleWhiteCol),
                                      ),
                                    ]
                                )
                            )
                        )
                    ):const SizedBox(),
                    //초기화 버튼
                    (isOption.value == true)? Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () {
                              showResetDialog();
                            },
                            child: Container(
                                height: CustomStyle.getHeight(60.0.h),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: sub_btn),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.refresh, size: 20.h, color: styleWhiteCol),
                                      CustomStyle.sizedBoxWidth(5.0.w),
                                      Text(
                                        textAlign: TextAlign.center,
                                        Strings.of(context)?.get("reset") ??
                                            "Not Found",
                                        style: CustomStyle.CustomFont(
                                            styleFontSize16, styleWhiteCol),
                                      ),
                                    ]
                                )
                            )
                        )
                    ):const SizedBox(),
                    // 저장 버튼
                    (isOption.value == true)? Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () async {
                              await save();
                            },
                            child: Container(
                                height: CustomStyle.getHeight(60.0.h),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(color: main_btn),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save_alt, size: 20.h, color: styleWhiteCol),
                                      CustomStyle.sizedBoxWidth(5.0.w),
                                      Text(
                                        textAlign: TextAlign.center,
                                        Strings.of(context)?.get("save") ??
                                            "Not Found",
                                        style: CustomStyle.CustomFont(
                                            styleFontSize16, styleWhiteCol),
                                      ),
                                    ]
                                )
                            )
                        )
                    ):const SizedBox(),
                  ],
                ));
          })
        )
    );
  }




}