class Wish < ActiveRecord::Base
  attr_accessible :notes, :title, :url, :image, :image_cache

  validates :secret, :presence => true, :uniqueness => true

  before_validation :create_secret

  mount_uploader :image, ImageUploader


  private

  def create_secret
    unique_id = nil
    begin
      unique_id = SecureRandom.uuid # or whatever you chose like UUID tools
    end while unique_id.nil? || self.class.exists?(:secret => unique_id)
    self.secret = unique_id
  end
end
