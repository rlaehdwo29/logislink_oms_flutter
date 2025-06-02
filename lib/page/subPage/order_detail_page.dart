import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fbroadcast/fbroadcast.dart' as BroadCast;
import 'package:flutter/material.dart';
import 'package:flutter_direct_caller_plugin/flutter_direct_caller_plugin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:logislink_oms_flutter/common/app.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';
import 'package:logislink_oms_flutter/common/model/order_model.dart';
import 'package:logislink_oms_flutter/common/model/stop_point_model.dart';
import 'package:logislink_oms_flutter/common/model/user_model.dart';
import 'package:logislink_oms_flutter/common/strings.dart';
import 'package:logislink_oms_flutter/common/style_theme.dart';
import 'package:logislink_oms_flutter/constants/const.dart';
import 'package:logislink_oms_flutter/page/location_control_page.dart';
import 'package:logislink_oms_flutter/page/subPage/reg_order/receipt_page.dart';
import 'package:logislink_oms_flutter/page/subPage/reg_order/regist_order_page.dart';
import 'package:logislink_oms_flutter/page/subPage/reg_order/stop_point_page.dart';
import 'package:logislink_oms_flutter/provider/dio_service.dart';
import 'package:logislink_oms_flutter/utils/util.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';

class OrderDetailPage extends StatefulWidget {

  OrderModel? order_vo;
  String? orderId;
  String? code;
  int? position;
  String? allocId;

  OrderDetailPage({Key? key,this.order_vo, this.orderId, this.code, this.position, this.allocId}):super(key:key);

  _OrderDetailPageState createState() => _OrderDetailPageState();
}


class _OrderDetailPageState extends State<OrderDetailPage> {

  ProgressDialog? pr;

  final mData = OrderModel().obs;

  final controller = Get.find<App>();

  final mStopList = List.empty(growable: true).obs;
  final orderId = "".obs;

  final tvOrderCancel = false.obs;
  final tvReOrder = false.obs;
  final tvAlloc = false.obs;
  final tvAllocCancel = false.obs;
  final tvAllocReg = false.obs;

  final tvOrderState = false.obs;
  final tvAllocState = false.obs;
  final llDriverInfo = false.obs;

  final llStopPointHeader = false.obs;
  final llStopPointList = false.obs;
  final llBottom = false.obs;
  final mRpaUseYn = "".obs;
  final mLinkState = false.obs;
  final tvSendLink = false.obs;
  final tvReceipt = false.obs;

  final isStopPointExpanded = [].obs;
  final isCargoExpanded = [].obs;
  final isEtcExpanded = [].obs;

  late TextEditingController etCarNumController;
  late TextEditingController etDriverNameController;
  late TextEditingController etTelController;
  late TextEditingController etCarTypeController;
  late TextEditingController etCarTonController;

  @override
  void initState() {
    super.initState();

    BroadCast.FBroadcast.instance().register(Const.INTENT_ORDER_DETAIL_REFRESH, (value, callback) async {

    },context: this);

    etCarNumController = TextEditingController();
    etDriverNameController = TextEditingController();
    etTelController = TextEditingController();
    etCarTypeController = TextEditingController();
    etCarTonController = TextEditingController();

    Future.delayed(Duration.zero, () async {
      if(widget.order_vo != null) {
        mData.value = widget.order_vo!;
      }else{
        mData.value = OrderModel();
      }

      if(mData.value.orderId != null) {
        await getStopPointFore();
      }else{
        if(widget.orderId != null) {
          orderId.value = widget.orderId!;
          await getOrderDetail(orderId.value);
        }else{
          Navigator.of(context).pop();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
      // 앱이 표시되고 사용자 입력에 응답합니다.
      // 주의! 최초 앱 실행때는 해당 이벤트가 발생하지 않습니다.
        BroadCast.FBroadcast.instance().broadcast(Const.INTENT_ORDER_DETAIL_REFRESH);
        print("resumed");
        break;
      case AppLifecycleState.inactive:
      // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
      // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
      // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
      // inactive가 발생되고 얼마후 pasued가 발생합니다.
        print("inactive");
        break;
      case AppLifecycleState.paused:
      // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
      // 안드로이드의 onPause()와 동일합니다.
      // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.
        print("paused");
        break;
      case AppLifecycleState.detached:
      // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
      // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
      // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
        print("detached");
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }

  @override
  void dispose() {
    super.dispose();
    etCarNumController.dispose();
    etDriverNameController.dispose();
    etTelController.dispose();
    etCarTypeController.dispose();
    etCarTonController.dispose();
  }

  Future<void> goToLocationControl() async {
    await Util.setDriverLocationLog(mData.value.orderId);
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LocationControlPage(order_vo:mData.value)));
  }

  bool equalsCharge(String? text) {
    if(text != null) {
      return !(text == "0");
    }else{
      return false;
    }
  }

  Future<void> copyOrder() async {
    Map<String,dynamic> results = await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RegistOrderPage(order_vo:mData.value)));

    if(results != null && results.containsKey("code")) {
      if (results["code"] == 200) {
        Navigator.of(context).pop({'code':200});
      }
    }

  }

  Future<void> getOrderDetail(String? allocId) async {
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).getOrderDetail(
      user.authorization,
      allocId,
    ).then((it) async {
      try {
        ReturnMap _response = DioService.dioResponse(it);
        logger.d("getOrderDetail() _response -> ${_response.status} // ${_response.resultMap}");
        if (_response.status == "200") {
          if (_response.resultMap?["result"] == true) {
            if (_response.resultMap?["data"] != null) {
              try {
                var list = _response.resultMap?["data"] as List;
                List<OrderModel> itemsList = list.map((i) => OrderModel.fromJSON(i)).toList();
                if(itemsList.length > 0){
                  mData.value = itemsList[0];
                }else{
                  openOkBox(context,"삭제되었거나 완료된 오더입니다.", Strings.of(context)?.get("confirm")??"Not Found", () { Navigator.of(context).pop(false);});
                }
              } catch (e) {
                print(e);
              }
            }else{
              openOkBox(context, "${_response.resultMap?["msg"]}",
                  Strings.of(context)?.get("confirm") ?? "Error!!", () {
                    Navigator.of(context).pop(false);
                  });
            }
          } else {
            openOkBox(context, "${_response.resultMap?["msg"]}",
                Strings.of(context)?.get("confirm") ?? "Error!!", () {
                  Navigator.of(context).pop(false);
                });
          }
        }
      }catch(e) {
        print("getOrderDetail() Exception =>$e");
      }
    }).catchError((Object obj){
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getOrderDetail() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getOrderDetail() getOrder Default => ");
          break;
      }
    });
  }

  Future<void> showNoDetail() async {
    await openOkBox(context,"삭제되었거나 완료된 오더입니다.", Strings.of(context)?.get("confirm")??"Not Found", () { Navigator.of(context).pop(false);});
  }

  Future<void> goToStopPoint() async {
    if(mStopList.value.length == 0) {
      await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StopPointPage(code:"detail",result_work_stopPoint:jsonEncode(mStopList.value))));
    }else{
      await getStopPoint();
    }
  }

  Future<void> getStopPoint() async {
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).getStopPoint(
        user.authorization,
        mData.value.orderId
    ).then((it) async {
      try {
        ReturnMap _response = DioService.dioResponse(it);
        logger.d("getStopPoint() _response -> ${_response.status} // ${_response.resultMap}");
        if (_response.status == "200") {
          if (_response.resultMap?["result"] == true) {
            if(_response.resultMap?["data"] != null) {
              var list = _response.resultMap?["data"] as List;
              List<StopPointModel> itemsList = list.map((i) => StopPointModel.fromJSON(i)).toList();
              if (mStopList.isNotEmpty) mStopList.clear();
              mStopList?.addAll(itemsList);
              await goToStopPoint();
            }
          } else {
            openOkBox(context, "${_response.resultMap?["msg"]}",
                Strings.of(context)?.get("confirm") ?? "Error!!", () {
                  Navigator.of(context).pop(false);
                });
          }
        }
      }catch(e) {
        print("getStopPoint() Exception =>$e");
      }
    }).catchError((Object obj){
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getStopPoint() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getStopPoint() getOrder Default => ");
          break;
      }
    });
  }

  Future<void> getStopPointFore() async {
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).getStopPoint(
        user.authorization,
        mData.value.orderId
    ).then((it) async {
      try {
        ReturnMap _response = DioService.dioResponse(it);
        logger.d("getStopPointFore() _response -> ${_response.status} // ${_response.resultMap}");
        if (_response.status == "200") {
          if (_response.resultMap?["result"] == true) {
            if(_response.resultMap?["data"] != null) {
              var list = _response.resultMap?["data"] as List;
              List<StopPointModel> itemsList = list.map((i) => StopPointModel.fromJSON(i)).toList();
              if (mStopList.isNotEmpty) mStopList.clear();
              mStopList?.addAll(itemsList);
              await initView();
            }
          } else {
            openOkBox(context, "${_response.resultMap?["msg"]}",
                Strings.of(context)?.get("confirm") ?? "Error!!", () {
                  Navigator.of(context).pop(false);
                });
          }
        }
      }catch(e) {
        print("getStopPointFore() Exception =>$e");
      }
    }).catchError((Object obj){
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getStopPointFore() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getStopPointFore() getOrder Default => ");
          break;
      }
    });
  }

  Future<void> setOrderState() async {
    if(mData.value.orderState == "09") {
      tvOrderState.value = true;
      tvAllocState.value = false;
      llDriverInfo.value = false;
    }else{
      if(mData.value.driverState != null) {
        tvOrderState.value = false;
        tvAllocState.value = false;
        llDriverInfo.value = true;
      }else{
        tvOrderState.value = false;
        tvAllocState.value = true;
        llDriverInfo.value = false;
      }
    }
  }

  Future<void> setAllocState() async {
    llBottom.value = true;
    await setVisibilitySendLink(false);
    switch(mData.value.allocState) {
      case "00" :
        // 접수
        if(mData.value.orderState == "09") {
          tvReOrder.value = true;
          await setVisibilitySendLink(false);
          tvOrderCancel.value = false;
          tvAlloc.value = false;
        }else{
          tvReOrder.value = false;
          await setVisibilitySendLink(true);
          tvOrderCancel.value = true;
          tvAlloc.value = true;
        }
        tvAllocCancel.value = false;
        tvAllocReg.value = false;
        break;
      case "01" :
      case "20" :
        /*if(mData.value.buyLinkYn == "Y") {
          await setVisibilitySendLink(true);
        }*/
        // 배차, 취소요청
        tvReOrder.value = false;
        tvOrderCancel.value = false;

        tvAlloc.value = false;
        tvAllocCancel.value = true;
        tvAllocReg.value = false;
        break;

      case "04":
      case "05":
      case "12":
      case "21":
        //출발, 도착, 입차, 취소
        llBottom.value = false;
        break;
      case "10":
        //운송사지정
        tvReOrder.value = false;
        tvOrderCancel.value = false;

        if(mData.value.orderState == "00") {
          tvAlloc.value = false;
          tvAllocCancel.value = true;
          tvAllocReg.value = true;
        }else if(mData.value.orderState == "01") {
          tvAlloc.value = false;
          tvAllocCancel.value = true;
          tvAllocReg.value = false;
        }else{
          llBottom.value = false;
        }
        break;
      case "11":
      case "13":
      case "23":
      case "24":
      case "25":
        await setVisibilitySendLink(true);

        // 정보망접수, 정보망접수 완료, 배차실패(화물맨), 배차대기(화물맨), 정보망오류
      if(mData.value.orderState == "00" || mData.value.orderState =="01"){
        tvReOrder.value = false;
        tvOrderCancel.value  = false;
        tvAlloc.value = true;

        tvAllocCancel.value = false;
        tvOrderCancel.value = true;
        tvAllocReg.value = false;
      }else{
        llBottom.value = false;
      }
      break;
    }
  }

  Future<void> setVisibilitySendLink(bool val) async {
    if(mRpaUseYn.value == "Y") {
      if(mLinkState.value) {
        // 정보망 전송 버튼 활성화, 비활성화
        // 수정 메뉴 정하기 전까지 일단 활성화 하지 말 것
        tvSendLink.value = val? true : false;
      }else{
        tvSendLink.value = false;
      }
    }else{
      tvSendLink.value = false;
    }
  }

  Future<void> goToReceipt() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ReceiptPage(order_vo: mData.value)));
  }

  Future<void> initView() async {
    await setOrderState();
    await setAllocState();
    setState(() {
      if(mData.value.stopCount != 0) {
        llStopPointHeader.value = true;
        llStopPointList.value = true;
      }else{
        llStopPointHeader.value = false;
        llStopPointList.value = false;
      }

      if(!(mData.value.receiptYn == "N")) {
        tvReceipt.value = true;
      }else{
        tvReceipt.value = false;
      }
    });
  }

  Widget topWidget() {
    return Column(
      children: [
        // 운송사 접수
        Container(
          padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w), right: CustomStyle.getWidth(5.w), top: CustomStyle.getHeight(8.h),bottom: CustomStyle.getHeight(8.h)),
          child: Row(
            children: [
             Container(
                    padding: EdgeInsets.only(right: CustomStyle.getWidth(3.w)),
                    child: Text(
                      mData.value.orderStateName??"운송사접수",
                      style: CustomStyle.CustomFont(styleFontSize15, order_state_01,font_weight: FontWeight.w700),
                    ),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(right: CustomStyle.getWidth(3.w)),
                    child: Text(
                      mData.value.buyCustName??"",
                      style: CustomStyle.CustomFont(styleFontSize13, text_color_01),
                    ),
                  )
              ),
                    Expanded(
                    flex: 2,
                      child: Container(
                      padding: EdgeInsets.only(right: CustomStyle.getWidth(3.w)),
                      child: Text(
                        mData.value.buyDeptName??"",
                        style: CustomStyle.CustomFont(styleFontSize13, text_color_01),
                      ),
                   )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    "${Util.getInCodeCommaWon(mData.value.buyCharge??"0")}원",
                    textAlign: TextAlign.right,
                    style: CustomStyle.CustomFont(styleFontSize15, text_color_01,font_weight: FontWeight.w700),
                  )
              ),
            ],
          ),
        ),
        Container(
          height: CustomStyle.getHeight(5.h),
          color: line,
        )
      ],
    );
  }

  Widget driverInfoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.of(context)?.get("order_detail_sub_title_05")?? "차주_정보",
                style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
              ),
              tvReceipt.value?
              InkWell(
                  onTap: () async {
                    await goToReceipt();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h),horizontal: CustomStyle.getWidth(10.w)),
                    decoration: BoxDecoration(
                        border: Border.all(color: order_state_01,width: 1.w),
                        borderRadius: BorderRadius.all(Radius.circular(5.w))
                    ),
                    child: Text(
                      "인수증 확인",
                      style: CustomStyle.CustomFont(styleFontSize12, order_state_01),
                    ),
                  )
              ):const SizedBox()
            ],
          ),
        ),
        CustomStyle.getDivider1(),
        Container(
          padding: EdgeInsets.all(5.w),
          child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(bottom: CustomStyle.getHeight(5.h)),
                          child: Row(
                            children: [
                              Text(
                                mData.value.driverName == null ?"" : "${mData.value.driverName} 차주님",
                                style: CustomStyle.CustomFont(styleFontSize16, text_color_01),
                              ),
                              InkWell(
                                  onTap: () async {
                                    if(Platform.isAndroid) {
                                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                      AndroidDeviceInfo info = await deviceInfo.androidInfo;
                                      if (info.version.sdkInt >= 23) {
                                        await FlutterDirectCallerPlugin.callNumber("${mData.value.driverTel}");
                                      }else{
                                        await launch("tel://${mData.value.driverTel}");
                                      }
                                    }else{
                                      await launch("tel://${mData.value.driverTel}");
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(3.w)),
                                    child: Text(
                                      Util.makePhoneNumber(mData.value.driverTel),
                                      style: CustomStyle.CustomFont(styleFontSize14, addr_type_text),
                                    ),
                                  )
                              )
                            ],
                          )
                      ),
                      Text(
                        mData.value.carNum??"",
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      ),
                    ],
                  )
                ),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap:(){
                      goToLocationControl();
                      //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LocationControlPage(order_vo: mData.value)));
                    } ,
                    child: Icon(Icons.location_on,size: 35.h,color: swipe_edit_btn)
                  ),
                )
              ],
            )
        ),
        Container(
          height: CustomStyle.getHeight(5.h),
          color: line,
        )
      ],
    );
  }

  Widget enterDateWidget() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: line,
                  width: CustomStyle.getHeight(5.h)
                )
              )
            ),
            child:Column(
              children: [
                Row(
                  children: [
                    Text(
                      Strings.of(context)?.get("order_reg_enter")??"입차_",
                      style: CustomStyle.CustomFont(styleFontSize13, text_color_01),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: CustomStyle.getWidth(3.w)),
                      child:Text(
                        mData.value.enterDate??"",
                        style: CustomStyle.CustomFont(styleFontSize13, text_color_01)
                      )
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h)),
                  child: Row(
                    children: [
                      Text(
                        Strings.of(context)?.get("order_reg_start")??"출발_",
                        style: CustomStyle.CustomFont(styleFontSize13, text_color_01),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: CustomStyle.getWidth(3.w)),
                          child:Text(
                              mData.value.startDate??"",
                              style: CustomStyle.CustomFont(styleFontSize13, text_color_01)
                          )
                      )
                    ],
                  )
                ),
                Container(
                    padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h)),
                    child: Row(
                      children: [
                        Text(
                          Strings.of(context)?.get("order_reg_end")??"도착_",
                          style: CustomStyle.CustomFont(styleFontSize13, text_color_01),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: CustomStyle.getWidth(3.w)),
                            child:Text(
                                mData.value.finishDate??"",
                                style: CustomStyle.CustomFont(styleFontSize13, text_color_01)
                            )
                        )
                      ],
                    )
                )
              ],
            )
            )
        ]
    );
  }

  Widget transInfoWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h), horizontal: CustomStyle.getWidth(5.w)),
              alignment: Alignment.centerLeft,
              child: Text(
                Strings.of(context)?.get("order_detail_sub_title_01")??"배차 정보_",
                style: CustomStyle.CustomFont(styleFontSize16, text_color_01),
              ),
            ),
            CustomStyle.getDivider1(),
            Container(
                padding: EdgeInsets.all(5.w),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                          height: CustomStyle.getHeight(180.h),
                          margin: EdgeInsets.only(top: CustomStyle.getHeight(5.0.h)),
                          padding: EdgeInsets.all(5.0.h),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: sub_color
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "${Util.splitSDate(mData.value.sDate)} 상차",
                                  style: CustomStyle.CustomFont(styleFontSize13, text_box_color_01),
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      mData.value.sComName??"",
                                      style: CustomStyle.CustomFont(
                                          styleFontSize14, text_color_01,
                                          font_weight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w),right: CustomStyle.getWidth(5.w), bottom: CustomStyle.getHeight(5.h)),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      mData.value.sStaff??"",
                                      style: CustomStyle.CustomFont(
                                          styleFontSize13, text_color_02,
                                          font_weight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w),right: CustomStyle.getWidth(5.w), bottom: CustomStyle.getHeight(5.h)),
                                    alignment: Alignment.centerLeft,
                                    child: !(mData.value.sStaff?.isEmpty == true) || !(mData.value.sTel?.isEmpty == true)?
                                    InkWell(
                                        onTap: () async {
                                          if(Platform.isAndroid) {
                                            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                            AndroidDeviceInfo info = await deviceInfo.androidInfo;
                                            if (info.version.sdkInt >= 23) {
                                              await FlutterDirectCallerPlugin.callNumber("${mData.value.sTel}");
                                            }else{
                                              await launch("tel://${mData.value.sTel}");
                                            }
                                          }else{
                                            await launch("tel://${mData.value.sTel}");
                                          }
                                        },
                                        child: Text(
                                            Util.makePhoneNumber(mData.value.sTel),
                                            style: CustomStyle.CustomFont(styleFontSize12, addr_type_text)
                                        )) : const SizedBox()),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(3.w)),
                                    child: Text(
                                      mData.value.sAddr??"",
                                      style: CustomStyle.CustomFont(
                                          styleFontSize13, text_color_02,
                                          font_weight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    )
                                ),
                                !(mData.value.sAddrDetail?.isEmpty == true) ?
                                Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                                    child: Text(
                                      mData.value.sAddrDetail??"",
                                      style: CustomStyle.CustomFont(
                                          styleFontSize13, text_color_02,
                                          font_weight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    )
                                ) : const SizedBox(),
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: !(mData.value.sMemo?.isEmpty == true) ? mData.value.sMemo??"-" : "-",
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  )
                              )
                          )
                        ])),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_right_alt,size: 21.h,color: const Color(0xff6d7780)),
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                            height: CustomStyle.getHeight(180.h),
                            margin: EdgeInsets.only(top: CustomStyle.getHeight(5.0.h)),
                            padding: EdgeInsets.all(5.0.h),
                            decoration: const BoxDecoration(
                                borderRadius:  BorderRadius.all(Radius.circular(10)),
                                color: sub_color
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${Util.splitEDate(mData.value.eDate)} 하차",
                                    textAlign: TextAlign.center,
                                    style: CustomStyle.CustomFont(styleFontSize13, text_box_color_01),
                                  ),
                                  Container(
                                      padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        mData.value.eComName??"",
                                        style: CustomStyle.CustomFont(
                                            styleFontSize14, text_color_01,
                                            font_weight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      )
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w),right: CustomStyle.getWidth(5.w), bottom: CustomStyle.getHeight(5.h)),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        mData.value.eStaff??"",
                                        style: CustomStyle.CustomFont(
                                            styleFontSize13, text_color_02,
                                            font_weight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      )
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: CustomStyle.getWidth(5.w),right: CustomStyle.getWidth(5.w), bottom: CustomStyle.getHeight(5.h)),
                                      alignment: Alignment.centerLeft,
                                      child: !(mData.value.eStaff?.isEmpty == true) || !(mData.value.eTel?.isEmpty == true)?
                                      InkWell(
                                          onTap: () async {
                                            if(Platform.isAndroid) {
                                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                              AndroidDeviceInfo info = await deviceInfo.androidInfo;
                                              if (info.version.sdkInt >= 23) {
                                                await FlutterDirectCallerPlugin.callNumber("${mData.value.eTel}");
                                              }else{
                                                await launch("tel://${mData.value.eTel}");
                                              }
                                            }else{
                                              await launch("tel://${mData.value.eTel}");
                                            }
                                          },
                                          child: Text(
                                              Util.makePhoneNumber(mData.value.eTel),
                                              style: CustomStyle.CustomFont(styleFontSize12, addr_type_text)
                                          )) : const SizedBox()),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                                      child: Text(
                                        mData.value.eAddr??"",
                                        style: CustomStyle.CustomFont(
                                            styleFontSize13, text_color_02,
                                            font_weight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      )
                                  ),
                                  !(mData.value.eAddrDetail?.isEmpty == true) ?
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                                      child: Text(
                                        mData.value.eAddrDetail??"",
                                        style: CustomStyle.CustomFont(
                                            styleFontSize13, text_color_02,
                                            font_weight: FontWeight.w600),
                                        textAlign: TextAlign.left,
                                      )
                                  ) : const SizedBox(),
                                Flexible(
                                    child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                                        alignment: Alignment.centerLeft,
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            text: !(mData.value.eMemo?.isEmpty == true) ? mData.value.eMemo ?? "-" : "-",
                                            style: CustomStyle.CustomFont(styleFontSize13, text_color_01),
                                          ),
                                        )
                                    )
                                )
                                ]
                            )
                        )
                    )
                  ],
                )
            ),
            Container(
                padding: EdgeInsets.all(10.w),
                color: Colors.white,
                child: Row(
                  children: [
                    Icon(Icons.more_vert, size: 24.h, color: text_color_02),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                      child: Text(
                        Util.makeDistance(mData.value.distance),
                        style: CustomStyle.CustomFont(styleFontSize12, text_color_02),
                      ),
                    ),
                    Text(
                      Util.makeTime(mData.value.time??0),
                      style: CustomStyle.CustomFont(styleFontSize12, text_color_02),
                    )
                  ],
                )
            ),
            Container(
              height: CustomStyle.getHeight(5.h),
              color: line,
            )
          ],
        )
    );
  }

  /*Widget transInfoWidget() {
    return Container(
      alignment: Alignment.centerLeft,
        child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h), horizontal: CustomStyle.getWidth(5.w)),
            alignment: Alignment.centerLeft,
            child: Text(
              Strings.of(context)?.get("order_detail_sub_title_01")??"배차 정보_",
              style: CustomStyle.CustomFont(styleFontSize16, text_color_01),
            ),
          ),
          CustomStyle.getDivider1(),
          Container(
            padding: EdgeInsets.all(5.w),
            color: Colors.white,
            child: Column(
             children: [
               //상.하차 날짜
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 6,
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h), horizontal: CustomStyle.getWidth(5.w)),
                          decoration: BoxDecoration(
                              color: sub_color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.h),
                                  topRight: Radius.circular(5.h)
                              )
                          ),
                          child: Text(
                              "${Util.splitSDate(mData.value.sDate)} 상차",
                              textAlign: TextAlign.center,
                              style: CustomStyle.CustomFont(styleFontSize13, text_box_color_01)
                          )
                      )
                  ),
                  const Expanded(
                      flex: 1,
                      child: SizedBox()
                  ),
                  Expanded(
                      flex: 6,
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h), horizontal: CustomStyle.getWidth(5.w)),
                          decoration: BoxDecoration(
                              color: sub_color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.h),
                                  topRight: Radius.circular(5.h)
                              )
                          ),
                          child: Text(
                              "${Util.splitEDate(mData.value.eDate)} 하차",
                              textAlign: TextAlign.center,
                              style: CustomStyle.CustomFont(styleFontSize13, text_box_color_01)
                          )
                      )
                  ),
                ],
              ),
               // 상차지명 / 하차지명
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Expanded(
                       flex: 6,
                       child: Container(
                           padding: EdgeInsets.all(5.w),
                           color: sub_color,
                           child: Text(
                               mData.value.sComName??"",
                               textAlign: TextAlign.center,
                               style: CustomStyle.CustomFont(styleFontSize15, text_color_01)
                           )
                       )
                   ),
                   Expanded(
                       flex: 1,
                       child: Icon(Icons.arrow_forward,color: const Color(0xff6d7780),size: 18.w,)
                   ),
                   Expanded(
                       flex: 6,
                       child: Container(
                           padding: EdgeInsets.all(5.w),
                           color: sub_color,
                           child: Text(
                               mData.value.eComName??"",
                               textAlign: TextAlign.center,
                               style: CustomStyle.CustomFont(styleFontSize15, text_color_01)
                           )
                       )
                   ),
                 ],
               ),
               // 상.하차지 담당자 / 담당자 연락처
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Expanded(
                       flex: 6,
                       child: mData.value.sStaff?.isNotEmpty == true && mData.value.sStaff !=null ?
                       Container(
                           padding: const EdgeInsets.all(5.0),
                           color: sub_color,
                           child: Column(
                             children: [
                               Text(
                                   mData.value.sStaff??"",
                                   textAlign: TextAlign.left,
                                   style: CustomStyle.CustomFont(styleFontSize15, text_color_02)
                               ),
                               InkWell(
                                 onTap: () async {
                                   if(Platform.isAndroid) {
                                     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                     AndroidDeviceInfo info = await deviceInfo.androidInfo;
                                     if (info.version.sdkInt >= 23) {
                                       await PhoneCall.calling("${mData.value.sTel}");
                                     }else{
                                       await launch("tel://${mData.value.sTel}");
                                     }
                                   }else{
                                     await launch("tel://${mData.value.sTel}");
                                   }
                                 },
                                 child: Text(
                                     Util.makePhoneNumber(mData.value.sTel),
                                     textAlign: TextAlign.left,
                                     style: CustomStyle.CustomFont(styleFontSize15, addr_type_text)
                                 ),
                               )
                             ],
                           )
                       ) : const SizedBox()
                   ),
                   const Expanded(
                       flex: 1,
                       child: SizedBox()
                   ),
                   Expanded(
                       flex: 6,
                       child: mData.value.eStaff?.isNotEmpty == true && mData.value.eStaff !=null ?
                       Container(
                           padding: const EdgeInsets.all(5.0),
                           color: sub_color,
                           child: Column(
                             children: [
                               Text(
                                   mData.value.eStaff??"",
                                   textAlign: TextAlign.left,
                                   style: CustomStyle.CustomFont(styleFontSize15, text_color_02)
                               ),
                               InkWell(
                                 onTap: () async {
                                   if(Platform.isAndroid) {
                                     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                                     AndroidDeviceInfo info = await deviceInfo.androidInfo;
                                     if (info.version.sdkInt >= 23) {
                                       await PhoneCall.calling("${mData.value.eTel}");
                                     }else{
                                       await launch("tel://${mData.value.eTel}");
                                     }
                                   }else{
                                     await launch("tel://${mData.value.eTel}");
                                   }
                                 },
                                 child: Text(
                                     Util.makePhoneNumber(mData.value.eTel),
                                     textAlign: TextAlign.left,
                                     style: CustomStyle.CustomFont(styleFontSize15, addr_type_text)
                                 ),
                               )
                             ],
                           )
                       ) : const SizedBox()
                   ),
                 ],
               ),
               // 상.하차지 주소
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Expanded(
                       flex: 6,
                       child: Container(
                           padding: EdgeInsets.all(5.w),
                           color: sub_color,
                           child: Text(
                               mData.value.sAddr??"",
                               textAlign: TextAlign.left,
                               style: CustomStyle.CustomFont(styleFontSize13, text_color_01,font_weight: FontWeight.w600)
                           )
                       )
                   ),
                   const Expanded(
                       flex: 1,
                       child: SizedBox()
                   ),
                   Expanded(
                       flex: 6,
                       child: Container(
                           padding: EdgeInsets.all(5.w),
                           color: sub_color,
                           child: Text(
                               mData.value.eAddr??"",
                               textAlign: TextAlign.left,
                               style: CustomStyle.CustomFont(styleFontSize13, text_color_01, font_weight: FontWeight.w600)
                           )
                       )
                   ),
                 ],
               ),
               // 상.하차지 상세주소
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Expanded(
                       flex: 6,
                       child: mData.value.sAddrDetail?.isNotEmpty == true && mData.value.sAddrDetail != null ?
                       Container(
                           padding: EdgeInsets.all(5.w),
                           color: sub_color,
                           child: Text(
                               mData.value.sAddrDetail??"",
                               textAlign: TextAlign.left,
                               style: CustomStyle.CustomFont(styleFontSize13, text_color_01,font_weight: FontWeight.w600)
                           )
                       ) : const SizedBox()
                   ),
                   const Expanded(
                       flex: 1,
                       child: SizedBox()
                   ),
                   Expanded(
                       flex: 6,
                       child: mData.value.eAddrDetail?.isNotEmpty == true && mData.value.eAddrDetail != null ?
                       Container(
                           padding: EdgeInsets.all(5.w),
                           color: sub_color,
                           child: Text(
                               mData.value.eAddrDetail??"",
                               textAlign: TextAlign.left,
                               style: CustomStyle.CustomFont(styleFontSize13, text_color_01, font_weight: FontWeight.w600)
                           )
                       ) : const SizedBox()
                   ),
                 ],
               ),
               // 상.하차지 메모
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Expanded(
                       flex: 6,
                       child: Container(
                           padding: EdgeInsets.all(5.w),
                           decoration: BoxDecoration(
                               color: sub_color,
                               borderRadius: BorderRadius.only(
                                   bottomLeft: Radius.circular(5.h),
                                   bottomRight: Radius.circular(5.h)
                               )
                           ),
                           child: Text(
                               mData.value.sMemo?.isNotEmpty == true && mData.value.sMemo != null ? mData.value.sMemo??"-" : "-",
                               textAlign: TextAlign.left,
                               style: CustomStyle.CustomFont(styleFontSize13, text_color_01,font_weight: FontWeight.w600)
                           )
                       )
                   ),
                   const Expanded(
                       flex: 1,
                       child: SizedBox()
                   ),
                   Expanded(
                       flex: 6,
                       child: Container(
                           padding: EdgeInsets.all(5.w),
                           decoration: BoxDecoration(
                               color: sub_color,
                               borderRadius: BorderRadius.only(
                                   bottomLeft: Radius.circular(5.h),
                                   bottomRight: Radius.circular(5.h)
                               )
                           ),
                           child: Text(
                               mData.value.eMemo?.isNotEmpty == true && mData.value.eMemo != null ? mData.value.eMemo??"-" : "-",
                               textAlign: TextAlign.left,
                               style: CustomStyle.CustomFont(styleFontSize13, text_color_01, font_weight: FontWeight.w600)
                           )
                       )
                   ),
                 ],
               ),
            ])
          ),
          Container(
            padding: EdgeInsets.all(10.w),
              color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.more_vert, size: 24.h, color: text_color_02),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w)),
                  child: Text(
                    Util.makeDistance(mData.value.distance),
                    style: CustomStyle.CustomFont(styleFontSize12, text_color_02),
                  ),
                ),
                Text(
                  Util.makeTime(mData.value.time??0),
                  style: CustomStyle.CustomFont(styleFontSize12, text_color_02),
                )
              ],
            )
          ),
          Container(
            height: CustomStyle.getHeight(5.h),
            color: line,
          )
        ],
      )
    );
  }*/

  Widget stopPointPannelWidget() {
    isStopPointExpanded.value = List.filled(1, false);
    return Flex(
      direction: Axis.vertical,
      children: List.generate(1, (index) {
        return Container(
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 5.w
                  ),
                )
            ),
          child: ExpansionPanelList.radio(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          children: [
            ExpansionPanelRadio(
              value: index,
              backgroundColor: Colors.white,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                     padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(5.h)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("경유지 ${mData.value.stopCount}곳",style: CustomStyle.CustomFont(styleFontSize16, text_color_01))
                      ],
                    )
                );
              },
              body: llStopPointList.value ?
                  Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: line,
                                  width: 1.w
                              ),
                          )
                      ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    mStopList.length,
                        (index) {
                      return stopPointItems(index);
                    },
                  ))) : const SizedBox(),
              canTapOnHeader: true,
            )
          ],
          expansionCallback: (int _index, bool status) {
            isStopPointExpanded[index] = !isStopPointExpanded[index];
          },
        ));
      }),
    );
  }

  Widget stopPointItems(int index) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h),horizontal: CustomStyle.getWidth(5.h)),
        decoration: BoxDecoration(
          color: styleGreyCol3,
          border: Border(bottom: BorderSide(color: line, width: 1.w)),
        ),
        child: Container(
            width: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                   Container(
                       padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h),horizontal: CustomStyle.getWidth(5.w)),
                       decoration: BoxDecoration(
                           border: Border.all(color: text_box_color_01,width: 1.w),
                           borderRadius: BorderRadius.all(Radius.circular(5.w))
                       ),
                       child: Text(
                         "경유지 ${index + 1}",
                         style: CustomStyle.CustomFont(styleFontSize12, text_box_color_01),
                       )
                   ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(3.w)),
                          child: Text(
                            mStopList.value[index].eComName??"",
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                          )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(3.w)),
                        alignment: Alignment.centerRight,
                        child: Text(
                          mStopList.value[index].stopSe == "S" ? "상차" : "하자",
                          style: CustomStyle.CustomFont(styleFontSize14, mStopList.value[index].stopSe == "S" ? order_state_04 : order_state_09),
                        ),
                      )
                    ],
                  ),
                  !(mStopList.value[index].eStaff?.isEmpty == true) || !(mStopList.value[index].eTel?.isEmpty == true) ?
                  Container(
                    margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h)),
                    child: Row(
                      children: [
                        Text(
                          mStopList.value[index].eStaff??"",
                          style: CustomStyle.CustomFont(styleFontSize12, text_color_01),
                        ),
                        InkWell(
                          onTap: () async {
                            if(Platform.isAndroid) {
                              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                              AndroidDeviceInfo info = await deviceInfo.androidInfo;
                              if (info.version.sdkInt >= 23) {
                                await FlutterDirectCallerPlugin.callNumber("${mStopList.value[index].eTel}");
                              }else{
                                await launch("tel://${mStopList.value[index].eTel}");
                              }
                            }else{
                              await launch("tel://${mStopList.value[index].eTel}");
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: CustomStyle.getWidth(3.w)),
                            child: Text(
                              Util.makePhoneNumber(mStopList.value[index].eTel),
                              style: CustomStyle.CustomFont(styleFontSize12, addr_type_text),
                            ),
                          ),
                        )
                      ],
                    )
                  ): const SizedBox(),
                  !(mStopList.value[index].eAddr?.isEmpty == true)?
                  Container(
                      margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h)),
                      child: Text(
                      mStopList.value[index].eAddr??"",
                      style: CustomStyle.CustomFont(styleFontSize12, text_color_01),
                    )
                  ) : const SizedBox(),
                  !(mStopList.value[index].eAddrDetail?.isEmpty == true) ?
                  Container(
                      margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h)),
                      child: Text(
                      mStopList.value[index].eAddrDetail??"",
                      style: CustomStyle.CustomFont(styleFontSize12, text_color_01),
                    )
                  ): const SizedBox()
                ],
              )
            )
    );
  }

  Widget cargoInfoWidget() {
    isCargoExpanded.value = List.filled(1, false);
    return Flex(
      direction: Axis.vertical,
      children: List.generate(1, (index) {
        return ExpansionPanelList.radio(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          children: [
            ExpansionPanelRadio(
              value: index,
              backgroundColor: Colors.white,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                    padding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(5.w),vertical: CustomStyle.getHeight(5.h)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("화물 정보",style: CustomStyle.CustomFont(styleFontSize16, text_color_01))
                      ],
                    ));
              },
              body: Obx((){
              return Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: line,
                      width: 1.w
                    )
                  )
                ),
                child: Column(
                  children: [
                    // 첫번째줄
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(2.w)),
                            decoration: BoxDecoration(
                                border: Border.all(color: line, width: 1.w)
                            ),
                            child: Text(
                                Strings.of(context)?.get("order_cargo_info_in_out_sctn")??"수출입구분_",
                              style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                            ),
                          )
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                          padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                          decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: line, width: 1.w
                                ),
                                right: BorderSide(
                                    color: line, width: 1.w
                                ),
                                top: BorderSide(
                                    color: line, width: 1.w
                                ),
                              )
                          ),
                          child: Text(
                              mData.value.inOutSctnName??"",
                            style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                          ),
                        )
                      ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    top: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_truck_type")??"운송유형_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    top: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.truckTypeName??"",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        )
                      ],
                    ),
                    // 두번째줄
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    left: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_car_ton")??"톤수_",
                                style: CustomStyle.CustomFont(styleFontSize12, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.carTonName??"",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_car_type")??"차종_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.carTypeName??"",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        )
                      ],
                    ),
                    // 세번째줄
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    left: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_cargo")??"화물정보_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.goodsName??"",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        )
                      ],
                    ),
                    // 네번째줄
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    left: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_item_lvl_1")??"운송품목_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.itemName??"-",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_wgt")??"적재중량_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                "${mData.value.goodsWeight} ${mData.value.weightUnitCode}",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        )
                      ],
                    ),
                    // 다섯번째줄
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    left: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_way_on")??"상차방법_",
                                style: CustomStyle.CustomFont(styleFontSize12, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.sWayName??"",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_way_off")??"하차방법_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.eWayName??"",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        )
                      ],
                    ),
                    // 여섯번째줄
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    left: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_mix_type")??"혼적여부_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.mixYn == "Y"?"${Strings.of(context)?.get("order_cargo_info_mix_y")}":"${Strings.of(context)?.get("order_cargo_info_mix_n")}",
                                style: CustomStyle.CustomFont(styleFontSize12, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                Strings.of(context)?.get("order_cargo_info_return_type")??"왕복여부_",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h),horizontal: CustomStyle.getWidth(5.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                    right: BorderSide(
                                        color: line, width: 1.w
                                    ),
                                  )
                              ),
                              child: Text(
                                mData.value.returnYn == "Y"?"${Strings.of(context)?.get("order_cargo_info_return_y")}":"${Strings.of(context)?.get("order_cargo_info_return_n")}",
                                style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                              ),
                            )
                        )
                      ],
                    )
                  ],
                )
              );
              }),
              canTapOnHeader: true,
            )
          ],
          expansionCallback: (int _index, bool status) {
            isCargoExpanded[index] = !isCargoExpanded[index];
          },
        );
      }),
    );
  }

  Widget etcPannelWidget() {

    isEtcExpanded.value = List.filled(1, false);
    return Flex(
      direction: Axis.vertical,
      children: List.generate(1, (index) {
        return ExpansionPanelList.radio(
          animationDuration: const Duration(milliseconds: 500),
          expandedHeaderPadding: EdgeInsets.zero,
          elevation: 0,
          children: [
            ExpansionPanelRadio(
              value: index,
              backgroundColor: Colors.white,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                    padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h),horizontal: CustomStyle.getWidth(5.w)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("기타",style: CustomStyle.CustomFont(styleFontSize16, text_color_01))
                      ],
                    ));
              },
              body: Obx((){
                return Container(
                    padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h),horizontal: CustomStyle.getWidth(10.w)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: line, width: 1.w
                        )
                      )
                    ),
                    child: Row(
                        children : [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Strings.of(context)?.get("order_trans_info_driver_memo")??"차주확인사항_",
                                style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                              ),
                              Container(
                                width: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width - 50.w,
                                height: CustomStyle.getHeight(80.h),
                                padding: EdgeInsets.all(10.w),
                                margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: line, width: 1.w),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                ),
                                child: Text(
                                  !(mData.value.driverMemo?.isEmpty == true) ? mData.value.driverMemo??"-" : "-",
                                  style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                                child: Text(
                                  Strings.of(context)?.get("order_request_info_reg_memo")??"요청사항_",
                                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                )
                              ),
                              Container(
                                width: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width - 50.w,
                                height: CustomStyle.getHeight(80.h),
                                padding: EdgeInsets.all(10.w),
                                margin: EdgeInsets.only(top: CustomStyle.getHeight(5.h)),
                                decoration: BoxDecoration(
                                    border: Border.all(color: line, width: 1.w),
                                    borderRadius: const BorderRadius.all(Radius.circular(5.0))
                                ),
                                child: Text(
                                  !(mData.value.reqMemo?.isEmpty == true) ? mData.value.reqMemo??"-" : "-",
                                  style: CustomStyle.CustomFont(styleFontSize11, text_color_01),
                                ),
                              )
                            ],
                          )
                        ]
                    )
                );
              }),
              canTapOnHeader: true,
            )
          ],
          expansionCallback: (int _index, bool status) {
            isEtcExpanded[index] = !isEtcExpanded[index];
          },
        );
      }),
    );
  }

  void showGuestDialog(){
    openOkBox(context, Strings.of(context)?.get("Guest_Intro_Mode")??"Error", Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
  }

  @override
  Widget build(BuildContext context) {
    pr = Util.networkProgress(context);
    return WillPopScope(
        onWillPop: () async {
          return Future((){
            BroadCast.FBroadcast.instance().broadcast(Const.INTENT_ORDER_REFRESH);
            Navigator.of(context).pop({'code':100});
            return true;
          });
        } ,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: sub_color,
          appBar: AppBar(
                title: Text(
                      Strings.of(context)?.get("order_detail_title")??"Not Found",
                      style: CustomStyle.appBarTitleFont(
                          styleFontSize16, styleWhiteCol)
                ),
                toolbarHeight: 50.h,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () async {
                    BroadCast.FBroadcast.instance().broadcast(Const.INTENT_ORDER_REFRESH);
                    Navigator.of(context).pop({'code':100});
                  },
                  color: styleWhiteCol,
                  icon: Icon(Icons.arrow_back,size: 24.h, color: Colors.white),
                ),
              ),
          body: SafeArea(
              child: Obx((){
                return SizedBox(
                    width: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width,
                    height: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height,
                    child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          topWidget(),
                          mData.value.driverId != null && mData.value.driverId?.isNotEmpty == true ? driverInfoWidget() : const SizedBox(), // 차주 정보
                          mData.value.enterDate != null && mData.value.enterDate?.isNotEmpty == true ? enterDateWidget() : const SizedBox(), // 입차, 출발, 도착 날짜
                          transInfoWidget(), // 배차 정보
                          llStopPointHeader.value ? stopPointPannelWidget() : const SizedBox(),
                          cargoInfoWidget(), // 화물 정보
                          Container(
                            height: 5.h,
                            color: line,
                          ),
                          etcPannelWidget()
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: CustomStyle.getHeight(7.h),
                        right: CustomStyle.getWidth(10.w),
                        child: InkWell(
                          onTap: () async {
                            await copyOrder();
                          },
                          child: Container(
                          padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(7.h),horizontal: CustomStyle.getWidth(10.w)),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(30.w),
                              color: copy_btn
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: CustomStyle.getWidth(3.w)),
                                child: Icon(Icons.file_copy, size: 24.h,color: Colors.white),
                              ),
                              Text(
                                Strings.of(context)?.get("order_detail_copy")??"오더복사_",
                                style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                              ),
                              ],
                            )
                        )
                      )
                    )
                  ],
                ));
              })
          ),
        )
    );
  }

}