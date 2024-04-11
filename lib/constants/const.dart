class Const {
// 로그 개발 true, 운영 false
  static final bool logEnable = false;

  // 버전명
  static final APP_VERSION = "1.1.12";

  //스토어 주소
  static final ANDROID_STORE = "https://play.google.com/store/apps/details?id=com.logislink.oms";
  static final IOS_STORE = "https://apps.apple.com/app/id6476912966";


  static final int CONNECT_TIMEOUT = 15;
  static final int WRITE_TIMEOUT = 15;
  static final int READ_TIMEOUT = 15;

  static final List<String> first_screen = ["기본", "오더등록", "실적현황"];

  /**
   * PUSH SERVICE
   */
  static final String PUSH_SERVICE_CHANNEL_ID = "CHANNEL_LOGISLINK_INNOVATION";

  /**
   * Intent key
   */
  static const String CODE = "code";
  // 오더 Vo
  static const String ORDER_VO = "order_vo";
  // 주소 Vo
  static const String ADDR_VO = "addr_vo";
  // 공지사항 Vo
  static const String NOTICE_VO = "notice_vo";
  // Guest 모드
  static final KEY_GUEST_MODE = "key_guest";
  static final GUEST_ID = "guestH";
  static final GUEST_PW = "guestHp";

  /**
   * Intent Result Code
   */
  static const String RESULT_WORK = "result_work";

  static const String RESULT_WORK_DAY = "result_work_day";
  static const String RESULT_WORK_REQUEST = "result_work_request";
  static const String RESULT_WORK_RECENT_ORDER = "result_work_recentOrder";
  static const String RESULT_WORK_SADDR = "result_work_s_addr";
  static const String RESULT_WORK_EADDR = "result_work_e_addr";
  static const String RESULT_WORK_STOP_POINT = "result_work_stopPoint";
  static const String RESULT_WORK_CARGO = "result_work_cargo";
  static const String RESULT_WORK_CHARGE = "result_work_charge";
  static const String RESULT_WORK_TRANS = "result_work_trans";

  static const String RESULT_SETTING_REQUEST = "result_setting_request";
  static const String RESULT_SETTING_SADDR = "result_setting_s_addr";
  static const String RESULT_SETTING_CARGO = "result_setting_cargo";
  static const String RESULT_SETTING_CHARGE = "result_setting_charge";
  static const String RESULT_SETTING_TRANS = "result_setting_trans";
  //static final String RESULT_SETTING_RPA   = "result_setting_rpa";

  /**
   * Intent Sub key
   */
  static final String UNIT_CHARGE_CNT = "unit_charge_cnt";
  static final String UNIT_BUY_CHARGE_LOCAL = "unit_buy_charge_local";
  static final String UNIT_SELL_CHARGE_LOCAL = "unit_sell_charge_local";
  static final String UNIT_PRICE_LOCAL = "unit_price_local";

  /**
   * Intent Sub key - RPA 모드
   */
  static final String RPA_24CALL_YN = "rpa_24call_yn";
  static final String RPA_HWAMULL_YN = "rpa_hwamull_yn";
  static final String RPA_ONECALL_YN = "rpa_onecall_yn";
  static final String RPA_SALARY = "rpa_salary";


  /**
   * Intent Filter
   */
  static final String INTENT_ORDER_REFRESH = "com.logislink.oms.INTENT_ORDER_REFRESH";
  static final String INTENT_ORDER_DETAIL_REFRESH = "com.logislink.oms.INTENT_ORDER_DETAIL_REFRESH";

  /**
   * SP key
   */
  // 약관동의
  static final String KEY_TERMS = "key_terms";
  // 유저 ID
  static final String KEY_USER_ID = "key_user_id";
  // 유저 PWD
  static final String KEY_USER_PWD = "key_user_pwd";
  // 유저정보
  static final String KEY_USER_INFO = "key_user_info";
  // 푸쉬 ID
  static final String KEY_PUSH_ID = "key_push_id";
  // 환경설정 - 화면 꺼짐 방지
  static final String KEY_SETTING_WAKE = "key_setting_wake";
  // 환경설정 - 푸시 메시지 알림
  static final String KEY_SETTING_PUSH = "key_setting_push";
  // 환경설정 - 알림톡
  static final String KEY_SETTING_TALK = "key_setting_talk";
  // 황결설정 - 시작 화면 설정
  static final String KEY_SETTING_SCREEN = "key_setting_screen";

  // 황결설정 - 상차지 초기값 설정
  static final String KEY_SETTING_SADDR = "key_setting_s_addr";
  // 황결설정 - 화물 초기값 설정
  static final String KEY_SETTING_CARGO = "key_setting_cargo";
  // 황결설정 - 운송 초기값 설정
  static final String KEY_SETTING_TRANS = "key_setting_trans";

  // 최근 공지 읽음처리
  static final String KEY_READ_NOTICE = "key_read_notice";

  /**
   * 공통코드 key
   */
  static List<String> codeList = [
    SELL_BUY_SCTN, SHIPMENT_PROG_CD, QTY_UNIT_CD, WGT_UNIT_CD, CAR_SPEC_CD, ITEM_CD,
    CARGO_TRAN_CAR_SCTN_CD, CUST_TYPE_CD, SIDO, TM_CAR_TYPE_CD, IN_OUT_SCTN, TRUCK_TYPE_CD,
    CAR_BOOK_ITEM_CD, BIZ_TYPE_CD, BANK_CD, ORDER_STATE_CD, ALLOC_STATE_CD, WAY_TYPE_CD,
    MIX_SIZE_CD, CAR_TYPE_CD, CAR_TON_CD, CAR_MNG_CD, URGENT_CODE, LINK_CD
  ];

  static getCodeList() {
    return codeList;
  }

  // 공통코드 버전
  static final String CD_VERSION = "CD_VERSION";
  // 매출입구분
  static final String SELL_BUY_SCTN = "SELL_BUY_SCTN";
  // 배차진행상태
  static final String SHIPMENT_PROG_CD = "SHIPMENT_PROG_CD";
  // 수량단위
  static final String QTY_UNIT_CD = "QTY_UNIT_CD";
  // 중량단위
  static final String WGT_UNIT_CD = "WGT_UNIT_CD";
  // 차량규격(톤수)
  static final String CAR_SPEC_CD = "CAR_SPEC_CD";
  // 대분류품목군
  static final String ITEM_CD = "ITEM_CD";
  // 차량구분
  static final String CARGO_TRAN_CAR_SCTN_CD = "CARGO_TRAN_CAR_SCTN_CD";
  // 거래처구분
  static final String CUST_TYPE_CD = "CUST_TYPE_CD";
  // 시/도
  static final String SIDO = "SIDO";
  // 차량유형(차종)
  static final String TM_CAR_TYPE_CD = "TM_CAR_TYPE_CD";
  // 수출입구분
  static final String IN_OUT_SCTN = "IN_OUT_SCTN";
  // 운송유형
  static final String TRUCK_TYPE_CD = "TRUCK_TYPE_CD";
  // 차계부항목
  static final String CAR_BOOK_ITEM_CD = "CAR_BOOK_ITEM_CD";
  // 사업자구분
  static final String BIZ_TYPE_CD = "BIZ_TYPE_CD";
  // 은행
  static final String BANK_CD = "BANK_CD";
  // 오더상태
  static final String ORDER_STATE_CD = "ORDER_STATE_CD";
  // 배차상태
  static final String ALLOC_STATE_CD = "ALLOC_STATE_CD";
  // 상하차방법
  static final String WAY_TYPE_CD = "WAY_TYPE_CD";
  // 혼적길이
  static final String MIX_SIZE_CD = "MIX_SIZE_CD";
  // 차종
  static final String CAR_TYPE_CD = "CAR_TYPE_CD";
  // 톤수
  static final String CAR_TON_CD = "CAR_TON_CD";
  // 차량관리코드
  static final String CAR_MNG_CD = "CAR_MNG_CD";
  // 긴급대응상태
  static final String URGENT_CODE = "URGENT_CODE";
  // 화물정보망그룹코드
  static final String LINK_CD = "LINK_CD";

  /**
   * Dialog key
   */
  // 시/군/구
  static final String SIDO_AREA = "SIDO_AREA";

  /**
   * API key
   */
  // 주소 API KEY
  static final String JUSU_KEY = "U01TX0FVVEgyMDIxMDcyODEyNTg0MzExMTQ2MjA=";
  /*
    * 기본 Enum 및 연산 도구
    */
}

/*
    * 기본 Enum 및 연산 도구
    */

enum TERMS {
  NONE, INSERT, UPDATE, DONE
}
