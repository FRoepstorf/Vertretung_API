class ChangesMailer < ApplicationMailer
  def mail_change(email, changes)
    @email = email
    @changes = Change.find_by_school_class 'IT7o'
    mail(to: @email, subject: 'Ausfall update')
  end
end
