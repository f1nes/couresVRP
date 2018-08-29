public class ProductViewController {

    public String NameProd{get;set;}
    public Decimal AmountProd{get;set;}
    public String DescriptionProd{get;set;}
    public String ImageProd{get;set;}
    public String ProdId{get;set;}    

    public ProductViewController (){
        viewPage();  
    }
    
    private void viewPage(){
		this.ProdId= Apexpages.currentPage().getparameters().get('id');
        IF (this.ProdId != null){
        	Product_Table__c Prod = [SELECT Name, Image_URL__c, Product_D__c, Unit__c FROM Product_Table__c WHERE id=:this.ProdId ];
         	this.NameProd        = Prod.Name;
         	this.ImageProd       = Prod.Image_URL__c;
         	this.AmountProd      = Prod.Unit__c == null ?  0 :  Prod.Unit__c;
         	this.DescriptionProd = Prod.Product_D__c;
        }
    }
  
}