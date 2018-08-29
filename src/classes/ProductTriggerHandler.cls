public class ProductTriggerHandler {
    public static Org_Configuration__c period_Term { 
        get { 
            return Org_Configuration__c.getInstance(); 
        } 
        private set; 
    }
    
    public static void insertMethod (List<Product_Table__c> products) {
        List<Warehouse__c> defaultWarehouses = listWarehouses();
        List<Warehouse__c> newWarehouses = new List<Warehouse__c>() ;
        for(Product_Table__c p : products) { 
            if (p.Added_Date__c == NULL) {
                p.Added_Date__c = Date.today();
            }
	        if (!checkDatePeriod(defaultWarehouses,p.Added_Date__c)){
				defaultWarehouses.add(new Warehouse__c(Period_Start__c = p.Added_Date__c,
                Period_End__c   = p.Added_Date__c.addDays(period_Term.Period_Term__c.intValue())));
                newWarehouses.add(new Warehouse__c(Period_Start__c = p.Added_Date__c,
                Period_End__c   = p.Added_Date__c.addDays(period_Term.Period_Term__c.intValue()) , 
                Name = 'Warehouse '  + String.valueOf( p.Added_Date__c) + '  ' +  String.valueOf(p.Added_Date__c.addDays(period_Term.Period_Term__c.intValue()))));
            }
       }
        
        insert newWarehouses;
       	List<Warehouse__c> defaultWarehouseNew = listWarehouses();
         for(Product_Table__c p : products) { 
           for (Warehouse__c dw : defaultWarehouseNew){
                if (dw.Period_Start__c <= p.Added_Date__c && dw.Period_End__c >=  p.Added_Date__c ){
                	 p.Warehouses__c = dw.id;
                } 
            }
       	}
    }
       
    private static Boolean checkDatePeriod(List<Warehouse__c> defaultWarehouses , Date dt){
		for (Warehouse__c dw : defaultWarehouses){
        	if (dw.Period_Start__c <= dt && dw.Period_End__c >= dt ){
            	return true;
            } 
		}
        return false;
	}
    private static List<Warehouse__c> listWarehouses (){
      
       List<Warehouse__c> defaultWarehouse = [
        	SELECT Id, Period_Start__c, Period_End__c
            FROM Warehouse__c 
      	]; 
        return defaultWarehouse;
        
    }
}