pragma solidity >=0.4.0 <0.6.0;
// This line says the code will compile with version greater than 0.4 and less than 0.6

contract Voting {

  struct voteRoom {
    bytes32 roomName;
    bytes32[] candidateList;
    mapping (bytes32 => uint8) votesReceived;
	bytes32 voteDate;
    bool exists;
  }

  uint8 roomCount = 1;
  mapping (uint8 => voteRoom) voteRoomList;

  function addVoteRoom(bytes32 _roomName, bytes32[] memory _candidateList, bytes32 _voteDate) public {
        uint8 index = roomCount;
		roomCount = roomCount + 1;

		voteRoomList[index].roomName = _roomName;
        voteRoomList[index].candidateList = _candidateList;
        for (uint i = 0; i < _candidateList.length; i++) {
            voteRoomList[index].votesReceived[_candidateList[i]] = 0;
        }
		voteRoomList[index].voteDate = _voteDate;
        voteRoomList[index].exists = true;
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
    // 1. check is room exists
    //require(voteRoomList[roomNumber].exists);
    // 2. check is candidate exists in the room
    //require(validCandidate(roomNumber, candidate));
    // 3. plus 1 to the room's candidate
    voteRoomList[roomNumber].votesReceived[candidate] += 1;
  }
  
  function totalVotesFor(uint8 roomNumber, bytes32 candidate) view public returns(uint8) {
    //require(validCandidate(roomNumber, candidate));
    return voteRoomList[roomNumber].votesReceived[candidate];
  }
}