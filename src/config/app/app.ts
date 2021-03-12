import testController from "../../test/test.controller";
import App, { IAppInit } from "../../classes/App";

const appInit: IAppInit = {
  apiVersion: process.env.API_VERSION,
  controllers: [testController],
};

export default new App(appInit);
