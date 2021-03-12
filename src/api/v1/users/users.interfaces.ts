import { NextFunction } from "express";

export interface IUser {
  id: number;
  login: string;
  password: string;
  age: number;
  status: string;
  role: number;
}

export interface IGetUsersDTO {
  id: number;
  next: NextFunction;
}

export interface IResUserDTO {
  status: string;
  data: IUser;
}

export interface ICreateUserDTO {
  login: string;
  password: string;
  role?: number;
}

export interface IResCreateUserDTO {
  status: string;
  message: string;
  data?: IUser;
}

export interface IResDTO<T> {
  status: string;
  message: string;
  data?: T;
}
