from flask import Flask
import subprocess

MARINA_BIN = '/app/bin/marina'  # Path to the Marina binary

app = Flask(__name__)
 
@app.route("/start")

def start_marina():
    result = subprocess.run([MARINA_BIN], capture_output=True, text=True)
    return result.stdout or result.stderr, 200
 
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)  # En HTTP, SSL via Ngrok