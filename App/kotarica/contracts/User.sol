// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract UserCrud{

    struct User{

        uint id;
        string userName;
        bytes32 password;
        string firstName;
        string lastName;
        string mail;
        string mobile;
        string adresa;
    }
    
    struct UserPic{
        string username;
        string hash;
    }

    User[] public users;
    uint public nextId=0;
    uint[] pom;
    event postojeciKorisnik(uint idUsera);
    uint public picCount;
    mapping(uint => User) public korisnici;
    mapping(uint => UserPic) public pics;

    function encPass(string memory password) public pure returns(bytes32)
    {
        return sha256(abi.encodePacked(password));
    }


    //dodavanje korisnika
    function create(string memory userName, string memory password, string memory firstName, string memory lastName, string memory mail, string memory mobile, string memory
        adresa) public
    {
        nextId++;
        bytes32 pass = encPass(password);
        korisnici[nextId-1] = User(nextId,userName,pass,firstName,lastName,mail,mobile,adresa);
        //nextId++;
        users.push(User(nextId,userName,pass,firstName,lastName,mail,mobile,adresa));
    }


    constructor() public 
    {
    
    
      create("PeraPerica", "pera123", "Petar", "Petrovic", "pera@gmail.com", "0648963125", "Andrije Jevremovica 16, Zlatibor");
      create("MarkoMare", "mare123", "Marko", "Markovic", "marko@gmail.com", "0623396648", "Dragise Cvetkovica 22, Nis");
      create("Angelina23", "angel55", "Angelina", "Misic", "angelina97@gmail.com","066152006","Srpskih Rudara 33, Vranje");
      create("Magdalena75", "megi975", "Magdalena", "Novakovic", "megi755@gmail.com","0642985536", "Mite Kalica 39, Sombor");
      create("CikaMisa", "cika223", "Miodrag","Kojic", "cikamisa@gmail.com", "0641502256", "Rujanska 7, Cajetina");
      create("Secerlema", "sandra123", "Sandra", "Djoric", "secerlema@gmail.com", "0635562395", "Dragice Pravice 44, Zrenjanin");
      create("JagodicaBobica", "jagodica12", "Mirjana", "Kovic", "miramirka@gmail.com","0642345596", "Karadjordjeva 39, Vrbovac");
      create("DadiljaSljivka", "sljivka34", "Natasa", "Lazic", "natalaz@gmail.com", "0652245896", "Mladena Simica 13, Krusevac");
      create("Cvecarka77", "cvece777", "Ivana", "Jokic", "ivka@gmail.com", "0615632448", "Bartok Bele 14, Srbobran");
      create("BureBurence", "burad123", "Branko", "Tomic", "brane@gmail.com", "0692348861", "Nade Milutinovic 36, Aleksandrovac");
      create("PcelicaMaja", "bzbz333", "Marina", "Tosic", "mara@gmail.com", "0661493365", "Rudnicka 13, Kragujevac");

      nextId=11;
    }    

    function addPic(string memory username, string memory hash) public
    {
        pics[picCount++] = UserPic(username,hash); 
    }

    //izmena korisnika
    function updateUser(string memory oldUsername, string memory newPass,string memory firstName, string memory lastName, string memory newMob,string memory email, string memory newAdrr1) public {
        for(uint i=0; i < users.length; i++)
        {
            if(keccak256(abi.encodePacked(users[i].userName)) == keccak256(abi.encodePacked(oldUsername)))
            {
                if(keccak256(abi.encodePacked(firstName)) != keccak256(abi.encodePacked(""))){
                    //users[i].userName = newUserName;
                    korisnici[i].firstName = firstName; }
                    
                if(keccak256(abi.encodePacked(lastName)) != keccak256(abi.encodePacked("")))
                    korisnici[i].lastName = lastName;

                if(keccak256(abi.encodePacked(newPass)) != keccak256(abi.encodePacked("")))
                    korisnici[i].password = encPass(newPass);

                if(keccak256(abi.encodePacked(newMob)) != keccak256(abi.encodePacked("")))
                    korisnici[i].mobile = newMob;
                
                if(keccak256(abi.encodePacked(email)) != keccak256(abi.encodePacked("")))
                    korisnici[i].mail = email;

                if(keccak256(abi.encodePacked(newAdrr1)) != keccak256(abi.encodePacked("")))
                    korisnici[i].adresa = newAdrr1;

                //if(keccak256(abi.encodePacked(newAdrr2)) != keccak256(abi.encodePacked("")))
                //users[i].adressaSlanje = newAdrr2;
            }
        }

    }

   
    function isUserExists(string memory username) public view returns(bool) {
        for(uint i = 0; i < nextId; i++) {
            if(keccak256(abi.encodePacked(users[i].userName)) == keccak256(abi.encodePacked(username))) return true;
//            if(users[i].userName == username) return true;
        }
        return false;
    }
   

    function checkUser(string memory userName, string memory password) public view returns(string memory)
   {
       for(uint i=0;i<nextId;i++)
       {
           if(keccak256(abi.encodePacked(korisnici[i].userName)) == keccak256(abi.encodePacked(userName)))
           {
               if(keccak256(abi.encodePacked(korisnici[i].password)) == keccak256(abi.encodePacked(encPass(password))))
               {
                   return "Postoji i tacna lozinka";
               }
               else{
                   return "Netacna lozinka";
               }
           }
       }
       
       return "Ne postoji";
   }


    function deleteUser(uint i) public
    {
        //uint i = findUser(id);
        delete users[i];
    }

   
}
