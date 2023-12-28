require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'session_email', with: @user.email
      fill_in 'session_password', with: @user.password
      click_button 'create-session'
    end
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        @task = FactoryBot.create(:task, user:@user)
        visit task_path(@task)
        expect(page).to have_content '登録表示テスト'
        expect(page).to have_content '登録表示のテスト内容'
      end
    end
  end
  
  describe '一覧表示機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'session_email', with: @user.email
      fill_in 'session_password', with: @user.password
      click_button 'create-session'
      # タスクを新規作成
      @task = FactoryBot.create(:task, title: 'first_task', created_at: '2023-02-18', priority: '中', status: '未着手', deadline_on: '2025-02-18', user: @user)
      @second_task = FactoryBot.create(:second_task, title: 'second_task', created_at: '2023-02-17', priority: '高', status: '着手中', deadline_on: '2025-02-17', user: @user)
      @third_task = FactoryBot.create(:third_task, title: 'third_task', created_at: '2023-02-16', priority: '低', status: '完了', deadline_on: '2025-02-16', user: @user)
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        # タスク一覧ページからすべてのタスクの作成日時を取得
        task_dates = page.all('.task-created-at').map(&:text)
        
        # タスクの作成日時が降順に並んでいることを確認
        expect(task_dates).to eq(['2023/02/18 00:00', '2023/02/17 00:00', '2023/02/16 00:00'].sort.reverse)
      end
    end
    
    context '新たにタスクを作成した場合' do
      before do
        @fourth_task = FactoryBot.create(:third_task, title: 'forth_task', user: @user)
      end
      it '新しいタスクが一番上に表示される' do
        # 一覧画面に戻って新しいタスクが一番上に表示されているか確認
        visit tasks_path
        expect(page).to have_content('forth_task')
        expect(page).to have_selector('tbody tr:first-child', text: 'forth_task')
      end
    end
  end

  describe 'ソート機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'session_email', with: @user.email
      fill_in 'session_password', with: @user.password
      click_button 'create-session'
      @task = FactoryBot.create(:task, title: 'first_task', created_at: '2023-02-18', priority: '中', status: '未着手', deadline_on: '2025-02-18', user: @user)
      @second_task = FactoryBot.create(:second_task, title: 'second_task', created_at: '2023-02-17', priority: '高', status: '着手中', deadline_on: '2025-02-17', user: @user)
      @third_task = FactoryBot.create(:third_task, title: 'third_task', created_at: '2023-02-16', priority: '低', status: '完了', deadline_on: '2025-02-16', user: @user)
      visit tasks_path
    end

    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        # ソートリンクをクリックするアクションをシミュレートする
        click_on I18n.t("activerecord.attributes.task.deadline_on")
  
        # ページ内のタスクが終了期限昇順に表示されていることを確認
        task_titles = all('tbody tr td:first-child').map(&:text)
        expect(task_titles[0]).to eq('third_task')
        expect(task_titles[1]).to eq('second_task')
        expect(task_titles[2]).to eq('first_task')
      end
    end

    context '「優先度」というリンクをクリックした場合' do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
        click_on I18n.t("activerecord.attributes.task.priority")

        # ページ内のタスクが優先度の高い順に表示されていることを確認
        task_titles = all('tbody tr td:first-child').map(&:text)
        expect(task_titles[0]).to eq('second_task')
        expect(task_titles[1]).to eq('first_task')
        expect(task_titles[2]).to eq('third_task')
      end
    end
  end
    
  describe '検索機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'session_email', with: @user.email
      fill_in 'session_password', with: @user.password
      click_button I18n.t("sign-in")
      @task = FactoryBot.create(:task, title: 'first_task', created_at: '2023-02-18', priority: '中', status: '未着手', deadline_on: '2025-02-18', user: @user)
      @second_task = FactoryBot.create(:second_task, title: 'second_task', created_at: '2023-02-17', priority: '高', status: '着手中', deadline_on: '2025-02-17', user: @user)
      @third_task = FactoryBot.create(:third_task, title: 'third_task', created_at: '2023-02-16', priority: '低', status: '完了', deadline_on: '2025-02-16', user: @user)
      visit tasks_path
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        
        fill_in 'search[title]', with: 'second'
        click_button I18n.t("search")

        expect(page).to have_text('second_task')
        
        expect(page).not_to have_text('first_task')
        expect(page).not_to have_text('third_task')
      end
    end

    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do

        select '着手中', from: 'search[status]'
        click_button I18n.t("search")
        
        expect(page).to have_text('second_task')
        
        expect(page).not_to have_text('first_task')
        expect(page).not_to have_text('third_task')
      end
    end

    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do

        fill_in 'search[title]', with: 'task'
        select '着手中', from: 'search[status]'
        click_button I18n.t("search")
        
        expect(page).to have_text('second_task')
        
        expect(page).not_to have_text('first_task')
        expect(page).not_to have_text('third_task')
      end
    end   

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do

        @task = FactoryBot.create(:task)

        visit tasks_path
        expect(page).to have_content('登録表示のテスト内容')
        expect(page).to have_selector('tbody tr:first-child', text: '登録表示のテスト内容')

        expect(Task.count).to eq(4) 
      end
    end
  end

  describe '任意のタスク詳細画面に遷移した場合' do
    before do
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'session_email', with: @user.email
      fill_in 'session_password', with: @user.password
      click_button 'create-session'
      @task = FactoryBot.create(:third_task, user: @user)
    end

    it 'そのタスクの内容が表示される' do
      visit task_path(@task)
      expect(page).to have_content '詳細テスト'
      expect(page).to have_content '詳細表示のテスト内容'
    end
  end

  describe "キャッシュが正しく機能しているかどうかを確認" do
    it "データキャッシュ" do
      # データをキャッシュ
      Rails.cache.write('some_key', 'some_value')
  
      # キャッシュからデータを取得
      cached_data = Rails.cache.read('some_key')
  
      expect(cached_data).to eq('some_value')
    end
  end

  describe '検索機能' do
    before do
      @user = FactoryBot.create(:user)
      visit new_session_path
      fill_in 'session_email', with: @user.email
      fill_in 'session_password', with: @user.password
      click_button 'create-session'
      @label = FactoryBot.create(:label, user: @user)
      @label2 = FactoryBot.create(:label, name: 'LabelTest2', user: @user)
      @task = FactoryBot.create(:task, user: @user)
      @task.labels << @label
      @task2 = FactoryBot.create(:second_task, user: @user)
      @task2.labels << @label2
    end
    context 'ラベルで検索をした場合' do
      it "そのラベルの付いたタスクがすべて表示される" do
        visit tasks_path
        select 'LabelTest', from: 'search[label_id]'
        click_button I18n.t("search")

        expect(page).to have_text(@task.title)
        expect(page).not_to have_text(@task2.title)
      end
    end
  end
end  