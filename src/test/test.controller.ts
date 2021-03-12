import * as express from "express";
import { Request, Response, NextFunction } from "express";
import { BaseController } from "../classes";

class TestController extends BaseController {
  public path = "/";
  // public router = express.Router();

  constructor() {
    super();
    this.initRoutes();
  }

  public initRoutes() {
    this.router.get(this.path, this.test);
  }

  test = async (req: Request, res: Response, next: NextFunction) => {
    return next(res.status(500));
  };
}

export default new TestController();
