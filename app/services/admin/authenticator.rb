# -*- coding: utf-8 -*-
class Admin::Authenticator
  def initialize(administrator)
    @administrator = administrator
  end

  def authenticate(raw_password)
    @administrator &&
      !@administrator.suspended? &&
      @administrator.hashed_password &&
      BCrypt::Password.new(@administrator.hashed_password) == raw_password
  end

  def authentication_alert(raw_password)
    if (@administrator.nil? ||
        BCrypt::Password.new(@administrator.hashed_password) != raw_password)
      @alert = 'メールアドレスまたはパスワードが誤っています。'
    elsif @administrator.suspended?
      @alert = 'アカウントが停止されています。'
    end
  end
end
