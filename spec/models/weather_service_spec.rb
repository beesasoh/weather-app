require 'rails_helper'

RSpec.describe WeatherService, type: :model do
 	
 	describe 'Methods' do

 		let(:weather_service) { WeatherService.new("Kampala", "UG") }
 		
 		describe 'get_weather_info' do

 			context "when city is valid" do

 				before(:each) do
 					FakeWeb.register_uri(:get, weather_service.webserive_uri, :body => '{"coord":{"lon":32.58,"lat":0.32},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"stations","main":{"temp":26,"pressure":1019,"humidity":61,"temp_min":26,"temp_max":26},"visibility":9000,"wind":{"speed":3.6,"deg":180},"clouds":{"all":20},"dt":1500462000,"sys":{"type":1,"id":6505,"message":0.0023,"country":"UG","sunrise":1500436318,"sunset":1500480005},"id":232422,"name":"Kampala","cod":200}' )
 				end

 				let(:results) { weather_service.get_weather_info }

 				it "returns WeatherRequestResults object" do
 					expect(results.class).to eq(WeatherRequestResults)
 				end

 				it "returns success as true" do
 					expect(results.success).to eq(true)
 				end

 				it "results contains weather object" do
 					expect(results.weather_info.class).to eq(Weather)
 				end

 			end

 			context "city is invalid" do

 				before(:each) do
 					FakeWeb.register_uri(:get, weather_service.webserive_uri, :body => '{"cod":"404","message":"city not found"}')
 				end

 				let(:results) { weather_service.get_weather_info }

 				it "returns WeatherRequestResults object" do
 					expect(results.class).to eq(WeatherRequestResults)
 				end

 				it "returns success as false" do
 					expect(results.success).to eq(false)
 				end

 				it "returns error message" do
 					expect(results.error_message).to eq("City not found")
 				end
 			end

 			context "when server returns an unknow cod " do 
 				before(:each) do
 					FakeWeb.register_uri(:get, weather_service.webserive_uri, :body => '{"cod":500,"message":"city not found"}')
 				end
 				let(:results) { weather_service.get_weather_info }

 				it "returns WeatherRequestResults object" do
 					expect(results.class).to eq(WeatherRequestResults)
 				end

 				it "returns success as false" do
 					expect(results.success).to eq(false)
 				end
 			end

 			context "when server returns no response " do 
 				before(:each) do
 					FakeWeb.register_uri(:get, weather_service.webserive_uri, :body => '')
 				end

 				let(:results) { weather_service.get_weather_info }

 				it "returns WeatherRequestResults object" do
 					expect(results.class).to eq(WeatherRequestResults)
 				end

 				it "returns success as false" do
 					expect(results.success).to eq(false)
 				end
 			end

 			context "when request Timeout" do 
 				before(:each) do
 					FakeWeb.register_uri(:get, weather_service.webserive_uri, :exception => Timeout::Error)
 				end
 				
 				let(:results) { weather_service.get_weather_info }

 				it "returns WeatherRequestResults object" do
 					expect(results.class).to eq(WeatherRequestResults)
 				end

 				it "returns success as false" do
 					expect(results.success).to eq(false)
 				end
 			end

 			context "when server returns success but fails to read weather params" do
 				before(:each) do
 					FakeWeb.register_uri(:get, weather_service.webserive_uri, :body => '{"coord":{"lon":32.58,"lat":0.32},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"stations","no-main":{"temp":26,"pressure":1019,"humidity":61,"temp_min":26,"temp_max":26},"visibility":9000,"wind":{"speed":3.6,"deg":180},"clouds":{"all":20},"dt":1500462000,"sys":{"type":1,"id":6505,"message":0.0023,"sunrise":1500436318,"sunset":1500480005},"id":232422,"name":"Kampala","cod":200}' )
 				end

 				let(:results) { weather_service.get_weather_info }

 				it "returns WeatherRequestResults object" do
 					expect(results.class).to eq(WeatherRequestResults)
 				end

 				it "returns success as false" do
 					expect(results.success).to eq(false)
 				end
 				
 			end

 		end   


 		describe 'webserive_uri' do

 			context "when city and country are provided" do
 				it "returns URL with city and country params" do
 					expected_uri = URI::encode("#{APP_CONFIGS[:api_url]}?q=Kampala,UG&appid=#{APP_CONFIGS[:api_key]}&units=#{APP_CONFIGS[:units]}")
 					expect(weather_service.webserive_uri).to eq(expected_uri)
 				end
 			end

 			context "when only city is provided" do
 				it "returns URL with city and country params" do
 					weather_service.country = nil
 					expected_uri = URI::encode("#{APP_CONFIGS[:api_url]}?q=Kampala&appid=#{APP_CONFIGS[:api_key]}&units=#{APP_CONFIGS[:units]}")
 					expect(weather_service.webserive_uri).to eq(expected_uri)
 				end
 			end

 		end


 		describe 'Self.get_group_weather_info' do

 		  	context "when correct city ids" do

 		  		before(:each) do
 					FakeWeb.register_uri(:get, WeatherService.group_webservice_url, :body => '{"cnt":2,"list":[{"coord":{"lon":13.41,"lat":52.52},"sys":{"type":1,"id":4892,"message":0.044,"country":"DE","sunrise":1500520129,"sunset":1500578148},"weather":[{"id":802,"main":"Clouds","description":"scattered clouds","icon":"03d"}],"main":{"temp":24,"pressure":1009,"humidity":64,"temp_min":24,"temp_max":24},"visibility":10000,"wind":{"speed":3.6,"deg":170},"clouds":{"all":40},"dt":1500541937,"id":2950159,"name":"Berlin"},{"coord":{"lon":32.58,"lat":0.32},"sys":{"type":1,"id":6505,"message":0.002,"country":"UG","sunrise":1500522722,"sunset":1500566408},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"main":{"temp":24,"pressure":1021,"humidity":73,"temp_min":24,"temp_max":24},"visibility":9000,"wind":{"speed":1.5,"deg":290},"clouds":{"all":20},"dt":1500541937,"id":232422,"name":"Kampala"}]}' )
 				end

 		  		it "returns array of weather objects" do 

 		  			weather_info = WeatherService.get_group_weather_info

 		  			expect(weather_info.class).to eq(Array)
          			expect(weather_info.first.class).to eq(Weather)
 		  		end
 		  	end

 		end
 	end 
 
end
