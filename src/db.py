import os
from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, DateTime, text
from sqlalchemy.sql import func

# Database configuration
DATABASE_URL = os.getenv('DATABASE_URL')
if not DATABASE_URL:
    raise EnvironmentError("DATABASE_URL environment variable not set.")

# Create engine (only if DATABASE_URL is provided)
engine = None
if DATABASE_URL:
    engine = create_engine(DATABASE_URL, echo=False)

# Create metadata object
metadata = MetaData()

def get_engine():
    if engine is None:
        raise RuntimeError("DATABASE_URL environment variable not set.")

    return engine

def get_metadata():
    if engine is not None:
        metadata.reflect(bind=engine)

    return metadata

def init_db(m):
    if engine is not None:
        m.create_all(engine)