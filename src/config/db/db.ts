import DataBase, { IDbInit } from "../../classes/DataBase";

const dbInit: IDbInit = {
  user: process.env.POSTGRES_DB_USER,
  host: process.env.POSTGRES_DB_HOST,
  database: process.env.POSTGRES_DB_NAME,
  password: process.env.POSTGRES_DB_PASSWORD,
  port: Number(process.env.POSTGRES_DB_PORT),
};

export default new DataBase(dbInit);
