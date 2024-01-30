// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _Rest implements Rest {
  _Rest(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://app.logis-link.co.kr';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<dynamic>> getCodeList(gcode) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'gcode': gcode};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cmm/code/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getCodeDetail(
    gcode,
    filter1,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'gcode': gcode,
      'filter1': filter1,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cmm/code/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getVersion(versionKind) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'versionKind': versionKind};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cmm/version/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> login(
    userId,
    passwd,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'passwd': passwd,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/cust/login/O',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> smsSendLoginService(
    Authorization,
    mobile,
    userName,
    userId,
    sendTime,
    loginBrowser,
    loginTime,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'mobile': mobile,
      'userName': userName,
      'userId': userId,
      'sendTime': sendTime,
      'loginBrowser': loginBrowser,
      'loginTime': loginTime,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/notice/talk/smsSendLoginService',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getUserInfo(Authorization) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/user/info',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> userUpdate(
    Authorization,
    passwd,
    telnum,
    email,
    mobile,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'passwd': passwd,
      'telnum': telnum,
      'email': email,
      'mobile': mobile,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/user/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> deviceUpdate(
    Authorization,
    pushYn,
    talkYn,
    pushId,
    deviceModel,
    deviceOs,
    appVersion,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'pushYn': pushYn,
      'talkYn': talkYn,
      'pushId': pushId,
      'deviceModel': deviceModel,
      'deviceOs': deviceOs,
      'appVersion': appVersion,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/device/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getOrder(
    Authorization,
    fromDate,
    toDate,
    orderState,
    myOrder,
    pageNo,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'fromDate': fromDate,
      'toDate': toDate,
      'orderState': orderState,
      'myOrder': myOrder,
      'pageNo': pageNo,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/order/list/O/v2',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getRecentOrder(
    Authorization,
    fromDate,
    toDate,
    pageNo,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'fromDate': fromDate,
      'toDate': toDate,
      'pageNo': pageNo,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/order/list/O/v2',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getOrderDetail(
    Authorization,
    orderId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'orderId': orderId};
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/order/list/O/v2',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getLocation(
    Authorization,
    orderId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'orderId': orderId};
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/orderlbs/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getStopPoint(
    Authorization,
    orderId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'orderId': orderId};
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/orderstop/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> orderReg(
    Authorization,
    reqCustId,
    reqDeptId,
    reqStaff,
    reqTel,
    reqAddr,
    reqAddrDetail,
    custId,
    deptId,
    inOutSctn,
    truckTypeCode,
    sComName,
    sSido,
    sGungu,
    sDong,
    sAddr,
    sAddrDetail,
    sDate,
    sStaff,
    sTel,
    sMemo,
    eComName,
    eSido,
    eGungu,
    eDong,
    eAddr,
    eAddrDetail,
    eDate,
    eStaff,
    eTel,
    eMemo,
    sLat,
    sLon,
    eLat,
    eLon,
    goodsName,
    goodsWeight,
    weightUnitCode,
    goodsQty,
    qtyUnitCode,
    sWayCode,
    eWayCode,
    mixYn,
    mixSize,
    returnYn,
    carTonCode,
    carTypeCode,
    chargeType,
    distance,
    time,
    reqMemo,
    driverMemo,
    itemCode,
    sellCharge,
    sellFee,
    orderStopList,
    buyStaff,
    buyStaffTel,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'reqCustId': reqCustId,
      'reqDeptId': reqDeptId,
      'reqStaff': reqStaff,
      'reqTel': reqTel,
      'reqAddr': reqAddr,
      'reqAddrDetail': reqAddrDetail,
      'custId': custId,
      'deptId': deptId,
      'inOutSctn': inOutSctn,
      'truckTypeCode': truckTypeCode,
      'sComName': sComName,
      'sSido': sSido,
      'sGungu': sGungu,
      'sDong': sDong,
      'sAddr': sAddr,
      'sAddrDetail': sAddrDetail,
      'sDate': sDate,
      'sStaff': sStaff,
      'sTel': sTel,
      'sMemo': sMemo,
      'eComName': eComName,
      'eSido': eSido,
      'eGungu': eGungu,
      'eDong': eDong,
      'eAddr': eAddr,
      'eAddrDetail': eAddrDetail,
      'eDate': eDate,
      'eStaff': eStaff,
      'eTel': eTel,
      'eMemo': eMemo,
      'sLat': sLat,
      'sLon': sLon,
      'eLat': eLat,
      'eLon': eLon,
      'goodsName': goodsName,
      'goodsWeight': goodsWeight,
      'weightUnitCode': weightUnitCode,
      'goodsQty': goodsQty,
      'qtyUnitCode': qtyUnitCode,
      'sWayCode': sWayCode,
      'eWayCode': eWayCode,
      'mixYn': mixYn,
      'mixSize': mixSize,
      'returnYn': returnYn,
      'carTonCode': carTonCode,
      'carTypeCode': carTypeCode,
      'chargeType': chargeType,
      'distance': distance,
      'time': time,
      'reqMemo': reqMemo,
      'driverMemo': driverMemo,
      'itemCode': itemCode,
      'sellCharge': sellCharge,
      'sellFee': sellFee,
      'orderStopList': orderStopList,
      'buyStaff': buyStaff,
      'buyStaffTel': buyStaffTel,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/order/write/v1',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getAddr(
    Authorization,
    addrName,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'addrName': addrName};
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/customer/addr',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> regAddr(
    Authorization,
    addrSeq,
    addrName,
    addr,
    addrDetail,
    lat,
    lon,
    staffName,
    staffTel,
    orderMemo,
    sido,
    gungu,
    dong,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'addrSeq': addrSeq,
      'addrName': addrName,
      'addr': addr,
      'addrDetail': addrDetail,
      'lat': lat,
      'lon': lon,
      'staffName': staffName,
      'staffTel': staffTel,
      'orderMemo': orderMemo,
      'sido': sido,
      'gungu': gungu,
      'dong': dong,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/customer/addr/write',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> deleteAddr(
    Authorization,
    addrSeq,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'addrSeq': addrSeq};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/customer/addr/delete',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getCustomer(
    Authorization,
    sellBuySctn,
    custName,
    telnum,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'sellBuySctn': sellBuySctn,
      'custName': custName,
      'telnum': telnum,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/customer/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getCustUser(
    Authorization,
    custId,
    deptId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'custId': custId,
      'deptId': deptId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/user/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getCost(
    Authorization,
    sellCustId,
    sellDeptId,
    buyCustId,
    buyDeptId,
    sSido,
    sGungu,
    eSido,
    eGungu,
    carTonCode,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'sellCustId': sellCustId,
      'sellDeptId': sellDeptId,
      'buyCustId': buyCustId,
      'buyDeptId': buyDeptId,
      'sSido': sSido,
      'sGungu': sGungu,
      'eSido': eSido,
      'eGungu': eGungu,
      'carTonCode': carTonCode,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/customer/frtCost',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getReceipt(
    Authorization,
    orderId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'orderId': orderId};
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/orderfile/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getMonitorOrder(
    Authorization,
    fromDate,
    toDate,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'fromDate': fromDate,
      'toDate': toDate,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/monitor/ownerKPI/v1',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getMonitorAlloc(
    Authorization,
    fromDate,
    toDate,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'fromDate': fromDate,
      'toDate': toDate,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/monitor/ownerOrder/v1',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getOption(Authorization) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/user/option',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> setOptionAddr(
    Authorization,
    sAreaYn,
    sComName,
    sSido,
    sGungu,
    sDong,
    sAddr,
    sAddrDetail,
    sStaff,
    sTel,
    sMemo,
    sLat,
    sLon,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'sAreaYn': sAreaYn,
      'sComName': sComName,
      'sSido': sSido,
      'sGungu': sGungu,
      'sDong': sDong,
      'sAddr': sAddr,
      'sAddrDetail': sAddrDetail,
      'sStaff': sStaff,
      'sTel': sTel,
      'sMemo': sMemo,
      'sLat': sLat,
      'sLon': sLon,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/user/option/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> setOptionCargo(
    Authorization,
    goodsYn,
    inOutSctn,
    truckTypeCode,
    carTypeCode,
    carTonCode,
    itemCode,
    goodsName,
    goodsWeight,
    sWayCode,
    eWayCode,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'goodsYn': goodsYn,
      'inOutSctn': inOutSctn,
      'truckTypeCode': truckTypeCode,
      'carTypeCode': carTypeCode,
      'carTonCode': carTonCode,
      'itemCode': itemCode,
      'goodsName': goodsName,
      'goodsWeight': goodsWeight,
      'sWayCode': sWayCode,
      'eWayCode': eWayCode,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/user/option/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> setOptionTrans(
    Authorization,
    buyYn,
    buyCustId,
    buyDeptId,
    buyStaffId,
    buyCharge,
    driverMemo,
    reqMemo,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'buyYn': buyYn,
      'buyCustId': buyCustId,
      'buyDeptId': buyDeptId,
      'buyStaffId': buyStaffId,
      'buyCharge': buyCharge,
      'driverMemo': driverMemo,
      'reqMemo': reqMemo,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/user/option/update',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getOmsUnitCharge(
    Authorization,
    buyCustId,
    buyDeptId,
    sSido,
    sGungu,
    sDong,
    eSido,
    eGungu,
    eDong,
    carTonCode,
    carTypeCode,
    sDate,
    eDate,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'buyCustId': buyCustId,
      'buyDeptId': buyDeptId,
      'sSido': sSido,
      'sGungu': sGungu,
      'sDong': sDong,
      'eSido': eSido,
      'eGungu': eGungu,
      'eDong': eDong,
      'carTonCode': carTonCode,
      'carTypeCode': carTypeCode,
      'sDate': sDate,
      'eDate': eDate,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/order/oms/unitcharge.do',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getOmsUnitCnt(
    Authorization,
    buyCustId,
    buyDeptId,
    sellCustId,
    sellDeptId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'buyCustId': buyCustId,
      'buyDeptId': buyDeptId,
      'sellCustId': sellCustId,
      'sellDeptId': sellDeptId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/order/unitCnt.do',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getNotice(Authorization) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/notice/board/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getNewNotice(
    Authorization,
    isNew,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'isNew': isNew};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/notice/board/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getNotification(Authorization) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cust/notice/push/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getJuso(
    confmKey,
    currentPage,
    countPerPage,
    keyword,
    resultType,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'confmKey': confmKey,
      'currentPage': currentPage,
      'countPerPage': countPerPage,
      'keyword': keyword,
      'resultType': resultType,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/addrlink/addrLinkApi.do',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getGeoAddress(
    Authorization,
    query,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'query': query};
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final Map<String, dynamic>? _data = null;
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/v2/local/search/address.json',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getSidoArea(sido) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {'sido': sido};
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/cmm/area/list',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> findId(
    userName,
    userPhone,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userName': userName,
      'userPhone': userPhone,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/cust/search/id',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> findPwd(
    userId,
    userName,
    userPhone,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/cust/search/pw',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getTermsUserAgree(
    Authorization,
    userId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'userId': userId};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/terms/AgreeUserIndex',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> getTermsTelAgree(
    Authorization,
    tel,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {'tel': tel};
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/terms/AgreeTelIndex',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> insertTermsAgree(
    Authorization,
    userName,
    tel,
    necessary,
    selective,
    termsVersion,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'userId': userName,
      'tel': tel,
      'necessary': necessary,
      'selective': selective,
      'version': termsVersion,
    };
    _data.removeWhere((k, v) => v == null);
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/terms/insertTermsAgree',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> updateTermsAgree(
    Authorization,
    userId,
    necessary,
    selective,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Authorization': Authorization};
    _headers.removeWhere((k, v) => v == null);
    final _data = {
      'userId': userId,
      'necessary': necessary,
      'selective': selective,
    };
    final _result =
        await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/terms/updateTermsAgree',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
