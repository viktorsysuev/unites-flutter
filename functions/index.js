var admin = require("firebase-admin");

var serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://unites-flutter-3cf43.firebaseio.com"
});

const functions = require('firebase-functions');


exports.sendEventChangedNotifications = functions.firestore.document('events/{eventId}').onUpdate( async (change, context) => {
    const eventId = context.params.eventId;
    const participantsArray = [];
    const users = [];
    const tokens = [];
    const idsUsers = [];
    let eventName = "Event";

    console.log('eventUpdated');


//    const allTokens = await admin.firestore().collection('fcmTokens').get();
    const timestamp = admin.firestore.FieldValue.serverTimestamp();
    const event = await admin.firestore().collection('events').doc(eventId).get();
    const owner = await admin.firestore().collection('users').doc(event.data().owner).get();
    const allUsers = await admin.firestore().collection('users').get();

    const participants = await admin.firestore().collection('events').doc(eventId).collection('participants').get();
    participants.forEach((participant) => {
       participantsArray.push(participant.data().userId)
        admin.firestore().collection('users')
                        .doc(participant.data().userId)
                        .collection('notifications')
                        .add({
                               state: "EVENT_CHANGED",
                               createdAt: timestamp,
                               eventId: eventId,
                               seenByMe: false,
                               eventName: event.data().name
                        }).then(snapshot => {
                            admin.firestore().collection('users').doc(participant.data().userId).collection('notifications').doc(snapshot.id).update({
                                                                                                                                                    notificationId: snapshot.id
                                                                                                                                                  });

                              return null;
                            }).catch(err => {
                                      console.log('Error updating documents', err);
                                     });

    })

});

exports.sendNewCommentNotifications = functions.firestore.document('events/{eventId}/comments/{commentId}').onCreate( async (snapshot, context) => {
    const data = snapshot.data();
    const user = await admin.firestore().collection('users').doc(data.authorId).get();
    const eventId = context.params.eventId;

    const timestamp = admin.firestore.FieldValue.serverTimestamp();
    const event = await admin.firestore().collection('events').doc(eventId).get();
    const owner = await admin.firestore().collection('users').doc(event.data().owner).get();
    const allUsers = await admin.firestore().collection('users').get();


    const fullName = user.data().firstName + ' ' + user.data().lastName;

    admin.firestore().collection('users')
                        .doc(owner.data().userId)
                        .collection('notifications')
                        .add({
                               state: "EVENT_NEW_COMMENT",
                               createdAt: timestamp,
                               eventId: eventId,
                               seenByMe: false,
                               initiatorId: user.data().userId,
                               initiatorName: fullName,
                               eventName: event.data().name
                        }).then(snapshot => {
                            admin.firestore().collection('users').doc(owner.data().userId).collection('notifications').doc(snapshot.id).update({
                                                                                                                                                    notificationId: snapshot.id
                                                                                                                                                  });

                              return null;
                            }).catch(err => {
                                      console.log('Error updating documents', err);
                                     });


});


exports.sendNewParticipantNotifications = functions.firestore.document('events/{eventId}/participants/{userId}').onCreate( async (snapshot, context) => {
    const data = snapshot.data();
    const user = await admin.firestore().collection('users').doc(data.userId).get();
    const eventId = context.params.eventId;

    const timestamp = admin.firestore.FieldValue.serverTimestamp();
    const event = await admin.firestore().collection('events').doc(eventId).get();
    const owner = await admin.firestore().collection('users').doc(event.data().owner).get();
    const fullName = user.data().firstName + ' ' + user.data().lastName;

    admin.firestore().collection('users')
                        .doc(owner.data().userId)
                        .collection('notifications')
                        .add({
                               state: "EVENT_NEW_PARTICIPANT",
                               createdAt: timestamp,
                               eventId: eventId,
                               initiatorId: user.data().userId,
                               initiatorName: fullName,
                               seenByMe: false,
                               eventName: event.data().name
                        }).then(snapshot => {
                            admin.firestore().collection('users').doc(owner.data().userId).collection('notifications').doc(snapshot.id).update({
                                                                                                                                                    notificationId: snapshot.id
                                                                                                                                                  });

                              return null;
                            }).catch(err => {
                                      console.log('Error updating documents', err);
                                     });


});


exports.sendParticipantLeftNotifications = functions.firestore.document('events/{eventId}/participants/{userId}').onDelete( async (snapshot, context) => {
    const data = snapshot.data();
    const user = await admin.firestore().collection('users').doc(data.userId).get();
    const eventId = context.params.eventId;

    const timestamp = admin.firestore.FieldValue.serverTimestamp();
    const event = await admin.firestore().collection('events').doc(eventId).get();
    const owner = await admin.firestore().collection('users').doc(event.data().owner).get();
    const fullName = user.data().firstName + ' ' + user.data().lastName;

    admin.firestore().collection('users')
                        .doc(owner.data().userId)
                        .collection('notifications')
                        .add({
                               state: "EVENT_LEFT_PARTICIPANT",
                               createdAt: timestamp,
                               eventId: eventId,
                               initiatorId: user.data().userId,
                               initiatorName: fullName,
                               seenByMe: false,
                               eventName: event.data().name
                        }).then(snapshot => {
                            admin.firestore().collection('users').doc(owner.data().userId).collection('notifications').doc(snapshot.id).update({
                                                                                                                                                    notificationId: snapshot.id
                                                                                                                                                  });

                              return null;
                            }).catch(err => {
                                      console.log('Error updating documents', err);
                                     });


});



