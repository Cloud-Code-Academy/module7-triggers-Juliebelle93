 /*
    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.
    */

trigger OpportunityTrigger on Opportunity (before update, before delete) {

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

     if(Trigger.isBefore && Trigger.isDelete) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : Trigger.old){
            accountIds.add(opp.AccountId);
        }
     Map<Id, Account> accountMap = new Map<Id, Account> (
            [SELECT Id, Industry FROM Account Where Id IN :accountIds]
        );

        for (Opportunity opp : Trigger.Old) {
            Account acc = accountMap.get(opp.AccountId);
            if (opp.StageName == 'Closed Won' &&  acc.Industry == 'Banking') {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
     
    }
}
     