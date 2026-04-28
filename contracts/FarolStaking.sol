// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

interface ILumenToken is IERC20 {
    function mint(address to, uint256 amount) external;
}

interface ILenteQuartzo {
    function checkMembro(address usuario) external view returns (bool);
}

contract FarolStaking is ReentrancyGuard, Ownable {
    ILumenToken public immutable rewardToken;
    ILenteQuartzo public immutable nftContract;
    AggregatorV3Interface internal immutable priceFeed;

    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastUpdate;

    uint256 public constant REWARD_RATE = 100 * 10**18;

    constructor(address _rewardToken, address _nftContract, address _priceFeed) Ownable(msg.sender) {
        rewardToken = ILumenToken(_rewardToken);
        nftContract = ILenteQuartzo(_nftContract);
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        require(price > 0, "Preco invalido");
        return price;
    }

    function stake() public payable nonReentrant {
        require(nftContract.checkMembro(msg.sender), "Nao possui NFT de acesso");
        require(msg.value > 0, "Valor deve ser maior que zero");
        
        uint256 reward = calculateReward(msg.sender);
        
        // slither-disable-next-line timestamp
        lastUpdate[msg.sender] = block.timestamp;
        balances[msg.sender] += msg.value;

        if (reward > 0) {
            rewardToken.mint(msg.sender, reward);
        }
    }

    function claimReward() public nonReentrant {
        uint256 reward = calculateReward(msg.sender);
        if (reward > 0) {
            // slither-disable-next-line timestamp
            lastUpdate[msg.sender] = block.timestamp;
            rewardToken.mint(msg.sender, reward);    
        }
    }

    function calculateReward(address account) public view returns (uint256) {
        if (balances[account] < 1 || lastUpdate[account] < 1) return 0;
        
        // slither-disable-next-line timestamp
        uint256 timeStaked = block.timestamp - lastUpdate[account];
        return (balances[account] * timeStaked * REWARD_RATE) / 1 ether;
    }

    function withdraw() public nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Sem saldo");
        
        uint256 reward = calculateReward(msg.sender);
        
        balances[msg.sender] = 0;
        // slither-disable-next-line timestamp
        lastUpdate[msg.sender] = block.timestamp;

        if (reward > 0) {
            rewardToken.mint(msg.sender, reward);
        }

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Falha ao enviar o ETH");
    }
}