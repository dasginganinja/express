Feature: Search Engine Optimization Bundle
  In order to optimize my site content for search engines
  Authenticated users with proper role
  I should be able access and edit SEO links and functionality
  
 Scenario: The Google Analytics Settings page has been installed
 Given I am logged is as a user with the "developer" role
 When I go to "admin/config/system/googleanalytics"
 Then I should see "General Settings"
 And I should see "Tracking scope"

Background: 
Given I am logged in as a user with the "site_owner" role

@api @seo
Scenario: The SEO tab should exist
When I go to "admin/dashboard"
Then I should see "User"
And I should see "SEO"
And I should see an "a" element with the "class" attribute set to "seo"

@api @seo
Scenario: The SEO Checklist should be populated with SEO functionality
When I go to "admin/dashboard/seo"
Then I should see "Google Analytics"
And I should see "Site Verification"
And I should see "Link Checker"
And I should see "Site Description"
And I should see "Responsive/Mobile Friendly"
And I should see "Content Updated"

@api @seo
Scenario: The SEO Link Checker should work
When I go to "admin/settings/seo/linkchecker-analyze"
And I press "edit-linkchecker-analyze"
# Then I should see DON'T KNOW; BROKEN ON ALL SITES RIGHT NOW; DEF SHOULD NOT SEE THE FOLLOWING:
Then I should not see "unexpected error"

@api @seo
Scenario: A Google Analytics number can be added to site
When I go to "admin/settings/site-configuration/google-analytics"
And I fill in "edit-ga-account" with "UA-654321-1"
And I press "edit-submit"
Then I should see "The configuration options have been saved"
And the "edit-ga-account" field should contain "UA-654321-1"

@api @seo
Scenario: Adding text to site description populates Meta tag "Description" on site homepage
When I go to "admin/settings/site-configuration/site-description"
When I fill in "edit-site-description" with "My Amazing Site Description"
And I press "edit-submit"
And I go to "/"
Then the response should contain "content=\"My Amazing Site Description\""

@api @seo @broken
Scenario: The Meta Tags page functionality has been added to Basic Page
When I go to "/"
And I follow "Edit"
Then I should see an "edit-metatags" element
And I should see an "#edit-metatags" element
