class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings = params[:ratings] || session[:ratings]
     
    #checks if the ratings parameter has been checked
    #if not sets all movies to be shown
    if params[:ratings]
      @ratings_to_show = params[:ratings]
      session[:ratings] = @ratings_to_show
    elsif session[:ratings]
      @ratings_to_show= session[:ratings]
    else
      @ratings_to_show = nil
    end
    
    #
    if params[:sort]
      @sort =params[:sort]
      session[:sort] = @sort
    elsif session[:sort]
      @sort = session[:sort]
    else
      @sort = nil
    end
    
    if !@ratings_to_show
      @ratings_to_show = Hash.new
      @all_ratings.each do |rating|
        @ratings_to_show[rating] = '1'
      end
    end
      
    #@ratings_to_show = params[:ratings] || session[:ratings] || {}
     #if no ratings are clicked - set the checkbox values to clicked
    
    if @ratings_to_show && @sort 
      #if some ratings are clicked - only show the selected ratings
       @movies = Movie.where(:rating => @ratings_to_show.keys).order(@sort)
    elsif @ratings_to_show
      @movies = Movie.where(:rating => @ratings_to_show.keys)
    elsif @sort
      @movies = Movie.all.order(@sort)
    else 
     @movies.all
    end  
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
