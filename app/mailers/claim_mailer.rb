class ClaimMailer < ActionMailer::Base
  default from: "test@wishlist.test"

  def claim(wish, email)
    @wish = wish
    @email = email # also used in the template
    mail(to: email, subject: I18n.t('claim_mailer_claim.subject', {:gift => @wish.title}))
  end

  def claimed_successfully(wish, email)
    @wish = wish
    mail(to: email, subject: I18n.t('claim_mailer_claimed_successfully.subject', {:gift => @wish.title}))
  end
end
