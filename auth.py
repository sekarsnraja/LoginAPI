from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from models import User
from flask_login import login_user, logout_user, login_required
from __init__ import db


auth = Blueprint('auth', __name__)


@auth.route('/signup', methods=['POST'])
def signup():
    posted_data = request.get_json()
    print(posted_data)
    email = posted_data.get('email')
    name = posted_data.get('name')
    password = posted_data.get('password')
    user = User.query.filter_by(email=email).first()
    if user:
        return jsonify({'message': 'Email address already exists'})
    new_user = User()
    new_user.email = email
    new_user.name = name
    new_user.password = generate_password_hash(password, method='sha256')
    db.session.add(new_user)
    db.session.commit()
    return jsonify({'message': 'Successfully Created the User', 'created_data': str(posted_data)})


@auth.route('/login', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        login_data = request.get_json()
        email = login_data.get('email')
        password = login_data.get('password')
        remember = True if login_data.get('remember') else False
        user = User.query.filter_by(email=email).first()
        if not user:
            return jsonify({'message': 'Email not found, if new Please sign up before'})
        elif not check_password_hash(user.password, password):
            return jsonify({'message': 'Wrong Password please try again'})
        login_user(user, remember=remember)
        return jsonify({'message': 'User logged in successfully'})
    else:
        login_data = request.args
        email = login_data.get('email')
        user = User.query.filter_by(email=email).first()
        if user:
            user_dict = {'name': user.name, 'email': user.email}
            return jsonify({'message': 'Successfully fetched User detail', 'user_details': [user_dict]})
        else:
            return jsonify({'message': 'Email not Found, if new user please signup'})


@auth.route('/getLoginDetailsAll', methods=['GET'])  # define login page path
def get_all_login():
    users = User.query.all()
    users_detail_list = []

    for user_obj in users:
        user_dict = {'id': user_obj.id, 'name': user_obj.name, 'email': user_obj.email}

        users_detail_list.append(user_dict)

    return jsonify({'message': 'Successfully fetched all Users detail', 'user_details': users_detail_list})


@auth.route('/updateUser', methods=['PATCH'])
def update_user():
    patched_data = request.get_json()
    email = patched_data.get('email')
    name = patched_data.get('name')
    password = patched_data.get('password')
    user = User.query.filter_by(email=email).first()
    if not user:
        return jsonify({'message': 'Email not Found, if new user please signup'})
    else:
        if name:
            user.name = name
        if password:
            user.password = generate_password_hash(password, method='sha256')
        db.session.commit()
        return jsonify({'message': 'User details updated Successfully'})


@auth.route('/deleteUser', methods=['DELETE'])
def delete_user():
    login_data = request.args
    email = login_data.get('email')
    user = User.query.filter_by(email=email).first()
    if user:
        db.session.delete(user)
        db.session.commit()
        return jsonify({'message': 'User deleted Successfully'})
    else:
        return jsonify({'message': 'Email not Found, if new user please signup'})

# @auth.route('/logout', methods=['POST'])
# @login_required
# def logout():
#     logout_user()
#     return jsonify({'message': 'User logged out successfully'})
