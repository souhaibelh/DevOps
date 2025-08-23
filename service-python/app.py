from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/api/message")
def message():
    # adding comment to test if job will run for service-adjavaasd
    return jsonify({"message": "Hello from Flask!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

