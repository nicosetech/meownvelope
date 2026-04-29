enum CloudButtonState {
  locked, // User is NOT logged in so show lock
  // TODO: Hook up the call here
  cloud, // User is logged in and Envelope is local ONLY
  uploaded, // User is logged in and Envelope is on Server
}

// Shows the three possible states of the cloud/share button.
// Will be used by EnvelopeDetailsViewModel to determine which Icons to display and what action to take when they are pressed.
