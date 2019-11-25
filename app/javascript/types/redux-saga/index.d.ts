type SagaCall<S> = S extends (...args: any) => infer T
  ? T extends Promise<infer U>
    ? U
    : never
  : never;
