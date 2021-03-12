import { Request, Response, NextFunction } from "express";
import { BaseError } from "../../classes";

const errorMiddleware = (
  err: any,
  _req: Request,
  res: Response,
  next: NextFunction
) => {
  console.log("Error Middleware");
  if (err instanceof BaseError) {
    return res.status(err.status).json({
      status: err.status >= 500 ? "error" : "fail",
      message: err.message,
    });
  }
  return res.status(500).json({
    status: "error",
    message: "Непредвиденная ошибка!",
  });
};

export default errorMiddleware;
