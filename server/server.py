import os
import subprocess

from flask import Flask, jsonify, request, send_from_directory

MARINA_BIN = "/out/marina"  # Path to the Marina binary

app = Flask(__name__)


@app.route("/favicon.ico")
def favicon():
    return send_from_directory(
        os.path.join(os.path.dirname(__file__), "static"),
        "favicon.ico",
        mimetype="image/vnd.microsoft.icon",
    )


@app.route("/", methods=["GET"])
def home():
    return "API Marina run /marina", 200


@app.route("/marina", methods=["POST"])
def start_marina():
    data = request.get_json()
    prop = data["prop"]
    if not prop:
        return "No property provided", 400

    result = subprocess.run([MARINA_BIN, prop], capture_output=True, text=True)
    output = result.stdout.strip() or result.stderr.strip()
    return jsonify({"output": output}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)  # HTTP, SSL Ngrok
