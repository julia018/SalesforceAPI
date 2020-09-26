public with sharing class SensorClient {

    private soapSforceComSchemasClassSensorserv.SensorService service;

    public SensorClient() {
        
        service = new soapSforceComSchemasClassSensorserv.SensorService();
    }

    public Boolean makeSoapRequest(String accountId, Integer sensorId, List<Integer> line) {

        soapSforceComSchemasClassSensorserv.SessionHeader_element sh = new soapSforceComSchemasClassSensorserv.SessionHeader_element();
        sh.sessionId = getAccessToken();
        service.SessionHeader = sh;
        return service.addData(accountId, sensorId, line);
    }

    // Resource Owner Password Credentials Flow
    @TestVisible public String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');

        String CLIENT_ID = 'xxxxxxxxxxxxx';
        String CLIENT_SECRET = 'xxxxxxxxxxxxx';
        String USERNAME = 'xxxxx@xxx.xxx';
        String PASSWORD = 'xxxxxxxx';

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
