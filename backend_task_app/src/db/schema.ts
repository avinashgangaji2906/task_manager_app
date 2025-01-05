import { pgTable, text, timestamp, uuid } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
  id: uuid("id").primaryKey().defaultRandom(),
  name: text("name").notNull(),
  email: text("email").notNull().unique(),
  password: text("password").notNull(),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// type of selected user and new user
export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;

export const tasks = pgTable("tasks", {
  id: uuid("id").primaryKey().defaultRandom(),
  title: text("title").notNull(),
  description: text("description").notNull(),
  hexColor: text("hex_color").notNull(),
  uid: uuid("uid")
    .notNull()
    .references(() => users.id, { onDelete: "cascade" }), // foreign key and if users gets deleted from users table then tasks of that user also be deleted
  dueAt: timestamp("due_at").$defaultFn(() => new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)),
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
});

// type of selected user and new user
export type Task = typeof tasks.$inferSelect;
export type NewTask = typeof tasks.$inferInsert;
