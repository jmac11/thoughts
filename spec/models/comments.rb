require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  
  before(:each) do
    @blog = Blog.create :title => "My Blog", :tagline => "My Tagline", :permalink => "/:year/:month/:day/:title"
    @user = User.create :blog => @blog, :openid => "http://whoisjake.myopenid.com", :name => "Jake Good"
    
    @post = Post.create :title => "My Test Post", :body => "Test Post Body", :user => @user
    @comment = Comment.new
    @comment.post = @post
  end
  
  it "can set values." do
    @comment.body = "My comment"
    @comment.name = "Jake"
    @comment.email = "jake@whoisjake.com"
    @comment.ip_address = "127.0.0.1"
    @comment.website = "http://thoughtstoblog.com"
  end
  
  it "can be saved." do
    @comment.body = "My comment"
    @comment.name = "Jake"
    @comment.email = "jake@whoisjake.com"
    @comment.ip_address = "127.0.0.1"
    @comment.website = "http://thoughtstoblog.com"
    @comment.save
    
    @post.comments.should include(@comment)
  end
  
  it "can be spam filtered" do
    @comment.body = "My comment"
    @comment.name = "Jake"
    @comment.email = "jake@whoisjake.com"
    @comment.ip_address = "127.0.0.1"
    @comment.website = "http://thoughtstoblog.com"
    @comment.splam?.should == false
    @comment.splam_score.should == 0
  end
  
  it "should filter out bad words." do
    @comment.body = "buy my cheap sexy gay porn viagra"
    @comment.splam?.should == true
    @comment.splam_score.should == 54 # buy(4) sexy(10,10) gay(10) porn(10) viagra(10)
  end

end