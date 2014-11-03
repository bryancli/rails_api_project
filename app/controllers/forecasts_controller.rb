require 'open-uri'
require 'json'

class ForecastsController < ApplicationController
  def location

    the_address = params[:address]

    # user address to get coordinates
    url_of_coords_we_want = "http://maps.googleapis.com/maps/api/geocode/json?address=#{the_address}"
    raw_coords_data = open(url_of_coords_we_want).read
    parsed_coords_data = JSON.parse(raw_coords_data)
    the_latitude = parsed_coords_data["results"][0]["geometry"]["location"]["lat"] #already URL safe
    the_longitude = parsed_coords_data["results"][0]["geometry"]["location"]["lng"] #already URL safe

    # use coordinates to get weather forecast
    url_of_weather_we_want = "https://api.forecast.io/forecast/ab5a5fcf35b1bdf9e80eb988b018d46f/#{the_latitude},#{the_longitude}"
    raw_weather_data = open(url_of_weather_we_want).read
    parsed_weather_data = JSON.parse(raw_weather_data)
    the_temperature = parsed_weather_data["currently"]["temperature"]
    the_hour_outlook = parsed_weather_data["hourly"]["summary"]
    the_day_outlook = parsed_weather_data["daily"]["summary"]

    # generate outputs
    @address = the_address
    @temperature = the_temperature
    @hour_outlook = the_hour_outlook
    @day_outlook = the_day_outlook

    render 'location'
  end
end
