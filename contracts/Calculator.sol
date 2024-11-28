// SPDX-License-Identifier: MIT

// 1️⃣ Make a contract called Calculator
// 2️⃣ Create Result variable to store result
// 3️⃣ Create functions to add, subtract, and multiply to result
// 4️⃣ Create a function to get result

pragma solidity ^0.8.26;

contract Calculator { 

  uint256 result = 0;

  function add(uint256 num) external  {
    result += num;
  }

  function subtract(uint256 num) public {
    result -= num;
  }

    function multiply(uint256 num) public {
    result *= num;
  }

  function get() public view returns (uint256) {
    return result;
  }
}