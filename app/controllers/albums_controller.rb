class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
    #Setting a default value for the params[:sort]
    if params[:sort].blank? or not Album.column_names.include? params[:sort]
      params[:sort] = "releasedate"
    end
    #Inserting values by each case: Name, Date, (Soon: By Alphabet!)
    if params[:sort] == "name"
      @sorted = @albums.sort! { |a,b| a.name.downcase <=> b.name.downcase }
      @title = "Name"      
    end
    if params[:sort] == "releasedate"
      @sorted = @albums.sort! { |a,b| b.releasedate <=> a.releasedate }  
      @title = "Release Date"
    end
    if params[:sort] == "created_at"
      @sorted = @albums.sort! { |a,b| b.created_at <=> a.created_at }  
      @title = "Added Date"
    end
    if params[:sort] == "publisher"
      @sorted = @albums.sort! { |a,b| a.publisher <=> b.publisher }  
      @title = "Publisher"
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @albums }
    end
    #Old Shal Code:
    #if @albums[0].is_a? String
    #  @sorted = @albums.sort! {|a,b| a[params[:sort]].downcase <=> b[params[:sort].downcase]}
    #else
    #  @sorted = @albums.sort! {|a,b| a[params[:sort]] <=> b[params[:sort]]}
    #end
  end
 
  # GET /albums/1
  # GET /albums/1.json
  def show
    require 'open-uri' #for screen scraping
    
    @album = Album.find(params[:id])
    @artists = @album.artists
    @sources = @album.sources
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @album }
    end
    
    #adding in automation functionality
    # if @album.catalognumber.blank? == true 
      # url = @album.reference
      # if url.split('/')[2] == "vgmdb.net"
      # doc = Nokogiri::HTML(open(url))
      # @catalognum = doc.xpath("//table[@id='album_infobit_large']//tr[1]//td[2]").text
      # @album.catalognumber = @catalognum.split(' ')[0]
      # @album.save
      # end
    # end

  end
  
  def nokogiri
    require 'open-uri'
    
    url = "http://vgmdb.net/album/33722"
    doc = Nokogiri::HTML(open(url))
    @catalognumber = doc.xpath("//table[@id='album_infobit_large']//tr[1]//td[2]").text
    
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new
    @title = "new"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @album }
      format.js {}
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    @artists = @album.artists
    @sources = @album.sources
    @title = "edit" 
  end

  # POST /albums
  # POST /albums.json
  def create
    
    @album = Album.new(params[:album])
    #params[:artist] if statement
    params["artistnames"].each do |each|
      if each.empty? == false
        @artistexists = Artist.find_by_name(each)
        if @artistexists.nil? == true
          @album.artists.build(:name => each)
        else
          @album.artists << Artist.find_by_name(each)
        end
      end
    end
    params["sourcenames"].each do |each|
      if each.empty? == false
        @artistexists = Source.find_by_name(each)
        if @artistexists.nil? == true
          @album.sources.build(:name => each)
        else
          @album.sources << Source.find_by_name(each)
        end
      end
    end
    
    if params[:album][:catalognumber].blank? == true 
      url = params[:album][:reference]
      if url.split('/')[2] == "vgmdb.net"
      doc = Nokogiri::HTML(open(url))
      @catalognum = doc.xpath("//table[@id='album_infobit_large']//tr[1]//td[2]").text
      @album.catalognumber = @catalognum.split(' ')[0]
      end
    end
    
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, :notice => 'Album was successfully created.' }
        format.json { render :json => @album, :status => :created, :location => @album }
        if params[:title] == "new"
          format.js { js_redirect_to(album_path(@album))}
        else
          format.js {}           
        end
      else
        format.html { render :action => "new" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
        format.js {}
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update
    @album = Album.find(params[:id])
    #Deleting Associated Artists
    @artistsexists = @album.artists.dup
    @artistsexists.each do |each|
      @existence = each.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.artists.delete(Artist.find_by_name(each.name))
      end
    end
    #Creating an Artist Association
    params["artistnames"].each do |each|
      if each.empty? == false
        @artistexists = Artist.find_by_name(each)
        if @artistexists.nil? == true
          @album.artists.build(:name => each)
        else
          @album.artists << Artist.find_by_name(each)
        end
      end
    end
    #Deleting Associated Sources
    @sourcesexists = @album.sources.dup
    @sourcesexists.each do |each|
      @existence = each.name #setting an instance variable as 'each' name
      if params[@existence] == "0" #checking the value of params[each.name] (which was set to 0 when unchecked.)
        @album.sources.delete(Source.find_by_name(each.name))
      end
    end
    #Creating A Source Association
    params["sourcenames"].each do |each|
      if each.empty? == false
        @artistexists = Source.find_by_name(each)
        if @artistexists.nil? == true
          @album.sources.build(:name => each)
        else
          @album.sources << Source.find_by_name(each)
        end
      end
    end
    
    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to @album, :notice => 'Album was successfully updated.' }
        format.json { head :no_content }
        format.js { js_redirect_to(album_path(@album))}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
        format.js {}
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end
end
