public class ProductTriggerHandler {
    
    public static Org_Configuration__c period_Term { 
        get { 
            return Org_Configuration__c.getInstance(); 
        } 
        private set; 
    }
    
    public static void insertMethod (List<Product_Table__c> products) {
        for(Product_Table__c p : products) { 
            if (p.Added_Date__c == NULL) {
                p.Added_Date__c = Date.today();
            }
            List<Warehouse__c> defaultWarehouse = [
                SELECT Id 
                FROM Warehouse__c 
                WHERE  Period_Start__c <= : p.Added_Date__c
                AND  Period_End__c >= :p.Added_Date__c
                LIMIT 1
            ];
            
            IF (!defaultWarehouse.isEmpty()) {
                p.Warehouses__c = defaultWarehouse.get(0).id;
            } ELSE {
                Warehouse__c newWarehouse = new Warehouse__c ();
                newWarehouse.Period_Start__c = p.Added_Date__c;
                newWarehouse.Period_End__c   = p.Added_Date__c.addDays(period_Term.Period_Term__c.intValue()) ; 
                newWarehouse.Name = 'Warehouse '  + String.valueOf(newWarehouse.Period_Start__c) + '  ' + 
                String.valueOf(newWarehouse.Period_End__c); 
                insert newWarehouse;
                p.Warehouses__c = newWarehouse.id;
            } 
        }
    }
}