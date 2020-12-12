// Visual what's look the linked list https://ibb.co/zSk2xm5

import { Comparators } from '@/utils/comparators';
import { Nullable, LinkedListNode } from '@/utils/type';

export interface ILinkedList<T> {
  prepend(value: T): LinkedList<T>;
  append(value: T): LinkedList<T>;
  delete(value: T): Nullable<LinkedListNode<T>>;
  deleteTail(): Nullable<LinkedListNode<T>>;
  deleteHead(): Nullable<LinkedListNode<T>>;
  fromArray(values: T[]): LinkedList<T>;
  toArray(): LinkedListNode<T>[];
  reverse(): LinkedList<T>;
  toString(): string;
}

export class LinkedList<T> implements ILinkedList<T> {
  public tail!: Nullable<LinkedListNode<T>>;
  public head!: Nullable<LinkedListNode<T>>;
  public compare!: Comparators;

  constructor(comparatorsFn?: Function) {
    this.head = null;
    this.tail = null;
    if (comparatorsFn) {
      this.compare = new Comparators(comparatorsFn);
    }
  }

  /*
   * Big O = O(1)
   * Độ phức tạp = O(1) = nhanh nhất
   */
  prepend(value: T) {
    // Make new node to be a head.
    // Tạo mới 1 node đẩy vào đầu tiên = head
    const newNode: LinkedListNode<T> = { value, next: this.head };
    this.head = newNode;

    // If there is no tail yet let's make new node a tail.
    // Nếu chưa có tail, cho cái tail = cái node mới luôn
    if (!this.tail) {
      this.tail = newNode;
    }

    return this;
  }

  append(value: T) {
    const newNode: LinkedListNode<T> = { value };
    if (!this.head) {
      this.head = this.tail = newNode;
      return this;
    }

    // will assign `this.tail.next` first
    this.tail = this.tail!.next = newNode;
    return this;
  }

  // If next node must be deleted then make next node to be a next next one.
  delete(value: T) {
    if (!this.head) return null;

    let deletedNode: Nullable<LinkedListNode<T>> = null;

    // Case 1: The head must be deleted ==>
    // Make next node that is differ from the head to be a new head.
    while (this.head && this.compare.equal(this.head.value, value)) {
      deletedNode = this.head;
      if (this.head?.next) {
        this.head = this.head.next;
      }
    }

    // Case 2: Random next node(except head and tail) must be deleted ==>
    // make next node to be a next next one.
    // We start going from 2nd element --> n element
    let currentNode = this.head;

    if (currentNode !== null) {
      let currentNodeNext = currentNode?.next;
      while (currentNodeNext) {
        if (this.compare.equal(currentNodeNext.value, value)) {
          deletedNode = currentNodeNext;
          currentNodeNext = currentNodeNext.next;
        } else {
          currentNode = currentNodeNext;
        }
      }
    }

    // Case 3: The tail must be deleted.
    // In this time, the current node went to the (last - 1) element of the list
    // Remove the tail = reference it to current node
    if (this.compare.equal(this.tail?.value, value)) {
      this.tail = currentNode;
    }

    return deletedNode;
  }

  find({ value }: any) {
    if (!this.head) return null;
    let currentNode = this.head;

    while (currentNode) {
      if (value !== undefined && this.compare.equal(currentNode.value, value)) {
        return currentNode;
      }
      if (currentNode.next) {
        currentNode = currentNode.next;
      }
    }

    return null;
  }

  deleteTail() {
    const deletedTail = this.tail;

    // Case 1: There is only one node in linked list.
    if (this.head === this.tail) {
      this.head = this.tail = null;
      return deletedTail;
    }

    // Case 2: Have many nodes in linked list.
    // Rewind to the last node and delete "next" link for the node before the last one.
    let currentNode = this.head;
    while (currentNode?.next) {
      if (!currentNode.next.next) {
        currentNode.next = null;
      } else {
        currentNode = currentNode.next;
      }
    }

    this.tail = currentNode;

    return deletedTail;
  }

  deleteHead() {
    // Case 1: linked list null.
    if (!this.head) {
      return null;
    }

    const deletedHead = this.head;
    if (this.head.next) {
      this.head = this.head.next;
    } else {
      // Case 2: Have 1 node in linked list.
      this.head = this.tail = null;
    }

    return deletedHead;
  }

  fromArray(values: T[]) {
    values.forEach((value) => this.append(value));
    return this;
  }

  toArray() {
    const nodes: LinkedListNode<T>[] = [];
    let currentNode = this.head;

    while (currentNode) {
      nodes.push(currentNode);
      if (currentNode.next) {
        currentNode = currentNode.next;
      }
    }

    return nodes;
  }

  reverse() {
    let prevNode = null;
    let currNode = this.head;
    let nextNode = null;

    while (currNode?.next) {
      // Store next node.
      nextNode = currNode.next;
      // Change next node of the current node so it would link to previous node.
      currNode.next = prevNode;
      // Move prevNode and currNode nodes one step forward.
      prevNode = currNode;
      currNode = nextNode;
    }

    // Reset head and tail.
    this.tail = this.head;
    this.head = prevNode;

    return this;
  }

  toString() {
    return `${this}`;
  }
}
