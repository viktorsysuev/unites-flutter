// Следует использовать для наименования реальные имена таблиц
Map<String, String> createTables = {
  'events': """CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
          eventId TEXT,
          name TEXT,
          description TEXT,
          company TEXT,
          phoneNumber TEXT,
          email TEXT,
          address TEXT,
          coordinates TEXT,
          start start,
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
};
