class Links < Application  
  def new
    only_provides :html
    @link = Link.new(params[:link])
    display @item
  end

  def create
    @link = Link.new(params[:link])
    if @link.save
      redirect url(:link, @link)
    else
      render :new
    end
  end
end
