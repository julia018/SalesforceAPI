#Salesforce API
1. На 1м SF Org - Реализовать custom SOAP API:
Создать Custom objects:
 1. Sensor__c (fields: Name(text 80), Max_Vectors_Difference - Roll up summary , Account_Id__c Master-Detail (Account) ). 
 2. Sensor_Event_c (fields: Name- Autonumber, Previous_Event__c - Lookup(Sensor_Event__c), Modulus_difference_Vectors__c - Formula(Number =sqrt(x*x + y*y + z*z)), Sensor__c - Master Detail(Sensor__c), x - number, y - number, z - number)
 
 Разработать SOAP service на стороне Salesforce, который будет принимать данные вида {accountId: id, sensorid: id, line: [x1, y1, z1, x2, y2, z2, x3, .... xN, yN, zN]}
 Пример: {accountId: '001ABCDEFG00001', sensorid: '1', line: [22, 17, 197, 23, 45, 14, 22, 43, 196, 24, 42, 198]} 

2. На 2ом SF Org - Реализовать интеграцию с 1м оргом.
 a) Реализовать классы и методы, которые будут использовать REST API для работы с Custom Objects. Записи в базе должны создаваться в одном запросе. 
 b) Реализовать SOAP клиент, который будет делать запросы на 1й орг и сохранять данные в Custom Objects
 c) Написать тесты, которые будут проверять работу всей логики. 
 d) Для авторизации должен быть использован Connected APP.