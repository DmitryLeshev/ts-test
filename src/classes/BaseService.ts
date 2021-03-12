import { db } from "../main";
import { QueryResult } from "pg";

interface IOkDTO {
  status: string;
  message: string;
  data: any;
}

export default class BaseService {
  query = async (query: string) => {
    console.log("[Query]: string -> ", query);
    const res: QueryResult = await db.query(query);
    return res;
  };

  failDTO = (message?: string) => ({
    status: "fail",
    message: message || "По запросу ни чего не найдено",
  });

  errorDTO = (message?: string) => ({
    status: "error",
    message: message || "Ошибка при запросе в базу данных",
  });

  okDTO = (data: any, message?: string): IOkDTO => {
    return { status: "success", message: message || null, data: data };
  };
}
