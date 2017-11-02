Nodes = new Mongo.Collection('nodes')

if (Meteor.isServer) {
  Meteor.publish('nodes', function () {
    return Nodes.find()
  })

  if (! Nodes.findOne()) {
    _.times(8, n => {
      Nodes.insert({ pin: n, client: 'node1', })
    })
  }

}
