public with sharing class KakaoAuth {

    public static final String CLIENT_ID = 'cf9622b337fc30d93f77670bb22ec5c5';
    public static final String CLIENT_SECRET = 'JqjeAG9ejUnoXmdFFLTxLY0Fb39QtXzx';
    public static final String REDIRECT_URI = 'https://hiho2-dev-ed.my.salesforce.com/apex/KakaoAuthCallback';
    public static String authCodeValue { get; set; } //visualforce에서 변수 전달받기 위함

    public KakaoAuth() {
        // 초기값 설정
        authCodeValue = '';
        
    }

    @RemoteAction
    public static void receiveAuthCode(String authCode) {
        // 전달된 authCode를 Custom Setting에 저장하기 위해 매개변수로 전달
        System.debug('Received Authorization Code: ' + authCode);
        setAccessToken( authCode);
    }
    
    @AuraEnabled
    public static String getAuthUrl() {
        String authUrl = 'https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=' + CLIENT_ID + '&redirect_uri=' + REDIRECT_URI;
        system.debug(authUrl);
        return authUrl;
    }

    

    @AuraEnabled
    public static void setAccessToken(String inputValue) {
        system.debug('apex에서  setAccessToken 시행  : ' + inputValue);
        String tokenUrl = 'https://kauth.kakao.com/oauth/token';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(tokenUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded;charset=utf-8');
        String body = 'grant_type=authorization_code'
                    + '&client_id=' + CLIENT_ID
                    + '&client_secret=' + CLIENT_SECRET
                    + '&redirect_uri=' + REDIRECT_URI
                    + '&code=' + inputValue;
        req.setBody(body);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) responseMap.get('access_token');
            
            // Custom Setting에 저장
            KakaoTokenSetting__c tokenSetting = KakaoTokenSetting__c.getInstance(UserInfo.getUserId());
            if (tokenSetting == null) {
                tokenSetting = new KakaoTokenSetting__c();
                tokenSetting.SetupOwnerId = UserInfo.getUserId();
            }
            tokenSetting.AccessToken__c = accessToken;
            System.debug('AccessToken__c.accessToken :'+ tokenSetting.AccessToken__c );
          
            upsert tokenSetting;
            
        } else {
            throw new CalloutException('Failed to get access token: ' + res.getBody());
        }
    }

    @AuraEnabled
    public static String getAccessTokenFromCustomSetting() {
        // Custom Setting을 가져오기 전에 디버그 로그 추가
        System.debug('Attempting to retrieve custom setting for user: ' + UserInfo.getUserId());
        
        KakaoTokenSetting__c tokenSetting = KakaoTokenSetting__c.getInstance(UserInfo.getUserId());
        
        if (tokenSetting == null) {
            System.debug('Custom setting is null for user: ' + UserInfo.getUserId());
            return null;
        } else {
            System.debug('Custom setting retrieved: ' + tokenSetting.AccessToken__c);
            return tokenSetting.AccessToken__c;
        }
    }
}