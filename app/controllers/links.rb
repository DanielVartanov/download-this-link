class Links < Application  
  def new
    only_provides :html
    @link = Link.new(params[:link])
    display @link
  end

  def create
    @link = Link.new(params[:link].merge(:status => 'Queued'))
    if @link.save
      run_later { start_download(@link) }
      redirect resource(@link)
    else
      render :new
    end
  end

  def show
    @link = Link.find(params[:id])
    display @link
  end

  def index    
    @links = Link.all    
    display @links
  end

protected

  def start_download(link)
    link.update_attribute(:status, "Downloading")
    file_name = generate_file_name
    download_link(link.url, Merb.root / 'public' / 'files' / file_name)
    link.update_attribute(:file_path, file_name)
    link.update_attribute(:status, "Downloaded")
  end

  def download_link(url, file_name)
    rio(url) > rio(file_name)
  end

  def generate_file_name
    "file-#{rand(1000000000)}"
  end
end