require "application_system_test_case"

class HouseholdsTest < ApplicationSystemTestCase
  setup do
    @household = households(:one)
  end

  test "visiting the index" do
    visit households_url
    assert_selector "h1", text: "Households"
  end

  test "creating a Household" do
    visit households_url
    click_on "New Household"

    click_on "Create Household"

    assert_text "Household was successfully created"
    click_on "Back"
  end

  test "updating a Household" do
    visit households_url
    click_on "Edit", match: :first

    click_on "Update Household"

    assert_text "Household was successfully updated"
    click_on "Back"
  end

  test "destroying a Household" do
    visit households_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Household was successfully destroyed"
  end
end
