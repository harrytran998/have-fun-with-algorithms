export class Comparator {
  private compare: Function

  constructor(compareFunction: Function) {
    this.compare = compareFunction || Comparator.defaultCompareFunction
  }

  /**
   * Default comparison function. It just assumes that "a" and "b" are strings or numbers.
   */
  static defaultCompareFunction(a: string | number, b: string | number) {
    if (a === b) {
      return 0
    }

    return a < b ? -1 : 1
  }

  /**
   * Checks if two variables are equal.
   */
  equal<T>(a: T, b: T) {
    return this.compare(a, b) === 0
  }

  /**
   * Checks if variable "a" is less than "b".
   */
  lessThan<T>(a: T, b: T) {
    return this.compare(a, b) < 0
  }

  greaterThan<T>(a: T, b: T) {
    return this.compare(a, b) > 0
  }

  /**
   * Checks if variable "a" is less than or equal to "b".
   */
  lessThanOrEqual<T>(a: T, b: T) {
    return this.lessThan(a, b) || this.equal(a, b)
  }

  /**
   * Checks if variable "a" is greater than or equal to "b".
   */
  greaterThanOrEqual<T>(a: T, b: T) {
    return this.greaterThan(a, b) || this.equal(a, b)
  }

  /**
   * Reverses the comparison order.
   */
  reverse<T>() {
    const compareOriginal = this.compare
    this.compare = (a: T, b: T) => compareOriginal(b, a)
  }
}
