import { Router, Request, Response } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middleware/auth";

const appRouter = Router();

interface SignUpBody {
  name: string;
  email: string;
  password: string;
}
interface LoginBody {
  email: string;
  password: string;
}

appRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
  try {
    // get the user body
    const { name, email, password } = req.body;

    // check if the user already exist
    const existingUser = await db.select().from(users).where(eq(users.email, email));
    if (existingUser.length) {
      res.status(400).json({ error: "User already exists!" });
      return;
    }

    // hash the user password
    const encryptedPassword = await bcryptjs.hash(password, 8);

    const newUser: NewUser = {
      name,
      email,
      password: encryptedPassword,
    };

    // store the user in db
    const [user] = await db.insert(users).values(newUser).returning();

    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ error: error });
  }
});

appRouter.post("/login", async (req: Request<{}, {}, LoginBody>, res: Response) => {
  try {
    // get the user body
    const { email, password } = req.body;

    // check if the user does not exist
    const [existingUser] = await db.select().from(users).where(eq(users.email, email));

    if (!existingUser) {
      res.status(400).json({ error: "User with this email does not exists!" });
      return;
    }

    // comparing hashedPassword with the user password
    const isMatched = await bcryptjs.compare(password, existingUser.password);

    if (!isMatched) {
      res.status(400).json({ error: "Incorrect Password" });
      return;
    }

    // signing / creating a jwt token
    const token = jwt.sign({ id: existingUser.id }, "passwordKey"); // passwordKey is sensitive and can be stored in .env

    // sending token with response
    res.status(200).json({ token, ...existingUser });
  } catch (error) {
    res.status(500).json({ error: error });
  }
});

appRouter.post("/tokenIsValid", async (req, res) => {
  try {
    // get the token from header
    const token = req.header("x-auth-token");

    if (!token) {
      res.json(false);
      return;
    }

    // verify if the token is valid
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      res.json(false);
      return;
    }

    // if token is valid, get the user data
    const verifiedToken = verified as { id: string };

    const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));

    // else no user, return false
    if (!user) {
      res.json(false);
      return;
    }
    res.json(true);
  } catch (error) {
    res.status(500).json(false);
  }
});

// auth is middleware which work when accessing "auth/" route
appRouter.get("/", auth, async (req: AuthRequest, res) => {
  try {
    if (!req.user) {
      res.status(400).json({ error: "User not found" });
      return;
    }
    // fetching the fresh up to date latest user data from db using user id
    const [user] = await db.select().from(users).where(eq(users.id, req.user));

    res.json({ ...user, token: req.token });
  } catch (error) {
    res.status(500).json(false);
  }
});

export default appRouter;
