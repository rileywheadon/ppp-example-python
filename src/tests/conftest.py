import pytest
import os
from src import create_app
from src.db import get_engine, get_metadata


@pytest.fixture
def app():
    app = create_app()
    return app


@pytest.fixture
def client(app):
    return app.test_client()


@pytest.fixture(scope='function')
def clean_db(app):
    with app.app_context():
        engine = get_engine()
        metadata = get_metadata()
        
        # Drop all tables
        metadata.drop_all(engine)
        
        # Recreate all tables
        metadata.create_all(engine)
        
        yield engine
        
        # Clean up after test
        metadata.drop_all(engine)