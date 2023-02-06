require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe "GET /index" do
    it "returns a 200" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /answer" do
    before do 
      session[:rails_method] = "FILTER"
      session[:answers] = []
    end

    it "return a 200" do
      post :answer, params: { game: { answer: "FILTER" } }, format: :turbo_stream
      expect(response).to have_http_status(:ok)
    end
  end

  describe "compute_colors(solution, answers)" do
    it "return all green when good word" do
      colors = controller.send(:compute_colors, "FILTER", ["FILTER"] )[0][0]
      expect(colors).to eq(["green", "green", "green", "green", "green", "green"])
    end
  
    it "return nothing when everything is wrong" do
      colors = controller.send(:compute_colors, "EACH", ["FIND"] )[0][0]
      expect(colors).to eq([nil, nil, nil, nil])
    end
  
    it "return some oranges when there are misplaced letters" do
      colors = controller.send(:compute_colors, "REVERSE", ["FLATTEN"] )[0][0]
      expect(colors).to eq([nil, nil, nil, nil, nil, "orange", nil])
    end
  
    it "correct edge case EXTENSIONS / EACH_SLICE " do
      colors = controller.send(:compute_colors, "EXTENSIONS", ["EACH_SLICE"] )[0][0]
      expect(colors).to eq(["green", nil, nil, nil, nil, "green", nil, "orange", nil, "orange"])
    end
  end
end