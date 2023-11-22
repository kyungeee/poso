/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();

// exports.sendNotificationOnWaterValueChange = functions.database.ref("/id4/12341234")
//     .onUpdate(async (change, context) => {
//     const newValue = change.after.val();
//     const threshold = 1; // 특정 숫자 설정

//     // 알림을 받을 디바이스 토큰 가져오기
//     const recipientToken = "c2N7BKOyTk6TslIeCxge9F:APA91bEf1Q0scQqi8TCOQbuRebMTIi-zj5xegLwy9UxqdvYMxxlZLeHOL7BBj4Ynwj27XcytFcfG7Al8K9AORudjm7iUHXKqTzT3WOU8N2ADDExVng7fGB6ALewjJX_8v7gUxyue7B6H";

//     if (newValue.waterValue > threshold) {
//       const payload = {
//         notification: {
//           title: "Water Value Alert"
//           body: "The water value is now above  ${threshold}."
//         },
//       };


//       // FCM으로 알림 보내기
//       return admin.messaging().sendToDevice(recipientToken, payload);
//     }

//     return null;
//   });
