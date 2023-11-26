require 'rails_helper'

 RSpec.describe 'ユーザモデル機能', type: :model do
   describe 'バリデーションのテスト' do
     context 'ユーザの名前が空文字の場合' do
        it 'バリデーションに失敗する' do
            user = FactoryBot.build(:user, name: '')
            expect(user).not_to be_valid
        end
     end

     context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = FactoryBot.build(:user, email: '') 
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = FactoryBot.build(:user, password: '')  
        expect(user).not_to be_valid  
      end
    end
    
    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        existing_user = FactoryBot.create(:user, email: 'existing@example.com')  
        user = FactoryBot.build(:user, email: 'existing@example.com')  
        expect(user).not_to be_valid  
      end
    end
    
    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = FactoryBot.build(:user, password: 'short')  
        expect(user).not_to be_valid  
      end
    end
    
    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = FactoryBot.build(:user, name: 'New User', email: 'new@example.com', password: 'newexample', password_confirmation: 'newexample')  
        expect(user).to be_valid  
      end
    end
   end
 end