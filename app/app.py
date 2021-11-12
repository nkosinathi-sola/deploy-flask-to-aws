from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello_world():
    """
    This is the / route endpoint.
    Returns:
        It renders the home template
    """
    return 'Hello, World!'


"""
Modify minimal with main
"""

if __name__ == '__main__':
    """
    Avoid only binding to the localhost interface
    Bind to 0.0.0.0 to access the container from outside
    """
    app.run(host='0.0.0.0', port=5000, debug=False)
