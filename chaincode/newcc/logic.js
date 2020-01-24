'use strict';
const { Contract} = require('fabric-contract-api');

class testContract extends Contract {



   async queryEmpDetails(ctx,empId) {
   
    let detailsAsBytes = await ctx.stub.getState(empId); 
    if (!detailsAsBytes || detailsAsBytes.toString().length <= 0) {
      throw new Error('Employee with this Id does not exist: ');
       }
      let details=JSON.parse(detailsAsBytes.toString());
      
      return JSON.stringify(details);
     }

   async addEmpDetails(ctx,empId,name,location,team) {
   
    let details={
       eName:name,
       eLocation:location,
       eTeam:team
       };

    await ctx.stub.putState(empId,Buffer.from(JSON.stringify(details))); 
    
    console.log('Student Marks added To the ledger Succesfully..');
    
  }

   async deleteEmpDetails(ctx,empId) {
   

    await ctx.stub.deleteState(empId); 
    
    console.log('Employee details deleted from the ledger Succesfully..');
    
    }
}

module.exports=testContract;
