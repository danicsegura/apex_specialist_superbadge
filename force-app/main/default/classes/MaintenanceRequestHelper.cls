public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> triggerNew) {       
        Map<Id, Case> mapClosedCases = new Map<Id, Case>();
        Map<Id, List<Id>> mapMaintenanceToEquipments = new Map<Id, List<Id>>();
        Map<Id, Integer> mapMaintenanceToCycle = new Map<Id, Integer>();
        List<Id> lstEquipmentsIds = new List<Id>();
        
        for(Case varCase : triggerNew){
            if(varCase.Status == 'Closed' && (varCase.Type == 'Repair' || varCase.Type == 'Routine Maintenance')){
				mapClosedCases.put(varCase.Id, varCase);
			}  
        }
        
        List<Equipment_Maintenance_Item__c> lstEquipMainItem = [SELECT Id, Equipment__c, Maintenance_Request__c, Quantity__c
            													FROM Equipment_Maintenance_Item__c 
                                                                WHERE Maintenance_Request__c IN : mapClosedCases.keySet()];
        
        for(Equipment_Maintenance_Item__c varEquipItem : lstEquipMainItem){
            if(mapMaintenanceToEquipments.containsKey(varEquipItem.Maintenance_Request__c)){
				lstEquipmentsIds.add(varEquipItem.Equipment__c);                
            }else{
            	mapMaintenanceToEquipments.put(varEquipItem.Maintenance_Request__c, lstEquipmentsIds); 
            }
        }
        
        for(Id caseId : mapClosedCases.keySet()){
            Case newCase = new Case();
            newCase.Vehicle__c = mapClosedCases.get(caseId).Vehicle__c;
            newCase.Type = 'Routine Maintenance';
            newCase.Subject = 'Routine Checkup';
            newCase.Date_Reported__c = System.today();
		}
    }        
    
}