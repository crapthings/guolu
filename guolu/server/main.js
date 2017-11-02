import mosca from 'mosca'

const broker = new mosca.Server({
  port: 1883,
})

broker.on('clientConnected', function (client) {
  console.log('client connected', client.id)
})

broker.on('published', function (packet, client) {
  console.log('Published', packet.payload)
})

broker.on('ready', setup)

function setup() {
  console.log('broker is up and running')
}

Meteor.methods({
  toggleNode(_id) {
    const { client, pin, toggle } = Nodes.findOne(_id)

    const message = {
      topic: `/${client}`,
      payload: `${pin},${toggle ? 1 : 0}`,
      qos: 0, // 0, 1, or 2
      retain: false // or true
    }

    broker.publish(message, Meteor.bindEnvironment(function() {
      Nodes.update(_id, {
        $set: { toggle: !toggle }
      })
    }))
  }
})
