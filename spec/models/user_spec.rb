require 'rails_helper'

RSpec.describe User, type: :model do
  context "name, email, password が指定されているとき" do
    let(:user) { build(:user) }
    it "ユーザーが作られる" do
      expect(user).to be_valid
    end
  end

  context "name が指定されていないとき" do
    let(:user) { build(:user, name: nil) }
    it "ユーザー作成に失敗する" do
      expect(user).to be_invalid
      expect(user.errors.messages[:name]).to eq ["can't be blank"]
    end
  end

  context "email が指定されていないとき" do
    let(:user) { build(:user, email: nil) }
    it "ユーザー作成に失敗する" do
      expect(user).to be_invalid
      expect(user.errors.messages[:email]).to eq ["can't be blank"]
    end
  end

  context "password が指定されていないとき" do
    let(:user) { build(:user, password: nil) }
    it "ユーザー作成に失敗する" do
      expect(user).to be_invalid
      expect(user.errors.messages[:password]).to eq ["can't be blank"]
    end
  end

  context "すでに同じ名前の name が存在しているとき" do
    let(:user) { build(:user, name: "foo") }
    it "ユーザーの作成に失敗する" do
      create(:user, name: "foo")
      expect(user).to be_invalid
      expect(user.errors.details[:name][0][:error]).to eq :taken
      expect(user.errors.details[:name][0][:value]).to eq "foo"
    end
  end

  context "ユーザーネームの最大文字数が31文字以上のとき" do
    let(:user) { build(:user, name: "a" * 31) }
    it "ユーザーの作成に失敗する" do
      expect(user).to be_invalid
      expect(user.errors.messages[:name]).to eq ["is too long (maximum is 30 characters)"]
    end
  end
end
