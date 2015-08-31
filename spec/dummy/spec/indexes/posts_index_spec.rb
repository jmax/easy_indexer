require "spec_helper"

describe PostsIndex do
  let(:index) { PostsIndex.new }

  describe "search(key)" do
    before(:each) do
      @one = Post.create(title: "One", body: "I'm a post with one", points: 3)
      @one.push_to_posts_index
      @two = Post.create(title: "Two", body: "I'm a post with two", points: 7)
      @two.push_to_posts_index
    end

    it "matches specific records for a given key" do
      @search = index.search("two")
      expect(@search.results.first.body).to eq(@two.body)
    end

    it "throws raw response for a given key" do
      @search = index.search("two")
      expect(@search.raw_results).not_to be_nil
    end
  end
end
