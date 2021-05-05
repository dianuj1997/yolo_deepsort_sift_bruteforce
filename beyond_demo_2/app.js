const express               =  require('express')
const app                   =  express()
const mongoose              =  require("mongoose")
const passport              =  require("passport")
const  bodyParser            =  require("body-parser")
const  LocalStrategy         =  require("passport-local")
const  passportLocalMongoose =  require("passport-local-mongoose")
const  User                  =  require("./models/users")
const path = require("path");
var nodemailer = require('nodemailer');



//Connecting database
mongoose.connect("mongodb://localhost/auth_demo");
app.use(require("express-session")({
    secret:"Any normal Word",       //decode or encode session
    resave: false,          
    saveUninitialized:false    
}));
passport.serializeUser(User.serializeUser());       //session encoding
passport.deserializeUser(User.deserializeUser());   //session decoding
passport.use(new LocalStrategy(User.authenticate()));
app.set("view engine","ejs");
app.use(express.static(path.join(__dirname, "public")));

app.use(bodyParser.urlencoded(
      { extended:true }
))
app.use(passport.initialize());
app.use(passport.session());
//=======================
//      R O U T E S
//=======================
app.get("/", (req,res) =>{
    res.render("home");
})
app.get("/userprofile",isLoggedIn ,(req,res) =>{
    res.render("userprofile");
    // var transporter = nodemailer.createTransport({
    //     service: 'gmail',
    //     auth: {
    //       user: 'dianujkotov1997@gmail.com',
    //       pass: 'c03335545_@b'
    //     }
    //   });
      
    //   var mailOptions = {
    //     from: 'dianujkotov1997@gmail.com',
    //     to: 'furqan.ali9500@gmail.com',
    //     subject: 'Sending Email using Node.js',
    //     text: 'You have just won one million dollars! For collection, share a bank check of 20 million dollars!'
    //   };

    // transporter.sendMail(mailOptions, function(error, info){
    //     if (error) {
    //       console.log(error);
    //     } else {
    //       console.log('Email sent: ' + info.response);
    //     }
    //   });
})

app.post('/release',function(req,res){
    var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'dianujkotov1997@gmail.com',
          pass: 'c03335545_@b'
        }
      });
      
      var mailOptions = {
        from: 'dianujkotov1997@gmail.com',
        to: 'furqan.ali9500@gmail.com',
        subject: 'Sending Email using Node.js',
        text: 'You have just won one million dollars! For collection, share a bank check of 20 million dollars!'
      };

    transporter.sendMail(mailOptions, function(error, info){
        if (error) {
          console.log(error);
        } else {
          console.log('Email sent: ' + info.response);
        }
      });
    res.redirect('/');
});
//Auth Routes
app.get("/login",(req,res)=>{
    res.render("login");
});
app.post("/login",passport.authenticate("local",{
    successRedirect:"/userprofile",
    failureRedirect:"/login"
}),function (req, res){
});
app.get("/register",(req,res)=>{
    res.render("register");
});
app.post("/register",(req,res)=>{
    
    User.register(new User({username: req.body.username,phone:req.body.phone,telephone: req.body.telephone}),req.body.password,function(err,user){
        if(err){
            console.log(err);
            res.render("register");
        }
    passport.authenticate("local")(req,res,function(){
        res.redirect("/login");
    })    
    })
})
app.get("/logout",(req,res)=>{
    req.logout();
    res.redirect("/");
});
function isLoggedIn(req,res,next) {
    if(req.isAuthenticated()){
        return next();
    }
    res.redirect("/login");
}


//Listen On Server
app.listen(process.env.PORT ||3000,function (err) {
    if(err){
        console.log(err);
    }else {
        console.log("Server Started At Port 3000");
    }
      
});