require 'rails_helper'

RSpec.describe 'step5', type: :system do

  let!(:user) { User.create(name: 'user_name', email: 'user@email.com', password: 'password', password_confirmation: 'password') } #password_confirmation: 'password'を追記
  let!(:admin) { User.create(name: 'admin_name', email: 'admin@email.com', password: 'password', password_confirmation: 'password', admin: true) } #password_confirmation: 'password'を追記
  let!(:task_created_by_user){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)}
  let!(:task_created_by_admin){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: admin.id)}
  let!(:label_created_by_user) { Label.create(name: 'label_name', user_id: user.id)}
  let!(:label_created_by_admin) { Label.create(name: 'label_name', user_id: admin.id)}

  describe '画面遷移要件' do
    describe '1.要件通りにパスのプレフィックスが使用できること' do
      context '一般ユーザでログイン中の場合' do
        before do
          visit root_path
          click_link 'ログイン'
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
        end
        it '要件通りにパスのプレフィックスが使用できること' do
          visit labels_path
          visit new_label_path
          visit edit_label_path(label_created_by_user)
        end
      end
      context '管理者でログイン中の場合' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          find('#create-session').click
        end
        it '要件通りにパスのプレフィックスが使用できること' do
          visit labels_path
          visit new_label_path
          visit edit_label_path(label_created_by_admin)
        end
      end
    end
  end

  describe '画面設計要件' do
    describe '2.要件通りにHTMLのid属性やclass属性が付与されていること' do
      context 'ログアウト中の場合' do
        it 'グローバルナビゲーション' do
          visit root_path
          expect(page).not_to have_css '#labels-index'
          expect(page).not_to have_css '#new-label'
        end
      end
      context '一般ユーザでログイン中の場合' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          find('#create-session').click
        end
        it 'グローバルナビゲーション' do
          expect(page).to have_css '#labels-index'
          expect(page).to have_css '#new-label'
        end
      end
      context '管理者でログイン中の場合' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          find('#create-session').click
        end
        it 'グローバルナビゲーション' do
          expect(page).to have_css '#labels-index'
          expect(page).to have_css '#new-label'
        end
      end
    end
  end

  describe '画面設計要件' do
    describe '3.要件通りに各画面に文字やリンク、ボタンを表示すること' do
      context 'ログアウト中の場合' do
        it 'グローバルナビゲーション' do
          visit root_path
          expect(page).not_to have_link 'ラベル一覧'
          expect(page).not_to have_link 'ラベルを登録する'
        end
      end
      context '一般ユーザでログイン中の場合' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'ログイン'
          sleep 0.5
        end
        it 'グローバルナビゲーション' do
          expect(page).to have_link 'ラベル一覧'
          expect(page).to have_link 'ラベルを登録する'
        end

        it 'ラベル一覧画面' do
          visit labels_path
          expect(page).to have_content '名前'
          expect(page).to have_content 'タスク数'
          expect(page).to have_link '編集'
          expect(page).to have_link '削除'
        end
        it 'ラベル登録画面' do
          visit new_label_path
          expect(page).to have_content 'ラベル登録ページ'
          expect(page).to have_selector 'input[name="label[name]"]'
          expect(page).to have_button '登録する'
        end
        it 'ラベル編集画面' do
          visit edit_label_path(label_created_by_user)
          expect(page).to have_content 'ラベル編集ページ'
          expect(page).to have_selector 'input[name="label[name]"]'
          expect(page).to have_button '更新する'
          expect(page).to have_link '戻る'
        end
        it 'タスク登録画面' do
          visit new_task_path
          expect(page).to have_selector 'label', text: 'ラベル'
          expect(find('input[type="checkbox"]')).to be_visible
          expect(page).to have_button '登録する'
          expect(page).to have_link '戻る'
        end
        it 'タスク編集画面' do
          visit edit_task_path(task_created_by_user)
          expect(page).to have_selector 'label', text: 'ラベル'
          expect(find('input[type="checkbox"]')).to be_visible
          expect(page).to have_button '更新する'
          expect(page).to have_link '戻る'
        end
      end
      context '管理者でログイン中の場合' do
        before do
          visit new_session_path
          sleep 0.5
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'ログイン'
          sleep 0.5
        end
        it 'グローバルナビゲーション' do
          expect(page).to have_link 'ラベル一覧'
          expect(page).to have_link 'ラベルを登録する'
        end
        it 'ラベル一覧画面' do
          visit labels_path
          sleep 0.5
          expect(page).to have_content '名前'
          expect(page).to have_content 'タスク数'
          expect(page).to have_link '編集'
          expect(page).to have_link '削除'
        end
        it 'ラベル登録画面' do
          visit new_label_path
          sleep 0.5
          expect(page).to have_content 'ラベル登録ページ'
          expect(page).to have_selector 'input[name="label[name]"]'
          expect(page).to have_button '登録する'
        end
        it 'ラベル編集画面' do
          visit edit_label_path(label_created_by_admin)
          sleep 0.5
          expect(page).to have_content 'ラベル編集ページ'
          expect(page).to have_selector 'label', text: '名前'
          expect(page).to have_button '更新する'
          expect(page).to have_link '戻る'
        end
      end
    end
    describe '4.ラベル一覧画面には、ラベルに紐づいているタスクの数を表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'ラベル一覧画面には、ラベルに紐づいているタスクの数を表示させること' do
        3.times do |t|
          task = Task.create(title: "task_title_#{t+10}", content: "task_content_#{t+10}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          task.labels << label_created_by_user
        end
        visit labels_path
        expect(page).to have_content(3)
      end
    end
    describe '5.タスクの登録、編集画面に「ラベル」という名前のフォームラベルと、ラベルを選択するチェックボックスを表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'タスク登録画面' do
        visit new_task_path
        expect(page).to have_selector 'label', text: 'ラベル'
        expect(find('input[type="checkbox"]')).to be_visible
      end
      it 'タスク編集画面' do
        visit edit_task_path(task_created_by_user)
        expect(page).to have_selector 'label', text: 'ラベル'
        expect(find('input[type="checkbox"]')).to be_visible
      end
    end
    describe '6.タスク編集画面では、タスクに紐づいているラベルにチェックが入った状態で表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'タスク編集画面では、タスクに紐づいているラベルにチェックが入った状態で表示させること' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user_id: user.id) }
        task_created_by_user.labels << Label.find(2,7,9)
        visit edit_task_path(task_created_by_user)
        sleep 0.5
        expect(page).to have_checked_field('label_2')
        expect(page).to have_checked_field('label_7')
        expect(page).to have_checked_field('label_9')
        expect(page).to have_unchecked_field('label_1')
        expect(page).to have_unchecked_field('label_3')
        expect(page).to have_unchecked_field('label_4')
        expect(page).to have_unchecked_field('label_5')
        expect(page).to have_unchecked_field('label_6')
        expect(page).to have_unchecked_field('label_8')
        expect(page).to have_unchecked_field('label_10')
      end
    end
    describe '7.タスク詳細画面に「ラベル」という項目を追加し、そのタスクに紐づいているラベル名をすべて表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'タスクに紐づいているラベル名をすべて表示させること' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user_id: user.id) }
        task_created_by_user.labels << Label.find(2,7,9)
        visit task_path(task_created_by_user)
        sleep 0.5
        expect(page).to have_content 'ラベル'
        expect(page).to have_content 'label_2'
        expect(page).to have_content 'label_7'
        expect(page).to have_content 'label_9'
        expect(page).not_to have_content 'label_1'
        expect(page).not_to have_content 'label_3'
        expect(page).not_to have_content 'label_4'
        expect(page).not_to have_content 'label_5'
        expect(page).not_to have_content 'label_6'
        expect(page).not_to have_content 'label_8'
        expect(page).not_to have_content 'label_10'
      end
    end
  end

  describe '画面遷移要件' do
    describe '8.画面遷移図通りに遷移させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'グローバルナビゲーションのリンクを要件通りに遷移させること' do
        click_link 'ラベル一覧'
        sleep 0.5
        expect(page).to have_content 'ラベル一覧ページ'
        click_link 'ラベルを登録する'
        sleep 0.5
        expect(page).to have_content 'ラベル登録ページ'
      end
      it 'ラベルの登録に成功した場合、ページタイトルに「ラベル一覧ページ」が表示される' do
        visit new_label_path
        sleep 0.5
        find('input[name="label[name]"]').set('new_label_name')
        click_button '登録する'
        sleep 0.5
        expect(page).to have_content 'ラベル一覧ページ'
      end
      it 'ラベルの登録に失敗した場合、ページタイトルに「ラベル登録ページ」が表示される' do
        visit new_label_path
        sleep 0.5
        find('input[name="label[name]"]').set('')
        click_button '登録する'
        sleep 0.5
        expect(page).to have_content 'ラベル登録ページ'
      end
      it 'ラベルの編集に成功した場合、ページタイトルに「ラベル一覧ページ」が表示される' do
        visit edit_label_path(label_created_by_user)
        sleep 0.5
        find('input[name="label[name]"]').set('edit_label_name')
        click_button '更新する'
        sleep 0.5
        expect(page).to have_content 'ラベル一覧ページ'
      end
      it 'ラベルの編集に失敗した場合、ページタイトルに「ラベル編集ページ」が表示される' do
        visit edit_label_path(label_created_by_user)
        sleep 0.5
        find('input[name="label[name]"]').set('')
        click_button '更新する'
        sleep 0.5
        expect(page).to have_content 'ラベル編集ページ'
      end
      it 'ラベル一覧画面の「編集」をクリックした場合、ページタイトルに「ラベル編集ページ」が表示される' do
        visit labels_path
        sleep 0.5
        click_link '編集', href: edit_label_path(label_created_by_user)
        sleep 0.5
        expect(page).to have_content 'ラベル編集ページ'
      end
      it 'ラベル一覧画面の「削除」をクリックした場合、ページタイトルに「ラベル一覧ページ」が表示される' do
        visit labels_path
        sleep 0.5
        click_link '削除', href: label_path(label_created_by_user)
        sleep 0.5
        #page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ラベル一覧ページ'
      end
      it 'ラベル編集画面の「戻る」をクリックした場合、ページタイトルに「ラベル一覧ページ」が表示される' do
        visit edit_label_path(label_created_by_user)
        sleep 0.5
        click_link '戻る'
        sleep 0.5
        expect(page).to have_content 'ラベル一覧ページ'
      end
    end
  end

  describe '基本要件' do
    before do
      visit root_path
      sleep 0.5
      find('#sign-in').click
      find('input[name="session[email]"]').set(admin.email)
      find('input[name="session[password]"]').set(admin.password)
      find('#create-session').click
      sleep 0.5
    end
    describe '9.ラベルの検索フォームはステップ3で実装したタスク一覧画面の検索フォームに追加する形で実装すること' do
      it 'ラベルの検索フォームはステップ3で実装したタスク一覧画面の検索フォームに追加する形で実装すること' do
        visit tasks_path
        sleep 0.5
        expect(page).to have_css '#search_label'
      end
    end
    describe '10.ラベルの検索フォームにはselectを使用し、デフォルト値は空にすること' do
      it 'ラベルの検索フォームにはselectを使用し、デフォルト値は空にすること' do
        visit tasks_path
        sleep 0.5
        expect(find('#search_label').all('option')[0].text).to be_blank
      end
    end
  end

  describe '機能要件' do
    describe '11.タスクを登録、編集する際、ラベル付けできるようにすること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'タスクを登録する際、ラベル付けできるようにすること' do
        visit new_task_path
        sleep 0.5
        find('input[name="task[title]"]').set('task_title')
        find('textarea[name="task[content]"]').set('task_content')
        find('input[name="task[deadline_on]"]').set(Date.today)
        select '高', from: 'task[priority]'
        select '未着手', from: 'task[status]'
        check label_created_by_user.name
        click_button '登録する'
        sleep 0.5
      end
      it 'タスクを編集する際、ラベル付けできるようにすること' do
        visit edit_task_path(task_created_by_user)
        sleep 0.5
        find('input[name="task[title]"]').set('task_title')
        find('textarea[name="task[content]"]').set('task_content')
        find('input[name="task[deadline_on]"]').set(Date.today)
        select '高', from: 'task[priority]'
        select '未着手', from: 'task[status]'
        check label_created_by_user.name
        click_button '更新する'
        sleep 0.5
      end
    end

    describe '12.1つのタスクに対し、複数のラベルを登録できるようにすること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      context 'タスク登録画面' do
        it '1つのタスクに対し、複数のラベルを登録できるようにすること' do
          10.times { |t| Label.create!(name: "label_#{t+1}", user_id: user.id) }
          visit new_task_path
          sleep 0.5
          find('input[name="task[title]"]').set('task_title')
          find('textarea[name="task[content]"]').set('task_content')
          find('input[name="task[deadline_on]"]').set(Date.today)
          select '高', from: 'task[priority]'
          select '未着手', from: 'task[status]'
          check 'label_1'
          check 'label_3'
          check 'label_5'
          check 'label_7'
          check 'label_9'
          click_button '登録する'
          sleep 0.5
          visit task_path(user.tasks.last)
          sleep 0.5
          expect(page).to have_content 'label_1'
          expect(page).to have_content 'label_3'
          expect(page).to have_content 'label_5'
          expect(page).to have_content 'label_7'
          expect(page).to have_content 'label_9'
        end
      end
      context 'タスク編集画面' do
        it '1つのタスクに対し、複数のラベルを登録できるようにすること' do
          10.times { |t| Label.create!(name: "label_#{t+1}", user_id: user.id) }
          visit edit_task_path(task_created_by_user)
          sleep 0.5
          find('input[name="task[title]"]').set('task_title')
          find('textarea[name="task[content]"]').set('task_content')
          find('input[name="task[deadline_on]"]').set(Date.today)
          select '高', from: 'task[priority]'
          select '未着手', from: 'task[status]'
          check 'label_2'
          check 'label_4'
          check 'label_6'
          check 'label_8'
          check 'label_10'
          click_button '更新する'
          sleep 0.5
          visit task_path(task_created_by_user)
          expect(page).to have_content 'label_2'
          expect(page).to have_content 'label_4'
          expect(page).to have_content 'label_6'
          expect(page).to have_content 'label_8'
          expect(page).to have_content 'label_10'
        end
      end
    end

    describe '13.ラベルを削除するリンクをクリックした際、確認ダイアログに「本当に削除してもよろしいですか？」という文字を表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'ラベルを削除するリンクをクリックした際、確認ダイアログに「本当に削除してもよろしいですか？」という文字を表示させること' do
        visit labels_path
        sleep 0.5
        click_link '削除', href: label_path(label_created_by_user)
        expect(page.driver.browser.switch_to.alert.text).to eq '本当に削除してもよろしいですか？'
      end
    end

    describe '14.要件通りにフラッシュメッセージを表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      context 'ラベルの登録に成功した場合' do
        it '「ラベルを登録しました」というフラッシュメッセージを表示させること' do
          visit new_label_path
          sleep 0.5
          find('input[name="label[name]"]').set('new_label_name')
          click_button '登録する'
          sleep 0.5
          expect(page).to have_content 'ラベルを登録しました'
        end
      end
      context 'ラベルの更新に成功した場合' do
        it '「ラベルを更新しました」というフラッシュメッセージを表示させること' do
          visit edit_label_path(label_created_by_user)
          sleep 0.5
          find('input[name="label[name]"]').set('new_label_name')
          click_button '更新する'
          sleep 0.5
          expect(page).to have_content 'ラベルを更新しました'
        end
      end
      context 'ラベルを削除した場合' do
        it '「ラベルを削除しました」というフラッシュメッセージを表示させること' do
          visit labels_path
          sleep 0.5
          click_link '削除', href: label_path(label_created_by_user)
          sleep 0.5
          #page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'ラベルを削除しました'
        end
      end
    end

    describe '15.ラベルの名前を未入力で登録、更新しようとした際、「名前を入力してください」というバリデーションメッセージを表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'ラベルの名前を未入力で登録しようとした際、「名前を入力してください」というバリデーションメッセージを表示させること' do
        visit new_label_path
        sleep 0.5
        find('input[name="label[name]"]').set('')
        click_button '登録する'
        sleep 0.5
        expect(page).to have_content '名前を入力してください'
      end
      it 'ラベルの名前を未入力で更新しようとした際、「名前を入力してください」というバリデーションメッセージを表示させること' do
        visit edit_label_path(label_created_by_user)
        sleep 0.5
        find('input[name="label[name]"]').set('')
        click_button '更新する'
        sleep 0.5
        expect(page).to have_content '名前を入力してください'
      end
    end

    describe '16.登録したラベルは、そのラベルを登録したユーザにしか使えないようにすること' do
      let!(:second_user) { User.create(name: 'second_user_name', email: 'second_user@email.com', password: 'password', password_confirmation: 'password') } #password_confirmation: 'password'を追記
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'タスク登録画面に他のユーザが作成したラベルは表示されない' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user: second_user) }
        visit new_task_path
        sleep 0.5
        expect(page).not_to have_content 'label_1'
        expect(page).not_to have_content 'label_2'
        expect(page).not_to have_content 'label_3'
        expect(page).not_to have_content 'label_4'
        expect(page).not_to have_content 'label_5'
        expect(page).not_to have_content 'label_6'
        expect(page).not_to have_content 'label_7'
        expect(page).not_to have_content 'label_8'
        expect(page).not_to have_content 'label_9'
        expect(page).not_to have_content 'label_10'
      end
      it 'タスク編集画面に他のユーザが作成したラベルは表示されない' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user: second_user) }
        visit edit_task_path(task_created_by_user)
        sleep 0.5
        expect(page).not_to have_content 'label_1'
        expect(page).not_to have_content 'label_2'
        expect(page).not_to have_content 'label_3'
        expect(page).not_to have_content 'label_4'
        expect(page).not_to have_content 'label_5'
        expect(page).not_to have_content 'label_6'
        expect(page).not_to have_content 'label_7'
        expect(page).not_to have_content 'label_8'
        expect(page).not_to have_content 'label_9'
        expect(page).not_to have_content 'label_10'
      end
    end

    describe '17.ラベルを1つ指定し検索することで、そのラベルが貼られたタスクのみ表示させること' do
      before do
        visit new_session_path
        sleep 0.5
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'ログイン'
        sleep 0.5
      end
      it 'ラベルを1つ指定し検索することで、そのラベルが貼られたタスクのみ表示させること' do
        5.times do |t|
          Task.create(title: "task_title_#{t+2}", content: "task_content_#{t+2}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          task = Task.create(title: "task_title_#{t+7}", content: "task_content_#{t+7}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          task.labels << label_created_by_user
        end
        visit tasks_path
        sleep 0.5
        find('select[name="search[label_id]"]').find("option[value='#{label_created_by_user.id}']").select_option #labelからlabel_idに修正
        click_button '検索'
        sleep 0.5
        expect(page).to have_content 'task_title_7'
        expect(page).to have_content 'task_title_8'
        expect(page).to have_content 'task_title_9'
        expect(page).to have_content 'task_title_10'
        expect(page).to have_content 'task_title_11'
        expect(page).not_to have_content 'task_title_2'
        expect(page).not_to have_content 'task_title_3'
        expect(page).not_to have_content 'task_title_4'
        expect(page).not_to have_content 'task_title_5'
        expect(page).not_to have_content 'task_title_6'
      end
    end
  end
end

