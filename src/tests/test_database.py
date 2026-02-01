import json
import pytest
from src.db import get_engine, get_metadata
from sqlalchemy import select, insert, text


def test_database_connection(app, clean_db):
    """Test that we can connect to the database."""
    with app.app_context():
        engine = get_engine()
        assert engine is not None
        
        # Test basic connection
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 1"))
            assert result.fetchone()[0] == 1


def test_database_tables_exist(app, clean_db):
    """Test that database tables are created."""
    with app.app_context():
        metadata = get_metadata()
        engine = get_engine()
        
        # Reflect the database to get current tables
        metadata.reflect(bind=engine)
        
        # Check if account table exists (from migration)
        assert 'account' in metadata.tables
        account_table = metadata.tables['account']
        
        # Verify table structure
        column_names = [col.name for col in account_table.columns]
        assert 'id' in column_names
        assert 'name' in column_names
        assert 'description' in column_names


def test_database_operations(app, clean_db):
    """Test basic database operations."""
    with app.app_context():
        engine = get_engine()
        metadata = get_metadata()
        metadata.reflect(bind=engine)
        
        account_table = metadata.tables['account']
        
        with engine.connect() as conn:
            # Test insert
            stmt = insert(account_table).values(
                name='Test Account',
                description='A test account for pytest'
            )
            result = conn.execute(stmt)
            conn.commit()
            
            # Test select
            stmt = select(account_table).where(account_table.c.name == 'Test Account')
            rows = conn.execute(stmt).fetchall()
            
            assert len(rows) == 1
            assert rows[0].name == 'Test Account'
            assert rows[0].description == 'A test account for pytest'


def test_db_test_endpoint(client, clean_db):
    """Test the /db/test endpoint."""
    response = client.get('/db/test')
    assert response.status_code == 200
    
    data = json.loads(response.data)
    assert data['status'] == 'success'
    assert data['message'] == 'Database connection successful'
    assert 'sample_records' in data