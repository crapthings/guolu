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


setInterval(function () {
// observe

  var message = {
    topic: '/topic',
    payload: 'abcde', // or a Buffer
    qos: 0, // 0, 1, or 2
    retain: false // or true
  }

  broker.publish(message, function() {
    console.log('done!')
  })

}, 5000)
