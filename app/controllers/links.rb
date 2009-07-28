class Links < Application  
  def new
    only_provides :html
    @link = Link.new(params[:link])
    display @link
  end

  def create
    @link = Link.new(params[:link].merge(:status => 'queued'))
    if @link.save
      redirect resource(:links)
    else
      render :new
    end
  end

  def show
    @link = Link.find(params[:id])
    display @link
  end

  def index        
    @links = Link.paginate :page => params[:page], :per_page => 50, :order => 'created_at DESC'
    display @links
  end

  
end