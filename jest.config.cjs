module.exports = {
  testEnvironment: 'node',
  roots: ['<rootDir>/test'],
  modulePaths: [
    "<rootDir>"
  ],
  testMatch: ['**/*.test.ts'],
  transform: {
    '^.+\\.tsx?$': 'ts-jest'
  }
};
