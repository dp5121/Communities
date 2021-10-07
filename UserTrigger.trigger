trigger UserTrigger on User (after insert, after update) {
    
    Set<Id> communityProfileIds = new Set<Id>();
    Set<Id> communityUserIds = new Set<Id>();
    List<Profile> communityProfiles = [select Id from Profile where Name like 'Customer Community%'];
    
    if (communityProfiles.size() > 0 ){
        for (Profile p : communityProfiles){
            communityProfileIds.add(p.Id);
        }
    }
    
    for (User u: Trigger.New){
        
        User uOld = (Trigger.oldMap != null && Trigger.oldMap.get(u.Id) != null) ? Trigger.oldMap.get(u.Id) : null;
        
        //Community Users
        if (communityProfileIds != null && communityProfileIds.contains(u.ProfileId)){
            if (uOld == null || (u.Street != uOld.Street || u.City != uOld.City || u.Country != uOld.Country || 
                                 u.State != uOld.State || u.PostalCode != uOld.PostalCode)){
                  communityUserIds.add(u.Id);                   
            }
           
        }
    }
    
    
    if (communityUserIds != null){
         UserTriggerHandler.updateCommunityContacts(communityUserIds);
    }

}
