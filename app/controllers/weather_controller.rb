class WeatherController < ApplicationController

  def index
  end

  def get_weather_info
  	city = params[:city]
  	country = params[:country]

  	weather_results = WeatherService.new(city, country).get_weather_info

  	if weather_results.success
  		@weather = weather_results.weather_info
  	else
  		@error = weather_results.error_message
  	end

  end

end
