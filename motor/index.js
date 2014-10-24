//~ var bytes_send = new Uint8Array(20);

var L1L = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x30,0x04,0xA9]);
var L1H = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x30,0x05,0xA8]);
var L2L = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x31,0x04,0xA8]);
var L2H = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x31,0x05,0xA7]);
var L3L = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x32,0x04,0xA7]);
var L3H = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x32,0x05,0xA6]);
var L4L = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x33,0x04,0xA6]);
var L4H = new Uint8Array([0x7E,0x00,0x10,0x17,0x05,0x00,0x13,0xA2,0x00,0x40,0x67,0x4D,0x1A,0xFF,0xFE,0x02,0x44,0x33,0x05,0xA5]);

var GetMotorStatus = new Uint8Array([0x4D]);
var GetTimeStamp   = new Uint8Array([0x54]);
var MinPlus        = new Uint8Array([0x3E]);
var MinMinus       = new Uint8Array([0x3C]);
var MinStart       = new Uint8Array([0x5E]);
var ManualStart    = new Uint8Array([0x2F]);
var ManualStop     = new Uint8Array([0x5C]);
var GetGLevel      = new Uint8Array([0x5B]);
var GetHLevel      = new Uint8Array([0x5D]);
var StartAuto      = new Uint8Array([0x23]);

var switchStatus = {
						L1 : 'L1L',
						L2 : 'L2L',
						L3 : 'L3L',
						L4 : 'L4L',
						LED22 : 'LED22L'
					};


var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var sp = require("serialport");
var motor = require("serialport");
var gpio = require("pi-gpio");
//~ var schedule = require('node-schedule');

//init for SerialPort connected to Arduino
var SerialPort = sp.SerialPort
var serialPort = new SerialPort('/dev/ttyUSB0', 
    {   baudrate: 9600,
        dataBits: 8,
        parity: 'none',
        stopBits: 1,
        flowControl: false
    });

serialPort.on("open", function () {
    console.log('serialPort open');
});

//init for SerialPort connected to Arduino
var MotorPort = motor.SerialPort
var motorPort = new MotorPort('/dev/ttyAMA0', 
    {   baudrate: 9600,
        dataBits: 8,
        parity: 'none',
        stopBits: 1,
        flowControl: false,
        parser: motor.parsers.readline("\n")
    });

motorPort.on("open", function () {
    console.log('motorPort open');
    motorPort.on('data', function(data) {
      console.log('Motor says: ' + data);
      io.emit('motor message',data);
    });
});


//~ setInterval(function(){
	 //~ motorPort.write(GetGLevel,function(){console.log('Glevel Requested');});
//~ },4000);
//~ setInterval(function(){
	 //~ motorPort.write(GetHLevel,function(){console.log('Glevel Requested');});
//~ },4000);




gpio.open(22, "output", function(err) {        // Open pin 16 for output
    console.log('gpio open');
});

app.get('/', function(req, res){
  res.sendfile('index.html');
});


app.get('/control/L1L', function(req, res){
  res.send('Done');
  var msg = 'L1L';
  serialPort.write(L1L,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L1=msg});
});
app.get('/control/L1H', function(req, res){
  res.send('Done');
  var msg = 'L1H';
  serialPort.write(L1H,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L1=msg});
});
app.get('/control/L2L', function(req, res){
  res.send('Done');
  var msg = 'L2L';
  serialPort.write(L2L,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L2=msg});
});
app.get('/control/L2H', function(req, res){
  res.send('Done');
  var msg = 'L2H';
  serialPort.write(L2H,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L2=msg});
});
app.get('/control/L3L', function(req, res){
  res.send('Done');
  var msg = 'L3L';
  serialPort.write(L3L,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L3=msg});
});
app.get('/control/L3H', function(req, res){
  res.send('Done');
  var msg = 'L3H';
  serialPort.write(L3H,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L3=msg});
});
app.get('/control/L4L', function(req, res){
  res.send('Done');
  var msg = 'L4L';
  serialPort.write(L4L,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L4=msg});
});
app.get('/control/L4H', function(req, res){
  res.send('Done');
  var msg = 'L4H';
  serialPort.write(L4H,function(){console.log('REST: sent ' + msg);io.emit('control message',msg);switchStatus.L4=msg});
});
app.get('/control/LED22H', function(req, res){
  res.send('Done');
  var msg = 'LED22H';
  gpio.write(22, 1, function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.LED22=msg});
});
app.get('/control/LED22L', function(req, res){
  res.send('Done');
  var msg = 'LED22L';
  gpio.write(22, 0, function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.LED22=msg});
});


io.on('connection', function(socket){
  socket.on('chat message', function(msg){
    io.emit('chat message', msg);
    console.log(msg);
  
  });
  socket.on('control message', function(msg){
	  switch(msg)
	  {
		  case 'L1L':
			serialPort.write(L1L,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L1=msg});
			break;
		  case 'L2L':
			serialPort.write(L2L,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L2=msg});
			break;
		  case 'L3L':
			serialPort.write(L3L,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L3=msg});
			break;
		  case 'L4L':
			serialPort.write(L4L,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L4=msg});
			break;
			
		  case 'L1H':
			serialPort.write(L1H,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L1=msg});
			break;
		  case 'L2H':
			serialPort.write(L2H,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L2=msg});
			break;
		  case 'L3H':
			serialPort.write(L3H,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L3=msg});
			break;
		  case 'L4H':
			serialPort.write(L4H,function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.L4=msg});
			break;
			
		  case 'LED22H':
			gpio.write(22, 1, function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.LED22=msg});
			break;
		  case 'LED22L':
			gpio.write(22, 0, function(){console.log('SOCKET: sent ' + msg);io.emit('control message',msg);switchStatus.LED22=msg});
			break;
			
			
		  case 'GETALL':
			console.log('SOCKET: sent ' + msg);
			io.emit('control message',switchStatus.L1);
			io.emit('control message',switchStatus.L2);
			io.emit('control message',switchStatus.L3);
			io.emit('control message',switchStatus.L4);
			io.emit('control message',switchStatus.LED22);
			break;

		  default:
			break;
			
	  }
  	
  });
  socket.on('motor message', function(msg){
	  switch(msg)
	  {
		  motorPort.write(msg,function(){});
	  }
  });

});

http.listen(3000, function(){
  console.log('listening on *:3000');
});

/*--------------------- Time Scheduling For Switches ------------------*/
/*
var L4ON = schedule.scheduleJob({hour: 13, minute: 30}, function(){
	var msg = 'L4H';
    serialPort.write(L4H,function(){
		console.log('TIMER: ' + msg);
		io.emit('control message',msg);
		switchStatus.L4=msg
		});
});
var L4OFF = schedule.scheduleJob({hour: 16, minute: 50}, function(){
	var msg = 'L4L';
    serialPort.write(L4L,function(){
		console.log('TIMER: ' + msg);
		io.emit('control message',msg);
		switchStatus.L4=msg
		});
});
*/
