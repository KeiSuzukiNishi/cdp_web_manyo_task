require 'rails_helper'
 RSpec.describe 'ラベル管理機能', type: :system do
    before do
        @user = FactoryBot.create(:user)
        visit new_session_path
        fill_in 'session_email', with: @user.email
        fill_in 'session_password', with: @user.password
        click_button 'create-session'
        @task = FactoryBot.create(:task, user:@user)
        visit tasks_path
    end
    describe '登録機能' do
        context 'ラベルを登録した場合' do
        it '登録したラベルが表示される' do
            @label = FactoryBot.create(:label, user:@user)
            visit labels_path
            expect(page).to have_content 'LabelTest'
        end
        end
    end
    describe '一覧表示機能' do
        context '一覧画面に遷移した場合' do
        it '登録済みのラベル一覧が表示される' do
            @label = FactoryBot.create(:label, user:@user)
            @label2 = FactoryBot.create(:label, name: 'LabelTest2', user:@user)
            visit labels_path
            expect(page).to have_content 'LabelTest'
            expect(page).to have_content 'LabelTest2'
        end
        end
   end
 end