require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    context 'ユーザを登録した場合' do
      before do
        @user = FactoryBot.create(:user)
        visit new_session_path
        fill_in 'session_email', with: @user.email
        fill_in 'session_password', with: @user.password
        click_button 'create-session'
      end
      it 'タスク一覧画面に遷移する' do
          visit tasks_path
          expect(page).to have_content('タスク一覧ページ')
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      before do
        visit tasks_path
      end
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        #visit new_session_path
        flash_message = find('.alert') 
        expect(flash_message).to have_content('ログインしてください')
      end
    end
  end

  describe 'ログイン機能' do
    context '登録済みのユーザでログインした場合' do
      before do
        @user = FactoryBot.create(:user)
        visit new_session_path
        fill_in 'session_email', with: @user.email
        fill_in 'session_password', with: @user.password
        click_button 'create-session'
      end
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        #visit tasks_path
        flash_message = find('.alert') # フラッシュメッセージをラップした要素を選択
        expect(flash_message).to have_content('ログインしました')
      end
      it '自分の詳細画面にアクセスできる' do
          visit user_path(@user)
          expect(page).to have_content(@user.name)
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
          @another_user = FactoryBot.create(:user, email: 'another@example.com')
          visit user_path(@another_user)
          expect(page).to have_content 'タスク一覧'
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
          click_link 'sign-out'
          expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    context '管理者がログインした場合' do
      before do
        @admin_user = FactoryBot.create(:admin_user)
        visit new_session_path
        fill_in 'session_email', with: @admin_user.email
        fill_in 'session_password', with: @admin_user.password
        click_button 'create-session'
      end
      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content 'ユーザ一覧ページ'
      end
      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in 'user_name', with: 'New User'
        fill_in 'user_email', with: 'newuser@example.com'
        fill_in 'user_password', with: 'newpassword'
        fill_in 'user_password_confirmation', with: 'newpassword'
        check 'user_admin'
        click_button 'create-user'
        expect(page).to have_content 'ユーザを登録しました'
      end
      it 'ユーザ詳細画面にアクセスできる' do
        user = FactoryBot.create(:user)
        visit admin_user_path(user)
        expect(page).to have_content 'ユーザ詳細ページ'
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        user = FactoryBot.create(:user)
        user_id = user.id
        visit edit_admin_user_path(user)
        fill_in 'user_name', with: 'Updated Name'
        fill_in 'user_password', with: 'UserTest'
        fill_in 'user_password_confirmation', with: 'UserTest'
        click_button 'update-user' 
        expect(page).to have_content("Updated Name")
      end      
      it 'ユーザを削除できる' do
        user = FactoryBot.create(:user, name: 'DestroyUser')
        visit admin_users_path
        within('table#user-table') do
          row = find('tr', text: user.name)
          row.find_link(I18n.t("destroy")).click
        end
        expect(page).to have_content 'ユーザを削除しました'
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      before do
        user = FactoryBot.create(:user)
        visit new_session_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'create-session'
        visit admin_users_path
      end
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        expect(page).to have_content 'タスク一覧ページ'
        flash_message = find('.alert') # フラッシュメッセージをラップした要素を選択
        expect(flash_message).to have_content('管理者以外アクセスできません')
      end
    end
  end
end