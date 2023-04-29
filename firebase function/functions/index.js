const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onNewRequest = functions.database
  .ref("requests/{requestId}")
  .onCreate((snap, context) => {
    // Your code to handle the new request here. You can access the new request
    // using snap.val()
    console.log("New request added:", snap.val());
    // You can also access the path to the new request using context.params
    console.log("Path to new request:", context.params);
    // Return a value to indicate success
    return true;
  });
