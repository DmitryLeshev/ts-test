import { QueryResult } from "pg";
import { BaseService } from "../../../classes";
import {
  ICreateUserDTO,
  IGetUsersDTO,
  IResCreateUserDTO,
  IResDTO,
  IUser,
} from "./users.interfaces";
import * as bcrypt from "bcrypt";

export default class UsersService extends BaseService {
  hasPassword = async (password: string, value: number) => {
    return await bcrypt.hash(password, value);
  };

  getUsers = async (filters: any) => {
    try {
      const { login, status } = filters;
      const page = filters.page || 1;
      const limit = filters.limit || 10;
      const offset = page * limit - limit;
      let query: string;
      if (!login && !status) {
        query = `SELECT * FROM users u ORDER BY u.login ASC LIMIT ${limit} OFFSET ${offset}`;
      }
      if (login && !status) {
        query = `SELECT * FROM users u WHERE login ILIKE '%${login}%' ORDER BY u.login ASC LIMIT ${limit} OFFSET ${offset}`;
      } else if (!login && status) {
        query = `SELECT * FROM users u WHERE status ILIKE '%${status}%' ORDER BY u.login ASC LIMIT ${limit} OFFSET ${offset}`;
      } else if (login && status) {
        query = `SELECT * FROM users u WHERE login ILIKE '%${login}%' AND status ILIKE '%${status}%' ORDER BY u.login ASC LIMIT ${limit} OFFSET ${offset}`;
      }
      const res: QueryResult = await this.query(query);
      const users = res.rows;
      if (!users.length) return this.failDTO("Чувак, у массива нет длины🧐");
      return this.okDTO(users, "Красава, вот твои пользователи");
    } catch (error) {
      console.log(error);
      return this.errorDTO("Error!!!🤬 'CATCH' for getUsers");
    }
  };

  getUser = async (dto: IGetUsersDTO) => {
    const { id } = dto;
    try {
      let query: string;
      if (id) {
        query = `SELECT * FROM users WHERE id = ${id}`;
      }
      const res: QueryResult = await this.query(query);
      const user = res.rows[0];
      if (!user) {
        return this.failDTO(
          "Что-то пошло не так 🤨 такого пользователя я не нашел"
        );
      }
      return this.okDTO(user, "Красава бро, вот твой пользователь");
    } catch (error) {
      console.log(error);
      return this.errorDTO(`Отработал 'сatch' у getUser`);
    }
  };

  createUser = async (dto: ICreateUserDTO) => {
    const { login, password, role } = dto;
    try {
      // Проверяем на наличие пользователя
      let query = `SELECT * FROM users WHERE login = '${login}'`;
      const candidate = await (await this.query(query)).rows[0];
      if (candidate) return this.failDTO("Такой пользователь уже есть");
      // Хешируем пароль
      const hasPassword = await this.hasPassword(password, 5);
      // Создаем пользователя
      query = `INSERT INTO users (login, password) VALUES ('${login}', '${hasPassword}') RETURNING *`;
      const user: IUser = await (await this.query(query)).rows[0];
      if (!user) return this.failDTO("Не получилось создать пользователя");
      // Создаем роль
      query = `INSERT INTO users_roles (user_id, role_id) VALUES('${
        user.id
      }', ${role || 2}) RETURNING *`;
      const userRole = await (await this.query(query)).rows[0];
      if (!userRole) return this.failDTO("USER + ROLE -");
      user.role = role || 2;
      const resDto: IResCreateUserDTO = this.okDTO(
        user,
        "Новый пользователь РОДИЛСЯ 🥰"
      );
      return resDto;
    } catch (error) {
      console.log(error);
      return this.errorDTO(`Отработал 'сatch' у createUser`);
    }
  };

  login = async (login: string, password: string) => {
    try {
      let query = `SELECT u.*, ur.role_id as role FROM users u LEFT JOIN users_roles ur ON u.id = ur.user_id WHERE login = '${login}'`;
      const user: IUser = await (await this.query(query)).rows[0];
      if (!user) return this.failDTO("Неа, нету такого");
      const comparePassword = bcrypt.compareSync(password, user.password);
      if (!comparePassword) return this.failDTO("Не верный пароль");
      const resDto: IResDTO<IUser> = this.okDTO(
        user,
        "Чётко, ты прошел проверку"
      );
      return resDto;
    } catch (error) {
      console.log(error);
      return this.errorDTO(`Отработал 'сatch' у login`);
    }
  };
}
