import { Request, Response, NextFunction, json } from "express";
import * as jwt from "jsonwebtoken";

import { BaseController } from "../../../classes";
import {
  ICreateUserDTO,
  IGetUsersDTO,
  IResCreateUserDTO,
  IResDTO,
  IUser,
} from "./users.interfaces";

import UsersService from "./users.service";

class UsersController extends BaseController {
  private path = "/users";
  private service = new UsersService();

  constructor() {
    super();
    this.initRouter();
  }

  initRouter() {
    this.router.get(this.path, this.getUsers);
    this.router.get(this.path, this.getUser);
    this.router.post(
      this.path + "/registration",
      this.checkBody,
      this.registrationUser
    );
    this.router.post(this.path + "/login", this.checkBody, this.login);
    this.router.get(this.path + "/auth", this.checkToken, this.check);
  }

  getUsers = async (req: Request, res: Response, next: NextFunction) => {
    const resDTO = await this.service.getUsers(req.query);

    if (!resDTO && resDTO.status !== "success") {
      return next(this.badRequest("Пользователи не найдены"));
    }

    this.ok(res, resDTO);
  };

  getUser = async (req: Request, res: Response, next: NextFunction) => {
    const { id } = req.query;

    if (!id) {
      return next(this.badRequest("Передайте значение для поиска"));
    }

    const getUserDTO: IGetUsersDTO = { id: Number(id), next };
    const resDTO = await this.service.getUser(getUserDTO);

    if (resDTO.status !== "success") return next(this.errors(resDTO));

    this.ok(res, resDTO);
  };

  checkBody = (req: Request, res: Response, next: NextFunction) => {
    const { login, password } = req.body;
    if (!login || !password) {
      return next(this.badRequest("Заполните обязательные поля"));
    }
    next();
  };

  registrationUser = async (
    req: Request,
    res: Response,
    next: NextFunction
  ) => {
    const { login, password, role } = req.body;
    const createUserDTO: ICreateUserDTO = { login, password, role };
    const resDTO: IResCreateUserDTO = await this.service.createUser(
      createUserDTO
    );

    if (resDTO.status !== "success") return next(this.errors(resDTO));

    // Создаем токен и передаем его на клиент
    const user = resDTO.data;
    console.log("USER", user);
    const token = this.jwtSign({
      id: user.id,
      login: user.login,
      role: user.role,
    });
    this.created(res, {
      status: "success",
      message: "Лови токен бро",
      token,
    });
  };

  login = async (req: Request, res: Response, next: NextFunction) => {
    const { login, password } = req.body;
    const resDTO: IResDTO<IUser> = await this.service.login(login, password);
    if (resDTO.status !== "success") return next(this.errors(resDTO));

    const totalRes = {
      status: resDTO.status,
      message: resDTO.message,
      token: this.jwtSign({
        id: resDTO.data.id,
        login: resDTO.data.login,
        role: resDTO.data.role,
      }),
    };
    this.ok(res, totalRes);
  };

  check = async (req: any, res: Response, next: NextFunction) => {
    const { id, login, role } = req.user;
    const token = this.jwtSign({ id, login, role });
    this.ok(res, {
      status: "success",
      message: "Ты сделал это! Красавчик!",
      token,
    });
  };

  jwtSign = ({ id, login, role }) => {
    return jwt.sign({ id, login, role }, process.env.SECRET_KEY, {
      expiresIn: "12h",
    });
  };

  checkToken = (req: any, res: Response, next: NextFunction) => {
    if (req.method === "OPTIONS") {
      next();
    }
    try {
      const token = req.headers.authorization.split(" ")[1];
      if (!token) {
        return res.status(401).json({
          status: "fail",
          message: "Пора авторизоваться, братик",
        });
      }
      const decoded = jwt.verify(token, process.env.SECRET_KEY);
      req.user = decoded;
      next();
    } catch (error) {
      console.log(error);
      res.status(401).json({
        status: "fail",
        message: "Пора авторизоваться, братик",
      });
    }
  };
}

export default new UsersController();
