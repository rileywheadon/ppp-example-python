from flask import Flask, render_template, jsonify
import time
from datetime import datetime

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/api/htmx')
def api_hello():
    current_time = datetime.now().strftime('%H:%M:%S')
    return render_template('htmx.html', current_time=current_time)


@app.route('/health')
def health_check():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'service': 'ppp-example-python',
    })