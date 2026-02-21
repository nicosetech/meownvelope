from flask import Flask, render_template, request
from flask_mail import Mail
from dotenv import load_dotenv
import os
from forms import validate_contact_form
from emailservice import send_support_email

#Setup Environment
load_dotenv('env')

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')

#Email Setup

app.config['MAIL_SERVER'] = os.getenv('EMAIL_HOST')
app.config['MAIL_PORT'] = int(os.getenv('EMAIL_PORT'))
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = os.getenv('EMAIL_USER')
app.config['MAIL_PASSWORD'] = os.getenv('EMAIL_PASSWORD')
app.config['MAIL_DEFAULT_SENDER'] = os.getenv('EMAIL_USER')

#Creates mail object
mail = Mail(app)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/support', methods=['GET', 'POST'])
def support():
    if request.method == 'POST':
        # Handle form submission
        form_data = {
            'name': request.form.get('name', ''),
            'email': request.form.get('email', ''),
            'subject': request.form.get('subject', ''), #Ensure matches subject in the HTML not Subject
            'message': request.form.get('message', '')
        }
        
        # Validate
        is_valid, errors = validate_contact_form(form_data)
        
        if is_valid:
            success, error = send_support_email(
                mail,
                form_data['name'],
                form_data['email'],
                form_data['subject'],
                form_data['message']
            )
            
            if success:
                return render_template('support.html', success=True, form_data={})
            else:
                errors['email_service'] = error
                return render_template('support.html', errors=errors, form_data=form_data)
        else:
            return render_template('support.html', errors=errors, form_data=form_data)
    
    # GET request - just show the form
    return render_template('support.html', form_data={})

@app.route('/info')
def info():
    return render_template('info.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)