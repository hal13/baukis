# -*- coding: utf-8 -*-
require 'rails_helper'
require 'spec_helper'

describe Admin::Authenticator do
  describe '#authenticate' do
    example '正しいパスワードを入力するとtrueを返す' do
      m = build(:administrator)
      expect(Admin::Authenticator.new(m).authenticate('pw')).to be_truthy
    end

    example '誤ったパスワードを入力するとfalseを返す' do
      m = build(:administrator)
      expect(Admin::Authenticator.new(m).authenticate('xy')).to be_falsey
    end

    example '停止フラグが立っているとfalseを返す' do
      m = build(:administrator, suspended: true)
      expect(Admin::Authenticator.new(m).authenticate('pw')).to be_falsey
    end
  end

  describe '#authentication_alert' do
    example 'パスワードが誤っていたら指定の文字列を返す' do
      m = build(:administrator)
      @authenticate = Admin::Authenticator.new(m).authentication_alert('xy')
      @authenticate.should include 'メールアドレスまたはパスワードが誤っています。'
    end

    example '停止フラグが立っていたら指定の文字列を返す' do
      m = build(:administrator, suspended: true)
      @authenticate = Admin::Authenticator.new(m).authentication_alert('pw')
      @authenticate.should include 'アカウントが停止されています。'
    end
  end
end
