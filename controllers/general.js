var router = require('express').Router();
var EpcUser = require("../models/epc_user");

router.get('/', function (req, res) {
    res.redirect('/home');
});

router.get('/home', function (req, res, next) {
    //console.log((typeof req.user == 'undefined') ? "undefined" : req.user.username);
    var epc_person = null;
    if (req.user != undefined && req.user.role_str == 0 && req.user.epc_users_id != undefined && req.user.epc_users_id != null && !isNaN(req.user.epc_users_id)) {
        // the users is an epc client
        EpcUser.getDetailedById(req.user.epc_users_id, function (err, rows) {
            if (err) {
                return next(err);
            }
            res.render('home', {
                user: req.user,
                epc_person: rows.length > 0 ? rows[0] : null,
                message: req.flash("signupMessage")
            });
            return;
        }, null);
    } else {
        res.render('home', {user: req.user, message: req.flash("signupMessage")});
        return;
    }
});

module.exports = router;