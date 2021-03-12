import { BaseError } from "classes";
import { NextFunction, Request, Response } from "express";
import * as jwt from "jsonwebtoken";

export enum Roles {
  GUEST = "GUEST",
  USER = "USER",
  ADMIN = "ADMIN",
}

export const Role = Roles.GUEST || Roles.USER || Roles.ADMIN;

export interface IRole {
  role: Roles;
}

const roleMiddleware = (arrayRoles: IRole[]) => (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (req.method === "OPTIONS") return next();
  const token = req.headers.authorization.split(" ")[1];
  if (!token) {
    return res.status(403).json({
      status: "fail",
      message: "Пользователь не авторизован",
    });
  }
  
  const { roles } = jwt.verify(token, process.env.SECRET_KEY)

  try {
  } catch (error) {
    console.log(error);
    return next(BaseError.internal("[roleMiddleware]: -> CATH"));
  }
};
