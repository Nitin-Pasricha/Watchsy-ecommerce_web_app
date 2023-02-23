class GalleryController < ApplicationController
  def index
    @watches = Store.all
  end

  def search
    if request.post?
      keyword = '%'+params[:keyword].capitalize()+'%'
      @watches = Store.where("name LIKE :k or  category LIKE :k or description LIKE :k or gender LIKE :k or colour LIKE :k", k:"#{keyword}")
      puts @watches
    end
  end
end
