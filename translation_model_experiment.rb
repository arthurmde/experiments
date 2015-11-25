# encoding: UTF-8

# French  Probability - THE
# total    1.0
# de   0.40791043647218106
# la   0.22426913868426165
# le   0.11747731937900212
# les    0.0868100441804861
# des    0.04161134405037424
# à    0.030690423579195384
# que    0.027788415221866848
# du   0.02005683015993737


# French  Probability - HEAR
# total    1.0
# Je   0.20237368916010756
# de   0.18004927962405007
# que    0.14729253260625713
# à    0.12216939423151771
# le   0.09173425857610402
# Nous   0.08532989517053484
# qui    0.07577627279876269
# M.   0.04613236863035644


require 'rubygems'
require 'n_gram'
require 'words_counted'

# Leitura das 9000 palavras

fr = File.foreach('fr.txt').first(9000)
fr.map! {|f| f.split(" ")}

fr_words = {}
fr.each {|f| fr_words[f.first] = f[1].to_i}

puts "French words: #{fr_words.count}"

en = File.foreach('en.txt').first(9000)
en.map! {|f| f.split(" ")}

en_words = {"unknown" => 0}
en.each {|f| en_words[f.first] = f[1].to_i}

puts "English words: #{en_words.count}"

# Probabilidade de cada palavra
pr_translation = {}

en_words.each do |key, value|
  pr_translation[key] = {}
end

alignment = {}

en_words.each do |key, value|
  alignment[key] = {:total => 0.0}
end

pr_translation = {}

en_words.each do |key, value|
  pr_translation[key] = {:total => 0.0}
end

en_count = {}

en_words.each do |key, value|
  en_count[key] = {:total => 0.0}
end

fr_alignment = {}

fr_words.each do |key, value|
  fr_alignment[key] = {:total => 0.0}
end

puts pr_translation.first

# # fertilities
# fertilities = {}

# en_words.each do |key, value|
#   fertilities[key] = {}
#   25.times do |i|
#     fertilities[key][i] = 0
#   end
# end


fr_phrases = File.foreach('europarl-v7.fr-en.fr').first(20000)
en_phrases = File.foreach('europarl-v7.fr-en.en').first(20000)


3.times do |n|
  puts n
  en_phrases.each_with_index do |phrase, i|
    en_ws = phrase.split(" ")
    fr_ws = fr_phrases[i].split(" ")

    next if fr_ws.count > 25


    en_ws.each do |e|
      z = 0.0
      e = "unknown" unless en_words.has_key?(e)
      fr_ws.each_with_index do |f, j|
        if !pr_translation[e].has_key?(f)
          pr_translation[e][f] = 1/9000.0
        end

        z = z + pr_translation[e][f]
      end

      fr_ws.each_with_index do |f, j|
        c = (pr_translation[e][f]/z)

        if !en_count[e].has_key?(f)
          en_count[e][f] = 0.0
        end

        en_count[e][f] = en_count[e][f] + c
        en_count[e][:total] = en_count[e][:total] + c
      end
    end

    en_ws.each do |e|
      e = "unknown" unless en_words.has_key?(e)
      en_count[e].each do |k, v|
        pr_translation[e][k] = (en_count[e][k]/en_count[e][:total])
      end
    end
  end
end


temp = pr_translation["the"].sort_by {|_key, value| value}.reverse
puts "French\tProbability"
i = 0
temp.each do |k, v|
  puts "#{k} \t #{v}"
  i = i + 1
  break if i > 8
end

if pr_translation.has_key? "hear"
  temp = pr_translation["hear"].sort_by {|_key, value| value}.reverse
  puts "French\tProbability"
  i = 0
  temp.each do |k, v|
    puts "#{k} \t #{v}"
    i = i + 1
    break if i > 8
  end
end

# fr_alignment

# en_phrases.each_with_index do |phrase, k|
#   en_ws = phrase.split(" ")
#   fr_ws = fr_phrases[k].split(" ")

#   next if fr_ws.count > 25

#   a = []
#   fr_ws.each_with_index do |f, i|
#     # e = "unknown" unless en_words.has_key?(e)
#     # alignment[e][:total] = alignment[e][:total] + fr_ws.count
#     er_ws.each_with_index do |e, j|
#       alignment[e][f] = alignment[e].has_key?(f) ? alignment[e][f]+1 : 1
#       #puts j
#       fertilities[e][j] = fertilities[e][j] + alignment[e][f]
#     end
#   end
# end

# en_words.each do |key, value|
#   sum = 0.0
#   25.times do |i|
#     sum = sum + fertilities[key][i]
#   end

#   next if sum == 0
#   25.times do |i|
#     fertilities[key][i] = (fertilities[key][i]/sum).to_f
#   end
# end




# puts alignment["the"]["la"], fertilities["the"]



# File readed from: http://www.statmt.org/europarl/

# puts "Total sentences: #{total.size}"
# # # Array per line

# test = total.select {|x| x.split(" ").size < 10}

# training = total - test

# puts "Training sentences: #{training.size}"
# puts "Test sentences: #{test.size}"

# puts "Creating the trigram..."
# t1 = Time.now
# # processing...
# trigram = NGram.new(training, :n => 3)
# t2 = Time.now
# delta = t2 - t1
# puts "It takes #{delta} seconds"

# test.last(38).each do |t|
#   t1 = Time.now
#   puts "="*100
#   puts "Test for: #{t}"

#   sentence_words = t.split(" ")
#   permutations = sentence_words.permutation(sentence_words.size).to_a

#   best = ""
#   score = -1

#   permutations.each do |p|
#     sentence = p.map { |s| "#{s}" }.join(' ')
#     test_gram = NGram.new([sentence], :n => 3)

#     p_score = 0
#     test_gram.ngrams_of_all_data[3].each do |key, value|
#       value = trigram.ngrams_of_all_data[3][key.to_s]
#       value = 0 if value.nil?
#       p_score = p_score + value
#     end

#     if p_score > score
#       best = p
#       score = p_score
#     end
#   end

#   t2 = Time.now
#   delta = t2 - t1

#   puts "Result (#{score}): #{best.join(' ')}"
#   puts "It takes #{delta} seconds"
#   puts "="*100
# end
