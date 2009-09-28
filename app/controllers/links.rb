require 'rubygems'
require 'rio'

class Links < Application  

  def new()
    only_provides :html
    @link = Link.new(params[:link])
    display @link
  end

  def create
    if (params[:link].nil?)
      render :new
    else
      @tmp = Link.new(params[:link])

      link_to_check = "http://captchator.com/captcha/check_answer/" + @tmp.captcha_val.to_s + "/" + @tmp.captcha_value.to_s
      anarray=rio(link_to_check).chomp[]

      @link = Link.new(params[:link].merge(:status => 'queued'))
      if ("1" == anarray[0])
        if @link.save
          redirect resource(:links)
        else
          render :new
        end
      else
        @error = "Не верная капча"
        render :new
      end
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

 # def audio
 #   @audio_links = Link.find_by_sql["SELECT * FROM links WHERE file_path like '%.mp3'"]
 #    display @audio_links
 # end
end