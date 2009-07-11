require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Merb::LinksHelper do
  include Merb::LinksHelper

  describe "display_downloading_time" do
    it "should display seconds" do
      display_downloading_time(59).should == '00:00:59'
    end

    it "should display minutes" do
      display_downloading_time(61).should == '00:01:01'
    end

    it "should display hours" do
      display_downloading_time(3661).should == '01:01:01'
    end
  end
end