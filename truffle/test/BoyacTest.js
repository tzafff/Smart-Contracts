const Boyac = artifacts.require("CheapBoredApeYachtClub")

contract("Spacebear", (accounts) => {
    it ("should credit and nft to specific account", async() => {
        const boacInstance = await Boyac.deployed();
        let txResult = await boacInstance.safeMint(accounts[1],"boayc_2.json");
        assert.equal(txResult.logs[0].event,"Transfer", "Event is not the transfer Event")
        assert.equal(await boacInstance.ownerOf(0), accounts[1], "Owner of token 1 is not equal to account 2");
    })
})
