class Link < ActiveRecord::Base
  validate :url_is_well_formed

  def url_is_well_formed
    begin
      URI.parse self.url
    rescue URI::InvalidURIError
      errors.add(:url, 'Ссылка какая-то странная')
    end
  end
end