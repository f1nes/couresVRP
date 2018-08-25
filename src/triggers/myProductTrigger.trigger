trigger myProductTrigger on Product_Table__c (before insert) {
 	if (Trigger.isInsert) {
	    ProductTriggerHandler.insertMethod(Trigger.new);
    }
}