// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./User.sol";

contract AdList {
    uint public adCount;
    uint public slikeCount;

    struct Ad {
        string name;
        string category;
        string description;
        string price;
        string contact;
        string korisnik;
        string picHash;
    }
    
     struct Slika{
        string adName;
        string adOwner;
        string hash;
    }


    mapping(uint => Ad) public ads;
    mapping(uint => Slika) public slike;
    

    event AdCreated(string adName, uint adNumber);
    
    constructor() public {

        ads[0] = Ad("Hortenzije", "Cvece", "Sadnice stare 2 godine, vise boja", "800", "0615632448", "Cvecarka77","1620662392243image1.png");
        ads[1] = Ad("Svez med", "Med", "Domaci med, bagremov, livadski, sumski", "700", "0661493365", "PcelicaMaja","1620662425120image2.png");
        ads[2] = Ad("Posni kolaci","Slatkisi","Sitni kolaci, idealni za proslave, 7 vrsta,  cena po kg","800","0635562395","Secerlema","1620662432563image3.png");
        ads[3] = Ad("Patuljaste ruze", "Cvece", "Sadnice patuljastih ruza, vise boja", "500", "0615632448", "Cvecarka77","1620662441023image4.png");
        ads[4] = Ad("Merlot vino 2L","Vino","Najkvalitetnije u Srbiji, punog ukusa","300","0692348861","BureBurence","1620662448753image5.png");
        ads[5] = Ad("Domaci cvarci","Meso i mesne preradjevine","Hrskavi,domaci cvarci 550din/kg","550","0641502256","CikaMisa","1620662457917image6.png");
        ads[6] = Ad("Tamjanika vino 2L","Vino","Provereno najkvalitetnije belo vino u Srbiji, punog ukusa","400","0692348861","BureBurence","1620662466427image7.png");
        ads[7] = Ad("Sljivovica 1L","Rakija","Pitka, ostra, domaca rakija od sljive, 500din/l","500","0652245896","DadiljaSljivka","1620662473403image8.png");
        ads[8] = Ad("Tamjanika vino 5L","Vino","Provereno najkvalitetnije belo vino u Srbiji, punog ukusa","1000","0692348861","BureBurence","1620662482226image9.png");
        ads[9] = Ad("Jagode","Voce","Neprskane, sveze, 200din/kg","200","0642345596","JagodicaBobica","1620662497470image10.png");
        ads[10] = Ad("Dzem od sljiva","Dzem","Najukusniji dzem od sljiva 350din/kg","350","0652245896","DadiljaSljivka","1620662509004image11.png");
        ads[11] = Ad("Maline","Voce","Neprskane, sveze, 250din/kg","250","0642345596","JagodicaBobica","1620662517508image12.png");
        ads[12] = Ad("Kravlji sir","Mleko i mlecni proizvodi","Domaci kravlji sir, 500din/kg","500","0648963125","PeraPerica","1620662528066image13.png");
        ads[13] = Ad("Kupine","Voce","Neprskane, sveze, 270din/kg","270","0642345596","JagodicaBobica","1620662539633image14.png");
        ads[14] = Ad("Borovnice","Voce","Neprskane, sveze, 300din/kg","300","0642345596","JagodicaBobica","1620662548854image15.png");
        ads[15] = Ad("Domaci kajmak","Mleko i mlecni proizvodi","Domaci kravlji kajmak, 800din/kg","800","0648963125","PeraPerica","1620662557303image16.png");
        ads[16] = Ad("Sljive","Voce","Neprskane,sveze,krupne,55din/kg","55","0652245896","DadiljaSljivka","1620662566178image17.png");
        ads[17] = Ad("Slatko od sljiva","Namaza","Preukusno, domace slatko od sljiva, tegle po 1kg","500","0652245896","DadiljaSljivka","1620662573795image18.png");
        ads[18] = Ad("Kravlje mleko","Mleko i mlecni proizvodi","Domace kravlje mleko u staklenoj ambalazi 1L","200","0648963125","PeraPerica","1620662581136image19.png");
        ads[19] = Ad("Suva pecenica","Meso i mesne preradjevine","Suva pecenica od najkvalitetnijeg mesa, 1500din/kg","1500","0641502256","CikaMisa","1620662593626image20.png");

        adCount = 20;
    }


    function createAd(string memory _name, string memory _category, string memory _description, string memory _price, string memory _contact, string memory _user, string memory pic, address userCrudAdrdess)
    public {
        UserCrud uc = UserCrud(userCrudAdrdess);
        if(uc.isUserExists(_user)) {
            ads[adCount++] =Ad(_name, _category, _description, _price, _contact, _user,pic);
        }

//        emit AdCreated(_name, adCount - 1);
    }

    function removeAd(string memory _name, string memory _user) public 
    {
        for(uint i=0;i<adCount;i++)
        {
            if(keccak256(abi.encodePacked(ads[i].name)) == keccak256(abi.encodePacked(_name)))
            {
                if(keccak256(abi.encodePacked(ads[i].korisnik)) == keccak256(abi.encodePacked(_user)))   
                {
                    ads[i].name = "obrisan";
                }
            }
        }
    }

    function addPic(string memory adName, string  memory adOwner, string memory hash) public
    {
        slike[slikeCount++] = Slika(adName,adOwner,hash);
    }
   



}
//contract UserCrud {
//    function isUserExists(string memory username) public returns(bool);
//}