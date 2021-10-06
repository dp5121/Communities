public class UserTriggerHandler {

    public static void updateCommunityContacts(Map<Id, User> oldUserMap, List<User> userList){
        
        Map<Id, Map<String, String>> contactIdWithAddress = new Map<Id, Map<String, String>>();
        List<Contact> updateContactList = new List<Contact>();
        
    	for (User u: userList){
            User uOld = (oldUserMap != null && oldUserMap.get(u.Id) != null) ? oldUserMap.get(u.Id) : null;
            
            if (uOld == null || (u.Address != uOld.Address)){
                
                Map<String, String> addressMap = new Map<String, String>();
                addressMap.put('Street', u.Street);
                addressMap.put('City', u.City);
                addressMap.put('State', u.State);
                addressMap.put('Country', u.Country);
                addressMap.put('PostalCode', u.PostalCode);
                
                contactIdWithAddress.put(u.ContactId , addressMap);
            }
    	}
        
        if (contactIdWithAddress.size() > 0){
            for (Id cId : contactIdWithAddress.keySet()){
                Contact c = new Contact(Id= cId);
                c.MailingStreet = contactIdWithAddress.get(cId).get('Street');
                c.MailingCity = contactIdWithAddress.get(cId).get('City');
                c.MailingState = contactIdWithAddress.get(cId).get('State');
                c.MailingCountry = contactIdWithAddress.get(cId).get('Country');
                c.MailingPostalCode = contactIdWithAddress.get(cId).get('PostalCode');
                
                updateContactList.add(c);
            }
            
            if (!updateContactList.isEmpty()){
                try{
                    update updateContactList;
                } catch(DMLException e){
                    system.debug('Error' + e.getMessage());
                }
            }
        }
    }
        
}