require 'rails_helper'

RSpec.describe Weather, type: :model do
  
  describe 'Methods' do

    describe 'get_icon_url' do
      it "returns correct icon URL" do
      	weather = Weather.new
      	weather.icon = "10d"
      	expect(weather.get_icon_url).to eq("http://openweathermap.org/img/w/10d.png")
      end
    end

    describe 'get_flag_url' do
      it "returns correct flag URL" do
      	weather = Weather.new
      	weather.country = "UG" 
      	expect(weather.get_flag_url).to eq("http://openweathermap.org/images/flags/ug.png")
      end
    end

  end
end
