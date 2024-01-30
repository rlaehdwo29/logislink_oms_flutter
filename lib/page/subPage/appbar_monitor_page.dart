import 'dart:convert';

import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:logislink_oms_flutter/common/app.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';
import 'package:logislink_oms_flutter/common/model/monitor_alloc_model.dart';
import 'package:logislink_oms_flutter/common/model/monitor_order_model.dart';
import 'package:logislink_oms_flutter/common/model/user_model.dart';
import 'package:logislink_oms_flutter/common/strings.dart';
import 'package:logislink_oms_flutter/common/style_theme.dart';
import 'package:logislink_oms_flutter/constants/const.dart';
import 'package:logislink_oms_flutter/provider/dio_service.dart';
import 'package:logislink_oms_flutter/utils/sp.dart';
import 'package:logislink_oms_flutter/utils/util.dart';
import 'package:logislink_oms_flutter/widget/show_code_dialog_widget.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:dio/dio.dart';

class AppBarMonitorPage extends StatefulWidget {
  AppBarMonitorPage({Key? key}):super(key: key);

  _AppBarMonitorPageState createState() => _AppBarMonitorPageState();
}

class _AppBarMonitorPageState extends State<AppBarMonitorPage> with TickerProviderStateMixin {
  final controller = Get.find<App>();

  final mCarBookList = List.empty(growable: true).obs;
  final mCarList = List.empty(growable: true).obs;
  final focusDate = DateTime.now().obs;
  final startDate = DateTime(DateTime.now().year,DateTime.now().month,1).obs;
  final endDate = DateTime(DateTime.now().year,DateTime.now().month+1,0).obs;
  final mTabCode = "01".obs;
  late TabController _tabController;

  ProgressDialog? pr;

  final GlobalKey webViewKey = GlobalKey();
  late final InAppWebViewController webViewController;
  late final PullToRefreshController pullToRefreshController;

  final mUser = UserModel().obs;
  final mMonitor = MonitorOrderModel().obs;
  final mMonitorAlloc = MonitorAllocModel().obs;

  //부서별 손익 Fragment
  final tvSellTotal = "".obs;
  final tvBuyTotal = "".obs;
  final tvProfitTotal = "".obs;
  final tvProfitPercentTotal = "".obs;

  final adapter01 = {}.obs;
  final adapter02 = {}.obs;
  final adapter03 = {}.obs;
  final adapter04 = {}.obs;


@override
void initState() {
  super.initState();

  startDate.value = DateTime(focusDate.value.year,focusDate.value.month,1);
  endDate.value = DateTime(focusDate.value.year,focusDate.value.month+1,0);
  _tabController = TabController(
      length: 2,
      vsync: this,//vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
      initialIndex: 0
  );
  _tabController.addListener(_handleTabSelection);

  Future.delayed(Duration.zero, () async {
  });

  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    await initView();
  });

  pullToRefreshController = (kIsWeb
      ? null
      : PullToRefreshController(
    options: PullToRefreshOptions(color: Colors.blue,),
    onRefresh: () async {
      if (defaultTargetPlatform == TargetPlatform.android) {
        webViewController.reload();
      } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
        webViewController.loadUrl(urlRequest: URLRequest(url: await webViewController.getUrl()));}
    },
  ))!;
}

Future<void> initView() async {
  mUser.value = await controller.getUserInfo();
  if(mTabCode.value == "01") {
    await getMonitorOrder();
  }else if(mTabCode.value == "02"){
    await getMonitorAlloc();
  }
}

Future<void> backMonth(String? code) async {
  focusDate.value = DateTime(focusDate.value.year,focusDate.value.month-1);
  startDate.value = DateTime(focusDate.value.year,focusDate.value.month,1);
  endDate.value = DateTime(focusDate.value.year,focusDate.value.month+1,0);
  if(mTabCode.value == "01") {
    await getMonitorOrder();
  }else if(mTabCode.value == "02"){
    await getMonitorAlloc();
  }
}

Future<void> nextMonth(String? code) async {
  focusDate.value = DateTime(focusDate.value.year,focusDate.value.month+1);
  startDate.value = DateTime(focusDate.value.year,focusDate.value.month,1);
  endDate.value = DateTime(focusDate.value.year,focusDate.value.month+1,0);
  if(mTabCode.value == "01") {
    await getMonitorOrder();
  }else if(mTabCode.value == "02"){
    await getMonitorAlloc();
  }
}

Future<void> _handleTabSelection() async {
  if (_tabController.indexIsChanging) {
    // 탭이 변경되는 중에만 호출됩니다.
    // _tabController.index를 통해 현재 선택된 탭의 인덱스를 가져올 수 있습니다.
    int selectedTabIndex = _tabController.index;
    switch(selectedTabIndex) {
      case 0 :
        mTabCode.value = "01";
        await initView();
        break;
      case 1 :
        mTabCode.value = "02";
        await initView();
        break;
    }
  }
}

Widget calendarWidget(String? code) {
  var mCal = Util.getDateCalToStr(focusDate.value, "yyyy-MM-dd");
  return Container(
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width,
    padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(5.h)),
    color: styleWhiteCol,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: (){backMonth(code);},
                alignment: Alignment.center,
                icon: Icon(Icons.keyboard_arrow_left_outlined,size: 26.h,color: text_color_01)
            )
        ),
        Expanded(
            flex: 1,
            child: Text(
                "${mCal.split("-")[0]}년 ${mCal.split("-")[1]}월",
                style: CustomStyle.CustomFont(styleFontSize14, Colors.black),
                textAlign: TextAlign.center,
            )
        ),
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: (){nextMonth(code);},
                alignment: Alignment.center,
                icon: Icon(Icons.keyboard_arrow_right_outlined,size: 26.h,color: text_color_01)
            )
        )
      ],
    ),
  );
}

Widget getTabFuture() {
  return tabBarViewWidget();
}

Widget tabBarValueWidget(String? tabValue) {
  Widget _widget = orderFragment(tabValue);
  switch(tabValue) {
    case "01" :
      _widget = orderFragment(tabValue);
      break;
    case "02" :
      _widget = allocFragment(tabValue);
      break;
  }
  return _widget;
}

  Future<void> getMonitorOrder() async {
    Logger logger = Logger();
    await pr?.show();
    await DioService.dioClient(header: true).getMonitorOrder(
        mUser.value.authorization,
        Util.getDateCalToStr(startDate.value, "yyyy-MM-dd"),
        Util.getDateCalToStr(endDate.value, "yyyy-MM-dd")
    ).then((it) async {
      await pr?.hide();
      ReturnMap response = DioService.dioResponse(it);
      logger.d("getMonitorOrder() _response -> ${response.status} // ${response.resultMap}");
      if(response.status == "200") {
        if (response.resultMap?["data"] != null) {
            var list = response.resultMap?["data"] as List;
            if (list != null && list.length > 0) {
              MonitorOrderModel? monitorOrder = MonitorOrderModel.fromJSON(
                  list[0]);
              mMonitor.value = monitorOrder;
            }
        }
      }
    }).catchError((Object obj) async {
      await pr?.hide();
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getMonitorOrder() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getMonitorOrder() Error Default => ");
          break;
      }
    });
  }

  Future<void> getMonitorAlloc() async {
    Logger logger = Logger();
    await pr?.show();
    await DioService.dioClient(header: true).getMonitorAlloc(
        mUser.value.authorization,
        Util.getDateCalToStr(startDate.value, "yyyy-MM-dd"),
        Util.getDateCalToStr(endDate.value, "yyyy-MM-dd")
    ).then((it) async {
      await pr?.hide();
      ReturnMap response = DioService.dioResponse(it);
      logger.d("getMonitorAlloc() _response -> ${response.status} // ${response.resultMap}");
      if(response.status == "200") {
        if (response.resultMap?["data"] != null) {
            var list = response.resultMap?["data"] as List;
            if(list[0]["orderCnt"] > 0) {
              MonitorAllocModel? data = MonitorAllocModel.fromJSON(list[0]);
              int? cntSTotal = int.parse(data.cnt1T.toString()) +
                  int.parse(data.cnt2T5.toString()) +
                  int.parse(data.cnt3T5.toString());
              int? cntMTotal = int.parse(data.cnt5T.toString()) +
                  int.parse(data.cnt5A.toString()) +
                  int.parse(data.cnt11T.toString());
              int? cntLTotal = int.parse(data.cnt15T.toString()) +
                  int.parse(data.cnt25T.toString());
              int? cntEtcTotal = int.parse(data.cnt20FT.toString()) +
                  int.parse(data.cnt40FT.toString()) +
                  int.parse(data.cntETC.toString());
              int? cntTotal = cntSTotal + cntMTotal + cntLTotal + cntEtcTotal;
              data.cntSTotal = cntSTotal;
              data.cntMTotal = cntMTotal;
              data.cntLTotal = cntLTotal;
              data.cntEtcTotal = cntEtcTotal;
              data.cntTotal = cntTotal;

              int? amtSTotal = int.parse(data.amt1T.toString()) +
                  int.parse(data.amt2T5.toString()) +
                  int.parse(data.amt3T5.toString());
              int? amtMTotal = int.parse(data.amt5T.toString()) +
                  int.parse(data.amt5A.toString()) +
                  int.parse(data.amt11T.toString());
              int? amtLTotal = int.parse(data.amt15T.toString()) +
                  int.parse(data.amt25T.toString());
              int? amtEtcTotal = int.parse(data.amt20FT.toString()) +
                  int.parse(data.amt40FT.toString()) +
                  int.parse(data.amtETC.toString());
              int? amtTotal = amtSTotal + amtMTotal + amtLTotal + amtEtcTotal;
              data.amtSTotal = amtSTotal;
              data.amtMTotal = amtMTotal;
              data.amtLTotal = amtLTotal;
              data.amtEtcTotal = amtEtcTotal;
              data.amtTotal = amtTotal;

              mMonitorAlloc.value = data;
            }else{
              mMonitorAlloc.value = MonitorAllocModel();
            }
        }
      }
    }).catchError((Object obj) async {
      await pr?.hide();
      switch (obj.runtimeType) {
        case DioError:
        // Here's the sample to get the failed response error code and message
          final res = (obj as DioError).response;
          print("getMonitorAlloc() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getMonitorAlloc() Error Default => ");
          break;
      }
    });
  }

  Widget orderStateWidget() {
  return Column(
    children: [
      // 구분 / 오더 현황
      Container(
        padding: EdgeInsets.all(10.w),
        color: main_color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                Strings.of(context)?.get("monitor_order_value_01")??"구분_",
                textAlign: TextAlign.center,
                style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.of(context)?.get("monitor_order_item_order")??"오뎌헌황_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                ),
                Text(
                  Strings.of(context)?.get("monitor_order_item_order_unit")??"(건, %)_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize12, Colors.white),
                ),
              ],
              )
            )
          ],
        ),
      ),
      //전체 오더
      Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: line,
              width: 0.5.w
            )
          )
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                Strings.of(context)?.get("monitor_order_item_order_value_01")??"전체오더_",
                textAlign: TextAlign.center,
                style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
              )
            ),
            Expanded(
                flex: 2,
                child: Text(
                  Util.getInCodeCommaWon((mMonitor.value.allocCnt??0).toString()),
                  textAlign: TextAlign.right,
                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                )
            ),
          ],
        ),
      ),
      // 사전오더
      Container(
        padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(15.h),horizontal: CustomStyle.getWidth(10.w)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: line,
                    width: 0.5.w
                )
            )
        ),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Text(
                  Strings.of(context)?.get("monitor_order_item_order_value_02")??"사전오더_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                )
            ),
            Expanded(
                flex: 2,
                child: Text(
                  Strings.of(context)?.get("sub_total")??"소계_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                )
            ),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Util.getInCodeCommaWon((mMonitor.value.preOrder??0).toString()),
                    textAlign: TextAlign.right,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                    child: Text(
                      Util.getPercent(mMonitor.value.preOrder??0, mMonitor.value.allocCnt??0),
                      textAlign: TextAlign.right,
                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                    )
                  )
                ],
                )
            ),
          ],
        ),
      ),
      // 당일오더
      Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: line,
                    width: 0.5.w
                )
            )
        ),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(left:CustomStyle.getWidth(10.w),top: CustomStyle.getHeight(15.h),bottom: CustomStyle.getHeight(15.h)),
                    child: Text(
                    Strings.of(context)?.get("monitor_order_item_order_value_03")??"당일오더_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
                )
            ),
            Expanded(
              flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: line,
                        width: 0.5.w
                      )
                    )
                  ),
                    child:Column(
                  children: [
                    //당일오더 -> 소계
                    Container(
                      padding: EdgeInsets.only(right:CustomStyle.getWidth(10.w),bottom: CustomStyle.getHeight(5.h),top: CustomStyle.getHeight(5.h)),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: line,
                            width: 0.5.w
                          )
                        )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Text(
                                Strings.of(context)?.get("sub_total")??"소계_",
                                textAlign: TextAlign.center,
                                style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                              )
                          ),
                          Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Util.getInCodeCommaWon((mMonitor.value.todayOrder??0).toString()),
                                    textAlign: TextAlign.right,
                                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                                      child: Text(
                                        Util.getPercent(mMonitor.value.todayOrder??0, mMonitor.value.allocCnt??0),
                                        textAlign: TextAlign.right,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  )
                                ],
                              )
                          ),
                        ],
                      )
                    ),
                    // 당일오더 -> 당착
                    Container(
                        padding: EdgeInsets.only(right:CustomStyle.getWidth(10.w),bottom: CustomStyle.getHeight(5.h),top: CustomStyle.getHeight(5.h)),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: line,
                                    width: 0.5.w
                                )
                            )
                        ),
                        child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text(
                              Strings.of(context)?.get("monitor_order_item_order_value_03_01")??"당착_",
                              textAlign: TextAlign.center,
                              style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                            )
                        ),
                        Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Util.getInCodeCommaWon((mMonitor.value.todayFinish??0).toString()),
                                  textAlign: TextAlign.right,
                                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                ),
                                Container(
                                    padding: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                                    child: Text(
                                      Util.getPercent(mMonitor.value.todayFinish??0, mMonitor.value.todayOrder??0),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    )
                                )
                              ],
                            )
                        ),
                      ],
                    )
                  ),
                    // 당일오더 -> 익착
                    Container(
                        padding: EdgeInsets.only(right:CustomStyle.getWidth(10.w),bottom: CustomStyle.getHeight(5.h),top: CustomStyle.getHeight(5.h)),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text(
                                  Strings.of(context)?.get("monitor_order_item_order_value_03_02")??"익착_",
                                  textAlign: TextAlign.center,
                                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                )
                            ),
                            Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      Util.getInCodeCommaWon((mMonitor.value.tomorrowFinish??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                                        child: Text(
                                          Util.getPercent(mMonitor.value.tomorrowFinish??0, mMonitor.value.todayOrder??0),
                                          textAlign: TextAlign.right,
                                          style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                        )
                                    )
                                  ],
                                )
                            ),
                          ],
                        )
                    )
                  ],
                )
            )
            )
          ],
        ),
      ),
    ],
  );
  }

  Widget kpiWidget() {
    return Column(
      children: [
        // 구분 / 배차 KPI
        Container(
          padding: EdgeInsets.all(10.w),
          color: main_color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  Strings.of(context)?.get("monitor_order_value_01")??"구분_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.of(context)?.get("monitor_order_item_kpi")??"배차KPI_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                      ),
                      Text(
                        Strings.of(context)?.get("monitor_order_item_kpi_unit")??"(건, %)_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize12, Colors.white),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
        // 책임배차
        Container(
          padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(15.h),horizontal: CustomStyle.getWidth(10.w)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("monitor_order_item_kpi_value_01")??"책임배차_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("monitor_order_item_kpi_value_01_01")??"미준수_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Util.getInCodeCommaWon((mMonitor.value.allocDelay??0).toString()),
                        textAlign: TextAlign.right,
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                          child: Text(
                            Util.getPercent(mMonitor.value.allocDelay??0, mMonitor.value.allocCnt??0),
                            textAlign: TextAlign.right,
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                          )
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
        // 입차준수
        Container(
          padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(15.h),horizontal: CustomStyle.getWidth(10.w)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("monitor_order_item_kpi_value_02")??"입차준수_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("monitor_order_item_kpi_value_02_01")??"미준수_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Util.getInCodeCommaWon((mMonitor.value.enterDelay??0).toString()),
                        textAlign: TextAlign.right,
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                          child: Text(
                            Util.getPercent(mMonitor.value.enterDelay??0, mMonitor.value.allocCnt??0),
                            textAlign: TextAlign.right,
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                          )
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
        // 도착준수
        Container(
          padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(15.h),horizontal: CustomStyle.getWidth(10.w)),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("monitor_order_item_kpi_value_03")??"도착준수_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("monitor_order_item_kpi_value_03_01")??"미준수_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Util.getInCodeCommaWon((mMonitor.value.finishDelay??0).toString()),
                        textAlign: TextAlign.right,
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: CustomStyle.getHeight(10.h)),
                          child: Text(
                            Util.getPercent(mMonitor.value.finishDelay??0, mMonitor.value.allocCnt??0),
                            textAlign: TextAlign.right,
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                          )
                      )
                    ],
                  )
              ),
            ],
          ),
        )
      ],
    );
  }

Widget orderFragment(String? code) {
  return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
    children: [
      calendarWidget(code),
      orderStateWidget(),
      kpiWidget()
    ],
  )
  );
}

  Widget allocFragment(String? code) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
            child: Column(
          children: [
            calendarWidget(code),
            allocStateWidget(), // 배차현황
            tonAllocStateWidget(), // 톤급별 배차대수
            tonAllocTransportPriceWidget(), // 톤급별 운송비
          ],
        ))
      ],
    );
  }

  Widget allocStateWidget() {
  return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          color: main_color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  Strings.of(context)?.get("monitor_order_value_01")??"구분_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.of(context)?.get("monitor_alloc_item_alloc")??"배차현황_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                      ),
                      Text(
                        Strings.of(context)?.get("monitor_order_item_kpi_unit")??"(건, %)_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize12, Colors.white),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
        //전체 오더
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("monitor_order_item_order_value_01")??"전체오더_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    Util.getInCodeCommaWon((mMonitorAlloc.value.orderCnt??0).toString()),
                    textAlign: TextAlign.right,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
            ],
          ),
        ),
        //배차
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_alloc_value_02")??"배차_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("sub_total")??"소계_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Util.getInCodeCommaWon((mMonitorAlloc.value.allocCnt??0).toString()),
                        textAlign: TextAlign.right,
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      ),
                      CustomStyle.sizedBoxHeight(3.h),
                      Text(
                        Util.getPercent(mMonitorAlloc.value.allocCnt??0, mMonitorAlloc.value.orderCnt??0),
                        textAlign: TextAlign.right,
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      )
                  ],
                )
              ),
            ],
          ),
        ),
        //미배차
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_alloc_value_03")??"미배차_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("sub_total")??"소계_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Util.getInCodeCommaWon((mMonitorAlloc.value.notAllocCnt??0).toString()),
                        textAlign: TextAlign.right,
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      ),
                      CustomStyle.sizedBoxHeight(3.h),
                      Text(
                        Util.getPercent(mMonitorAlloc.value.notAllocCnt??0, mMonitorAlloc.value.orderCnt??0),
                        textAlign: TextAlign.right,
                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ],
  );
}

  Widget tonAllocStateWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          color: main_color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  Strings.of(context)?.get("monitor_order_value_01")??"구분_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.of(context)?.get("monitor_alloc_item_ton")??"톤급별 배차대수_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                      ),
                      Text(
                        Strings.of(context)?.get("monitor_alloc_item_ton_unit")??"(건)_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize12, Colors.white),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
        //전체 오더
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("total")??"합계_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    Util.getInCodeCommaWon((mMonitorAlloc.value.cntTotal??0).toString()),
                    textAlign: TextAlign.right,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
            ],
          ),
        ),
        //소형
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: CustomStyle.getWidth(1.0)
                  ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01")??"소형_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: line,
                          width: CustomStyle.getWidth(1.0)
                        )
                      )
                    ),
                      child: Column(
                children: [
                  //소계
                  Container(
                    padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: line,
                          width: CustomStyle.getWidth(1.0)
                        )
                      )
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              Strings.of(context)?.get("sub_total")??"소계_",
                              textAlign: TextAlign.center,
                              style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                            )
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            Util.getInCodeCommaWon((mMonitorAlloc.value.cntSTotal??0).toString()),
                            textAlign: TextAlign.right,
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                          ),
                        ),
                      ],
                    )
                  ),
                  // 1톤
                  Container(
                      padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01_01")??"1톤_",
                            textAlign: TextAlign.center,
                            style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                          )
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          Util.getInCodeCommaWon((mMonitorAlloc.value.cnt1T??0).toString()),
                          textAlign: TextAlign.right,
                          style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                        ),
                      ),
                    ],
                  )
                  ),
                  // 2.5톤
                  Container(
                      padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01_02")??"2.5톤_",
                                textAlign: TextAlign.center,
                                style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                              )
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              Util.getInCodeCommaWon((mMonitorAlloc.value.cnt2T5??0).toString()),
                              textAlign: TextAlign.right,
                              style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                            ),
                          ),
                        ],
                      )
                  ),
                  // 3.5톤
                  Container(
                      padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01_03")??"3.5톤_",
                                textAlign: TextAlign.center,
                                style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                              )
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              Util.getInCodeCommaWon((mMonitorAlloc.value.cnt3T5??0).toString()),
                              textAlign: TextAlign.right,
                              style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              )
              )
              )
            ],
          ),
        ),
        //중형
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: line,
                    width: CustomStyle.getWidth(1.0)
                ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02")??"중형_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Column(
                        children: [
                          //소계
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("sub_total")??"소계_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cntMTotal??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 5톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02_01")??"5톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cnt5T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 5톤축
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02_02")??"5톤축_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cnt5A??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 11톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02_03")??"11톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cnt11T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
        //대형
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: line,
                    width: CustomStyle.getWidth(1.0)
                ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_03")??"대형_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Column(
                        children: [
                          //소계
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("sub_total")??"소계_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cntLTotal??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 15톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_03_01")??"15톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cnt15T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 25톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_03_02")??"25톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cnt25T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
        //기타
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: line,
                    width: CustomStyle.getWidth(1.0)
                ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04")??"기타_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Column(
                        children: [
                          //소계
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("sub_total")??"소계_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cntEtcTotal??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 20FT
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04_01")??"20FT_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cnt20FT??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 40FT
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04_02")??"40FT_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cnt40FT??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 기타
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04_03")??"기타_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.cntETC??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget tonAllocTransportPriceWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          color: main_color,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  Strings.of(context)?.get("monitor_order_value_01")??"구분_",
                  textAlign: TextAlign.center,
                  style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Strings.of(context)?.get("monitor_alloc_item_charge")??"톤급별 운송비_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize14, Colors.white),
                      ),
                      Text(
                        Strings.of(context)?.get("monitor_alloc_item_charge_unit")??"(원)_",
                        textAlign: TextAlign.center,
                        style: CustomStyle.CustomFont(styleFontSize12, Colors.white),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
        //전체 오더
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: line,
                      width: 0.5.w
                  )
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    Strings.of(context)?.get("total")??"합계_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    Util.getInCodeCommaWon((mMonitorAlloc.value.amtTotal??0).toString()),
                    textAlign: TextAlign.right,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
            ],
          ),
        ),
        //소형
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: line,
                    width: CustomStyle.getWidth(1.0)
                ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01")??"소형_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Column(
                        children: [
                          //소계
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("sub_total")??"소계_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amtSTotal??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 1톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01_01")??"1톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt1T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 2.5톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01_02")??"2.5톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt2T5??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 3.5톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_01_03")??"3.5톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt3T5??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
        //중형
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: line,
                    width: CustomStyle.getWidth(1.0)
                ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02")??"중형_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Column(
                        children: [
                          //소계
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("sub_total")??"소계_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amtMTotal??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 5톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02_01")??"5톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt5T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 5톤축
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02_02")??"5톤축_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt5A??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 11톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_02_03")??"11톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt11T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
        //대형
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: line,
                    width: CustomStyle.getWidth(1.0)
                ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_03")??"대형_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Column(
                        children: [
                          //소계
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("sub_total")??"소계_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amtLTotal??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 15톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_03_01")??"15톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt15T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 25톤
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_03_02")??"25톤_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt25T??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
        //기타
        Container(
          decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: line,
                    width: CustomStyle.getWidth(1.0)
                ),
              )
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04")??"기타_",
                    textAlign: TextAlign.center,
                    style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                  )
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: line,
                                  width: CustomStyle.getWidth(1.0)
                              )
                          )
                      ),
                      child: Column(
                        children: [
                          //소계
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("sub_total")??"소계_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amtEtcTotal??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 20FT
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04_01")??"20FT_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt20FT??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 40FT
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: line,
                                          width: CustomStyle.getWidth(1.0)
                                      )
                                  )
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04_02")??"40FT_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amt40FT??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          // 기타
                          Container(
                              padding: EdgeInsets.only(top: CustomStyle.getHeight(3.h),bottom: CustomStyle.getHeight(3.h), right: CustomStyle.getWidth(3.w),left: CustomStyle.getWidth(3.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        Strings.of(context)?.get("monitor_alloc_item_ton_charge_value_04_03")??"기타_",
                                        textAlign: TextAlign.center,
                                        style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                      )
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      Util.getInCodeCommaWon((mMonitorAlloc.value.amtETC??0).toString()),
                                      textAlign: TextAlign.right,
                                      style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      )
                  )
              )
            ],
          ),
        ),
      ],
    );
  }

Widget tabBarViewWidget() {
  return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          tabBarValueWidget("01"),
          tabBarValueWidget("02"),
        ],
      )
  );
}

Widget customTabBarWidget() {
  return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xff31363A),
      child: TabBar(
        tabs: [
          Container(
              height: 50.h,
              alignment: Alignment.center,
              child: Text(
                      Strings.of(context)?.get("monitor_value_01")??"Not Found",
                      style: TextStyle(
                  fontSize: styleFontSize14,
                )
                    ),
          ),
          Container(
              height: 50.h,
              alignment: Alignment.center,
              child: Text(
                Strings.of(context)?.get("monitor_value_02")??"Not Found",
                style: TextStyle(
                  fontSize: styleFontSize14,
                )
              ),
          ),
        ],
        indicator: const BoxDecoration(
            color: Color(0xff31363A)
        ),
        labelColor: Colors.white,
        unselectedLabelColor: text_color_03,
        controller: _tabController,
      ));
}


@override
Widget build(BuildContext context) {
  pr = Util.networkProgress(context);
  return WillPopScope(
      onWillPop: () async {
        return Future((){
          FBroadcast.instance().broadcast(Const.INTENT_ORDER_REFRESH);
          return true;
        });
      } ,
      child: Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 50.h,
              title: Text(
                  Strings.of(context)?.get("monitor_title")??"Not Found",
                  style: CustomStyle.appBarTitleFont(styleFontSize18,styleWhiteCol)
              ),
              leading: IconButton(
                onPressed: () async {
                  FBroadcast.instance().broadcast(Const.INTENT_ORDER_REFRESH);
                  Navigator.of(context).pop();
                },
                color: styleWhiteCol,
                icon: Icon(Icons.close,size: 24.h,color: styleWhiteCol),
              )
          ),
      body: SafeArea(
          child: Obx(() {
          return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customTabBarWidget(),
                    getTabFuture()
                  ]
          );
        }
        )
      )
  ));
}
}