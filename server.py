from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    return "CAU-IoT-Project-Design-2023"

# 클라이언트로부터 센서 데이터 값 받기
# 해당 기능은 Test 용도
@app.route("/get-sensor-data", methods=["GET"])
def getSensorData():
    if request.method == "GET":
        x = request.args.get("x")
        y = request.args.get("y")
        z = request.args.get("z")
        
        return "x: {0}, y: {1}, z: {2}".format(x, y, z)
        
if __name__ == "__main__":
    with open("information.txt", encoding="UTF-8") as f:
        lines = f.readlines()
    info = []
    for line in lines:
        info.append(line)

    app.run("0.0.0.0", port=info[0])