const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
const admin = require('firebase-admin');
admin.initializeApp();

// Email transport using Gmail
const transporter = nodemailer.createTransport({
  service: 'gmail', // Use 'gmail' for Gmail service
  auth: {
    user: 'bhatabhishek226@gmail.com',  // Your Gmail address
    pass: 'AbhiBhat226@$%'          // Your Gmail app password
  }
});

// Firebase Firestore collection for OTPs
const otpCollection = 'otp_verification';  // Firestore collection to store OTP

// Generate OTP and send it via email
exports.sendOtpEmail = functions.auth.user().onCreate(async (user) => {
  const email = user.email;
  
  // Generate a 6-digit OTP
  const otp = Math.floor(100000 + Math.random() * 900000);

  // Store OTP in Firestore
  await admin.firestore().collection(otpCollection).doc(user.uid).set({
    otp: otp,
    email: email,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // Send OTP email
  const mailOptions = {
    from: 'bhatabhishek226@gmail.com',  // Your Gmail address
    to: email,
    subject: 'Your OTP for Email Verification',
    text: `Your OTP code is: ${otp}. Please use it to verify your email address.`
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log('OTP email sent to:', email);
  } catch (error) {
    console.error('Error sending OTP email:', error);
  }
});
