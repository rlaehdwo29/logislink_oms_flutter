import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:logislink_oms_flutter/common/app.dart';
import 'package:logislink_oms_flutter/common/app.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';
import 'package:logislink_oms_flutter/common/model/customer_model.dart';
import 'package:logislink_oms_flutter/common/model/user_model.dart';
import 'package:logislink_oms_flutter/common/strings.dart';
import 'package:logislink_oms_flutter/common/style_theme.dart';
import 'package:logislink_oms_flutter/constants/const.dart';
import 'package:logislink_oms_flutter/provider/dio_service.dart';
import 'package:logislink_oms_flutter/provider/order_service.dart';
import 'package:logislink_oms_flutter/utils/util.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class OrderCustomerPage extends StatefulWidget {

  OrderCustomerPage({Key? key}):super(key:key);

  _OrderCustomerPageState createState() => _OrderCustomerPageState();
}

class _OrderCustomerPageState extends State<OrderCustomerPage> {
  final controller = Get.find<App>();
  ProgressDialog? pr;

  final search_text = "".obs;
  final mList = List.empty(growable: true).obs;
  final arrayList = List.empty(growable: true).obs;
  final mFlag = false.obs;
  final size = 0.obs;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await initView();
    });
  }

  Future<void> initView() async {
    await getCustomer();
  }

  Future<void> getCustomer() async {
    Logger logger = Logger();
    UserModel? user = await controller.getUserInfo();
    await DioService.dioClient(header: true).getCustomer(
        user.authorization,
        "02","",""
    ).then((it) async {
      ReturnMap _response = DioService.dioResponse(it);
      logger.d("getCustUser() _response -> ${_response.status} // ${_response.resultMap}");
      if(_response.status == "200") {
        if(_response.resultMap?["result"] == true) {
          if(_response.resultMap?["data"] != null) {
            var list = _response.resultMap?["data"] as List;
            if(mList.length > 0) mList.clear();
            if(list.length > 0) {
              List<CustomerModel> itemsList = list.map((i) => CustomerModel.fromJSON(i)).toList();
              mList.addAll(itemsList);
              arrayList.addAll(mList);
            }else{
              arrayList.clear();
            }
            size.value = mList.length;
          }else{
            mList.value = List.empty(growable: true);
            arrayList.clear();
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
          print("getCustUser() Error => ${res?.statusCode} // ${res?.statusMessage}");
          break;
        default:
          print("getCustUser() getOrder Default => ");
          break;
      }
    });
  }

  Widget searchListWidget(){
    return mList.isNotEmpty
          ? Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: mList.length,
            itemBuilder: (context, index) {
              var item = mList[index];
              return getListItemView(item);
            },
          )
      ):Expanded(
          child: Container(
              alignment: Alignment.center,
              child: Text(
                Strings.of(context)?.get("empty_list") ?? "Not Found",
                style: CustomStyle.baseFont(),
              )
          )
      );
  }

  Widget getListItemView(CustomerModel item) {
    return InkWell(
        onTap: (){
          Navigator.of(context).pop({'code':200,'cust':item, "nonCust":false});
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: CustomStyle.getHeight(10.h), horizontal: CustomStyle.getWidth(20.w)),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: line,
                  width: 1.h
                )
              )
            ),
            child: Row(
              children: [
                Text(
                  item.custName??"",
                  style: CustomStyle.CustomFont(styleFontSize14, text_color_01),
                ),
                Container(
                    padding: EdgeInsets.only(left: CustomStyle.getHeight(5.0.w)),
                    child: Text(
                      item.deptName??"",
                      style: CustomStyle.CustomFont(styleFontSize12, text_color_03),
                    )
                ),
                CustomStyle.getDivider1()
              ],
            )
        )
    );
  }

  Widget searchBoxWidget() {
    return Row(
        children :[
          Expanded(
              child: TextField(
                style: CustomStyle.CustomFont(styleFontSize14, Colors.black),
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                onChanged: (value) async {
                  search_text.value = value;
                  if(size.value != 0) {
                    await getFilter(search_text.value);
                  }
                  mFlag.value = false;
                  String mResult = search_text.value.trim();
                  for(int i = 0; i < mList.length; i++) {
                    if((mResult == mList[i].custName && "물류팀(임시)" == mList[i].deptName)) {
                      mFlag.value = true;
                    }
                  }
                },
                decoration: InputDecoration(
                  counterText: '',
                  hintText: Strings.of(context)?.get("search_info")??"Not Found",
                  hintStyle:CustomStyle.greyDefFont(),
                  contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(15.0),vertical:CustomStyle.getHeight(15.0) ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: line, width: CustomStyle.getWidth(0.5))
                  ),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: line, width: CustomStyle.getWidth(0.5))
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: line, width: CustomStyle.getWidth(0.5))
                  ),
                  suffixIcon: GestureDetector(
                    child: Icon(
                      Icons.search, size: 20.h, color: Colors.black,
                    ),
                    onTap: (){

                    },
                  ),
                ),
              )
          ),
        ]
    );
  }

  Future<void> getFilter(String str) async {
    String search = str;
    search = search.toLowerCase();
    mList.clear();
    if(search.length == 0) {
      mList.addAll(arrayList);
    }else{
      for(var data in arrayList) {
        String name = data.custName;
        if(name.toLowerCase().contains(search)) {
          mList.add(data);
        }
      }
    }
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
          resizeToAvoidBottomInset: false,
            backgroundColor: sub_color,
            appBar: AppBar(
                  title:  Text(
                      Strings.of(context)?.get("order_customer_title")??"Not Found",
                      style: CustomStyle.appBarTitleFont(styleFontSize16,styleWhiteCol)
                  ),
                  toolbarHeight: 50.h,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop({'code':100});
                    },
                    color: styleWhiteCol,
                    icon: Icon(Icons.arrow_back, size: 24.h, color: styleWhiteCol),
                  ),
                ),
            body: SafeArea(
                child: Obx((){
                  return SizedBox(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    searchBoxWidget(),
                    searchListWidget()
                  ],
                ));
                })
              )
            ),
    );
  }

}