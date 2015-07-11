require "spec_helper"

describe PostsIndex do
  let(:index) { PostsIndex.new }

  describe "search(key)" do
    before(:each) do
      @one = Post.create(title: "One", body: "I'm a post with one", points: 3)
      index.store(@one) #FIXME= this must be performed with a callback
      @two = Post.create(title: "Two", body: "I'm a post with two", points: 7)
      index.store(@two) #FIXME= this must be performed with a callback
      @search = index.search("")
      puts "@search = #{@search.inspect}"
    end

    it "matches records for a given key" do
    end
  end

  after(:each) do
    index.rebuild!
  end
end
