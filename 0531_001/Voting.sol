pragma solidity >=0.4.0 <0.6.0;
// This line says the code will compile with version greater than 0.4 and less than 0.6

contract Voting {
  // constructor to initialize candidates
  // vote for candidates
  // get count of votes for each candidates
  
  struct voteRoom {
    bytes32 roomName;
    bytes32[] candidateList;
    mapping (bytes32 => uint8) votesReceived;
	bytes32 voteDate;
    bool exists;
  }

  mapping (uint8 => voteRoom) voteRoomList;
  uint8 roomCount = 1;

  function addVoteRoom(bytes32 _roomName, bytes32[] memory _candidateList, bytes32 _voteDate) public {
  
        voteRoomList[roomCount].roomName = _roomName;
		voteRoomList[roomCount].candidateList = _candidateList;
        for (uint i = 0; i < _candidateList.length; i++) {
            voteRoomList[roomCount].votesReceived[_candidateList[i]] = 0;
        }
        voteRoomList[roomCount].voteDate = _voteDate;
        voteRoomList[roomCount].exists = true;
  
		roomCount = roomCount + 1;
  }

  function getRoomCount() view public returns(uint8) {
	return roomCount - 1;
  }

  function getRoomName(uint8 roomNumber) view public returns(bytes32) {
	return voteRoomList[roomNumber].roomName;
  }

  function getCandidateList(uint8 roomNumber) view public returns(bytes32[] memory) {
	return voteRoomList[roomNumber].candidateList;
  }

  function getVoteDate(uint8 roomNumber) view public returns(bytes32) {
	return voteRoomList[roomNumber].voteDate;
  }

  function voteForCandidate(uint8 roomNumber, bytes32 candidate) public {
    voteRoomList[roomNumber].votesReceived[candidate] += 1;
  }

  function totalVotesFor(uint8 roomNumber, bytes32 candidate) view public returns(uint8) {
    return voteRoomList[roomNumber].votesReceived[candidate];
  }
}