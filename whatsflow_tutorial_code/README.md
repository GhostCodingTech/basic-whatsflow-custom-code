For deploying the cloud function the following steps can be followed. 

You can use any IDE that you want for this. Whether Notepad++, Atom or VS Code. 
You will also need to make sure that you have nodejs installed on your machine before running these commands.
Nodejs can be found at: https://nodejs.org/en

Firebase cloud function

* Open CMD and navigate to Desktop
* Create folder
* npm init -y (for package.json file)
* npm i firebase-tools -D (install firebase tools specifically for development)
* npx firebase-tools --version (check firebase version)
* npx firebase-tools login (Login to firebase)
* npx firebase init functions (Setup firebase functions project and select which firebase project it needs to belong to)
* Add .env
* Add the following inside the .env file and don't forget to paste in your actual values from Agora. APP_ID =     &&    APP_CERTIFICATE = 
* Add "agora-access-token": "^2.0.0", to package.json
* cd functions (to navigate to functions directory and run npm install to install added packages)
* npm install (to install the agora_access-token package)
* npm install dotenv
* Add cloud function to index.js
* npx firebase deploy --only functions (to deploy to firebase)


Dart Code.

For the Voice Call Screen, you will need to add the following packages as dependencies before compiling the code. Make sure that you've turned on Microphone permissions in your application.
agora_rtc_engine: ^5.3.1
permission_handler: