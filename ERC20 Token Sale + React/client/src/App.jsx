
import MyToken from "./contracts/MyToken.json";
import MyTokenSale from "./contracts/MyTokenSale.json"
import KycContract from "./contracts/KycContract.json"
import web3 from "web3";
import React, { Component } from "react";

class App extends Component {
  state = { loaded:false, kycAddress: "0x123...",tokenSaleAddress: null, userTokens:0 };

  componentDidMount = async () => {
    try {
      this.web3 = new web3(web3.givenProvider || "http://192.168.1.9:8080/");
      const accounts = await this.web3.eth.getAccounts();
      this.accounts = accounts;
      

      this.networkId = await this.web3.eth.net.getId();

      this.tokenInstance = new this.web3.eth.Contract(
        MyToken.abi,
        MyToken.networks[this.networkId] && MyToken.networks[this.networkId].address,
      );

    

      this.tokenSaleInstance = new this.web3.eth.Contract(
        MyTokenSale.abi,
        MyTokenSale.networks[this.networkId] && MyTokenSale.networks[this.networkId].address,
      );  
      
      this.kycInstance = new this.web3.eth.Contract(
        KycContract.abi,
        KycContract.networks[this.networkId] && KycContract.networks[this.networkId].address,
      );  
      this.listenToTokenTransfer();
      this.setState({loaded:true, tokenSaleAddress:MyTokenSale.networks[this.networkId].address, userTokens:this.updateUserTokens});
      this.updateUserTokens();
    }
    catch (error){
      console.log(error)
    }
  };


updateUserTokens = async() => {
  let userTokens = await this.tokenInstance.methods.balanceOf(this.accounts[0]).call();
   console.log(userTokens)
  this.setState({userTokens: userTokens});
}

listenToTokenTransfer = () => {
  this.tokenInstance.events.Transfer({to: this.accounts[0]}).on("data", this.updateUserTokens)
}

handleBuyTokens = async() => {
  await this.tokenSaleInstance.methods.buyTokens(this.accounts[0]).send({from: this.accounts[0], value: this.web3.utils.toWei("1","wei")});
}

handleInputChange = (event) => {
  const target = event.target;
  const value = target.type === "checkbox" ? target.checked : target.value;
  const name = target.name;
  this.setState({
    [name]: value
  });
}

handleKycWhitelisting = async () => {
  
  if (!this.accounts || !this.accounts[0]) {
    console.error("No accounts found.");
    return;
  }
  await this.kycInstance.methods.setKycCompleted(this.state.kycAddress).send({from: this.accounts[0]});
  alert("KYC for" + this.state.kycAddress+ " is completed")
}

  render() {
    if(!this.state.loaded){
      return <div>Loading web3</div>
    }
    return (
      <div
    className="App"
    style={{
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
      justifyContent: "center",
      height: "100vh",
      background: "#9324D3", // Replace with your desired color,
    }}
  >
    <div style={{ backgroundColor: "rgba(255, 255, 255, 0.8)", padding: "4rem", borderRadius: "0.5rem" }}>
      <h1 style={{ fontSize: "3rem", marginBottom: "2rem", textAlign: "center" }}>Trade Bot Token SALE!!</h1>
      <p style={{ fontSize: "1.5rem", marginBottom: "3rem", textAlign: "center" }}>Get your Tokens today!</p>
      <div className="form-container" style={{ marginBottom: "3rem" }}>
        <h2 style={{ fontSize: "2rem", marginBottom: "1rem", textAlign: "center" }}>Kyc WhiteListing</h2>
        <div style={{ display: "flex", alignItems: "center", justifyContent: "center", marginBottom: "1rem" }}>
          <label htmlFor="kycAddress" style={{ marginRight: "0.5rem", fontSize: "1.5rem" }}>
            Address to allow:
          </label>
          <input type="text" name="kycAddress" id="kycAddress" value={this.state.kycAddress} onChange={this.handleInputChange} style={{ padding: "0.5rem", fontSize: "1.5rem" }} />
        </div>
        <div style={{ display: "flex", justifyContent: "center" }}>
        <button type="button" onClick={this.handleKycWhitelisting} style={{ padding: "0.5rem 1rem", fontSize: "1.5rem" }}>
            Add  address to Whitelist
          </button>
        </div>
      </div>
      <div className="buy-tokens-container">
        <h2 style={{ fontSize: "2rem", marginBottom: "1rem", textAlign: "center" }}>Buy Tokens</h2>
        <p style={{ fontSize: "1.5rem", marginBottom: "2rem", textAlign: "center" }}>If you want to buy tokens, send Wei to this address:</p>
        <p style={{ fontFamily: "monospace", fontSize: "1.5rem", marginBottom: "2rem", textAlign: "center" }}>{this.state.tokenSaleAddress}</p>
        <p style={{ fontSize: "1.5rem", marginBottom: "2rem", textAlign: "center" }}>You currently have: {this.state.userTokens}</p>
        <div style={{ display: "flex", justifyContent: "center" }}>
          <button type="button" onClick={this.handleBuyTokens} style={{ padding: "0.5rem 1rem", fontSize: "1.5rem" }}>
            Buy more tokens
          </button>
        </div>
      </div>
    </div>
  </div>
    );
  }

}

  


export default App;