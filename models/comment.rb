class Comment < Sequel::Model
  many_to_one :post
  
  include Splam
  splammable :body do |splam|
    splam.threshold = 40
    splam.rules = [:bad_words, :html, :bbcode, :href, :chinese, :line_length, :russian]
  end
  
end