# -*- coding: utf-8 -*-
class Staff::Authenticator
  def initialize(staff_member)
    @staff_member = staff_member
  end

  def authenticate(raw_password)
    @staff_member &&
      !@staff_member.suspended? &&
      @staff_member.hashed_password &&
      @staff_member.start_date <= Date.today &&
      (@staff_member.end_date.nil? || @staff_member.end_date > Date.today) &&
      BCrypt::Password.new(@staff_member.hashed_password) == raw_password
  end

  def authentication_alert(raw_password)
    if (@staff_member.nil? || BCrypt::Password.new(@staff_member.hashed_password) != raw_password)
      @alert = 'メールアドレスまたはパスワードが正しくありません。'
    elsif @staff_member.suspended?
      @alert = 'アカウントが停止されています。'
    elsif @staff_member.start_date > Date.today
      @alert = 'アカウントの有効期限が未到来です。'
    elsif (!@staff_member.end_date.nil? && @staff_member.end_date <= Date.today)
      @alert = 'アカウントの有効期限が過ぎています。'
    end
  end
end
