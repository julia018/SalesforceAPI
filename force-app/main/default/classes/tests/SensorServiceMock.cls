
public with sharing class SensorServiceMock implements WebServiceMock{
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
        
        soapSforceComSchemasClassSensorserv.addDataResponse_element response_x = new soapSforceComSchemasClassSensorserv.addDataResponse_element();
        response_x.result = true;
        response.put('response_x', response_x);     
    }
}
