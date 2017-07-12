var squel = require('squel').useFlavour('postgres');
var pool = require('../config/db');
var User = require('./user');
//var bcrypt = require("bcrypt");
var tableName = "epc_users";

module.exports.create = function (usernameIn, passwordIn, emailIn, roleIn, epcUserIdIn, companyName, companyEmail, companyAddress, companyWebsite, companyContact, contactPersonName, contactPersonDesignation, contactPersonEmail, contactPersonPhone, done) {
    var role = (roleIn == null) ? 1 : roleIn;

    var rollback = function (client, tranDone) {
        client.query('ROLLBACK', function (err) {
            return tranDone(err);
        });
    };

    pool.connect(function (err, client, tranDone) {
        if (err) throw err;
        client.query('BEGIN', function (err) {
            if (err) return rollback(client, tranDone);
            var text = 'INSERT INTO account(money) VALUES($1) WHERE id = $2';
            User.create(usernameIn, passwordIn, emailIn, role, epcUserIdIn, function (err, userId) {
                if (err) {
                    done(err);
                    return rollback(client, tranDone);
                }
                if (userId == null) {
                    done(new Error("User Personal Details not created"));
                    return rollback(client, tranDone);
                }
                var insert_sql = squel.insert()
                    .into(tableName)
                    .set('users_id', userId)
                    .set('company_name', companyName)
                    .set('company_email', companyEmail)
                    .set('company_address', companyAddress)
                    .set('company_website', companyWebsite)
                    .set('company_contact', companyContact)
                    .set('contact_person_name', contactPersonName)
                    .set('contact_person_designation', contactPersonDesignation)
                    .set('contact_person_email', contactPersonEmail)
                    .set('contact_person_phone', contactPersonPhone)
                    .returning("*")
                    .toParam();
                //console.log(insert_sql.text);
                //console.log(insert_sql.values);
                client.query(insert_sql.text, insert_sql.values, function (err, res) {
                    if (err) {
                        done(err);
                        return rollback(client, tranDone);
                    }
                    //console.log('EPC Insert result ======>', res);
                    client.query('COMMIT', function (err, commitDone) {
                        tranDone();
                        if (res.rows.length == 0) {
                            done(null, null);
                        } else {
                            done(null, res.rows[0]['users_id']);
                        }
                    });
                });
            }, client);
        });
    });
};

module.exports.getByUserId = function (userId, done, client) {
    var select_sql = squel.select().from('epc_users').where('users_id=?', userId).toParam();
    var conn = client;
    if (conn == null) {
        conn = pool;
    }
    conn.query(select_sql.text, select_sql.values, function (err, res) {
        if (err) {
            console.error('error running epc user getByUserId query', err);
            return done(err);
        }
        //console.log('SELECT result ======>', res);
        done(null, res.rows);
    });
};

// todo function for get

// todo function for getByUsername

//todo function for getByEmail

// todo function for getByUsernameOrEmail

// todo function for updateById
