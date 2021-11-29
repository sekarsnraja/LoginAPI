from flask_login import LoginManager
from flask import Flask
from __init__ import db


def create_app():
    main_app = Flask(__name__)
    main_app.config.from_object("config.Config")
    db.init_app(main_app)
    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(main_app)
    from models import User

    @login_manager.user_loader
    def load_user(user_id):
        return User.query.get(int(user_id))

    from auth import auth as auth_blueprint
    main_app.register_blueprint(auth_blueprint)
    return main_app


app = create_app()

if __name__ == '__main__':
    db.create_all(app=create_app())
    app.run(debug=False, host='0.0.0.0', port=8000)
