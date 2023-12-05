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
# 해당 기능은 Test 용도
@app.route("/get-sensor-data", methods=["GET"])
def getSensorData():
    if request.method == "GET":
        x = request.args.get("x")
        y = request.args.get("y")
        z = request.args.get("z")
        
        return "x: {0}, y: {1}, z: {2}".format(x, y, z)
        
@app.route("/indoor-localization", methods=["POST"])
def localization():
    if request.method == "POST":
        file = request.files['file']
        filename = secure_filename(file.name)
        file.save("./" + filename)
        
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

# TODO: Test 용도로 삭제 예정
def test():
    eng.addpath(os.getcwd())
    result = eng.localization()[0]
    resultX = result[0]
    resultY = result[1]
    resultZ = result[2]
    print(resultX)
    print(resultY)
    print(resultZ)
    
if __name__ == "__main__":
    with open("information.txt", encoding="UTF-8") as f:
        lines = f.readlines()
    info = []
    for line in lines:
        info.append(line)

    app.run("0.0.0.0", port=info[0])