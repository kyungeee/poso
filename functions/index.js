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


const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnWaterValueChange = functions.database.ref("/id4/12341234")
    .onUpdate(async (change, context) => {
    const newValue = change.after.val();
    const recipientToken = "c2N7BKOyTk6TslIeCxge9F:APA91bEf1Q0scQqi8TCOQbuRebMTIi-zj5xegLwy9UxqdvYMxxlZLeHOL7BBj4Ynwj27XcytFcfG7Al8K9AORudjm7iUHXKqTzT3WOU8N2ADDExVng7fGB6ALewjJX_8v7gUxyue7B6H";

    // 특정 숫자 설정
    const step1 = 1;
    const step2 = 2;

    // 알림 제목과 내용 초기화
    let title = "";
    let body = "";

    // waterValue에 따라 알림 내용 설정
    if (newValue.step == step1) {
        title = "침수 위험 알림⚠️";
        body = "현재 차량 침수 위험 경고💧";
    } else if (newValue.step = step2) {
        title = "침수 위험 알림⚠️";
        body = "현재 차량이 침수되었습니다💧";
    }

    // 알림 내용이 있는 경우에만 FCM으로 알림 보내기
    if (title !== "" && body !== "") {
        const payload = {
            notification: {
                title: title,
                body: body,
            },
        };

        // FCM으로 알림 보내기
        return admin.messaging().sendToDevice(recipientToken, payload);
    }

    return null;
});
