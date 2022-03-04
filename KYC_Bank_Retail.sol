    // SPDX-License-Identifier: GPL-3.0

    pragma solidity >=0.8.0;

    contract RetailBankingKYC{

//Central Bank is the owner 
        address owner;
        constructor() {
            owner=msg.sender;

        }

        modifier isOwner() {
            require(msg.sender == owner, "Caller is not owner");
            _;
    }
//Bank Model

        struct bank{
        string name;
        address eth_address;
        uint8 kycCount;
        bool canAddCustomer;
        bool canKYC;
        }

        bank _bank;

        mapping(address=>bank) _banks;

//Customer Model

        struct customer{
        string nationalIdentifier;
        string nationalIdentifierType;
        string[] banks;   
        string name;
        bool kycDone;
    
        }

        customer _customer;
        mapping(string=>customer) _customers;
        


      function addNewBank(string  memory name, address from) public isOwner
        {
            _bank.name=name;
            _bank.eth_address=from;
            _bank.kycCount=0;
            _bank.canAddCustomer=false;
            _bank.canKYC=false;
            _banks[from]=_bank;
        }

     function bankRoleUpdate (bool  canAddCustomer, bool  canKYC, address  bankID) public isOwner
     {

         _banks[bankID].canAddCustomer=canAddCustomer;
         _banks[bankID].canKYC=canKYC;
         

     }
    
     function addNewCustomerRequestForKYC(string memory nationalIdentifier, string memory nationalIdentifierType, string  memory name, address _addTobank) public
     {
         require(_banks[_addTobank].canKYC, "KYC not allowed by thid bank");
         _customer.nationalIdentifier=nationalIdentifier;
         _customer.nationalIdentifierType=nationalIdentifierType;
         _customer.name=name;
         _customer.kycDone=false;
         _customers[nationalIdentifier]=_customer;
    

     }
      function addNewCustomerToBank(string memory nationalIdentifier, address _addTobank) public
      {
          require(_banks[_addTobank].canAddCustomer, "This bank not allowed to add customer");
          require(_customers[nationalIdentifier].kycDone, "KYC not completed yet");
    
          _customers[nationalIdentifier].banks.push(_banks[_addTobank].name);


      }
     
     function getCustomerView(string memory nationalIdentifier) view public returns ( string memory,  string memory , string memory,bool, string[] memory)
      {
        
        return (_customers[nationalIdentifier].nationalIdentifier,_customers[nationalIdentifier].nationalIdentifierType,_customers[nationalIdentifier].name,_customers[nationalIdentifier].kycDone,_customers[nationalIdentifier].banks);


      }

      function completeKYC(string memory nantionalIdetifier, address fromBank) public
      {
          require(_banks[fromBank].canKYC,"KYC cannot be done by you");
          _customers[nantionalIdetifier].kycDone=true;
          _banks[fromBank].kycCount= _banks[fromBank].kycCount+1;

      }
 
     function checkKYCStatus(string memory nantionalIdetifier) view public returns (bool)
        {

            return(_customers[nantionalIdetifier].kycDone);

        }
    }
