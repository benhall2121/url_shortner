class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  def index
    @urls = Url.all
  end

  def show
  end

  def new
    @url = Url.new
  end

  def edit
  end

  def create
    @return_hash = {:response => "", :url => nil }
    
    # Check if url is valid
    link = URI.parse(params[:url][:long_url]) rescue false
    if !link.kind_of?(URI::HTTP) && !link.kind_of?(URI::HTTPS)
      @return_hash[:response] = "Not a valid url"
    else
      # Check and return url it it already exists
      @url = Url.where("long_url = ?", params[:url][:long_url])

      if !@url.empty?
        @return_hash[:url] = @url.first
        @return_hash[:response] = "This url has previously been shortened to #{request.protocol}#{request.host_with_port}#{request.fullpath}#{@url.first.short_link}."
      else
        # Create a short url
        @url = Url.new
        @url.long_url = params[:url][:long_url]
        @url.short_link = getShortUrl

        if @url.save
          @return_hash[:url] = @url
          @return_hash[:response] = "The new url created is: #{@url.short_link}."
        end
      end
    end

    respond_to do |format|
      format.js { render partial: 'new'}
    end
  end

  def update
    respond_to do |format|
      if @url.update(url_params)
        format.html { redirect_to @url, notice: 'Url was successfully updated.' }
        format.json { render :show, status: :ok, location: @url }
      else
        format.html { render :edit }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @url.destroy
    respond_to do |format|
      format.html { redirect_to urls_url, notice: 'Url was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:long_url, :short_link)
    end

    def getShortUrl
      total_url = Url.all.count
      token = ""

      loop do
        token_range = (rand((total_url+1)..(total_url+3))/2)
        # SecureRandom.hex is returning twice as many as token_range. Because of that, we are dividing by two
        token = SecureRandom.hex( token_range )
        break token unless Url.where(short_link: token).exists?
      end

      return token
    end
end
