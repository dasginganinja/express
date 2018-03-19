@cu_permissions @newtest
Feature: Admin functionality is hidden from most users
When I go to the many admin pages
As an authenticated user
I should see Access denied

@api 
Scenario: A developer should be able to access certain admin settings
    Given I am logged in as a user with the developer role
    When I am on "admin/index"
    Then I should see "jQuery Update"
    And I should see "Express Layout Settings"

@api 
Scenario Outline: Most users should not be able to access admin/index
    Given I am logged in as a user with the <role> role
    When I am on "admin/index"
    Then I should not see "jQuery Update"
    And I should not see "Express Layout Settings"
 
 Examples:
    | role |
    | administrator |
    | site_owner |
    | content_editor |
    | edit_my_content |

#NOTE THE FOLLOWING IS ADMITTEDLY A RATHER RANDOM TEST FOR ADMIN ACCESS   
@api
Scenario Outline: Most users should not be able to access Admin pages
    Given I am logged in as a user with the <role> role
    When I am on "admin/config/people/ldap"
    Then I should see <message>
    
    Examples:
      | role            | message              |
      | developer       | "LDAP Configuration" |
      | administrator   | "Access denied"      |
      | site_owner      | "Access denied"      |
      | content_editor  | "Access denied"      |
      | edit_my_content | "Access denied"      |
