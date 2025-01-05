import { UUID } from "crypto";
import { Response, Request, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { db } from "../db";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request {
  user?: UUID;
  token?: string;
}

// Auth middleware which will authenticate each request and sends to next function
export const auth = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    // get the token from header
    const token = req.header("x-auth-token");

    if (!token) {
      res.status(401).json({ error: "Authentication failed, access denied" });
      return;
    }

    // verify if the token is valid
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      res.status(401).json({ error: "Invalid token" });
      return;
    }

    // if token is valid, get the user data
    const verifiedToken = verified as { id: UUID };

    const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));

    // else no user, return false
    if (!user) {
      res.status(401).json({ error: "User not found" });
      return;
    }

    // setting up userId and token for fetching the fresh user data in next function in routes
    // Here instead of setting directly user, we just assign user id as user and latest user data will be fetched in next function
    req.user = verifiedToken.id;
    req.token = token;

    next();
  } catch (error) {
    res.status(500).json(false);
  }
};
