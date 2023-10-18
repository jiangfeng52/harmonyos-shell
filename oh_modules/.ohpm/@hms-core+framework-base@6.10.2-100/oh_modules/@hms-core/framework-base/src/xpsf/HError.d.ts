import { HObject } from "./HObject";

export class HError {
  code: number;
  message: string;
  data: object;
  solution: HObject

  constructor(code: number, message: string);

  setData(data: object): void;

  setSolution(coreSolution: HObject): void;
}