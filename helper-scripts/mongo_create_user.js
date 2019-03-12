db.createUser( { user: "multivac",
                 pwd: {{ mongo_password }},
                 roles: [ { role: "readWrite", db: "multivac" } ]});
