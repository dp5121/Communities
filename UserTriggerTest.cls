@isTest
public class UserTriggerTest {
    
       
    @TestSetUp
    public static void dataSetUp(){
        
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'CEO' Limit 1];

        User adminUser = [Select Id, UserRoleId From User Where Profile.Name='System Administrator' Limit 1];
        
        adminUser.UserRoleId = userRole.Id;
        update adminUser;
        
        Account acc = new Account(name = 'Community');
        insert acc;
        
        Contact c = new Contact(AccountId = acc.Id, FirstName = 'test', lastName = 'Contact');
        insert c;
        
        Id communityProfileId = [SELECT Id FROM Profile WHERE Name like 'Customer Community%' LIMIT 1].Id;
        String randomNumString = String.valueOf(Math.random() * 10000);
        
        System.runAs(adminUser){
            User comUser = new User();
            comUser.LastName = 'Testing';
            comUser.Alias = 'Testing';
            comUser.Email = 'communityUser@test.com';
            comUser.Username = randomNumString + '@test' + randomNumString + '.com';
            comUser.CommunityNickname = comUser.LastName + randomNumString;
            comUser.EmailEncodingKey = 'UTF-8';
            comUser.ProfileId = communityProfileId;
            comUser.LanguageLocaleKey = 'en_US';
            comUser.TimeZoneSidKey = 'America/Phoenix';
            comUser.LocaleSidKey = 'en_US';
            comUser.PortalRole = 'Manager';
    
            if (c.Id != null) {
                comUser.ContactId = c.Id;
            }
        
            insert comUser;
        }
        
    }
    @isTest
	public static void validate_updateCommunityContacts(){
        Test.startTest();
        User communityUser = [select Id, ContactId from User where Email = 'communityUser@test.com'];
        communityUser.Street = '1002 Maple Street';
        communityUser.City = 'New York';
        communityUser.State = 'New York';
        communityUser.Country = 'USA';
        communityUser.PostalCode = '1016';
        
        update communityUser;
        
        Test.stopTest();
        Contact updatedContact = [select Id, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode
                                 from Contact where Id =: communityUser.ContactId];
        
        system.assertEquals(communityUser.Street, updatedContact.MailingStreet);
    }
}
