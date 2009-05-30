class Links < Application  
  def new
    only_provides :html
    @link = Link.new(params[:link])
    display @link
  end

  def create
    @link = Link.new(params[:link].merge(:status => 'queued'))
    @link.save
    @links = Link.all
    render :index
  end

  def show
    @link = Link.find(params[:id])
    display @link
  end

  def index
    @link = Link.new(params[:link])
    @links = Link.all
    display @links
  end
end