class Links < Application  
  def new
    only_provides :html
    @link = Link.new(params[:link])
    display @link
  end

  def create
    @link = Link.new(params[:link])
    if @link.save
      redirect resource(@link)
    else
      render :new
    end
  end

  def index
    @links = Link.all
    display @links
  end
end