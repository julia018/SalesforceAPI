public with sharing class SensorRESTClient {

    public void makeRestCallout(Id accountId, Integer sensorId, List<Integer> line) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://ap16.salesforce.com/services/Soap/class/SensorService');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');        
        String token = getAccessToken();
        
        String body = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sen="http://soap.sforce.com/schemas/class/SensorService"><soapenv:Header><sen:AllowFieldTruncationHeader><sen:allowFieldTruncation>true</sen:allowFieldTruncation></sen:AllowFieldTruncationHeader><sen:DebuggingHeader></sen:DebuggingHeader><sen:CallOptions><sen:client>true</sen:client></sen:CallOptions><sen:SessionHeader><sen:sessionId>'
                       + token + 
                       '</sen:sessionId></sen:SessionHeader></soapenv:Header><soapenv:Body><sen:addData><sen:accountId>'
                       + accountId + 
                       '</sen:accountId><sen:sensorId>'
                       + sensorId + 
                       '</sen:sensorId>';
        for(Integer point: line) {
            body += '<sen:line>' + point + '</sen:line>';
        }               
        body += '</sen:addData></soapenv:Body></soapenv:Envelope>';
        request.setBody(body);
        HttpResponse responce = Http.send(request);
        system.debug(responce);
        system.debug(responce.getBody());
    }

    // Resource Owner Password Credentials Flow
    @TestVisible public String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token');

        String CLIENT_ID = 'xxxxxxxxxx';
        String CLIENT_SECRET = 'xxxxxxxxxx';
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
        system.debug(accessToken);
        return accessToken;
    }
}
