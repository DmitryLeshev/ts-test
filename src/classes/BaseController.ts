import * as express from "express";
import BaseError from "./BaseError";



export default class BaseController {
  protected req: express.Request;
  protected res: express.Response;

  public router = express.Router();

  public ok<T>(res: express.Response, dto?: T) {
    if (!!dto) {
      return res.status(200).json(dto);
    } else {
      return res.sendStatus(200);
    }
  }

  public created<T>(res: express.Response, dto?: T) {
    if (!!dto) {
      return res.status(201).json(dto);
    } else {
      return res.sendStatus(201);
    }
  }

  public badRequest = (message?: string) => {
    if (!message) message = "Bad Request 404";
    return BaseError.badRequest(message);
  };

  public internal = (message?: string) => {
    if (!message) message = "Internal 500";
    return BaseError.internal(message);
  };

  public errors = (dto: any) => {
    if (dto.status === "error") {
      return this.internal(dto.message);
    } else if (dto.status === "fail") {
      return this.badRequest(dto.message);
    }
  };


}
