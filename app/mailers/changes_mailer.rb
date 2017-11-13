class ChangesMailer < ApplicationMailer
  def mail_change(email)
    @email = email
    @changes = Change.find_by_school_class 'IT_c'
    mail(to: @email, subject: 'Ausfall update')
  end
end
