@cu_permissions @rebuild
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

#NOTE THE FOLLOWING ARE ADMITTEDLY RATHER RANDOM TESTS FOR ADMIN ACCESS   
@api 
Scenario Outline: Most users should not be able to access Admin pages
    Given I am logged in as a user with the <role> role
    When I am on <adminUrl>
    Then I should see "Access denied"
    
    Examples:
      | role            | adminUrl                            |
      | administrator   | admin/config/blocks                 | 
      | site_owner      | admin/config/people/ldap            |
      | content_editor  | admin/config/user-interface/bigmenu | 
      | edit_my_content | admin/config/development/logging    |



