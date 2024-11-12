const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer"); // For sending emails

admin.initializeApp();

// Configure your email transport
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "your-email@gmail.com",
    pass: "your-email-password",
  },
});

// Cloud Function to send OTP
exports.sendOTP = functions.https.onCall(async (data, context) => {
  const {email} = data; // Email of the user

  if (!email) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Email is required",
    );
  }

  try {
    // Get user details from Firebase Auth
    const user = await admin.auth().getUserByEmail(email);

    if (!user.emailVerified) {
      throw new functions.https.HttpsError(
          "permission-denied",
          "Email is not verified",
      );
    }

    // Generate a random 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000);

    // Store the OTP in Firestore with an expiration time (e.g., 10 minutes)
    await admin.firestore().collection("otp").doc(user.uid).set({
      otp,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Send OTP via email
    const mailOptions = {
      from: "your-email@gmail.com",
      to: email,
      subject: "Your OTP Code",
      text: `Your OTP code is: ${otp}. It expires in 10 minutes.`,
    };

    // Send email asynchronously
    await transporter.sendMail(mailOptions);

    return {message: "OTP sent successfully to your email"};
  } catch (error) {
    console.error("Error sending OTP:", error);
    throw new functions.https.
        HttpsError("internal", "Failed to send OTP", error);
  }
});

// Cloud Function to verify OTP
exports.verifyOTP = functions.https.onCall(async (data, context) => {
  const {email, otp} = data;

  if (!email || !otp) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "Email and OTP are required",
    );
  }

  try {
    // Get user details from Firebase Auth
    const user = await admin.auth().getUserByEmail(email);

    // Retrieve the OTP record from Firestore
    const otpRecord = await admin.firestore()
        .collection("otp")
        .doc(user.uid)
        .get();

    if (!otpRecord.exists) {
      throw new functions.https.HttpsError("not-found", "No OTP record found");
    }

    const storedOtp = otpRecord.data().otp;
    const timestamp = otpRecord.data().timestamp;

    // Check if OTP has expired (e.g., 10 minutes expiration)
    const currentTime = admin.firestore.FieldValue.serverTimestamp();
    const expirationTime = 10 * 60 * 1000; // 10 minutes in milliseconds
    const elapsedTime = currentTime.toMillis() - timestamp.toMillis();

    if (elapsedTime > expirationTime) {
      throw new functions.https.HttpsError(
          "deadline-exceeded",
          "OTP has expired",
      );
    }

    // Compare the entered OTP with the stored OTP
    if (storedOtp === otp) {
      return {message: "OTP verified successfully!"};
    } else {
      throw new functions.https.HttpsError(
          "unauthenticated",
          "Incorrect OTP",
      );
    }
  } catch (error) {
    console.error("Error verifying OTP:", error);
    throw new functions.https.HttpsError(
        "internal",
        "Failed to verify OTP",
        error,
    );
  }
});
