import express from "express";
import appRouter from "./routes/auth";
import taskRouter from "./routes/tasks";

const app = express();

// middleware: check the all upcomming request and only parse the json request("content-type":"application/json")
app.use(express.json());

// Auth router
app.use("/auth", appRouter);

// Task Router
app.use("/tasks", taskRouter);

app.get("/", (req, res) => {
  res.send("Hii, Avinash gangaji");
});

app.listen(8000, () => {
  console.log("Listening on PORT 8000");
});
