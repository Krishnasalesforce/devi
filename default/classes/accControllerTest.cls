@isTest 
private class accControllerTest {
    static testMethod void accountController() {
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        accController accountController = new accController();
    }
}