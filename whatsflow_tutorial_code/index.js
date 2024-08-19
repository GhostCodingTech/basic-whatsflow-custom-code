const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code
const {RtcTokenBuilder, RtcRole} = require("agora-access-token");
require("dotenv").config();
const APP_ID = process.env.APP_ID;
const APP_CERTIFICATE = process.env.APP_CERTIFICATE;

admin.initializeApp();

exports.generateAgoraTokenOnCreate = functions.firestore
    .document("calls/{callId}")
    .onCreate(async (snap, context) => {
      const callData = snap.data();
      const callId = context.params.callId;

      console.log(`New call document created: ${callId}`);

      // eslint-disable-next-line indent
        if (!callData.channelName) {
        console.error(`Channel name is missing in the document: ${callId}`);
        return;
      }

      const channelName = callData.channelName;
      const uid = 0; // Use 0 if you do not have a specific user ID
      const role = RtcRole.PUBLISHER;
      const expirationTimeInSeconds = 3600;
      const currentTimestamp = Math.floor(Date.now() / 1000);
      const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

      try {
        const token = RtcTokenBuilder
            .buildTokenWithUid(APP_ID,
                APP_CERTIFICATE,
                channelName,
                uid,
                role,
                privilegeExpiredTs);

        // Update the call document with the APP_ID and token_id
        await admin.firestore().collection("calls").doc(callId).update({
          app_id: APP_ID,
          token_id: token,
        });

        console.log(`Token generated and added to the document: ${callId}`);
      } catch (error) {
        console.error(`Error generating token for document: ${callId}`, error);
      }
    });
