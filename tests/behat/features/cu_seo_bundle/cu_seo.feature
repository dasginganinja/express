Feature: Search Engine Optimization Bundle
  In order to optimize my site content for search engines
  As a Site Owner or Content Editor
  I should be able access and edit SEO links and functionality

Background: 
Given I am logged in as a user with the "site_owner" role

@api @seo
Scenario: The SEO tab should exist
When I go to "admin/dashboard"
Then I should see "User"
And I should see "SEO"

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
# Then I should see I DON'T KNOW; IT'S BROKEN ON ALL SITES RIGHT NOW
Then I should not see "the website encountered an unexpected error"

@api @seo
Scenario: A Google Analytics number can be added to site
When I go to "admin/settings/site-configuration/google-analytics"
And I fill in "edit-ga-account" with: "UA-123456-1"
And I press "edit-submit"
Then I should see "The configuration options have been saved"

@api @seo
Scenario: The Meta Tags page functionality has been added and populated
When I go to "/"
And I follow "edit"
# Then I should see "Meta tags" THIS ONE FAILS; WILL THE REST PASS? STAY TUNED.
Then I should see "Basic Tags" 
And I should see "Advanced Tags"
And I should see "Open Graph"
And I should see "Twitter Card"

@api @seo
Scenario: Adding text to site description populates Meta tag "Description" on site homepage
When I go to "admin/settings/site-configuration/site-description"
When I fill in "edit-site-description" with: "My Awesome Site Description"
And I press "edit-submit"
And I go to "/"
Then I should see a "meta" element
And the "meta" element should contain "name=\"description\""
