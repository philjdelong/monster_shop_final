require 'rails_helper'

RSpec.describe "As a merchant user" do
  describe "when i visit a coupon show page", type: :feature do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)

      @half_off_mm = Coupon.create(
        name:       "Half off Megans",
        code:       00001,
        percentage: 50
      )

      @fourth_off_mm = Coupon.create(
        name:       "Fourth off Megans",
        code:       00002,
        percentage: 25
      )

      @half_off_bb = Coupon.create(
        name:       "Half off Brians",
        code:       00003,
        percentage: 50
      )

      @fourth_off_bb = Coupon.create(
        name:       "Fourth off Brians",
        code:       00004,
        percentage: 25
      )

      @merchant_1.coupons << [@half_off_mm, @fourth_off_mm]
      @merchant_2.coupons << [@half_off_bb, @fourth_off_bb]
      @half_off_bb.orders << @order_1

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)

      visit "/merchant/coupons/#{@half_off_mm.id}"
    end

    it "i see the coupon info" do
      expect(page).to have_content('Half off Megans')
      expect(page).to have_content('Code: 1')
      expect(page).to have_content('50%')
    end

    it "i can click a link to edit the coupon" do
      click_link 'Edit Coupon'
      expect(current_path).to eq("/merchant/coupons/#{@half_off_mm.id}/edit")

      fill_in 'Name', with: 'Fifth off Megans'
      fill_in 'Code', with: '04301'
      fill_in 'Percentage', with: '20'

      click_on 'Update Coupon'
      expect(current_path).to eq("/merchant/coupons/#{@half_off_mm.id}")

      expect(page).to have_content('Fifth off Megans')
      expect(page).to_not have_content('Half off Megans')
    end

    it "i cannot update coupon without valid info" do
      click_link 'Edit Coupon'
      expect(current_path).to eq("/merchant/coupons/#{@half_off_mm.id}/edit")

      fill_in 'Name', with: 'Fifth off Megans'
      fill_in 'Percentage', with: '20'

      click_on 'Update Coupon'
      expect(current_path).to eq("/merchant/coupons/#{@half_off_mm.id}/edit")

      expect(page).to have_content('Please enter valid coupon info.')
    end

    it "i can click a link to delete the coupon" do
      click_on 'Delete Coupon'
      expect(current_path).to eq("/merchant/coupons")

      expect(page).to have_content("Coupon successfully deleted.")
      expect(@merchant_1.coupons.count).to eq(1)
    end

    it "i cannot delete the coupon if it has been used on an order" do
      visit "/merchant/coupons/#{@half_off_bb.id}"

      click_on 'Delete Coupon'
      expect(current_path).to eq("/merchant/coupons/#{@half_off_bb.id}")

      expect(page).to have_content("#{@half_off_bb.name} has been used, so it can not be deleted!")
      expect(page).to have_content("Half off Brians")
    end
  end
end
