import os
from server import app, socketio
socketio.run(app, host='0.0.0.0', port=5000, debug=True)
