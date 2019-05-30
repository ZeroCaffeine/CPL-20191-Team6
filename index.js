import Web3 from "web3";
import votingArtifact from "../../build/contracts/Voting.json";

let candidates = {"Rama": "totalVotes-1", "Nick": "totalVotes-2", "Jose": "totalVotes-3"}
let roomNumber = 2;

const App = {
 web3: null,
 account: null,
 voting: null,

 start: async function() {
  const { web3 } = this;

  try {
   // get contract instance
   const networkId = await web3.eth.net.getId();
   const deployedNetwork = votingArtifact.networks[networkId];

   $("#test").html("State : testing now...");
   this.voting = new web3.eth.Contract(
    votingArtifact.abi,
    deployedNetwork.address,
   );
   $("#test").html("State : Instance work!");

   // get accounts
   const accounts = await web3.eth.getAccounts();
   this.account = accounts[0];
   
   $("#test").html("State : creation start...");
   this.createVoteRoom();
   $("#test").html("State : load room data...");
   this.loadRoomData();
   $("#test").html("State : load candidates and votes...");
   this.loadCandidatesAndVotes();

  } catch (error) {
   console.error("Could not connect to contract or chain.");
  }
 },

 createVoteRoom: async function() {
   const { addVoteRoom } = this.voting.methods;
   $("#test1").html("State 1 : createVoteRoom start.");
   var candidateNames = ["Finn", "Jake", "Bubblegum"];
   var candidateList = new Array();
   for (var i = 0; i < candidateNames.length; i++) {
     candidateList[i] = this.web3.utils.asciiToHex(candidateNames[i]);
   }

   let roomName = this.web3.utils.asciiToHex("Room1");  
   let voteDate = this.web3.utils.asciiToHex("0530");
   //var check = await addVoteRoom(roomName,candidateList,voteDate).call();
   var check = await addVoteRoom(roomName,candidateList,voteDate).send({gas: 320000, from: this.account});
   $("#test1").html("State 1 : createVoteRoom finished");   
  },

 loadRoomData: async function() {
   const { getRoomName, getVoteDate } = this.voting.methods;
   
   var roomName = await getRoomName(roomNumber).call();
   var voteDate = await getVoteDate(roomNumber).call();
 
   $("#roomName").html(this.web3.utils.hexToAscii(roomName));
   $("#voteDate").html(this.web3.utils.hexToAscii(voteDate));
 },

 loadCandidatesAndVotes: async function() {
   const { getCandidateList, totalVotesFor } = this.voting.methods;
   $("#test2").html("State 2 : loadCandidatesAndVotes start.");
   var candidateList = await getCandidateList(roomNumber).call();

   for (var i = 1; i <= candidateList.length; i++) {
     var name = this.web3.utils.hexToAscii(candidateList[i-1]);
     $("#candidate-" + i).html(name);
    
     var count = await totalVotesFor(roomNumber,candidateList[i-1]).call();
     $("#totalVotes-" + i).html(count);
   }
   
   $("#test2").html("State 2 : loadCandidatesAndVotes finished.");
 },

 voteForCandidate: async function() {
  const { totalVotesFor, voteForCandidate } = this.voting.methods;
  var candidateName = $("#candidate").val();
  $("#test3").html("State 3 : voteForCandidate start.");
  $("#candidate").val("");

  await voteForCandidate(roomNumber,this.web3.utils.asciiToHex(candidateName)).send({gas: 600000, from: this.account});

  this.loadCandidatesAndVotes();

  $("#test3").html("State 3 : voteForCandidate finished.");
 }  

};

window.App = App;

window.addEventListener("load", function() {
 if (window.ethereum) {
  $("#" + candidates[name]).html("Ropsten");
  // use MetaMask's provider
  App.web3 = new Web3(window.ethereum);
  window.ethereum.enable(); // get permission to access accounts
 } else {
  $("#" + candidates[name]).html("Not working");
  console.warn(
   "No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live",
  );
  // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
  App.web3 = new Web3(
   new Web3.providers.HttpProvider("http://127.0.0.1:8545"),
  );
 }

 App.start();
});

