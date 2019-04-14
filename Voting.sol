pragma solidity >=0.4.0 <0.6.0;

contract Voting {
  
  // 후보자 명단
  bytes32[] public candidateList;
  // 후보자 명단과 투표 수 정보를 매핑
  mapping (bytes32 => uint8) public votesReceived;

  // 후보자 등록 함수
  // 생성자가 함수를 대신한다.
  constructor(bytes32[] memory candidateNames) public {
    candidateList = candidateNames;
  }
  
  // 투표 기능 함수
  function voteForCandidate(bytes32 candidate) public {
    // 정상적인 후보자 입력을 검사 
    require(validCandidate(candidate));
    // 후보자 정보에 투표 수를 1 올린다.
    votesReceived[candidate] += 1;
  }
  
  // 후보자 투표 수 산출 함수 
  function totalVotesFor(bytes32 candidate) view public returns(uint8) {
    // 정상적인 후보자 입력을 검사 
    require(validCandidate(candidate));
    // 투표 수 반환
    return votesReceived[candidate];
  }
  
  // 후보자 여부 검사 함수
  // 정상적인 후보자(현재 이름) 정보를 명단과 대조한다.
  function validCandidate(bytes32 candidate) view public returns (bool) {
    for(uint i=0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return true;
      }
    }
    return false;
  }
  
}