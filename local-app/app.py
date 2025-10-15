from flask import Flask
from prometheus_client import Counter, generate_latest
import threading
import time

app = Flask(__name__)
REQUEST_COUNT = Counter('app_requests_total', 'Total number of requests')

# Simulate activity automatically
def simulate_requests():
    while True:
        REQUEST_COUNT.inc()
        time.sleep(5)

@app.route('/')
def hello():
    REQUEST_COUNT.inc()
    return "Hello, Prometheus!"

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain; charset=utf-8'}

if __name__ == '__main__':
    threading.Thread(target=simulate_requests, daemon=True).start()
    app.run(host='0.0.0.0', port=8080)