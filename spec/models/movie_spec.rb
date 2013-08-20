require 'spec_helper'

describe Movie do
  describe 'list movies with same director as this object' do
    before :each do
      with_director = [
        {:director => 'A director', :title => 'Amelie', :rating => 'R', :release_date => '25-Apr-2001'},
        {:director => 'A director', :title => 'Chocolat', :rating => 'PG-13', :release_date => '5-Jan-2001'},
        {:director => 'A director', :title => 'The Help', :rating => 'PG-13', :release_date => '10-Aug-2011'},
        {:director => 'A director', :title => 'The Terminator', :rating => 'R', :release_date => '26-Oct-1984'},
        {:director => 'A director', :title => 'When Harry Met Sally', :rating => 'R', :release_date => '21-Jul-1989'},
      ]
      without_director = [
        {:title => '2001: A Space Odyssey', :rating => 'G', :release_date => '6-Apr-1968'},
        {:title => 'Aladdin', :rating => 'G', :release_date => '25-Nov-1992'},
        {:title => 'Chicken Run', :rating => 'G', :release_date => '21-Jun-2000'},
        {:title => 'Raiders of the Lost Ark', :rating => 'PG', :release_date => '12-Jun-1981'},
        {:title => 'The Incredibles', :rating => 'PG', :release_date => '5-Nov-2004'},
      ]
      @movies_with_director=[]
      with_director.each do |movie|
        m=Movie.new(movie)
        @movies_with_director << m
        m.save!
      end
      @movies_without_director=[]
      without_director.each do |movie|
        m=Movie.new(movie)
        @movies_without_director << m
        m.save!
      end
    end
       
    it 'should return list of movies with the same director when filled' do
      m = @movies_with_director[0]
      m.find_similars_by_director.should == @movies_with_director
    end
    it 'should return nil when no director available' do
      m = @movies_without_director[0]
      m.find_similars_by_director.should == nil
    end
  end
end