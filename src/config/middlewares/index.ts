import * as bodyParser from "body-parser";
import * as fileUpload from "express-fileupload";
import * as morgan from "morgan";

const middlewares = () => {
  let array = [
    bodyParser.json(),
    bodyParser.urlencoded({ extended: true }),
    fileUpload({}),
  ];
  if (process.env.NODE_ENV === "development") {
    array.push(morgan("dev"));
  }
  return array;
};

export default middlewares();
