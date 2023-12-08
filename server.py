from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import matlab.engine
import os

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


@app.route("/indoor-localization", methods=["GET"])
def localization():
    if request.method == "GET":
        eng.addpath(os.getcwd())
        eng.addpath(os.getcwd())
        result = eng.localization()[0]
        resultX = result[0]
        resultY = result[1]
        resultZ = result[2]
        
        return jsonify({
            "result": "Section ?",
            "resultX": resultX,
            "resultY": resultY,
            "resultZ": resultZ
            })
    
    
@app.route("/save-localization-data", methods=["POST"])
def saveLocalizationData():
    if request.method == "POST":
        data = request.get_json()


@app.route("/save-localization-data", methods=["POST"])
def saveLocalizatinoData():
    if request.method == "POST":
        data = request.get_json()
        x = data["x"]
        y = data["y"]
        z = data["z"]
        section = data["section"]
        with open("data.txt", "a+", encoding="UTF-8") as f:
            f.write("%f,%f,%f,%d" % (x, y, z, section))
        return "OK"
    

@app.route("/save-rssi-data", methods=["GET"])
def safeRssiData():
    if request.method == "GET":
        t1  = request.args.get("t1")
        r1 = request.args.get("r1")
        t2  = request.args.get("t2")
        r2 = request.args.get("r2")
        t3  = request.args.get("t3")
        r3 = request.args.get("r3")
       
        return "t1: {0}, r1: {1}, t2: {2}, r2: {3}, t3: {4}, r3: {5}".format(t1, r1, t2, r2, t3, r3)

    
if __name__ == "__main__":
    with open("information.txt", encoding="UTF-8") as f:
        lines = f.readlines()
    info = []
    for line in lines:
        info.append(line)

    app.run("0.0.0.0", port=info[0])