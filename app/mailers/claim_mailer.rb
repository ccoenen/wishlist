class ClaimMailer < ActionMailer::Base
  default from: "test@wishlist.test"

  def claim(wish, email)
    @wish = wish
    @email = email
    mail(to: email, subject: "test")
  end
end
