import express from "express";
import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

admin.initializeApp(); // ✅ MUST be before importing routes

import { router as authRouter } from "./authFunctions"; // ✅ SAFE now

const app = express();

// ✅ Body parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ✅ Routes
app.use("/auth", authRouter);

// ✅ Export
export const api = onRequest(app);
