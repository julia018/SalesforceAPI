public with sharing class SensorRESTClient {
    public SensorRESTClient() {

    }

    public void makeRestCallout() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://ap16.salesforce.com/services/Soap/class/SensorService');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        request.setHeader('SOAPAction', '""');
        String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sen="http://soap.sforce.com/schemas/class/SensorService">' +
   '<soapenv:Header><sen:AllowFieldTruncationHeader><sen:allowFieldTruncation>true</sen:allowFieldTruncation>' +
      '</sen:AllowFieldTruncationHeader><sen:CallOptions><sen:client>true</sen:client></sen:CallOptions><sen:SessionHeader><sen:sessionId>';
        String token = getAccessToken();
        body += token + '</sen:sessionId>';
        body += '</sen:SessionHeader></soapenv:Header><soapenv:Body>' +
           '<sen:addData><sen:accountId>0012w00000I5UffAAF</sen:accountId><sen:sensorId>1</sen:sensorId>'+
           '<sen:line>1, 2, 3</sen:line>1</sen:addData></soapenv:Body></soapenv:Envelope>';
        
        String body1 = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sen="http://soap.sforce.com/schemas/class/SensorService"><soapenv:Header><sen:AllowFieldTruncationHeader><sen:allowFieldTruncation>true</sen:allowFieldTruncation></sen:AllowFieldTruncationHeader><sen:DebuggingHeader></sen:DebuggingHeader><sen:CallOptions><sen:client>true</sen:client></sen:CallOptions><sen:SessionHeader><sen:sessionId>' + token + '</sen:sessionId></sen:SessionHeader></soapenv:Header><soapenv:Body><sen:addData><sen:accountId>0012w00000I5UffAAF</sen:accountId><sen:sensorId>1</sen:sensorId><sen:line>2</sen:line><sen:line>1</sen:line><sen:line>4</sen:line></sen:addData></soapenv:Body></soapenv:Envelope>';
        request.setBody(body1);
        HttpResponse responce = Http.send(request);
        system.debug(responce);
        system.debug(responce.getBody());
    }

    public void makeRestCalloutNew() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://ap16.salesforce.com/services/Soap/class/SensorService');
        request.setMethod('POST');
        request.setHeader('Action', '');
        request.setHeader('Authorization', 'Bearer ' + '00D2w000008p1tV!AQcAQECE1sZdIPPe3rctLF9iI1hEMjlvsSGj8aZL2IkEj_gxx3m7kRdU1hsMu3_ShOdKE1QIKm6c2xXfQ6ZJE5_ViWVGi03k');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"accountId": "0012w00000I5UffAAF", "sensorId":"1", "line":{1,2,3}}');
        HttpResponse response = http.send(request);
        system.debug(response);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
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
        system.debug(accessToken);
        return accessToken;
    }
}
