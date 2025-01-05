import { Router } from "express";
import { auth, AuthRequest } from "../middleware/auth";
import { db } from "../db";
import { NewTask, tasks } from "../db/schema";
import { eq } from "drizzle-orm";

const taskRouter = Router();

// CREATE A NEW TASK
taskRouter.post("/", auth, async (req: AuthRequest, res) => {
  try {
    req.body = { ...req.body, dueAt: new Date(req.body.dueAt), uid: req.user };

    const newTask: NewTask = req.body;

    const [task] = await db.insert(tasks).values(newTask).returning();

    res.status(201).json(task);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

// GET ALL TASKS
taskRouter.get("/", auth, async (req: AuthRequest, res) => {
  try {
    const allTasks = await db.select().from(tasks).where(eq(tasks.uid, req.user!));

    res.json(allTasks);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

// DELETE A TASK
taskRouter.delete("/", auth, async (req: AuthRequest, res) => {
  try {
    const { taskId }: { taskId: string } = req.body;

    await db.delete(tasks).where(eq(tasks.id, taskId));

    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

// SYNC ALL THE TASKS
taskRouter.post("/sync", auth, async (req: AuthRequest, res) => {
  try {
    const listOfTasks = req.body;

    const filteredListOfTasks: NewTask[] = [];

    for (let task of listOfTasks) {
      task = { ...task, dueAt: new Date(task.dueAt), createdAt: new Date(task.createdAt), updatedAt: new Date(task.updatedAt), uid: req.user };
      filteredListOfTasks.push(task);
    }

    const pushedTasks = await db.insert(tasks).values(filteredListOfTasks).returning(); // drizzle will automatically stores list of tasks in postgres

    res.status(201).json(pushedTasks);
  } catch (e) {
    res.status(500).json({ error: e });
  }
});

export default taskRouter;
