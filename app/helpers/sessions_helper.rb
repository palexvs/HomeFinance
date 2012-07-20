module SessionsHelper

  def sign_in(user)
    s = Sessions.new
    s.user_id = user.id
    if s.save
      cookies.permanent[:sid] = s.sid
      self.current_user = user
    else
      false
    end
  end

  def sign_out
    Sessions.find_by_sid(cookies[:sid]).delete
    cookies.delete(:sid)
    @current_user = nil
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    if !cookies[:sid].blank?
      s = Sessions.find_by_sid(cookies[:sid])
      if !s.nil?
        @current_user ||= s.user
      else
        @current_user = nil
      end
    else
      @current_user = nil
    end
  end
end
