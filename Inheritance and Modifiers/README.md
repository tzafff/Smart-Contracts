# Inheritance and Modifiers

This directory contains examples related to inheritance and modifiers in smart contracts.

## Contracts

### Ownable

The `Ownable.sol` contract implements a basic ownership functionality using the "Ownable" pattern. It includes a modifier to restrict access to specific functions only to the contract owner.

### Token

The `Token.sol` contract represents an example implementation of an ERC20 token contract. It showcases how to utilize inheritance to inherit functionalities from the OpenZeppelin `ERC20` contract and how to add custom modifiers for additional access control.

## Usage

To utilize the examples in this directory, follow these steps:

1. Make sure you have a compatible Ethereum development environment set up, such as Remix or Truffle.
2. Open the contract files (`Ownable.sol` and `Token.sol`) in your preferred Solidity editor.
3. Compile the contracts to ensure they are error-free and ready for deployment.
4. Deploy the contracts to an Ethereum network of your choice, providing necessary deployment parameters.
5. Once the contracts are deployed, you can interact with them through their provided functions and modifiers.

Note: The `Ownable` contract demonstrates the usage of the "Ownable" pattern for ownership control, while the `Token` contract showcases inheritance from an external library (OpenZeppelin) and the addition of custom modifiers.

## Additional Information

For more details about the code and functionalities of the contracts, please review the respective files in this directory.

