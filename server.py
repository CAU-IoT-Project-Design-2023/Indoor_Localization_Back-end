from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import matlab.engine
import os
import time

app = Flask(__name__)
eng = matlab.engine.start_matlab()


@app.route("/", methods=["GET"])
def home():
    return "CAU-IoT-Project-Design-2023"


@app.route("/is-connected", methods=["GET"])
def isConnected():
    return "connected"


# 클라이언트로부터 센서 데이터 값 받기
@app.route("/save-sensor-data", methods=["POST"])
def saveSensorData():
    if request.method == "POST":
        file = request.files["file"]
        filename = secure_filename(file.filename)
        file.save("./" + filename)
        return "OK"


# RSSI-based Localization
@app.route("/rssi-measure", methods = ["GET"])
def rssiMeasure():
    if request.method == "GET":
        eng.addpath(os.getcwd())
        knnResult = eng.doKNNPrediction(10, 10, 10)
        print(knnResult)
        time.sleep(1.5)
        return str(knnResult)


if __name__ == "__main__":
    app.run("0.0.0.0", port=8080)