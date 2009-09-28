class Player < Application

  def audio
    @pl_au_link = Link.find(params[:id])
    display @pl_au_link
  end

  def video
    @pl_link = Link.find(params[:id])
    display @pl_link
  end

end