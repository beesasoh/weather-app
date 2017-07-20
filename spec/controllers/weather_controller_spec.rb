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

    describe "assigns @random_weather_locations" do

      context "when server returns success JSON" do

        it "returns array of weather objects" do
          FakeWeb.register_uri(:get, WeatherService.group_webservice_url, :body => '{"cnt":2,"list":[{"coord":{"lon":13.41,"lat":52.52},"sys":{"type":1,"id":4892,"message":0.044,"country":"DE","sunrise":1500520129,"sunset":1500578148},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"main":{"temp":24,"pressure":1009,"humidity":64,"temp_min":24,"temp_max":24},"visibility":10000,"wind":{"speed":3.6,"deg":170},"clouds":{"all":40},"dt":1500541937,"id":2950159,"name":"Berlin"},{"coord":{"lon":32.58,"lat":0.32},"sys":{"type":1,"id":6505,"message":0.002,"country":"UG","sunrise":1500522722,"sunset":1500566408},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"main":{"temp":24,"pressure":1021,"humidity":73,"temp_min":24,"temp_max":24},"visibility":9000,"wind":{"speed":1.5,"deg":290},"clouds":{"all":20},"dt":1500541937,"id":232422,"name":"Kampala"}]}')
          
          get :index

          expect(assigns(:random_weather_locations).class).to eq(Array)
          expect(assigns(:random_weather_locations).first.class).to eq(Weather)
        end
      end

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
