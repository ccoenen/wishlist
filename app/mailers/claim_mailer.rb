class ClaimMailer < ActionMailer::Base
  default from: "test@wishlist.test"

  def claim(wish, email)
    @wish = wish
    @email = email
    mail(to: email, subject: I18n.t('claim_mailer_claim.subject', {:gift => @wish.title}))
  end

  # todo claim complete mail!
end
