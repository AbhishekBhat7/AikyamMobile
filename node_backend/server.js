const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');
const cors = require('cors');
const fs = require('fs');
require('dotenv').config(); // Load environment variables

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

let otp = null;
let otpEmail = null;

function getEmailHtml(otp) {
    const template = fs.readFileSync('email-template.html', 'utf8');
    console.log(template);
    
    return template.replace('{{OTP}}', otp);
}

app.post('/sendOtp', async (req, res) => {
    const email = req.body.email;
    console.log("Email received:", email);
    console.log("Received request to send OTP");

    if (!email) {
        return res.send({ success: false, error: "Email not provided" });
    }

    otp = Math.floor(100000 + Math.random() * 900000);
    otpEmail = email;

    let transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: process.env.EMAIL_USER,
            pass: process.env.EMAIL_PASS
        }
    });

    let mailOptions = {
        from: process.env.EMAIL_USER,
        to: email,
        subject: 'OTP for Aikyam Sports Science',
        html: getEmailHtml(otp)
    };

    try {
        await transporter.sendMail(mailOptions);
        res.send({ success: true });
    } catch (error) {
        console.error("Error sending email:", error);
        res.send({ success: false, error: error.message });
    }
});

app.post('/verifyOtp', (req, res) => {
    console.log("Received request to verify OTP");
    const { email, userOtp } = req.body;
    if (email === otpEmail && userOtp == otp) {
        res.send({ verified: true });
    } else {
        res.send({ verified: false });
    }
});

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
