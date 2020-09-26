public with sharing class SensorClient {

    private soapSforceComSchemasClassSensorserv.SensorService service;

    public SensorClient() {
        
        service = new soapSforceComSchemasClassSensorserv.SensorService();
    }

    public Boolean makeSoapRequest(String accountId, Integer sensorId, List<Integer> line) {
        //partnerSoapSforceCom.Soap myPartnerSoap = new partnerSoapSforceCom.Soap();  

        //partnerSoapSforceCom.LoginResult partnerLoginResult = myPartnerSoap.login('kisliuk-y@brave-unicorn-1e83n9.com', 'Kisya2000Y7lUeL3XsepQdMSfAhXWjO6q1'); 
        soapSforceComSchemasClassSensorserv.SessionHeader_element sh = new soapSforceComSchemasClassSensorserv.SessionHeader_element();
        sh.sessionId = getAccessToken();
        //sh.sessionId = partnerLoginResult.sessionId;
        service.SessionHeader = sh;
        return service.addData(accountId, sensorId, line);
    }

    // Resource Owner Password Credentials Flow
    @TestVisible public String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');

        String CLIENT_ID = '3MVG9n_HvETGhr3CVgh7YISdxCqtczxbn.jiToFPpAD75qrql9g.6eIvUF57NU636fRTLjrQpVJ7knOYBkmnL';
        String CLIENT_SECRET = '1BE15877A0EF14D85E52C025F29F7AD527990E0DA3A0D15A4EC7F8A67452BAFB';
        String USERNAME = 'julia018@bsuir.com';
        String PASSWORD = 'Kisya0182000';

        req.setBody('grant_type=password' + 
                    '&client_id=' + CLIENT_ID + 
                    '&client_secret=' + CLIENT_SECRET + 
                    '&username=' + USERNAME +
                    '&password=' + PASSWORD
                   );  

        Http http = new Http();
        HTTPResponse response = http.send(req);
        System.debug('Body ' + response.getBody());
        System.debug('Status ' + response.getStatus());
        System.debug('Status code ' + response.getStatusCode());
        System.debug('error ' + response.getBody());
        //return response.getBody();
        JSONParser parser = JSON.createParser(response.getBody());
        String accessToken = '';        
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                parser.nextToken();
                System.debug('fieldName'+fieldName);
                if (fieldName == 'access_token') {
                    accessToken = parser.getText();
                } 
            }
        }
        return accessToken;
    }


}
