import http.client
import json

CITY, LATITUDE, LONGITUDE = "Berlin", 52.520008, 13.404954


def fetch_weather_data(latitude, longitude):
    conn = http.client.HTTPSConnection("api.open-meteo.com")
    endpoint = (
        f"/v1/forecast?latitude={latitude}&longitude={longitude}&current_weather=true"
    )
    conn.request("GET", endpoint)
    response = conn.getresponse()
    data = response.read().decode("utf-8")
    return json.loads(data)


def parse_weather_data(weather_data):
    current_weather = weather_data["current_weather"]
    temperature = current_weather["temperature"]
    windspeed = current_weather["windspeed"]
    return temperature, windspeed


def display_weather_info(city, temperature, windspeed):
    print(f"Current Weather in {city}:")
    print(f"Temperature: {temperature}°C")
    print(f"Wind Speed: {windspeed} km/h")


def main():
    weather_data = fetch_weather_data(LATITUDE, LONGITUDE)
    temperature, windspeed = parse_weather_data(weather_data)
    display_weather_info(CITY, temperature, windspeed)
