from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
import matlab.engine

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
        
        ## Step 0: Data load
        
        rate = 100 # Sampling rate = 100 Hz
        daltaT = 0.01
        
        # A reference vector used for showing orientations
        refV = [0.0, 1.0, 0.0]
        refQ = eng.quaternion(0.0, refV[0], refV[1], refV[2])
        
        # Read a gyro and accel data from an excel file
        gyro = eng.xlsread(filename, "Gyroscope")
        accel = eng.xlsread(filename, "Linear Accelerometer")
        
        ## Step 1: Orientation relative to a previous body frame
        orientation = eng.struct()
        
        # TODO
        return jsonify({"result": "Section 1"})

if __name__ == "__main__":
    with open("information.txt", encoding="UTF-8") as f:
        lines = f.readlines()
    info = []
    for line in lines:
        info.append(line)

    app.run("0.0.0.0", port=info[0])