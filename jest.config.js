/**
 * SHOULD read https://jestjs.io/docs/en/configuration.html first
 */
module.exports = {
  moduleFileExtensions: ['js','ts'],
  // https://jestjs.io/docs/en/configuration#modulenamemapper-objectstring-string--arraystring
  moduleNameMapper: {
    '^@/(.*)': '<rootDir>/$1',
  },
  testEnvironment: 'node',
  testRegex: '.test.ts$',
  transform: {
    '^.+\\.(t|j)s$': 'ts-jest',
  },
  // preset: 'ts-jest',
  // testMatch: ['**/__test__/**/*.test.ts'],
  // coverageDirectory: 'coverage',
  // coveragePathIgnorePatterns: ['\\\\node_modules\\\\'],
  // testPathIgnorePatterns: ['\\\\node_modules\\\\', '\\\\dist\\\\'],
}
