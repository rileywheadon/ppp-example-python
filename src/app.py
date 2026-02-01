from src import create_app

# Create the Flask application using the factory pattern
app = create_app()

if __name__ == '__main__':
    app.run()