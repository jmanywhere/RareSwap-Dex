//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DummyLossless {
    event DummyBeforeTransfer(address from, address to, uint256 amount);
    event DummyBeforeTransferFrom(
        address executor,
        address from,
        address to,
        uint256 amount
    );

    function beforeTransfer(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        emit DummyBeforeTransfer(from, to, amount);
        return true;
    }

    function beforeTransferFrom(
        address executor,
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        emit DummyBeforeTransferFrom(executor, from, to, amount);
        return true;
    }
}
