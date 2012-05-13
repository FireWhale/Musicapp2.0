class AlbumsController < ApplicationController
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.all
    #Setting a default value for the params[:sort]
    if params[:sort].blank? or not Album.column_names.include? params[:sort]
      params[:sort] = "name"
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
    @album = Album.find(params[:id])
    @artists = @album.artists
    @sources = @album.sources
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    @artists = @album.artists
    @sources = @album.sources
    @sourcesexists = @sources.dup
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new(params[:album])
    if params[:artist][:name].to_s.empty? == false #if there is a name there
      @artistexists = Artist.find_by_name(params[:artist][:name])
      if @artistexists.nil? == true #if the artist isn't in the database
        @album.artists.build(params[:artist])
      else
        @album.artists << Artist.find_by_name(params[:artist][:name])
      end   
    end
    if params[:source][:name].to_s.empty? == false #if there is a name there
      @sourceexists = Source.find_by_name(params[:artist][:name])
      if @sourceexists.nil? == true #if the source isn't in the database
        @album.sources.build(params[:source])
      else
        @album.sources << Source.find_by_name(params[:source][:name])
      end   
    end    

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, :notice => 'Album was successfully created.' }
        format.json { render :json => @album, :status => :created, :location => @album }
      else
        format.html { render :action => "new" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
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
    if params[:artist][:name].to_s.empty? == false #Adding an artist Statement
      @artistexists = Artist.find_by_name(params[:artist][:name])
      if @artistexists.nil? == true
        @album.artists.build(params[:artist])
      else
        @album.artists << Artist.find_by_name(params[:artist][:name])   
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
    if params[:source][:name].to_s.empty? == false #Adding an source Statement
      @sourceexists = Source.find_by_name(params[:source][:name])
      if @sourceexists.nil? == true
        @album.sources.build(params[:source])
      else
        @album.sources << Source.find_by_name(params[:source][:name])   
      end
    end
    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to @album, :notice => 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @album.errors, :status => :unprocessable_entity }
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
