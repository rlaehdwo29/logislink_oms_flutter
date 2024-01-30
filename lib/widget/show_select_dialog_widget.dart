import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logislink_oms_flutter/common/model/code_model.dart';
import 'package:logislink_oms_flutter/common/style_theme.dart';
import 'package:logislink_oms_flutter/constants/const.dart';
import 'package:logislink_oms_flutter/utils/sp.dart';

class ShowSelectDialogWidget {
  final BuildContext context;
  final String mTitle;
  final String codeType;
  final int? value;
  final void Function(CodeModel?,{String codeType,int value}) callback;

  ShowSelectDialogWidget({required this.context, required this.mTitle, required this.codeType,this.value, required this.callback});

  Future<void> showDialog() async  {
    var codeList = await SP.getCodeList(codeType);
    List<CodeModel>? mList = codeList;

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              mTitle,
              style: CustomStyle.CustomFont(styleFontSize18, Colors.white),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.of(context).pop();
                    });
                  },
                  icon: Icon(Icons.close, size: 28.h)
              )
            ],
            automaticallyImplyLeading: false,
          ),
          body: GridView.builder(
              itemCount: mList?.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //1 개의 행에 보여줄 item 개수
                childAspectRatio: (1 / .65),
                mainAxisSpacing: 2, //수평 Padding
                crossAxisSpacing: 2, //수직 Padding
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      callback(mList?[index],codeType: codeType, value: value??0);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                        height: CustomStyle.getHeight(70.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: line,
                                    width: CustomStyle.getWidth(1.0)
                                ),
                                right: BorderSide(
                                    color: line,
                                    width: CustomStyle.getWidth(1.0)
                                )
                            )
                        ),
                        child: Center(
                          child: Text(
                            "${mList?[index].codeName}",
                            textAlign: TextAlign.center,
                            style: CustomStyle.CustomFont(
                                styleFontSize12, text_color_01,
                                font_weight: FontWeight.w600),
                          ),
                        )
                    )
                );
              }
          ),
        );
      },
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.white,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}