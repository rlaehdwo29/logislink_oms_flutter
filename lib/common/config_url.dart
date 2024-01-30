// String SERVER_URL = "http://ec2-13-124-193-78.ap-northeast-2.compute.amazonaws.com:8080";     // DEV URL


//String SERVER_URL = "https://app.logis-link.co.kr";   // PRO URL

const String m_ServerRelease = "https://app.logis-link.co.kr";
const String m_ServerDebug = "http://172.30.1.89:8080";
//const String m_ServerDebug = "http://192.168.0.2:8080";
const String m_ServerTest = "http://211.252.86.30:806";
const String SERVER_URL = m_ServerRelease;

const String RECEIPT_PATH = "/files/receipt/";

const String m_Release = "https://abt.logis-link.co.kr";
const String m_Debug = "http://172.30.1.89:8080";
//const String m_Debug = "http://192.168.0.2:8080";
const String m_Setting = m_Release;

const String JUSO_URL = "https://www.juso.go.kr";
const String KAKAO_URL = "https://dapi.kakao.com";

// 도로명 API 주소검색
const String URL_JUSO = "/addrlink/addrLinkApi.do";
// 카카오 API 주소검색(좌표 포함)
const String URL_KAKAO_ADDRESS = "/v2/local/search/address.json";

// 공통코드
const String URL_CODE_LIST = "/cmm/code/list";
// 버전코드
const String URL_VERSION_CODE = "/cmm/version/list";

// 로그인
const String URL_MEMBER_LOGIN = "/cust/login/O";
// 사용자 정보
const String URL_USER_INFO = "/cust/user/info";
// 사용자 정보 수정
const String URL_USER_UPDATE = "/cust/user/update";
// 기기 정보 업데이트
const String URL_DEVICE_UPDATE = "/cust/device/update";
// 로그인시 카카오톡 알람 확인
const String URL_LOGIN_ALARM = "/notice/talk/smsSendLoginService";

// 오더 목록
const String URL_ORDER_LIST = "/cust/order/list/O/v2";
// 오더 등록
const String URL_ORDER_REG = "/cust/order/write/v1";
// 경유지 목록
const String URL_STOP_POINT_LIST = "/cust/orderstop/list";
// 주소지명 목록
const String URL_ADDR_LIST = "/cust/customer/addr";
// 주소지명 등록/수정
const String URL_ADDR_REG = "/cust/customer/addr/write";
// 주소지명 삭제
const String URL_ADDR_DEL = "/cust/customer/addr/delete";
// 등록 거래처 목록
const String URL_CUSTOMER_LIST = "/cust/customer/list";
// 거래처 담당자 목록
const String URL_CUST_USER_LIST = "/cust/user/list";
// 구간별 계약 단가
const String URL_FRT_COST = "/cust/customer/frtCost";
// 인수증 목록
const String URL_RECEIPT_LIST = "/cust/orderfile/list";
// 차량 위치 관제
const String URL_LBS = "/cust/orderlbs/list";
// 공지사항
const String URL_NOTICE = "/cust/notice/board/list";
// 공지사항 상세
const String URL_NOTICE_DETAIL = "/notice/board/detail?boardSeq=";
// 알림
const String URL_NOTIFICATION = "/cust/notice/push/list";
// 시/군/구 목록
const String URL_SIDO_AREA = "/cmm/area/list";
// 오더&배차현황
const String URL_MONITOR_ORDER = "/cust/monitor/ownerKPI/v1";
// 배차&운송비현황
const String URL_MONITOR_ALLOC = "/cust/monitor/ownerOrder/v1";
// 업무 초기값
const String URL_OPTION = "/cust/user/option";
// 업무 초기값 설정
const String URL_OPTION_UPDATE = "/cust/user/option/update";
// ID 찾기
const String URL_FIND_ID = "/cust/search/id";
// 비밀번호 찾기
const String URL_FIND_PWD = "/cust/search/pw";

// 단가표 데이터 가져오기
const String URL_OMS_UNIT_CHARGE = "/cust/order/oms/unitcharge.do";

// 단가표 조회(Count)
const String URL_OMS_UNIT_CNT = "/cust/order/unitCnt.do";

// Junghwan.hwang Update
// 약관 동의 확인(ID)
const String URL_TERMS_ID = "/terms/AgreeUserIndex";
// 약관 동의 확인(전화번호)
const String URL_TERMS_TEL = "/terms/AgreeTelIndex";
// 약관 동의 업데이트(필수, 선택항목)
const String URL_TERMS_INSERT = "/terms/insertTermsAgree";
// 약관 동의 기록 DB 저장(insert)
const String URL_TERMS_UPDATE = "/terms/updateTermsAgree";

// 회원가입
const String URL_JOIN = "https://abt.logis-link.co.kr/join.do";

// 서비스 이용약관
//const String URL_SERVICE_TERMS = "https://abt.logis-link.co.kr/terms/service.do";
// 개인정보 처리방침
//const String URL_PRIVACY_TERMS = "https://abt.logis-link.co.kr/terms/privacy.do";
// 위치기반 서비스 이용약관
// const String URL_LBS_TERMS = "https://abt.logis-link.co.kr/terms/lbs.do";

// 2022.10.01 버전
// 이용약관
const String URL_AGREE_TERMS = m_Setting +"/terms/agree.do";
// 개인정보수집이용동의
const String URL_PRIVACY_TERMS = m_Setting +"/terms/privacy.do";
// 개인정보처리방침
const String URL_PRIVATE_INFO_TERMS = m_Setting +"/terms/privateInfo.do";
// 데이터보안서약
const String URL_DATA_SECURE_TERMS = m_Setting +"/terms/dataSecure.do";
// 마케팅정보수신동의
const String URL_MARKETING_TERMS = m_Setting +"/terms/marketing.do";


// 도움말
const String URL_MANUAL = SERVER_URL + "/manual/O/list";