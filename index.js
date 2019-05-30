import Web3 from "web3";
import votingArtifact from "../../build/contracts/Voting.json";

let candidates = {"Rama": "totalVotes-1", "Nick": "totalVotes-2", "Jose": "totalVotes-3"}
let roomNumber = 1;

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
   this.voting = new web3.eth.Contract(
    votingArtifact.abi,
    deployedNetwork.address,
   );

   // get accounts
   const accounts = await web3.eth.getAccounts();
   this.account = accounts[0];
   
   //this.test();
   //this.createVoteRoom();
   //this.loadCandidatesAndVotes();
  } catch (error) {
   console.error("Could not connect to contract or chain.");
  }
 },

 test: async function() {
   let candidateNames = Object.keys(candidates);
  for (var i = 0; i < candidateNames.length; i++) {
   let name = candidateNames[i];
   var count = i;
   $("#" + candidates[name]).html(count);
  }
 },

 createVoteRoom: async function() {
   const { addVoteRoom } = this.voting.methods;
   let candidateNames = Object.keys(candidates);
   let candidateList = new Array();
   for (var i = 0; i < candidateNames.length; i++) {
     candidateList[i] = this.web3.utils.asciiToHex(candidateNames[i]);
   }

   let roomName = this.web3.utils.asciiToHex("Room1");  
   var voteDate = this.web3.utils.asciiToHex("0530");
   await addVoteRoom(roomName,candidateList,voteDate).send({gas: 240000, from: this.account});
  },

 loadCandidatesAndVotes: async function() {
  const { totalVotesFor, getRoomName, getCandidateList, getVoteDate } = this.voting.methods;

  let roomName = await getRoomName(roomNumber).call();
  $("#roomName").html(this.web3.utils.hexToAscii(roomName));

  let candidateList = await getCandidateList(roomNumber).call();

  for (var i = 1; i <= candidateList.length; i++) {
    var name = this.web3.utils.hexToAscii(candidateList[i-1]);
    var count = await totalVotesFor(roomNumber,candidateList[i-1]).call();
    $("#candidate-" + i).html(name);
    $("#totalVotes-" + i).html(count);
  }




  let voteDate = await getVoteDate(roomNumber).call();
  $("#voteDate").html(this.web3.utils.hexToAscii(voteDate));
 },

 voteForCandidate: async function() {
  let candidateName = $("#candidate").val();
  $("#msg").html("Vote has been submitted. The vote count will increment as soon as the vote is recorded on the blockchain. Please wait.")
  $("#candidate").val("");

  const { totalVotesFor, voteForCandidate } = this.voting.methods;

  let roomName = this.web3.utils.asciiToHex("Room1");
  await voteForCandidate(roomNumber,this.web3.utils.asciiToHex(candidateName)).send({gas: 140000, from: this.account});
  let div_id = candidates[candidateName];
 
  var count = await totalVotesFor(roomNumber,this.web3.utils.asciiToHex(candidateName)).call();
  $("#" + div_id).html(count);
  $("#msg").html("");
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

