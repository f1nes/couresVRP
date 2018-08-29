@isTest
public class ApexTestControllers {
    @testSetup
    public static void setup() {
       
		insert new Org_Configuration__c(period_Term__c = 5);

    	List<Product_Table__c> productTable = new List<Product_Table__c>();
        for(Integer i=0;i<10;i++) {
     		productTable.add(new Product_Table__c(Name = 'product name ' + i,Unit__c = i,Unit_price__c= i + 5,Product_D__c = 'test product' + i));
        }
        insert productTable;        
  		
        List<Contact> contact = new List<Contact>();
        for(Integer i=0;i<5;i++) {
            contact.add(new Contact(FirstName = 'firstName' + i,LastName = 'lastName' + i,Email = 'email' + i + '@email.ru'));
        }
        insert contact;        
 
    }
    
	@isTest
    public static void testProductListController(){
        PageReference pageRef = Page.Product_List;
        pageRef.getParameters().put('message','message');
        test.setCurrentPageReference(pageRef);
        ProductListController ListController = new ProductListController();
        List<Product_Table__c> products = ProductListController.getProducts();
    }

    @isTest
    public static void testProductViewController(){
        Product_Table__c  product_Table = [SELECT Id FROM Product_Table__c LIMIT 1];
        PageReference pageRef = Page.Product_List;
        pageRef.getParameters().put('id',product_Table.id);
        test.setCurrentPageReference(pageRef);
        ProductViewController ViewController = new ProductViewController();
    }
    
    @isTest
    public static void testProductBuyController(){
        Contact  contact = [SELECT id,firstName, lastName, email FROM Contact LIMIT 1];
	    testAddBuy(4,contact.email,contact.firstName,contact.lastName, 1);
        testAddBuy(4,contact.email,'firstName99','lastName99', 1);
        testAddBuy(2,'','','', 1); 
        testAddBuy(2,contact.email,'','', 1);
		testAddBuy(2,'email11-email.ru','','', 1);
        testAddBuy(2,contact.email,contact.firstName,'', 1);
        testAddBuy(0,contact.email,contact.firstName,contact.lastName, 0);
        testAddBuy(0,contact.email,contact.firstName,contact.lastName, 3);
        testAddBuy(4,'email11@email.ru',contact.firstName,contact.lastName, 1);
    }
    
	private static void testAddBuy(Integer unit, String email, String firstName, String lastName, Decimal amountProd ) {
    	Product_Table__c product_Table = [SELECT Id FROM Product_Table__c WHERE Unit__c >=: unit LIMIT 1];
        PageReference pageRef = Page.Product_List;
        pageRef.getParameters().put('id',product_Table.id);
        test.setCurrentPageReference(pageRef);
        ProductBuyController buyController = new ProductBuyController();
        buyController.email = email;
        buyController.getNameContact();
        buyController.firstName = firstName;
        buyController.lastName = lastName;
        buyController.amountProd = amountProd;
        buyController.saveInfoBuy();
    }    
}