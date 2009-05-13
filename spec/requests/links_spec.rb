require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a link exists" do
  Link.delete_all
  request(resource(:links), :method => "POST", 
    :params => { :link => { :id => nil }})
end

describe "resource(:links)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:links))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of links" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a link exists" do
    before(:each) do
      @response = request(resource(:links))
    end
    
    it "has a list of links" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Link.delete_all
          @response = request(resource(:links), :method => "POST", 
        :params => { :link => { :id => nil }})
    end
    
    it "redirects to resource(:links)" do
      @response.should redirect_to(resource(Link.first), :message => {:notice => "link was successfully created"})
          end
    
  end
end

describe "resource(@link)" do 
  describe "a successful DELETE", :given => "a link exists" do
     before(:each) do
       @response = request(resource(Link.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:links))
     end

   end
end

describe "resource(:links, :new)" do
  before(:each) do
    @response = request(resource(:links, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@link, :edit)", :given => "a link exists" do
  before(:each) do
    @response = request(resource(Link.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@link)", :given => "a link exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Link.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @link = Link.first
      @response = request(resource(@link), :method => "PUT", 
        :params => { :link => {:id => @link.id} })
    end
  
    it "redirect to the link show action" do
      @response.should redirect_to(resource(@link))
    end
  end
  
end

