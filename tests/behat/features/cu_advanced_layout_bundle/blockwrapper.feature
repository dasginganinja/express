@AdvLayoutBundle @block-wrapper-block @javascript
Feature: the Block Wrapper Block
In order to place system blocks as beans
As an authenticated user
I should be able to access and use the Block Wrapper Block
  
@api 
Scenario Outline: An authenticated user should be able to access the form for adding a block wrapper block
    Given I am logged in as a user with the <role> role
    When I go to "block/add/block-wrapper"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create Block Wrapper block" |
    | site_owner      | "Create Block Wrapper block" |
    | administrator   | "Create Block Wrapper block" |
    | developer       | "Create Block Wrapper block" |

@api 
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/block-wrapper"
  Then I should see "Access denied"