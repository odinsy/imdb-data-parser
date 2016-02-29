FactoryGirl.define do
  factory :movie do
    list { build(:movie_list) }
    attributes = ["http://www.imdb.com/title/tt0111161/", "The Shawshank Redemption", "1994", "USA", "1994-10-14", "Crime,Drama", "142", "9.3", "Frank Darabont", "Tim Robbins,Morgan Freeman,Bob Gunton"]
    initialize_with { new(list, attributes) }
  end
  factory :classic_movie, class: Movie::ClassicMovie do
    list { build(:my_movie_list) }
    attributes = ["http://www.imdb.com/title/tt0052561/", "Anatomy of a Murder", "1959", "USA", "1959-09", "Crime,Drama,Mystery,Thriller", "160", "8.1", "Otto Preminger", "James Stewart,Lee Remick,Ben Gazzara"]
    initialize_with { new(list, attributes) }
  end
  factory :ancient_movie, class: Movie::AncientMovie do
    list { build(:my_movie_list) }
    attributes = ["http://www.imdb.com/title/tt0017925/", "The General", "1926", "USA", "1929", "Action,Adventure,Comedy,Drama,War", "67", "8.3", "Clyde BruckmanBuster Keaton", "Buster Keaton,Marion Mack,Glen Cavender"]
    initialize_with { new(list, attributes) }
  end
  factory :modern_movie, class: Movie::ModernMovie do
    list { build(:my_movie_list) }
    attributes = ["http://www.imdb.com/title/tt0094625/", "Акира", "1988", "Japan", "1988-07-16", "Animation,Action,Sci-Fi", "124", "8.1", "Katsuhiro Ôtomo", "Nozomu Sasaki,Mami Koyama,Mitsuo Iwata"]
    initialize_with { new(list, attributes) }
  end
  factory :new_movie, class: Movie::NewMovie do
    list { build(:my_movie_list) }
    attributes = ["http://www.imdb.com/title/tt0118694/", "In the Mood for Love", "2000", "Hong Kong", "2001-03-09", "Drama,Romance", "98", "8.1", "Kar-wai Wong", "Tony Chiu Wai Leung,Maggie Cheung,Ping Lam Siu"]
    initialize_with { new(list, attributes) }
  end
end
