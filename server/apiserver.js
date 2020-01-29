var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.json());

// Setting for Hyperledger Fabric
const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');
const ccpPath = path.resolve(__dirname, '..', 'fabnet', 'connection-manufacturer.json');


//add employee

app.post('/api/addEmployeeDetails/', async function (req, res) {
        console.log("entered into add employees api......");
        try {
    // Create a new file system based wallet for managing identities.
            const walletPath = path.join(process.cwd(), 'wallet');
            const wallet = new FileSystemWallet(walletPath);
            console.log(`Wallet path: ${walletPath}`);
    // Check to see if we've already enrolled the user.
            const userExists = await wallet.exists('user3');
            if (!userExists) {
                console.log('An identity for the user "user3" does not exist in the wallet');
                console.log('Run the registerUser.js application before retrying');
                return;
            }
    // Create a new gateway for connecting to our peer node.
            const gateway = new Gateway();
            await gateway.connect(ccpPath, { wallet, identity: 'user3', discovery: { enabled: true, asLocalhost: true } });
    // Get the network (channel) our contract is deployed to.
            const network = await gateway.getNetwork('fabnet-channel');
    // Get the contract from the network.
            const contract = network.getContract('mycc');
    // Submit the specified transaction.
            
            await contract.submitTransaction('addEmpDetails', req.body.empid, req.body.name, req.body.location, req.body.team);
           
            console.log('Transaction has been submitted');
            res.send('Transaction has been submitted');
    // Disconnect from the gateway.
            await gateway.disconnect();
    } catch (error) {
            console.error(`Failed to submit transaction: ${error}`);
            process.exit(1);
        }
    })

//query employee
var tx_id =null;
app.get('/api/query/:emp_index', async function (req, res) {
    try {
// Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
// Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user3');
        if (!userExists) {
            console.log('An identity for the user "user3" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }
// Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: 'user3', discovery: { enabled: true, asLocalhost: true } });
// Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('fabnet-channel');
// Get the contract from the network.
        const contract = network.getContract('mycc');
// Evaluate the specified transaction.
       
        const result = await contract.evaluateTransaction('queryEmpDetails', req.params.emp_index);
        
        console.log(`Transaction has been evaluated, result is: ${result.toString()}`);
        res.status(200).json({response: result.toString()});
} catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({error: error});
        process.exit(1);
    }
});

//delete employees

app.delete('/api/deleteEmployee/:index', async function (req, res) {
    try {
// Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);
// Check to see if we've already enrolled the user.
        const userExists = await wallet.exists('user3');
        if (!userExists) {
            console.log('An identity for the user "user3" does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }
// Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: 'user3', discovery: { enabled: true, asLocalhost: true } });
// Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('fabnet-channel');
// Get the contract from the network.
        const contract = network.getContract('mycc');
// Evaluate the specified transaction.
       
        const result = await contract.evaluateTransaction('deleteEmpDetails', req.params.index);
        
        console.log(`Transaction has been evaluated, deleted`);
        res.send('Transaction has been submitted, deleted ');
} catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        res.status(500).json({error: error});
        process.exit(1);
    }
});


app.listen(8080);
console.log("Running on port 8080...");