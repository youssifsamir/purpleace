import express from "express";
import * as admin from "firebase-admin";
import { Request, Response } from "express";

export const router = express.Router();

// -------------------- SIGNUP --------------------
router.post("/signup", async (req: Request, res: Response) => {
  // ✅ SAFE: Firebase is guaranteed to be initialized here
  const db = admin.firestore();
  const auth = admin.auth();

  // -------------------- EXTRACT DATA WITH DEFAULTS --------------------
  const {
    username = "",
    email = "",
    password = "",
    firstName = "",
    lastName = "",
    gender = "",
    religon = "",
    DOB = null,
    nationalID = "",
    mobileNumber = "",
    additionalMobileNumber = "",
  } = req.body;

  // -------------------- REQUIRED VALIDATION --------------------
  if (!username || !email || !password || !firstName || !lastName || !gender || !DOB || !nationalID || !mobileNumber) {
    return res.status(400).json({
      error: "Missing required fields",
      received: req.body, // ✅ TEMP DEBUG (remove later)
    });
  }

  try {
    // -------------------- CHECK USERNAME UNIQUENESS --------------------
    const usernameQuery = await db.collection("users").where("username", "==", username).get();
    if (!usernameQuery.empty) {
      return res.status(400).json({ error: "Username already taken" });
    }

    // -------------------- CREATE AUTH USER --------------------
    const userRecord = await auth.createUser({
      email,
      password,
      displayName: username,
      phoneNumber: mobileNumber,
    });

    // -------------------- BUILD USER DATA --------------------
    const userData = {
      uid: userRecord.uid,
      username,
      email,

      personalInfo: {
        firstName,
        lastName,
        gender,
        religion: religon || "N/A",
        dob: DOB || null,
        nationalID,
        phoneNumber: mobileNumber,
        additionalPhoneNo: additionalMobileNumber || "",
        profileImage: "",
      },

      workInfo: {
        employeeID: req.body.employeeID || "",
        position: req.body.position || "",
        branch: req.body.branch || "",
        department: req.body.department || "",
        location: req.body.location || "",
        shiftType: req.body.shiftType || "",
        schedule: req.body.schedule || "",
        parentManager: req.body.parentManager || "",
        fingerprintID: req.body.fingerprintID || "",
        vacationStartDate: req.body.vacationStartDate || null,
        unpaidVacationBalance: req.body.unpaidVacationBalance ?? 0,
        normalVacation: req.body.normalVacation ?? 0,
        urgentVacation: req.body.urgentVacation ?? 0,
      },

      contactInfo: {
        joinDate: req.body.joinDate || null,
        grossSalary: req.body.grossSalary ?? 0,
        newGrossSalary: req.body.newGrossSalary ?? 0,
        insuranceSalary: req.body.insuranceSalary ?? 0,
        otherExemption: req.body.otherExemption ?? 0,
        shiftHours: req.body.shiftHours ?? 0,
        effectiveSalaryDate: req.body.effectiveSalaryDate || null,
        currency: req.body.currency || "",
        contractType: req.body.contractType || "",
        paymentMethod: req.body.paymentMethod || "",
        bankAccountNumber: req.body.bankAccountNumber || "",
        bankName: req.body.bankName || "",
        startContractDate: req.body.startContractDate || null,
        endContractDate: req.body.endContractDate || null,
      },

      userAccount: {
        role: req.body.role || "employee",
        email,
        medicalInsurance: req.body.medicalInsurance ?? false,
        isTaxable: req.body.isTaxable ?? false,
      },

      permissions: {
        overridePermissionDepartmentSettings: req.body.overridePermissionDepartmentSettings ?? false,
        sickVacationPermission: req.body.sickVacationPermission ?? false,
        urgentVacationPermission: req.body.urgentVacationPermission ?? false,
        unpaidVacationPermission: req.body.unpaidVacationPermission ?? false,
        missionPermission: req.body.missionPermission ?? false,
        overtimePermission: req.body.overtimePermission ?? false,
        advancedPaymentPermission: req.body.advancedPaymentPermission ?? false,
        upaidExcusePermission: req.body.upaidExcusePermission ?? false,
        checkinApprovalPermission: req.body.checkinApprovalPermission ?? false,
        excusePermission: req.body.excusePermission ?? false,
        allowancePermission: req.body.allowancePermission ?? false,
        workFromHomePermission: req.body.workFromHomePermission ?? false,
        payslipSettings: req.body.payslipSettings ?? false,
        showPayslipPermission: req.body.showPayslipPermission ?? false,
        showPayslipDetailsPermission: req.body.showPayslipDetailsPermission ?? false,
        excuseLimitSettings: req.body.excuseLimitSettings ?? false,
        overrideExcuseDepartmentSettings: req.body.overrideExcuseDepartmentSettings ?? false,
      },

      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // -------------------- SAVE TO FIRESTORE --------------------
    await db.collection("users").doc(userRecord.uid).set(userData);

    return res.status(201).json(userData);
  } catch (error: any) {
    console.error("Signup error:", error);
    return res.status(500).json({ error: error.message });
  }
});


// -------------------- LOGIN --------------------
router.post("/login", async (req: Request, res: Response) => {
  const { email = "", password = "" } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email and password are required" });
  }

  try {
    const auth = admin.auth();
    const db = admin.firestore();

    // -------------------- GET USER BY EMAIL --------------------
    const userRecord = await auth.getUserByEmail(email);

    // Firebase Admin SDK cannot verify password directly, so we simulate with custom token
    // Normally, client uses Firebase Auth SDK to sign in with email/password
    // Here, we can create a custom token for the client
    const customToken = await auth.createCustomToken(userRecord.uid);

    // -------------------- GET USER DATA --------------------
    const userDoc = await db.collection("users").doc(userRecord.uid).get();
    if (!userDoc.exists) {
      return res.status(404).json({ error: "User data not found" });
    }

    const userData = userDoc.data();

    // -------------------- RESPONSE --------------------
    return res.status(200).json({
      token: customToken,
      user: userData,
    });
  } catch (error: any) {
    console.error("Login error:", error);
    return res.status(401).json({ error: "Invalid email or password" });
  }
});

// // -------------------- LOGIN BY USERNAME --------------------
// router.post("/loginbyusername", async (req: Request, res: Response) => {
//   const { username, password } = req.body;

//   if (!username || !password) {
//     return res.status(400).json({ error: "Username and password are required" });
//   }

//   try {
//     const db = admin.firestore();
//     const auth = admin.auth();

//     // 1️⃣ Look up user by username in Firestore
//     const userQuery = await db.collection("users").where("username", "==", username).get();

//     if (userQuery.empty) {
//       return res.status(404).json({ error: "User not found" });
//     }

//     const userData = userQuery.docs[0].data();
//     const email = userData.email;

//     // 2️⃣ Use Firebase Auth to verify credentials
//     // Firebase Admin SDK does not provide a direct "signIn" method.
//     // You need to use the Firebase Client SDK or create a custom token for server login.
//     // Here we generate a custom token to return to the client:
//     const firebaseUser = await auth.getUserByEmail(email);
//     const customToken = await auth.createCustomToken(firebaseUser.uid);

//     // ✅ Return custom token and user data
//     return res.status(200).json({
//       token: customToken,
//       user: userData,
//     });
//   } catch (error: any) {
//     console.error("Login error:", error);
//     return res.status(500).json({ error: error.message });
//   }
// });