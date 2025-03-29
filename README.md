# 📌 Salesforce KakaoTalk OAuth 2.0 Integration & Message Sender

---

## 🧩 프로젝트 개요

Salesforce 플랫폼에서 **APEX**와 **LWC (Lightning Web Components)**를 활용하여 **카카오톡 OAuth 2.0 인증**을 수행하고, 인증된 사용자가 **"나에게 메시지 보내기"** 기능을 사용할 수 있도록 구현한 프로젝트입니다.  
이를 통해 외부 소셜 플랫폼과 Salesforce 간의 인증 및 API 통신 흐름을 이해하고, 실제 비즈니스 로직에 적용 가능한 패턴을 실습했습니다.

---

## ⚙️ 기술 스택

| 구분           | 기술                                      |
|----------------|-------------------------------------------|
| 백엔드         | Apex (Salesforce)                         |
| 프론트엔드     | LWC (Lightning Web Components)            |
| 인증 프로토콜  | OAuth 2.0 (카카오)                         |
| 외부 API       | KakaoTalk REST API                        |
| 저장소         | Salesforce Custom Metadata / Custom Settings |
| 기타           | Named Credentials, Auth Provider          |

---

## 🗺️ 기능 시나리오

1. **사용자가 LWC 페이지 접속**  
   - "카카오톡 로그인" 버튼 클릭  
   - 사용자 브라우저는 카카오 OAuth 인증 URL로 리디렉션됨  

2. **카카오 인증 완료 후 리디렉션**  
   - 카카오 서버가 승인 코드 (Authorization Code)를 포함한 콜백 URL로 리디렉션  
   - Apex Controller가 코드 수신 → 액세스 토큰 요청  

3. **액세스 토큰 발급 및 저장**  
   - APEX에서 HTTP 요청으로 토큰 발급 요청  
   - 토큰을 Custom Metadata에 저장  

4. **"나에게 메시지 보내기" 버튼 클릭**  
   - APEX가 액세스 토큰을 사용하여 `/v2/api/talk/memo/default/send` 엔드포인트 호출  
   - 사용자의 카카오 계정으로 메시지 전송  

---

## 🔐 인증 흐름 상세

### 🔸 Auth Provider 설정
- Salesforce > Setup > Auth Provider 메뉴에서 Kakao OAuth 설정  
- Consumer Key/Secret, Authorize URL, Token URL 등 입력  

### 🔸 Named Credential 등록
- 인증된 API 호출을 위해 Named Credential 구성  
- Bearer Token 방식으로 Kakao API에 안전하게 접근  

### 🔸 APEX Controller
- `@AuraEnabled` 메서드로 OAuth 코드 처리 및 메시지 전송  
- `HttpRequest` / `HttpResponse` 활용하여 REST 통신 구현  

### 🔸 LWC 컴포넌트
- 사용자 인터페이스 구성 (로그인 버튼, 메시지 전송 버튼)  
- Apex 호출을 통한 비동기 처리 및 에러 핸들링

  

## 📤 메시지 샘플

```json
{
  "template_object": {
    "object_type": "text",
    "text": "Salesforce에서 보낸 테스트 메시지입니다.",
    "link": {
      "web_url": "https://mydomain.lightning.force.com",
      "mobile_web_url": "https://mydomain.lightning.force.com"
    },
    "button_title": "바로 가기"
  }
}

## 🔎 주요 포인트  
Salesforce 내 인증 연동이 복잡한 외부 플랫폼과도 어떻게 연동 가능한지를 보여주는 사례  

OAuth 인증부터 API 호출까지 전체 인증 흐름에 대한 이해도 입증  

LWC와 Apex 간의 비동기 처리 및 사용자 피드백 처리 구조 구현  

Named Credential + Auth Provider 활용으로 Salesforce 보안 정책 내에서 API 연동 가능  

## 💬 향후 개선 아이디어  
메시지 템플릿 커스터마이징 (버튼 추가, 이미지 포함 등)  

사용자별 토큰 저장을 위한 Custom Object 설계  

토큰 만료 자동 갱신 로직 추가  

친구에게 메시지 보내기 확장 기능  
