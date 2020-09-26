global class SensorService {

    global SensorService() {

    }
    
    webservice static Boolean addData(Id accountId, Integer sensorId, List<Integer> line) {
        if ((Math.mod(line.size(), 3)) != 0) {
            System.debug('Vector is defined by point with 3 coordinates. Please, provide valid amount of coordinates.');
            return false;
        }

        if (!checkAccountPresence(accountId)) {
            System.debug('Account with such Id doesnt exist.');
            return false;
        }

        Sensor__c sensor = getSensorByExternalId(sensorId);

        if(sensor == null) {
            //create sensor 
            sensor = createSensor(sensorId, accountId);
        }

        Sensor_Event__c prevEvent = findPrevEvent(sensor);

        Integer vectorCount = line.size() / 3;

        List<Sensor_Event__c> eventList = new List<Sensor_Event__c>();
        for (Integer i = 0; i < vectorCount; i++) {
            Sensor_Event__c newEvent = createSensorEvent(sensor, line[i * 3], line[i * 3 + 1], line[i * 3 + 2]);
            eventList.add(newEvent);
        }
        insert eventList;

        for (Integer i = 0; i < eventList.size(); i++) {
            eventList.get(i).Previous_Event__c = (prevEvent != null ? prevEvent.Id : null);
            prevEvent = eventList.get(i);
        }

        upsert eventList;

        return true;
        
    }

    private static Sensor_Event__c createSensorEvent(Sensor__c sensor, Integer x, Integer y, Integer z) {
        Sensor_Event__c newEvent = new Sensor_Event__c(Sensor__c = sensor.Id, x__c = x, y__c = y, z__c = z);
        return newEvent;
    }

    private static Sensor_Event__c findPrevEvent(Sensor__c sensor) {
        List<Sensor_Event__c> sensorEvents = getEventsBySensor(sensor);
        Sensor_Event__c lastEvent = getLastEvent(sensorEvents);
        return lastEvent;
    }

    private static Sensor__c createSensor(Integer externalId, Id accountId) {
        Sensor__c newSensor = new Sensor__c(Name = 'Sensor' + externalId, Account_Id__c = accountId, externalId__c = externalId);
        insert newSensor;
        return newSensor;
    }
    

    private static boolean checkAccountPresence(Id accountId) {
        Account acc = [SELECT Id FROM Account WHERE Id =: accountId];
        if (acc != null) {
            return true;
        }
        return false;
    }

    private static Sensor__c getSensorByExternalId(Decimal externalId) {
        List<Sensor__c> result = [SELECT Id, Name FROM Sensor__c WHERE externalId__c =: externalId];
        if(result.size() == 0) {
            return null;
        }
        return result.get(0);
    }

    private static List<Sensor_Event__c> getEventsBySensor(Sensor__c sensor) {
        return [SELECT Id, Name, Sensor__c FROM Sensor_Event__c WHERE Sensor__c =: sensor.Id];
    }

    private static Sensor_Event__c getLastEvent(List<Sensor_Event__c> events) {
        String lastNumber = '-1';
        Sensor_Event__c lastEvent = null;
        if(events == null) {
            return lastEvent;
        }
        for(Sensor_Event__c event: events) {
            if(event.Name > lastNumber) {
                lastNumber = event.Name;
                lastEvent = event;
            }
        }
        return lastEvent;
    }

    private static Double countVectorModulus(Double x, Double y, Double z) {
        return Math.sqrt(x * x + y * y + z * z);
    }


}
