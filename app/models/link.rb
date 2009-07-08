class Link < ActiveRecord::Base
  WRONG_URL_MESSAGE = 'Неверный URL!'
  WRONG_ABOUT_MESSAGE = 'Описание превышает 250 символов'

  before_validation :parse_url

  validate :url_is_well_formed

  validate :url_protocol_is_http_or_ftp

  validates_presence_of :url, :message => WRONG_URL_MESSAGE

  validates_length_of :file_about, :maximum => 250, :message => WRONG_ABOUT_MESSAGE

  validates_inclusion_of :status, :in => %w(queued downloading downloaded failure)

  named_scope :queued, :conditions => { :status => 'queued' }

  def parse_url
    begin
      @parsed_uri = URI.parse self.url
    rescue URI::InvalidURIError
      @parsed_uri = nil
    end
  end

  def url_is_well_formed
    unless @parsed_uri and @parsed_uri.is_a?(URI)
      errors.add(:url, WRONG_URL_MESSAGE)
    end
  end

  def url_protocol_is_http_or_ftp
    unless @parsed_uri and @parsed_uri.scheme and ['http', 'ftp'].include?(@parsed_uri.scheme.downcase)
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