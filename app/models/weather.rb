class Weather
	attr_accessor :main, :description, :icon, :city, :country, :temp, :temp_min, :temp_max,
					:pressure, :humidity, :wind_speed


	def self.new_instance(params)
		begin
			weather = Weather.new
			weather.main = params["weather"].first["main"]
			weather.description = params["weather"].first["description"]
			weather.icon = params["weather"].first["icon"]
			weather.city = params["name"]
			weather.country = params["sys"]["country"]
			weather.temp = params["main"]["temp"]
			weather.temp_min = params["main"]["temp_min"]
			weather.temp_max = params["main"]["temp_max"]
			weather.pressure = params["main"]["pressure"]
			weather.humidity = params["main"]["humidity"]
			weather.wind_speed = params["wind"]["speed"]
			return weather
		rescue Exception => e
			LOGGER.error("Weather#new_instance failed to create weather object: #{e}")
			return nil
		end
		
	end

	def get_icon_url
		"http://openweathermap.org/img/w/#{icon}.png"
	end

	def get_flag_url
		"http://openweathermap.org/images/flags/#{country.downcase}.png"
	end

end
