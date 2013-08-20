require 'spec_helper'

describe MoviesController do
  describe 'list similar movies operation' do
    before :each do
      @movie=mock('movie1', :director => 'A director', :find_similars_by_director =>nil)
    end
    it 'should call find on Model object for given id to get movie' do
      Movie.should_receive(:find).with('1').and_return(@movie)
      get :find_by_director, {:id=>1}
    end
    it 'should render index when movie found for given id has no director' do
      Movie.stub(:find).with('1').and_return(Movie.new)
      get :find_by_director, {:id=>1}
      response.should redirect_to movies_path
    end
    it 'should notify warning when no director info' do
      Movie.stub(:find).with('1').and_return(Movie.new)
      get :find_by_director, {:id=>1}
      flash[:warning].should_not == nil
    end
    it 'should call on model method when object found has director' do
      Movie.stub(:find).with('1').and_return(@movie)
      @movie.should_receive(:find_similars_by_director).with(no_args)
      get :find_by_director, {:id=>1}
    end
    it 'should render similar movies when search succeed' do
      mlist=[@movie,mock('movie2', :director => 'A director')]
      Movie.stub(:find).with('1').and_return(@movie)
      @movie.should_receive(:find_similars_by_director).with(no_args).and_return(mlist)
      get :find_by_director, {:id=>1}
      response.should render_template('find_by_director')
    end
    it 'should provide results to the view' do
      mlist=[@movie,mock('movie2', :director => 'A director')]
      Movie.stub(:find).with('1').and_return(@movie)
      @movie.stub(:find_similars_by_director).and_return(mlist)
      get :find_by_director, {:id=>1}
      assigns(:movies).should == mlist
    end
  end
  
  describe 'create movie operation' do
    before :each do
      @title = "A title"
      lambda{Movie.find_by_title!(@title)}.should raise_error(ActiveRecord::RecordNotFound)
      post :create, {:movie=>{:title=>@title}}
    end
    it 'should create a movie on db with params received' do
      lambda{Movie.find_by_title!(@title)}.should_not raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should notify success' do
      flash[:notice].should_not==nil
    end
    it 'should redirect to index' do
      response.should redirect_to movies_path
    end
  end

  describe 'delete movie operation' do
    before :each do
      @movie=Movie.create!(:title=>'Any random title')
      lambda{Movie.find(@movie.id)}.should_not raise_error(ActiveRecord::RecordNotFound)
      post :destroy, {:id=>@movie.id}
    end

    it 'should delete a movie for given id' do
      lambda{Movie.find(@movie.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should notify success' do
      flash[:notice].should_not==nil
    end
    it 'should redirect to index' do
      response.should redirect_to movies_path
    end
  end
end