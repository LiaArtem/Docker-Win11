conn = new Mongo();
db = conn.getDB("testDB");
db.createCollection("Curs");
db.Curs.insertMany([ { curr_code: 'USD', curs_date: new Date("2022-11-12T00:00"), forc: 1, rate: 37.345 }, { curr_code: 'USD', curs_date: new Date("2022-11-11T00:00"), forc: 1, rate: 36.5 } ])


