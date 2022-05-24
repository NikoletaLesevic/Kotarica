const fs = require('fs');
const express = require('express');
const multer  = require('multer');
const app = express();
// const cors = require('cors');

// app.use(cors());

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  res.setHeader("Access-Control-Allow-Methods", "GET, POST");
  next();
});

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, './uploads');
  },
  filename: (req, file, cb) => {
    cb(null,Date.now() + file.originalname);
  }
})

const upload = multer({ storage: storage });



  

app.use('/uploads',express.static('uploads'));

app.post('/upload', upload.single('image'), function (req, res, next) {
    
    console.log(req.file);
    res.send(req.file.filename);
    
  })

app.listen(3000);