class Link < ActiveRecord::Base
  WRONG_URL_MESSAGE = 'Не верный URL!'
  WRONG_ABOUT_MESSAGE = 'Описание превышает 250 символов'
  attr_accessor :field

  validate :url_is_well_formed

  validates_presence_of :url, :message => WRONG_URL_MESSAGE

  validates_length_of :file_about,:maximum=>250, :message => WRONG_ABOUT_MESSAGE

  validates_inclusion_of :status, :in => %w(queued downloading downloaded failure)

  named_scope :queued, :conditions => { :status => 'queued' }

  def url_is_well_formed
    begin
      URI.parse self.url
    rescue URI::InvalidURIError
      errors.add(:url, WRONG_URL_MESSAGE)
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