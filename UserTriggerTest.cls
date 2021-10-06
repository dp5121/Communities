@isTest
public class UserTriggerTest {
    
    public static Id communityProfileId;
    
    @TestSetUp
    public static void dataSetUp(){
        
        Contact c = new Contact(FirstName = 'test', lastName = 'Contact');
        insert c;
        
        communityProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User'].Id;
        String randomNumString = String.valueOf(Math.random() * 10000);
    
        User comUser = new User();
        comUser.LastName = 'Testing';
        comUser.Alias = 'Testing';
        comUser.Email = 'testing@test.com';
        comUser.Username = randomNumString + '@test' + randomNumString + '.com';
        comUser.CommunityNickname = comUser.LastName + randomNumString;
        comUser.EmailEncodingKey = 'UTF-8';
        comUser.ProfileId = communityProfileId;
        comUser.LanguageLocaleKey = 'en_US';
        comUser.TimeZoneSidKey = 'America/Phoenix';
        comUser.LocaleSidKey = 'en_US';

        if (c.Id != null) {
            comUser.ContactId = c.Id;
        }
    
        insert comUser;
        
    }
    @isTest
	public static void validate_updateCommunityContacts(){
        User communityUser = [select Id, ContactId from User where ProfileId =: communityProfileId];
        communityUser.Street = '1002 Maple Street';
        communityUser.City = 'New York';
        communityUser.State = 'New York';
        communityUser.Country = 'USA';
        communityUser.PostalCode = '1016';
        
        update communityUser;
        
        Contact updatedContact = [select Id, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode
                                 from Contact where Id =: communityUser.ContactId];
        
        system.assertEquals(communityUser.Street, updatedContact.MailingStreet);
    }
}