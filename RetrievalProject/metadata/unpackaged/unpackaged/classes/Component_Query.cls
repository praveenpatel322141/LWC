@isTest
global with sharing class Component_Query {
    global String queryString {get; set;}
    global List<sObject> results {get{
        List<sObject> result = Database.Query(queryString);
        return result;
    } set; }
      
    private static testmethod void contactTest(){
        Contact c = new Contact(lastName = 'apex test contact');
        insert c;
        Test.startTest();
        Component_Query component = new Component_Query();
        component.queryString = 'SELECT id, name FROM Contact WHERE Id = \''+c.id+'\'';
        List<sObject> result = component.results;
        
        System.assertEquals(1,result.size(),'Expected a single contact record');
        System.assertEquals('apex test contact',(String)result.get(0).get('name') );
    }
}