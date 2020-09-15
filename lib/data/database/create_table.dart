// Следует использовать для наименования реальные имена таблиц
Map<String, String> createTables = {
  'events': """CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
          eventId TEXT,
          name TEXT,
          owner TEXT,
          description TEXT,
          company TEXT,
          phoneNumber TEXT,
          email TEXT,
          address TEXT,
          coordinates TEXT,
          start TEXT,
          end TEXT,
          UNIQUE(eventId)
       );""",
  'participants': """CREATE TABLE participants (
	      id INTEGER PRIMARY KEY AUTOINCREMENT,
	      docId TEXT,
	      eventId TEXT,
	      userId TEXT,
	      avatar TEXT,
	      firstName TEXT,
	      lastName TEXT,
	      role TEXT,
	      UNIQUE(eventId, userId)
	      );""",
  'users': """CREATE TABLE users (
	      id INTEGER PRIMARY KEY AUTOINCREMENT,
	      userId TEXT,
	      firstName TEXT,
	      lastName TEXT,
	      interests TEXT,
	      useful TEXT,
	      phone TEXT,
	      company TEXT,
	      token TEXT,
	      aboutMe TEXT,
	      avatar TEXT,
	      UNIQUE(userId)
	      );""",

  'comments': """CREATE TABLE comments (
	      id INTEGER PRIMARY KEY AUTOINCREMENT,
	      commentId TEXT,
	      authorId TEXT,
	      createdAt TEXT,
	      eventId TEXT,
	      text TEXT,
	      UNIQUE(commentId)
	      );""",

  'notifications': """CREATE TABLE notifications (
	      id INTEGER PRIMARY KEY AUTOINCREMENT,
	      notificationId TEXT,
	      eventId TEXT,
	      eventName TEXT,
	      state TEXT,
	      createdAt TEXT,
	      initiatorId TEXT,
	      initiatorName TEXT,
	      seenByMe INTEGER,
	      UNIQUE(notificationId)
	      );""",

  'stories': """CREATE TABLE stories (
	      id INTEGER PRIMARY KEY AUTOINCREMENT,
	      storyId TEXT,
	      userId TEXT,
	      url TEXT,
	      mediaType TEXT,
	      duration INTEGER,
	      UNIQUE(storyId)
	      );""",


  'comments_with_users': """
	        CREATE VIEW comments_with_users
          AS
          SELECT
            commentid,
            authorid,
            eventid,
            text,
            createdat,
            users.firstname as firstName,
            users.lastname as lastName,
            users.avatar as avatar
          FROM comments
          INNER JOIN users ON users.userId = comments.authorId
            ;""",
};
