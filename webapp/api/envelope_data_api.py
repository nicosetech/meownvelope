from flask import request, Blueprint, jsonify, g
from api.database import get_db
from api.database import hash_password
from api.database import check_password
from api.credential_api import confirmCredentials
from api.websocket_api import send_envelope_update
import string
import random
import uuid

envelope_data_api = Blueprint('envelope_data_api', __name__, url_prefix='/api')

@envelope_data_api.route('/createEnvelope',methods=['POST'])
def create_envelope():
    if request.method == 'POST':
        req_data = request.get_json()

        db = get_db()
        cursor = db.cursor(buffered=True)

        user_info = confirmCredentials(cursor, req_data)
        userID = user_info["user_id"]
        if not userID:
            return jsonify({"message": "Invalid credentials"}), 401
        
        try:
            envelopeData = req_data["envelope_data"]
            name = envelopeData["name"]
            budgetTarget = envelopeData["budget_target"]
            balance = envelopeData["balance"]
        except KeyError:
            cursor.close()
            return jsonify({"message": "Missing envelope data"}), 400
        
        if len(name) > 20:
            cursor.close()
            return jsonify({"message": "Envelope name too long"}), 400
        
        envelopeId = uuid.uuid4()
        shareCode = id_generator(cursor)

        cursor.execute(
            "INSERT INTO envelopes (id, name, budget_target, balance, share_code) VALUES (%s, %s, %s, %s, %s)",
            (envelopeId.bytes, name, budgetTarget, balance, shareCode)
        )

        cursor.execute(
            "INSERT INTO user_envelopes (user_id, envelope_id) VALUES (%s, %s)",
            (userID, envelopeId.bytes)
        )

        new_transaction(cursor, envelopeId, userID, balance)
        
        db.commit()
        cursor.close()
        return jsonify({"message": "Envelope created", "envelope_id": f"{envelopeId}"}), 201
    
@envelope_data_api.route('/batchRequest',methods=['POST'])
def batch_request_envelopes():
    if request.method == 'POST':
        req_data = request.get_json()

        db = get_db()
        cursor = db.cursor(buffered=True)

        user_info = confirmCredentials(cursor, req_data)
        userID = user_info["user_id"]
        if not userID:
            return jsonify({"message": "Invalid credentials"}), 401

        cursor.execute("SELECT envelope_id, name, budget_target, balance, share_code FROM user_envelopes INNER JOIN envelopes ON user_envelopes.envelope_id=envelopes.id WHERE user_id=%s", (userID,))
        envelopes = cursor.fetchall()
        cleanEnvelopes = []
        for i in envelopes:
            envelope = {
                "envelope_id": uuid.UUID(bytes=i[0]),
                "name": i[1],
                "budget_target": i[2],
                "balance": i[3],
                "share_code": i[4]
            }
            cleanEnvelopes.append(envelope)
        cursor.close()
        return jsonify({"message": "Envelopes retrieved", "envelopes": cleanEnvelopes}), 200

@envelope_data_api.route('/setEnvelopeName',methods=['PATCH'])
def set_envelope_name():
    if request.method == 'PATCH':
        req_data = request.get_json()

        db = get_db()
        cursor = db.cursor(buffered=True)

        user_info = confirmCredentials(cursor, req_data)
        userID = user_info["user_id"]
        if not userID:
            return jsonify({"message": "Invalid credentials"}), 401

        try:
            envelopeData = req_data["envelope_data"]
            envelopeID = uuid.UUID(envelopeData["envelope_id"])
            newName = envelopeData["name"]
        except KeyError:
            cursor.close()
            return jsonify({"message": "Missing envelope data"}), 400
        except ValueError as e:
            print(e,flush=True)
            cursor.close()
            return jsonify({"message": "Invalid envelope ID format"}), 400
        
        if not confirmUserEnvelopeAccess(cursor, userID, envelopeID):
            return jsonify({"message": "Envelope not found. User may not have access to it"}), 404
        
        cursor.execute("UPDATE envelopes SET name=%s WHERE id=%s", (newName, envelopeID.bytes))

        db.commit()
        cursor.close()
        return jsonify({"message": "Envelope name updated"}), 200

@envelope_data_api.route('/editEnvelopeBalance',methods=['PATCH'])
def edit_envelope_balance():
    if request.method == 'PATCH':
        req_data = request.get_json()

        db = get_db()
        cursor = db.cursor(buffered=True)

        user_info = confirmCredentials(cursor, req_data)
        userID = user_info["user_id"]
        if not userID:
            return jsonify({"message": "Invalid credentials"}), 401
        
        try:
            envelopeData = req_data["envelope_data"]
            envelopeID = uuid.UUID(envelopeData["envelope_id"])
            changeBalanceAmount = int(envelopeData["balance_change_amount"])
        except KeyError:
            cursor.close()
            return jsonify({"message": "Missing envelope data"}), 400
        except ValueError as e:
            print(e,flush=True)
            cursor.close()
            return jsonify({"message": "Invalid envelope ID format"}), 400
        
        if not confirmUserEnvelopeAccess(cursor, userID, envelopeID):
            return jsonify({"message": "Envelope not found. User may not have access to it"}), 404
        
        cursor.execute(f"SELECT balance FROM envelopes WHERE id = %s", (envelopeID.bytes,))
        newBalance = int(cursor.fetchall()[0][0]) + changeBalanceAmount
        cursor.execute("UPDATE envelopes SET balance=%s WHERE id=%s", (newBalance, envelopeID.bytes))

        new_transaction(cursor, envelopeID, userID, changeBalanceAmount)

        send_envelope_update(envelope_id=envelopeID, update_data={"envelope_id": f"{envelopeID}", "balance": newBalance})

        db.commit()
        cursor.close()
        return jsonify({"message": "Envelope balance updated"}), 200

@envelope_data_api.route('/requestShareCode',methods=['POST'])
def request_share_code():
    if request.method == 'POST':
        req_data = request.get_json()

        db = get_db()
        cursor = db.cursor(buffered=True)

        user_info = confirmCredentials(cursor, req_data)
        userID = user_info["user_id"]
        if not userID:
            return jsonify({"message": "Invalid credentials"}), 401

        try:
            envelopeID = uuid.UUID(req_data["envelope_id"])
        except KeyError as e:
            print(e,flush=True)
            cursor.close()
            return jsonify({"message": "Missing envelope data"}), 400
        except ValueError as e:
            print(e,flush=True)
            cursor.close()
            return jsonify({"message": "Invalid envelope ID format"}), 400
        
        if not confirmUserEnvelopeAccess(cursor, userID, envelopeID):
            return jsonify({"message": "Envelope not found. User may not have access to it"}), 404
        
        cursor.execute("SELECT share_code FROM envelopes WHERE id=%s", (envelopeID.bytes,))
        share_code = cursor.fetchall()[0][0]

        db.commit()
        cursor.close()
        return jsonify({"message": "Share code retrieved", "share_code": share_code}), 200
    
@envelope_data_api.route('/addUserToEnvelope',methods=['PUT'])
def add_user_to_envelope():
    if request.method == 'PUT':
        req_data = request.get_json()

        db = get_db()
        cursor = db.cursor(buffered=True)

        user_info = confirmCredentials(cursor, req_data)
        userID = user_info["user_id"]
        if not userID:
            return jsonify({"message": "Invalid credentials"}), 401

        try:
            share_code = req_data["share_code"]
        except KeyError as e:
            print(e,flush=True)
            cursor.close()
            return jsonify({"message": "Missing share code"}), 400
        
        cursor.execute("SELECT * FROM envelopes WHERE share_code=%s", (share_code,))
        envelopeTuple = cursor.fetchall()
        if not envelopeTuple:
            return jsonify({"message": "Invalid share code"}), 400
        envelopeTuple = envelopeTuple[0]
        envelopeDict = {
            "envelope_id": uuid.UUID(bytes=envelopeTuple[0]),
            "name": envelopeTuple[1],
            "budget_target": envelopeTuple[2],
            "balance": envelopeTuple[3],
            "share_code": envelopeTuple[4]
        }

        cursor.execute("SELECT * FROM user_envelopes WHERE user_id=%s AND envelope_id=%s", (userID, envelopeDict["envelope_id"].bytes))
        if cursor.fetchall():
            cursor.close()
            return jsonify({"message": "User already has access to this envelope"}), 200
        
        cursor.execute("INSERT INTO user_envelopes (user_id, envelope_id) VALUES (%s, %s)", (userID, envelopeDict["envelope_id"].bytes))
        
        db.commit()
        cursor.close()
        return jsonify({"message": "User added to envelope", "envelope": envelopeDict}), 201

def confirmUserEnvelopeAccess(cursor, userID, envelopeID):
    cursor.execute("SELECT * FROM user_envelopes WHERE user_id=%s AND envelope_id=%s", (userID, envelopeID.bytes))
    if not cursor.fetchall():
        cursor.close()
        return False
    return True

def id_generator(cursor, size=8, chars=string.ascii_uppercase + string.digits):
    str = ''.join(random.choice(chars) for _ in range(size))
    cursor.execute(f"SELECT share_code FROM envelopes WHERE share_code='{str}'")
    if cursor.fetchall():
        return id_generator(cursor, size, chars)
    return str

def new_transaction(cursor, envelopeId, userId, amount):
    cursor.execute(
        "INSERT INTO transactions (envelope_id, amount, user_id) VALUES (%s, %s, %s)",
        (envelopeId.bytes, amount, userId)
    )
