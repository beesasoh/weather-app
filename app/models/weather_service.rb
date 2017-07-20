class WeatherService

	attr_accessor :city, :country

	def initialize city, country=nil
		@city = city
		@country = country
	end

	def get_weather_info
		begin
			response_json = HTTParty.get(webserive_uri).body
			LOGGER.info("Server response: #{response_json}")
			
			response_hash = JSON.parse(response_json)
			cod = response_hash["cod"]

			if cod == 200
				weather = Weather.new_instance(response_hash)

				if weather.nil?
					return WeatherRequestResults.new(false, nil, "Failed to read weather information" )
				else
					return WeatherRequestResults.new(true, Weather.new_instance(response_hash), nil )
				end
			elsif cod == "404"
				return WeatherRequestResults.new(false, nil, "City not found" )
			else
				return WeatherRequestResults.new(false, nil, "An error occured. Please try again" )
			end

		rescue Exception => e
			LOGGER.error("WeatherService#get_weather_info ERROR:- #{e}")

			message = "Something went wrong. Please check your internet connection and try again"
			return WeatherRequestResults.new(false, nil, message)
		end
	end

	def webserive_uri
		q = country.nil? ? city : "#{city},#{country}"
		url = "#{APP_CONFIGS[:api_url]}?q=#{q}&appid=#{APP_CONFIGS[:api_key]}&units=#{APP_CONFIGS[:units]}"
		uri = URI::encode(url)

		LOGGER.info("Webserivce URI returned as: #{url}")
		return uri
	end

	def self.group_webservice_url
		id = APP_CONFIGS[:key_cities].sample(20).join(",")
		url = "#{APP_CONFIGS[:api_url_group]}?id=#{id}&appid=#{APP_CONFIGS[:api_key]}&units=#{APP_CONFIGS[:units]}"
		uri = URI::encode(url)

		LOGGER.info("Group Webserivce URI returned as: #{url}")
		return uri
	end

	def self.get_group_weather_info

		begin
			response_json = HTTParty.get(group_webservice_url).body
			LOGGER.info("get_group_weather_info | Server response: #{response_json}")

			response_hash = JSON.parse(response_json)
			
			if response_hash["list"]

				return response_hash["list"].map{|weather_item| Weather.new_instance(weather_item) }
			else
				return []
			end

		rescue Exception => e
			LOGGER.error("get_group_weather_info | ERROR: #{e}")
			return []
		end
		
	end

end