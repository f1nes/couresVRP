public class ProductListController {
   
    private String message{get;set;}
  
    public ProductListController (){
    	chkMsg();      
    }
    public static List<Product_Table__c> getProducts() {
        return [
            SELECT
                Id,
                Unit_Price__c,
                Image_url__c,
                Product_D__c,
                Warehouses__r.Name,
                Unit__c,
                Name
            FROM Product_Table__c
        ];
    }
    
    private void chkMsg(){
        this.message = ApexPages.CurrentPage().GetParameters().Get('message');
        if( this.message != null){
               ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, this.message)); 
        }  
    }
    
}