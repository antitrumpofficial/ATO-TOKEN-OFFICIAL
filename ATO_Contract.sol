// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Anti Trump Official Token (ATO)
 * @dev A professionally designed BEP-20 token with multiple DeFi utilities and humanitarian backing.
 * Author: antitrumpofficial.com
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AntiTrumpOfficial is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 300_000_000 * 10**18;
    address public taxWallet = 0xddb5baecc32c634a7242c9fee80493129d9d5ada;
    uint256 public taxRate = 100; // 1% = 100 basis points

    mapping(address => bool) private _isExcludedFromFee;

    constructor() ERC20("Anti Trump Official", "ATO") {
        _mint(msg.sender, INITIAL_SUPPLY);
        _isExcludedFromFee[msg.sender] = true;
        _isExcludedFromFee[address(this)] = true;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        address sender = _msgSender();

        if (_isExcludedFromFee[sender] || _isExcludedFromFee[to]) {
            _transfer(sender, to, amount);
        } else {
            uint256 taxAmount = (amount * taxRate) / 10000;
            uint256 netAmount = amount - taxAmount;

            _transfer(sender, taxWallet, taxAmount);
            _transfer(sender, to, netAmount);
        }

        return true;
    }

    function setTaxRate(uint256 newRate) external onlyOwner {
        require(newRate <= 500, "Max 5%");
        taxRate = newRate;
    }

    function setTaxWallet(address newWallet) external onlyOwner {
        require(newWallet != address(0), "Invalid wallet");
        taxWallet = newWallet;
    }

    function excludeFromFee(address account, bool excluded) external onlyOwner {
        _isExcludedFromFee[account] = excluded;
    }

    function isExcludedFromFee(address account) external view returns (bool) {
        return _isExcludedFromFee[account];
    }
}