pragma solidity >=0.4.0 <0.6.0;

contract Voting {

 // We use the struct datatype to store the voter information.
 struct voter {
  address voterAddress; // 투표자의 주소, 주소 자료형
  uint tokensBought;  // 투표자가 가진 토큰의 총합
  uint[] tokensUsedPerCandidate; // 후보마다 투표에 쓰인 토큰수
  /* We have an array of candidates initialized below.
   Every time this voter votes with her tokens, the value at that
   index is incremented. Example, if candidateList array declared
   below has ["Rama", "Nick", "Jose"] and this
   voter votes 10 tokens to Nick, the tokensUsedPerCandidate[1]
   will be incremented by 10.
   */
 }// 각 투표자가 이러한 구조체를 가지게 된다.

 /* mapping is equivalent to an associate array or hash
  The key of the mapping is candidate name stored as type bytes32 and value is
  an unsigned integer which used to store the vote count
  */

 mapping (address => voter) public voterInfo;// 투표자 정보를 주소에 따라 조회할 수 있다.
 //투표자 정보 구조체를 주소가 키가 되어 투표자가 값이 되는 구조체가 생성

 /* Solidity doesn't let you return an array of strings yet. We will use an array of bytes32
  instead to store the list of candidates
  */

 mapping (bytes32 => uint) public votesReceived;// 받은 투표수를 기록

 bytes32[] public candidateList; // 후보자 리스트

 uint public totalTokens; // Total no. of tokens available for this election 총 토큰 수
 uint public balanceTokens; // Total no. of tokens still available for purchase 구매 가능한 토큰 수
 uint public tokenPrice; // Price per token  토큰당 가격

 /* When the contract is deployed on the blockchain, we will initialize
  the total number of tokens for sale, cost per token and all the candidates
  */
 constructor(uint tokens, uint pricePerToken, bytes32[] memory candidateNames) public {
  candidateList = candidateNames; 
  totalTokens = tokens;//
  balanceTokens = tokens;
  tokenPrice = pricePerToken;
 }// 생성자, 토큰 가격 생성, 현재 생성하여 하나도 팔리지 않았으므로 총 토큰수, 구매가능한 토큰수는 설정한 token변수

  //1. Users should be able to purchase tokens 토큰을 구입할 수 있어야 한다.
  //2. Users should be able to vote for candidates with tokens 토큰으로 후보자에게 투표할 수 있어야한다.
  //3. Anyone should be able to lookup voter info 투표자 정보를 확인할 수 있어야 한다.
  function buy() payable public {//지불 기능을 담을때는 payable을 사용해야 한다.
    uint tokensToBuy = msg.value / tokenPrice;// msg value를 사용하면 이더를 얼마나 보냈는지 확인 (wei단위)
    require(tokensToBuy <= balanceTokens);//살려는 토큰의 양이 현재 팔수 있는 토큰의 양보다는 작아야한다.
    voterInfo[msg.sender].voterAddress = msg.sender;//msg.sender는 어느 계정이 buy함수를 호출햇는지 알려줌  
    voterInfo[msg.sender].tokensBought += tokensToBuy;// 토큰이 사졌으니 계정의 구조체에 구매한 토큰의 양을 늘려야 한ㅁ
    balanceTokens -= tokensToBuy; // 구매가능한 토큰을 산 만큼의 토큰만큼 빼야함
  }
    function voteForCandidate(bytes32 candidate, uint tokens) public {
    // Check to make sure user has enough tokens to vote 투표를 위한 토큰이 충분히 존재하는지 확인
    // Increment vote count for candidate 투표의 횟수를 증가
    // Update the voter struct tokensUsedPerCandidate for this voter  구조체의 내용 업데이트
     //  투표할 후보자 특정 뿐 아니라 몇개의 토큰을 이 후보자에게 투표할 것인지
    uint availableTokens = voterInfo[msg.sender].tokensBought - totalTokensUsed(voterInfo[msg.sender].tokensUsedPerCandidate);
   // 사용자가 구입한 토큰에서 투표에 사용한 총 토큰 수를 뺀 값
    require(tokens <= availableTokens, "You don't have enough tokens");// 토큰이 충분하지 않으면 겨고문
    votesReceived[candidate] += tokens;
     
    if(voterInfo[msg.sender].tokensUsedPerCandidate.length == 0) {//초기화
      for(uint i=0; i<candidateList.length; i++) {
        voterInfo[msg.sender].tokensUsedPerCandidate.push(0);
      }
    }
     
    uint index = indexOfCandidate(candidate);
    voterInfo[msg.sender].tokensUsedPerCandidate[index] += tokens;//해당 후보자의  
  }
   
  function indexOfCandidate(bytes32 candidate) view public returns(uint) {
    for(uint i=0; i<candidateList.length; i++) {
      if (candidateList[i] == candidate) {//후보자 명단을 읊으면서 해당되는 것이 있으면 그 index를 반환
        return i;
      }
    }
    return uint(-1);
  }

  function totalTokensUsed(uint[] memory _tokensUsedPerCandidate) private pure returns (uint) {//내부에서만 호출하고 읽기 전용이므로 private view
    uint totalUsedTokens = 0;
    for(uint i=0; i<_tokensUsedPerCandidate.length; i++) {
      totalUsedTokens += _tokensUsedPerCandidate[i];// 투표 총 횟수 체크
    }
    return totalUsedTokens;
  } 
  function voterDetails(address user) view public returns (uint, uint[] memory) {//후보자 정보 반환,투표자 주소에 대해 구입한 만큼의 투표와 정보 만한
    return (voterInfo[user].tokensBought, voterInfo[user].tokensUsedPerCandidate);
  }
   
  function tokensSold() public view returns (uint) {
    return totalTokens - balanceTokens; //토큰 얼마나 팔았는가
  }
   
  function allCandidates() public view returns (bytes32[] memory) {
    return candidateList;//후보자 리스트 목록
  }
   
  function totalVotesFor(bytes32 candidate) public view returns (uint) {
    return votesReceived[candidate];//각 후보가 받은 투표자 전체 표수
  }
}
