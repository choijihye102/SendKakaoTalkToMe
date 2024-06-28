public with sharing class KakaoMessageService {

    private static String KAKAO_API_ENDPOINT = 'https://kapi.kakao.com/v2/api/talk/memo/default/send';
    private static String EXTERNAL_ACTIVITY_API_ENDPOINT = '/services/apexrest/api/v5/external-activities'; // 외부 활동 API 엔드포인트 URL

    @AuraEnabled
    public static void embeded(String message) {
        String token = KakaoAuth.getAccessTokenFromCustomSetting();
        System.debug('send클래스에서 token을 잘 세팅됨 :' + token);
        sendMessage(message, token);
    }

    @AuraEnabled
    public static void sendMessage(String message, String token) {
        String KAKAO_ACCESS_TOKEN = token;
        // KakaoTalk 메시지 보내기
        Map<String, Object> templateObject = createTemplateObject(message);
        String templateObjectJSON = JSON.serialize(templateObject);
        
        System.debug('Serialized Template Object: ' + templateObjectJSON);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(KAKAO_API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + KAKAO_ACCESS_TOKEN);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String encodedBody = 'template_object=' + EncodingUtil.urlEncode(templateObjectJSON, 'UTF-8');
        req.setBody(encodedBody);

        System.debug('Encoded Body: ' + encodedBody);
        
        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug('카카오톡 메시지를 성공적으로 보냈습니다.');
        } else {
            System.debug('오류: ' + res.getStatusCode() + ' - ' + res.getStatus());
            System.debug('응답 내용: ' + res.getBody());
        }
    }

    public static void createExternalActivity(String extension, String activityType, String value) {
        // 외부 활동 생성
        String requestBody = '{';
        requestBody += '"extension": "' + extension + '",';
        requestBody += '"type": "' + activityType + '",';
        requestBody += '"value": "' + value + '"';
        requestBody += '}';

        HttpRequest req = new HttpRequest();
        req.setEndpoint(EXTERNAL_ACTIVITY_API_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        // req.setHeader('Authorization', 'Bearer ' + 'YOUR_ACCESS_TOKEN'); // 필요에 따라 인증 헤더 추가
        req.setBody(requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 201) {
            System.debug('외부 활동이 성공적으로 생성되었습니다.');
        } else {
            System.debug('오류: ' + res.getStatusCode() + ' - ' + res.getStatus());
            System.debug('응답 내용: ' + res.getBody());
        }
    }

    private static Map<String, Object> createTemplateObject(String message) {
        Map<String, Object> templateObject = new Map<String, Object>();
        templateObject.put('object_type', 'text');
        templateObject.put('text', message);
        templateObject.put('link', new Map<String, Object>{'web_url' => 'http://www.google.com', 'mobile_web_url' => 'http://www.google.com'});
        return templateObject;
    }
}
