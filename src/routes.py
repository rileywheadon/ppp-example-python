from flask import Blueprint, render_template, jsonify
from datetime import datetime
from src.db import get_engine, get_metadata
from sqlalchemy import select, insert
import os

bp = Blueprint('main', __name__)


@bp.route('/')
def index():
    environment = os.getenv('FLASK_ENV', 'production')
    return render_template('index.html', environment=environment)


@bp.route('/api/htmx')
def api_hello():
    current_time = datetime.now().strftime('%H:%M:%S')
    return render_template('htmx.html', current_time=current_time)


@bp.route('/health')
def health_check():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'service': 'ppp-example-python',
    })


@bp.route('/db/test')
def test_db():

    try:
        engine = get_engine()
        account = get_metadata().tables.get('account')

        with engine.connect() as conn:
            
            # Test table operations
            stmt = insert(account).values(
                name='Test Record',
                description='This is a test record created via SQLAlchemy Core'
            )

            conn.execute(stmt)
            conn.commit()
            
            # Query the table
            stmt = select(account).limit(5)
            rows = conn.execute(stmt).fetchall()
            
            return jsonify({
                'status': 'success',
                'message': 'Database connection successful',
                'sample_records': len(rows)
            })

    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': f'Database error: {str(e)}'
        }), 500