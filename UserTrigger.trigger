trigger UserTrigger on User (before insert, before update) {
    
    Set<Id> communityProfileIds = new Set<Id>();
    List<User> communityUserList = new List<User>();
    List<Profile> communityProfiles = [select Id from Profile where Name like 'Customer Community%'];
    
    if (communityProfiles.size() > 0 ){
        for (Profile p : communityProfiles){
            communityProfileIds.add(p.Id);
        }
    }
    
    for (User u: Trigger.New){
        
        //Community Users
        if (communityProfileIds != null && communityProfileIds.contains(u.ProfileId)){
           communityUserList.add(u);
        }
    }
    
    if (!communityUserList.isEmpty()){
         UserTriggerHandler.updateCommunityContacts(Trigger.OldMap, communityUserList);
    }

}