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
end