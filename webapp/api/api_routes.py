from flask import request, Blueprint, jsonify, g
import mysql.connector
from api.database import get_db
from api.database import hash_password
from api.database import check_password

api = Blueprint('api', __name__, url_prefix='/api')

@api.route('/createAccount',methods=['POST'])
def create_account():
    if request.method == 'POST':
        req_data = request.get_json()
        username = req_data["username"]
        email = req_data["email"]
        password = req_data["password"]

        pass_hashed = hash_password(password)

        db = get_db()
        cursor = db.cursor(buffered=True)

        cursor.execute(f"SELECT username FROM users WHERE username='{username}'")
        if not cursor.fetchall():
            cursor.execute(f"SELECT email FROM users WHERE email='{email}'")
            if not cursor.fetchall():
                cursor.execute(
                    "INSERT INTO users (username, email, password) VALUES (%s, %s, %s)",
                    (username, email, pass_hashed)
                )
                db.commit()

                return jsonify({"message": "User created"}), 201
            return jsonify({"message": "Email already used"}), 409
        return jsonify({"message": "Username taken"}), 409
    
@api.route('/deleteAccount', methods=['POST'])
def delete_account():
    if request.method == 'POST':
        req_data = request.get_json()
        username = req_data["username"]
        password = req_data["password"]

        db = get_db()
        cursor = db.cursor(buffered=True)

        cursor.execute(f"SELECT password FROM users WHERE username='{username}'")
        fetchedPassword = cursor.fetchall()
        if fetchedPassword:
            if check_password(password, fetchedPassword[0][0]):
                cursor.execute(f"DELETE FROM users WHERE username='{username}'")
                db.commit()
                return jsonify({"message": "Account deleted"}), 201
            return jsonify({"message": "Wrong Password"}), 409
        return jsonify({"message": "No user"}), 409


@api.route('/login',methods=['POST'])
def login():
    if request.method == 'POST':
        req_data = request.get_json()
        username = req_data["username"]
        password = req_data["password"]

        db = get_db()
        cursor = db.cursor(buffered=True)

        cursor.execute(f"SELECT password FROM users WHERE username='{username}'")
        fetchedPassword = cursor.fetchall()
        if fetchedPassword:
            if check_password(password, fetchedPassword[0][0]):

                return jsonify({"message": "Success Login"}), 200
            
            return jsonify({"message": "Wrong Password"}), 404

        return jsonify({"message": "No user"}), 404
    

@api.route('/changeUsername', methods=['POST'])
def change_username():
    if request.method == 'POST':
        req_data = request.get_json()
        username = req_data["username"]
        password = req_data["password"]
        new_username = req_data["new_username"]

        db = get_db()
        cursor = db.cursor(buffered=True)

        cursor.execute(f"SELECT password FROM users WHERE username = '{username}'")
        fetchedPassword = cursor.fetchall()
        if fetchedPassword:
            if check_password(password, fetchedPassword[0][0]):
                cursor.execute(f"SELECT username FROM users WHERE username='{new_username}'")
                if cursor.fetchall():
                    return jsonify({"message": "Username taken"}), 409
                cursor.execute(f"UPDATE users SET username='{new_username}' WHERE username='{username}'")
                db.commit()
                return jsonify({"message": "Username updated"}), 201
            return jsonify({"message": "Wrong Password"}), 409
        return jsonify({"message": "No user"}), 409
    
@api.route('/changePassword', methods=['POST'])
def change_password():
    if request.method == 'POST':
        req_data = request.get_json()
        username = req_data["username"]
        password = req_data["password"]
        new_password= req_data["new_password"]

        db = get_db()
        cursor = db.cursor(buffered=True)

        cursor.execute(f"SELECT password FROM users WHERE username = '{username}'")
        fetchedPassword = cursor.fetchall()
        if fetchedPassword:
            if check_password(password, fetchedPassword[0][0]):
                new_hashed = hash_password(new_password).decode('utf-8')
                cursor.execute(f"UPDATE users SET password='{new_hashed}' WHERE username='{username}'")
                db.commit()
                return jsonify({"message": "Password Updated"}), 201
            return jsonify({"message": "Wrong Password"}), 409
        return jsonify({"message" "No user"}), 409