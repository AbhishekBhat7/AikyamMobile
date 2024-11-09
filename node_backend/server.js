const express = require('express');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const otpStore = {}; // Store OTPs temporarily

const transporter = nodemailer.createTransport({
  service: 'Gmail',
  auth: {
    user: 'your-email@gmail.com', // Replace with your email
    pass: 'your-email-password',  // Replace with your email password
  },
});

app.post('/send-otp', (req, res) => {
  const { email } = req.body;
  const otp = crypto.randomInt(1000, 9999).toString();

  otpStore[email] = otp;

  const mailOptions = {
    from: 'your-email@gmail.com',
    to: email,
    subject: 'Your OTP Code',
    text: `Your OTP code is: ${otp}`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log(error);
      res.status(500).send('Failed to send OTP');
    } else {
      console.log('Email sent: ' + info.response);
      res.status(200).send('OTP sent');
    }
  });
});

app.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;
  if (otpStore[email] === otp) {
    delete otpStore[email];
    res.status(200).send('OTP verified');
  } else {
    res.status(400).send('Invalid OTP');
  }
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});
