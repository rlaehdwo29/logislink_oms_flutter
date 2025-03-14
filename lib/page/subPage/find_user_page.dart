import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logislink_oms_flutter/common/common_util.dart';
import 'package:logislink_oms_flutter/common/model/result_model.dart';
import 'package:logislink_oms_flutter/common/style_theme.dart';
import 'package:logislink_oms_flutter/interfaces/rest.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../common/strings.dart';
import 'package:logger/logger.dart';

class FindUserPage extends StatefulWidget {
      const FindUserPage({Key? key}): super(key: key);

      @override
      _FindUserPageState createState() => _FindUserPageState();
}

class _FindUserPageState extends State<FindUserPage> {

  String findID_nm = "";
  String findID_phone = "";
  String findPW_id = "";
  String findPW_nm = "";
  String findPW_phone = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

   return Scaffold(
     backgroundColor: styleWhiteCol,
     appBar: AppBar(
       title: Text(
           Strings.of(context)?.get("find_user")??"ID / 비밀번호 찾기_",
           style: CustomStyle.appBarTitleFont(styleFontSize16,styleWhiteCol)
       ),
       toolbarHeight: 50.h,
       centerTitle: true,
       automaticallyImplyLeading: false,
       leading: IconButton(
         onPressed: (){
           Navigator.pop(context);
         },
         color: styleWhiteCol,
         icon: Icon(Icons.arrow_back,size: 24.h,color: Colors.white),
       ),
     ),
     body: SafeArea(
       child: SingleChildScrollView(
         child: Container(
           padding: const EdgeInsets.all(20.0),
            child: Column(
             children: [
               Container(
                 alignment: Alignment.centerLeft,
                 padding: EdgeInsets.only(bottom: CustomStyle.getHeight(15.0)),
                 child : Text(
                   "이름, 휴대폰 번호로\n아이디를 찾습니다.",
                   style: CustomStyle.CustomFont(styleFontSize15,styleBlackCol1),
                 )
               ),
               TextField(
                  style: CustomStyle.CustomFont(styleFontSize14,styleBalckCol4),
                 textAlign: TextAlign.start,
                 keyboardType: TextInputType.text,
                 onChanged: (value){
                   findID_nm = value;
                 },
                 maxLength: 50,
                 decoration: InputDecoration(
                     counterText: '',
                     hintText: Strings.of(context)?.get("name"),
                     hintStyle:CustomStyle.greyDefFont(),
                     contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(15.0)),
                     enabledBorder: UnderlineInputBorder(
                         borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                     ),
                     disabledBorder: UnderlineInputBorder(
                         borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                     ),
                     focusedBorder: UnderlineInputBorder(
                         borderSide: BorderSide(color: main_color, width: CustomStyle.getWidth(1.5))
                     )
                  )
                 ),
               CustomStyle.sizedBoxHeight(20.0),
               TextField(
                   style: CustomStyle.CustomFont(styleFontSize14,styleBalckCol4),
                   textAlign: TextAlign.start,
                   keyboardType: TextInputType.text,
                   onChanged: (value){
                      findID_phone = value;
                   },
                   maxLength: 50,
                   decoration: InputDecoration(
                       counterText: '',
                       hintText: Strings.of(context)?.get("phone_number"),
                       hintStyle:CustomStyle.greyDefFont(),
                       contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(15.0)),
                       enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       disabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: main_color, width: CustomStyle.getWidth(1.5))
                       )
                   )
               ),
               CustomStyle.sizedBoxHeight(20.0),
               SizedBox(
                 width: width,
                 height: CustomStyle.getHeight(50.0),
                 child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       foregroundColor: main_color,
                       backgroundColor: main_color,
                     ),
                     onPressed: () {
                       var logger = Logger();
                       Dio dio = Dio();
                       dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
                       final client = Rest(dio);
                       ReturnMap response;
                       client.findId(findID_nm, findID_phone).then((it) {
                         try {
                           var jsonString = jsonEncode(it);
                           Map<String, dynamic> jsonData = jsonDecode(jsonString);
                           ResultModel result = ResultModel.fromJSON(jsonData);
                           response = ReturnMap(status: "200",message: result.msg);
                         }catch(e) {
                           response = ReturnMap(status: "500", message: "json parser error");
                         }
                         logger.i("find_user_page.dart findId() => ${it}");
                         openOkBox(context,response.message??"",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
                       }).catchError((Object obj) {
                         switch (obj.runtimeType) {
                           case DioError:
                           // Here's the sample to get the failed response error code and message
                             final res = (obj as DioError).response;
                             logger.e("find_user_page.dart findId() error : ${res?.statusCode} -> ${res?.statusMessage}");
                             openOkBox(context,"${res?.statusCode} / ${res?.statusMessage}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
                             break;
                           default:
                             logger.e("find_user_page.dart findId() error2 :");
                             break;
                         }
                       });


                     },
                     child: Text(
                       Strings.of(context)?.get("find_id")??"Not Found",
                       style: CustomStyle.baseFont(),
                     )
                 )
               ),
               CustomStyle.sizedBoxHeight(30.0),
               CustomStyle.getDivider2(),
               CustomStyle.sizedBoxHeight(30.0), Container(
                   alignment: Alignment.centerLeft,
                   padding: EdgeInsets.only(bottom: CustomStyle.getHeight(15.0)),
                   child : Text(
                     "아이디, 이름, 휴대폰번호로\n비밀번호를 찾습니다.",
                     style: CustomStyle.CustomFont(styleFontSize15,styleBlackCol1),
                   )
               ),
               TextField(
                   style: CustomStyle.CustomFont(styleFontSize14,styleBalckCol4),
                   textAlign: TextAlign.start,
                   keyboardType: TextInputType.text,
                   onChanged: (value){
                      findPW_id = value;
                   },
                   maxLength: 50,
                   decoration: InputDecoration(
                       counterText: '',
                       hintText: Strings.of(context)?.get("id"),
                       hintStyle:CustomStyle.greyDefFont(),
                       contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(15.0)),
                       enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       disabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: main_color, width: CustomStyle.getWidth(1.5))
                       )
                   )
               ),
               CustomStyle.sizedBoxHeight(20.0),
               TextField(
                   style: CustomStyle.CustomFont(styleFontSize14,styleBalckCol4),
                   textAlign: TextAlign.start,
                   keyboardType: TextInputType.text,
                   onChanged: (value){
                      findPW_nm = value;
                   },
                   maxLength: 50,
                   decoration: InputDecoration(
                       counterText: '',
                       hintText: Strings.of(context)?.get("name"),
                       hintStyle:CustomStyle.greyDefFont(),
                       contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(15.0)),
                       enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       disabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: main_color, width: CustomStyle.getWidth(1.5))
                       )
                   )
               ),
               CustomStyle.sizedBoxHeight(20.0),
               TextField(
                   style: CustomStyle.CustomFont(styleFontSize14,styleBalckCol4),
                   textAlign: TextAlign.start,
                   keyboardType: TextInputType.text,
                   onChanged: (value){
                      findPW_phone = value;
                   },
                   maxLength: 50,
                   decoration: InputDecoration(
                       counterText: '',
                       hintText: Strings.of(context)?.get("phone_number"),
                       hintStyle:CustomStyle.greyDefFont(),
                       contentPadding: EdgeInsets.symmetric(horizontal: CustomStyle.getWidth(15.0)),
                       enabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       disabledBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: styleBlackCol1, width: CustomStyle.getWidth(0.5))
                       ),
                       focusedBorder: UnderlineInputBorder(
                           borderSide: BorderSide(color: main_color, width: CustomStyle.getWidth(1.5))
                       )
                   )
               ),
               CustomStyle.sizedBoxHeight(20.0),
               SizedBox(
                   width: width,
                   height: CustomStyle.getHeight(50.0),
                   child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         foregroundColor: main_color,
                         backgroundColor: main_color,
                       ),
                       onPressed: () {
                         if(findPW_id.isEmpty){
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(
                                 content: Text("아이디를 입력해주세요."),
                               duration: Duration(seconds: 2),
                             )
                           );
                           return;
                         }
                         if(findPW_nm.isEmpty){
                           ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                 content: Text("이름을 입력해주세요."),
                                 duration: Duration(seconds: 2),
                               )
                           );
                           return;
                         }
                         if(findPW_phone.isEmpty) {
                           ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                 content: Text("휴대폰 번호를 입력해주세요."),
                                 duration: Duration(seconds: 2),
                               )
                           );
                           return;
                         }
                         var logger = Logger();
                         Dio dio = Dio();
                         dio.options.headers["Content-Type"] = "application/x-www-form-urlencoded";
                         final client = Rest(dio);
                         ReturnMap response;
                         client.findPwd(findPW_id, findPW_nm, findPW_phone).then((it) {
                           try {
                             var jsonString = jsonEncode(it);
                             Map<String, dynamic> jsonData = jsonDecode(jsonString);
                             ResultModel result = ResultModel.fromJSON(jsonData);
                             response = ReturnMap(status: "200",message: result.msg);
                           }catch(e) {
                             response = ReturnMap(status: "500", message: "json parser error");
                           }
                           logger.i("find_user_page.dart findPwd() => ${it}");
                           openOkBox(context,response.message??"",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
                         }).catchError((Object obj) {
                           switch (obj.runtimeType) {
                             case DioError:
                             // Here's the sample to get the failed response error code and message
                               final res = (obj as DioError).response;
                               logger.e("find_user_page.dart findPwd() error : ${res?.statusCode} -> ${res?.statusMessage}");
                               openOkBox(context,"${res?.statusCode} / ${res?.statusMessage}",Strings.of(context)?.get("confirm")??"Error!!",() {Navigator.of(context).pop(false);});
                               break;
                             default:
                               logger.e("find_user_page.dart findPwd() error2222 :");
                               break;
                           }
                         });
                       },
                       child: Text(
                         Strings.of(context)?.get("find_pwd")??"Not Found",
                         style: CustomStyle.baseFont(),
                       )
                   )
               ),
             ],
           )
         )
       )
     ),
   );
  }

}