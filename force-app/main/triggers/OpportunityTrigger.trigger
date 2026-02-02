 /*
    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.
    */

trigger OpportunityTrigger on Opportunity (before update) {

    if(Trigger.isBefore && Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new) {
            if (opp.Amount <= 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    }

/*
     * Question 6
	 * Opportunity Trigger
	 * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	 * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
	 * Trigger should only fire on delete.
	 */

     if (Trigger.isBefore && Trigger.isDelete) {
        List<Id> oppIds = new List<Id>();
        for (Opportunity opp : Trigger.old) {
            oppIds.add(opp.Id);
        }
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
            [SELECT Id, StageName, AccountId, Account.Industry FROM Opportunity WHERE Id IN :oppIds]
        );
        
        for (Opportunity opp : Trigger.old) {
            Opportunity fullOpp = oppMap.get(opp.Id);
            if (fullOpp.StageName == 'Closed Won' && fullOpp.Account.Industry == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        for (Opportunity opp : Trigger.new) {
            if (opp.Amount <= 5000) {
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    }

     /*
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
    */
    if(Trigger.isBefore && Trigger.isUpdate) {
        Set<Id> accountIds = new Set<Id> (); 
    for (Opportunity opp : Trigger.new) { 
        accountIds.add(opp.AccountId);
    }    
    
    Map<Id, Contact> ceoContactMap = new Map<Id, Contact>();
    for (Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountId IN : accountIds AND Title = 'CEO']) {
        ceoContactMap.put(con.AccountId, con);
    }
    
    for (Opportunity opp : Trigger.new) {
        Contact ceoCon = ceoContactMap.get(opp.AccountId); 
        if (ceoCon != null) { 
            opp.Primary_Contact__c = ceoCon.Id;
        }      
    }
    }
}