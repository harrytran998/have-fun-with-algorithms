// Visual what's look the linked list https://ibb.co/zSk2xm5

import { Comparator } from '../../utils/comparator/Comparator'
import { LinkedListNode, Nullable } from '../../utils/type'

export interface ILinkedList<T> {
  prepend(value: T): LinkedList<T>
  append(value: T): LinkedList<T>
  delete(value: T): Nullable<LinkedListNode<T>>
}

export class LinkedList<T> implements ILinkedList<T> {
  private tail?: Nullable<LinkedListNode<T>>
  private head?: Nullable<LinkedListNode<T>>
  private compare: Comparator

  constructor(comparatorFn: Function) {
    this.head = null
    this.tail = null
    this.compare = new Comparator(comparatorFn)
  }

  /*
   * Big O = O(1)
   * Độ phức tạp = O(1) = nhanh nhất
   */
  prepend(value: T) {
    // Make new node to be a head.
    // Tạo mới 1 node đẩy vào đầu tiên = head
    const newNode: LinkedListNode<T> = { value, next: this.head }
    this.head = newNode

    // If there is no tail yet let's make new node a tail.
    // Nếu chưa có tail, cho cái tail = cái node mới luôn
    if (!this.tail) {
      this.tail = newNode
    }

    return this
  }

  append(value: T) {
    const newNode: LinkedListNode<T> = { value }
    if (!this.head) {
      this.head = this.tail = newNode
      return this
    }

    // will assign `this.tail.next` first
    this.tail = this.tail.next = newNode
    return this
  }

  // If next node must be deleted then make next node to be a next next one.
  delete(value: T) {
    if (!this.head) return null

    let deletedNode: Nullable<LinkedListNode<T>> = null

    // Case 1: The head must be deleted ==>
    // Make next node that is differ from the head to be a new head.
    while (this.head && this.compare.equal(this.head.value, value)) {
      deletedNode = this.head
      this.head = this.head.next
    }

    // Case 2: Random next node(except head and tail) must be deleted ==>
    // make next node to be a next next one.
    // We start going from 2nd element --> n element
    let currentNode = this.head

    if (currentNode !== null) {
      while (currentNode.next) {
        if (this.compare.equal(currentNode.next.value, value)) {
          deletedNode = currentNode.next
          currentNode.next = currentNode.next.next
        } else {
          currentNode = currentNode.next
        }
      }
    }

    // Case 3: The tail must be deleted.
    // In this time, the current node went to the (last - 1) element of the list
    // Remove the tail = reference it to current node
    if (this.compare.equal(this.tail.value, value)) {
      this.tail = currentNode
    }

    return deletedNode
  }
}
