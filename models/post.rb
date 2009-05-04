class Post < Sequel::Model
  many_to_one :user
  one_to_many :comments
  one_to_many :taggings
  
  def before_create
    return false if super == false
    # Set created_at
    self.created_at = Time.now.utc
  end
  
  def publish!
    # Set published
    self.published = true
    # Set published date
    self.published_at = Time.now.utc
    # Set permalink
    self.permalink = Post.create_permalink(self.title,self.published_at)
  end
  
  def self.create_permalink(title, published_at)
    permalink = Blog.default.permalink.gsub(/:year/, published_at.year.to_s)
    
    permalink.gsub!(/:month/, published_at.month.pad)
    permalink.gsub!(/:day/, published_at.day.pad)

    title.gsub!(/\W+/, ' ')
    title.strip!
    title.downcase!
    title.gsub!(/\ +/, '-')
    permalink.gsub!(/:title/,title)
    
    permalink
  end
  
end