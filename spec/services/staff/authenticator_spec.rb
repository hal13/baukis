# -*- coding: utf-8 -*-
require 'rails_helper'
require 'spec_helper'

describe Staff::Authenticator do
  describe '#authenticate' do
    example '正しいパスワードならtrueを返す' do
      m = build(:staff_member)
      expect(Staff::Authenticator.new(m).authenticate('pw')).to be_truthy
    end

    example '誤ったパスワードならfalseを返す' do
      m = build(:staff_member)
      expect(Staff::Authenticator.new(m).authenticate('xy')).to be_falsey
    end

    example 'パスワードがnilならfalseを返す' do
      m = build(:staff_member, password: nil)
      expect(Staff::Authenticator.new(m).authenticate(nil)).to be_falsey
    end

    example '停止フラグが立っていればfalseを返す' do
      m = build(:staff_member, suspended: true)
      expect(Staff::Authenticator.new(m).authenticate('pw')).to be_falsey
    end

    example '開始前ならfalseを返す' do
      m = build(:staff_member, start_date: Date.tomorrow)
      expect(Staff::Authenticator.new(m).authenticate('pw')).to be_falsey
    end

    example '終了後ならfalseを返す' do
      m = build(:staff_member, end_date: Date.yesterday)
      expect(Staff::Authenticator.new(m).authenticate('pw')).to be_falsey
    end
  end

  describe '#authentication_alert' do
    example 'パスワードが間違っていれば指定の文字列を返す' do
      m = build(:staff_member)
      @target = Staff::Authenticator.new(m).authentication_alert('xy')
      #{@target}.should include 'メールアドレスまたはパスワードが正しくありません。'
    end
    
    example '停止フラグが立っている場合は指定の文字列を返す' do
      m = build(:staff_member, suspended: true)
      @target = Staff::Authenticator.new(m).authentication_alert('pw')
      #{@target}.should include 'アカウントが停止されています。'
    end
    
    example '開始日前であれば指定の文字列を返す' do
      m = build(:staff_member, start_date: Date.tomorrow)
      @target = Staff::Authenticator.new(m).authentication_alert('pw')
      #{@target}.should include 'アカウントの有効期限が未到来です。'
    end
    
    example '終了後であれば指定の文字列を返す' do
      m = build(:staff_member, end_date: Date.yesterday)
      @target = Staff::Authenticator.new(m).authentication_alert('pw')
      #{@target}.should include 'アカウントの有効期限が過ぎています。'
    end
    
  end
end
