export type Nullable<T> = T | null;

export type LinkedListNode<T> = {
  value?: T;
  next?: Nullable<LinkedListNode<T>>;
  toString(): string;
};
