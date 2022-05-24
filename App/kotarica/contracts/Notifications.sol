// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract NotificationList {
    
    
    uint public countNotif;
    uint public countKupovine;
    uint public countWallets;
    
    struct Notification //spisak obavestenja 
    {
        uint id;
        string naslov;
        string sadrzaj;
        string odKoga;
        string zaKoga;
        string datum; //ako je klik na kupi, danasnji datum, ako je rezervisi, ide odabrani datum za rezervaciju
        uint kupljeno; //0 rezervacija, 1 kupovina pouzecem, 2 kupovina kriptovalutom 
        bool procitano;
    }
    
    struct Kupovina{ //moje kupovine 
        
        uint id;
        string usernameKupac;
        string adOwner;
        string adName;
        uint kupljeno; //ako je kupljeno 1, ako je rezervisano 0, 2 kupljeno kriptovalutom
        string datum;
        bool ocenjeno;
        bool komentarisano;
    }
    
    struct Wallet {
        string username;
        bool imaWallet;
        string publicKey;
    }
    
    
    mapping(uint => Notification) public obavestenja;
    mapping(uint => Kupovina) public kupovine;
    mapping(uint => Wallet) public wallets;
    
    function dodajObavestenje(string memory naslov, string memory sadrzaj,string memory odKoga,string memory zaKoga, string memory datum,uint kupljeno) public
    {
        obavestenja[countNotif++] = Notification(countNotif+1,naslov,sadrzaj,odKoga,zaKoga,datum,kupljeno,false);
    }
    
    
    function oznaciKaoProcitano(uint id) public
    {
        for(uint i=0;i<countNotif;i++)
        {
            if(obavestenja[i].id == id)
            {
             obavestenja[i].procitano=true;   
            }
        }
    }
    
    function kupiRezervisi(string memory usernameKupac, string memory adOwner, string memory adName, uint kupljeno, string memory datum) public //dodaje i kupljene i rezervisane
    {
        kupovine[countKupovine++] = Kupovina(countKupovine+1,usernameKupac,adOwner,adName,kupljeno,datum,false,false);
    }
    
    function prebaciRezervisanoUKupljeno(uint id) public // podrazumeva da se kupi kriptovalutom
    {
        for(uint i=0;i<countKupovine;i++)
        {
            if(kupovine[i].id == id)
            kupovine[i].kupljeno =2;
        }
    }

    function prebaciUOcenjeno(uint id) public
    {
        for(uint i=0;i<countKupovine;i++)
        {
            if(kupovine[i].id == id)
            kupovine[i].ocenjeno =true;
        }
    }

    function prebaciUKomentarisano(uint id) public
    {
        for(uint i=0;i<countKupovine;i++)
        {
            if(kupovine[i].id == id)
            kupovine[i].komentarisano =true;
        }
    }
    
    function createWallet(string memory username, bool imaWallet,string memory publicKey) public //proveravamo da li moze prodavac da stavi rezervaciju i kupovinu kriptovalutom
    {
        wallets[countWallets++] = Wallet(username,imaWallet,publicKey);
    }
    
    
    /*
    u modelu napraviti funkciju koja pri svakom logovanju proverava da li je datum rezervacije danasnji datum, ako jeste,
    skida novac sa racuna automatski i prebacuje u kupljeno
    
    */
    
}