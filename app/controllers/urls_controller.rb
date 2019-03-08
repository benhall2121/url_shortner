class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]

  def index
    @urls = Url.all
  end

  def show
  end

  def show_by_short_link
    # Check if to go to the show page or be redirected
    go_to_show_page = params[:short_link][-1] == "+" ? true : false
    # If there is a plus sign remove it from the short link
    params[:short_link].slice!(params[:short_link].length-1,params[:short_link].length) if go_to_show_page
    # Search for the url
    @check_url = Url.where(:short_link => params[:short_link])

    # A url should not be saved twice but if it is, use the first one
    @url = @check_url.first

    if !@check_url.empty? && !go_to_show_page
      # Track the number of times (clicks) users have used this url
      current_users_ip_address = request.remote_ip
      c = Click.new(:ip_address => current_users_ip_address, :url_id => @url.id)
      c.save
      # redirect to original url
      redirect_to @url.long_url
    elsif @check_url.empty?
      # If the url is not found, go to the homepage
      flash[:notice] = 'URL not found'
      redirect_to root_path
    end

    # Go to the show_by_short_link page
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
        @return_hash[:response] = "This url has previously been shortened to #{getBaseUrl}#{@url.first.short_link}."
      else
        # Create a short url
        @url = Url.new
        @url.long_url = params[:url][:long_url]
        @url.short_link = getShortUrl

        if @url.save
          @return_hash[:url] = @url
          @return_hash[:response] = "The new url created is: #{getBaseUrl}#{@url.short_link}."
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

    def getBaseUrl
      base_url = request.protocol + request.host_with_port + "/"
      # Default Base Url
      base_url = "https://sho-url.herokuapp.com/" if base_url == ""

      return base_url
    end

    def getShortUrl
      # Get the length of all the current urls
      # This will give us the shortest optimal link
      total_url = Math.log10(Url.all.count).to_i + 1

      token = ""

      loop do
        token_range = (rand((total_url+1)..(total_url+3))/2)
        # SecureRandom.hex is returning twice as many as total_url. Because of that, we are dividing by two
        token = SecureRandom.hex( token_range )
        break token unless Url.where(short_link: token).exists?
      end

      return token
    end
end
