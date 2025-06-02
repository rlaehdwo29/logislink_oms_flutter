import 'package:logislink_oms_flutter/common/model/result_model.dart';
import 'package:logislink_oms_flutter/common/model/user_model.dart';
import 'package:retrofit/retrofit.dart';
import '../common/config_url.dart';
import 'package:dio/dio.dart';

part 'rest.g.dart';

@RestApi(baseUrl: SERVER_URL)
abstract class Rest {
  factory Rest(Dio dio,{String baseUrl}) = _Rest;


  /**
   * 공통코드
   */
  @POST(URL_CODE_LIST)
  Future<HttpResponse> getCodeList(@Field("gcode") String gcode);

  /**
   * 공통코드 상세
   */
  @POST(URL_CODE_LIST)
  Future<HttpResponse> getCodeDetail(@Field("gcode") String? gcode,
      @Field("filter1") String? filter1);

  /**
   * 버전코드
   */
  @POST(URL_VERSION_CODE)
  Future<HttpResponse> getVersion(@Field("versionKind") String versionKind);

  /**
   * 로그 저장
   */
  @FormUrlEncoded()
  @POST(URL_EVENT_LOG)
  Future<HttpResponse> setEventLog(
      @Field("userId") String? userId,
      @Field("menu_url") String? menu_url,
      @Field("menu_name") String? menu_name,
      @Field("app_type") String? app_type,
      @Field("device_os") String? device_os,
      @Field("app_version") String? app_version,
      @Field("loginYn") String? loginYn
      );

  /**
   * 차주 위치 관제 로그 저장
   */
  @FormUrlEncoded()
  @POST(URL_DRIVER_LOCATION_LOG)
  Future<HttpResponse> setDriverLocationLog(
      @Field("orderId") String? orderId,
      @Field("eventDesc") String? eventDesc,
      @Field("eventUrl") String? eventUrl,
      @Field("loginId") String? loginId,
      @Field("deviceOs") String? deviceOs,
      );


  /**
   * 로그인
   */
  @FormUrlEncoded()
  @POST(URL_MEMBER_LOGIN)
  Future<HttpResponse> login(@Field("userId") String userId,
      @Field("passwd") String passwd);


  /**
   * 기기 로그인 알림톡 전송
   */
  @POST(URL_LOGIN_ALARM)
  Future<HttpResponse> smsSendLoginService(@Header("Authorization") String? Authorization,
      @Field("mobile")String? mobile,
      @Field("userName")String? userName,
      @Field("userId")String? userId,
      @Field("sendTime")String? sendTime,
      @Field("loginBrowser")String? loginBrowser,
      @Field("loginTime")String? loginTime);

  /**
   * 사용자 정보
   */
  @POST(URL_USER_INFO)
  Future<HttpResponse> getUserInfo(@Header("Authorization") String? Authorization);

  /**
   * 사용자 정보 수정
   */
  @POST(URL_USER_UPDATE)
  Future<HttpResponse> userUpdate(@Header("Authorization") String? Authorization,
      @Field("passwd") String? passwd,
      @Field("telnum") String? telnum,
      @Field("email") String? email,
      @Field("mobile") String? mobile);

  /**
   * 기기 정보 업데이트
   */
  @POST(URL_DEVICE_UPDATE)
  Future<HttpResponse> deviceUpdate(@Header("Authorization") String? Authorization,
      @Field("pushYn") String pushYn,
      @Field("talkYn") String talkYn,
      @Field("pushId") String pushId,
      @Field("deviceModel") String deviceModel,
      @Field("deviceOs") String deviceOs,
      @Field("appVersion") String appVersion);

  /**
   * 오더 목록
   */
  @POST(URL_ORDER_LIST)
  Future<HttpResponse> getOrder(@Header("Authorization") String? Authorization,
      @Field("fromDate") String? fromDate,
      @Field("toDate") String? toDate,
      @Field("orderState") String? orderState,
      @Field("myOrder") String? myOrder,
      @Field("pageNo") int? pageNo);

  /**
   * 기존 거래 목록
   */
  @POST(URL_ORDER_LIST)
  Future<HttpResponse> getRecentOrder(@Header("Authorization") String? Authorization,
      @Field("fromDate") String? fromDate,
      @Field("toDate") String? toDate,
      @Field("pageNo") int? pageNo);

  /**
   * 오더 상세
   */
  @POST(URL_ORDER_LIST)
  Future<HttpResponse> getOrderDetail(@Header("Authorization") String? Authorization,
      @Field("orderId") String? orderId);

  /**
   * 차량 위치 관제
   */
  @POST(URL_LBS)
  Future<HttpResponse> getLocation(@Header("Authorization") String? Authorization,
      @Field("orderId") String? orderId);

  /**
   * 경유지 목록
   */
  @POST(URL_STOP_POINT_LIST)
  Future<HttpResponse> getStopPoint(@Header("Authorization") String? Authorization,
      @Field("orderId") String? orderId);

  /**
   * 오더 등록
   */
  @POST(URL_ORDER_REG)
  Future<HttpResponse> orderReg(@Header("Authorization") String? Authorization,
      @Field("reqCustId") String? reqCustId, @Field("reqDeptId") String? reqDeptId,
      @Field("reqStaff") String? reqStaff, @Field("reqTel") String? reqTel,
      @Field("reqAddr") String? reqAddr, @Field("reqAddrDetail") String? reqAddrDetail,
      @Field("custId") String? custId, @Field("deptId") String? deptId,
      @Field("inOutSctn") String? inOutSctn, @Field("truckTypeCode") String? truckTypeCode,
      @Field("sComName") String? sComName, @Field("sSido") String? sSido,
      @Field("sGungu") String? sGungu, @Field("sDong") String? sDong,
      @Field("sAddr") String? sAddr, @Field("sAddrDetail") String? sAddrDetail,
      @Field("sDate") String? sDate, @Field("sStaff") String? sStaff,
      @Field("sTel") String? sTel, @Field("sMemo") String? sMemo,
      @Field("eComName") String? eComName, @Field("eSido") String? eSido,
      @Field("eGungu") String? eGungu, @Field("eDong") String? eDong,
      @Field("eAddr") String? eAddr, @Field("eAddrDetail") String? eAddrDetail,
      @Field("eDate") String? eDate, @Field("eStaff") String? eStaff,
      @Field("eTel") String? eTel, @Field("eMemo") String? eMemo,
      @Field("sLat") double? sLat, @Field("sLon") double? sLon,
      @Field("eLat") double? eLat, @Field("eLon") double? eLon,
      @Field("goodsName") String? goodsName, @Field("goodsWeight") String? goodsWeight,
      @Field("weightUnitCode") String? weightUnitCode, @Field("goodsQty") String? goodsQty,
      @Field("qtyUnitCode") String? qtyUnitCode, @Field("sWayCode") String? sWayCode,
      @Field("eWayCode") String? eWayCode, @Field("mixYn") String? mixYn,
      @Field("mixSize") String? mixSize, @Field("returnYn") String? returnYn,
      @Field("carTonCode") String? carTonCode, @Field("carTypeCode") String? carTypeCode,
      @Field("chargeType") String? chargeType, @Field("distance") double? distance,
      @Field("time") int? time, @Field("reqMemo") String? reqMemo,
      @Field("driverMemo") String? driverMemo, @Field("itemCode") String? itemCode,
      @Field("sellCharge") String? sellCharge, @Field("sellFee") String? sellFee,
      @Field("orderStopList") String? orderStopList, @Field("buyStaff") String? buyStaff,
      @Field("buyStaffTel") String? buyStaffTel);

  /**
   * 주소지 목록
   */
  @POST(URL_ADDR_LIST)
  Future<HttpResponse> getAddr(@Header("Authorization") String? Authorization,
      @Field("addrName") String? addrName);


  /**
   * 주소지 등록
   */
  @POST(URL_ADDR_REG)
  Future<HttpResponse> regAddr(@Header("Authorization") String? Authorization,
      @Field("addrSeq") int? addrSeq,
      @Field("addrName") String? addrName,
      @Field("addr") String? addr,
      @Field("addrDetail") String? addrDetail,
      @Field("lat") String? lat,
      @Field("lon") String? lon,
      @Field("staffName") String? staffName,
      @Field("staffTel") String? staffTel,
      @Field("orderMemo") String? orderMemo,
      @Field("sido") String? sido,
      @Field("gungu") String? gungu,
      @Field("dong") String? dong);

  /**
   * 주소지 삭제
   */
  @POST(URL_ADDR_DEL)
  Future<HttpResponse> deleteAddr(@Header("Authorization") String Authorization,
      @Field("addrSeq") int addrSeq);

  /**
   * 거래처 목록
   */
  @POST(URL_CUSTOMER_LIST)
  Future<HttpResponse> getCustomer(@Header("Authorization") String? Authorization,
      @Field("sellBuySctn") String? sellBuySctn,
      @Field("custName") String? custName,
      @Field("telnum") String? telnum);

  /**
   * 거래처 담당자 목록
   */
  @POST(URL_CUST_USER_LIST)
  Future<HttpResponse> getCustUser(@Header("Authorization") String? Authorization,
      @Field("custId") String? custId,
      @Field("deptId") String? deptId);

  /**
   * 구간별계약단가
   */
  @POST(URL_FRT_COST)
  Future<HttpResponse> getCost(@Header("Authorization") String Authorization,
      @Field("sellCustId") String sellCustId,
      @Field("sellDeptId") String sellDeptId,
      @Field("buyCustId") String buyCustId,
      @Field("buyDeptId") String buyDeptId,
      @Field("sSido") String sSido,
      @Field("sGungu") String sGungu,
      @Field("eSido") String eSido,
      @Field("eGungu") String eGungu,
      @Field("carTonCode") String carTonCode);

  /**
   * 인수증 목록
   */
  @POST(URL_RECEIPT_LIST)
  Future<HttpResponse> getReceipt(@Header("Authorization") String? Authorization,
      @Field("orderId") String? orderId);

  /**
   * 오더&배차현황
   */
  @POST(URL_MONITOR_ORDER)
  Future<HttpResponse> getMonitorOrder(@Header("Authorization") String? Authorization,
      @Field("fromDate") String? fromDate,
      @Field("toDate") String? toDate);

  /**
   * 배차&운송비현황
   */
  @POST(URL_MONITOR_ALLOC)
  Future<HttpResponse> getMonitorAlloc(@Header("Authorization") String? Authorization,
      @Field("fromDate") String? fromDate,
      @Field("toDate") String? toDate);

  /**
   * 업무초기값
   */
  @POST(URL_OPTION)
  Future<HttpResponse> getOption(@Header("Authorization") String? Authorization);

  /**
   * 업무초기값 설정 - 상차지
   */
  @POST(URL_OPTION_UPDATE)
  Future<HttpResponse> setOptionAddr(@Header("Authorization") String? Authorization,
      @Field("sAreaYn") String? sAreaYn,
      @Field("sComName") String? sComName,
      @Field("sSido") String? sSido,
      @Field("sGungu") String? sGungu,
      @Field("sDong") String? sDong,
      @Field("sAddr") String? sAddr,
      @Field("sAddrDetail") String? sAddrDetail,
      @Field("sStaff") String? sStaff,
      @Field("sTel") String? sTel,
      @Field("sMemo") String? sMemo,
      @Field("sLat") double? sLat,
      @Field("sLon") double? sLon);

  /**
   * 업무초기값 설정 - 화물 정보
   */
  @POST(URL_OPTION_UPDATE)
  Future<HttpResponse> setOptionCargo(@Header("Authorization") String? Authorization,
      @Field("goodsYn") String? goodsYn,
      @Field("inOutSctn") String? inOutSctn,
      @Field("truckTypeCode") String? truckTypeCode,
      @Field("carTypeCode") String? carTypeCode,
      @Field("carTonCode") String? carTonCode,
      @Field("itemCode") String? itemCode,
      @Field("goodsName") String? goodsName,
      @Field("goodsWeight") String? goodsWeight,
      @Field("sWayCode") String? sWayCode,
      @Field("eWayCode") String? eWayCode);

  /**
   * 업무초기값 설정 - 운송 정보
   */
  @POST(URL_OPTION_UPDATE)
  Future<HttpResponse> setOptionTrans(@Header("Authorization") String? Authorization,
      @Field("buyYn") String? buyYn,
      @Field("buyCustId") String? buyCustId,
      @Field("buyDeptId") String? buyDeptId,
      @Field("buyStaffId") String? buyStaffId,
      @Field("buyCharge") String? buyCharge,
      @Field("driverMemo") String? driverMemo,
      @Field("reqMemo") String? reqMemo);

  /**
   * 단가표 값 조회
   */
  @POST(URL_OMS_UNIT_CHARGE)
  Future<HttpResponse> getOmsUnitCharge(@Header("Authorization") String? Authorization,
      @Field("buyCustId") String? buyCustId,
      @Field("buyDeptId") String? buyDeptId,
      @Field("sSido") String? sSido,
      @Field("sGungu") String? sGungu,
      @Field("sDong") String? sDong,
      @Field("eSido") String? eSido,
      @Field("eGungu") String? eGungu,
      @Field("eDong") String? eDong,
      @Field("carTonCode") String? carTonCode,
      @Field("carTypeCode") String? carTypeCode,
      @Field("sDate") String? sDate,
      @Field("eDate") String? eDate,
      );

  /**
   * 단가표 Count
   */
  @POST(URL_OMS_UNIT_CNT)
  Future<HttpResponse> getOmsUnitCnt(@Header("Authorization") String? Authorization,
      @Field("buyCustId") String? buyCustId,
      @Field("buyDeptId") String? buyDeptId,
      @Field("sellCustId") String? sellCustId,
      @Field("sellDeptId") String? sellDeptId);

  /**
   * 공지사항
   */
  @POST(URL_NOTICE)
  Future<HttpResponse> getNotice(@Header("Authorization") String? Authorization);

  /**
   * 공지사항 최신
   */
  @POST(URL_NOTICE)
  Future<HttpResponse> getNewNotice(@Header("Authorization") String Authorization,
      @Field("isNew") String isNew);

  /**
   * 알림
   */
  @POST(URL_NOTIFICATION)
  Future<HttpResponse> getNotification(@Header("Authorization") String? Authorization);

  /**
   * 주소 검색(도로명주소 API)
   */
  @POST(URL_JUSO)
  Future<HttpResponse> getJuso(@Field("confmKey") String confmKey,
      @Field("currentPage") String currentPage,
      @Field("countPerPage") String countPerPage,
      @Field("keyword") String keyword,
      @Field("resultType") String resultType);

  /**
   * 주소 검색(카카오 API)
   */
  @GET(URL_KAKAO_ADDRESS)
  Future<HttpResponse> getGeoAddress(@Header("Authorization") String Authorization,
      @Query("query") String query);


  /**
   * 시/군/구 검색
   */
  @POST(URL_SIDO_AREA)
  Future<HttpResponse> getSidoArea(@Field("sido") String? sido);

  /**
   * ID 찾기
   */
  @FormUrlEncoded()
  @POST(URL_FIND_ID)
  Future<HttpResponse> findId(@Field("userName") String userName,
      @Field("userPhone") String userPhone);

  /**
   * 비밀번호 찾기
   */
  @FormUrlEncoded()
  @POST(URL_FIND_PWD)
  Future<HttpResponse> findPwd(@Field("userId") String userId,
      @Field("userName") String userName,
      @Field("userPhone") String userPhone);

  ///////////////////////////////////////////////////////////////////////
  // 약관 동의
  ///////////////////////////////////////////////////////////////////////

  /**
   * 약관 동의 확인(ID)
   */
  @POST(URL_TERMS_ID)
  Future<HttpResponse> getTermsUserAgree(
      @Header("Authorization") String Authorization,
      @Field("userId") String userId);

  /**
   * 약관 동의 확인(전화번호)
   */
  @POST(URL_TERMS_TEL)
  Future<HttpResponse> getTermsTelAgree(
      @Header("Authorization") String Authorization,
      @Field("tel") String tel);

  /**
   * 약관 동의 업데이트(필수, 선택항목)
   */
  @POST(URL_TERMS_INSERT)
  Future<HttpResponse> insertTermsAgree(
      @Header("Authorization") String? Authorization,
      @Field("userId") String? userName,
      @Field("tel") String? tel,
      @Field("necessary") String? necessary,
      @Field("selective") String? selective,
      @Field("version") String? termsVersion
      );

  /**
   * 약관 동의 업데이트
   */
  @POST(URL_TERMS_UPDATE)
  Future<HttpResponse> updateTermsAgree(
      @Header("Authorization") String Authorization,
      @Field("userId") String userId,
      @Field("necessary") String necessary,
      @Field("selective") String selective
      );


}