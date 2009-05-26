class Link < ActiveRecord::Base
  validate :url_is_well_formed

  validates_inclusion_of :status, :in => %w(queued downloading downloaded)

  named_scope :queued, :conditions => { :status => 'queued' }

  def url_is_well_formed
    begin
      URI.parse self.url
    rescue URI::InvalidURIError
      errors.add(:url, 'Ссылка какая-то странная')
    end
  end

  def downloading?
    self.status == 'downloading'
  end

  def downloaded?
    self.status == 'downloaded'
  end

  def queued?
    self.status == 'queued'
  end
end