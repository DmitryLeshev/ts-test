import * as dotenv from "dotenv";
dotenv.config({ path: ".env" });

import { App, DataBase, Server } from "./classes";
import middlewares from "./config/middlewares";

import UsersController from "./api/v1/users";
import testController from "./test/test.controller";

const app = new App({
  apiVersion: process.env.API_VERSION,
  controllers: [testController, UsersController],
  middlewares,
});

export const db = new DataBase({
  user: process.env.POSTGRES_DB_USER,
  host: process.env.POSTGRES_DB_HOST,
  database: process.env.POSTGRES_DB_NAME,
  password: process.env.POSTGRES_DB_PASSWORD,
  port: Number(process.env.POSTGRES_DB_PORT),
});

const server = new Server({
  port: Number(process.env.PORT),
  app,
  db,
});

server.start();
