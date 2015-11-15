class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    @all_ratings = Movie.ratings
    @sort = params[:sort]
    @ratings = params[:ratings]
    #check deployment
    if params[:ratings].nil? and session[:ratings].nil?
      @ratings = @all_ratings
      params[:ratings] = @all_ratings
      session[:ratings] = @all_ratings
      @movies = Movie.find_all_by_rating(@ratings.keys)
    end
    if params[:sort] == session[:sort] and params[:ratings] == session[:ratings]
      if params[:sort].nil?
        @ratings = params[:ratings]
        @movies = Movie.find_all_by_rating(params[:ratings].keys)
      else
        @ratings = params[:ratings]
        @movies = Movie.order(params[:sort]).find_all_by_rating(params[:ratings].keys)
      end
    else
      if !params[:sort].nil?
        session[:sort] = params[:sort]
      end
      if !params[:ratings].nil?
        session[:ratings] = params[:ratings]
      end
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
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

end
