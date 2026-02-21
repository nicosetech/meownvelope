import re

def validate_contact_form(data):
    """
    Validates contact form data.
    Returns (is_valid, errors_dict)
    """
    errors = {}
    
    # Validate name
    name = data.get('name', '').strip()
    if not name:
        errors['name'] = 'Name is required'
    elif len(name) > 100:
        errors['name'] = 'Name must be 100 characters or less'
    
    # Validate email
    email = data.get('email', '').strip()
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not email:
        errors['email'] = 'Email is required'
    elif not re.match(email_pattern, email):
        errors['email'] = 'Please enter a valid email address'
    
    # Validate subject
    subject = data.get('subject', '').strip()
    valid_subjects = ['General', 'Bug Report', 'Feature Request', 'Other']
    if not subject:
        errors['subject'] = 'Please select a subject'
    elif subject not in valid_subjects:
        errors['subject'] = 'Invalid subject selected'
    
    # Validate message
    message = data.get('message', '').strip()
    if not message:
        errors['message'] = 'Message is required'
    elif len(message) < 20:
        errors['message'] = 'Message must be at least 20 characters'
    elif len(message) > 2000:
        errors['message'] = 'Message must be 2000 characters or less'
    
    is_valid = len(errors) == 0
    return is_valid, errors