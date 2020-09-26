@isTest
public with sharing class SensorClientTest {
    @isTest static void makeSoapRequestTest() {  
        Test.startTest();       
        Test.setMock(WebServiceMock.class, new SensorServiceMock());
        SensorClient sc = new SensorClient();
        List<Integer> points = new List<Integer>();
        points.add(1);
        points.add(2);
        points.add(4);
        
        Boolean res = sc.makeSoapRequest('0012w00000I5UffAAF', 1, points);
        Test.stopTest();
        // Verify that a fake result is returned
        System.assertEquals(true, res); 
        
    }
}
