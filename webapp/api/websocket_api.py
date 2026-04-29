import uuid

from flask import request, Blueprint, jsonify, g
from api.database import get_db
from api.database import hash_password
from api.database import check_password
from flask_socketio import SocketIO, send, emit, join_room, leave_room, rooms
from api.credential_api import confirmCredentials

sid_to_user = {}
user_to_sid = {}

def initialize_socketio(socketio : SocketIO):

    @socketio.on("connect")
    def connection():
        try:
            req_data = request.args

            db = get_db()
            cursor = db.cursor(buffered=True)

            user_info = confirmCredentials(cursor, req_data)
            userID = user_info["user_id"]
            if not userID:
                cursor.close()
                raise ConnectionRefusedError('unauthorized!')
            
            sid_to_user[request.sid] = userID
            user_to_sid[userID] = request.sid

            cursor.execute("SELECT envelope_id FROM user_envelopes WHERE user_id = %s", (userID,))
            for (envelope_id,) in cursor.fetchall():
                join_room(uuid.UUID(bytes=envelope_id).hex)

        except Exception as e:
            print(f"Connection refused: {e}",flush=True)
            return False  # Refuse the connection
    
    @socketio.on("lateJoinRoom")
    def lateJoinRoom(data):
        try:
            db = get_db()
            cursor = db.cursor(buffered=True)

            user_info = confirmCredentials(cursor, data)
            userID = user_info["user_id"]
            if not userID:
                cursor.close()
                raise ConnectionRefusedError('unauthorized!')

            envelopeId = uuid.UUID(data["envelope_id"])
            cursor.execute("SELECT envelope_id FROM user_envelopes WHERE user_id = %s AND envelope_id = %s", (userID, envelopeId.bytes))

            result = cursor.fetchall()

            if result:
                join_room(envelopeId.hex)

        except Exception as e:
            print(f"Couldn't add user to room: {e}",flush=True)
            return False  # Refuse the connection

            


def send_envelope_update(envelope_id, update_data):
    emit('envelope_update', update_data, room=envelope_id.hex, namespace='/')