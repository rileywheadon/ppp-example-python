from flask import Flask
from src.db import init_db, get_metadata

def create_app():
    app = Flask(__name__, static_folder='static')
    
    # Initialize database
    with app.app_context():
        metadata = get_metadata()
        init_db(metadata)
    
    # Register blueprints/routes
    from src import routes
    app.register_blueprint(routes.bp)
    
    return app