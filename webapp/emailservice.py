from flask_mail import Message
import os

def send_support_email(mail, name, email, subject, message):
    """
    Sends support email to the support inbox.
    Returns (success, error_message)
    """
    try:
        support_email = os.getenv('SUPPORT_EMAIL')
        
        msg = Message(
            subject=f'Support Request: {subject}',
            recipients=[support_email],
            reply_to=email
        )
        
        msg.body = f"""
New Support Request

From: {name}
Email: {email}
Subject: {subject}

Message:
{message}
        """
        
        mail.send(msg)
        return True, None
        
    except Exception as e:
        print(f"Error sending email: {str(e)}")
        return False, "Failed to send email. Please try again later."