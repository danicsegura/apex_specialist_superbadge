public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> triggerNew) {       
        Map<Id, Case> mapClosedCases = new Map<Id, Case>();
        Map<String, Id> mapClosedSubjectToCase = new Map<String, Id>();
        List<Case> lstCasesToInsert = new List<Case>();
        List<Equipment_Maintenance_Item__c> lstEquipItemToInsert = new List<Equipment_Maintenance_Item__c>();
        Map<Id, Id> mapClosedCaseToNewCase = new Map<Id, Id>();
        
        for(Case varCase : triggerNew){
            if(varCase.Status == 'Closed' && (varCase.Type == 'Repair' || varCase.Type == 'Routine Maintenance')){
				mapClosedCases.put(varCase.Id, varCase);
			}  
        }

        for(Id caseId : mapClosedCases.keySet()){
            mapClosedSubjectToCase.put(mapClosedCases.get(caseId).Subject, mapClosedCases.get(caseId).Id);
        }
        
        List<Equipment_Maintenance_Item__c> lstEquipMainItem = [SELECT Id, Equipment__c, Maintenance_Request__c, Quantity__c
            													FROM Equipment_Maintenance_Item__c 
                                                                WHERE Maintenance_Request__c IN : mapClosedCases.keySet()];
        
        for(Id caseId : mapClosedCases.keySet()){
            Case newCase = new Case();
            newCase.Vehicle__c = mapClosedCases.get(caseId).Vehicle__c;
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = mapClosedCases.get(caseId).Subject;
            newCase.Date_Reported__c = System.today();
            lstCasesToInsert.add(newCase);
		}

        insert lstCasesToInsert;

        for(Case varCase : lstCasesToInsert){
            if(mapClosedSubjectToCase.containsKey(varCase.Subject)){
                mapClosedCaseToNewCase.put(mapClosedSubjectToCase.get(varCase.Subject), varCase.Id);
            }
        }

        for(Equipment_Maintenance_Item__c varEquipItem : lstEquipMainItem){
            if(mapClosedCaseToNewCase.containsKey(varEquipItem.Maintenance_Request__c)){
                //criar novos Equipment_Maintenance_Item__c
                //add na lista lstEquipItemToInsert
            }
        }

    }        
    
}