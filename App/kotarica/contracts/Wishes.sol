// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract WishList{

    uint public wishCount;
    uint public oceneCount;

    struct Wish{
        string username;
        string adOwner;
        string adName;
        bool uListi;
    }

    struct OcenaOglasa{
        string adName;
        string adOwner;
        uint brojOcena;
        uint zbirOcena;
    }

    mapping(uint => Wish) public wishes;
    mapping(uint => OcenaOglasa) public ocene;


     function addToWishList(string memory username, string memory adOwner, string memory adName) public 
    {
        wishes[wishCount++] = Wish(username,adOwner,adName,true);
    }

     function removeFromWishList(string memory username, string memory adOwner, string memory adName) public
    {
        for(uint i=0;i<wishCount;i++)
        {
            if(keccak256(abi.encodePacked(wishes[i].username)) == keccak256(abi.encodePacked(username)))
            {
                if(keccak256(abi.encodePacked(wishes[i].adOwner)) == keccak256(abi.encodePacked(adOwner)))
                {
                    if(keccak256(abi.encodePacked(wishes[i].adName)) == keccak256(abi.encodePacked(adName)))
                    {
                        if(wishes[i].uListi == true)
                        wishes[i].uListi = false;
                        else 
                        wishes[i].uListi = true;
                    }
                }
            }
        }
    }
    

    function dodeliOcenu(string memory adOwner, string memory adName, uint ocena) public 
    {
        bool nadjen = false;
        
        for(uint i=0; i<oceneCount;i++)
        {
            if(keccak256(abi.encodePacked(ocene[i].adName)) == keccak256(abi.encodePacked(adName))) //ako je vec ocenjivan
            {
                if(keccak256(abi.encodePacked(ocene[i].adOwner)) == keccak256(abi.encodePacked(adOwner)))
                {
                    ocene[i].brojOcena++;
                    ocene[i].zbirOcena += ocena;
                    nadjen = true;
                    
                }
            }
        }
        
        if(keccak256(abi.encodePacked(nadjen)) == keccak256(abi.encodePacked(false))) //ako oglas nije ocenjivan
         ocene[oceneCount++] = OcenaOglasa(adName, adOwner,1,ocena);
        
    }
}

