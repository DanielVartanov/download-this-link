class Link < ActiveRecord::Base
  WRONG_URL_MESSAGE = 'Неверный URL!'
  WRONG_ABOUT_MESSAGE = 'Описание превышает 250 символов'
  URL_ALREADY_IN_THE_LIST = 'Эта ссылка уже есть в списке'

  before_validation :parse_url

  validate :url_is_well_formed

  validate :url_protocol_is_http_or_ftp

  validate :url_is_not_in_list_already

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

  def url_is_not_in_list_already
    links = Link.find_all_by_url self.url
    good_links = links.select { |link| link.downloading? or link.downloaded? or link.queued? }
    unless good_links.empty?
      errors.add(:url, URL_ALREADY_IN_THE_LIST)
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