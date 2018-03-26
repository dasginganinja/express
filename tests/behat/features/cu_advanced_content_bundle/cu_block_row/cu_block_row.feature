@AdvContentBundle
Feature: Block Row Block

Feature: the Block Row Block
In order to placed blocks side by side
As an authenticated user
I should be able to access and use the Block Row Block
  

@api @block-row-block
Scenario Outline: An authenticated user should be able to access the form for adding a block row block
    Given  I am logged in as a user with the <role> role
    When I go to "block/add/block-row"
    Then I should see <message>

    Examples:
    | role            | message         |
    | edit_my_content | "Access denied" |
    | content_editor  | "Create Block Row block" |
    | site_owner      | "Create Block Row block" |
    | administrator   | "Create Block Row block" |
    | developer       | "Create Block Row block" |

@api @block-row-block
Scenario: An anonymous user should not be able to access the form
  Given I go to "block/add/block-row"
  Then I should see "Access denied"

# CREATE TWO TEXT BLOCKS, PLACE WITH BLOCK ROW
@api
Scenario: All blocks have the same height when "Match Heights" checkbox is checked
Given: I am logged in as a user with the "site_owner" role
When I go to "block/add/block"
 And fill in "edit-label" with "Block Row Text One"
 And fill in "edit-title" with "Block Row Text One"
 And I fill in "edit-field-block-text-und-0-value" with "Cupcake ipsum dolor sit amet ice cream cake carrot cake carrot cake. Tart candy pastry sweet roll candy tart sugar plum pudding."
 And I press "Save"
 And I go to "block/add/block"
 And fill in "edit-label" with "Block Row Text Two"
 And fill in "edit-title" with "Block Row Text Two"
 And I fill in "edit-field-block-text-und-0-value" with "Lemon drops dessert chocolate gingerbread dessert."
 And I press "Save"
 And I go to "block/add/block-row"
 And I fill in "edit_label" with "My Block Row Block"
 And I fill in "edit_title" with "My Block Row Block"
 And I press "edit-field-block-row-collection-und-0-field-block-row-block-und-actions-ief-add-existing"
 and I fill in "edit-field-block-row-collection-und-0-field-block-row-block-und-form-entity-id" with "Block Row Text One"
 And I press "edit-field-block-row-collection-und-0-field-block-row-block-und-form-actions-ief-reference-save"
 And I press "Save"
 Then I should see "Cupcake ipsum dolor sit amet ice cream cake"
 
