#!/usr/bin/python
import sys
import Adafruit_DHT
import random
import time
import iothub_client
# pylint: disable=E0611
from iothub_client import IoTHubClient, IoTHubClientError, IoTHubTransportProvider, IoTHubClientResult
from iothub_client import IoTHubMessage, IoTHubMessageDispositionResult, IoTHubError, DeviceMethodReturnValue

CONNECTION_STRING = "YourConnectionString"

# Using the MQTT protocol.
PROTOCOL = IoTHubTransportProvider.MQTT
MESSAGE_TIMEOUT = 10000

# Define the JSON message to send to IoT Hub.
TEMPERATURE = 20.0
HUMIDITY = 60
MSG_TXT = "{\"temperature\": %.2f,\"humidity\": %.2f}"
sensor_args = { '11': Adafruit_DHT.DHT11,
                    '22': Adafruit_DHT.DHT22,
                    '2302': Adafruit_DHT.AM2302 }

def send_confirmation_callback(message, result, user_context):
    print ( "IoT Hub responded to message with status: %s" % (result) )

def iothub_client_init():
    # Create an IoT Hub client
    client = IoTHubClient(CONNECTION_STRING, PROTOCOL)
    return client

def get_sensor_data(sensor,pin):
    return Adafruit_DHT.read_retry(sensor, pin)

def data_loop(sensor,pin):
    try:
        client = iothub_client_init()
        print ( "IoT Hub device sending periodic messages, press Ctrl-C to exit" )
        count = 0
        while True:
            # Build the message with simulated telemetry values.
            humidity, temperature = get_sensor_data(sensor,pin)
            msg_txt_formatted = MSG_TXT % (temperature, humidity)
            message = IoTHubMessage(msg_txt_formatted)
            # Optional due to edgeHub error
            message.message_id = "message_%d" % count
            message.correlation_id = "correlation_%d" % count
            count += 1
            # Add a custom application property to the message.
            # An IoT hub can filter on these properties without access to the message body.
            prop_map = message.properties()
            if temperature > 30:
              prop_map.add("temperatureAlert", "true")
            else:
              prop_map.add("temperatureAlert", "false")

            # Send the message.
            print( "Sending message: %s" % message.get_string() )
            client.send_event_async(message, send_confirmation_callback, None)
            time.sleep(1)

    except IoTHubError as iothub_error:
        print ( "Unexpected error %s from IoTHub" % iothub_error )
        return
    except KeyboardInterrupt:
        print ( "IoTHubClient sample stopped" )

if __name__ == '__main__':
    print ( "Sensor data" )
    print ( "Press Ctrl-C to exit" )
    sensor = sensor_args[sys.argv[1]]
    pin = sys.argv[2]
    data_loop(sensor,pin)