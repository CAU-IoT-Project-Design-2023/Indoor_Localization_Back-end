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


@app.route("/save-localization-data", methods=["POST"])
def saveLocalizationData():
    if request.method == "POST":
        data = request.get_json()
        x = data["x"]
        y = data["y"]
        z = data["z"]
        section = data["section"]
        with open("data.txt", "a+", encoding="UTF-8") as f:
            f.write("%f,%f,%f,%d" % (x, y, z, section))
        return "OK"


@app.route("/rssi-measure", methods = ["GET"])
def rssiMeasure():
    if request.method == "GET":
        eng.addpath(os.getcwd())
        result = eng.calculateKalman()[0]
        time.sleep(1.5)
        ap1 = result[0]
        ap2 = result[1]
        ap3 = result[2]
        knnResult = eng.doKNNPrediction(ap1, ap2, ap3)[0]
        time.sleep(1.5)
        return jsonify({
            "result": knnResult
        })



#@app.route("/indoor-localization", methods=["GET"])
#def localization():
#    if request.method == "GET":
#        eng.addpath(os.getcwd())
#        ap1 = request.args.get("ap1")
#        ap2 = request.args.get("ap2")
#        ap3 = request.args.get("ap3")
#        knnResult = eng.doKNNPrediction(ap1, ap2, ap3)[0]
#        return jsonify({
#            "result": knnResult
#        })

    
if __name__ == "__main__":
    # with open("information.txt", encoding="UTF-8") as f:
    #     lines = f.readlines()
    # info = []
    # for line in lines:
    #     info.append(line)

    app.run("0.0.0.0", port=8080)