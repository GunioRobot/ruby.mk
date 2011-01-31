require 'spec_helper'

describe Admin::PostsController do
  describe "index posts" do
    before :each do
      login
      @posts_mock = [mock_model(Post)]
      Post.stub!(:paginate).and_return(@posts_mock)
    end

    it "should render list of posts successfully" do
      Post.should_receive(:paginate).and_return([@posts_mock])
      get :index
      response.should be_success
      assigns(:posts).should_not be_nil
    end
  end

  describe "new post" do
    before :each do
      login
      Post.stub!(:new).and_return(@mock_object = mock_model(Post))
    end

    it "should render new post successfully" do
      Post.should_receive(:new).with().and_return(@mock_object)
      get :new
      response.should be_success
      assigns(:post).should_not be_nil
    end
  end

  describe "show post" do
    before :each do
      login
      Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post))
    end

    it "should render new comment successfully" do
      Post.should_receive(:find).with("1").and_return(@mock_object)
      get :show, :id => "1"
      response.should be_success
      assigns(:post).should_not be_nil
    end
  end

  describe "new post create valid" do
    before :each do
      login
      Post.stub!(:new).and_return(@mock_object = mock_model(Post, :save=>true))
    end

    it "should initialize new post successfully" do
      Post.should_receive(:new).with("name"=>"value").and_return(@mock_object)
      post :create, :post=>{:name=>"value"}
    end

    it "should save the post successfully" do
      @mock_object.should_receive(:save).and_return(true)
      post :create, :post=>{:name=>"value"}
      #    assigns[:post].should_not be_new_record
    end

    it "should have response with redirect" do
      post :create, :post=>{:name=>"value"}
      response.should be_redirect
    end

    it "should assign post" do
      post :create, :post=>{:name=>"value"}
      assigns(:post).should == @mock_object
    end

    it "should set flash notice" do
      post :create, :post=>{:name=>"value"}
      flash[:notice].should == 'Post was created successfully'
    end

    it "should have response with redirect to the admin post path" do
      post :create, :post=>{:name=>"value"}
      response.should redirect_to(admin_post_url(@mock_object))
    end
  end

  describe "new post create invalid" do
    before :each do
      login
      Post.stub!(:new).and_return(@mock_object = mock_model(Post, :save=>false))
    end

    it "should initialize new post successfully" do
      Post.should_receive(:new).with("name"=>"value").and_return(@mock_object)
      post :create, :post=>{:name=>"value"}
    end

    it "should not save the post" do
      @mock_object.should_receive(:save).and_return(false)
      post :create, :post=>{:name=>"value"}
    end

    it "response should be success" do
      post :create, :post=>{:name=>"value"}
      response.should be_success
    end

    it "should assign post" do
      post :create, :post=>{:name=>"value"}
      assigns(:post).should == @mock_object
    end

    it "should render new action" do
      post :create, :post=>{:name=>"value"}
      response.should render_template("new")
    end
  end

  describe "edit post" do
    before :each do
      login
      Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post))
    end

    it "should render edit post successfully" do
      Post.should_receive(:find).with("1").and_return(@mock_object)
      get :edit, :id => "1"
      response.should be_success
      assigns(:post).should_not be_nil
    end
  end

  describe "update post with valid params" do
    before :each do
      login
      Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post, :update_attributes=>true))
    end

    it "should find post successfully" do
      Post.should_receive(:find).with("1").and_return(@mock_object)
      put :update, :id => "1", :post=>{}
    end

    it "should update post attributes successfully" do
      @mock_object.should_receive(:update_attributes).and_return(true)
      put :update, :id => "1", :post => {}
    end

    it "should have response with redirect" do
      put :update, :id => "1", :post=>{}
      response.should be_redirect
    end

    it "should assign post" do
      put :update, :id => "1", :post=>{}
      assigns(:post).should == @mock_object
    end

    it "should set flash notice" do
      put :update, :id => "1", :post=>{}
      flash[:notice].should == 'Post was updated successfully'
    end

    it "should have response with redirect to the admin post path" do
      put :update, :id => "1", :post=>{}
      response.should redirect_to(admin_post_url(@mock_object))
    end

  end

  describe "update post with invalid params" do
    before :each do
      login
      Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post, :update_attributes=>false))
    end

    it "should find post successfully" do
      Post.should_receive(:find).with("1").and_return(@mock_object)
      put :update, :id => "1", :post=>{}
    end

    it "should not update the post attributes" do
      @mock_object.should_receive(:update_attributes).and_return(false)
      put :update, :id => "1", :post => {}
    end

    it "response should render edit action" do
      put :update, :id => "1", :post=>{}
      response.should render_template("edit")
    end
  end

  describe "delete post" do
    before :each do
      login
      Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post))
    end

    it "should render delete post successfully" do
      Post.should_receive(:find).with("1").and_return(@mock_object)
      get :delete, :id => "1"
      response.should be_success
      assigns(:post).should_not be_nil
    end
  end

  describe "destroy post" do
    before :each do
      login
      Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post, :destroy => true))
    end

    it "should find post successfully" do
      Post.should_receive(:find).with("1").and_return(@mock_object)
      delete :destroy, :id => "1"
    end

    it "should destroy post successfully" do
      @mock_object.should_receive(:destroy).and_return(true)
      delete :destroy, :id => "1"
    end

    it "response should be redirect" do
      delete :destroy, :id => "1"
      response.should be_redirect
    end

    it "should set flash notice" do
      delete :destroy, :id => "1"
      flash[:notice].should == 'Post was deleted successfully'
    end

    it "should redirect to the admin post path" do
      delete :destroy, :id => "1"
      response.should redirect_to(admin_posts_url)
    end
  end

  describe "invalid credentals" do
    it "should protect from accessing posts list in administration " do
      get :index
      response.code.should == "302" # unauthorized
    end

    it "should protect from accessing post 1 in administration " do
      get :show, :id => 1
      response.code.should == "302" # unauthorized
    end

    it "should protect from accessing edit post 1 in administration " do
      get :edit, :id => 1
      response.code.should == "302" # unauthorized
    end

    it "should protect from accessing new post form in administration " do
      get :new
      response.code.should == "302" # unauthorized
    end

    it "should protect from accessing create post in administration " do
      post :create, :post => {:title => "something"}
      response.code.should == "302" # unauthorized
    end

    it "should protect from accessing update post in administration " do
      put :create, :id => 1, :post => {:title => "something"}
      response.code.should == "302" # unauthorized
    end

    it "should protect from accessing delete post in administration " do
      delete :destroy, :id => 1
      response.code.should == "302" # unauthorized
    end
  end
end
