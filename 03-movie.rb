#!/usr/bin/env ruby

if ARGV.empty?
  puts "There are no arguments!"
  exit
end

path = ARGV.shift

if File.exist?(path)
  movies = File.open(path)
else
  puts "File not found: #{path}"
  exit
end

hash = Hash.new {|key, value| key[value]={}} 

movies.readlines.each do |movie|
  movie.chomp!
  link, name, year, country, date, genre, duration, rating, director, actors = movie.split("|")
  actors = actors.split(",")
  hash[name] = { link: link, year: year, country: country, date: date, genre: genre, duration: duration, rating: rating, director: director, actors: actors }
end   

puts "5 longest movies"
puts hash.sort_by { |k, v| v[:duration].gsub!(/ min/, '').to_i }.last(5)

puts "\nComedy sorted by release date"
puts hash.select { |k, v| v[:genre].include? "Comedy" }.sort_by {|k, v| v[:date] }

puts "\nDirector list: "
puts hash.map { |k, v| v[:director] }.sort.uniq

puts "\nDisplay count of not USA films"
puts hash.reject { |k, v| v[:country] == "USA" }.count

puts "\nDisplay count of films grouped by director"
puts hash.group_by { |x, y| y[:director] }.map { |k, v| [k, v.count] }.sort

puts "\nDisplay count of films for every actor"
h = Hash.new(0)
puts hash.map { |x, y| y[:actors] }.flatten.inject(h) { |acc, n| acc[n] += 1; acc } 



