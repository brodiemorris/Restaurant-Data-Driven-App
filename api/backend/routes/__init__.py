from .user_routes import users
from .group_routes import groups
from .analytics_routes import analytics
from .admin_routes import admin
from .restaurant_routes import restaurants

def register_routes(app):
    app.register_blueprint(restaurants)
    app.register_blueprint(users)
    app.register_blueprint(groups)
    app.register_blueprint(analytics)
    app.register_blueprint(admin)