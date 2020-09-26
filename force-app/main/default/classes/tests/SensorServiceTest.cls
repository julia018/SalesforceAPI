@isTest
public with sharing class SensorServiceTest {

    @TestSetup
    static void makeData(){
        // insert account
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
    }
    
    @isTest
    static void addDataNewSensorEventsInsertedPositiveTest() {
        Account testAcc = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount'];
        Id testAccId = testAcc.Id;
        List<Integer> points = new List<Integer>();
        points.add(1);
        points.add(2);
        points.add(1);
        Test.startTest();
        Boolean res = SensorService.addData(testAccId, 1, points);
        System.assertEquals(true, res);
        Sensor__c newSensor = [SELECT Id, Account_Id__c, externalId__c, Max_Vectors_Difference__c FROM Sensor__c WHERE Account_Id__c =: testAccId and externalId__c = 1];
        List<Sensor_Event__c> events = [SELECT Id, Sensor__c FROM Sensor_Event__c WHERE Sensor__r.externalId__c = 1 and Sensor__r.Account_Id__c =: testAccId];
        System.assertEquals(1, events.size());        
        Test.stopTest();        
    }

    @isTest
    static void addDataNewSensorEventsInsertedNegativeTest() {
        Account testAcc = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount'];
        Id testAccId = testAcc.Id;
        List<Integer> points = new List<Integer>();
        points.add(1);
        points.add(2);
        points.add(1);
        points.add(4);
        Test.startTest();
        Boolean res = SensorService.addData(testAccId, 1, points);
        System.assertEquals(false, res);      
        Test.stopTest();        
    }

    @isTest
    static void addDataNewSensorExternalIdPositiveTest() {
        Account testAcc = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount'];
        Id testAccId = testAcc.Id;
        List<Integer> points = new List<Integer>();
        points.add(1);
        points.add(2);
        points.add(1);
        Test.startTest();
        Boolean res = SensorService.addData(testAccId, 18, points);
        System.assertEquals(true, res);
        Sensor__c newSensor = [SELECT Id, Account_Id__c, externalId__c, Max_Vectors_Difference__c FROM Sensor__c WHERE Account_Id__c =: testAccId and externalId__c = 18];
        System.assertNotEquals(null, newSensor);       
        Test.stopTest();        
    }


    @isTest
    static void addDataNewSensorPrevEventPositiveTest() {
        Account testAcc = [SELECT Id, Name FROM Account WHERE Name = 'TestAccount'];
        Id testAccId = testAcc.Id;
        // data for 1st event
        List<Integer> points = new List<Integer>();
        points.add(1);
        points.add(2);
        points.add(1);
        // data for 2nd event
        List<Integer> points2 = new List<Integer>();
        points2.add(1);
        points2.add(0);
        points2.add(5);

        Test.startTest();
        Boolean res = SensorService.addData(testAccId, 5, points);
        System.assertEquals(true, res);
        Sensor__c newSensor = [SELECT Id, Account_Id__c, externalId__c, Max_Vectors_Difference__c FROM Sensor__c WHERE Account_Id__c =: testAccId and externalId__c = 5];
        System.assertNotEquals(null, newSensor);
        List<Sensor_Event__c> events = [SELECT Id, Sensor__c, Previous_Event__c FROM Sensor_Event__c WHERE Sensor__r.externalId__c = 5 and Sensor__r.Account_Id__c =: testAccId];
        System.assertEquals(1, events.size()); 
        Sensor_Event__c firstSensorEvent = events.get(0);         
        System.assertEquals(null, firstSensorEvent.Previous_Event__c); 
        
        Boolean res2 = SensorService.addData(testAccId, 5, points2);
        System.assertEquals(true, res2);
        List<Sensor_Event__c> events2 = [SELECT Id, Sensor__c, Previous_Event__c FROM Sensor_Event__c WHERE Sensor__r.externalId__c = 5 and Sensor__r.Account_Id__c =: testAccId ORDER BY Name];
        System.assertEquals(2, events2.size()); 
        System.assertEquals(events2.get(1).Previous_Event__c, firstSensorEvent.Id);      

        Test.stopTest();        
    }

}
