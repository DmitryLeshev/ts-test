export default class BaseError extends Error {
  public status: number;
  public message: string;

  constructor(status: number, message: string) {
    super();
    this.status = status;
    this.message = message;
  }

  static forbidden = (message: string) => {
    return new BaseError(403, message);
  };

  static badRequest = (message: string) => {
    return new BaseError(404, message);
  };

  static internal = (message: string) => {
    return new BaseError(500, message);
  };
}
