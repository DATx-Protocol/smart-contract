
pragma solidity ^0.4.18;

import './Ownable.sol';
import './SafeMath.sol';
import './DATxToken.sol';

contract TOKENCrowdsalePure is Ownable {
  using SafeMath for uint;

  Token public token;
  uint public totalToken;
  uint public tokenSaled = 0;
  
  bool public isFinalized = false;

  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint value, uint amount);
  event Finalized();

  function TOKENCrowdsalePure(address _token) public {
    require(_token != address(0));
    token = Token(_token);

    totalToken = 1250000000 * 10 ** uint(token.decimals());
  }

  function () external payable {
    buyTokens(msg.sender);
  }

  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(!isFinalized);
    uint ethValue = msg.value;
    require(ethValue >= 0.5 ether);

    uint needTokens = ethValue.mul(25000);
    tokenSaled = tokenSaled.add(needTokens);
    token.transfer(beneficiary, needTokens);
    owner.transfer(msg.value);
    TokenPurchase(msg.sender, beneficiary, ethValue, needTokens);
  }

  function finalize() onlyOwner public {
    require(!isFinalized);
    token.transfer(owner,token.balanceOf(this));
    isFinalized = true;
    Finalized();
  }
}