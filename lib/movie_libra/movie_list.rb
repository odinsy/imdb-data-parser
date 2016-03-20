#!/usr/bin/env ruby

require 'json'
require 'csv'
require 'movie_libra/movie.rb'
require 'movie_libra/rate_list.rb'

module MovieLibra
  class MovieList
    include Enumerable

    attr_accessor :list, :movies, :algos, :filters

    def initialize(data)
      data      = [] unless data.is_a?(Array)
      @list     = self
      @movies   = data.map { |movie| Movie.new(self, movie) }
      @algos    = {}
      @filters  = {}
    end

    # Load from JSON
    def self.load_json(path)
      new(parse_json(path))
    end

    # Load from CSV
    def self.load_csv(path)
      new(parse_csv(path))
    end

    # Print movies
    def print
      @movies.map { |i| puts yield(i) } if block_given?
    end

    # Add sorting algorithm
    def add_sort_algo(algo, &block)
      @algos.store(algo, block)
    end

    # Sorting by algorithm or block
    def sorted_by(algo = nil, &block)
      if @algos.include?(algo)
        algo = @algos[algo]
        @movies.sort_by(&algo)
      elsif block
        @movies.sort_by(&block)
      else
        raise ArgumentError, "Unknown algorithm #{algo}"
      end
    end

    # Add new filter for movie list
    def add_filter(filter, &block)
      @filters.store(filter, block)
    end

    # Call filter on movie list
    def filter(attrs)
      attrs.inject(@movies) do |result, (title, value)|
        filter = @filters[title]
        raise ArgumentError, "Unknown filter #{title}" unless filter
        result.select { |movie| filter.call(movie, *value) }
      end
    end

    # Display the longest movies
    def longest(num)
      @movies.sort_by(&:duration).last(num)
    end

    # Display movies selected by genre
    def select_by_genre(genre)
      @movies.select { |k| k.genre.include? genre }.sort_by(&:date)
    end

    # Display all directors sorted by second name
    def directors
      @movies.map(&:director).sort_by { |words| words.split(' ').last }.uniq
    end

    # Display the count of movies without skipped country
    def skip_country(country)
      @movies.count { |k| k.country != country }
    end

    # Display the count of movies by each director
    def count_by_director
      @movies.group_by(&:director).map { |k, v| [k, v.count] }.sort_by { |_k, v| v }.reverse.to_h
    end

    # Display the movies by director
    def by_director(director)
      @movies.select { |m| m.director == director }.map(&:name)
    end

    # Display the count of movies by each actor
    def count_by_actor
      @movies.map(&:actors).flatten.each_with_object(Hash.new(0)) { |acc, n| n[acc] += 1 }.sort_by { |_k, v| v }.reverse
    end

    # Display the statistics of movies shot each month
    def month_stats
      @movies.map { |k| k.date.mon }.each_with_object(Hash.new(0)) { |acc, n| n[acc] += 1 }.sort
    end

    def each(&block)
      @movies.each(&block)
    end

    protected

    # Parse from JSON to array of hashes
    def self.parse_json(path)
      raise ArgumentError, "File not found: #{path}" unless File.exist?(path)
      JSON.parse(open(path).read, symbolize_names: true)
    end

    # Parse from CSV to array of hashes
    def self.parse_csv(path)
      raise ArgumentError, "File not found: #{path}" unless File.exist?(path)
      CSV.foreach(path, col_sep: '|', headers: true, header_converters: :symbol).map
    end
  end
end
