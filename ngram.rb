# encoding: UTF-8

require 'rubygems'
require 'n_gram'
require 'words_counted'


total = File.foreach('europarl-v7.pt-en.pt').first(250000)
# total = File.foreach('europarl-v7.fr-en.en').first(250000)
# File readed from: http://www.statmt.org/europarl/

puts "Total sentences: #{total.size}"
# # Array per line

test = total.select {|x| x.split(" ").size < 10}

training = total - test

puts "Training sentences: #{training.size}"
puts "Test sentences: #{test.size}"

puts "Creating the trigram..."
t1 = Time.now
# processing...
trigram = NGram.new(training, :n => 3)
t2 = Time.now
delta = t2 - t1
puts "It takes #{delta} seconds"

test.last(38).each do |t|
  t1 = Time.now
  puts "="*100
  puts "Test for: #{t}"

  sentence_words = t.split(" ")
  permutations = sentence_words.permutation(sentence_words.size).to_a

  best = ""
  score = -1

  permutations.each do |p|
    sentence = p.map { |s| "#{s}" }.join(' ')
    test_gram = NGram.new([sentence], :n => 3)

    p_score = 0
    test_gram.ngrams_of_all_data[3].each do |key, value|
      value = trigram.ngrams_of_all_data[3][key.to_s]
      value = 0 if value.nil?
      p_score = p_score + value
    end

    if p_score > score
      best = p
      score = p_score
    end
  end

  t2 = Time.now
  delta = t2 - t1

  puts "Result (#{score}): #{best.join(' ')}"
  puts "It takes #{delta} seconds"
  puts "="*100
end
