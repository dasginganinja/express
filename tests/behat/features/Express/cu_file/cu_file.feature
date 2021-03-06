@file
Feature: File Content Type
When I login to a Web Express website
As an authenticated user
I should be able to create, edit, and delete File content

Scenario Outline: An authenticated user can access the form for adding a file
  Given  I am logged in as a user with the <role> role
  When I go to "node/add/file"
  Then I should see <message>

    Examples:
      | role            | message         |
      | edit_my_content | "Access denied" |
      | content_editor  | "Create File"   |
      | site_owner      | "Create File"   |
      | administrator   | "Create File"   |
      | developer       | "Create File"   |

Scenario: An anonymous user should not be able to access the form for adding a file
    When I am on "node/add/file"
    Then I should see "Access denied"

 Scenario: An authenticated user can upload a file; with secure https URL
    Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/file"
    And I fill in "edit-title" with "My Ralphie Photo"
    And I fill in "edit-body-und-0-value" with "A photo of Ralphie and handlers"
    And I attach the file "ralphie.jpg" to "edit-field-file-attachment-und-0-upload"
    And I press "Upload"
    # And I wait for AJAX
    Then I should see "File Information"
    And I should see "Operations"
    And I press "edit-submit"
    Then I should see "A user without editing permissions would have been redirected"
    Then I should see "My Ralphie Photo"
    And I should see "Access the top file listed below with the following url"
    And I should not see "http://www.colorado.edu"
    
Scenario: An authenticated user can delete a File Content Type node
    Given I am logged in as a user with the "site_owner" role
    When I go to "node/add/file"
    And I fill in "edit-title" with "Test Page"
    And I fill in "edit-body-und-0-value" with "File For Deleting"
    And I attach the file "ralphie.jpg" to "edit-field-file-attachment-und-0-upload"
    And I press "edit-submit"
     And I follow "Edit"
    And I press "Delete"
    Then I should see "Are you sure you want to delete Test Page?"
    And I press "Delete"
    Then I am on "/"
    
Scenario: The File Content Type verifies that a file has been uploaded
    Given I am logged in as a user with the "content_editor" role
    When I go to "node/add/file"
      And I fill in "edit-title" with "Test Page"
      And I fill in "body[und][0][value]" with "Do not keep this page"
      And I press "Save"
    Then I should see "File Attachment field is required."
    
