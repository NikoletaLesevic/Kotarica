# kotarica


Uputstvo za pokretanje projekta:
-potrebno je imati instaliran truffle(zahteva node.js) i ganache
-klonirati projekat kod sebe
-pokrenuti ganache(namestiti url ukoliko je potrebno)
-podesiti u svim modelima(AdModel, UserModel...) rpcUrl i wsUrl na odgovarajuci url(
    ukoliko se pokrece putem browsera-localhost,
    na telefonu - odgovarajuca WiFi mreza)
-podesiti private key u svim modelima (prekopirati sa ganache)
-obrisati gitkeep iz src/abis (zna da pravi gresku prilikom migriranja)
-izvrsiti migracije (truffle migrate -reset)
-pokernuti app.js fajl u folderu server
-za kreiranje baze za komentare potrebno je pokrenuti Command Prompt
-izvrsiti komandu 'sqllocaldb create TechLab', a zatim 'sqllocaldb start TechLab'
-pokrenuti SQL Server Managment Studio i izvrsiti upit koji se nalazi u fajlu sqlUpit.txt (TechLab\App\ChatBackend\sqlUpitKomentari.txt)
-U fajlu appsettings.json promeniti konekcioni string
-U package manager konzoli odrediti Add-Migration <naziv migracije>, pa zatim Update-Database
-koristeci Visual Studio potrebno je pokrenuti projekat ChatBackend (TechLab\App\ChatBackend\ChatBackend.sln)
-pokrenuti aplikaciju

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
