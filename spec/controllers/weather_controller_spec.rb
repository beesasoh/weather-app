require 'rails_helper'

RSpec.describe WeatherController, type: :controller do

  describe "GET #index" do

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

  end

  describe 'XHR #get_weather_info' do
    it "returns success" do
    	@params = {:city=> "xxxxcxcc", :country => ""}
    	xhr :post, :get_weather_info, @params

		expect(response).to have_http_status(:success)    	
    end

    it "sets @weather param when city is valid" do
    	@params = {:city=> "kampala", :country => "UG"}

    	weather_service = WeatherService.new(@params[:city], @params[:country]) 
    	FakeWeb.register_uri(:get, weather_service.webserive_uri, :body => '{"coord":{"lon":32.58,"lat":0.32},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"stations","main":{"temp":26,"pressure":1019,"humidity":61,"temp_min":26,"temp_max":26},"visibility":9000,"wind":{"speed":3.6,"deg":180},"clouds":{"all":20},"dt":1500462000,"sys":{"type":1,"id":6505,"message":0.0023,"country":"UG","sunrise":1500436318,"sunset":1500480005},"id":232422,"name":"Kampala","cod":200}' )
 		
    	xhr :post, :get_weather_info, @params

    	expect(assigns(:weather).class).to eq(Weather)
    end

    it "sets @error incase city is not found" do
    	@params = {:city=> "xxxxcxcc", :country => ""}

    	weather_service = WeatherService.new(@params[:city], @params[:country]) 
    	FakeWeb.register_uri(:get, weather_service.webserive_uri, :body => '{"cod":"404","message":"city not found"}')

    	xhr :post, :get_weather_info, @params

    	expect(assigns(:error).class).to eq(String)
    end

  end

end
