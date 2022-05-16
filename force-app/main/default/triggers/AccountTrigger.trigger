trigger AccountTrigger on Account (after insert) {
    // Check for the context variables which would tell us that 
    // code should run only for “After Insert”
    if(Trigger.isAfter && Trigger.isInsert) {
        // Declare a List of Contacts.
        List<Contact> contacts = new List<Contact>();
        
        // Loop for each account which was inserted.
        for(Account account : Trigger.new) {
            // Add the contact which needs to be inserted in the list of Contacts.
            Contact newContact = new Contact(LastName=account.Name+ 'Con', AccountId=account.Id);
            contacts.add(newContact);
        }
        // Now insert all the contacts together.
        insert contacts;
    }
}