class WeatherRequestResults
	attr_accessor :success, :weather_info, :error_message

	def initialize success, weather_info, error_message
		@success = success
		@weather_info = weather_info
		@error_message = error_message	
	end

end