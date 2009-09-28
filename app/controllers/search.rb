class Search < Application
  # Ужасно грязный код. Срочно рефакторить.
  def index
    if params.key? :url
      link = Link.find_by_url params[:url]
      unless link.nil?
        return redirect(resource(link))
      end
    end
    render
  end

 def audio
    @audio_links = Link.find_by_sql "SELECT * FROM links WHERE ucase(file_path) like ucase('%.mp3')"
     display @audio_links
  end

def video
    @video_links = Link.find_by_sql "SELECT * FROM links WHERE (ucase(file_path) like ucase('%.avi')) or (ucase(file_path) like ucase('%.flv')) "
     display @video_links
  end

end