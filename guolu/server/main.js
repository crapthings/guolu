import mosca from 'mosca'

const broker = new mosca.Server({
  port: 1883,
})

broker.on('clientConnected', function (client) {
  console.log('client connected', client.id)
})

// fired when a message is received
broker.on('published', function (packet, client) {
  console.log('Published', packet.payload)
})

broker.on('ready', setup)

function setup() {
  console.log('broker is up and running')
}


// observe

// var message = {
//   topic: '/hello/world',
//   payload: 'abcde', // or a Buffer
//   qos: 0, // 0, 1, or 2
//   retain: false // or true
// };

// server.publish(message, function() {
//   console.log('done!');
// });
